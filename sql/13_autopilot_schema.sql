-- ============================================================
-- Cap Fund Academy — Autopilot & Exception Schema
-- File: 13_autopilot_schema.sql
-- Idempotent: safe to re-run
-- Run after: 12_content_schema.sql
-- ============================================================

-- ============================================================
-- autopilot_runs — log of every scheduled function execution
-- ============================================================
CREATE TABLE IF NOT EXISTS autopilot_runs (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  function_name text NOT NULL,
  status        text NOT NULL DEFAULT 'running',  -- running|success|failed|partial
  started_at    timestamptz NOT NULL DEFAULT now(),
  completed_at  timestamptz,
  records_processed integer NOT NULL DEFAULT 0,
  records_failed    integer NOT NULL DEFAULT 0,
  summary       jsonb NOT NULL DEFAULT '{}',
  error_message text
);

-- ============================================================
-- exception_events — alert log for system exceptions
-- ============================================================
CREATE TABLE IF NOT EXISTS exception_events (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  event_type    text NOT NULL,   -- see EXCEPTION_TYPES below
  severity      text NOT NULL DEFAULT 'warning',  -- info|warning|error|critical
  title         text NOT NULL,
  description   text,
  metadata      jsonb NOT NULL DEFAULT '{}',
  resolved      boolean NOT NULL DEFAULT false,
  resolved_at   timestamptz,
  resolved_by   uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at    timestamptz NOT NULL DEFAULT now()
);

-- Exception types:
-- payment_failed, seat_limit_reached, ai_scoring_failed, support_request,
-- high_value_abandoned, compliance_flag, dwu_submitted, integration_failure,
-- inactivity_spike, revenue_drop, enrollment_error, webhook_error

-- ============================================================
-- alert_rules — configurable alert thresholds (admin-editable)
-- ============================================================
CREATE TABLE IF NOT EXISTS alert_rules (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name          text NOT NULL,
  event_type    text NOT NULL,
  condition     jsonb NOT NULL DEFAULT '{}',   -- {threshold, operator, window_hours}
  severity      text NOT NULL DEFAULT 'warning',
  notify_email  text NOT NULL DEFAULT 'support@capfundacademy.com',
  is_active     boolean NOT NULL DEFAULT true,
  created_at    timestamptz NOT NULL DEFAULT now()
);

INSERT INTO alert_rules (name, event_type, condition, severity, notify_email) VALUES
  ('Payment Failed',          'payment_failed',       '{"threshold":1}',    'error',    'support@capfundacademy.com'),
  ('High-Value Cart Abandoned','high_value_abandoned',  '{"threshold_cents":50000}', 'warning', 'support@capfundacademy.com'),
  ('AI Scoring Failed',       'ai_scoring_failed',    '{"threshold":3,"window_hours":1}', 'error', 'support@capfundacademy.com'),
  ('Compliance Flag Triggered','compliance_flag',      '{"threshold":1}',    'warning',  'support@capfundacademy.com'),
  ('DWY Application Submitted','dwu_submitted',        '{"threshold":1}',    'info',     'support@capfundacademy.com'),
  ('Seat Limit Reached',      'seat_limit_reached',   '{"threshold":1}',    'warning',  'support@capfundacademy.com'),
  ('Webhook Error',           'webhook_error',         '{"threshold":1}',    'error',    'support@capfundacademy.com')
ON CONFLICT DO NOTHING;

-- ============================================================
-- RLS
-- ============================================================
ALTER TABLE autopilot_runs   ENABLE ROW LEVEL SECURITY;
ALTER TABLE exception_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE alert_rules      ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "runs_admin"       ON autopilot_runs;
DROP POLICY IF EXISTS "exceptions_admin" ON exception_events;
DROP POLICY IF EXISTS "alerts_admin"     ON alert_rules;

CREATE POLICY "runs_admin"       ON autopilot_runs   FOR ALL USING (get_my_role() IN ('super_admin','admin'));
CREATE POLICY "exceptions_admin" ON exception_events FOR ALL USING (get_my_role() IN ('super_admin','admin'));
CREATE POLICY "alerts_admin"     ON alert_rules      FOR ALL USING (get_my_role() IN ('super_admin','admin'));
