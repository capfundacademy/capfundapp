// ============================================================================
// stripe-checkout.js — Create Stripe Checkout Session
// Supports: single cert, bundle, org license, subscription, DWU
// Auth: requires valid Supabase JWT
// ============================================================================

const Stripe       = require('stripe');
const { createClient } = require('@supabase/supabase-js');

const stripe = Stripe(process.env.STRIPE_SECRET_KEY);
const SUPABASE_URL         = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const SITE_URL             = process.env.URL || 'https://capfundacademy.com';

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

  if (!process.env.STRIPE_SECRET_KEY) return err(503, 'Payments not configured');

  const authHeader = event.headers.authorization || event.headers.Authorization;
  if (!authHeader?.startsWith('Bearer ')) return err(401, 'Missing bearer token');

  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false }
  });

  const { data: userData, error: userErr } = await admin.auth.getUser(authHeader.slice(7));
  if (userErr || !userData?.user) return err(401, 'Invalid session');
  const user = userData.user;

  let body;
  try { body = JSON.parse(event.body || '{}'); }
  catch { return err(400, 'Invalid JSON'); }

  const { offer_id, coupon_code, cert_number, organization_id } = body;
  if (!offer_id) return err(400, 'offer_id required');

  // Fetch offer
  const { data: offer } = await admin.from('offers').select('*').eq('id', offer_id).eq('is_active', true).maybeSingle();
  if (!offer) return err(404, 'Offer not found or inactive');

  // Resolve coupon
  let stripeCoupon;
  let couponId;
  if (coupon_code) {
    const { data: coupon } = await admin.from('coupons')
      .select('*')
      .eq('code', coupon_code.toUpperCase())
      .eq('is_active', true)
      .maybeSingle();
    if (coupon) {
      if (coupon.expires_at && new Date(coupon.expires_at) < new Date()) {
        return err(400, 'Coupon has expired');
      }
      if (coupon.max_uses && coupon.uses_count >= coupon.max_uses) {
        return err(400, 'Coupon has reached its usage limit');
      }
      stripeCoupon = coupon.stripe_coupon_id;
      couponId = coupon.id;
    }
  }

  // Fetch or create Stripe customer
  let stripeCustomerId;
  const { data: existingOrder } = await admin.from('orders')
    .select('stripe_customer_id')
    .eq('user_id', user.id)
    .not('stripe_customer_id', 'is', null)
    .limit(1)
    .maybeSingle();

  if (existingOrder?.stripe_customer_id) {
    stripeCustomerId = existingOrder.stripe_customer_id;
  } else {
    const customer = await stripe.customers.create({
      email: user.email,
      metadata: { supabase_user_id: user.id }
    });
    stripeCustomerId = customer.id;
  }

  // Build Stripe line items
  let lineItems;
  if (offer.stripe_price_id) {
    lineItems = [{ price: offer.stripe_price_id, quantity: 1 }];
  } else {
    // Create ad-hoc price if no Stripe Price ID configured
    lineItems = [{
      price_data: {
        currency: 'usd',
        unit_amount: offer.price_cents,
        product_data: {
          name: offer.title,
          description: offer.description || undefined,
        },
      },
      quantity: 1,
    }];
  }

  // Create a pending order record
  const { data: order } = await admin.from('orders').insert({
    user_id: user.id,
    organization_id: organization_id || null,
    offer_id: offer.id,
    coupon_id: couponId || null,
    status: 'pending',
    amount_cents: offer.price_cents,
    stripe_customer_id: stripeCustomerId,
    metadata: { offer_type: offer.offer_type, cert_numbers: offer.cert_numbers, seat_limit: offer.seat_limit }
  }).select().single();

  if (!order) return err(500, 'Failed to create order');

  // Create Stripe Checkout Session
  const sessionParams = {
    mode: offer.offer_type === 'subscription' ? 'subscription' : 'payment',
    customer: stripeCustomerId,
    line_items: lineItems,
    success_url: `${SITE_URL}/?checkout=success&order=${order.id}`,
    cancel_url:  `${SITE_URL}/?checkout=cancelled`,
    client_reference_id: order.id,
    metadata: {
      order_id:    order.id,
      user_id:     user.id,
      offer_id:    offer.id,
      offer_type:  offer.offer_type,
    },
    allow_promotion_codes: !coupon_code,
  };

  if (stripeCoupon) sessionParams.discounts = [{ coupon: stripeCoupon }];

  try {
    const session = await stripe.checkout.sessions.create(sessionParams);
    await admin.from('orders').update({ stripe_session_id: session.id }).eq('id', order.id);
    return ok({ url: session.url, session_id: session.id, order_id: order.id });
  } catch (e) {
    console.error('Stripe checkout error:', e.message);
    await admin.from('orders').update({ status: 'failed' }).eq('id', order.id);
    return err(500, 'Checkout creation failed: ' + e.message);
  }
};
