#!/usr/bin/env node
// ============================================================================
// stripe-setup.js — One-time Stripe product and price creation
//
// Run: STRIPE_SECRET_KEY=sk_live_xxx node scripts/stripe-setup.js
//
// Creates all products and prices then prints a SQL UPDATE block to paste
// into Supabase SQL Editor to link Stripe IDs to your offers table.
// ============================================================================

const Stripe = require('stripe');

const key = process.env.STRIPE_SECRET_KEY;
if (!key) { console.error('Set STRIPE_SECRET_KEY env var first'); process.exit(1); }

const stripe = Stripe(key);

// ── Product definitions ───────────────────────────────────────────────────────
const INDIVIDUAL_CERTS = [
  { num: 1,  title: 'Microfinance Foundations & Borrower-Centered Lending',           price: 49700 },
  { num: 2,  title: 'Revolving Loan Fund Design & Capitalization',                    price: 49700 },
  { num: 3,  title: 'USDA RMAP Eligibility, Application & Scoring',                  price: 59700 },
  { num: 4,  title: 'RMAP Microlender Operations, Loan Closing & Compliance',         price: 49700 },
  { num: 5,  title: 'RMAP Technical Assistance & Training Program',                   price: 49700 },
  { num: 6,  title: 'USDA RBDG Rural Business Development Grant & RLF',               price: 59700 },
  { num: 7,  title: 'IRP and Federal Capital Stack Strategy',                         price: 49700 },
  { num: 8,  title: 'Underwriting, Credit Policy & Portfolio Risk',                   price: 59700 },
  { num: 9,  title: 'Loan Servicing, Collections, Workouts & Default Management',     price: 49700 },
  { num: 10, title: 'Federal Compliance, Civil Rights, Environmental Review & 2 CFR 200', price: 59700 },
  { num: 11, title: 'RLF Accounting, Fund Administration, Reporting & Audit Readiness', price: 59700 },
  { num: 12, title: 'Application Assembly, Evidence Documentation & AI-Assisted Scoring', price: 49700 },
  { num: 13, title: 'Community Outreach, Partnerships, Job Creation & Economic Impact', price: 49700 },
  { num: 14, title: 'Automated Offer, Sales Funnel & Enrollment Operations',           price: 49700 },
  { num: 15, title: 'Content Engine, Social Media Automation & Ads',                  price: 49700 },
  { num: 16, title: 'CRM, Applications, Customer Success & Business Operations',       price: 49700 },
  { num: 17, title: 'Master Capstone: USDA-Ready Microlending/RLF Program and Automated Certification Business', price: 99700 },
];

const BUNDLES = [
  {
    slug:  'rural-microfinance-associate',
    title: 'Rural Microfinance Associate — Certs 1–4 Bundle',
    desc:  'All 4 certifications for the Rural Microfinance Associate credential. Save $491 vs buying individually.',
    price: 149700,  // $1,497
    type:  'one_time',
  },
  {
    slug:  'rlf-practitioner',
    title: 'Revolving Loan Fund Practitioner — Certs 1–9 Bundle',
    desc:  'All 9 certifications for the RLF Practitioner credential. Save $980 vs buying individually.',
    price: 299700,  // $2,997
    type:  'one_time',
  },
  {
    slug:  'usda-rural-capital-specialist',
    title: 'USDA Rural Capital Program Specialist — Certs 1–13 Bundle',
    desc:  'All 13 certifications for the USDA Rural Capital Specialist credential. Save $1,474 vs buying individually.',
    price: 399700,  // $3,997
    type:  'one_time',
  },
  {
    slug:  'certified-rlf-executive',
    title: 'Certified RLF Executive — Certs 1–15 Bundle',
    desc:  'All 15 certifications for the Certified RLF Executive credential. Save $1,468 vs buying individually.',
    price: 499700,  // $4,997
    type:  'one_time',
  },
  {
    slug:  'master-administrator',
    title: 'Master Rural Microfinance & RLF Administrator — All 17 Certs',
    desc:  'Complete 17-certification bundle for the highest Cap Fund Academy credential. Save $1,965 vs buying individually.',
    price: 599700,  // $5,997
    type:  'one_time',
  },
  {
    slug:  'org-license-5-seats',
    title: 'Organization License — Up to 5 Seats',
    desc:  'All 17 certifications for up to 5 staff members. Includes admin seat management and progress tracking.',
    price: 500000,  // $5,000
    type:  'one_time',
  },
  {
    slug:  'done-with-you-support',
    title: 'Done-With-You Application Support',
    desc:  'Full curriculum access plus personalized application review, live coaching sessions, and submission support for your USDA RMAP or RBDG application.',
    price: 1000000, // $10,000
    type:  'one_time',
  },
  {
    slug:  'annual-membership',
    title: 'Annual Membership — Updates & Community Access',
    desc:  'Annual membership including all curriculum updates, regulatory change notifications, alumni community, and monthly live Q&A sessions.',
    price: 19900,   // $199/year
    type:  'recurring',
    interval: 'year',
  },
];

