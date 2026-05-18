-- ============================================================
-- Cap Fund Academy — Content Engine Schema
-- File: 12_content_schema.sql
-- Idempotent: safe to re-run
-- Run after: 11_crm_schema.sql
-- ============================================================

DO $$ BEGIN
  CREATE TYPE content_status AS ENUM ('draft','review','approved','scheduled','published','archived','rejected');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE autopilot_level AS ENUM ('draft_only','approval_required','preapproved','paused');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- ============================================================
-- brand_voice_settings — single-row brand voice config
-- ============================================================
CREATE TABLE IF NOT EXISTS brand_voice_settings (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  tone            text NOT NULL DEFAULT 'professional, trustworthy, accessible, institutional',
  audience        text NOT NULL DEFAULT 'nonprofits, CDFIs, rural development organizations, consultants, and tribal entities interested in USDA rural capital programs',
  key_messages    text[] NOT NULL DEFAULT ARRAY[
    'Cap Fund Academy is an independent, self-funded training platform',
    'We prepare organizations to understand and apply for USDA rural capital programs',
    'Our training is educational — we do not guarantee funding or approval',
    'We align to publicly available federal criteria including 7 CFR 4280'
  ],
  avoid_phrases   text[] NOT NULL DEFAULT ARRAY[
    'USDA-certified','USDA-approved','USDA-endorsed','government-certified',
    'guaranteed funding','guarantee approval','ensure you get funded',
    'we will get you funded','100% approval rate','proven funding results'
  ],
  autopilot_level autopilot_level NOT NULL DEFAULT 'approval_required',
  updated_at      timestamptz NOT NULL DEFAULT now()
);

INSERT INTO brand_voice_settings (id) VALUES (uuid_generate_v4())
ON CONFLICT DO NOTHING;

-- ============================================================
-- forbidden_claims — compliance blocklist (admin-editable)
-- ============================================================
CREATE TABLE IF NOT EXISTS forbidden_claims (
  id          uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  phrase      text UNIQUE NOT NULL,
  reason      text,
  severity    text NOT NULL DEFAULT 'block',  -- 'block'|'warn'
  is_active   boolean NOT NULL DEFAULT true,
  created_at  timestamptz NOT NULL DEFAULT now()
);

INSERT INTO forbidden_claims (phrase, reason, severity) VALUES
  ('USDA-certified',        'Implies USDA endorsement — we are not a USDA-certified entity', 'block'),
  ('USDA certified',        'Implies USDA endorsement', 'block'),
  ('USDA-approved',         'Implies government approval of our training', 'block'),
  ('USDA approved',         'Implies government approval of our training', 'block'),
  ('USDA-endorsed',         'Implies government endorsement', 'block'),
  ('USDA endorsed',         'Implies government endorsement', 'block'),
  ('government-certified',  'Overly broad government endorsement claim', 'block'),
  ('guaranteed funding',    'No training can guarantee funding decisions', 'block'),
  ('guarantee approval',    'USDA approval decisions are solely USDA''s', 'block'),
  ('guarantee you will',    'Funding/approval guarantees are prohibited', 'block'),
  ('ensure you get funded', 'Implies funding outcome guarantee', 'block'),
  ('100% approval',         'Misleading funding success claim', 'block'),
  ('proven funding results','Implies outcome guarantee', 'block'),
  ('will get you funded',   'Direct funding guarantee', 'block'),
  ('USDA partner',          'May imply official partnership', 'warn'),
  ('affiliated with USDA',  'We are explicitly not affiliated with USDA', 'block'),
  ('certified by USDA',     'We are not certified by USDA', 'block'),
  ('official USDA',         'We have no official USDA relationship', 'block')
ON CONFLICT (phrase) DO NOTHING;

