// ============================================================================
// ai-coach.js — AI Study Coach for DWY members
// Auth: requires valid Supabase JWT + coach_access = true on profile
// Rate limit: 50 messages per user per day
// ============================================================================

const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL         = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const OPENAI_API_KEY       = process.env.OPENAI_API_KEY;

const CORS = {
  'Access-Control-Allow-Origin':  '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
};
const ok  = (b) => ({ statusCode: 200, headers: { ...CORS, 'Content-Type': 'application/json' }, body: JSON.stringify(b) });
const err = (s, m) => ({ statusCode: s, headers: { ...CORS, 'Content-Type': 'application/json' }, body: JSON.stringify({ error: m }) });

const SYSTEM_PROMPT = `You are an expert AI Study Coach for Cap Fund Academy — a certification training platform for rural nonprofits, CDFIs, and community lenders working with USDA rural capital programs.

## Your expertise covers:
- **USDA RMAP** (Rural Microentrepreneur Assistance Program) — 7 CFR Part 4280 Subpart D. Eligibility, application, scoring rubric (125 points across 5 categories), RMRF/LLRF account requirements, TA&T programs, quarterly reporting, site visits.
- **USDA RBDG** (Rural Business Development Grant) — 7 CFR Part 4280 Subpart E. Eligible applicants, RLF establishment, project types, scoring criteria, leverage requirements, post-award compliance.
- **IRP** (Intermediary Relending Program) — 7 U.S.C. 1932(b). 1% fixed rate, 30-year terms, eligibility, how IRP fits in a capital stack after RBDG and RMAP.
- **Revolving Loan Funds** — Fund design, capitalization, governance, loan committee structure, written loan policy requirements, underwriting standards, RMRF/LLRF controls.
- **Federal Compliance** — 2 CFR 200 Uniform Guidance (allowable costs, procurement, record retention, single audit), civil rights (ECOA, Title VI, ADA, Section 504), environmental review (NEPA, Phase I ESA), SAM.gov/UEI, debarment.
- **RLF Accounting** — Restricted fund accounting, program income allocation, LLRF reserve calculation (≥5% of outstanding RMAP principal), quarterly USDA reports, SF-270 drawdowns, single audit preparation.
- **Underwriting** — Cash flow analysis, global debt service, collateral, the 6 Cs of credit, loan committee decisions, adverse action notices under ECOA.
- **Loan Servicing** — Payment processing, delinquency monitoring (PAR 30/60/90), collections, workouts, charge-off procedures, USDA reporting for defaults.
- **Application Assembly** — Evidence crosswalk methodology, reviewer-centered packet assembly, narrative strengthening (metrics-dates-capacity framework), AI scoring interpretation.

## How you respond:
- Be the knowledgeable colleague who's read the actual regulations — cite specific CFR sections (e.g., "7 CFR 4280.316") when answering regulatory questions.
- Give direct, actionable answers. If a student asks "what goes in a RMAP loan policy," give them the actual list from 7 CFR 4280.315.
- When students share their organization's situation, apply the concepts specifically to their context.
- Use plain language first, regulatory precision second — not the other way around.
- If you give a number (e.g., "5% LLRF requirement"), cite the source regulation.
- For application strategy questions, help them prioritize by point value in the scoring rubric.
- Keep responses focused: lead with the direct answer, then explain. Avoid lengthy preambles.

## Hard limits:
- Never give legal advice, tax advice, or financial advice. If asked, say: "I'd recommend consulting a licensed attorney for that specific question."
- Never guarantee funding, eligibility, or USDA approval outcomes.
- Never imply Cap Fund Academy is affiliated with, endorsed by, or certified by USDA.
- If uncertain about a specific regulatory detail, say so and direct to ecfr.gov for the current text.
- Do not review or score actual application documents submitted to USDA — use the Cap Fund Academy AI Scoring tool in the application workspace for that.

## Tone:
Expert, direct, warm. Like the most helpful person in the room at a USDA rural development conference — not a chatbot, not a professor. A practitioner who knows this material cold and genuinely wants the student to succeed.`;

exports.handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') return { statusCode: 204, headers: CORS, body: '' };
  if (event.httpMethod !== 'POST')    return err(405, 'Method not allowed');
  if (!OPENAI_API_KEY)                return err(503, 'AI coach not configured');

  const authHeader = event.headers.authorization || event.headers.Authorization;
  if (!authHeader?.startsWith('Bearer ')) return err(401, 'Missing bearer token');

  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false }
  });

  const { data: userData, error: userErr } = await admin.auth.getUser(authHeader.slice(7));
  if (userErr || !userData?.user) return err(401, 'Invalid session');
  const userId = userData.user.id;

  // Verify coach access
  const { data: prof } = await admin.from('profiles').select('coach_access, role').eq('id', userId).maybeSingle();
  const hasAccess = prof?.coach_access === true || ['super_admin', 'admin'].includes(prof?.role);
  if (!hasAccess) return err(403, 'AI Study Coach is available exclusively for Done-With-You members. Upgrade at capfundacademy.com.');

  // Rate limit: 50 messages per user per 24 hours
  const oneDayAgo = new Date(Date.now() - 86400000).toISOString();
  const { count } = await admin.from('email_sends')
    .select('*', { count: 'exact', head: true })
    .eq('to_email', `coach:${userId}`)
    .gte('sent_at', oneDayAgo);
  if ((count || 0) >= 50) return err(429, 'Daily message limit reached (50 messages/day). Resets at midnight UTC.');

  let body;
  try { body = JSON.parse(event.body || '{}'); }
  catch { return err(400, 'Invalid JSON'); }

  const { messages, context } = body;
  if (!messages?.length) return err(400, 'messages required');

  // Build OpenAI messages
  const systemContent = context ? `${SYSTEM_PROMPT}\n\nCurrent context: ${context}` : SYSTEM_PROMPT;
  const openaiMessages = [
    { role: 'system', content: systemContent },
    ...messages.slice(-10).map(m => ({ role: m.role, content: m.content })) // last 10 for context window
  ];

  try {
    const res = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${OPENAI_API_KEY}` },
      body: JSON.stringify({ model: 'gpt-4o', messages: openaiMessages, temperature: 0.65, max_tokens: 1200 })
    });
    if (!res.ok) { const t = await res.text(); throw new Error(`OpenAI error: ${t}`); }
    const data = await res.json();
    const answer = data.choices?.[0]?.message?.content || 'I had trouble generating a response. Please try again.';

    // Log usage (reuse email_sends table with coach: prefix to avoid a new table)
    await admin.from('email_sends').insert({ to_email: `coach:${userId}`, subject: 'coach_message', status: 'sent', sent_at: new Date().toISOString() });

    return ok({ answer, tokens: data.usage });
  } catch (e) {
    console.error('ai-coach error:', e.message);
    return err(500, 'Coach response failed: ' + e.message);
  }
};
