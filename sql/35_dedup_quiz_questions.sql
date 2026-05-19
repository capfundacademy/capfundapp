-- ============================================================
-- Cap Fund Academy — Deduplicate public_quiz_questions
-- Removes duplicate rows keeping the one with the lowest sort_order
-- Run once in Supabase SQL editor
-- ============================================================

-- Step 1: See duplicates before deleting
SELECT question_text, COUNT(*) AS count
FROM public_quiz_questions
GROUP BY question_text
HAVING COUNT(*) > 1
ORDER BY count DESC;

-- Step 2: Delete duplicates, keeping the row with the smallest id
DELETE FROM public_quiz_questions
WHERE id NOT IN (
  SELECT DISTINCT ON (question_text) id
  FROM public_quiz_questions
  ORDER BY question_text, sort_order ASC, id ASC
);

-- Step 3: Add unique constraint to prevent future duplicates
ALTER TABLE public_quiz_questions
  DROP CONSTRAINT IF EXISTS public_quiz_questions_question_text_unique;

ALTER TABLE public_quiz_questions
  ADD CONSTRAINT public_quiz_questions_question_text_unique
  UNIQUE (question_text);

-- Step 4: Verify
SELECT COUNT(*) AS total_questions FROM public_quiz_questions WHERE is_active = true;
