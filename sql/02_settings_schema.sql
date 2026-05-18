-- ============================================================
-- Cap Fund Academy — Admin Settings Schema
-- File: 02_settings_schema.sql
-- Idempotent: safe to re-run
-- ============================================================

CREATE TABLE IF NOT EXISTS admin_settings (
  id           uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  key          text UNIQUE NOT NULL,
  value        jsonb NOT NULL,
  description  text,
  updated_by   uuid REFERENCES profiles(id) ON DELETE SET NULL,
  updated_at   timestamptz NOT NULL DEFAULT now()
);

-- ---- RLS ----
ALTER TABLE admin_settings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "settings: admin read" ON admin_settings;
CREATE POLICY "settings: admin read"
  ON admin_settings FOR SELECT
  USING (get_my_role() IN ('super_admin', 'admin'));

DROP POLICY IF EXISTS "settings: admin write" ON admin_settings;
CREATE POLICY "settings: admin write"
  ON admin_settings FOR ALL
  USING (get_my_role() IN ('super_admin', 'admin'));

-- ---- Updated-at trigger ----
DROP TRIGGER IF EXISTS set_updated_at ON admin_settings;
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON admin_settings
  FOR EACH ROW EXECUTE FUNCTION tg_set_updated_at();

-- ============================================================
-- Seed default settings
-- ============================================================
INSERT INTO admin_settings (key, value, description) VALUES
  (
    'brand_name',
    '"Cap Fund Academy"',
    'Public brand name of the platform'
  ),
  (
    'support_email',
    '"support@capfundacademy.com"',
    'Primary support email address'
  ),
  (
    'disclaimer_text',
    '"Cap Fund Academy is an independent training and certification platform. It is not affiliated with, endorsed by, or certified by USDA or any government agency. Training is designed to help organizations understand and prepare for microlending, revolving loan funds, rural capital access programs, RMAP, RBDG, IRP, and related community finance best practices. Cap Fund Academy does not guarantee funding, eligibility, approval, or award decisions."',
    'Verbatim USDA non-affiliation disclaimer — displayed on all pages and Trust Center'
  ),
  (
    'pricing_single_cert_from',
    '497',
    'Starting price in USD for a single certificate purchase'
  ),
  (
    'pricing_library',
    '1997',
    'Price in USD for full Professional Library (all 17 certs)'
  ),
  (
    'pricing_org_license_from',
    '5000',
    'Starting price in USD for Organization License (up to 5 seats)'
  ),
  (
    'pricing_dwu_from',
    '10000',
    'Starting price in USD for Done-With-You application support package'
  ),
  (
    'ai_scoring_enabled',
    'true',
    'Feature flag: enable RMAP AI Scoring Engine'
  ),
  (
    'self_signup_enabled',
    'false',
    'Feature flag: allow public self-signup (admin creates users when false)'
  )
ON CONFLICT (key) DO NOTHING;
