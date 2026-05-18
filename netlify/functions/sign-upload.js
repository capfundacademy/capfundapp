// ============================================================================
// sign-upload.js — Supabase Storage signed upload URL for evidence files
// Auth: requires valid Supabase JWT
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

const ALLOWED_TYPES = ['application/pdf','application/msword','application/vnd.openxmlformats-officedocument.wordprocessingml.document','application/vnd.ms-excel','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet','image/jpeg','image/png','text/plain','text/csv'];
const MAX_SIZE = 25 * 1024 * 1024; // 25 MB

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

  const { workspace_id, file_name, mime_type, file_size } = body;

  if (!workspace_id || !file_name) return err(400, 'workspace_id and file_name required');
  if (file_size && file_size > MAX_SIZE) return err(400, `File too large. Maximum 25 MB.`);
  if (mime_type && !ALLOWED_TYPES.includes(mime_type)) return err(400, `File type not allowed: ${mime_type}`);

  // Verify workspace ownership
  const { data: ws } = await admin.from('application_workspaces').select('id').eq('id', workspace_id).eq('user_id', userId).maybeSingle();
  if (!ws) return err(403, 'Workspace not found or access denied');

  // Sanitize filename
  const safe = file_name.replace(/[^a-zA-Z0-9._-]/g, '_').slice(0, 120);
  const path = `${userId}/${workspace_id}/${Date.now()}-${safe}`;

  try {
    const { data, error: signErr } = await admin.storage.from(BUCKET).createSignedUploadUrl(path);
    if (signErr) throw signErr;
    return ok({ signed_url: data.signedUrl, path, token: data.token });
  } catch (e) {
    console.error('sign-upload error:', e.message);
    return err(500, 'Failed to create upload URL: ' + e.message);
  }
};
