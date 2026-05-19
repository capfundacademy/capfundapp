-- ============================================================
-- Cap Fund Academy — Link Stripe Price IDs
-- File: 33_stripe_price_ids.sql
-- Run after: 27_cert_seeds_18_35.sql
-- Adds stripe_price_id to certifications table and seeds all
-- 36 cert prices + 9 bundle/package offers with Stripe IDs.
-- ============================================================

-- Step 1: Add stripe columns to certifications if missing
ALTER TABLE certifications ADD COLUMN IF NOT EXISTS stripe_price_id   text;
ALTER TABLE certifications ADD COLUMN IF NOT EXISTS stripe_product_id  text;

-- Step 2: Update all 36 certifications with Stripe price IDs
UPDATE certifications SET stripe_price_id = 'price_1TYsoSPZzqlygATGXIHeT8yA', stripe_product_id = 'prod_UXymQzY4l0IK15' WHERE cert_number = 1;
UPDATE certifications SET stripe_price_id = 'price_1TYsoTPZzqlygATGORhKpJaF', stripe_product_id = 'prod_UXymsB7zj4mCtg'  WHERE cert_number = 2;
UPDATE certifications SET stripe_price_id = 'price_1TYsoUPZzqlygATGWrysXaLT', stripe_product_id = 'prod_UXymJfACUVw9f6'  WHERE cert_number = 3;
UPDATE certifications SET stripe_price_id = 'price_1TYsoUPZzqlygATGtJQfA9pi', stripe_product_id = 'prod_UXymcrZjJEOD7b'  WHERE cert_number = 4;
UPDATE certifications SET stripe_price_id = 'price_1TYsoVPZzqlygATGkBJhBLjU', stripe_product_id = 'prod_UXymkjoh9cMoP6'  WHERE cert_number = 5;
UPDATE certifications SET stripe_price_id = 'price_1TYsoWPZzqlygATGxqAhpFca', stripe_product_id = 'prod_UXymrlIPukTR5M'  WHERE cert_number = 6;
UPDATE certifications SET stripe_price_id = 'price_1TYsoWPZzqlygATGAQvNQCf1', stripe_product_id = 'prod_UXymFEUbKRuLNX'  WHERE cert_number = 7;
UPDATE certifications SET stripe_price_id = 'price_1TYsoXPZzqlygATGqVP3mqQN', stripe_product_id = 'prod_UXym61xFwlg3OU'  WHERE cert_number = 8;
UPDATE certifications SET stripe_price_id = 'price_1TYsoYPZzqlygATGfKnP8yRG', stripe_product_id = 'prod_UXymCcN96EOtMt'  WHERE cert_number = 9;
UPDATE certifications SET stripe_price_id = 'price_1TYsoZPZzqlygATGZ5fdb8XD', stripe_product_id = 'prod_UXymEcWc3PjBU9'  WHERE cert_number = 10;
UPDATE certifications SET stripe_price_id = 'price_1TYsoZPZzqlygATGNZmaS2YE', stripe_product_id = 'prod_UXymCCxSDn5DLB'  WHERE cert_number = 11;
UPDATE certifications SET stripe_price_id = 'price_1TYsoaPZzqlygATGvD664ej1', stripe_product_id = 'prod_UXymg3sTXTUrzi'  WHERE cert_number = 12;
UPDATE certifications SET stripe_price_id = 'price_1TYsobPZzqlygATGlm3PAV9p', stripe_product_id = 'prod_UXym91ZU0u2Ies'  WHERE cert_number = 13;
UPDATE certifications SET stripe_price_id = 'price_1TYsobPZzqlygATGeBzofUrc', stripe_product_id = 'prod_UXymQUfXw4KIEN'  WHERE cert_number = 14;
UPDATE certifications SET stripe_price_id = 'price_1TYsocPZzqlygATGjsCD0GaR', stripe_product_id = 'prod_UXymbEFlYCYjeW'  WHERE cert_number = 15;
UPDATE certifications SET stripe_price_id = 'price_1TYsodPZzqlygATGnBflJer7', stripe_product_id = 'prod_UXymmpv94l7g4K'  WHERE cert_number = 16;
UPDATE certifications SET stripe_price_id = 'price_1TYsoePZzqlygATGc9vP0gqZ', stripe_product_id = 'prod_UXymfMERM51Ja7'  WHERE cert_number = 17;
UPDATE certifications SET stripe_price_id = 'price_1TYsoePZzqlygATGwK46LHa5', stripe_product_id = 'prod_UXym9Pgq9CnQAU'  WHERE cert_number = 18;
UPDATE certifications SET stripe_price_id = 'price_1TYsofPZzqlygATGKr6s2mpB', stripe_product_id = 'prod_UXymOi7cnQP3FT'  WHERE cert_number = 19;
UPDATE certifications SET stripe_price_id = 'price_1TYsogPZzqlygATGfoYpsnn3', stripe_product_id = 'prod_UXym7pxWAfQMfr'  WHERE cert_number = 20;
UPDATE certifications SET stripe_price_id = 'price_1TYsogPZzqlygATGKOXCBy84', stripe_product_id = 'prod_UXymVOFhM2AV92'  WHERE cert_number = 21;
UPDATE certifications SET stripe_price_id = 'price_1TYsohPZzqlygATGLDcljxWG', stripe_product_id = 'prod_UXymUjAwgHLtLT'  WHERE cert_number = 22;
UPDATE certifications SET stripe_price_id = 'price_1TYsoiPZzqlygATGxcnMnOxN', stripe_product_id = 'prod_UXymfiLuET4pSV'  WHERE cert_number = 23;
UPDATE certifications SET stripe_price_id = 'price_1TYsojPZzqlygATGlBNWuqoG', stripe_product_id = 'prod_UXymLexZlOKJl3'  WHERE cert_number = 24;
UPDATE certifications SET stripe_price_id = 'price_1TYsojPZzqlygATGNDyfxkz9', stripe_product_id = 'prod_UXym5RXCUUdtic'  WHERE cert_number = 25;
UPDATE certifications SET stripe_price_id = 'price_1TYsokPZzqlygATGFZBDqb6h', stripe_product_id = 'prod_UXymIBe5wazKnw'  WHERE cert_number = 26;
UPDATE certifications SET stripe_price_id = 'price_1TYsolPZzqlygATGOJgZHdHg', stripe_product_id = 'prod_UXymZsqCVjnh49'  WHERE cert_number = 27;
UPDATE certifications SET stripe_price_id = 'price_1TYsolPZzqlygATGckCCl12v', stripe_product_id = 'prod_UXymGlBcvx9dsH'  WHERE cert_number = 28;
UPDATE certifications SET stripe_price_id = 'price_1TYsomPZzqlygATGibDh2fnF', stripe_product_id = 'prod_UXymM7ekN8JGmV'  WHERE cert_number = 29;
UPDATE certifications SET stripe_price_id = 'price_1TYsonPZzqlygATGU3kBHrXj', stripe_product_id = 'prod_UXym3eTx38GNye'  WHERE cert_number = 30;
UPDATE certifications SET stripe_price_id = 'price_1TYsonPZzqlygATGWh3wH5Rw', stripe_product_id = 'prod_UXymaXcNKLQNKs'  WHERE cert_number = 31;
UPDATE certifications SET stripe_price_id = 'price_1TYsooPZzqlygATGiSWsmbtS', stripe_product_id = 'prod_UXymYzgdSjOPoD'  WHERE cert_number = 32;
UPDATE certifications SET stripe_price_id = 'price_1TYsopPZzqlygATGedKptku0', stripe_product_id = 'prod_UXymoVvnat9zD2'  WHERE cert_number = 33;
UPDATE certifications SET stripe_price_id = 'price_1TYsoqPZzqlygATGSyLXiR21', stripe_product_id = 'prod_UXymSFYGg1Ux5X'  WHERE cert_number = 34;
UPDATE certifications SET stripe_price_id = 'price_1TYsoqPZzqlygATG4n8QLLgH', stripe_product_id = 'prod_UXymlNelc90SjA'  WHERE cert_number = 35;
UPDATE certifications SET stripe_price_id = 'price_1TYsorPZzqlygATGXYi3Igsh', stripe_product_id = 'prod_UXymj6UaQF15JH'  WHERE cert_number = 36;

