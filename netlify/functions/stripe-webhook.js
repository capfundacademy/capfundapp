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
          await admin.rpc('increment_coupon_uses', { coupon_id: order.coupon_id });
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
