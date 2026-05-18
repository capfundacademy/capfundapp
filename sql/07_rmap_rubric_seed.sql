-- ============================================================
-- Cap Fund Academy — RMAP Scoring Rubric Seed
-- File: 07_rmap_rubric_seed.sql
-- Source: 7 CFR 4280.316 (RMAP Final Rule, published 5-14-21)
--         USDA RMAP Application Checklist/Scoresheet 2025
-- Criteria encoded VERBATIM from federal regulation.
-- Admin-editable in the platform; never hardcoded in functions.
-- Idempotent: ON CONFLICT DO NOTHING
-- Run after: 06_application_schema.sql
-- ============================================================

DO $$
DECLARE
  rubric_id uuid;
  r_id      uuid;
BEGIN

-- ── Insert rubric ──────────────────────────────────────────
INSERT INTO scoring_rubrics (program_type, version, title, description, max_points)
VALUES (
  'rmap', '2025',
  'USDA RMAP Scoring Rubric — 7 CFR 4280.316',
  'Rural Microentrepreneur Assistance Program scoring criteria. 45-point common baseline (all applicants) plus pathway-specific points: 55 for experienced microlenders (§4280.316(b)), 55 for less-experienced (§4280.316(c)), 55 for TA-only (§4280.316(d)). Maximum total: 100 points.',
  100
)
ON CONFLICT (program_type, version) DO NOTHING;

SELECT id INTO rubric_id FROM scoring_rubrics WHERE program_type = 'rmap' AND version = '2025';
IF rubric_id IS NULL THEN
  RAISE NOTICE 'RMAP rubric already seeded — skipping criteria insert';
  RETURN;
END IF;

-- ═══════════════════════════════════════════════════════════
-- SECTION A — 4280.316(a) All Applications (45 points max)
-- ═══════════════════════════════════════════════════════════

INSERT INTO scoring_criteria (rubric_id, section_code, section_label, criterion_code, criterion_label, description, max_points, point_bands, evidence_hint, sort_order)
VALUES

-- A1: Organizational Chart (5 pts)
(rubric_id, '4280.316(a)', 'All Applications — Common 45 Points', 'a1',
 'Organizational Chart',
 'Clearly showing the positions and naming the individuals in those positions. Of particular interest to the Agency are management positions and those positions essential to the operation of microlending and TA programming.',
 5,
 '[
   {"label":"Complete chart naming all key positions","points":5},
   {"label":"Chart present but missing some key names or positions","points":3},
   {"label":"Partial or unclear org chart","points":1},
   {"label":"Not provided","points":0}
 ]',
 'Organizational chart with named individuals in every position, particularly microlending and TA leadership.',
 10),

-- A2: Resumes (5 pts)
(rubric_id, '4280.316(a)', 'All Applications — Common 45 Points', 'a2',
 'Resumes for Key Personnel',
 'Resumes for each of the individuals shown on the organizational chart and indicated as key to the operation of the activities to be funded. Points awarded based on the quality of resumes and the demonstrated ability of key personnel to administer the program.',
 5,
 '[
   {"label":"Strong resumes demonstrating clear ability to administer RMAP","points":5},
   {"label":"Adequate resumes with some relevant experience","points":3},
   {"label":"Weak or incomplete resumes","points":1},
   {"label":"Not provided","points":0}
 ]',
 'Individual resume for each person named on the org chart as key to RMAP operations.',
 20),

-- A3: Succession Plan (5 pts)
(rubric_id, '4280.316(a)', 'All Applications — Common 45 Points', 'a3',
 'Succession Plan',
 'A succession plan to be followed in the event of the departure of personnel key to the operation of the applicant''s RMAP activities.',
 5,
 '[
   {"label":"Clear, detailed succession plan covering all key positions","points":5},
   {"label":"General succession plan with some gaps","points":3},
   {"label":"Minimal succession planning","points":1},
   {"label":"Not provided","points":0}
 ]',
 'Written succession plan naming backup personnel or processes for each key RMAP role.',
 30),

