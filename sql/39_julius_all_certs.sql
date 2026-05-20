-- ============================================================
-- Give Julius Jackson all 36 certifications
-- Run in Supabase SQL editor
-- ============================================================

DO $$
DECLARE
  v_user_id uuid;
  v_cert    RECORD;
  v_cert_num text;
  v_comp_id  uuid;
  v_score    int;
BEGIN

  -- Get Julius's user ID
  SELECT id INTO v_user_id FROM auth.users WHERE email = 'julius@lifehousereentry.com';
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'User julius@lifehousereentry.com not found';
  END IF;

  RAISE NOTICE 'Granting all 36 certs to Julius (user_id: %)', v_user_id;

  -- Loop through all 36 certifications
  FOR v_cert IN SELECT * FROM certifications ORDER BY cert_number LOOP

    -- Random score between 85-97
    v_score := 85 + floor(random() * 13)::int;
    v_cert_num := 'CFA-' || upper(substr(encode(gen_random_bytes(6), 'hex'), 1, 10));

    -- Upsert certification_completion
    INSERT INTO certification_completions
      (user_id, certification_id, artifact_submitted, completed_at, certificate_number)
    VALUES
      (v_user_id, v_cert.id, true,
       now() - (interval '1 day' * (36 - v_cert.cert_number) * 14),
       v_cert_num)
    ON CONFLICT (user_id, certification_id) DO UPDATE
      SET artifact_submitted = true
    RETURNING id INTO v_comp_id;

    -- Get ID if upsert hit conflict
    IF v_comp_id IS NULL THEN
      SELECT id INTO v_comp_id FROM certification_completions
      WHERE user_id = v_user_id AND certification_id = v_cert.id;
    END IF;

    -- Issue certificate (skip if already exists)
    INSERT INTO certificates
      (user_id, certification_id, completion_id, recipient_name, cert_title, issued_at, cert_number, score)
    VALUES
      (v_user_id, v_cert.id, v_comp_id, 'Julius Jackson',
       'Cert ' || v_cert.cert_number || ': ' || v_cert.title,
       now() - (interval '1 day' * (36 - v_cert.cert_number) * 14),
       v_cert_num, v_score)
    ON CONFLICT (user_id, certification_id) DO NOTHING;

    -- Mark all lessons in this cert as completed
    INSERT INTO student_progress (user_id, certification_id, lesson_id, status, completed_at)
    SELECT
      v_user_id,
      v_cert.id,
      l.id,
      'completed',
      now() - (interval '1 day' * (36 - v_cert.cert_number) * 14 + interval '1 day')
    FROM lessons l
    JOIN modules m ON m.id = l.module_id
    WHERE m.certification_id = v_cert.id
    ON CONFLICT (user_id, lesson_id) DO UPDATE
      SET status = 'completed', completed_at = EXCLUDED.completed_at;

    RAISE NOTICE '  ✓ Cert %: % (score: % pct)', v_cert.cert_number, v_cert.title, v_score;
  END LOOP;

  RAISE NOTICE 'Done — Julius now has all 36 certifications.';
END $$;

-- Verify
SELECT
  p.full_name,
  COUNT(DISTINCT cc.certification_id) AS certs_completed,
  COUNT(DISTINCT cr.id)               AS certificates_issued
FROM profiles p
LEFT JOIN certification_completions cc ON cc.user_id = p.id
LEFT JOIN certificates cr              ON cr.user_id  = p.id
WHERE p.email = 'julius@lifehousereentry.com'
GROUP BY p.full_name;
