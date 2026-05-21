// check-social-config.js — env var + live DB connection diagnostic
const { createClient } = require('@supabase/supabase-js');

const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
};

exports.handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') return { statusCode: 204, headers: CORS, body: '' };

  const SUPABASE_URL  = process.env.SUPABASE_URL;
  const SERVICE_KEY   = process.env.SUPABASE_SERVICE_ROLE_KEY;
  const OPENAI_KEY    = process.env.OPENAI_API_KEY;
  const BUFFER_TOKEN  = process.env.BUFFER_ACCESS_TOKEN;

  // ── 1. Env var presence ───────────────────────────────────────────────────
  const envChecks = {
    SUPABASE_URL:              !!SUPABASE_URL,
    SUPABASE_SERVICE_ROLE_KEY: !!SERVICE_KEY,
    OPENAI_API_KEY:            !!OPENAI_KEY,
    BUFFER_ACCESS_TOKEN:       !!BUFFER_TOKEN,
    BUFFER_PROFILE_LINKEDIN:   !!process.env.BUFFER_PROFILE_LINKEDIN,
    BUFFER_PROFILE_INSTAGRAM:  !!process.env.BUFFER_PROFILE_INSTAGRAM,
    BUFFER_PROFILE_TIKTOK:     !!process.env.BUFFER_PROFILE_TIKTOK,
  };
  const missing = Object.entries(envChecks).filter(([,v]) => !v).map(([k]) => k);
  const present = Object.entries(envChecks).filter(([,v]) =>  v).map(([k]) => k);

  const hints = {};
  if (OPENAI_KEY)   hints.OPENAI_API_KEY        = OPENAI_KEY.slice(0, 10)   + '…';
  if (BUFFER_TOKEN) hints.BUFFER_ACCESS_TOKEN    = BUFFER_TOKEN.slice(0, 8)  + '…';
  if (SERVICE_KEY)  hints.SERVICE_KEY_prefix     = SERVICE_KEY.slice(0, 20)  + '…';
  if (SUPABASE_URL) hints.SUPABASE_URL           = SUPABASE_URL;
  if (process.env.BUFFER_PROFILE_LINKEDIN)  hints.BUFFER_PROFILE_LINKEDIN  = process.env.BUFFER_PROFILE_LINKEDIN;
  if (process.env.BUFFER_PROFILE_INSTAGRAM) hints.BUFFER_PROFILE_INSTAGRAM = process.env.BUFFER_PROFILE_INSTAGRAM;
  if (process.env.BUFFER_PROFILE_TIKTOK)   hints.BUFFER_PROFILE_TIKTOK    = process.env.BUFFER_PROFILE_TIKTOK;

  // ── 2. Live Supabase DB test (service role) ───────────────────────────────
  let dbTest = { ok: false, error: 'skipped — SUPABASE_URL or SERVICE_KEY missing' };

  if (SUPABASE_URL && SERVICE_KEY) {
    try {
      const admin = createClient(SUPABASE_URL, SERVICE_KEY, {
        auth: { autoRefreshToken: false, persistSession: false },
      });

      // Test INSERT then DELETE so we leave no junk rows
      const testName = 'check-social-config-test';
      const { data: inserted, error: insErr } = await admin
        .from('autopilot_runs')
        .insert({ function_name: testName, status: 'running', started_at: new Date().toISOString() })
        .select('id')
        .single();

      if (insErr) {
        dbTest = { ok: false, error: `INSERT failed: ${insErr.message} (code: ${insErr.code})` };
      } else {
        // Clean up the test row
        await admin.from('autopilot_runs').delete().eq('id', inserted.id);
        dbTest = { ok: true, inserted_id: inserted.id, message: 'INSERT + DELETE succeeded — DB connection working' };
      }
    } catch (e) {
      dbTest = { ok: false, error: `Exception: ${e.message}` };
    }
  }

  // ── 3. OpenAI reachability (lightweight model list call) ─────────────────
  let openaiTest = { ok: false, error: 'skipped — OPENAI_API_KEY missing' };
  if (OPENAI_KEY) {
    try {
      const r = await fetch('https://api.openai.com/v1/models', {
        headers: { Authorization: `Bearer ${OPENAI_KEY}` },
        signal: AbortSignal.timeout(8000),
      });
      openaiTest = r.ok
        ? { ok: true, status: r.status, message: 'OpenAI API key valid and reachable' }
        : { ok: false, status: r.status, error: await r.text().then(t => t.slice(0, 200)) };
    } catch (e) {
      openaiTest = { ok: false, error: e.message };
    }
  }

  // ── 4. Buffer API reachability ────────────────────────────────────────────
  let bufferTest = { ok: false, error: 'skipped — BUFFER_ACCESS_TOKEN missing' };
  if (BUFFER_TOKEN) {
    try {
      const r = await fetch('https://api.buffer.com/graphql', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${BUFFER_TOKEN}` },
        body: JSON.stringify({ query: '{ viewer { id email } }' }),
        signal: AbortSignal.timeout(8000),
      });
      const json = await r.json().catch(() => ({}));
      bufferTest = (r.ok && json?.data?.viewer)
        ? { ok: true, viewer: json.data.viewer, message: 'Buffer token valid' }
        : { ok: false, status: r.status, error: json?.errors?.[0]?.message || JSON.stringify(json).slice(0, 200) };
    } catch (e) {
      bufferTest = { ok: false, error: e.message };
    }
  }

  const allGood = missing.length === 0 && dbTest.ok && openaiTest.ok && bufferTest.ok;

  return {
    statusCode: allGood ? 200 : 500,
    headers: { ...CORS, 'Content-Type': 'application/json' },
    body: JSON.stringify({ allGood, missing, present, hints, dbTest, openaiTest, bufferTest }),
  };
};
