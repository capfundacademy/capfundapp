-- ============================================================
-- Cap Fund Academy — Security Hardening & RLS Audit
-- File: 14_security_hardening.sql
-- Run after: 13_autopilot_schema.sql
-- Purpose: verify RLS on all tables, add retention settings,
--          add rate-limit helpers, tighten remaining policies
-- ============================================================

-- ============================================================
-- 1. RLS AUDIT — verify every table has RLS enabled
-- ============================================================
DO $$
DECLARE
  t record;
  missing text[] := '{}';
BEGIN
  FOR t IN
    SELECT tablename FROM pg_tables
    WHERE schemaname = 'public'
    AND tablename NOT IN ('schema_migrations','spatial_ref_sys')
  LOOP
    IF NOT EXISTS (
      SELECT 1 FROM pg_class c
      JOIN pg_namespace n ON n.oid = c.relnamespace
      WHERE n.nspname = 'public'
      AND c.relname = t.tablename
      AND c.relrowsecurity = true
    ) THEN
      missing := array_append(missing, t.tablename);
    END IF;
  END LOOP;

  IF array_length(missing, 1) > 0 THEN
    RAISE WARNING 'Tables missing RLS: %', array_to_string(missing, ', ');
  ELSE
    RAISE NOTICE 'RLS audit PASSED — all tables have row-level security enabled.';
  END IF;
END $$;

-- ============================================================
-- 2. Enable RLS on any tables that may have been missed
-- ============================================================
DO $$
DECLARE t record;
BEGIN
  FOR t IN
    SELECT tablename FROM pg_tables WHERE schemaname = 'public'
    AND tablename NOT IN ('schema_migrations','spatial_ref_sys','funnel_stages')
  LOOP
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', t.tablename);
  END LOOP;
END $$;

-- funnel_stages is reference data — keep it readable by all auth users
ALTER TABLE public.funnel_stages ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- 3. Data retention settings in admin_settings
-- ============================================================
INSERT INTO admin_settings (key, value, description) VALUES
  ('data_retention_leads_days',         '730',   'Days to retain lead records (0 = forever)'),
  ('data_retention_email_sends_days',   '365',   'Days to retain email send logs'),
  ('data_retention_autopilot_runs_days','90',    'Days to retain autopilot function run logs'),
  ('data_retention_exception_events_days','180', 'Days to retain resolved exception events'),
  ('data_retention_scoring_runs_days',  '365',   'Days to retain scoring run records'),
  ('max_file_upload_mb',                '25',    'Maximum evidence file upload size in MB'),
  ('ai_scoring_rate_limit_per_hour',    '5',     'Max AI scoring runs per user per hour'),
  ('content_gen_rate_limit_per_hour',   '20',    'Max content generations per user per hour'),
  ('self_signup_enabled',               'false', 'Allow public sign-up (false = admin creates users only)')
ON CONFLICT (key) DO NOTHING;

-- ============================================================
-- 4. Rate-limit helper function (callable from functions)
-- ============================================================
CREATE OR REPLACE FUNCTION check_rate_limit(
  p_user_id    uuid,
  p_action     text,
  p_table_name text,
  p_column     text,
  p_max_count  integer,
  p_window_hrs integer DEFAULT 1
) RETURNS boolean
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_count integer;
  v_since timestamptz := now() - (p_window_hrs || ' hours')::interval;
BEGIN
  EXECUTE format(
    'SELECT COUNT(*) FROM public.%I WHERE %I = $1 AND created_at >= $2',
    p_table_name, p_column
  ) INTO v_count USING p_user_id, v_since;
  RETURN v_count < p_max_count;
END;
$$;

-- ============================================================
-- 5. Cleanup function for old autopilot run logs
-- ============================================================
CREATE OR REPLACE FUNCTION cleanup_old_logs() RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_days integer;
BEGIN
  SELECT (value::text)::integer INTO v_days
  FROM admin_settings WHERE key = 'data_retention_autopilot_runs_days';
  v_days := COALESCE(v_days, 90);

  DELETE FROM public.autopilot_runs
  WHERE started_at < now() - (v_days || ' days')::interval;

  DELETE FROM public.email_sends
  WHERE sent_at < now() - (
    COALESCE((SELECT value::text FROM admin_settings WHERE key = 'data_retention_email_sends_days'), '365')
    || ' days')::interval;

  DELETE FROM public.exception_events
  WHERE resolved = true
  AND resolved_at < now() - (
    COALESCE((SELECT value::text FROM admin_settings WHERE key = 'data_retention_exception_events_days'), '180')
    || ' days')::interval;
END;
$$;

-- ============================================================
-- 6. Tighten leads INSERT policy — allow anon insert for lead capture
-- ============================================================
DROP POLICY IF EXISTS "leads_anon_insert" ON leads;
CREATE POLICY "leads_anon_insert" ON leads
  FOR INSERT WITH CHECK (true);  -- public lead forms can insert

DROP POLICY IF EXISTS "leads_own_read" ON leads;
CREATE POLICY "leads_own_read" ON leads
  FOR SELECT USING (get_my_role() IN ('super_admin','admin','instructor'));

DROP POLICY IF EXISTS "leads_admin_all" ON leads;
CREATE POLICY "leads_admin_all" ON leads
  FOR ALL USING (get_my_role() IN ('super_admin','admin'));

-- ============================================================
-- 7. Ensure quiz_responses allows anonymous insert (public quiz)
-- ============================================================
DROP POLICY IF EXISTS "quiz_resp_insert" ON quiz_responses;
DROP POLICY IF EXISTS "quiz_resp_admin"  ON quiz_responses;
CREATE POLICY "quiz_resp_insert" ON quiz_responses FOR INSERT WITH CHECK (true);
CREATE POLICY "quiz_resp_admin"  ON quiz_responses FOR SELECT USING (get_my_role() IN ('super_admin','admin'));

-- ============================================================
-- 8. Final audit report
-- ============================================================
SELECT
  t.tablename,
  c.relrowsecurity AS rls_enabled,
  COUNT(p.policyname) AS policy_count
FROM pg_tables t
JOIN pg_class c ON c.relname = t.tablename
JOIN pg_namespace n ON n.oid = c.relnamespace AND n.nspname = 'public'
LEFT JOIN pg_policies p ON p.tablename = t.tablename AND p.schemaname = 'public'
WHERE t.schemaname = 'public'
GROUP BY t.tablename, c.relrowsecurity
ORDER BY t.tablename;
