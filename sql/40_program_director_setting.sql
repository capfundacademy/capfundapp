-- ============================================================
-- Cap Fund Academy — Seed Program Director setting
-- Run in Supabase SQL editor
-- ============================================================

INSERT INTO admin_settings (key, value, description)
VALUES (
  'program_director',
  '{"name": "Robert Nore", "title": "Program Director"}',
  'Name and title shown on certificates as the program director signature'
)
ON CONFLICT (key) DO UPDATE SET
  value = EXCLUDED.value,
  description = EXCLUDED.description;

-- Verify
SELECT key, value, updated_at FROM admin_settings WHERE key = 'program_director';
