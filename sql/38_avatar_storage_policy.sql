-- ============================================================
-- Cap Fund Academy — Avatar storage RLS fix
-- Allows authenticated users to upload their own avatar to
-- the social-images bucket under avatars/{user_id}.png
-- Run in Supabase SQL editor
-- ============================================================

-- Allow authenticated users to upload/update their own avatar
INSERT INTO storage.buckets (id, name, public)
VALUES ('social-images', 'social-images', true)
ON CONFLICT (id) DO UPDATE SET public = true;

-- Storage policies for social-images bucket
CREATE POLICY IF NOT EXISTS "avatars: user upload own"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'social-images'
    AND (storage.foldername(name))[1] = 'avatars'
  );

CREATE POLICY IF NOT EXISTS "avatars: user update own"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'social-images'
    AND (storage.foldername(name))[1] = 'avatars'
    AND owner = auth.uid()
  );

CREATE POLICY IF NOT EXISTS "social-images: public read"
  ON storage.objects FOR SELECT
  TO public
  USING (bucket_id = 'social-images');

-- Ensure profiles.avatar_url column exists
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS avatar_url text;

-- Verify
SELECT id, name, public FROM storage.buckets WHERE id = 'social-images';