-- A4: Understanding of Microenterprise Development (5 pts)
(rubric_id, '4280.316(a)', 'All Applications — Common 45 Points', 'a4',
 'Policy & Procedures — Understanding of Microenterprise Development',
 'Information indicating an understanding of microenterprise development concepts. Provide those parts of your policy and procedures manual that deal with the provision of loans, management of loan funds, and provision of technical assistance.',
 5,
 '[
   {"label":"Comprehensive policies covering loans, fund management, and TA with strong conceptual grounding","points":5},
   {"label":"Adequate policies but missing some areas","points":3},
   {"label":"Limited or underdeveloped policies","points":1},
   {"label":"Not provided","points":0}
 ]',
 'Relevant sections of your policy and procedures manual covering loan provision, loan fund management, and technical assistance.',
 40),

-- A5: Financial Statements (10 pts)
(rubric_id, '4280.316(a)', 'All Applications — Common 45 Points', 'a5',
 'Financial Statements — 3 Years',
 'Copies of the applicant''s most recent, and two years previous, financial statements. Points awarded based on: the demonstrated ability of the applicant to maintain or grow its fund balance; its ability to manage one or more federal programs; and its capacity to manage multiple funding sources, restricted and non-restricted funding sources, income, earnings, and expenditures.',
 10,
 '[
   {"label":"Strong financials showing fund balance growth, federal program management, and multiple funding sources","points":10},
   {"label":"Adequate financials with minor concerns","points":7},
   {"label":"Financials show some capacity gaps or instability","points":4},
   {"label":"Weak financials or significant concerns","points":2},
   {"label":"Not provided","points":0}
 ]',
 'Audited or reviewed financial statements for current year and two prior years (balance sheet, income statement, notes).',
 50),

-- A6: Mission Statement (5 pts)
(rubric_id, '4280.316(a)', 'All Applications — Common 45 Points', 'a6',
 'Organizational Mission Statement',
 'A copy of the applicant''s organizational mission statement. Rated based on its relative connectivity to microenterprise development and general economic development.',
 5,
 '[
   {"label":"Mission statement strongly aligned with microenterprise and economic development","points":5},
   {"label":"Mission statement has some connection to microenterprise development","points":3},
   {"label":"Mission statement has weak or indirect connection","points":1},
   {"label":"Not provided or no connection","points":0}
 ]',
 'Organizational mission statement (can be from bylaws, website, or standalone document — do not submit bylaws twice).',
 60),

-- A7: Geographic Service Area (10 pts)
(rubric_id, '4280.316(a)', 'All Applications — Common 45 Points', 'a7',
 'Geographic Service Area',
 'Information regarding the geographic service area to be served. Describe the service area (must be rural as defined). State the number of counties or other jurisdictions to be served. Note: applicant will not be scored on the size of the service area but on its ability to fully cover the service area as described.',
 10,
 '[
   {"label":"Clear description of rural service area with strong demonstrated capacity to cover it","points":10},
   {"label":"Good description with adequate coverage capacity","points":7},
   {"label":"Service area described but coverage capacity unclear","points":4},
   {"label":"Weak or incomplete service area description","points":2},
   {"label":"Not provided","points":0}
 ]',
 'Map or written description of rural service area; county/jurisdiction count; evidence of capacity to serve the stated geography.',
 70),

-- ═══════════════════════════════════════════════════════════
-- SECTION B — 4280.316(b) Experienced Microlender >3 Years (55 pts max)
-- ═══════════════════════════════════════════════════════════

-- B1: History of Microloans (20 pts total across b1i–b1v)
(rubric_id, '4280.316(b)', 'Experienced Microlender (>3 years) — 55 Points', 'b1i',
 'Rural Lending History — Years of Consecutive Rural Lending',
 'History of providing microloans in rural areas for the three years prior to application.',
 5,
 '[
   {"label":"Three or more consecutive years immediately prior to this application","points":5},
   {"label":"At least two of the three consecutive years immediately prior","points":3},
   {"label":"At least 6 months but not more than one year immediately prior","points":1},
   {"label":"Less than 6 months or no rural lending history","points":0}
 ]',
 'Table showing rural microloan history for last 3 Federal Fiscal Years (count and dollar amount by year).',
 100),

