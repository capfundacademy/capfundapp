-- ============================================================
-- Cap Fund Academy — Seed Full Completions for 3 Students
-- File: 24_seed_student_completions.sql
-- Gives Julius, Kai, and Brittney 100% completion on all 17 certs
-- Run after: 23_seed_users.sql and all cert content SQL files
-- ============================================================

DO $$
DECLARE
  v_julius    uuid;
  v_kai       uuid;
  v_brittney  uuid;
  v_user      uuid;
  v_user_name text;
  v_cert      RECORD;
  v_lesson    RECORD;
  v_comp_id   uuid;
  v_cert_num  text;
BEGIN

-- ── Get user IDs from profiles ───────────────────────────────────────────────
SELECT id INTO v_julius   FROM profiles WHERE email = 'julius@lifehousereentry.com';
SELECT id INTO v_kai      FROM profiles WHERE email = 'kai@lifehousereentry.com';
SELECT id INTO v_brittney FROM profiles WHERE email = 'brittney@lifehousereentry.com';

IF v_julius   IS NULL THEN RAISE EXCEPTION 'julius@lifehousereentry.com not found — create in Auth first'; END IF;
IF v_kai      IS NULL THEN RAISE EXCEPTION 'kai@lifehousereentry.com not found — create in Auth first'; END IF;
IF v_brittney IS NULL THEN RAISE EXCEPTION 'brittney@lifehousereentry.com not found — create in Auth first'; END IF;

RAISE NOTICE 'Found users: Julius=%, Kai=%, Brittney=%', v_julius, v_kai, v_brittney;

-- ── Loop over each student ────────────────────────────────────────────────────
FOR v_user, v_user_name IN
  VALUES
    (v_julius,   'Julius Jackson'),
    (v_kai,      'Kai Shariff'),
    (v_brittney, 'Brittney Jackson')
LOOP
  RAISE NOTICE 'Processing %...', v_user_name;

  -- ── Mark every lesson as completed ─────────────────────────────────────────
  FOR v_lesson IN
    SELECT l.id AS lesson_id, m.certification_id
    FROM lessons l
    JOIN modules m ON m.id = l.module_id
    WHERE l.status = 'approved'
  LOOP
    INSERT INTO student_progress (user_id, certification_id, lesson_id, status, completed_at)
    VALUES (v_user, v_lesson.certification_id, v_lesson.lesson_id, 'completed', now() - interval '7 days')
    ON CONFLICT (user_id, lesson_id) DO UPDATE
      SET status = 'completed', completed_at = EXCLUDED.completed_at;
  END LOOP;

  -- ── Create certification_completion + certificate for every cert ────────────
  FOR v_cert IN
    SELECT id, cert_number, title
    FROM certifications
    WHERE status = 'approved'
    ORDER BY cert_number
  LOOP
    -- Generate unique cert number
    v_cert_num := 'CFA-' || upper(substr(encode(gen_random_bytes(6), 'hex'), 1, 10));

    -- Insert completion (skip if already exists)
    INSERT INTO certification_completions
      (user_id, certification_id, artifact_submitted, completed_at, certificate_number)
    VALUES
      (v_user, v_cert.id, true, now() - interval '5 days', v_cert_num)
    ON CONFLICT (user_id, certification_id) DO NOTHING
    RETURNING id INTO v_comp_id;

    -- If we got a new completion, create the certificate record
    IF v_comp_id IS NOT NULL THEN
      INSERT INTO certificates
        (user_id, certification_id, completion_id, recipient_name, cert_title, issued_at, cert_number, score)
      VALUES
        (v_user, v_cert.id, v_comp_id, v_user_name,
         'Cert ' || v_cert.cert_number || ': ' || v_cert.title,
         now() - interval '5 days',
         v_cert_num,
         95)
      ON CONFLICT DO NOTHING;
    END IF;

    -- If completion already existed, make sure certificate exists too
    IF v_comp_id IS NULL THEN
      SELECT id INTO v_comp_id
      FROM certification_completions
      WHERE user_id = v_user AND certification_id = v_cert.id;

      INSERT INTO certificates
        (user_id, certification_id, completion_id, recipient_name, cert_title, issued_at, cert_number, score)
      VALUES
        (v_user, v_cert.id, v_comp_id, v_user_name,
         'Cert ' || v_cert.cert_number || ': ' || v_cert.title,
         now() - interval '5 days',
         'CFA-' || upper(substr(encode(gen_random_bytes(6), 'hex'), 1, 10)),
         95)
      ON CONFLICT DO NOTHING;
    END IF;

  END LOOP;

  RAISE NOTICE '  Done: %', v_user_name;
END LOOP;

RAISE NOTICE 'All 3 students fully completed. Verifying counts...';

-- ── Verification ─────────────────────────────────────────────────────────────
RAISE NOTICE 'julius lessons completed:  %', (SELECT count(*) FROM student_progress WHERE user_id = v_julius AND status = 'completed');
RAISE NOTICE 'julius certs completed:    %', (SELECT count(*) FROM certification_completions WHERE user_id = v_julius);
RAISE NOTICE 'julius certificates:       %', (SELECT count(*) FROM certificates WHERE user_id = v_julius);
RAISE NOTICE 'kai lessons completed:     %', (SELECT count(*) FROM student_progress WHERE user_id = v_kai AND status = 'completed');
RAISE NOTICE 'kai certs completed:       %', (SELECT count(*) FROM certification_completions WHERE user_id = v_kai);
RAISE NOTICE 'brittney lessons completed:%', (SELECT count(*) FROM student_progress WHERE user_id = v_brittney AND status = 'completed');
RAISE NOTICE 'brittney certs completed:  %', (SELECT count(*) FROM certification_completions WHERE user_id = v_brittney);

END $$;

-- ── Final check — readable summary ───────────────────────────────────────────
SELECT
  p.full_name,
  p.email,
  (SELECT count(*) FROM student_progress sp WHERE sp.user_id = p.id AND sp.status = 'completed') AS lessons_completed,
  (SELECT count(*) FROM certification_completions cc WHERE cc.user_id = p.id) AS certs_completed,
  (SELECT count(*) FROM certificates c WHERE c.user_id = p.id) AS certificates_issued
FROM profiles p
WHERE p.email IN (
  'julius@lifehousereentry.com',
  'kai@lifehousereentry.com',
  'brittney@lifehousereentry.com'
);
