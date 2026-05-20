-- ============================================================
-- Cap Fund Academy — Missing RPC + Schema Fixes
-- File: 37_missing_rpc_and_fixes.sql
-- Run in Supabase SQL editor
-- ============================================================

-- 1. increment_coupon_uses RPC (CRITICAL — Stripe webhook calls this on every order)
CREATE OR REPLACE FUNCTION increment_coupon_uses(coupon_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE coupons
  SET uses_count = COALESCE(uses_count, 0) + 1
  WHERE id = coupon_id;
END;
$$;

-- 2. Create ai_coach_sessions table to replace the email_sends abuse
CREATE TABLE IF NOT EXISTS ai_coach_sessions (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  messages    int  NOT NULL DEFAULT 1,
  created_at  timestamptz DEFAULT now(),
  updated_at  timestamptz DEFAULT now()
);

-- One row per user, updated per session (for rate limiting)
CREATE UNIQUE INDEX IF NOT EXISTS ai_coach_sessions_user_id_idx ON ai_coach_sessions(user_id);

ALTER TABLE ai_coach_sessions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "coach_sessions_own" ON ai_coach_sessions;
CREATE POLICY "coach_sessions_own" ON ai_coach_sessions
  FOR ALL USING (auth.uid() = user_id);

-- 3. Verify coupons table has uses_count column
ALTER TABLE coupons ADD COLUMN IF NOT EXISTS uses_count integer NOT NULL DEFAULT 0;

-- 4. Verify email_sends has user_id nullable (for internal sends)
ALTER TABLE email_sends ALTER COLUMN user_id DROP NOT NULL;

-- 5. Seed BUFFER_ACCESS_TOKEN check reminder (no SQL action — just verification)
-- Run this to confirm your env vars are set:
SELECT
  current_setting('app.settings.resend_api_key', true) IS NOT NULL AS has_resend,
  'Check Netlify env vars: RESEND_API_KEY, BUFFER_ACCESS_TOKEN, OPENAI_API_KEY' AS reminder;
