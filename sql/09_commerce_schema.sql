-- ============================================================
-- Cap Fund Academy — Commerce Schema
-- File: 09_commerce_schema.sql
-- Idempotent: safe to re-run
-- Run after: 08_rbdg_irp_rubric_seed.sql
-- ============================================================

DO $$ BEGIN
  CREATE TYPE offer_type AS ENUM ('single_cert','bundle','org_license','subscription','dwu');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE order_status AS ENUM ('pending','paid','refunded','failed','cancelled');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE subscription_status AS ENUM ('active','past_due','cancelled','trialing','unpaid');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- ============================================================
-- offers — admin-editable product catalog
-- ============================================================
CREATE TABLE IF NOT EXISTS offers (
  id                  uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  offer_type          offer_type NOT NULL,
  title               text NOT NULL,
  slug                text UNIQUE NOT NULL,
  description         text,
  features            text[] NOT NULL DEFAULT '{}',
  cert_numbers        integer[] NOT NULL DEFAULT '{}',  -- which certs are included
  price_cents         integer NOT NULL,                 -- default price in cents USD
  stripe_price_id     text,                             -- Stripe Price object ID
  stripe_product_id   text,                             -- Stripe Product object ID
  seat_limit          integer NOT NULL DEFAULT 1,       -- for org licenses
  is_active           boolean NOT NULL DEFAULT true,
  is_featured         boolean NOT NULL DEFAULT false,
  sort_order          integer NOT NULL DEFAULT 0,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- coupons — discount codes
-- ============================================================
CREATE TABLE IF NOT EXISTS coupons (
  id                  uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  code                text UNIQUE NOT NULL,
  description         text,
  discount_type       text NOT NULL DEFAULT 'percent',  -- 'percent' | 'fixed'
  discount_value      integer NOT NULL,                 -- % or cents
  max_uses            integer,
  uses_count          integer NOT NULL DEFAULT 0,
  expires_at          timestamptz,
  applies_to_offer_ids uuid[] DEFAULT NULL,             -- NULL = all offers
  stripe_coupon_id    text,
  is_active           boolean NOT NULL DEFAULT true,
  created_at          timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- orders — one-time purchase records
-- ============================================================
CREATE TABLE IF NOT EXISTS orders (
  id                    uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id               uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  organization_id       uuid REFERENCES organizations(id) ON DELETE SET NULL,
  offer_id              uuid NOT NULL REFERENCES offers(id) ON DELETE RESTRICT,
  coupon_id             uuid REFERENCES coupons(id) ON DELETE SET NULL,
  status                order_status NOT NULL DEFAULT 'pending',
  amount_cents          integer NOT NULL,
  amount_refunded_cents integer NOT NULL DEFAULT 0,
  currency              text NOT NULL DEFAULT 'usd',
  stripe_session_id     text UNIQUE,
  stripe_payment_intent text,
  stripe_customer_id    text,
  metadata              jsonb NOT NULL DEFAULT '{}',
  created_at            timestamptz NOT NULL DEFAULT now(),
  updated_at            timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- subscriptions — recurring billing
-- ============================================================
CREATE TABLE IF NOT EXISTS subscriptions (
  id                    uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id               uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  organization_id       uuid REFERENCES organizations(id) ON DELETE SET NULL,
  offer_id              uuid REFERENCES offers(id) ON DELETE SET NULL,
  status                subscription_status NOT NULL DEFAULT 'active',
  stripe_subscription_id text UNIQUE NOT NULL,
  stripe_customer_id    text,
  current_period_start  timestamptz,
  current_period_end    timestamptz,
  cancelled_at          timestamptz,
  created_at            timestamptz NOT NULL DEFAULT now(),
  updated_at            timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- enrollments — which users have access to which certs
-- ============================================================
CREATE TABLE IF NOT EXISTS enrollments (
  id                uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id           uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  certification_id  uuid REFERENCES certifications(id) ON DELETE CASCADE,
  order_id          uuid REFERENCES orders(id) ON DELETE SET NULL,
  organization_id   uuid REFERENCES organizations(id) ON DELETE SET NULL,
  enrolled_at       timestamptz NOT NULL DEFAULT now(),
  expires_at        timestamptz,
  granted_by        text NOT NULL DEFAULT 'purchase',  -- 'purchase'|'admin'|'org_seat'
  UNIQUE (user_id, certification_id)
);

-- ============================================================
-- organization_seats — seat management for org licenses
-- ============================================================
CREATE TABLE IF NOT EXISTS organization_seats (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id uuid NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  order_id        uuid REFERENCES orders(id) ON DELETE SET NULL,
  offer_id        uuid NOT NULL REFERENCES offers(id) ON DELETE RESTRICT,
  total_seats     integer NOT NULL DEFAULT 5,
  used_seats      integer NOT NULL DEFAULT 0,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- seat_invitations — org inviting members
-- ============================================================
CREATE TABLE IF NOT EXISTS seat_invitations (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id uuid NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  invited_by      uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  email           text NOT NULL,
  token           text UNIQUE NOT NULL DEFAULT encode(gen_random_bytes(24), 'hex'),
  status          text NOT NULL DEFAULT 'pending',  -- pending|accepted|expired
  expires_at      timestamptz NOT NULL DEFAULT now() + interval '7 days',
  accepted_at     timestamptz,
  created_at      timestamptz NOT NULL DEFAULT now(),
  UNIQUE (organization_id, email)
);

-- ============================================================
-- stripe_events — idempotency log for webhook events
-- ============================================================
CREATE TABLE IF NOT EXISTS stripe_events (
  id          text PRIMARY KEY,   -- Stripe event ID (evt_xxx)
  type        text NOT NULL,
  processed   boolean NOT NULL DEFAULT false,
  payload     jsonb,
  error       text,
  created_at  timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- Triggers
-- ============================================================
DROP TRIGGER IF EXISTS set_updated_at ON offers;
CREATE TRIGGER set_updated_at BEFORE UPDATE ON offers FOR EACH ROW EXECUTE FUNCTION tg_set_updated_at();

DROP TRIGGER IF EXISTS set_updated_at ON orders;
CREATE TRIGGER set_updated_at BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION tg_set_updated_at();

DROP TRIGGER IF EXISTS set_updated_at ON subscriptions;
CREATE TRIGGER set_updated_at BEFORE UPDATE ON subscriptions FOR EACH ROW EXECUTE FUNCTION tg_set_updated_at();

DROP TRIGGER IF EXISTS set_updated_at ON organization_seats;
CREATE TRIGGER set_updated_at BEFORE UPDATE ON organization_seats FOR EACH ROW EXECUTE FUNCTION tg_set_updated_at();

-- ============================================================
-- RLS
-- ============================================================
ALTER TABLE offers             ENABLE ROW LEVEL SECURITY;
ALTER TABLE coupons            ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders             ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions      ENABLE ROW LEVEL SECURITY;
ALTER TABLE enrollments        ENABLE ROW LEVEL SECURITY;
ALTER TABLE organization_seats ENABLE ROW LEVEL SECURITY;
ALTER TABLE seat_invitations   ENABLE ROW LEVEL SECURITY;
ALTER TABLE stripe_events      ENABLE ROW LEVEL SECURITY;

-- Offers: active ones public-readable; admin writes
DROP POLICY IF EXISTS "offers_read"  ON offers;
DROP POLICY IF EXISTS "offers_write" ON offers;
CREATE POLICY "offers_read"  ON offers FOR SELECT USING (is_active = true OR get_my_role() IN ('super_admin','admin'));
CREATE POLICY "offers_write" ON offers FOR ALL   USING (get_my_role() IN ('super_admin','admin'));

-- Coupons: admin only
DROP POLICY IF EXISTS "coupons_admin" ON coupons;
CREATE POLICY "coupons_admin" ON coupons FOR ALL USING (get_my_role() IN ('super_admin','admin'));

-- Orders: own + admin
DROP POLICY IF EXISTS "orders_own"   ON orders;
DROP POLICY IF EXISTS "orders_admin" ON orders;
CREATE POLICY "orders_own"   ON orders FOR ALL    USING (user_id = auth.uid());
CREATE POLICY "orders_admin" ON orders FOR SELECT USING (get_my_role() IN ('super_admin','admin'));

-- Subscriptions: own + admin
DROP POLICY IF EXISTS "subs_own"   ON subscriptions;
DROP POLICY IF EXISTS "subs_admin" ON subscriptions;
CREATE POLICY "subs_own"   ON subscriptions FOR ALL    USING (user_id = auth.uid());
CREATE POLICY "subs_admin" ON subscriptions FOR SELECT USING (get_my_role() IN ('super_admin','admin'));

-- Enrollments: own + org members + admin
DROP POLICY IF EXISTS "enrollments_own"   ON enrollments;
DROP POLICY IF EXISTS "enrollments_admin" ON enrollments;
CREATE POLICY "enrollments_own"   ON enrollments FOR ALL    USING (user_id = auth.uid());
CREATE POLICY "enrollments_admin" ON enrollments FOR SELECT USING (get_my_role() IN ('super_admin','admin','instructor'));

-- Org seats: org members + admin
DROP POLICY IF EXISTS "seats_org"   ON organization_seats;
DROP POLICY IF EXISTS "seats_admin" ON organization_seats;
CREATE POLICY "seats_org"   ON organization_seats FOR SELECT USING (organization_id IN (SELECT organization_id FROM organization_members WHERE user_id = auth.uid()));
CREATE POLICY "seats_admin" ON organization_seats FOR ALL   USING (get_my_role() IN ('super_admin','admin'));

-- Seat invitations: org owner/manager + admin
DROP POLICY IF EXISTS "invitations_org"   ON seat_invitations;
DROP POLICY IF EXISTS "invitations_admin" ON seat_invitations;
CREATE POLICY "invitations_org"   ON seat_invitations FOR ALL USING (organization_id IN (SELECT id FROM organizations WHERE owner_id = auth.uid()) OR invited_by = auth.uid());
CREATE POLICY "invitations_admin" ON seat_invitations FOR ALL USING (get_my_role() IN ('super_admin','admin'));

-- Stripe events: admin only
DROP POLICY IF EXISTS "stripe_events_admin" ON stripe_events;
CREATE POLICY "stripe_events_admin" ON stripe_events FOR ALL USING (get_my_role() IN ('super_admin','admin'));

-- ============================================================
-- Seed default offers (admin-editable after deploy)
-- ============================================================
INSERT INTO offers (offer_type, title, slug, description, features, cert_numbers, price_cents, seat_limit, is_featured, sort_order)
VALUES
  ('single_cert', 'Single Certification', 'single-cert',
   'One standalone certification of your choice.',
   ARRAY['Full lesson content','Knowledge check quiz','Required artifact template','Certificate of completion','Lifetime access'],
   ARRAY[]::integer[], 49700, 1, false, 10),

  ('bundle', 'Professional Library', 'professional-library',
   'All 17 certifications, self-paced, lifetime access.',
   ARRAY['All 17 certifications','Full lesson content for every cert','AI scoring engine access','All artifact templates','Priority support','Lifetime access'],
   ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17], 199700, 1, true, 20),

  ('bundle', 'Rural Microfinance Associate', 'rma-bundle',
   'Certifications 1–4: the Foundation track.',
   ARRAY['Cert 1: Microfinance Foundations','Cert 2: RLF Design','Cert 3: RMAP Application & Scoring','Cert 4: RMAP Operations','Foundation credential','Lifetime access'],
   ARRAY[1,2,3,4], 99700, 1, false, 30),

  ('bundle', 'RLF Practitioner Bundle', 'rlf-practitioner',
   'Certifications 1–9: Foundation + Practitioner tracks.',
   ARRAY['All Foundation certs (1-4)','Cert 5: RMAP TA Program','Cert 6: RBDG','Cert 7: IRP Strategy','Cert 8: Underwriting','Cert 9: Loan Servicing','RLF Practitioner credential'],
   ARRAY[1,2,3,4,5,6,7,8,9], 149700, 1, false, 40),

  ('org_license', 'Organization License', 'org-license',
   'Up to 5 seats for your team. Includes all 17 certifications and the AI scoring engine.',
   ARRAY['5 team seats','All 17 certifications','AI scoring engine for each seat','Admin dashboard','Member progress tracking','Priority support','Annual updates'],
   ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17], 500000, 5, false, 50),

  ('dwu', 'Done-With-You Application Support', 'dwu-support',
   'Expert-guided RMAP or RBDG application preparation with AI scoring and human review.',
   ARRAY['Full Professional Library access','Dedicated application workspace','AI scoring with human review overlay','Application binder assembly support','Strategy calls via scheduling link','Priority email support'],
   ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17], 1000000, 1, false, 60)
ON CONFLICT (slug) DO NOTHING;
