// ============================================================================
// sign-read.js — Supabase Storage signed read URL for evidence files
// Auth: requires valid Supabase JWT; user must own the workspace
// ============================================================================

const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL         = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const BUCKET               = process.env.STORAGE_BUCKET || 'evidence';

const CORS = {
  'Access-Control-Allow-Origin':  '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
};
const ok  = (b) => ({ statusCode: 200, headers: { ...CORS, 'Content-Type': 'application/json' }, body: JSON.stringify(b) });
const err = (s, m) => ({ statusCode: s, headers: { ...CORS, 'Content-Type': 'application/json' }, body: JSON.stringify({ error: m }) });

exports.handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') return { statusCode: 204, headers: CORS, body: '' };
  if (event.httpMethod !== 'POST')    return err(405, 'Method not allowed');

  const authHeader = event.headers.authorization || event.headers.Authorization;
  if (!authHeader?.startsWith('Bearer ')) return err(401, 'Missing bearer token');

  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false }
  });

  const { data: userData, error: userErr } = await admin.auth.getUser(authHeader.slice(7));
  if (userErr || !userData?.user) return err(401, 'Invalid session');
  const userId = userData.user.id;

  let body;
  try { body = JSON.parse(event.body || '{}'); }
  catch { return err(400, 'Invalid JSON'); }

  const { file_path, evidence_file_id } = body;
  if (!file_path && !evidence_file_id) return err(400, 'file_path or evidence_file_id required');

  let path = file_path;
  if (evidence_file_id && !path) {
    const { data: ef } = await admin.from('evidence_files').select('file_path, user_id').eq('id', evidence_file_id).maybeSingle();
    if (!ef) return err(404, 'Evidence file not found');
    // Check access: own file or admin
    const { data: prof } = await admin.from('profiles').select('role').eq('id', userId).maybeSingle();
    const isAdmin = ['super_admin','admin','instructor','reviewer'].includes(prof?.role);
    if (ef.user_id !== userId && !isAdmin) return err(403, 'Access denied');
    path = ef.file_path;
  }

  try {
    const { data, error: signErr } = await admin.storage.from(BUCKET).createSignedUrl(path, 3600);
    if (signErr) throw signErr;
    return ok({ url: data.signedUrl, expires_in: 3600 });
  } catch (e) {
    console.error('sign-read error:', e.message);
    return err(500, 'Failed to create read URL: ' + e.message);
  }
};
