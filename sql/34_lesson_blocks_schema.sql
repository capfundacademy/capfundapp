-- ============================================================
-- Cap Fund Academy — Lesson Blocks Column
-- Adds blocks jsonb column to lessons for block-based editor
-- Existing lessons continue to use the content (markdown) column
-- as fallback; blocks take priority when present.
-- ============================================================

ALTER TABLE lessons ADD COLUMN IF NOT EXISTS blocks jsonb;

-- Comment for documentation
COMMENT ON COLUMN lessons.blocks IS
  'Structured block array [{type, text, items, terms, ...}]. '
  'When present, used instead of content (markdown) for rendering. '
  'Block types: paragraph, heading, subheading, list, numbered, '
  'callout, glossary, activity, case_study, divider, video, image, audio.';
