-- ============================================================
-- Fix: Allow all authenticated users to read the program_director
-- setting so certificates show the current director on all accounts
-- ============================================================

-- Allow any logged-in user to read the program_director setting only
DROP POLICY IF EXISTS "settings: public keys read" ON admin_settings;
CREATE POLICY "settings: public keys read"
  ON admin_settings FOR SELECT
  TO authenticated
  USING (key = 'program_director');

-- Verify
SELECT key, value->>'name' AS director_name, value->>'title' AS title
FROM admin_settings WHERE key = 'program_director';
