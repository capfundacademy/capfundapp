-- ============================================================
-- Cap Fund Academy — De-duplicate certificates table
-- Keeps one certificate per (user_id, certification_id),
-- retaining the row with the earliest issued_at.
-- Run in Supabase SQL editor.
-- ============================================================

-- Step 1: Delete duplicates, keeping oldest issued_at per (user_id, certification_id)
DELETE FROM certificates
WHERE id IN (
  SELECT id FROM (
    SELECT
      id,
      ROW_NUMBER() OVER (
        PARTITION BY user_id, certification_id
        ORDER BY issued_at ASC, created_at ASC
      ) AS rn
    FROM certificates
  ) ranked
  WHERE rn > 1
);

-- Step 2: Add unique constraint to prevent future duplicates
ALTER TABLE certificates
  DROP CONSTRAINT IF EXISTS certificates_user_cert_unique;

ALTER TABLE certificates
  ADD CONSTRAINT certificates_user_cert_unique
  UNIQUE (user_id, certification_id);

-- Step 3: Verify — should show exactly one row per user per cert
SELECT
  p.full_name,
  COUNT(*) AS cert_count
FROM certificates c
JOIN profiles p ON p.id = c.user_id
GROUP BY p.full_name
ORDER BY p.full_name;
