// ============================================================================
// stripe-webhook.js — Handle Stripe webhook events (IDEMPOTENT)
// Handles: checkout.session.completed, payment_intent.payment_failed,
//          customer.subscription.updated, customer.subscription.deleted,
//          charge.refunded
// ============================================================================

const Stripe       = require('stripe');
const { createClient } = require('@supabase/supabase-js');

const stripe = Stripe(process.env.STRIPE_SECRET_KEY);
const WEBHOOK_SECRET       = process.env.STRIPE_WEBHOOK_SECRET;
const SUPABASE_URL         = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const SITE_URL             = process.env.URL || 'https://capfundacademy.com';

async function sendPurchaseEmail({ toEmail, toName, offerTitle, amountCents }) {
  const amount   = amountCents ? `$${(amountCents / 100).toFixed(2)}` : '';
  const html = `
    <div style="font-family:sans-serif;max-width:560px;margin:0 auto;color:#1f2937">
      <div style="background:#0F1631;padding:24px;text-align:center;border-radius:12px 12px 0 0">
        <img src="${SITE_URL}/assets/logo-header.png" alt="Cap Fund Academy" style="height:48px"/>
      </div>
      <div style="background:#ffffff;padding:40px;border-radius:0 0 12px 12px;border:1px solid #e5e7eb">
        <h1 style="color:#111827;font-size:22px;margin:0 0 8px">Payment Confirmed ✅</h1>
        <p style="color:#6b7280;margin:0 0 24px">Hi ${toName || 'there'}, your enrollment is confirmed.</p>

        <div style="background:#f0f4ff;border:1px solid #c7d2fe;border-radius:10px;padding:20px;margin-bottom:24px">
          <p style="margin:0 0 4px;font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:.05em;color:#6366f1">Enrolled In</p>
          <p style="margin:0;font-size:16px;font-weight:700;color:#2D1FB1">${offerTitle}</p>
          ${amount ? `<p style="margin:4px 0 0;font-size:13px;color:#6b7280">Amount paid: <strong>${amount}</strong></p>` : ''}
        </div>

        <p style="font-weight:600;color:#111827;margin:0 0 12px">What to do next:</p>
        <table style="width:100%;border-collapse:collapse;margin-bottom:28px">
          ${[
            ['🎓','Log in to your dashboard','Your course is ready to start right now.'],
            ['📜','Complete all lessons','Pass the quiz to earn your official certificate.'],
            ['📞','Need help?','Email support@capfundacademy.com anytime.'],
          ].map(([icon, title, body]) => `
            <tr>
              <td style="width:36px;vertical-align:top;padding:8px 0;font-size:20px">${icon}</td>
              <td style="padding:8px 0">
                <p style="margin:0;font-weight:600;color:#111827;font-size:14px">${title}</p>
                <p style="margin:0;color:#6b7280;font-size:13px">${body}</p>
              </td>
            </tr>
          `).join('')}
        </table>

        <a href="${SITE_URL}" style="display:block;background:#2D1FB1;color:#ffffff;text-align:center;padding:14px;border-radius:10px;font-weight:700;font-size:15px;text-decoration:none;margin-bottom:24px">
          Access My Course →
        </a>

        <p style="font-size:12px;color:#9ca3af;text-align:center;margin:0">
          Cap Fund Academy · Not affiliated with USDA or any government agency<br>
          Questions? <a href="mailto:support@capfundacademy.com" style="color:#6366f1">support@capfundacademy.com</a>
        </p>
      </div>
    </div>`;

  try {
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 12000);
    await fetch(`${SITE_URL}/.netlify/functions/email-send`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ to: toEmail, subject: `You're enrolled — ${offerTitle}`, html, _internal: true }),
      signal: controller.signal,
    });
    clearTimeout(timeout);
  } catch (e) {
    console.error('Purchase confirmation email failed:', e.message);
  }
}