// ── Helper ────────────────────────────────────────────────────────────────────
async function createProduct(name, desc, metadata = {}) {
  return stripe.products.create({ name, description: desc, metadata });
}

async function createPrice(productId, unitAmount, currency = 'usd', recurring = null) {
  const params = { product: productId, unit_amount: unitAmount, currency };
  if (recurring) params.recurring = recurring;
  return stripe.prices.create(params);
}

// ── Main ──────────────────────────────────────────────────────────────────────
(async () => {
  console.log('\n🔵 Cap Fund Academy — Stripe Product Setup\n');
  console.log(`Environment: ${key.startsWith('sk_live') ? '🟢 LIVE' : '🟡 TEST'}\n`);

  const results = [];

  // ── Individual certifications ──────────────────────────────────────────────
  console.log('Creating 17 individual certification products…');
  for (const cert of INDIVIDUAL_CERTS) {
    try {
      const product = await createProduct(
        `Cap Fund Academy — Cert ${cert.num}: ${cert.title}`,
        `Standalone certification. ${cert.title}. Self-paced online certification by Cap Fund Academy (independent training platform, not affiliated with USDA).`,
        { cert_number: String(cert.num), type: 'individual_cert' }
      );
      const price = await createPrice(product.id, cert.price);
      results.push({ slug: `cert-${cert.num}`, product_id: product.id, price_id: price.id, amount: cert.price });
      console.log(`  ✅ Cert ${cert.num}: ${product.id} / ${price.id} ($${(cert.price/100).toFixed(0)})`);
    } catch (e) {
      console.error(`  ❌ Cert ${cert.num}: ${e.message}`);
    }
    await new Promise(r => setTimeout(r, 200)); // rate limit buffer
  }

  // ── Bundles and packages ───────────────────────────────────────────────────
  console.log('\nCreating bundle and package products…');
  for (const bundle of BUNDLES) {
    try {
      const product = await createProduct(
        `Cap Fund Academy — ${bundle.title}`,
        bundle.desc + ' Cap Fund Academy is an independent training platform not affiliated with USDA.',
        { type: bundle.type === 'recurring' ? 'membership' : 'bundle', slug: bundle.slug }
      );
      const recurring = bundle.type === 'recurring' ? { interval: bundle.interval } : null;
      const price = await createPrice(product.id, bundle.price, 'usd', recurring);
      results.push({ slug: bundle.slug, product_id: product.id, price_id: price.id, amount: bundle.price });
      const suffix = bundle.type === 'recurring' ? `/${bundle.interval}` : '';
      console.log(`  ✅ ${bundle.slug}: ${product.id} / ${price.id} ($${(bundle.price/100).toFixed(0)}${suffix})`);
    } catch (e) {
      console.error(`  ❌ ${bundle.slug}: ${e.message}`);
    }
    await new Promise(r => setTimeout(r, 200));
  }

  // ── Print SQL to update offers table ──────────────────────────────────────
  console.log('\n\n── Stripe setup complete ──────────────────────────────────────');
  console.log(`\nCreated ${results.length} products/prices.\n`);
  console.log('Paste this into your Supabase SQL Editor to link Stripe IDs:\n');
  console.log('-- Stripe Product/Price IDs → Supabase offers table');
  console.log('-- Run in Supabase SQL Editor after running this script\n');

  for (const r of results) {
    console.log(`-- ${r.slug} ($${(r.amount/100).toFixed(0)})`);
    console.log(`UPDATE offers SET stripe_product_id = '${r.product_id}', stripe_price_id = '${r.price_id}' WHERE slug = '${r.slug}';`);
  }

  console.log('\n-- Also update certifications table with Stripe price IDs:');
  for (const r of results.filter(r => r.slug.startsWith('cert-'))) {
    const num = r.slug.split('-')[1];
    console.log(`UPDATE certifications SET stripe_price_id = '${r.price_id}' WHERE cert_number = ${num};`);
  }

  console.log('\n✅ Done. Copy the SQL above and run it in Supabase.\n');
})();
