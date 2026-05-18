// ============================================================================
// ai-scoring.js — RMAP/RBDG/IRP AI readiness scoring engine
// Auth: requires valid Supabase JWT
// Rate limit: 5 scoring runs per user per hour
// All OpenAI calls server-side only — key never exposed to client
// ============================================================================

const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL         = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const OPENAI_API_KEY       = process.env.OPENAI_API_KEY;
const MODEL_DEFAULT        = 'gpt-4o-mini';

const CORS = {
  'Access-Control-Allow-Origin':  '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
};

const ok  = (b) => ({ statusCode: 200, headers: { ...CORS, 'Content-Type': 'application/json' }, body: JSON.stringify(b) });
const err = (s, m) => ({ statusCode: s, headers: { ...CORS, 'Content-Type': 'application/json' }, body: JSON.stringify({ error: m }) });

const AI_DISCLAIMER = 'AI scoring outputs are estimates based on publicly available USDA scoring criteria. Results are advisory only and do not represent USDA\'s review or determination. Cap Fund Academy is not affiliated with, endorsed by, or certified by USDA or any government agency. These results do not guarantee funding, eligibility, approval, or award decisions.';

function buildPrompt(programType, criteria, answers, evidenceList, context) {
  const criteriaText = criteria.map(c =>
    `[${c.criterion_code}] ${c.criterion_label} (max ${c.max_points} pts, section ${c.section_code})\n` +
    `Description: ${c.description}\n` +
    `Evidence needed: ${c.evidence_hint || 'See description'}\n` +
    `Applicant answer: ${answers[c.id] || '(not provided)'}\n` +
    `Point bands: ${JSON.stringify(c.point_bands)}`
  ).join('\n\n');

  const evidenceText = evidenceList.length
    ? evidenceList.map(e => `- ${e.label || e.file_name}`).join('\n')
    : '(No evidence files uploaded yet)';

  const programLabels = {
    rmap: 'USDA Rural Microentrepreneur Assistance Program (RMAP) — 7 CFR 4280.316',
    rbdg: 'USDA Rural Business Development Grant (RBDG) — 7 CFR 4280 Subpart E',
    irp:  'USDA Intermediary Relending Program (IRP)',
    rlf_ops: 'Revolving Loan Fund Operational Readiness Review',
    legal_ogc: 'Legal/OGC Readiness Review',
    full_binder: 'Full Application Binder Gap Analysis',
  };

  return `You are an expert in USDA rural capital access programs with deep knowledge of ${programLabels[programType] || programType} application scoring.

A rural organization is preparing their application. Analyze their responses against the exact scoring criteria below and provide a structured assessment.

CRITICAL RULES:
- Base scores strictly on the criteria descriptions and point bands provided
- Be honest about weaknesses — do not inflate scores
- Every output must note that results are advisory only, not USDA's determination
- Never suggest the applicant is guaranteed to receive funding
- If information is missing, flag it clearly as a gap

PROGRAM: ${programLabels[programType] || programType}

ADDITIONAL CONTEXT FROM APPLICANT:
${context || '(None provided)'}

UPLOADED EVIDENCE FILES:
${evidenceText}

SCORING CRITERIA AND APPLICANT RESPONSES:
${criteriaText}

Respond with a JSON object exactly matching this schema:
{
  "program_type": "${programType}",
  "total_score_estimate": <integer — sum of estimated points>,
  "max_possible_score": <integer — sum of max points for all criteria>,
  "readiness_level": <"not_ready"|"emerging"|"competitive"|"strong"|"submission_ready">,
  "section_scores": {
    "<section_code>": {
      "label": "<section label>",
      "score": <integer>,
      "max": <integer>,
      "pct": <integer 0-100>
    }
  },
  "criterion_scores": {
    "<criterion_code>": {
      "score": <integer>,
      "max": <integer>,
      "rationale": "<1-2 sentence explanation>"
    }
  },
  "strengths": ["<specific strength>", ...],
  "weaknesses": ["<specific weakness>", ...],
  "missing_evidence": ["<document or data that is absent>", ...],
  "risk_flags": ["<compliance or scoring risk>", ...],
  "recommended_actions": ["<specific, actionable step>", ...],
  "plain_english_summary": "<2-3 paragraph plain language assessment suitable for a nonprofit leader without federal grant experience>",
  "evidence_checklist": [
    {"item": "<document name>", "status": "present|missing|partial", "priority": "critical|high|medium|low"}
  ],
  "priority_fix_list": [
    {"action": "<specific action>", "impact_points": <integer>, "effort": "low|medium|high"}
  ],
  "readiness_level_explanation": "<one sentence explaining why this readiness level was assigned>"
}

Readiness level guidance:
- not_ready: score <40% of max, critical gaps
- emerging: 40-59% of max, significant work needed
- competitive: 60-74% of max, viable with improvements
- strong: 75-84% of max, well-prepared
- submission_ready: 85%+ of max, ready to submit

Return only the JSON object. No markdown, no preamble.`;
}

