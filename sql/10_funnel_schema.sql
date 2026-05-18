-- ============================================================
-- Cap Fund Academy — Lead Funnel Schema
-- File: 10_funnel_schema.sql
-- Idempotent: safe to re-run
-- Run after: 09_commerce_schema.sql
-- ============================================================

-- Extend leads table with funnel fields
ALTER TABLE public.leads
  ADD COLUMN IF NOT EXISTS quiz_score     integer,
  ADD COLUMN IF NOT EXISTS result_tag     text,
  ADD COLUMN IF NOT EXISTS funnel_stage   text NOT NULL DEFAULT 'lead',
  ADD COLUMN IF NOT EXISTS utm_content    text,
  ADD COLUMN IF NOT EXISTS referrer       text,
  ADD COLUMN IF NOT EXISTS last_activity  timestamptz NOT NULL DEFAULT now();

-- ============================================================
-- public_quiz_questions — the 12-question RLF Readiness Quiz
-- (separate from LMS quiz_questions — this is public/ungated)
-- ============================================================
CREATE TABLE IF NOT EXISTS public_quiz_questions (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  question_text text NOT NULL,
  options       jsonb NOT NULL DEFAULT '[]',  -- [{id, text, points}]
  sort_order    integer NOT NULL DEFAULT 0,
  category      text,                          -- for result segmentation
  is_active     boolean NOT NULL DEFAULT true
);

