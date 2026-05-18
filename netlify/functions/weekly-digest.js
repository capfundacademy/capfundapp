// ============================================================================
// weekly-digest.js — Weekly analytics summary email to support@capfundacademy.com
// Scheduled: every Monday at 8am UTC
// ============================================================================

const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL         = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const RESEND_API_KEY       = process.env.RESEND_API_KEY;
const SITE_URL             = process.env.URL || 'https://capfundacademy.com';
const ADMIN_EMAIL          = 'support@capfundacademy.com';
const FROM                 = 'Cap Fund Academy Autopilot <support@capfundacademy.com>';

exports.handler = async () => {
  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false }
  });

  const runId = (await admin.from('autopilot_runs').insert({
    function_name: 'weekly-digest', status: 'running', started_at: new Date().toISOString()
  }).select().single()).data?.id;

  try {
    const now = new Date();
    const weekAgo = new Date(now - 7 * 24 * 60 * 60 * 1000).toISOString();
    const twoWeeksAgo = new Date(now - 14 * 24 * 60 * 60 * 1000).toISOString();

    // Gather this week's metrics
    const [
      { count: newLeads },
      { count: newLeadsPrior },
      { data: orders },
      { count: completions },
      { count: scoringRuns },
      { count: postsGenerated },
      { count: postsApproved },
      { count: pendingApprovals },
      { data: exceptions },
      { count: newStudents }
    ] = await Promise.all([
      admin.from('leads').select('*', { count: 'exact', head: true }).gte('created_at', weekAgo),
      admin.from('leads').select('*', { count: 'exact', head: true }).gte('created_at', twoWeeksAgo).lt('created_at', weekAgo),
      admin.from('orders').select('amount_cents').eq('status', 'paid').gte('created_at', weekAgo),
      admin.from('certification_completions').select('*', { count: 'exact', head: true }).gte('completed_at', weekAgo),
      admin.from('scoring_runs').select('*', { count: 'exact', head: true }).eq('status', 'complete').gte('started_at', weekAgo),
      admin.from('social_posts').select('*', { count: 'exact', head: true }).gte('created_at', weekAgo),
      admin.from('social_posts').select('*', { count: 'exact', head: true }).eq('status', 'approved').gte('created_at', weekAgo),
      admin.from('social_posts').select('*', { count: 'exact', head: true }).eq('status', 'review'),
      admin.from('exception_events').select('event_type,title,severity').eq('resolved', false).gte('created_at', weekAgo).limit(10),
      admin.from('profiles').select('*', { count: 'exact', head: true }).eq('role', 'student').gte('created_at', weekAgo),
    ]);

    const revenue = (orders || []).reduce((s, o) => s + (o.amount_cents || 0), 0);
    const revenueFormatted = '$' + (revenue / 100).toLocaleString('en-US', { minimumFractionDigits: 2 });
    const leadChange = (newLeadsPrior || 0) > 0
      ? Math.round(((newLeads - newLeadsPrior) / newLeadsPrior) * 100) : null;
    const leadTrend = leadChange === null ? '' : leadChange >= 0 ? `↑${leadChange}% vs last week` : `↓${Math.abs(leadChange)}% vs last week`;

    const exceptionsHtml = (exceptions || []).length === 0
      ? '<li style="color:#16A34A">✅ No unresolved exceptions this week</li>'
      : (exceptions || []).map(e => `<li style="color:${e.severity === 'error' ? '#DC2626' : '#D97706'}">⚠️ ${e.title}</li>`).join('');

    const html = `
<div style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto;color:#0F1631">
  <div style="border-bottom:3px solid #2D1FB1;padding:24px 0 16px">
    <img src="${SITE_URL}/assets/logo-white.png" alt="Cap Fund Academy" style="height:48px;background:#2D1FB1;padding:8px;border-radius:8px"/>
    <p style="margin:8px 0 0;font-size:12px;color:#6B7280;letter-spacing:.08em;text-transform:uppercase">Weekly Autopilot Digest — ${now.toLocaleDateString('en-US', { weekday:'long', year:'numeric', month:'long', day:'numeric' })}</p>
  </div>

  <div style="padding:24px 0">
    <h2 style="margin:0 0 20px;color:#2D1FB1">This Week at a Glance</h2>

    <table style="width:100%;border-collapse:collapse;margin-bottom:24px">
      <tr>
        <td style="background:#F8FAFC;padding:16px;border-radius:8px;text-align:center;width:25%">
          <div style="font-size:32px;font-weight:900;color:#2D1FB1">${newLeads || 0}</div>
          <div style="font-size:11px;color:#6B7280;margin-top:4px">New Leads</div>
          ${leadTrend ? `<div style="font-size:11px;color:#16A34A;margin-top:2px">${leadTrend}</div>` : ''}
        </td>
        <td style="width:4%"></td>
        <td style="background:#F8FAFC;padding:16px;border-radius:8px;text-align:center;width:25%">
          <div style="font-size:32px;font-weight:900;color:#16A34A">${revenueFormatted}</div>
          <div style="font-size:11px;color:#6B7280;margin-top:4px">Revenue</div>
        </td>
        <td style="width:4%"></td>
        <td style="background:#F8FAFC;padding:16px;border-radius:8px;text-align:center;width:25%">
          <div style="font-size:32px;font-weight:900;color:#F97316">${newStudents || 0}</div>
          <div style="font-size:11px;color:#6B7280;margin-top:4px">New Students</div>
        </td>
        <td style="width:4%"></td>
        <td style="background:#F8FAFC;padding:16px;border-radius:8px;text-align:center;width:25%">
          <div style="font-size:32px;font-weight:900;color:#7C3AED">${completions || 0}</div>
          <div style="font-size:11px;color:#6B7280;margin-top:4px">Certs Completed</div>
        </td>
      </tr>
    </table>

    <h3 style="color:#0F1631;border-bottom:1px solid #E5E7EB;padding-bottom:8px">Platform Activity</h3>
    <table style="width:100%;font-size:14px;margin-bottom:24px">
      ${[
        ['AI Scoring Runs', scoringRuns || 0],
        ['Content Posts Generated', postsGenerated || 0],
        ['Content Posts Approved', postsApproved || 0],
        ['Posts Pending Approval', pendingApprovals || 0],
      ].map(([label, val]) => `<tr><td style="padding:6px 0;color:#6B7280">${label}</td><td style="padding:6px 0;font-weight:700;text-align:right">${val}</td></tr>`).join('')}
    </table>

    <h3 style="color:#0F1631;border-bottom:1px solid #E5E7EB;padding-bottom:8px">Exceptions & Alerts</h3>
    <ul style="margin:0 0 24px;padding-left:16px;font-size:13px;line-height:1.8">
      ${exceptionsHtml}
    </ul>

    <a href="${SITE_URL}" style="display:inline-block;padding:12px 24px;background:#2D1FB1;color:white;font-weight:bold;border-radius:8px;text-decoration:none">Open Admin Dashboard →</a>
  </div>

  <div style="border-top:1px solid #E5E7EB;padding-top:16px;font-size:11px;color:#9CA3AF">
    This digest is sent automatically every Monday. Cap Fund Academy is an independent training platform not affiliated with USDA.
  </div>
</div>`;

    if (RESEND_API_KEY) {
      await fetch('https://api.resend.com/emails', {
        method: 'POST',
        headers: { 'Authorization': `Bearer ${RESEND_API_KEY}`, 'Content-Type': 'application/json' },
        body: JSON.stringify({ from: FROM, to: [ADMIN_EMAIL], subject: `Cap Fund Academy Weekly Digest — ${now.toLocaleDateString('en-US', { month:'short', day:'numeric' })}`, html })
      });
    }

    const summary = { newLeads, revenue, newStudents, completions, scoringRuns, postsGenerated };
    if (runId) await admin.from('autopilot_runs').update({ status: 'success', completed_at: new Date().toISOString(), records_processed: 1, summary }).eq('id', runId);

    console.log('Weekly digest sent:', summary);
    return { statusCode: 200, body: JSON.stringify(summary) };
  } catch (e) {
    console.error('weekly-digest error:', e.message);
    if (runId) await admin.from('autopilot_runs').update({ status: 'failed', completed_at: new Date().toISOString(), error_message: e.message }).eq('id', runId);
    return { statusCode: 500, body: e.message };
  }
};
