-- ============================================================
-- Cap Fund Academy — Fix "17 certifications" references in blog posts
-- Run after 25_seo_blog_posts.sql has been seeded.
-- ============================================================

UPDATE blog_posts
SET content = REPLACE(content, 'Our 17 stackable certifications', 'Our 36 stackable certifications')
WHERE content LIKE '%Our 17 stackable certifications%';

UPDATE blog_posts
SET content = REPLACE(content, 'our 17 certifications', 'our 36 certifications')
WHERE content LIKE '%our 17 certifications%';

UPDATE blog_posts
SET content = REPLACE(content, 'Our 17 certifications', 'Our 36 certifications')
WHERE content LIKE '%Our 17 certifications%';

UPDATE blog_posts
SET content = REPLACE(content, 'Cap Fund Academy''s 17 certifications', 'Cap Fund Academy''s 36 certifications')
WHERE content LIKE '%Cap Fund Academy''s 17 certifications%';

UPDATE blog_posts
SET content = REPLACE(content,
  '- **Rural Microfinance Associate** (Certs 1–4) — $1,497
- **Revolving Loan Fund Practitioner** (Certs 1–9) — $2,997
- **USDA Rural Capital Program Specialist** (Certs 1–13) — $3,997
- **Certified RLF Executive** (Certs 1–15) — $4,997
- **Master Rural Microfinance & RLF Administrator** (All 17) — $5,997',
  '- **Rural Microfinance Associate** (Certs 1–4) — $1,497
- **Revolving Loan Fund Practitioner** (Certs 1–9) — $2,997
- **USDA Rural Capital Program Specialist** (Certs 1–13) — $3,997
- **Master RLF Administrator** (All 17 RMAP/RLF certs) — $5,997
- **Government Lending Associate** (Certs 18–25) — $3,997
- **Master Capital Access Architect** (All 36 certs) — $9,997'
)
WHERE content LIKE '%Master Rural Microfinance & RLF Administrator%';

-- Update pricing blog post specifically
UPDATE blog_posts
SET
  content = REPLACE(
    REPLACE(
      REPLACE(content,
        'Each of the 17 certifications can be purchased individually',
        'Each of the 36 certifications can be purchased individually'
      ),
      'Organization License
$5,000 — All 17 certifications',
      'Organization License
$5,000 — All 36 certifications'
    ),
    'Master Administrator (All 17)',
    'Master Capital Access Architect (All 36)'
  )
WHERE slug = 'cap-fund-academy-pricing';

-- Verify
SELECT slug, LEFT(content, 100) as preview
FROM blog_posts
WHERE content LIKE '%17 cert%' OR content LIKE '%17 stack%'
ORDER BY slug;