-- ============================================================
-- quiz_responses — stores each completed public quiz
-- ============================================================
CREATE TABLE IF NOT EXISTS quiz_responses (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  lead_id       uuid REFERENCES leads(id) ON DELETE SET NULL,
  email         text,
  name          text,
  organization  text,
  answers       jsonb NOT NULL DEFAULT '{}',  -- {question_id: option_id}
  score         integer NOT NULL DEFAULT 0,
  max_score     integer NOT NULL DEFAULT 100,
  result_tag    text,    -- 'beginner'|'developing'|'ready'|'advanced'
  created_at    timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- funnel_pages — admin-editable sales/VSL/thank-you pages
-- ============================================================
CREATE TABLE IF NOT EXISTS funnel_pages (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  slug          text UNIQUE NOT NULL,
  page_type     text NOT NULL DEFAULT 'sales',  -- sales|vsl|webinar|thank_you|lead_magnet
  title         text NOT NULL,
  headline      text,
  subheadline   text,
  body_blocks   jsonb NOT NULL DEFAULT '[]',    -- [{type, content}]
  cta_text      text,
  cta_url       text,
  offer_id      uuid REFERENCES offers(id) ON DELETE SET NULL,
  video_url     text,   -- YouTube/Vimeo embed URL
  is_active     boolean NOT NULL DEFAULT true,
  meta_title    text,
  meta_desc     text,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- email_sequences — define automated sequences
-- ============================================================
CREATE TABLE IF NOT EXISTS email_sequences (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name          text NOT NULL,
  trigger_event text NOT NULL,  -- 'quiz_complete'|'checklist_download'|'purchase'|'abandoned_checkout'|'welcome'
  result_tag    text,           -- filter by quiz result tag (null = all)
  is_active     boolean NOT NULL DEFAULT true,
  created_at    timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- email_sequence_steps — individual emails in a sequence
-- ============================================================
CREATE TABLE IF NOT EXISTS email_sequence_steps (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  sequence_id   uuid NOT NULL REFERENCES email_sequences(id) ON DELETE CASCADE,
  step_number   integer NOT NULL DEFAULT 1,
  delay_hours   integer NOT NULL DEFAULT 0,  -- hours after trigger
  subject       text NOT NULL,
  body_html     text NOT NULL,
  from_name     text NOT NULL DEFAULT 'Cap Fund Academy',
  from_email    text NOT NULL DEFAULT 'support@capfundacademy.com',
  is_active     boolean NOT NULL DEFAULT true
);

-- ============================================================
-- email_sends — log of sent emails
-- ============================================================
CREATE TABLE IF NOT EXISTS email_sends (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  lead_id       uuid REFERENCES leads(id) ON DELETE SET NULL,
  user_id       uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  sequence_id   uuid REFERENCES email_sequences(id) ON DELETE SET NULL,
  step_id       uuid REFERENCES email_sequence_steps(id) ON DELETE SET NULL,
  to_email      text NOT NULL,
  subject       text NOT NULL,
  status        text NOT NULL DEFAULT 'sent',  -- sent|failed|opened|clicked
  sent_at       timestamptz NOT NULL DEFAULT now(),
  provider_id   text   -- Resend message ID
);

-- ============================================================
-- Triggers
-- ============================================================
DROP TRIGGER IF EXISTS set_updated_at ON funnel_pages;
CREATE TRIGGER set_updated_at BEFORE UPDATE ON funnel_pages FOR EACH ROW EXECUTE FUNCTION tg_set_updated_at();

-- ============================================================
-- RLS
-- ============================================================
ALTER TABLE public_quiz_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_responses         ENABLE ROW LEVEL SECURITY;
ALTER TABLE funnel_pages           ENABLE ROW LEVEL SECURITY;
ALTER TABLE email_sequences        ENABLE ROW LEVEL SECURITY;
ALTER TABLE email_sequence_steps   ENABLE ROW LEVEL SECURITY;
ALTER TABLE email_sends            ENABLE ROW LEVEL SECURITY;

-- Public quiz questions: anyone can read active ones
DROP POLICY IF EXISTS "quiz_q_public"  ON public_quiz_questions;
DROP POLICY IF EXISTS "quiz_q_admin"   ON public_quiz_questions;
CREATE POLICY "quiz_q_public" ON public_quiz_questions FOR SELECT USING (is_active = true);
CREATE POLICY "quiz_q_admin"  ON public_quiz_questions FOR ALL   USING (get_my_role() IN ('super_admin','admin'));

-- Quiz responses: anon insert (public quiz), admin read all
DROP POLICY IF EXISTS "quiz_resp_insert" ON quiz_responses;
DROP POLICY IF EXISTS "quiz_resp_admin"  ON quiz_responses;
CREATE POLICY "quiz_resp_insert" ON quiz_responses FOR INSERT WITH CHECK (true);
CREATE POLICY "quiz_resp_admin"  ON quiz_responses FOR SELECT USING (get_my_role() IN ('super_admin','admin'));

-- Funnel pages: active ones public-readable
DROP POLICY IF EXISTS "funnel_read"  ON funnel_pages;
DROP POLICY IF EXISTS "funnel_write" ON funnel_pages;
CREATE POLICY "funnel_read"  ON funnel_pages FOR SELECT USING (is_active = true OR get_my_role() IN ('super_admin','admin'));
CREATE POLICY "funnel_write" ON funnel_pages FOR ALL   USING (get_my_role() IN ('super_admin','admin'));

-- Email sequences: admin only
DROP POLICY IF EXISTS "seq_admin"  ON email_sequences;
DROP POLICY IF EXISTS "step_admin" ON email_sequence_steps;
DROP POLICY IF EXISTS "send_admin" ON email_sends;
CREATE POLICY "seq_admin"  ON email_sequences       FOR ALL USING (get_my_role() IN ('super_admin','admin'));
CREATE POLICY "step_admin" ON email_sequence_steps  FOR ALL USING (get_my_role() IN ('super_admin','admin'));
CREATE POLICY "send_admin" ON email_sends           FOR ALL USING (get_my_role() IN ('super_admin','admin'));

-- ============================================================
-- Seed: 12-question RLF Readiness Quiz
-- ============================================================
INSERT INTO public_quiz_questions (question_text, options, sort_order, category)
VALUES
(
  'What type of organization are you?',
  '[
    {"id":"a","text":"Nonprofit / 501(c)(3)","points":10},
    {"id":"b","text":"Government / Public entity","points":10},
    {"id":"c","text":"Federally-recognized Indian tribe","points":10},
    {"id":"d","text":"CDFI (Community Development Financial Institution)","points":10},
    {"id":"e","text":"Consultant / Technical Assistance provider","points":5},
    {"id":"f","text":"For-profit or individual","points":0}
  ]', 1, 'eligibility'
),
(
  'What is your primary goal?',
  '[
    {"id":"a","text":"Apply for USDA RMAP funds (microloan program)","points":10},
    {"id":"b","text":"Apply for USDA RBDG (rural business development grant)","points":10},
    {"id":"c","text":"Set up or improve a revolving loan fund","points":9},
    {"id":"d","text":"Help clients understand and apply for rural capital programs","points":8},
    {"id":"e","text":"Just learning — exploring options","points":3}
  ]', 2, 'intent'
),
(
  'Does your organization primarily serve rural areas (areas not in cities over 50,000 people)?',
  '[
    {"id":"a","text":"Yes — we serve primarily rural communities","points":10},
    {"id":"b","text":"We serve a mix of rural and urban areas","points":6},
    {"id":"c","text":"Mostly urban — but some rural clients","points":2},
    {"id":"d","text":"We are not sure of the USDA definition of rural","points":1}
  ]', 3, 'eligibility'
),
(
  'Have you ever applied for a USDA rural capital program?',
  '[
    {"id":"a","text":"Yes — we have received USDA funding before","points":10},
    {"id":"b","text":"Yes — we applied but were not funded","points":7},
    {"id":"c","text":"We started an application but did not submit","points":4},
    {"id":"d","text":"No — this would be our first application","points":2}
  ]', 4, 'experience'
),
(
  'Do you have written loan policies and procedures?',
  '[
    {"id":"a","text":"Yes — comprehensive written policies covering underwriting, servicing, and collections","points":10},
    {"id":"b","text":"Partial — some written policies but gaps exist","points":6},
    {"id":"c","text":"In development — working on them now","points":3},
    {"id":"d","text":"No written loan policies","points":0}
  ]', 5, 'operations'
),
(
  'Do you have 3 years of organizational financial statements?',
  '[
    {"id":"a","text":"Yes — audited financial statements for 3+ years","points":10},
    {"id":"b","text":"Yes — reviewed or compiled (not audited) for 3 years","points":7},
    {"id":"c","text":"Only 1–2 years of financial history","points":4},
    {"id":"d","text":"We are a new organization — less than 1 year","points":0}
  ]', 6, 'financial'
),
(
  'Do you provide technical assistance (TA) or training to small businesses or entrepreneurs?',
  '[
    {"id":"a","text":"Yes — we have an active, documented TA program with measurable outcomes","points":10},
    {"id":"b","text":"Some informal TA — we help clients but do not document outcomes well","points":6},
    {"id":"c","text":"We are planning to develop a TA program","points":3},
    {"id":"d","text":"No — we do not provide TA","points":0}
  ]', 7, 'operations'
),
(
  'What is your organization''s annual budget?',
  '[
    {"id":"a","text":"Over $1 million","points":10},
    {"id":"b","text":"$250,000 – $1 million","points":8},
    {"id":"c","text":"$100,000 – $249,999","points":5},
    {"id":"d","text":"Under $100,000","points":2}
  ]', 8, 'financial'
),
(
  'Do you have experience managing federal grants or federally-backed loans?',
  '[
    {"id":"a","text":"Yes — extensive experience with federal programs and 2 CFR 200 compliance","points":10},
    {"id":"b","text":"Some experience — managed at least one federal grant or loan","points":7},
    {"id":"c","text":"Limited — familiar with requirements but no direct experience","points":3},
    {"id":"d","text":"No — this would be our first federal program","points":0}
  ]', 9, 'compliance'
),
(
  'Do you have a loan committee or formal board oversight for lending decisions?',
  '[
    {"id":"a","text":"Yes — a formal loan committee with documented authority and conflict-of-interest policy","points":10},
    {"id":"b","text":"Board oversight exists but no dedicated loan committee","points":6},
    {"id":"c","text":"Informal oversight — planning to formalize","points":3},
    {"id":"d","text":"No structured oversight for lending decisions","points":0}
  ]', 10, 'governance'
),
(
  'What is your timeline for applying for USDA funding?',
  '[
    {"id":"a","text":"Now or next application cycle","points":10},
    {"id":"b","text":"6–12 months from now","points":7},
    {"id":"c","text":"1–2 years — building capacity first","points":4},
    {"id":"d","text":"Just exploring — no firm timeline","points":1}
  ]', 11, 'intent'
),
(
  'What is your biggest challenge with USDA rural capital programs?',
  '[
    {"id":"a","text":"Understanding eligibility requirements","points":5},
    {"id":"b","text":"Assembling the required documentation","points":6},
    {"id":"c","text":"Understanding how scoring works and how to be competitive","points":7},
    {"id":"d","text":"Compliance and reporting after award","points":8},
    {"id":"e","text":"All of the above — the whole process is overwhelming","points":4}
  ]', 12, 'intent'
)
ON CONFLICT DO NOTHING;

-- Seed default funnel pages
INSERT INTO funnel_pages (slug, page_type, title, headline, subheadline, cta_text, cta_url, video_url)
VALUES
(
  'rmap-readiness-quiz', 'lead_magnet',
  'Free RLF Readiness Quiz',
  'Is Your Organization Ready for USDA Rural Funding?',
  'Take our 12-question quiz to find out exactly where you stand — and what to do next.',
  'Take the Free Quiz →', '#quiz', NULL
),
(
  'rmap-checklist', 'lead_magnet',
  'Free RMAP Evidence Checklist',
  'Download the Free RMAP Application Checklist',
  'Know exactly what USDA reviewers look for. Get the complete evidence checklist mapped to 7 CFR 4280.316 scoring criteria.',
  'Get the Free Checklist →', '#checklist', NULL
),
(
  'webinar', 'vsl',
  'Free Training: How to Build a USDA-Ready Microlending Program',
  'Watch the Free Training',
  'Learn the 5 steps to becoming a competitive RMAP applicant — from eligibility to scoring to submission.',
  'Watch Now →', '#video', 'https://www.youtube.com/embed/dQw4w9WgXcQ'
)
ON CONFLICT (slug) DO NOTHING;