(rubric_id, '4280.316(b)', 'Experienced Microlender (>3 years) — 55 Points', 'b1ii',
 'Percentage of Loans Made in Rural Areas — By Count',
 'Percentage of the total number of microloans made in rural areas across the 3 prior Federal Fiscal Years.',
 5,
 '[
   {"label":"75% or more of total microloans made in rural areas","points":5},
   {"label":"At least 50% but less than 75%","points":3},
   {"label":"At least 25% but less than 50%","points":1},
   {"label":"Less than 25%","points":0}
 ]',
 'Total loan count and rural loan count for each of the last 3 Federal Fiscal Years.',
 110),

(rubric_id, '4280.316(b)', 'Experienced Microlender (>3 years) — 55 Points', 'b1iii',
 'Percentage of Dollar Amount in Rural Areas',
 'Dollar amount of microloans made in rural areas as a percentage of the total portfolio (rural and non-rural) for each of the 3 prior Federal Fiscal Years.',
 5,
 '[
   {"label":"75% or more of total dollar amount in rural areas","points":5},
   {"label":"At least 50% but less than 75%","points":3},
   {"label":"At least 25% but less than 50%","points":1},
   {"label":"Less than 25%","points":0}
 ]',
 'Total dollar amount and rural dollar amount for each of the last 3 Federal Fiscal Years.',
 120),

(rubric_id, '4280.316(b)', 'Experienced Microlender (>3 years) — 55 Points', 'b1iv',
 'Portfolio Diversity — Demographic Match to Service Area',
 'Compare the diversity of the entire microloan portfolio to the demographic makeup of the service area (per latest decennial census). Demographic groups: gender, racial/ethnic minority status, and disability (per ADA). Based on loans made during the three years preceding the application.',
 5,
 '[
   {"label":"At least one loan to each demographic group AND percentage within 5% of demographic makeup for each group","points":5},
   {"label":"At least one loan to each group AND percentage within 10% of demographic makeup for each group","points":3},
   {"label":"At least one loan to each group but one or more groups >10% off, OR no loans to one group but others within 10%","points":1},
   {"label":"No loans to two or more demographic groups","points":0}
 ]',
 'Portfolio breakdown by gender, racial/ethnic minority, and disability for past 3 years; service area demographic data from latest Census.',
 130),

-- B2: Portfolio Management (10 pts)
(rubric_id, '4280.316(b)', 'Experienced Microlender (>3 years) — 55 Points', 'b2i',
 'Portfolio Management — On-Time Payment Rate',
 'Total number of microloans paying on time for the 3 previous Federal Fiscal Years.',
 10,
 '[
   {"label":"95% or more paying on time at end of each year","points":10},
   {"label":"At least 85% but less than 95%","points":7},
   {"label":"At least 70% but less than 85%","points":4},
   {"label":"Less than 70% paying on time","points":0}
 ]',
 'On-time payment data for portfolio for each of the last 3 Federal Fiscal Years (count and percentage).',
 140),

-- B3: Provision of TA (10 pts)
(rubric_id, '4280.316(b)', 'Experienced Microlender (>3 years) — 55 Points', 'b3',
 'Provision of Technical Assistance — History and Quality',
 'History of providing technical assistance and training to microentrepreneurs. Includes types of TA provided, number of clients served, outcomes documented, and integration with lending activities.',
 10,
 '[
   {"label":"Strong TA history: documented outcomes, multiple TA types, integrated with lending, measurable results","points":10},
   {"label":"Good TA history with some documentation of outcomes","points":7},
   {"label":"Some TA history but limited documentation","points":4},
   {"label":"Minimal or no TA history","points":0}
 ]',
 'TA log data: sessions by type (group/individual/peer/online), client count, outcome metrics (survival, revenue, jobs), evaluations.',
 150),

-- B4: Commitment/Support Letters (10 pts)
(rubric_id, '4280.316(b)', 'Experienced Microlender (>3 years) — 55 Points', 'b4',
 'Commitment Letters and Community Support',
 'Letters from community partners, funders, referral sources, and organizations demonstrating support for the applicant''s RMAP activities and capacity to serve rural microentrepreneurs.',
 10,
 '[
   {"label":"Strong letters from multiple credible partners with specific commitments","points":10},
   {"label":"Adequate letters from some partners","points":7},
   {"label":"Limited letters with general support only","points":4},
   {"label":"No commitment letters","points":0}
 ]',
 'Signed letters from banks, CDFIs, local government, foundations, or other partners referencing specific support for RMAP activities.',
 160),

