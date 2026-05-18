// ============================================================================
// renewal-reminder.js — Subscription renewal reminders (30 days before expiry)
// Scheduled: daily at 10am UTC
// ============================================================================

const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL         = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const RESEND_API_KEY       = process.env.RESEND_API_KEY;
const SITE_URL             = process.env.URL || 'https://capfundacademy.com';
const FROM                 = 'Cap Fund Academy <support@capfundacademy.com>';

exports.handler = async () => {
  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false }
  });

  const runId = (await admin.from('autopilot_runs').insert({
    function_name: 'renewal-reminder', status: 'running', started_at: new Date().toISOString()
  }).select().single()).data?.id;

  let processed = 0, failed = 0;

  try {
    const thirtyDaysFromNow = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString();
    const twentyNineDaysFromNow = new Date(Date.now() + 29 * 24 * 60 * 60 * 1000).toISOString();

    // Find subscriptions expiring in ~30 days
    const { data: expiring } = await admin.from('subscriptions')
      .select('id, user_id, current_period_end, offers(title)')
      .eq('status', 'active')
      .gte('current_period_end', twentyNineDaysFromNow)
      .lte('current_period_end', thirtyDaysFromNow);

    for (const sub of expiring || []) {
      try {
        const { data: userData } = await admin.auth.admin.getUserById(sub.user_id);
        if (!userData?.user?.email) continue;

        const email = userData.user.email;
        const expiryDate = new Date(sub.current_period_end).toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' });

        // Check we haven't already sent a reminder this week
        const sevenDaysAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString();
        const { count } = await admin.from('email_sends')
          .select('*', { count: 'exact', head: true })
          .eq('to_email', email)
          .eq('subject', `Your Cap Fund Academy subscription renews on ${expiryDate}`)
          .gte('sent_at', sevenDaysAgo);
        if ((count || 0) > 0) continue;

        const html = `<div style="font-family:Arial,sans-serif;max-width:560px;margin:0 auto;color:#0F1631">
          <img src="${SITE_URL}/assets/logo-white.png" alt="Cap Fund Academy" style="height:40px;background:#2D1FB1;padding:8px;border-radius:8px;margin-bottom:20px"/>
          <h2>Your subscription renews soon</h2>
          <p>Your <strong>${sub.offers?.title || 'Cap Fund Academy'}</strong> subscription will automatically renew on <strong>${expiryDate}</strong>.</p>
          <p>No action needed if you want to continue — your access will remain uninterrupted.</p>
          <p>If you have questions about your subscription, reply to this email or contact us at <a href="mailto:support@capfundacademy.com">support@capfundacademy.com</a>.</p>
          <a href="${SITE_URL}" style="display:inline-block;padding:12px 24px;background:#2D1FB1;color:white;font-weight:bold;border-radius:8px;text-decoration:none;margin-top:8px">Access Your Dashboard →</a>
          <p style="margin-top:24px;font-size:11px;color:#9CA3AF">Cap Fund Academy is an independent training platform not affiliated with USDA or any government agency.</p>
        </div>`;

        if (RESEND_API_KEY) {
          const subject = `Your Cap Fund Academy subscription renews on ${expiryDate}`;
          const res = await fetch('https://api.resend.com/emails', {
            method: 'POST',
            headers: { 'Authorization': `Bearer ${RESEND_API_KEY}`, 'Content-Type': 'application/json' },
            body: JSON.stringify({ from: FROM, to: [email], subject, html })
          });
          if (res.ok) {
            const result = await res.json();
            await admin.from('email_sends').insert({ to_email: email, subject, status: 'sent', provider_id: result?.id });
            processed++;
          } else { failed++; }
        }
      } catch (e) { console.error('Renewal reminder failed:', e.message); failed++; }
    }

    if (runId) await admin.from('autopilot_runs').update({
      status: failed > 0 ? 'partial' : 'success',
      completed_at: new Date().toISOString(),
      records_processed: processed, records_failed: failed,
      summary: { expiring: (expiring || []).length, sent: processed }
    }).eq('id', runId);

    return { statusCode: 200, body: JSON.stringify({ processed, failed }) };
  } catch (e) {
    console.error('renewal-reminder error:', e.message);
    if (runId) await admin.from('autopilot_runs').update({ status: 'failed', error_message: e.message, completed_at: new Date().toISOString() }).eq('id', runId);
    return { statusCode: 500, body: e.message };
  }
};