exports.handler = async (event) => {
  if (event.httpMethod !== 'POST') return { statusCode: 405, body: 'Method not allowed' };

  const sig = event.headers['stripe-signature'];
  let stripeEvent;

  try {
    stripeEvent = stripe.webhooks.constructEvent(event.body, sig, WEBHOOK_SECRET);
  } catch (e) {
    console.error('Webhook signature verification failed:', e.message);
    return { statusCode: 400, body: `Webhook Error: ${e.message}` };
  }

  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false }
  });

  // Idempotency: check if already processed
  const { data: existing } = await admin.from('stripe_events').select('id,processed').eq('id', stripeEvent.id).maybeSingle();
  if (existing?.processed) {
    console.log('Duplicate webhook event, skipping:', stripeEvent.id);
    return { statusCode: 200, body: 'Already processed' };
  }

  // Log event
  await admin.from('stripe_events').upsert({
    id: stripeEvent.id, type: stripeEvent.type, processed: false,
    payload: stripeEvent.data.object, created_at: new Date().toISOString()
  }, { onConflict: 'id' });

  try {
    switch (stripeEvent.type) {

      case 'checkout.session.completed': {
        const session = stripeEvent.data.object;
        const orderId = session.client_reference_id || session.metadata?.order_id;
        if (!orderId) break;

        const { data: order } = await admin.from('orders').select('*, offers(*)').eq('id', orderId).maybeSingle();
        if (!order) { console.error('Order not found:', orderId); break; }

        // Update order to paid
        await admin.from('orders').update({
          status: 'paid',
          stripe_payment_intent: session.payment_intent,
          stripe_customer_id: session.customer,
          updated_at: new Date().toISOString()
        }).eq('id', orderId);

        // Enroll user in certifications
        const offer = order.offers;
        if (offer?.cert_numbers?.length > 0) {
          // Get cert IDs from cert numbers
          const { data: certs } = await admin.from('certifications')
            .select('id, cert_number')
            .in('cert_number', offer.cert_numbers);

          if (certs?.length > 0) {
            const enrollments = certs.map(c => ({
              user_id: order.user_id,
              certification_id: c.id,
              order_id: order.id,
              organization_id: order.organization_id,
              enrolled_at: new Date().toISOString(),
              granted_by: 'purchase'
            }));
            await admin.from('enrollments').upsert(enrollments, { onConflict: 'user_id,certification_id', ignoreDuplicates: true });
          }
        }

        // Grant AI Study Coach access for DWY purchasers
        if (offer?.offer_type === 'dwu') {
          await admin.from('profiles').update({ coach_access: true }).eq('id', order.user_id);
          console.log('Coach access granted to user:', order.user_id);
        }

        // For org licenses: create organization_seats record
        if (offer?.offer_type === 'org_license' && order.organization_id) {
          await admin.from('organization_seats').upsert({
            organization_id: order.organization_id,
            order_id: order.id,
            offer_id: offer.id,
            total_seats: offer.seat_limit || 5,
            used_seats: 1
          }, { onConflict: 'organization_id' });
        }

        // Increment coupon use count
        if (order.coupon_id) {
          const { error: rpcErr } = await admin.rpc('increment_coupon_uses', { coupon_id: order.coupon_id });
          if (rpcErr) {
            // Fallback if RPC not yet created: read-then-write
            console.warn('increment_coupon_uses RPC missing, using fallback:', rpcErr.message);
            const { data: coupon } = await admin.from('coupons').select('uses_count').eq('id', order.coupon_id).single();
            if (coupon) {
              await admin.from('coupons').update({ uses_count: (coupon.uses_count || 0) + 1 }).eq('id', order.coupon_id);
            }
          }
        }

        // Send purchase confirmation email
        const { data: buyerProfile } = await admin.from('profiles')
          .select('full_name')
          .eq('id', order.user_id)
          .maybeSingle();
        const { data: buyerAuth } = await admin.auth.admin.getUserById(order.user_id);
        const buyerEmail = buyerAuth?.user?.email;
        if (buyerEmail) {
          await sendPurchaseEmail({
            toEmail:    buyerEmail,
            toName:     buyerProfile?.full_name || '',
            offerTitle: order.offers?.name || 'Cap Fund Academy Certification',
            amountCents: order.amount_cents,
          });
        }

        console.log('Order fulfilled:', orderId);
        break;
      }

      case 'payment_intent.payment_failed': {
        const pi = stripeEvent.data.object;
        await admin.from('orders')
          .update({ status: 'failed', updated_at: new Date().toISOString() })
          .eq('stripe_payment_intent', pi.id);
        break;
      }

      case 'charge.refunded': {
        const charge = stripeEvent.data.object;
        const refundedCents = charge.amount_refunded;
        await admin.from('orders')
          .update({
            status: refundedCents >= charge.amount ? 'refunded' : 'paid',
            amount_refunded_cents: refundedCents,
            updated_at: new Date().toISOString()
          })
          .eq('stripe_payment_intent', charge.payment_intent);
        break;
      }

      case 'customer.subscription.updated': {
        const sub = stripeEvent.data.object;
        await admin.from('subscriptions')
          .update({
            status: sub.status,
            current_period_start: new Date(sub.current_period_start * 1000).toISOString(),
            current_period_end:   new Date(sub.current_period_end   * 1000).toISOString(),
            updated_at: new Date().toISOString()
          })
          .eq('stripe_subscription_id', sub.id);
        break;
      }

      case 'customer.subscription.deleted': {
        const sub = stripeEvent.data.object;
        await admin.from('subscriptions')
          .update({ status: 'cancelled', cancelled_at: new Date().toISOString(), updated_at: new Date().toISOString() })
          .eq('stripe_subscription_id', sub.id);
        break;
      }

      default:
        console.log('Unhandled event type:', stripeEvent.type);
    }

    await admin.from('stripe_events').update({ processed: true }).eq('id', stripeEvent.id);
    return { statusCode: 200, body: 'OK' };

  } catch (e) {
    console.error('Webhook handler error:', e.message);
    await admin.from('stripe_events').update({ error: e.message }).eq('id', stripeEvent.id);
    return { statusCode: 500, body: 'Handler error: ' + e.message };
  }
};