-- B5: Work Plan (5 pts)
(rubric_id, '4280.316(b)', 'Experienced Microlender (>3 years) — 55 Points', 'b5',
 'Work Plan — Microlending and TA Activities',
 'A work plan describing the activities to be undertaken under RMAP, including microlending goals, TA programming, staffing, timeline, and performance targets.',
 5,
 '[
   {"label":"Detailed work plan with specific goals, timeline, staffing, and measurable targets","points":5},
   {"label":"Adequate work plan with some gaps","points":3},
   {"label":"General or incomplete work plan","points":1},
   {"label":"Not provided","points":0}
 ]',
 'Written work plan covering loan volume goals, TA hours, staffing allocation, quarterly milestones, and performance metrics.',
 170),

-- ═══════════════════════════════════════════════════════════
-- SECTION C — 4280.316(c) Less-Experienced Microlender ≤3 Years (55 pts max)
-- ═══════════════════════════════════════════════════════════

(rubric_id, '4280.316(c)', 'Less-Experienced Microlender (≤3 years) — 55 Points', 'c1',
 'Work Plan — 5-Page Detailed Plan',
 'A detailed work plan (up to 5 pages) describing proposed RMAP activities, approach to microlending, staffing plan, outreach strategy, and timeline. Rated on specificity, feasibility, and alignment with rural microenterprise needs.',
 20,
 '[
   {"label":"Exceptional 5-page plan: specific, feasible, well-staffed, rural-aligned with clear milestones","points":20},
   {"label":"Strong plan with minor gaps","points":15},
   {"label":"Adequate plan but missing key elements","points":10},
   {"label":"Weak or general plan","points":5},
   {"label":"Not provided","points":0}
 ]',
 '5-page maximum work plan covering lending approach, TA model, staffing, outreach, timeline, and performance targets.',
 200),

(rubric_id, '4280.316(c)', 'Less-Experienced Microlender (≤3 years) — 55 Points', 'c2',
 'Years in Business / Operational Track Record',
 'Number of years the organization has been in operation providing business development services, lending, or related services to microentrepreneurs or underserved communities.',
 10,
 '[
   {"label":"3 years of operations with relevant track record","points":10},
   {"label":"2 years of operations","points":7},
   {"label":"1-2 years of operations","points":4},
   {"label":"Less than 1 year","points":1},
   {"label":"New organization, no track record","points":0}
 ]',
 'Documentation of organizational history: incorporation date, service history, prior programs delivered.',
 210),

(rubric_id, '4280.316(c)', 'Less-Experienced Microlender (≤3 years) — 55 Points', 'c3',
 'Staffing and Training Plan',
 'Qualifications of proposed staff and training plan to build microlending and TA capacity. Includes evidence of training completed or planned, relevant certifications, and partnerships with experienced organizations.',
 10,
 '[
   {"label":"Well-qualified staff with clear training plan and credible capacity-building partnerships","points":10},
   {"label":"Adequate qualifications with training planned","points":7},
   {"label":"Some qualifications but training plan weak","points":4},
   {"label":"Limited qualifications and no training plan","points":0}
 ]',
 'Staff resumes, training plan, partnerships with SBDCs/CDFIs/experienced microlenders, planned certifications.',
 220),

(rubric_id, '4280.316(c)', 'Less-Experienced Microlender (≤3 years) — 55 Points', 'c4',
 'Support Letters and Community Commitment',
 'Letters from community partners, referral sources, and organizations demonstrating support and commitment to the applicant''s proposed RMAP activities.',
 10,
 '[
   {"label":"Multiple strong letters with specific commitments from credible partners","points":10},
   {"label":"Several letters with general support","points":7},
   {"label":"A few letters with limited specificity","points":4},
   {"label":"No support letters","points":0}
 ]',
 'Signed commitment letters from local government, banks, CDFIs, community organizations, referral partners.',
 230),

