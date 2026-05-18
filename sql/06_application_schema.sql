-- ============================================================
-- Cap Fund Academy — Application Workspace & AI Scoring Schema
-- File: 06_application_schema.sql
-- Idempotent: safe to re-run
-- Run after: 05_cert01_content.sql
-- ============================================================

DO $$ BEGIN
  CREATE TYPE program_type AS ENUM ('rmap','rbdg','irp','rlf_ops','legal_ogc','full_binder');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE readiness_level AS ENUM ('not_ready','emerging','competitive','strong','submission_ready');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE scoring_status AS ENUM ('pending','running','complete','failed');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- ============================================================
-- scoring_rubrics — one per program type, admin-editable
-- ============================================================
CREATE TABLE IF NOT EXISTS scoring_rubrics (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  program_type  program_type NOT NULL,
  version       text NOT NULL DEFAULT '1.0',
  title         text NOT NULL,
  description   text,
  max_points    integer NOT NULL DEFAULT 100,
  is_active     boolean NOT NULL DEFAULT true,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  UNIQUE (program_type, version)
);

-- ============================================================
-- scoring_criteria — individual scoring items per rubric
-- ============================================================
CREATE TABLE IF NOT EXISTS scoring_criteria (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  rubric_id       uuid NOT NULL REFERENCES scoring_rubrics(id) ON DELETE CASCADE,
  section_code    text NOT NULL,        -- e.g. '4280.316(a)', '4280.316(b)'
  section_label   text NOT NULL,        -- human label for this section
  criterion_code  text NOT NULL,        -- e.g. 'a1', 'b1i'
  criterion_label text NOT NULL,
  description     text,
  max_points      integer NOT NULL DEFAULT 0,
  point_bands     jsonb NOT NULL DEFAULT '[]', -- [{min_score, max_score, points, label}]
  evidence_hint   text,                -- what document/data is needed
  is_required     boolean NOT NULL DEFAULT true,
  sort_order      integer NOT NULL DEFAULT 0
);