async function callOpenAI(prompt, model) {
  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${OPENAI_API_KEY}`,
    },
    body: JSON.stringify({
      model,
      messages: [{ role: 'user', content: prompt }],
      temperature: 0.2,
      max_tokens: 3000,
      response_format: { type: 'json_object' },
    }),
  });

  if (!response.ok) {
    const text = await response.text();
    throw new Error(`OpenAI error ${response.status}: ${text}`);
  }

  const data = await response.json();
  const content = data.choices?.[0]?.message?.content;
  if (!content) throw new Error('No content in OpenAI response');

  return {
    result: JSON.parse(content),
    usage: data.usage || {},
  };
}

exports.handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') return { statusCode: 204, headers: CORS, body: '' };
  if (event.httpMethod !== 'POST')    return err(405, 'Method not allowed');

  if (!OPENAI_API_KEY) return err(503, 'AI scoring is not configured on this server');
  if (!SUPABASE_URL || !SUPABASE_SERVICE_KEY) return err(503, 'Database not configured');

  // Auth
  const authHeader = event.headers.authorization || event.headers.Authorization;
  if (!authHeader?.startsWith('Bearer ')) return err(401, 'Missing bearer token');
  const jwt = authHeader.slice(7);

  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false }
  });

  const { data: userData, error: userErr } = await admin.auth.getUser(jwt);
  if (userErr || !userData?.user) return err(401, 'Invalid session');
  const userId = userData.user.id;

  // Parse body
  let body;
  try { body = JSON.parse(event.body || '{}'); }
  catch { return err(400, 'Invalid JSON'); }

  const { workspace_id, context, model: requestedModel } = body;
  if (!workspace_id) return err(400, 'workspace_id required');

  const model = requestedModel || MODEL_DEFAULT;

  // Rate limit: max 5 runs per user per hour
  const oneHourAgo = new Date(Date.now() - 3600000).toISOString();
  const { count } = await admin
    .from('scoring_runs')
    .select('*', { count: 'exact', head: true })
    .eq('user_id', userId)
    .gte('started_at', oneHourAgo);

  if ((count || 0) >= 5) {
    return err(429, 'Rate limit reached: maximum 5 scoring runs per hour. Please wait before running another score.');
  }

  // Verify workspace belongs to user
  const { data: workspace } = await admin
    .from('application_workspaces')
    .select('*')
    .eq('id', workspace_id)
    .eq('user_id', userId)
    .maybeSingle();

  if (!workspace) return err(403, 'Workspace not found or access denied');

  // Get rubric + criteria for this program type
  const { data: rubric } = await admin
    .from('scoring_rubrics')
    .select('*')
    .eq('program_type', workspace.program_type)
    .eq('is_active', true)
    .order('version', { ascending: false })
    .limit(1)
    .maybeSingle();

  if (!rubric) return err(404, `No active rubric found for program type: ${workspace.program_type}`);

  const { data: criteria } = await admin
    .from('scoring_criteria')
    .select('*')
    .eq('rubric_id', rubric.id)
    .order('sort_order');

  if (!criteria?.length) return err(404, 'Rubric has no criteria — contact support');

  // Get answers
  const { data: answerRows } = await admin
    .from('application_answers')
    .select('criterion_id, answer_text, answer_data, self_score')
    .eq('workspace_id', workspace_id);

  const answers = {};
  (answerRows || []).forEach(a => { answers[a.criterion_id] = a.answer_text || ''; });

  // Get evidence files
  const { data: evidenceFiles } = await admin
    .from('evidence_files')
    .select('file_name, label, criterion_id')
    .eq('workspace_id', workspace_id);

  // Create scoring run record
  const { data: run } = await admin
    .from('scoring_runs')
    .insert({
      workspace_id,
      user_id: userId,
      rubric_id: rubric.id,
      status: 'running',
      model_used: model,
      started_at: new Date().toISOString(),
    })
    .select()
    .single();

  if (!run) return err(500, 'Failed to create scoring run');

  try {
    const prompt = buildPrompt(workspace.program_type, criteria, answers, evidenceFiles || [], context);
    const { result, usage } = await callOpenAI(prompt, model);

    // Add required disclaimer to result
    result.ai_disclaimer = AI_DISCLAIMER;

    // Save result
    await admin.from('scoring_results').insert({
      run_id:                 run.id,
      workspace_id,
      program_type:           workspace.program_type,
      total_score_estimate:   result.total_score_estimate,
      max_possible_score:     result.max_possible_score,
      readiness_level:        result.readiness_level,
      section_scores:         result.section_scores || {},
      strengths:              result.strengths || [],
      weaknesses:             result.weaknesses || [],
      missing_evidence:       result.missing_evidence || [],
      risk_flags:             result.risk_flags || [],
      recommended_actions:    result.recommended_actions || [],
      plain_english_summary:  result.plain_english_summary || '',
      evidence_checklist:     result.evidence_checklist || [],
      priority_fix_list:      result.priority_fix_list || [],
      ai_disclaimer:          result.ai_disclaimer,
    });

    // Update run as complete
    await admin.from('scoring_runs').update({
      status: 'complete',
      completed_at: new Date().toISOString(),
      prompt_tokens: usage.prompt_tokens,
      completion_tokens: usage.completion_tokens,
    }).eq('id', run.id);

    return ok({ run_id: run.id, result });

  } catch (e) {
    console.error('AI scoring error:', e.message);
    await admin.from('scoring_runs').update({
      status: 'failed',
      error_message: e.message,
      completed_at: new Date().toISOString(),
    }).eq('id', run.id);
    return err(500, 'AI scoring failed: ' + e.message);
  }
};