(rubric_id, '4280.316(c)', 'Less-Experienced Microlender (≤3 years) — 55 Points', 'c5',
 'Benchmarking — Comparable Programs',
 'Evidence of research into comparable RMAP programs and benchmarking against established microlenders. Demonstrates understanding of the field and realistic expectations.',
 5,
 '[
   {"label":"Clear benchmarking with specific data from comparable programs","points":5},
   {"label":"Some benchmarking with general comparisons","points":3},
   {"label":"Minimal benchmarking","points":1},
   {"label":"No benchmarking","points":0}
 ]',
 'Research or data on comparable RMAP microlenders: loan volume, TA model, service area, outcomes — used to set realistic targets.',
 240),

-- ═══════════════════════════════════════════════════════════
-- SECTION D — 4280.316(d) TA-Only MDOs (55 pts max)
-- ═══════════════════════════════════════════════════════════

(rubric_id, '4280.316(d)', 'TA-Only MDO — 55 Points', 'd1',
 'History of TA Provision',
 'Documented history of providing technical assistance and training to microentrepreneurs and microenterprises. Volume, types, and outcomes of TA delivered over the prior 3 years.',
 20,
 '[
   {"label":"Strong 3-year TA history with documented outcomes, multiple delivery methods, measurable results","points":20},
   {"label":"Good TA history with some documentation","points":15},
   {"label":"Moderate TA history with limited documentation","points":10},
   {"label":"Minimal TA history","points":5},
   {"label":"No prior TA history","points":0}
 ]',
 'TA logs for 3 prior years: sessions by type, client count, topics, outcomes (revenue, jobs, loan conversion, survival).',
 300),

(rubric_id, '4280.316(d)', 'TA-Only MDO — 55 Points', 'd2',
 'Resultant Microloans — TA to Loan Conversion',
 'Number of microloans made to clients who received TA from the applicant. Demonstrates connection between TA delivery and capital access outcomes.',
 15,
 '[
   {"label":"Significant TA-to-loan conversion rate with documented microloan outcomes","points":15},
   {"label":"Moderate conversion with some documentation","points":10},
   {"label":"Some conversion but limited documentation","points":5},
   {"label":"No documented loan outcomes from TA clients","points":0}
 ]',
 'List or count of microloans made to TA clients (amount, lender, year); referral records from TA to capital providers.',
 310),

(rubric_id, '4280.316(d)', 'TA-Only MDO — 55 Points', 'd3',
 'TA Methods and Delivery Approach',
 'Description of TA methods used: group training, one-on-one counseling, peer learning, distance/online delivery, business planning, financial coaching, etc. Rated on diversity, appropriateness for rural microentrepreneurs, and quality.',
 10,
 '[
   {"label":"Diverse, well-documented TA methods clearly suited to rural microentrepreneurs","points":10},
   {"label":"Good methods with some diversity","points":7},
   {"label":"Limited methods or delivery approach","points":4},
   {"label":"Not described","points":0}
 ]',
 'Written description or catalog of TA services: delivery format, curriculum, duration, target population, language access.',
 320),

(rubric_id, '4280.316(d)', 'TA-Only MDO — 55 Points', 'd4',
 'Evaluations and Outcomes Documentation',
 'Evidence that the applicant measures and documents TA outcomes: client satisfaction, business outcomes (revenue, jobs, survival, loan repayment), and program improvement based on evaluation results.',
 5,
 '[
   {"label":"Systematic evaluation process with documented outcomes and program improvements","points":5},
   {"label":"Some evaluation data collected","points":3},
   {"label":"Minimal evaluation","points":1},
   {"label":"No evaluation","points":0}
 ]',
 'Client satisfaction surveys, outcome tracking data, annual evaluation reports, success stories.',
 330),

(rubric_id, '4280.316(d)', 'TA-Only MDO — 55 Points', 'd5',
 'TA Plan — Proposed Program',
 'A detailed plan for TA and training to be delivered under the RMAP TA grant: services, methods, target population, staffing, budget, and performance targets.',
 5,
 '[
   {"label":"Detailed, realistic TA plan with specific deliverables and measurable targets","points":5},
   {"label":"Adequate plan with some gaps","points":3},
   {"label":"General plan with limited specifics","points":1},
   {"label":"Not provided","points":0}
 ]',
 'Written TA program plan: service menu, delivery calendar, staff allocation, budget narrative, 12-month targets.',
 340)

ON CONFLICT DO NOTHING;

RAISE NOTICE 'RMAP rubric seeded: rubric_id = %', rubric_id;

END $$;
