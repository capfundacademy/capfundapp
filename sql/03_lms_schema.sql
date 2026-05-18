-- ============================================================
-- Cap Fund Academy — LMS Core Schema
-- File: 03_lms_schema.sql
-- Idempotent: safe to re-run
-- Run after: 01_base_schema.sql, 02_settings_schema.sql
-- ============================================================

-- ============================================================
-- Enums
-- ============================================================
DO $$ BEGIN
  CREATE TYPE draft_status AS ENUM ('draft', 'review', 'approved', 'archived');
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  CREATE TYPE resource_type AS ENUM ('pdf', 'template', 'checklist', 'video', 'link');
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  CREATE TYPE progress_status AS ENUM ('not_started', 'in_progress', 'completed');
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  CREATE TYPE submission_status AS ENUM ('pending', 'approved', 'rejected');
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

-- ============================================================
-- certifications
-- ============================================================
CREATE TABLE IF NOT EXISTS certifications (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  cert_number     integer UNIQUE NOT NULL,
  title           text NOT NULL,
  slug            text UNIQUE NOT NULL,
  description     text,
  learning_outcomes text[],
  hours_min       integer,
  hours_max       integer,
  price_default   numeric(10,2),
  status          draft_status NOT NULL DEFAULT 'draft',
  sort_order      integer NOT NULL DEFAULT 0,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- modules
-- ============================================================
CREATE TABLE IF NOT EXISTS modules (
  id                uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  certification_id  uuid NOT NULL REFERENCES certifications(id) ON DELETE CASCADE,
  title             text NOT NULL,
  description       text,
  sort_order        integer NOT NULL DEFAULT 0,
  status            draft_status NOT NULL DEFAULT 'draft',
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- lessons
-- ============================================================
CREATE TABLE IF NOT EXISTS lessons (
  id                uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  module_id         uuid NOT NULL REFERENCES modules(id) ON DELETE CASCADE,
  title             text NOT NULL,
  slug              text NOT NULL,
  content           text,
  summary           text,
  read_time_minutes integer,
  sort_order        integer NOT NULL DEFAULT 0,
  status            draft_status NOT NULL DEFAULT 'draft',
  reviewed_by       uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  reviewed_at       timestamptz,
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- lesson_resources
-- ============================================================
CREATE TABLE IF NOT EXISTS lesson_resources (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  lesson_id     uuid NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  title         text NOT NULL,
  url           text NOT NULL,
  resource_type resource_type NOT NULL DEFAULT 'link',
  sort_order    integer NOT NULL DEFAULT 0
);

-- ============================================================
-- quizzes
-- ============================================================
CREATE TABLE IF NOT EXISTS quizzes (
  id                  uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  certification_id    uuid NOT NULL REFERENCES certifications(id) ON DELETE CASCADE,
  title               text NOT NULL,
  passing_score       integer NOT NULL DEFAULT 80,
  time_limit_minutes  integer,
  status              draft_status NOT NULL DEFAULT 'draft',
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- quiz_questions
-- ============================================================
CREATE TABLE IF NOT EXISTS quiz_questions (
  id                uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  quiz_id           uuid NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
  question_text     text NOT NULL,
  options           jsonb NOT NULL DEFAULT '[]',
  correct_option_id text NOT NULL,
  explanation       text,
  sort_order        integer NOT NULL DEFAULT 0
);

-- ============================================================
-- quiz_attempts
-- ============================================================
CREATE TABLE IF NOT EXISTS quiz_attempts (
  id                uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id           uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  quiz_id           uuid NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
  certification_id  uuid NOT NULL REFERENCES certifications(id) ON DELETE CASCADE,
  answers           jsonb NOT NULL DEFAULT '{}',
  score             integer,
  passed            boolean,
  started_at        timestamptz NOT NULL DEFAULT now(),
  completed_at      timestamptz
);

-- ============================================================
-- student_progress
-- ============================================================
CREATE TABLE IF NOT EXISTS student_progress (
  id                uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id           uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  certification_id  uuid NOT NULL REFERENCES certifications(id) ON DELETE CASCADE,
  lesson_id         uuid REFERENCES lessons(id) ON DELETE CASCADE,
  status            progress_status NOT NULL DEFAULT 'not_started',
  completed_at      timestamptz,
  UNIQUE (user_id, lesson_id)
);

-- ============================================================
-- certification_completions
-- ============================================================
CREATE TABLE IF NOT EXISTS certification_completions (
  id                   uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id              uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  certification_id     uuid NOT NULL REFERENCES certifications(id) ON DELETE CASCADE,
  quiz_attempt_id      uuid REFERENCES quiz_attempts(id) ON DELETE SET NULL,
  artifact_submitted   boolean NOT NULL DEFAULT false,
  completed_at         timestamptz NOT NULL DEFAULT now(),
  certificate_number   text UNIQUE NOT NULL DEFAULT ('CFA-' || upper(substr(encode(gen_random_bytes(6), 'hex'), 1, 10))),
  UNIQUE (user_id, certification_id)
);

-- ============================================================
-- certificates
-- ============================================================
CREATE TABLE IF NOT EXISTS certificates (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id         uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  certification_id uuid NOT NULL REFERENCES certifications(id) ON DELETE CASCADE,
  completion_id   uuid NOT NULL REFERENCES certification_completions(id) ON DELETE CASCADE,
  recipient_name  text NOT NULL,
  cert_title      text NOT NULL,
  issued_at       timestamptz NOT NULL DEFAULT now(),
  cert_number     text UNIQUE NOT NULL,
  score           integer
);

-- ============================================================
-- master_credentials
-- ============================================================
CREATE TABLE IF NOT EXISTS master_credentials (
  id                    uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  title                 text NOT NULL,
  slug                  text UNIQUE NOT NULL,
  description           text,
  required_cert_numbers integer[] NOT NULL DEFAULT '{}',
  created_at            timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- user_master_credentials
-- ============================================================
CREATE TABLE IF NOT EXISTS user_master_credentials (
  id                    uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id               uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  master_credential_id  uuid NOT NULL REFERENCES master_credentials(id) ON DELETE CASCADE,
  earned_at             timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, master_credential_id)
);

-- ============================================================
-- artifact_submissions
-- ============================================================
CREATE TABLE IF NOT EXISTS artifact_submissions (
  id                uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id           uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  certification_id  uuid NOT NULL REFERENCES certifications(id) ON DELETE CASCADE,
  file_url          text NOT NULL,
  file_name         text NOT NULL,
  submitted_at      timestamptz NOT NULL DEFAULT now(),
  status            submission_status NOT NULL DEFAULT 'pending',
  reviewed_by       uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  reviewed_at       timestamptz,
  reviewer_notes    text
);

-- ============================================================
-- Updated-at triggers
-- ============================================================
DROP TRIGGER IF EXISTS set_updated_at ON certifications;
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON certifications
  FOR EACH ROW EXECUTE FUNCTION tg_set_updated_at();

DROP TRIGGER IF EXISTS set_updated_at ON modules;
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON modules
  FOR EACH ROW EXECUTE FUNCTION tg_set_updated_at();

DROP TRIGGER IF EXISTS set_updated_at ON lessons;
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON lessons
  FOR EACH ROW EXECUTE FUNCTION tg_set_updated_at();

DROP TRIGGER IF EXISTS set_updated_at ON quizzes;
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON quizzes
  FOR EACH ROW EXECUTE FUNCTION tg_set_updated_at();

-- ============================================================
-- Row Level Security
-- ============================================================

ALTER TABLE certifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE modules ENABLE ROW LEVEL SECURITY;
ALTER TABLE lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE lesson_resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE certification_completions ENABLE ROW LEVEL SECURITY;
ALTER TABLE certificates ENABLE ROW LEVEL SECURITY;
ALTER TABLE master_credentials ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_master_credentials ENABLE ROW LEVEL SECURITY;
ALTER TABLE artifact_submissions ENABLE ROW LEVEL SECURITY;

-- ---- certifications ----
DROP POLICY IF EXISTS "certifications: approved readable by all auth" ON certifications;
CREATE POLICY "certifications: approved readable by all auth"
  ON certifications FOR SELECT
  USING (
    auth.uid() IS NOT NULL
    AND status = 'approved'
  );

DROP POLICY IF EXISTS "certifications: staff see all" ON certifications;
CREATE POLICY "certifications: staff see all"
  ON certifications FOR SELECT
  USING (get_my_role() IN ('instructor', 'admin', 'reviewer', 'super_admin'));

DROP POLICY IF EXISTS "certifications: admin write" ON certifications;
CREATE POLICY "certifications: admin write"
  ON certifications FOR ALL
  USING (get_my_role() IN ('admin', 'super_admin', 'instructor'));

-- ---- modules ----
DROP POLICY IF EXISTS "modules: approved readable by all auth" ON modules;
CREATE POLICY "modules: approved readable by all auth"
  ON modules FOR SELECT
  USING (
    auth.uid() IS NOT NULL
    AND status = 'approved'
  );

DROP POLICY IF EXISTS "modules: staff see all" ON modules;
CREATE POLICY "modules: staff see all"
  ON modules FOR SELECT
  USING (get_my_role() IN ('instructor', 'admin', 'reviewer', 'super_admin'));

DROP POLICY IF EXISTS "modules: admin write" ON modules;
CREATE POLICY "modules: admin write"
  ON modules FOR ALL
  USING (get_my_role() IN ('admin', 'super_admin', 'instructor'));

-- ---- lessons ----
DROP POLICY IF EXISTS "lessons: approved readable by all auth" ON lessons;
CREATE POLICY "lessons: approved readable by all auth"
  ON lessons FOR SELECT
  USING (
    auth.uid() IS NOT NULL
    AND status = 'approved'
  );

DROP POLICY IF EXISTS "lessons: staff see all" ON lessons;
CREATE POLICY "lessons: staff see all"
  ON lessons FOR SELECT
  USING (get_my_role() IN ('instructor', 'admin', 'reviewer', 'super_admin'));

DROP POLICY IF EXISTS "lessons: admin write" ON lessons;
CREATE POLICY "lessons: admin write"
  ON lessons FOR ALL
  USING (get_my_role() IN ('admin', 'super_admin', 'instructor'));

-- ---- lesson_resources ----
DROP POLICY IF EXISTS "lesson_resources: auth readable" ON lesson_resources;
CREATE POLICY "lesson_resources: auth readable"
  ON lesson_resources FOR SELECT
  USING (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "lesson_resources: admin write" ON lesson_resources;
CREATE POLICY "lesson_resources: admin write"
  ON lesson_resources FOR ALL
  USING (get_my_role() IN ('admin', 'super_admin', 'instructor'));

-- ---- quizzes ----
DROP POLICY IF EXISTS "quizzes: approved readable by all auth" ON quizzes;
CREATE POLICY "quizzes: approved readable by all auth"
  ON quizzes FOR SELECT
  USING (
    auth.uid() IS NOT NULL
    AND status = 'approved'
  );

DROP POLICY IF EXISTS "quizzes: staff see all" ON quizzes;
CREATE POLICY "quizzes: staff see all"
  ON quizzes FOR SELECT
  USING (get_my_role() IN ('instructor', 'admin', 'reviewer', 'super_admin'));

DROP POLICY IF EXISTS "quizzes: admin write" ON quizzes;
CREATE POLICY "quizzes: admin write"
  ON quizzes FOR ALL
  USING (get_my_role() IN ('admin', 'super_admin', 'instructor'));

-- ---- quiz_questions ----
DROP POLICY IF EXISTS "quiz_questions: approved readable by all auth" ON quiz_questions;
CREATE POLICY "quiz_questions: approved readable by all auth"
  ON quiz_questions FOR SELECT
  USING (
    auth.uid() IS NOT NULL
    AND EXISTS (
      SELECT 1 FROM quizzes q WHERE q.id = quiz_questions.quiz_id AND q.status = 'approved'
    )
  );

DROP POLICY IF EXISTS "quiz_questions: staff see all" ON quiz_questions;
CREATE POLICY "quiz_questions: staff see all"
  ON quiz_questions FOR SELECT
  USING (get_my_role() IN ('instructor', 'admin', 'reviewer', 'super_admin'));

DROP POLICY IF EXISTS "quiz_questions: admin write" ON quiz_questions;
CREATE POLICY "quiz_questions: admin write"
  ON quiz_questions FOR ALL
  USING (get_my_role() IN ('admin', 'super_admin', 'instructor'));

-- ---- quiz_attempts ----
DROP POLICY IF EXISTS "quiz_attempts: own" ON quiz_attempts;
CREATE POLICY "quiz_attempts: own"
  ON quiz_attempts FOR ALL
  USING (user_id = auth.uid());

DROP POLICY IF EXISTS "quiz_attempts: admin see all" ON quiz_attempts;
CREATE POLICY "quiz_attempts: admin see all"
  ON quiz_attempts FOR SELECT
  USING (get_my_role() IN ('super_admin', 'admin'));

-- ---- student_progress ----
DROP POLICY IF EXISTS "student_progress: own" ON student_progress;
CREATE POLICY "student_progress: own"
  ON student_progress FOR ALL
  USING (user_id = auth.uid());

DROP POLICY IF EXISTS "student_progress: admin see all" ON student_progress;
CREATE POLICY "student_progress: admin see all"
  ON student_progress FOR SELECT
  USING (get_my_role() IN ('super_admin', 'admin'));

-- ---- certification_completions ----
DROP POLICY IF EXISTS "certification_completions: own" ON certification_completions;
CREATE POLICY "certification_completions: own"
  ON certification_completions FOR ALL
  USING (user_id = auth.uid());

DROP POLICY IF EXISTS "certification_completions: admin see all" ON certification_completions;
CREATE POLICY "certification_completions: admin see all"
  ON certification_completions FOR SELECT
  USING (get_my_role() IN ('super_admin', 'admin'));

-- ---- certificates ----
DROP POLICY IF EXISTS "certificates: own" ON certificates;
CREATE POLICY "certificates: own"
  ON certificates FOR ALL
  USING (user_id = auth.uid());

DROP POLICY IF EXISTS "certificates: admin see all" ON certificates;
CREATE POLICY "certificates: admin see all"
  ON certificates FOR SELECT
  USING (get_my_role() IN ('super_admin', 'admin'));

-- ---- master_credentials ----
DROP POLICY IF EXISTS "master_credentials: all auth readable" ON master_credentials;
CREATE POLICY "master_credentials: all auth readable"
  ON master_credentials FOR SELECT
  USING (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "master_credentials: admin write" ON master_credentials;
CREATE POLICY "master_credentials: admin write"
  ON master_credentials FOR ALL
  USING (get_my_role() IN ('admin', 'super_admin'));

-- ---- user_master_credentials ----
DROP POLICY IF EXISTS "user_master_credentials: own" ON user_master_credentials;
CREATE POLICY "user_master_credentials: own"
  ON user_master_credentials FOR SELECT
  USING (user_id = auth.uid());

DROP POLICY IF EXISTS "user_master_credentials: admin see all" ON user_master_credentials;
CREATE POLICY "user_master_credentials: admin see all"
  ON user_master_credentials FOR ALL
  USING (get_my_role() IN ('super_admin', 'admin'));

-- ---- artifact_submissions ----
DROP POLICY IF EXISTS "artifact_submissions: own" ON artifact_submissions;
CREATE POLICY "artifact_submissions: own"
  ON artifact_submissions FOR ALL
  USING (user_id = auth.uid());

DROP POLICY IF EXISTS "artifact_submissions: staff see all" ON artifact_submissions;
CREATE POLICY "artifact_submissions: staff see all"
  ON artifact_submissions FOR SELECT
  USING (get_my_role() IN ('admin', 'instructor', 'reviewer', 'super_admin'));

DROP POLICY IF EXISTS "artifact_submissions: staff review" ON artifact_submissions;
CREATE POLICY "artifact_submissions: staff review"
  ON artifact_submissions FOR UPDATE
  USING (get_my_role() IN ('admin', 'instructor', 'reviewer', 'super_admin'));
