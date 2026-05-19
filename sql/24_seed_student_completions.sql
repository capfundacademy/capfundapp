-- ============================================================
-- Cap Fund Academy — Realistic Completion History for 3 Students
-- File: 24_seed_student_completions.sql
-- Each student completed all 17 certs over ~6 months at different
-- paces, on different days, with different scores.
-- Run after: 23_seed_users.sql and all cert content SQL files
-- ============================================================

DO $$
DECLARE
  v_julius    uuid;
  v_kai       uuid;
  v_brittney  uuid;
  v_user_id   uuid;
  v_user_name text;
  v_cert      RECORD;
  v_lesson    RECORD;
  v_comp_id   uuid;
  v_cert_num  text;
  v_score     integer;
  v_comp_date timestamptz;
  v_lesson_date timestamptz;

  -- Each student's per-cert completion dates (cert 1 through 17)
  -- Julius:   steady pacer, started Nov 2025, one cert every ~11 days
  julius_dates  timestamptz[];
  -- Kai:      faster early, slower on harder compliance certs
  kai_dates     timestamptz[];
  -- Brittney: slower starter, caught up fast after cert 5
  brittney_dates timestamptz[];

  -- Scores per cert per student (realistic variation, 80-98 range)
  julius_scores   integer[];
  kai_scores      integer[];
  brittney_scores integer[];

BEGIN

-- ── Get user IDs ─────────────────────────────────────────────────────────────
SELECT id INTO v_julius   FROM profiles WHERE email = 'julius@lifehousereentry.com';
SELECT id INTO v_kai      FROM profiles WHERE email = 'kai@lifehousereentry.com';
SELECT id INTO v_brittney FROM profiles WHERE email = 'brittney@lifehousereentry.com';

IF v_julius   IS NULL THEN RAISE EXCEPTION 'julius@lifehousereentry.com not found'; END IF;
IF v_kai      IS NULL THEN RAISE EXCEPTION 'kai@lifehousereentry.com not found';    END IF;
IF v_brittney IS NULL THEN RAISE EXCEPTION 'brittney@lifehousereentry.com not found'; END IF;

-- ── Julius Jackson — steady, consistent pacer ─────────────────────────────
-- Started Nov 6 2025, finished cert 17 on May 4 2026 (179 days / ~6 months)
-- Took weekends off, averaged 10-14 days per cert. Strong on USDA policy.
julius_dates := ARRAY[
  '2025-11-18 14:22:00'::timestamptz,  -- Cert 1
  '2025-12-01 09:45:00'::timestamptz,  -- Cert 2
  '2025-12-17 16:30:00'::timestamptz,  -- Cert 3 (longer, 16 days)
  '2025-12-30 11:15:00'::timestamptz,  -- Cert 4
  '2026-01-10 15:00:00'::timestamptz,  -- Cert 5 (holiday slowdown)
  '2026-01-27 09:20:00'::timestamptz,  -- Cert 6 (17 days, dense content)
  '2026-02-07 13:45:00'::timestamptz,  -- Cert 7
  '2026-02-22 10:30:00'::timestamptz,  -- Cert 8 (15 days, underwriting heavy)
  '2026-03-05 14:00:00'::timestamptz,  -- Cert 9
  '2026-03-20 09:00:00'::timestamptz,  -- Cert 10 (compliance, 15 days)
  '2026-04-02 16:15:00'::timestamptz,  -- Cert 11 (accounting)
  '2026-04-13 11:00:00'::timestamptz,  -- Cert 12
  '2026-04-22 14:30:00'::timestamptz,  -- Cert 13
  '2026-04-30 10:00:00'::timestamptz,  -- Cert 14
  '2026-05-07 15:45:00'::timestamptz,  -- Cert 15
  '2026-05-13 09:30:00'::timestamptz,  -- Cert 16
  '2026-05-19 11:00:00'::timestamptz   -- Cert 17 (Master Capstone)
];
julius_scores := ARRAY[
  94,  -- Cert 1  — strong foundation
  91,  -- Cert 2
  88,  -- Cert 3  — tricky scoring rubric
  93,  -- Cert 4
  90,  -- Cert 5
  85,  -- Cert 6  — RBDG details
  92,  -- Cert 7
  87,  -- Cert 8  — underwriting math
  94,  -- Cert 9
  86,  -- Cert 10 — compliance heavy
  89,  -- Cert 11
  95,  -- Cert 12 — application assembly (his strength)
  97,  -- Cert 13
  91,  -- Cert 14
  88,  -- Cert 15
  93,  -- Cert 16
  96   -- Cert 17 — capstone
];

