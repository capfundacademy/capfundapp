-- ============================================================
-- Cap Fund Academy — Fix missing tables & verify platform health
-- Run in Supabase SQL editor
-- ============================================================

-- 1. Seed funnel_stages if empty (CRM pipeline stages)
INSERT INTO funnel_stages (name, slug, color, sort_order, is_active)
VALUES
  ('New Lead',          'new_lead',         '#6366f1', 1, true),
  ('Quiz Completed',    'quiz_complete',     '#3b82f6', 2, true),
  ('Interested',        'interested',        '#f59e0b', 3, true),
  ('Demo Scheduled',    'demo_scheduled',    '#8b5cf6', 4, true),
  ('Proposal Sent',     'proposal_sent',     '#06b6d4', 5, true),
  ('Enrolled',          'enrolled',          '#10b981', 6, true),
  ('Churned',           'churned',           '#ef4444', 7, true)
ON CONFLICT (slug) DO NOTHING;

-- 2. Ensure funnel_stages has the slug column with unique constraint
DO $$ BEGIN
  ALTER TABLE funnel_stages ADD COLUMN IF NOT EXISTS slug text;
  ALTER TABLE funnel_stages ADD COLUMN IF NOT EXISTS is_active boolean DEFAULT true;
EXCEPTION WHEN OTHERS THEN NULL; END $$;

-- 3. Verify lead capture is working — show all leads
SELECT
  id,
  name,
  email,
  organization,
  source,
  funnel_stage,
  quiz_score,
  result_tag,
  created_at::date AS joined
FROM leads
ORDER BY created_at DESC
LIMIT 20;

-- 4. Verify certification completions count (should be 51 for 3 students × 17 certs)
SELECT
  p.full_name,
  COUNT(cc.id) AS certs_completed
FROM certification_completions cc
JOIN profiles p ON p.id = cc.user_id
GROUP BY p.full_name
ORDER BY certs_completed DESC;

-- 5. Verify quiz questions are deduped
SELECT COUNT(*) AS total_quiz_questions FROM public_quiz_questions WHERE is_active = true;

-- 6. Show autopilot run history
SELECT function_name, status, records_processed, started_at::date
FROM autopilot_runs
ORDER BY started_at DESC
LIMIT 10;
