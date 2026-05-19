#!/usr/bin/env node
// ============================================================================
// stripe-setup.js — One-time Stripe product and price creation for all 36 certs
//
// Run: STRIPE_SECRET_KEY=sk_live_xxx node scripts/stripe-setup.js
//
// Creates all 36 individual cert products + bundles, then prints SQL to paste
// into Supabase SQL Editor to link Stripe IDs to your certifications table.
// ============================================================================

const Stripe = require('stripe');

const key = process.env.STRIPE_SECRET_KEY;
if (!key) { console.error('Set STRIPE_SECRET_KEY env var first'); process.exit(1); }

const stripe = Stripe(key);

// ── All 36 individual certifications ─────────────────────────────────────────
const INDIVIDUAL_CERTS = [
  // ── RMAP/RLF Core Track (Certs 1-17) ──
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
  { num: 17, title: 'Master Capstone: USDA-Ready Microlending/RLF Program',           price: 99700 },
  // ── All Things Lender Track (Certs 18-36) ──
  { num: 18, title: 'Government Lending Models Foundations',                           price: 49700 },
  { num: 19, title: 'Lending Entity, Licensing & Compliance Readiness',               price: 59700 },
  { num: 20, title: 'SBA 7(a) & Small Business Lending',                              price: 59700 },
  { num: 21, title: 'SBA Microloan, CDC/504 & SBIC',                                  price: 59700 },
  { num: 22, title: 'USDA Rural Business & OneRD Guaranteed Lending',                 price: 69700 },
  { num: 23, title: 'USDA Housing & Multifamily Lending',                             price: 69700 },
  { num: 24, title: 'USDA Farm & Agriculture Credit',                                 price: 59700 },
  { num: 25, title: 'FHA, VA, USDA Mortgage & Native Housing Lending',                price: 69700 },
  { num: 26, title: 'FHA Multifamily, Healthcare & HUD Risk-Sharing',                 price: 69700 },
  { num: 27, title: 'Secondary Market & Mortgage Liquidity',                          price: 59700 },
  { num: 28, title: 'CDFI, Treasury & Community Investment',                          price: 79700 },
  { num: 29, title: 'SSBCI, State & Local Capital Access',                            price: 59700 },
  { num: 30, title: 'EDA Revolving Loan Fund',                                        price: 69700 },
  { num: 31, title: 'EPA, Water & Environmental RLF',                                 price: 59700 },
  { num: 32, title: 'Infrastructure, Energy, Transportation & Utility Finance',       price: 69700 },
  { num: 33, title: 'Export, Trade & International Sales Finance',                    price: 49700 },
  { num: 34, title: 'Tribal & Native Lending Programs',                               price: 69700 },
  { num: 35, title: 'Student Loan & Legacy Servicing Awareness',                      price: 39700 },
  { num: 36, title: 'Capital Stack Design & Partnership Strategy',                    price: 59700 },
];