-- Step 3: Upsert bundle and package offers
INSERT INTO offers (offer_type, title, slug, description, features, cert_numbers, price_cents, stripe_price_id, stripe_product_id, is_active, is_featured, sort_order)
VALUES
  ('bundle',
   'Rural Microfinance Associate — Certs 1–4',
   'rural-microfinance-associate',
   'All 4 certifications for the Rural Microfinance Associate credential.',
   ARRAY['4 certifications','Microfinance foundations','RLF design','RMAP eligibility','RMAP operations'],
   ARRAY[1,2,3,4], 149700,
   'price_1TYsosPZzqlygATGWS025SPA', 'prod_UXymU7hxIqBGl2',
   true, false, 1),

  ('bundle',
   'Revolving Loan Fund Practitioner — Certs 1–9',
   'rlf-practitioner',
   'All 9 certifications for the RLF Practitioner credential.',
   ARRAY['9 certifications','Full RMAP/RBDG/IRP track','Underwriting & servicing','Save $980'],
   ARRAY[1,2,3,4,5,6,7,8,9], 299700,
   'price_1TYsosPZzqlygATGJu5BjZvO', 'prod_UXymBZwqRngGu3',
   true, false, 2),

  ('bundle',
   'USDA Rural Capital Program Specialist — Certs 1–13',
   'usda-rural-capital-specialist',
   'All 13 certifications for the USDA Rural Capital Specialist credential.',
   ARRAY['13 certifications','Federal compliance & accounting','Application assembly','Save $1,474'],
   ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13], 399700,
   'price_1TYsotPZzqlygATG3d6CPNhy', 'prod_UXymbROgifcpuK',
   true, false, 3),

  ('bundle',
   'Master RLF Administrator — All 17 Core Certs',
   'master-rlf-administrator',
   'Complete 17-certification RMAP/RLF core track.',
   ARRAY['17 certifications','Complete RMAP/RLF track','Master capstone included','Save $1,965'],
   ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17], 599700,
   'price_1TYsouPZzqlygATGU4pxpJTa', 'prod_UXymRGNC3hajFf',
   true, false, 4),

  ('bundle',
   'Government Lending Program Associate — Certs 18–25',
   'government-lending-associate',
   '8-certification bundle covering government lending foundations and expanded programs.',
   ARRAY['8 certifications','SBA & USDA programs','FHA/VA/HUD mortgage','Gov lending foundations'],
   ARRAY[18,19,20,21,22,23,24,25], 399700,
   'price_1TYsouPZzqlygATGvGkPW0P4', 'prod_UXymAw1t5Ut8Wu',
   true, false, 5),

  ('bundle',
   'Master Capital Access Architect — All 36 Certifications',
   'master-capital-access-architect',
   'Complete 36-certification bundle. The most comprehensive government lending curriculum available.',
   ARRAY['All 36 certifications','7 specialty tracks','Master credential','Save $3,000+'],
   ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36], 999700,
   'price_1TYsovPZzqlygATGmKM9fTn0', 'prod_UXymXWXGnSkrdZ',
   true, true, 6),

  ('org_license',
   'Organization License — Up to 5 Seats',
   'org-license-5-seats',
   'All 36 certifications for up to 5 staff members.',
   ARRAY['5 team seats','All 36 certifications','Admin dashboard','Progress tracking','Priority support'],
   ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36], 500000,
   'price_1TYsowPZzqlygATGPnQVWg55', 'prod_UXymI7dBKYUK8e',
   true, false, 7),

  ('dwu',
   'Done-With-You Application Support',
   'done-with-you-support',
   'Full curriculum access plus personalized application review and coaching.',
   ARRAY['All 36 certifications','Live coaching sessions','Application review','Submission support','Priority access'],
   ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36], 1000000,
   'price_1TYsoxPZzqlygATGdwM5gQAs', 'prod_UXymmpbptU8SIf',
   true, false, 8),

  ('subscription',
   'Annual Membership — Updates & Community Access',
   'annual-membership',
   'Annual membership: all curriculum updates, regulatory change alerts, alumni community, and monthly live Q&A.',
   ARRAY['All curriculum updates','Regulatory change alerts','Monthly live Q&A','Alumni community','$199/year'],
   ARRAY[], 19900,
   'price_1TYsoyPZzqlygATGnV84UtBe', 'prod_UXymPC9SVuvs0u',
   true, false, 9)

ON CONFLICT (slug) DO UPDATE SET
  stripe_price_id   = EXCLUDED.stripe_price_id,
  stripe_product_id = EXCLUDED.stripe_product_id,
  price_cents       = EXCLUDED.price_cents,
  cert_numbers      = EXCLUDED.cert_numbers,
  features          = EXCLUDED.features,
  is_active         = EXCLUDED.is_active,
  is_featured       = EXCLUDED.is_featured;

-- Step 4: Verify
SELECT cert_number, title, stripe_price_id IS NOT NULL AS has_stripe
FROM certifications ORDER BY cert_number;