-- ============================================================
-- social_posts — individual content pieces
-- ============================================================
CREATE TABLE IF NOT EXISTS social_posts (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  created_by      uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  platform        text NOT NULL,   -- 'linkedin'|'facebook'|'instagram'|'twitter'|'tiktok_script'|'email_newsletter'|'blog'|'ad_copy'
  content_type    text NOT NULL,   -- 'post'|'carousel'|'reel_script'|'ad'|'blog'|'newsletter'|'faq'|'seo_meta'
  title           text,
  body            text NOT NULL,
  hashtags        text[],
  image_prompt    text,            -- AI image generation prompt
  utm_url         text,
  status          content_status NOT NULL DEFAULT 'draft',
  approved_by     uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  approved_at     timestamptz,
  rejection_note  text,
  scheduled_at    timestamptz,
  published_at    timestamptz,
  compliance_flags jsonb NOT NULL DEFAULT '[]',  -- [{phrase, severity}]
  compliance_passed boolean,
  ai_generated    boolean NOT NULL DEFAULT true,
  campaign_id     uuid,            -- FK added after content_campaigns created
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- content_campaigns — group posts by campaign
-- ============================================================
CREATE TABLE IF NOT EXISTS content_campaigns (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name          text NOT NULL,
  description   text,
  goal          text,    -- 'lead_gen'|'nurture'|'launch'|'awareness'
  start_date    date,
  end_date      date,
  status        text NOT NULL DEFAULT 'active',
  created_by    uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at    timestamptz NOT NULL DEFAULT now()
);

-- Add campaign FK after both tables exist
ALTER TABLE social_posts
  ADD CONSTRAINT IF NOT EXISTS social_posts_campaign_id_fkey
  FOREIGN KEY (campaign_id) REFERENCES content_campaigns(id) ON DELETE SET NULL;

-- ============================================================
-- ad_campaigns — paid advertising plans
-- ============================================================
CREATE TABLE IF NOT EXISTS ad_campaigns (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name            text NOT NULL,
  platform        text NOT NULL,   -- 'facebook'|'instagram'|'google'|'linkedin'
  objective       text,            -- 'traffic'|'leads'|'conversions'|'awareness'
  target_audience text,
  budget_daily    numeric(10,2),
  budget_total    numeric(10,2),
  utm_source      text,
  utm_medium      text DEFAULT 'paid',
  utm_campaign    text,
  landing_page    text,
  headline        text,
  body_copy       text,
  cta             text,
  status          text NOT NULL DEFAULT 'draft',
  approved_by     uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  approved_at     timestamptz,
  compliance_flags jsonb NOT NULL DEFAULT '[]',
  compliance_passed boolean,
  created_by      uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at      timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- Triggers
-- ============================================================
DROP TRIGGER IF EXISTS set_updated_at ON social_posts;
CREATE TRIGGER set_updated_at BEFORE UPDATE ON social_posts FOR EACH ROW EXECUTE FUNCTION tg_set_updated_at();

-- ============================================================
-- RLS
-- ============================================================
ALTER TABLE brand_voice_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE forbidden_claims     ENABLE ROW LEVEL SECURITY;
ALTER TABLE social_posts         ENABLE ROW LEVEL SECURITY;
ALTER TABLE content_campaigns    ENABLE ROW LEVEL SECURITY;
ALTER TABLE ad_campaigns         ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "bvs_read"  ON brand_voice_settings;
DROP POLICY IF EXISTS "bvs_write" ON brand_voice_settings;
CREATE POLICY "bvs_read"  ON brand_voice_settings FOR SELECT USING (get_my_role() IN ('super_admin','admin'));
CREATE POLICY "bvs_write" ON brand_voice_settings FOR ALL   USING (get_my_role() IN ('super_admin','admin'));

DROP POLICY IF EXISTS "claims_read"  ON forbidden_claims;
DROP POLICY IF EXISTS "claims_write" ON forbidden_claims;
CREATE POLICY "claims_read"  ON forbidden_claims FOR SELECT USING (get_my_role() IN ('super_admin','admin'));
CREATE POLICY "claims_write" ON forbidden_claims FOR ALL   USING (get_my_role() IN ('super_admin','admin'));

DROP POLICY IF EXISTS "posts_own"     ON social_posts;
DROP POLICY IF EXISTS "posts_admin"   ON social_posts;
DROP POLICY IF EXISTS "posts_approve" ON social_posts;
CREATE POLICY "posts_own"     ON social_posts FOR ALL    USING (created_by = auth.uid());
CREATE POLICY "posts_admin"   ON social_posts FOR SELECT USING (get_my_role() IN ('super_admin','admin'));
CREATE POLICY "posts_approve" ON social_posts FOR UPDATE USING (get_my_role() IN ('super_admin','admin','reviewer'));

DROP POLICY IF EXISTS "campaigns_admin" ON content_campaigns;
CREATE POLICY "campaigns_admin" ON content_campaigns FOR ALL USING (get_my_role() IN ('super_admin','admin'));

DROP POLICY IF EXISTS "ads_admin" ON ad_campaigns;
CREATE POLICY "ads_admin" ON ad_campaigns FOR ALL USING (get_my_role() IN ('super_admin','admin'));
