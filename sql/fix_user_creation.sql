-- ============================================================
-- Fix: user creation trigger + storage bucket name
-- Run this in Supabase SQL Editor, then retry creating
-- support@capfundacademy.com in Authentication → Users
-- ============================================================

-- Step 1: Make sure user_role enum has all values
DO $$ BEGIN
  CREATE TYPE user_role AS ENUM (
    'super_admin','admin','instructor','reviewer',
    'organization_owner','organization_manager','student','affiliate'
  );
EXCEPTION WHEN duplicate_object THEN
  -- Add any missing values to existing enum
  BEGIN ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'super_admin'; EXCEPTION WHEN others THEN NULL; END;
  BEGIN ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'admin'; EXCEPTION WHEN others THEN NULL; END;
  BEGIN ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'instructor'; EXCEPTION WHEN others THEN NULL; END;
  BEGIN ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'reviewer'; EXCEPTION WHEN others THEN NULL; END;
  BEGIN ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'organization_owner'; EXCEPTION WHEN others THEN NULL; END;
  BEGIN ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'organization_manager'; EXCEPTION WHEN others THEN NULL; END;
  BEGIN ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'student'; EXCEPTION WHEN others THEN NULL; END;
  BEGIN ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'affiliate'; EXCEPTION WHEN others THEN NULL; END;
END $$;

-- Step 2: Ensure profiles table exists with correct columns
CREATE TABLE IF NOT EXISTS public.profiles (
  id          uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email       text,
  full_name   text,
  role        user_role NOT NULL DEFAULT 'student',
  avatar_url  text,
  organization_id uuid,
  exam_early_access boolean NOT NULL DEFAULT false,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

-- Step 3: Re-create the trigger function (clean version)
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, role)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    CASE
      WHEN NEW.email = 'support@capfundacademy.com' THEN 'super_admin'::user_role
      ELSE 'student'::user_role
    END
  )
  ON CONFLICT (id) DO UPDATE SET
    email = EXCLUDED.email,
    role  = CASE
              WHEN EXCLUDED.email = 'support@capfundacademy.com' THEN 'super_admin'::user_role
              ELSE profiles.role
            END;
  RETURN NEW;
END;
$$;

-- Step 4: Re-attach trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Step 5: If the user was already created but the profile is missing,
-- run this after creating the user in the dashboard:
-- (Replace the UUID with the actual user ID from Authentication → Users)
-- INSERT INTO public.profiles (id, email, role)
-- SELECT id, email, 'super_admin'::user_role
-- FROM auth.users WHERE email = 'support@capfundacademy.com'
-- ON CONFLICT (id) DO UPDATE SET role = 'super_admin';

SELECT 'Trigger fixed. Now try creating support@capfundacademy.com in Authentication → Users.' AS status;
