-- ============================================================
-- Fix social_posts for automated daily-content function
-- 1. created_by: make nullable (automation has no user context)
-- 2. buffer_post_id: add column for tracking Buffer queue IDs
-- ============================================================

ALTER TABLE social_posts
  ALTER COLUMN created_by DROP NOT NULL;

ALTER TABLE social_posts
  ADD COLUMN IF NOT EXISTS buffer_post_id text;

-- Verify
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'social_posts'
  AND column_name IN ('created_by', 'buffer_post_id')
ORDER BY column_name;
