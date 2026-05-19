-- ============================================================
-- Cap Fund Academy — Specialty Tracks & Capstone Schema
-- File: 26_tracks_schema.sql
-- Run after: 03_lms_schema.sql
-- ============================================================

-- ── Credential ladder levels ──────────────────────────────────
CREATE TABLE IF NOT EXISTS credential_levels (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  level_number  int  NOT NULL UNIQUE,
  title         text NOT NULL,
  description   text,
  created_at    timestamptz DEFAULT now()
);

-- ── Specialty tracks ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS certification_tracks (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug          text NOT NULL UNIQUE,
  title         text NOT NULL,
  description   text,
  badge_label   text,
  cert_numbers  int[] NOT NULL DEFAULT '{}',
  sort_order    int  NOT NULL DEFAULT 0,
  status        text NOT NULL DEFAULT 'active' CHECK (status IN ('active','draft','archived')),
  created_at    timestamptz DEFAULT now()
);

-- ── Student track enrollment ──────────────────────────────────
CREATE TABLE IF NOT EXISTS student_track_enrollments (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  track_id      uuid NOT NULL REFERENCES certification_tracks(id) ON DELETE CASCADE,
  enrolled_at   timestamptz DEFAULT now(),
  completed_at  timestamptz,
  UNIQUE(user_id, track_id)
);

-- ── Capstone submissions ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS capstone_submissions (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  status            text NOT NULL DEFAULT 'draft'
                    CHECK (status IN ('draft','submitted','under_review','revision_requested','approved','rejected')),
  submitted_at      timestamptz,
  reviewed_at       timestamptz,
  reviewed_by       uuid REFERENCES auth.users(id),
  reviewer_notes    text,
  program_score     int,   -- 0-100
  compliance_score  int,
  application_score int,
  finance_score     int,
  artifacts_pass    boolean,
  defense_pass      boolean,
  final_approved    boolean DEFAULT false,
  created_at        timestamptz DEFAULT now(),
  updated_at        timestamptz DEFAULT now()
);

-- ── Capstone deliverables ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS capstone_deliverables (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  submission_id     uuid NOT NULL REFERENCES capstone_submissions(id) ON DELETE CASCADE,
  deliverable_number int NOT NULL,
  title             text NOT NULL,
  file_url          text,
  notes             text,
  status            text DEFAULT 'pending' CHECK (status IN ('pending','uploaded','reviewed','approved','rejected')),
  uploaded_at       timestamptz,
  created_at        timestamptz DEFAULT now()
);

-- ── RLS ───────────────────────────────────────────────────────
ALTER TABLE certification_tracks       ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_track_enrollments  ENABLE ROW LEVEL SECURITY;
ALTER TABLE capstone_submissions       ENABLE ROW LEVEL SECURITY;
ALTER TABLE capstone_deliverables      ENABLE ROW LEVEL SECURITY;

-- Public read for tracks
CREATE POLICY IF NOT EXISTS "tracks_public_read"
  ON certification_tracks FOR SELECT USING (status = 'active');

-- Students see own enrollments
CREATE POLICY IF NOT EXISTS "track_enrollments_own"
  ON student_track_enrollments FOR ALL USING (auth.uid() = user_id);

-- Students see own capstone
CREATE POLICY IF NOT EXISTS "capstone_own"
  ON capstone_submissions FOR ALL USING (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "capstone_deliverables_own"
  ON capstone_deliverables FOR ALL
  USING (EXISTS (
    SELECT 1 FROM capstone_submissions cs
    WHERE cs.id = submission_id AND cs.user_id = auth.uid()
  ));

-- ── Credential Levels Seed ────────────────────────────────────
INSERT INTO credential_levels (level_number, title, description)
VALUES
  (1, 'Capital Access Foundations Certificate',
   'Understand major lender models and capital access pathways.'),
  (2, 'Government Lending Program Associate',
   'Understand SBA, USDA, HUD, CDFI, EDA, EPA, and state/local programs.'),
  (3, 'Revolving Loan Fund & Relending Practitioner',
   'Learn how to design and operate loan funds and relending programs.'),
  (4, 'Government Lending & Capital Access Strategist',
   'Build program strategies and application-readiness systems.'),
  (5, 'Master Capital Access Architect',
   'Design a complete multi-lane capital access platform.')
ON CONFLICT (level_number) DO NOTHING;

-- ── Specialty Tracks Seed ─────────────────────────────────────
INSERT INTO certification_tracks (slug, title, description, badge_label, cert_numbers, sort_order, status)
VALUES
  ('microloan-rlf-builder',
   'Certified Microloan & Revolving Loan Fund Builder',
   'Master the full lifecycle of building, funding, launching, and sustaining a compliant microloan and revolving loan fund program using USDA RMAP, RBDG, IRP, and EDA pathways.',
   'Microloan & RLF Builder',
   ARRAY[18,19,1,2,3,4,5,6,7,30,8,9,11,22],
   1, 'active'),

  ('small-business-capital-specialist',
   'Certified Small Business Capital Access Specialist',
   'Navigate SBA, state capital access, and federal small business lending programs to connect entrepreneurs with the capital they need.',
   'Small Business Capital Specialist',
   ARRAY[20,21,29,8,9,36],
   2, 'active'),

  ('usda-rural-capital-specialist',
   'Certified USDA Rural Capital Specialist',
   'Become the go-to expert on the full USDA Rural Development lending ecosystem — from OneRD guarantees to RMAP relending, housing, and farm credit programs.',
   'USDA Rural Capital Specialist',
   ARRAY[22,1,2,3,4,5,6,7,23,24,22],
   3, 'active'),

  ('housing-capital-specialist',
   'Certified Housing Capital Access Specialist',
   'Build expertise across USDA, FHA, VA, HUD, and secondary market programs that fund affordable housing development, mortgage lending, and rural homeownership.',
   'Housing Capital Specialist',
   ARRAY[23,25,26,27,29],
   4, 'active'),

  ('cdfi-community-investment-specialist',
   'Certified CDFI & Community Investment Specialist',
   'Pursue CDFI certification, understand Treasury programs, leverage NMTC and Capital Magnet Fund, and build a mission-driven community investment vehicle.',
   'CDFI & Community Investment Specialist',
   ARRAY[28,29,30,36,11],
   5, 'active'),

  ('infrastructure-environmental-specialist',
   'Certified Infrastructure & Environmental Finance Specialist',
   'Finance broadband, energy, water, environmental cleanup, and transportation infrastructure through USDA, EPA, DOE, and DOT capital programs.',
   'Infrastructure & Environmental Specialist',
   ARRAY[31,32,22,36,22],
   6, 'active'),

  ('tribal-capital-specialist',
   'Certified Tribal Capital Access Specialist',
   'Navigate BIA, HUD Section 184, Native CDFI, tribal SSBCI, and DOE energy loan guarantee programs to build capital access strategies for tribal communities.',
   'Tribal Capital Specialist',
   ARRAY[34,28,25,32,36],
   7, 'active')

ON CONFLICT (slug) DO UPDATE SET
  title        = EXCLUDED.title,
  description  = EXCLUDED.description,
  badge_label  = EXCLUDED.badge_label,
  cert_numbers = EXCLUDED.cert_numbers,
  sort_order   = EXCLUDED.sort_order;