// ── Bundles & packages ────────────────────────────────────────────────────────
const BUNDLES = [
  // RMAP/RLF track bundles
  {
    slug:  'rural-microfinance-associate',
    title: 'Rural Microfinance Associate — Certs 1–4 Bundle',
    desc:  'All 4 certifications for the Rural Microfinance Associate credential. Save $491 vs buying individually.',
    price: 149700,
    type:  'one_time',
  },
  {
    slug:  'rlf-practitioner',
    title: 'Revolving Loan Fund Practitioner — Certs 1–9 Bundle',
    desc:  'All 9 certifications for the RLF Practitioner credential. Save $980 vs buying individually.',
    price: 299700,
    type:  'one_time',
  },
  {
    slug:  'usda-rural-capital-specialist',
    title: 'USDA Rural Capital Program Specialist — Certs 1–13 Bundle',
    desc:  'All 13 certifications for the USDA Rural Capital Specialist credential. Save $1,474 vs buying individually.',
    price: 399700,
    type:  'one_time',
  },
  {
    slug:  'master-rlf-administrator',
    title: 'Master RLF Administrator — All 17 RMAP/RLF Core Certs',
    desc:  'Complete 17-certification RMAP/RLF core track. Save $1,965 vs buying individually.',
    price: 599700,
    type:  'one_time',
  },
  // Expanded All Things Lender bundles
  {
    slug:  'government-lending-associate',
    title: 'Government Lending Program Associate — Certs 18–25 Bundle',
    desc:  'Eight-certification bundle covering government lending foundations, SBA, and USDA programs.',
    price: 399700,
    type:  'one_time',
  },
  {
    slug:  'master-capital-access-architect',
    title: 'Master Capital Access Architect — All 36 Certifications',
    desc:  'Complete 36-certification bundle. The most comprehensive government lending curriculum available. Save over $3,000 vs buying individually.',
    price: 999700,
    type:  'one_time',
  },
  // Org and services
  {
    slug:  'org-license-5-seats',
    title: 'Organization License — Up to 5 Seats',
    desc:  'All 36 certifications for up to 5 staff members. Includes admin seat management and team progress tracking.',
    price: 500000,
    type:  'one_time',
  },
  {
    slug:  'done-with-you-support',
    title: 'Done-With-You Application Support',
    desc:  'Full curriculum access plus personalized application review, live coaching sessions, and submission support for your USDA RMAP, RBDG, CDFI, EDA, or other government lending application.',
    price: 1000000,
    type:  'one_time',
  },
  {
    slug:  'annual-membership',
    title: 'Annual Membership — Updates & Community Access',
    desc:  'Annual membership: all curriculum updates, regulatory change alerts, alumni community, and monthly live Q&A sessions.',
    price: 19900,
    type:  'recurring',
    interval: 'year',
  },
];

// ── Helpers ───────────────────────────────────────────────────────────────────
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

  // Individual certifications
  console.log(`Creating ${INDIVIDUAL_CERTS.length} individual certification products…`);
  for (const cert of INDIVIDUAL_CERTS) {
    try {
      const product = await createProduct(
        `Cap Fund Academy — Cert ${cert.num}: ${cert.title}`,
        `Standalone certification. Self-paced online training by Cap Fund Academy (independent training platform, not affiliated with any government agency).`,
        { cert_number: String(cert.num), type: 'individual_cert' }
      );
      const price = await createPrice(product.id, cert.price);
      results.push({ slug: `cert-${cert.num}`, product_id: product.id, price_id: price.id, amount: cert.price });
      console.log(`  ✅ Cert ${cert.num}: ${product.id} / ${price.id} ($${(cert.price/100).toFixed(0)})`);
    } catch (e) {
      console.error(`  ❌ Cert ${cert.num}: ${e.message}`);
    }
    await new Promise(r => setTimeout(r, 250));
  }

  // Bundles and packages
  console.log(`\nCreating ${BUNDLES.length} bundle/package products…`);
  for (const bundle of BUNDLES) {
    try {
      const product = await createProduct(
        `Cap Fund Academy — ${bundle.title}`,
        bundle.desc + ' Cap Fund Academy is an independent training platform not affiliated with any government agency.',
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
    await new Promise(r => setTimeout(r, 250));
  }

  // Print SQL
  console.log('\n\n══════════════════════════════════════════════════════════');
  console.log(`✅ Created ${results.length} products/prices total.`);
  console.log('══════════════════════════════════════════════════════════\n');
  console.log('Paste this SQL into your Supabase SQL Editor:\n');
  console.log('-- ── Stripe Price IDs → certifications table ──────────────');
  for (const r of results.filter(r => r.slug.startsWith('cert-'))) {
    const num = r.slug.split('-')[1];
    console.log(`UPDATE certifications SET stripe_price_id = '${r.price_id}' WHERE cert_number = ${num};`);
  }

  console.log('\n-- ── Stripe Product/Price IDs → offers table ──────────────');
  for (const r of results.filter(r => !r.slug.startsWith('cert-'))) {
    console.log(`-- ${r.slug} ($${(r.amount/100).toFixed(0)})`);
    console.log(`UPDATE offers SET stripe_product_id = '${r.product_id}', stripe_price_id = '${r.price_id}' WHERE slug = '${r.slug}';`);
  }

  console.log('\n✅ Done. Copy the SQL above and run it in Supabase.\n');
})();
