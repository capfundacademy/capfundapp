-- ============================================================
-- Cap Fund Academy — Seed Initial Users
-- File: 23_seed_users.sql
-- Run in Supabase SQL Editor
-- Creates 3 Life House Reentry team members as students
-- ============================================================

-- NOTE: Supabase Auth users must be created via the Dashboard UI or
-- the Admin API, not plain SQL. Use the Supabase Dashboard:
--   Authentication → Users → Add User for each person below.
--
-- After creating auth users, run the UPDATE statements below to
-- set their profile data (the handle_new_user trigger creates the
-- profile row automatically when auth.users is inserted).
--
-- ── User 1: Julius Jackson ───────────────────────────────────
-- Email:    julius@lifehousereentry.com
-- Password: Julius33!
-- After creating in Auth dashboard, run:

UPDATE profiles SET
  full_name    = 'Julius Jackson',
  role         = 'student',
  public_org   = 'Life House Reentry',
  public_state = 'AL'
WHERE email = 'julius@lifehousereentry.com';

-- ── User 2: Kai Shariff ──────────────────────────────────────
-- Email:    kai@lifehousereentry.com
-- Password: Julius33!

UPDATE profiles SET
  full_name    = 'Kai Shariff',
  role         = 'student',
  public_org   = 'Life House Reentry',
  public_state = 'AL'
WHERE email = 'kai@lifehousereentry.com';

-- ── User 3: Brittney Jackson ─────────────────────────────────
-- Email:    brittney@lifehousereentry.com
-- Password: Julius33!

UPDATE profiles SET
  full_name    = 'Brittney Jackson',
  role         = 'student',
  public_org   = 'Life House Reentry',
  public_state = 'AL'
WHERE email = 'brittney@lifehousereentry.com';

-- Verify
SELECT id, full_name, email, role, public_org FROM profiles
WHERE email IN (
  'julius@lifehousereentry.com',
  'kai@lifehousereentry.com',
  'brittney@lifehousereentry.com'
);