-- ── Kai Shariff — fast starter, hit a wall on compliance certs ────────────
-- Started Nov 25 2025, finished May 10 2026 (165 days)
-- Breezed through first 6, then slowed on regulatory content (Certs 10-11)
kai_dates := ARRAY[
  '2025-12-04 10:00:00'::timestamptz,  -- Cert 1 (9 days — fast!)
  '2025-12-13 14:30:00'::timestamptz,  -- Cert 2 (9 days)
  '2025-12-26 11:00:00'::timestamptz,  -- Cert 3 (13 days, Christmas break)
  '2026-01-05 09:15:00'::timestamptz,  -- Cert 4 (10 days)
  '2026-01-14 13:00:00'::timestamptz,  -- Cert 5 (9 days)
  '2026-01-28 10:30:00'::timestamptz,  -- Cert 6 (14 days, heavy)
  '2026-02-06 15:00:00'::timestamptz,  -- Cert 7 (9 days)
  '2026-02-19 11:45:00'::timestamptz,  -- Cert 8 (13 days)
  '2026-02-28 09:00:00'::timestamptz,  -- Cert 9 (9 days)
  '2026-03-21 14:00:00'::timestamptz,  -- Cert 10 (21 days — compliance wall)
  '2026-04-10 10:30:00'::timestamptz,  -- Cert 11 (20 days — accounting hard)
  '2026-04-20 13:15:00'::timestamptz,  -- Cert 12 (10 days, back on track)
  '2026-04-28 09:45:00'::timestamptz,  -- Cert 13
  '2026-05-05 14:00:00'::timestamptz,  -- Cert 14
  '2026-05-11 10:00:00'::timestamptz,  -- Cert 15
  '2026-05-16 15:30:00'::timestamptz,  -- Cert 16
  '2026-05-22 11:00:00'::timestamptz   -- Cert 17 (Capstone — careful finish)
];
kai_scores := ARRAY[
  97,  -- Cert 1  — natural quick learner
  95,  -- Cert 2
  91,  -- Cert 3
  96,  -- Cert 4
  93,  -- Cert 5
  89,  -- Cert 6
  94,  -- Cert 7
  90,  -- Cert 8
  95,  -- Cert 9
  80,  -- Cert 10 — struggled, barely passed first try
  82,  -- Cert 11 — accounting was hard
  91,  -- Cert 12 — bounced back
  94,  -- Cert 13
  98,  -- Cert 14 — business certs are his wheelhouse
  96,  -- Cert 15
  95,  -- Cert 16
  93   -- Cert 17
];

-- ── Brittney Jackson — slow start, accelerated after cert 5 ──────────────
-- Started Dec 15 2025, finished May 18 2026 (154 days)
-- Took 3 weeks on first few certs (new material), then hit stride
brittney_dates := ARRAY[
  '2026-01-06 13:00:00'::timestamptz,  -- Cert 1 (22 days — careful reader)
  '2026-01-22 10:30:00'::timestamptz,  -- Cert 2 (16 days)
  '2026-02-08 14:45:00'::timestamptz,  -- Cert 3 (17 days)
  '2026-02-22 09:30:00'::timestamptz,  -- Cert 4 (14 days)
  '2026-03-05 15:00:00'::timestamptz,  -- Cert 5 (11 days)
  '2026-03-15 11:15:00'::timestamptz,  -- Cert 6 (10 days, pace picked up)
  '2026-03-24 09:00:00'::timestamptz,  -- Cert 7 (9 days)
  '2026-04-01 14:30:00'::timestamptz,  -- Cert 8 (8 days — on fire)
  '2026-04-09 10:00:00'::timestamptz,  -- Cert 9
  '2026-04-18 13:45:00'::timestamptz,  -- Cert 10 (9 days)
  '2026-04-26 09:15:00'::timestamptz,  -- Cert 11 (8 days)
  '2026-05-03 14:00:00'::timestamptz,  -- Cert 12
  '2026-05-08 10:30:00'::timestamptz,  -- Cert 13
  '2026-05-12 15:00:00'::timestamptz,  -- Cert 14
  '2026-05-15 09:45:00'::timestamptz,  -- Cert 15
  '2026-05-17 13:00:00'::timestamptz,  -- Cert 16
  '2026-05-22 16:00:00'::timestamptz   -- Cert 17
];
brittney_scores := ARRAY[
  85,  -- Cert 1  — took time, thorough
  88,  -- Cert 2
  84,  -- Cert 3
  90,  -- Cert 4  — improving
  92,  -- Cert 5
  95,  -- Cert 6  — hit her stride
  93,  -- Cert 7
  96,  -- Cert 8  — underwriting strong
  94,  -- Cert 9
  91,  -- Cert 10
  93,  -- Cert 11
  97,  -- Cert 12 — application assembly (her strongest)
  95,  -- Cert 13
  88,  -- Cert 14 — business certs less familiar
  86,  -- Cert 15
  90,  -- Cert 16
  94   -- Cert 17
];

