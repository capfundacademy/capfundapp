// ============================================================================
// content-generate.js — AI content generation with compliance checking
// Auth: admin only
// Rate limit: 20 generations per hour per user
// All OpenAI calls server-side only
// ============================================================================

const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL         = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const OPENAI_API_KEY       = process.env.OPENAI_API_KEY;
const MODEL                = 'gpt-4o-mini';

const CORS = {
  'Access-Control-Allow-Origin':  '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
};
const ok  = (b) => ({ statusCode: 200, headers: { ...CORS, 'Content-Type': 'application/json' }, body: JSON.stringify(b) });
const err = (s, m) => ({ statusCode: s, headers: { ...CORS, 'Content-Type': 'application/json' }, body: JSON.stringify({ error: m }) });

const DISCLAIMER = '\n\n⚠️ Cap Fund Academy is an independent training platform not affiliated with, endorsed by, or certified by USDA or any government agency. Training is educational only and does not guarantee funding, eligibility, or approval.';

const PLATFORM_SPECS = {
  linkedin:          { maxChars: 3000, format: 'professional LinkedIn post with line breaks, no hashtag spam (max 3)', tone: 'thought leadership' },
  facebook:          { maxChars: 1200, format: 'engaging Facebook post, conversational, can include a question', tone: 'accessible and encouraging' },
  instagram:         { maxChars: 500,  format: 'punchy Instagram caption with 5-8 relevant hashtags at the end', tone: 'motivational and visual' },
  tiktok_script:     { maxChars: 300,  format: '60-second TikTok/Reels script with hook, content, and CTA sections labeled', tone: 'energetic and educational' },
  email_newsletter:  { maxChars: 5000, format: 'HTML email newsletter with subject line on first line, then body', tone: 'professional and helpful' },
  blog:              { maxChars: 8000, format: 'SEO blog post with H2 headings, introduction, and conclusion', tone: 'authoritative and educational' },
  ad_copy:           { maxChars: 500,  format: 'paid ad copy with Headline (max 40 chars), Body (max 90 chars), CTA labeled separately', tone: 'direct and benefit-focused' },
  seo_meta:          { maxChars: 300,  format: 'SEO meta: first line is title (max 60 chars), second line is description (max 160 chars)', tone: 'clear and keyword-rich' },
};

function buildPrompt(platform, contentType, topic, audience, keyMessages, tone, additionalContext) {
  const spec = PLATFORM_SPECS[platform] || PLATFORM_SPECS.linkedin;
  return `You are a content writer for Cap Fund Academy, an independent certification platform for rural capital access, microfinance, and USDA program readiness training.

BRAND VOICE:
- Tone: ${tone}
- Audience: ${audience}
- Key messages: ${keyMessages.join('; ')}

PLATFORM: ${platform.toUpperCase()}
FORMAT: ${spec.format}
MAX LENGTH: ${spec.maxChars} characters
TONE: ${spec.tone}

TOPIC: ${topic}
${additionalContext ? `ADDITIONAL CONTEXT: ${additionalContext}` : ''}

CRITICAL COMPLIANCE RULES — violating these means the content cannot be published:
1. NEVER say "USDA-certified", "USDA-approved", "USDA-endorsed", or "certified by USDA"
2. NEVER imply that training guarantees funding, approval, or eligibility
3. ALWAYS position Cap Fund Academy as an independent educational platform
4. If mentioning USDA programs, describe them accurately without implying affiliation
5. Never use phrases like "guaranteed funding", "ensure you get funded", "proven funding results"

Generate the content now. Output only the content itself, no preamble or explanation.`;
}

function checkCompliance(content, forbiddenPhrases) {
  const flags = [];
  const contentLower = content.toLowerCase();
  for (const item of forbiddenPhrases) {
    if (contentLower.includes(item.phrase.toLowerCase())) {
      flags.push({ phrase: item.phrase, reason: item.reason, severity: item.severity });
    }
  }
  return flags;
}

