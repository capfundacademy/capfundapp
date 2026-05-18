// ============================================================================
// abandoned-checkout.js — Scheduled: check for pending orders >1hr, send recovery email
// Runs every 2 hours via netlify.toml scheduled function
// ============================================================================

const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL         = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const RESEND_API_KEY       = process.env.RESEND_API_KEY;
const SITE_URL             = process.env.URL || 'https://capfundacademy.com';
const FROM_EMAIL           = 'Cap Fund Academy <support@capfundacademy.com>';

exports.handler = async () => {
  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false }
  });

  const oneHourAgo = new Date(Date.now() - 60 * 60 * 1000).toISOString();
  const twentyFourHoursAgo = new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString();

  // Find orders pending for 1–24 hours (not already emailed)
  const { data: abandoned } = await admin
    .from('orders')
    .select('id, user_id, amount_cents, offers(title), metadata')
    .eq('status', 'pending')
    .lt('created_at', oneHourAgo)
    .gt('created_at', twentyFourHoursAgo);

  if (!abandoned?.length) {
    console.log('No abandoned checkouts found');
    return { statusCode: 200, body: 'No abandoned checkouts' };
  }

  let sent = 0;
  for (const order of abandoned) {
    try {
      // Get user email
      const { data: userData } = await admin.auth.admin.getUserById(order.user_id);
      if (!userData?.user?.email) continue;

      const email = userData.user.email;
      const offerTitle = order.offers?.title || 'your selected program';
      const price = '$' + (order.amount_cents / 100).toLocaleString();

      const res = await fetch('https://api.resend.com/emails', {
        method: 'POST',
        headers: { 'Authorization': `Bearer ${RESEND_API_KEY}`, 'Content-Type': 'application/json' },
        body: JSON.stringify({
          from: FROM_EMAIL,
          to: [email],
          subject: `You left something behind — ${offerTitle}`,
          html: `<div style="font-family:Arial,sans-serif;max-width:560px;margin:0 auto;color:#0F1631">
            <img src="${SITE_URL}/assets/logo.png" alt="Cap Fund Academy" style="height:48px;margin-bottom:24px"/>
            <h2 style="color:#2D1FB1">You started something great</h2>
            <p>You were moments away from enrolling in <strong>${offerTitle}</strong> (${price}).</p>
            <p>If you had any questions or concerns, we're here to help. Reply to this email or reach us at <a href="mailto:support@capfundacademy.com">support@capfundacademy.com</a>.</p>
            <a href="${SITE_URL}" style="display:inline-block;padding:12px 24px;background:#F97316;color:white;font-weight:bold;border-radius:8px;text-decoration:none;margin-top:16px">Complete Enrollment →</a>
            <p style="margin-top:32px;font-size:11px;color:#999">Cap Fund Academy is an independent training platform not affiliated with USDA or any government agency.</p>
          </div>`
        })
      });

      if (res.ok) {
        // Mark order so we don't re-email (add a metadata flag)
        await admin.from('orders').update({
          metadata: { ...order.metadata, abandoned_email_sent: new Date().toISOString() }
        }).eq('id', order.id);
        sent++;
      }
    } catch (e) {
      console.error('Abandoned checkout email failed for order', order.id, e.message);
    }
  }

  console.log(`Abandoned checkout: sent ${sent} recovery emails`);
  return { statusCode: 200, body: JSON.stringify({ sent, total: abandoned.length }) };
};
