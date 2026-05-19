// ============================================================================
// inactivity-nudge.js — Email students who haven't logged in for 7+ days
// Scheduled: daily at 11 AM UTC
// Finds students with in-progress certs who have been inactive 7-14 days
// Sends a personalized "we miss you" email with their exact progress
// ============================================================================

const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL         = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const SITE_URL             = process.env.URL || 'https://capfundacademy.com';

exports.handler = async () => {
  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false },
  });

  const { data: runLog } = await admin.from('autopilot_runs').insert({
    function_name: 'inactivity-nudge', status: 'running', started_at: new Date().toISOString(),
  }).select().single();
  const runId = runLog?.id;

  let nudged = 0;
  const errors = [];

  try {
    const sevenDaysAgo  = new Date(Date.now() - 7  * 86400000).toISOString();
    const fourteenAgo   = new Date(Date.now() - 14 * 86400000).toISOString();

    // Students with activity between 7-14 days ago (not before 14 — already nudged)
    const { data: inactive } = await admin
      .from('student_progress')
      .select('user_id, certification_id, completed_at, certifications(title, cert_number)')
      .eq('status', 'completed')
      .lt('completed_at', sevenDaysAgo)
      .gt('completed_at', fourteenAgo)
      .order('completed_at', { ascending: false });

    if (!inactive?.length) {
      await admin.from('autopilot_runs').update({ status: 'success', completed_at: new Date().toISOString(), summary: { nudged: 0, reason: 'no inactive students' } }).eq('id', runId);
      return { statusCode: 200, body: JSON.stringify({ nudged: 0 }) };
    }

    // Deduplicate — one email per user
    const seen = new Set();
    for (const row of inactive) {
      if (seen.has(row.user_id)) continue;
      seen.add(row.user_id);

      // Get profile
      const { data: profile } = await admin.from('profiles').select('email, full_name').eq('id', row.user_id).single();
      if (!profile?.email) continue;

      // Count total lessons completed across all in-progress certs
      const { count: lessonsTotal } = await admin.from('student_progress')
        .select('*', { count: 'exact', head: true }).eq('user_id', row.user_id).eq('status', 'completed');

      // Count completed certs
      const { count: certsComplete } = await admin.from('certification_completions')
        .select('*', { count: 'exact', head: true }).eq('user_id', row.user_id);

      const name     = profile.full_name?.split(' ')[0] || 'there';
      const certName = row.certifications?.title || 'your current certification';
      const certNum  = row.certifications?.cert_number || '';
      const remaining = 36 - (certsComplete || 0);

      const emailHtml = `<!DOCTYPE html><html><head><meta charset="UTF-8"/></head>
      <body style="font-family:Inter,sans-serif;background:#F8FAFC;margin:0;padding:20px;">
      <div style="max-width:540px;margin:0 auto;background:#fff;border-radius:16px;overflow:hidden;box-shadow:0 4px 24px rgba(0,0,0,0.08);">
        <div style="background:#0F1631;padding:20px 28px;">
          <img src="${SITE_URL}/assets/logo-cfa.png" alt="Cap Fund Academy" style="height:44px;width:auto;"/>
        </div>
        <div style="padding:28px;">
          <h2 style="font-size:20px;font-weight:800;color:#0F1631;margin:0 0 12px;">Hey ${name} — your progress is waiting 👋</h2>
          <p style="color:#6b7280;font-size:14px;line-height:1.6;margin:0 0 20px;">
            It looks like you haven't logged in for a few days. You've come a long way —
            <strong>${lessonsTotal || 0} lessons completed</strong> and
            <strong>${certsComplete || 0} of 36 certifications earned</strong>.
            Don't let the momentum slip now.
          </p>
          <div style="background:#eff6ff;border-radius:10px;padding:16px;margin-bottom:20px;">
            <div style="font-size:12px;color:#2D1FB1;font-weight:700;text-transform:uppercase;letter-spacing:1px;margin-bottom:6px;">Where you left off</div>
            <div style="font-size:15px;font-weight:700;color:#0F1631;">Cert ${certNum}: ${certName}</div>
            <div style="font-size:13px;color:#6b7280;margin-top:2px;">${remaining} certification${remaining === 1 ? '' : 's'} remaining to complete your track</div>
          </div>
          <div style="text-align:center;margin-bottom:20px;">
            <a href="${SITE_URL}" style="display:inline-block;background:#F97316;color:#fff;font-weight:700;padding:14px 32px;border-radius:12px;text-decoration:none;font-size:15px;">
              Pick Up Where I Left Off →
            </a>
          </div>
          <p style="font-size:12px;color:#9ca3af;text-align:center;margin:0;">
            You're building expertise that most rural finance professionals never develop.<br/>Keep going.
          </p>
        </div>
        <div style="background:#f8fafc;padding:14px 28px;border-top:1px solid #e5e7eb;text-align:center;">
          <p style="font-size:11px;color:#9ca3af;margin:0;">
            Cap Fund Academy · Not affiliated with USDA · <a href="${SITE_URL}" style="color:#9ca3af;">capfundacademy.com</a>
          </p>
        </div>
      </div></body></html>`;

      try {
        await fetch(`${SITE_URL}/.netlify/functions/email-send`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            to: profile.email,
            subject: `${name}, your Cap Fund Academy progress is waiting`,
            html: emailHtml,
            _internal: true,
          }),
        });
        nudged++;
      } catch (e) { errors.push(`${profile.email}: ${e.message}`); }

      await new Promise(r => setTimeout(r, 300)); // rate limit
    }

    await admin.from('autopilot_runs').update({
      status: errors.length ? 'partial' : 'success',
      completed_at: new Date().toISOString(),
      records_processed: nudged,
      records_failed: errors.length,
      summary: { nudged, errors },
    }).eq('id', runId);

    return { statusCode: 200, body: JSON.stringify({ nudged, errors }) };

  } catch (fatal) {
    await admin.from('autopilot_runs').update({ status: 'failed', completed_at: new Date().toISOString(), error_message: fatal.message }).eq('id', runId);
    return { statusCode: 500, body: JSON.stringify({ error: fatal.message }) };
  }
};
