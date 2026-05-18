-- ============================================================
-- Cap Fund Academy — AI Study Coach Access Control
-- File: 19_coach_access.sql
-- Grants coach_access to profiles that purchase the DWY offer
-- Run after: 14_security_hardening.sql
-- ============================================================

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS coach_access boolean NOT NULL DEFAULT false;

-- Grant coach access to any user who already paid for DWY
UPDATE public.profiles p
SET coach_access = true
WHERE id IN (
  SELECT DISTINCT o.user_id
  FROM orders o
  JOIN offers of ON of.id = o.offer_id
  WHERE o.status = 'paid'
  AND of.offer_type = 'dwu'
);

SELECT 'coach_access column added. Existing DWY purchasers updated.' AS status;
