-- ============================================================
-- Clear the bad blank signature that was saved before the fix
-- This resets signature_data_url to null so the admin can
-- re-draw it cleanly in Settings → Program Director Signature
-- ============================================================

UPDATE admin_settings
SET value = jsonb_set(value, '{signature_data_url}', 'null')
WHERE key = 'program_director';

-- Verify: signature_data_url should now be null
SELECT
  key,
  value->>'name'               AS director_name,
  value->>'title'              AS title,
  (value->>'signature_data_url') IS NULL AS signature_cleared
FROM admin_settings
WHERE key = 'program_director';
