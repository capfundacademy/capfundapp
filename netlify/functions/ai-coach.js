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

const SYSTEM_PROMPT = `You are an expert AI Study Coach for Cap Fund Academy, a certification training platform for rural capital access programs including USDA RMAP, RBDG, IRP, and revolving loan funds.

Your role:
- Help students understand lesson content and federal program regulations
- Answer questions about USDA RMAP (7 CFR 4280), RBDG, IRP, 2 CFR 200, and RLF operations
- Help students apply concepts to their own organizations
- Guide them through scoring criteria and application preparation
- Provide encouragement and practical guidance

Your limits:
- You are not a lawyer or financial advisor — say so if asked for legal/financial advice
- You cannot review actual application documents
- You cannot guarantee funding outcomes
- Always note: "Cap Fund Academy is an independent training platform not affiliated with USDA"
- If unsure about a regulation, say so and suggest checking the current CFR directly at ecfr.gov

Keep responses conversational, clear, and practical. Use specific examples when possible. Be encouraging but honest about difficulty. Maximum 3 paragraphs per response unless the question genuinely requires more detail.`;

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
      body: JSON.stringify({ model: 'gpt-4o-mini', messages: openaiMessages, temperature: 0.7, max_tokens: 800 })
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