exports.handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') return { statusCode: 204, headers: CORS, body: '' };
  if (event.httpMethod !== 'POST')    return err(405, 'Method not allowed');

  if (!OPENAI_API_KEY) return err(503, 'AI content generation not configured');

  const authHeader = event.headers.authorization || event.headers.Authorization;
  if (!authHeader?.startsWith('Bearer ')) return err(401, 'Missing bearer token');

  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false }
  });

  const { data: userData, error: userErr } = await admin.auth.getUser(authHeader.slice(7));
  if (userErr || !userData?.user) return err(401, 'Invalid session');
  const userId = userData.user.id;

  const { data: requester } = await admin.from('profiles').select('role').eq('id', userId).maybeSingle();
  if (!['super_admin','admin'].includes(requester?.role)) return err(403, 'Admin access required');

  // Rate limit: 20 generations per hour
  const oneHourAgo = new Date(Date.now() - 3600000).toISOString();
  const { count } = await admin.from('social_posts').select('*', { count: 'exact', head: true })
    .eq('created_by', userId).eq('ai_generated', true).gte('created_at', oneHourAgo);
  if ((count || 0) >= 20) return err(429, 'Rate limit: 20 AI generations per hour');

  let body;
  try { body = JSON.parse(event.body || '{}'); }
  catch { return err(400, 'Invalid JSON'); }

  const { platform, content_type, topic, additional_context, campaign_id, save = true } = body;
  if (!platform || !topic) return err(400, 'platform and topic required');

  // Load brand voice + forbidden claims
  const [{ data: bvs }, { data: claims }] = await Promise.all([
    admin.from('brand_voice_settings').select('*').limit(1).maybeSingle(),
    admin.from('forbidden_claims').select('*').eq('is_active', true)
  ]);

  const tone       = bvs?.tone       || 'professional, trustworthy, accessible';
  const audience   = bvs?.audience   || 'nonprofits and rural development organizations';
  const keyMessages = bvs?.key_messages || [];
  const autopilot  = bvs?.autopilot_level || 'approval_required';

  const prompt = buildPrompt(platform, content_type, topic, audience, keyMessages, tone, additional_context);

  // Call OpenAI
  const aiRes = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${OPENAI_API_KEY}` },
    body: JSON.stringify({ model: MODEL, messages: [{ role: 'user', content: prompt }], temperature: 0.7, max_tokens: 2000 })
  });

  if (!aiRes.ok) { const t = await aiRes.text(); return err(502, `OpenAI error: ${t}`); }
  const aiData = await aiRes.json();
  let generatedContent = aiData.choices?.[0]?.message?.content || '';

  // Compliance check
  const complianceFlags = checkCompliance(generatedContent, claims || []);
  const blockingFlags   = complianceFlags.filter(f => f.severity === 'block');
  const compliancePassed = blockingFlags.length === 0;

  // Determine status based on autopilot level
  let status = 'draft';
  if (compliancePassed) {
    if (autopilot === 'preapproved') status = 'approved';
    else if (autopilot === 'approval_required') status = 'review';
    else status = 'draft';
  } else {
    status = 'draft'; // always draft if compliance failed
  }

  let savedPost = null;
  if (save && compliancePassed) {
    const { data: post } = await admin.from('social_posts').insert({
      created_by: userId,
      platform,
      content_type: content_type || 'post',
      body: generatedContent,
      status,
      compliance_flags: complianceFlags,
      compliance_passed: compliancePassed,
      ai_generated: true,
      campaign_id: campaign_id || null,
    }).select().single();
    savedPost = post;
  }

  return ok({
    content: generatedContent,
    compliance: { passed: compliancePassed, flags: complianceFlags },
    status,
    autopilot_level: autopilot,
    post_id: savedPost?.id || null,
    needs_review: status === 'review',
    message: !compliancePassed
      ? `Content blocked: contains ${blockingFlags.length} forbidden claim(s). Review and regenerate.`
      : status === 'review' ? 'Content generated and queued for approval.'
      : status === 'approved' ? 'Content auto-approved (preapproved autopilot).'
      : 'Content saved as draft.'
  });
};