-- ── Process each student ────────────────────────────────────────────────────
FOR v_user_id, v_user_name IN
  VALUES
    (v_julius,   'Julius Jackson'),
    (v_kai,      'Kai Shariff'),
    (v_brittney, 'Brittney Jackson')
LOOP
  RAISE NOTICE 'Seeding completions for %...', v_user_name;

  -- Loop through all 17 certs in order
  FOR v_cert IN
    SELECT id, cert_number, title
    FROM certifications
    WHERE status = 'approved'
    ORDER BY cert_number
  LOOP
    -- Pick this student's score and completion date for this cert
    IF v_user_id = v_julius THEN
      v_score     := julius_scores[v_cert.cert_number];
      v_comp_date := julius_dates[v_cert.cert_number];
    ELSIF v_user_id = v_kai THEN
      v_score     := kai_scores[v_cert.cert_number];
      v_comp_date := kai_dates[v_cert.cert_number];
    ELSE
      v_score     := brittney_scores[v_cert.cert_number];
      v_comp_date := brittney_dates[v_cert.cert_number];
    END IF;

    -- ── Mark all lessons for this cert as completed ─────────────────────────
    -- Spread lesson completions across the 2 weeks before cert completion
    FOR v_lesson IN
      SELECT l.id AS lesson_id, m.certification_id,
             row_number() OVER (ORDER BY m.sort_order, l.sort_order) AS rn,
             count(*) OVER () AS total
      FROM lessons l
      JOIN modules m ON m.id = l.module_id
      WHERE m.certification_id = v_cert.id
        AND l.status = 'approved'
    LOOP
      -- Each lesson completed progressively: earliest lesson ~14 days before cert completion
      v_lesson_date := v_comp_date - interval '14 days'
        + ((v_comp_date - (v_comp_date - interval '14 days')) * (v_lesson.rn::float / v_lesson.total::float));

      INSERT INTO student_progress
        (user_id, certification_id, lesson_id, status, completed_at)
      VALUES
        (v_user_id, v_cert.id, v_lesson.lesson_id, 'completed', v_lesson_date)
      ON CONFLICT (user_id, lesson_id) DO UPDATE
        SET status = 'completed', completed_at = EXCLUDED.completed_at;
    END LOOP;

    -- ── Create certification_completion ─────────────────────────────────────
    v_cert_num := 'CFA-' || upper(substr(encode(gen_random_bytes(6), 'hex'), 1, 10));

    INSERT INTO certification_completions
      (user_id, certification_id, artifact_submitted, completed_at, certificate_number)
    VALUES
      (v_user_id, v_cert.id, true, v_comp_date, v_cert_num)
    ON CONFLICT (user_id, certification_id) DO UPDATE
      SET completed_at = EXCLUDED.completed_at,
          artifact_submitted = true
    RETURNING id INTO v_comp_id;

    -- If upsert hit the conflict path, get the existing id
    IF v_comp_id IS NULL THEN
      SELECT id INTO v_comp_id
      FROM certification_completions
      WHERE user_id = v_user_id AND certification_id = v_cert.id;
    END IF;

    -- ── Issue certificate ───────────────────────────────────────────────────
    INSERT INTO certificates
      (user_id, certification_id, completion_id, recipient_name, cert_title, issued_at, cert_number, score)
    VALUES
      (v_user_id, v_cert.id, v_comp_id, v_user_name,
       'Cert ' || v_cert.cert_number || ': ' || v_cert.title,
       v_comp_date, v_cert_num, v_score)
    ON CONFLICT DO NOTHING;

  END LOOP; -- certs

  RAISE NOTICE '  ✓ % — all 17 certs seeded', v_user_name;
END LOOP; -- students

-- ── Verification summary ────────────────────────────────────────────────────
RAISE NOTICE '=== Seeding complete ===';

END $$;

-- Readable summary with scores and dates
SELECT
  p.full_name,
  c.cert_number,
  cert.title,
  c.completed_at::date AS completed_date,
  cert_rec.score,
  c.certificate_number
FROM certification_completions c
JOIN profiles p ON p.id = c.user_id
JOIN certifications cert ON cert.id = c.certification_id
JOIN certificates cert_rec ON cert_rec.completion_id = c.id
WHERE p.email IN (
  'julius@lifehousereentry.com',
  'kai@lifehousereentry.com',
  'brittney@lifehousereentry.com'
)
ORDER BY p.full_name, cert.cert_number;
