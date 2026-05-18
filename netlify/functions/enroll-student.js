// ============================================================================
// enroll-student.js — Manual enrollment (admin grants access without payment)
// Auth: admin or super_admin only
// ============================================================================

const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL         = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

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

  const { data: requester } = await admin.from('profiles').select('role').eq('id', userData.user.id).maybeSingle();
  if (!['super_admin','admin'].includes(requester?.role)) return err(403, 'Admin access required');

  let body;
  try { body = JSON.parse(event.body || '{}'); }
  catch { return err(400, 'Invalid JSON'); }

  const { target_user_id, cert_numbers, offer_id, organization_id, granted_by = 'admin' } = body;
  if (!target_user_id) return err(400, 'target_user_id required');

  let certIds = [];

  if (cert_numbers?.length) {
    const { data: certs } = await admin.from('certifications').select('id,cert_number').in('cert_number', cert_numbers);
    certIds = (certs || []).map(c => c.id);
  } else if (offer_id) {
    const { data: offer } = await admin.from('offers').select('cert_numbers').eq('id', offer_id).maybeSingle();
    if (offer?.cert_numbers?.length) {
      const { data: certs } = await admin.from('certifications').select('id').in('cert_number', offer.cert_numbers);
      certIds = (certs || []).map(c => c.id);
    }
  }

  if (!certIds.length) return err(400, 'No certifications to enroll in');

  const enrollments = certIds.map(certId => ({
    user_id: target_user_id,
    certification_id: certId,
    order_id: null,
    organization_id: organization_id || null,
    enrolled_at: new Date().toISOString(),
    granted_by
  }));

  const { error: enrollErr } = await admin.from('enrollments')
    .upsert(enrollments, { onConflict: 'user_id,certification_id', ignoreDuplicates: true });

  if (enrollErr) return err(500, 'Enrollment failed: ' + enrollErr.message);

  return ok({ enrolled: certIds.length, message: `Enrolled in ${certIds.length} certification(s)` });
};
