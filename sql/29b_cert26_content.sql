-- ============================================================
-- Cap Fund Academy — Cert 26 Content (split from 29)
-- Run after: 29_cert22_26_content.sql
-- ============================================================


-- ═══════════════════════════════════════════════════════════════
-- CERT 26: FHA Multifamily, Healthcare & HUD Risk-Sharing
-- ═══════════════════════════════════════════════════════════════

-- ── Cert 26 ─────────────────────────────────────

INSERT INTO modules (certification_id, title, sort_order, status)
SELECT id, 'FHA Multifamily Finance: MAP Lender Model', 1, 'approved' FROM certifications WHERE cert_number = 26
ON CONFLICT DO NOTHING;


INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status)
SELECT m.id, 'FHA Multifamily Programs: 221(d)(4), 223(f), and MAP Lender Basics', 'fha-multifamily-programs-221d4-223f-and-map-lender-basics',
$BODY$## FHA Multifamily Programs: 221(d)(4), 223(f), and MAP Lender Basics

FHA's multifamily mortgage insurance programs are the dominant financing mechanism for affordable housing development, preservation, and market-rate apartment projects across the United States. These programs provide mortgage insurance for loans made by approved MAP (Multifamily Accelerated Processing) lenders.

**What is a MAP Lender?**
A Multifamily Accelerated Processing lender is a HUD-approved financial institution that has delegated underwriting authority for FHA multifamily programs. MAP lenders can process most FHA multifamily applications in-house without going through HUD's full review process — dramatically accelerating processing times. Becoming a MAP lender requires HUD approval, experienced multifamily underwriters, and significant operational infrastructure.

**FHA 221(d)(4): New Construction and Substantial Rehabilitation**
The 221(d)(4) program is FHA's primary product for new construction and substantial rehabilitation of market-rate and affordable multifamily housing. Key features:
- Loan terms up to 40 years (plus two-year construction period)
- Maximum loan-to-cost ratios around 87% for affordable housing, 85% for market-rate
- FHA insurance eliminates most credit risk for the lender
- Davis-Bacon prevailing wage requirements apply during construction
- Can be combined with LIHTC equity, HOME funds, and other sources

**FHA 223(f): Acquisition and Refinancing**
The 223(f) program provides mortgage insurance for the acquisition or refinancing of existing multifamily properties. It is one of the most commonly used FHA multifamily tools. Properties must be at least three years old. Loan terms up to 35 years. Lower loan-to-value ratios than 221(d)(4).

**FHA 223(a)(7): Existing FHA-Insured Loan Refinancing**
Streamlined refinancing for existing FHA-insured multifamily loans. Lower cost and faster processing than 223(f) because the property is already in the FHA insurance portfolio.

**Key Terms**
- **MAP lender**: A HUD-approved lender with delegated underwriting authority for FHA multifamily.
- **Davis-Bacon**: Federal prevailing wage requirements that apply to FHA-insured construction projects.
- **LTC**: Loan-to-cost ratio — the loan amount as a percentage of total project cost.

**Practical Checklist**
- [ ] Identify MAP lenders operating in your market
- [ ] Review HUD's 221(d)(4) and 223(f) program summaries at hud.gov
- [ ] Understand the role of LIHTC in combination with FHA multifamily
- [ ] Learn Davis-Bacon compliance requirements for construction projects
- [ ] Develop a project finance pathway memo for a hypothetical affordable housing project
$BODY$, 1, 10, 'approved'
FROM modules m JOIN certifications c ON m.certification_id = c.id
WHERE c.cert_number = 26 AND m.sort_order = 1
ON CONFLICT DO NOTHING;



INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
SELECT id, 'FHA Multifamily, Healthcare & HUD Risk-Sharing Assessment', 75, 45, 'approved' FROM certifications WHERE cert_number = 26
ON CONFLICT DO NOTHING;


WITH qid AS (
  SELECT q.id AS quiz_id FROM quizzes q JOIN certifications c ON q.certification_id = c.id
  WHERE c.cert_number = 26 AND q.title = 'FHA Multifamily, Healthcare & HUD Risk-Sharing Assessment')
INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order)
SELECT qid.quiz_id, v.question_text, v.options::jsonb, v.correct_option_id, v.explanation, v.sort_order
FROM qid CROSS JOIN (VALUES
  ('What is a MAP lender?', '[{"id":"a","text":"A USDA-approved rural housing lender"},{"id":"b","text":"A HUD-approved lender with delegated underwriting authority for FHA multifamily programs"},{"id":"c","text":"A state-licensed mortgage company"},{"id":"d","text":"A Fannie Mae seller/servicer for multifamily loans"}]', 'b', 'MAP (Multifamily Accelerated Processing) lenders are HUD-approved institutions with delegated underwriting authority that allows them to process most FHA multifamily applications without full HUD review.', 1),
  ('Which FHA program is used for new construction and substantial rehabilitation of multifamily housing?', '[{"id":"a","text":"FHA 223(f)"},{"id":"b","text":"FHA 221(d)(4)"},{"id":"c","text":"FHA 241(a)"},{"id":"d","text":"FHA 223(a)(7)"}]', 'b', 'FHA 221(d)(4) is FHA''s primary program for new construction and substantial rehabilitation of multifamily housing, with loan terms up to 40 years plus construction period.', 2),
  ('What is the purpose of FHA 223(f)?', '[{"id":"a","text":"New construction of healthcare facilities"},{"id":"b","text":"Acquisition or refinancing of existing multifamily properties"},{"id":"c","text":"Streamlined refinancing of existing FHA loans"},{"id":"d","text":"Supplemental loans for completed FHA projects"}]', 'b', 'FHA 223(f) provides mortgage insurance for the acquisition or refinancing of existing multifamily properties at least three years old.', 3),
  ('What wage requirement applies to FHA-insured construction projects?', '[{"id":"a","text":"State minimum wage only"},{"id":"b","text":"Davis-Bacon prevailing wage requirements"},{"id":"c","text":"Federal minimum wage plus 10%"},{"id":"d","text":"No wage requirements for affordable housing"}]', 'b', 'Davis-Bacon Act prevailing wage requirements apply to construction projects financed with FHA-insured loans, requiring contractors to pay locally prevailing wages.', 4),
  ('FHA 232 provides mortgage insurance for which type of facility?', '[{"id":"a","text":"Rural multifamily housing"},{"id":"b","text":"Healthcare facilities — nursing homes and assisted living"},{"id":"c","text":"Tribal housing developments"},{"id":"d","text":"Student housing at universities"}]', 'b', 'FHA 232 (Lean 232) provides mortgage insurance for nursing homes, assisted living facilities, intermediate care facilities, and board and care homes.', 5),
  ('HUD 542(b) and 542(c) risk-sharing programs are designed to work with:', '[{"id":"a","text":"FHA MAP lenders"},{"id":"b","text":"State Housing Finance Agencies and HUD-approved public entities"},{"id":"c","text":"Fannie Mae and Freddie Mac"},{"id":"d","text":"USDA Rural Development"}]', 'b', 'HUD 542(b) and 542(c) risk-sharing programs allow state housing finance agencies and other HUD-approved public entities to share risk with HUD on multifamily mortgage insurance, enabling faster processing and more flexible underwriting.', 6),
  ('What is the maximum loan term for an FHA 221(d)(4) construction loan?', '[{"id":"a","text":"20 years"},{"id":"b","text":"30 years"},{"id":"c","text":"40 years plus construction period"},{"id":"d","text":"50 years"}]', 'c', 'FHA 221(d)(4) loans have terms up to 40 years for the permanent loan, plus a construction period of up to two years.', 7),
  ('What is FHA 223(a)(7)?', '[{"id":"a","text":"New construction insurance"},{"id":"b","text":"Supplemental loan insurance"},{"id":"c","text":"Streamlined refinancing for existing FHA-insured multifamily loans"},{"id":"d","text":"Healthcare facility insurance"}]', 'c', 'FHA 223(a)(7) provides streamlined refinancing for existing FHA-insured multifamily mortgages — faster and lower-cost than a full 223(f) refinance since the property is already in the insurance portfolio.', 8),
  ('A community development organization wants to finance a 50-unit affordable apartment project. Which financing approach should they explore?', '[{"id":"a","text":"SBA 7(a) loan only"},{"id":"b","text":"FHA 221(d)(4) with MAP lender, combined with LIHTC equity"},{"id":"c","text":"USDA Business & Industry guarantee"},{"id":"d","text":"Section 502 Direct loans"}]', 'b', 'A 50-unit affordable apartment project is an ideal candidate for FHA 221(d)(4) financing through a MAP lender, often combined with Low-Income Housing Tax Credit equity and other affordable housing sources.', 9),
  ('HUD Section 108 provides which type of financing?', '[{"id":"a","text":"Mortgage insurance for single-family homes"},{"id":"b","text":"Community development loan guarantees using CDBG entitlement funds as security"},{"id":"c","text":"Multifamily insurance for rural areas"},{"id":"d","text":"Healthcare facility construction grants"}]', 'b', 'HUD Section 108 allows CDBG entitlement communities to borrow against future CDBG allocations for community and economic development projects, leveraging grant dollars into larger loan capacity.', 10)
) AS v(question_text, options, correct_option_id, explanation, sort_order)
ON CONFLICT DO NOTHING;
