// ============================================================================
// exception-detect.js — Hourly exception detection + admin alerts
// Checks: payment failures, high-value abandoned carts, compliance flags,
//         AI scoring failures, DWY submissions, seat limit warnings
// Scheduled: every hour
// ============================================================================

const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL         = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const RESEND_API_KEY       = process.env.RESEND_API_KEY;
const SITE_URL             = process.env.URL || 'https://capfundacademy.com';
const ADMIN_EMAIL          = 'support@capfundacademy.com';
const FROM                 = 'Cap Fund Academy Alerts <support@capfundacademy.com>';

async function alertAdmin(subject, html) {
  if (!RESEND_API_KEY) return;
  await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: { 'Authorization': `Bearer ${RESEND_API_KEY}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({ from: FROM, to: [ADMIN_EMAIL], subject, html })
  });
}

async function logException(admin, type, severity, title, description, metadata = {}) {
  await admin.from('exception_events').insert({ event_type: type, severity, title, description, metadata });
}

exports.handler = async () => {
  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false }
  });

  const runId = (await admin.from('autopilot_runs').insert({
    function_name: 'exception-detect', status: 'running', started_at: new Date().toISOString()
  }).select().single()).data?.id;

  const oneHourAgo  = new Date(Date.now() - 3600000).toISOString();
  const alerts = [];
  let processed = 0;

  try {
    // 1. Payment failures in last hour
    const { data: failedOrders } = await admin.from('orders')
      .select('id, amount_cents, created_at, offers(title)')
      .eq('status', 'failed')
      .gte('updated_at', oneHourAgo);

    if (failedOrders?.length) {
      for (const order of failedOrders) {
        await logException(admin, 'payment_failed', 'error',
          `Payment failed: ${order.offers?.title || 'Unknown offer'}`,
          `Order ${order.id} failed. Amount: $${(order.amount_cents/100).toFixed(2)}`,
          { order_id: order.id, amount_cents: order.amount_cents });
      }
      alerts.push(`⚠️ ${failedOrders.length} payment failure(s)`);
      processed += failedOrders.length;
    }

    // 2. High-value abandoned checkouts (>$500) older than 2 hours, no recovery email
    const twoHoursAgo = new Date(Date.now() - 7200000).toISOString();
    const { data: highValueAbandoned } = await admin.from('orders')
      .select('id, amount_cents, user_id, offers(title), metadata')
      .eq('status', 'pending')
      .gte('amount_cents', 50000)
      .lt('created_at', twoHoursAgo)
      .not('metadata->abandoned_email_sent', 'is', null);

    if (highValueAbandoned?.length) {
      for (const order of highValueAbandoned) {
        if (!order.metadata?.high_value_alerted) {
          await logException(admin, 'high_value_abandoned', 'warning',
            `High-value cart abandoned: ${order.offers?.title}`,
            `$${(order.amount_cents/100).toFixed(2)} order pending for 2+ hours`,
            { order_id: order.id });
          await admin.from('orders').update({ metadata: { ...order.metadata, high_value_alerted: true } }).eq('id', order.id);
        }
      }
      if (highValueAbandoned.length) alerts.push(`💰 ${highValueAbandoned.length} high-value cart(s) abandoned`);
      processed += highValueAbandoned.length;
    }

    // 3. AI scoring failures in last hour (>3 failures)
    const { count: scoringFails } = await admin.from('scoring_runs')
      .select('*', { count: 'exact', head: true })
      .eq('status', 'failed')
      .gte('started_at', oneHourAgo);

    if ((scoringFails || 0) >= 3) {
      await logException(admin, 'ai_scoring_failed', 'error',
        `AI scoring failures: ${scoringFails} in the last hour`,
        'Check OPENAI_API_KEY and rate limits', { count: scoringFails });
      alerts.push(`🤖 ${scoringFails} AI scoring failures in last hour`);
      processed++;
    }

    // 4. Content compliance flags triggered in last hour
    const { count: complianceFlags } = await admin.from('social_posts')
      .select('*', { count: 'exact', head: true })
      .eq('compliance_passed', false)
      .gte('created_at', oneHourAgo);

    if ((complianceFlags || 0) > 0) {
      await logException(admin, 'compliance_flag', 'warning',
        `${complianceFlags} content piece(s) blocked by compliance checker`,
        'Review the Content Engine approval queue', { count: complianceFlags });
      alerts.push(`🚩 ${complianceFlags} compliance flag(s) triggered`);
      processed++;
    }

    // 5. DWY (Done-With-You) order submitted — high-touch alert
    const { data: dwuOrders } = await admin.from('orders')
      .select('id, user_id, created_at, offers(offer_type,title)')
      .eq('status', 'paid')
      .gte('created_at', oneHourAgo);

    const dwu = (dwuOrders || []).filter(o => o.offers?.offer_type === 'dwu');
    if (dwu.length) {
      for (const order of dwu) {
        await logException(admin, 'dwu_submitted', 'info',
          `DWY application support purchased!`,
          `Order ${order.id} — immediate follow-up needed within 24 hours`,
          { order_id: order.id });
      }
      alerts.push(`🤝 ${dwu.length} DWY purchase(s) — follow up needed`);
      processed += dwu.length;
    }

    // 6. Org seat limit warnings
    const { data: seats } = await admin.from('organization_seats')
      .select('organization_id, total_seats, used_seats');
    for (const seat of seats || []) {
      if (seat.used_seats >= seat.total_seats) {
        await logException(admin, 'seat_limit_reached', 'warning',
          'Organization seat limit reached',
          `Org ${seat.organization_id} has used ${seat.used_seats}/${seat.total_seats} seats`,
          { organization_id: seat.organization_id });
        alerts.push(`🪑 Seat limit reached for an organization`);
        processed++;
      }
    }

    // Send alert email if anything found
    if (alerts.length && RESEND_API_KEY) {
      await alertAdmin(
        `⚠️ Cap Fund Academy — ${alerts.length} alert(s) detected`,
        `<div style="font-family:Arial,sans-serif;max-width:560px;color:#0F1631">
          <h2 style="color:#DC2626">Autopilot Alerts</h2>
          <p>${new Date().toLocaleString()}</p>
          <ul>${alerts.map(a => `<li style="margin-bottom:8px">${a}</li>`).join('')}</ul>
          <a href="${SITE_URL}" style="display:inline-block;padding:12px 24px;background:#2D1FB1;color:white;font-weight:bold;border-radius:8px;text-decoration:none;margin-top:16px">Open Admin Dashboard →</a>
        </div>`
      );
    }

    if (runId) await admin.from('autopilot_runs').update({
      status: 'success', completed_at: new Date().toISOString(),
      records_processed: processed, summary: { alerts }
    }).eq('id', runId);

    return { statusCode: 200, body: JSON.stringify({ alerts, processed }) };

  } catch (e) {
    console.error('exception-detect error:', e.message);
    if (runId) await admin.from('autopilot_runs').update({ status: 'failed', completed_at: new Date().toISOString(), error_message: e.message }).eq('id', runId);
    return { statusCode: 500, body: e.message };
  }
};