-- ============================================================
-- application_workspaces — one per user per program application
-- ============================================================
CREATE TABLE IF NOT EXISTS application_workspaces (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id         uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  organization_id uuid REFERENCES organizations(id) ON DELETE SET NULL,
  program_type    program_type NOT NULL,
  title           text NOT NULL DEFAULT 'My Application',
  applicant_name  text,
  fiscal_year     integer,
  notes           text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- application_answers — answers keyed to scoring criteria
-- ============================================================
CREATE TABLE IF NOT EXISTS application_answers (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  workspace_id    uuid NOT NULL REFERENCES application_workspaces(id) ON DELETE CASCADE,
  criterion_id    uuid NOT NULL REFERENCES scoring_criteria(id) ON DELETE CASCADE,
  answer_text     text,
  answer_data     jsonb DEFAULT '{}',  -- for structured answers (numbers, lists)
  self_score      integer,            -- user's self-assessment
  updated_at      timestamptz NOT NULL DEFAULT now(),
  UNIQUE (workspace_id, criterion_id)
);

-- ============================================================
-- evidence_files — uploaded documents linked to a workspace
-- ============================================================
CREATE TABLE IF NOT EXISTS evidence_files (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  workspace_id    uuid NOT NULL REFERENCES application_workspaces(id) ON DELETE CASCADE,
  criterion_id    uuid REFERENCES scoring_criteria(id) ON DELETE SET NULL,
  user_id         uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  file_name       text NOT NULL,
  file_path       text NOT NULL,      -- Supabase Storage path
  file_size       bigint,
  mime_type       text,
  label           text,               -- user-assigned label
  uploaded_at     timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- scoring_runs — one per AI scoring request
-- ============================================================
CREATE TABLE IF NOT EXISTS scoring_runs (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  workspace_id    uuid NOT NULL REFERENCES application_workspaces(id) ON DELETE CASCADE,
  user_id         uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  rubric_id       uuid REFERENCES scoring_rubrics(id) ON DELETE SET NULL,
  status          scoring_status NOT NULL DEFAULT 'pending',
  model_used      text DEFAULT 'gpt-4o-mini',
  prompt_tokens   integer,
  completion_tokens integer,
  started_at      timestamptz NOT NULL DEFAULT now(),
  completed_at    timestamptz,
  error_message   text
);

-- ============================================================
-- scoring_results — structured output from a scoring run
-- ============================================================
CREATE TABLE IF NOT EXISTS scoring_results (
  id                      uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  run_id                  uuid NOT NULL REFERENCES scoring_runs(id) ON DELETE CASCADE UNIQUE,
  workspace_id            uuid NOT NULL REFERENCES application_workspaces(id) ON DELETE CASCADE,
  program_type            program_type NOT NULL,
  total_score_estimate    integer,
  max_possible_score      integer,
  readiness_level         readiness_level,
  section_scores          jsonb NOT NULL DEFAULT '{}',  -- {section_code: {score, max, pct}}
  strengths               text[] NOT NULL DEFAULT '{}',
  weaknesses              text[] NOT NULL DEFAULT '{}',
  missing_evidence        text[] NOT NULL DEFAULT '{}',
  risk_flags              text[] NOT NULL DEFAULT '{}',
  recommended_actions     text[] NOT NULL DEFAULT '{}',
  plain_english_summary   text,
  evidence_checklist      jsonb NOT NULL DEFAULT '[]', -- [{item, status, priority}]
  priority_fix_list       jsonb NOT NULL DEFAULT '[]', -- [{action, impact_points, effort}]
  ai_disclaimer           text NOT NULL DEFAULT 'AI scoring outputs are estimates based on publicly available USDA scoring criteria. Results are advisory only and do not represent USDA''s review or determination. Cap Fund Academy does not guarantee funding, eligibility, or approval.',
  created_at              timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- readiness_reports — saved printable reports
-- ============================================================
CREATE TABLE IF NOT EXISTS readiness_reports (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  workspace_id  uuid NOT NULL REFERENCES application_workspaces(id) ON DELETE CASCADE,
  run_id        uuid NOT NULL REFERENCES scoring_runs(id) ON DELETE CASCADE,
  user_id       uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title         text NOT NULL,
  created_at    timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- Triggers
-- ============================================================
DROP TRIGGER IF EXISTS set_updated_at ON scoring_rubrics;
CREATE TRIGGER set_updated_at BEFORE UPDATE ON scoring_rubrics FOR EACH ROW EXECUTE FUNCTION tg_set_updated_at();

DROP TRIGGER IF EXISTS set_updated_at ON application_workspaces;
CREATE TRIGGER set_updated_at BEFORE UPDATE ON application_workspaces FOR EACH ROW EXECUTE FUNCTION tg_set_updated_at();

-- ============================================================
-- RLS
-- ============================================================
ALTER TABLE scoring_rubrics         ENABLE ROW LEVEL SECURITY;
ALTER TABLE scoring_criteria        ENABLE ROW LEVEL SECURITY;
ALTER TABLE application_workspaces  ENABLE ROW LEVEL SECURITY;
ALTER TABLE application_answers     ENABLE ROW LEVEL SECURITY;
ALTER TABLE evidence_files          ENABLE ROW LEVEL SECURITY;
ALTER TABLE scoring_runs            ENABLE ROW LEVEL SECURITY;
ALTER TABLE scoring_results         ENABLE ROW LEVEL SECURITY;
ALTER TABLE readiness_reports       ENABLE ROW LEVEL SECURITY;

-- Rubrics: all auth can read active; admin can write
DROP POLICY IF EXISTS "rubrics_read"  ON scoring_rubrics;
DROP POLICY IF EXISTS "rubrics_write" ON scoring_rubrics;
CREATE POLICY "rubrics_read"  ON scoring_rubrics FOR SELECT USING (auth.uid() IS NOT NULL AND is_active = true);
CREATE POLICY "rubrics_write" ON scoring_rubrics FOR ALL   USING (get_my_role() IN ('super_admin','admin'));

-- Criteria: all auth can read; admin can write
DROP POLICY IF EXISTS "criteria_read"  ON scoring_criteria;
DROP POLICY IF EXISTS "criteria_write" ON scoring_criteria;
CREATE POLICY "criteria_read"  ON scoring_criteria FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY "criteria_write" ON scoring_criteria FOR ALL   USING (get_my_role() IN ('super_admin','admin'));

-- Workspaces: own + org members + admin
DROP POLICY IF EXISTS "workspaces_own"   ON application_workspaces;
DROP POLICY IF EXISTS "workspaces_admin" ON application_workspaces;
CREATE POLICY "workspaces_own"   ON application_workspaces FOR ALL    USING (user_id = auth.uid());
CREATE POLICY "workspaces_admin" ON application_workspaces FOR SELECT USING (get_my_role() IN ('super_admin','admin','instructor','reviewer'));

-- Answers: follow workspace ownership
DROP POLICY IF EXISTS "answers_own"   ON application_answers;
DROP POLICY IF EXISTS "answers_admin" ON application_answers;
CREATE POLICY "answers_own"   ON application_answers FOR ALL    USING (workspace_id IN (SELECT id FROM application_workspaces WHERE user_id = auth.uid()));
CREATE POLICY "answers_admin" ON application_answers FOR SELECT USING (get_my_role() IN ('super_admin','admin'));

-- Evidence files: own + admin
DROP POLICY IF EXISTS "evidence_own"   ON evidence_files;
DROP POLICY IF EXISTS "evidence_admin" ON evidence_files;
CREATE POLICY "evidence_own"   ON evidence_files FOR ALL    USING (user_id = auth.uid());
CREATE POLICY "evidence_admin" ON evidence_files FOR SELECT USING (get_my_role() IN ('super_admin','admin'));

-- Scoring runs: own + admin
DROP POLICY IF EXISTS "runs_own"   ON scoring_runs;
DROP POLICY IF EXISTS "runs_admin" ON scoring_runs;
CREATE POLICY "runs_own"   ON scoring_runs FOR ALL    USING (user_id = auth.uid());
CREATE POLICY "runs_admin" ON scoring_runs FOR SELECT USING (get_my_role() IN ('super_admin','admin'));

-- Scoring results: follow run ownership
DROP POLICY IF EXISTS "results_own"   ON scoring_results;
DROP POLICY IF EXISTS "results_admin" ON scoring_results;
CREATE POLICY "results_own"   ON scoring_results FOR ALL    USING (workspace_id IN (SELECT id FROM application_workspaces WHERE user_id = auth.uid()));
CREATE POLICY "results_admin" ON scoring_results FOR SELECT USING (get_my_role() IN ('super_admin','admin'));

-- Reports: own + admin
DROP POLICY IF EXISTS "reports_own"   ON readiness_reports;
DROP POLICY IF EXISTS "reports_admin" ON readiness_reports;
CREATE POLICY "reports_own"   ON readiness_reports FOR ALL    USING (user_id = auth.uid());
CREATE POLICY "reports_admin" ON readiness_reports FOR SELECT USING (get_my_role() IN ('super_admin','admin'));
