-- ============================================================
-- Cap Fund Academy — Base Schema
-- File: 01_base_schema.sql
-- Idempotent: safe to re-run
-- ============================================================

-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================
-- Enums
-- ============================================================
DO $$ BEGIN
  CREATE TYPE user_role AS ENUM (
    'super_admin',
    'admin',
    'instructor',
    'reviewer',
    'organization_owner',
    'organization_manager',
    'student',
    'affiliate'
  );
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

-- ============================================================
-- Tables
-- ============================================================

CREATE TABLE IF NOT EXISTS organizations (
  id           uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name         text NOT NULL,
  slug         text UNIQUE NOT NULL,
  owner_id     uuid,
  plan_type    text NOT NULL DEFAULT 'single',
  seat_limit   integer NOT NULL DEFAULT 1,
  created_at   timestamptz NOT NULL DEFAULT now(),
  updated_at   timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS profiles (
  id              uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email           text NOT NULL,
  full_name       text,
  role            user_role NOT NULL DEFAULT 'student',
  avatar_url      text,
  organization_id uuid REFERENCES organizations(id) ON DELETE SET NULL,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS organization_members (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id uuid NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  user_id         uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  role            text NOT NULL DEFAULT 'member' CHECK (role IN ('owner', 'manager', 'member')),
  joined_at       timestamptz NOT NULL DEFAULT now(),
  UNIQUE (organization_id, user_id)
);

CREATE TABLE IF NOT EXISTS leads (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name            text,
  email           text NOT NULL,
  organization    text,
  source          text,
  tags            text[],
  utm_source      text,
  utm_medium      text,
  utm_campaign    text,
  created_at      timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- Updated-at trigger
-- ============================================================
CREATE OR REPLACE FUNCTION tg_set_updated_at()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS set_updated_at ON profiles;
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION tg_set_updated_at();

DROP TRIGGER IF EXISTS set_updated_at ON organizations;
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON organizations
  FOR EACH ROW EXECUTE FUNCTION tg_set_updated_at();

-- ============================================================
-- Auth trigger — create profile on new user
-- ============================================================
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, role)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    CASE
      WHEN NEW.email = 'support@capfundacademy.com' THEN 'super_admin'::user_role
      ELSE 'student'::user_role
    END
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- ============================================================
-- Helper: get current user role (SECURITY DEFINER to avoid RLS recursion)
-- ============================================================
CREATE OR REPLACE FUNCTION get_my_role()
RETURNS user_role LANGUAGE sql SECURITY DEFINER STABLE AS $$
  SELECT role FROM public.profiles WHERE id = auth.uid();
$$;

-- ============================================================
-- Row Level Security
-- ============================================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE organization_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE leads ENABLE ROW LEVEL SECURITY;

-- ---- profiles ----
DROP POLICY IF EXISTS "profiles: own row" ON profiles;
CREATE POLICY "profiles: own row"
  ON profiles FOR SELECT
  USING (id = auth.uid());

DROP POLICY IF EXISTS "profiles: own row update" ON profiles;
CREATE POLICY "profiles: own row update"
  ON profiles FOR UPDATE
  USING (id = auth.uid());

DROP POLICY IF EXISTS "profiles: admin see all" ON profiles;
CREATE POLICY "profiles: admin see all"
  ON profiles FOR SELECT
  USING (get_my_role() IN ('super_admin', 'admin'));

DROP POLICY IF EXISTS "profiles: admin update all" ON profiles;
CREATE POLICY "profiles: admin update all"
  ON profiles FOR UPDATE
  USING (get_my_role() IN ('super_admin', 'admin'));

-- ---- organizations ----
DROP POLICY IF EXISTS "organizations: members see own" ON organizations;
CREATE POLICY "organizations: members see own"
  ON organizations FOR SELECT
  USING (
    id IN (
      SELECT organization_id FROM organization_members WHERE user_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "organizations: admin see all" ON organizations;
CREATE POLICY "organizations: admin see all"
  ON organizations FOR SELECT
  USING (get_my_role() IN ('super_admin', 'admin'));

DROP POLICY IF EXISTS "organizations: admin manage" ON organizations;
CREATE POLICY "organizations: admin manage"
  ON organizations FOR ALL
  USING (get_my_role() IN ('super_admin', 'admin'));

-- ---- organization_members ----
DROP POLICY IF EXISTS "org_members: see own org" ON organization_members;
CREATE POLICY "org_members: see own org"
  ON organization_members FOR SELECT
  USING (
    organization_id IN (
      SELECT organization_id FROM organization_members WHERE user_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "org_members: admin see all" ON organization_members;
CREATE POLICY "org_members: admin see all"
  ON organization_members FOR SELECT
  USING (get_my_role() IN ('super_admin', 'admin'));

DROP POLICY IF EXISTS "org_members: admin manage" ON organization_members;
CREATE POLICY "org_members: admin manage"
  ON organization_members FOR ALL
  USING (get_my_role() IN ('super_admin', 'admin'));

-- ---- leads ----
DROP POLICY IF EXISTS "leads: anon insert" ON leads;
CREATE POLICY "leads: anon insert"
  ON leads FOR INSERT
  WITH CHECK (true);

DROP POLICY IF EXISTS "leads: admin read" ON leads;
CREATE POLICY "leads: admin read"
  ON leads FOR SELECT
  USING (get_my_role() IN ('super_admin', 'admin'));

DROP POLICY IF EXISTS "leads: admin manage" ON leads;
CREATE POLICY "leads: admin manage"
  ON leads FOR ALL
  USING (get_my_role() IN ('super_admin', 'admin'));
