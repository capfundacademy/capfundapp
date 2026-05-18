-- ============================================================
-- Cap Fund Academy — RBDG & IRP Rubric Seeds
-- File: 08_rbdg_irp_rubric_seed.sql
-- Source: 7 CFR 4280 Subpart E (RBDG), RD-RBCS-508 Fact Sheet 2024
-- Idempotent: ON CONFLICT DO NOTHING
-- Run after: 07_rmap_rubric_seed.sql
-- ============================================================

DO $$
DECLARE
  rbdg_id uuid;
  irp_id  uuid;
BEGIN

-- ══════════════════════════════════════════════════════════
-- RBDG RUBRIC
-- ══════════════════════════════════════════════════════════

INSERT INTO scoring_rubrics (program_type, version, title, description, max_points)
VALUES (
  'rbdg', '2024',
  'USDA RBDG Readiness Rubric — 7 CFR 4280 Subpart E',
  'Rural Business Development Grant program readiness assessment. RBDG funds rural business opportunity grants and rural business enterprise grants. Eligible applicants: rural public entities, nonprofits, and Indian tribes. Two project types: Business Opportunity (BO) and Business Enterprise (BE). This rubric assesses application readiness, not USDA''s scoring.',
  100
)
ON CONFLICT (program_type, version) DO NOTHING;

SELECT id INTO rbdg_id FROM scoring_rubrics WHERE program_type = 'rbdg' AND version = '2024';
IF rbdg_id IS NULL THEN RETURN; END IF;

INSERT INTO scoring_criteria (rubric_id, section_code, section_label, criterion_code, criterion_label, description, max_points, point_bands, evidence_hint, sort_order)
VALUES

(rbdg_id, 'Eligibility', 'RBDG Eligibility', 'e1',
 'Eligible Applicant Type',
 'Eligible applicants for RBDG are: incorporated towns and villages, boroughs, townships, counties, states, authorities, districts, and other political subdivisions; nonprofit corporations; and Federally-recognized Indian tribes.',
 10,
 '[
   {"label":"Confirmed eligible applicant type with documentation","points":10},
   {"label":"Likely eligible but documentation incomplete","points":5},
   {"label":"Eligibility unclear","points":0}
 ]',
 'Articles of incorporation (nonprofit), tribal resolution (Indian tribe), or government charter (public entity).',
 10),

(rbdg_id, 'Eligibility', 'RBDG Eligibility', 'e2',
 'Rural Area Requirement',
 'Project must serve a rural area as defined by USDA: areas not in cities or towns with populations greater than 50,000. The project''s primary beneficiaries must be rural businesses or rural residents.',
 10,
 '[
   {"label":"Clearly documented rural service area with supporting census data","points":10},
   {"label":"Rural area likely but not fully documented","points":5},
   {"label":"Rural eligibility unclear or service area not defined","points":0}
 ]',
 'Map of service area; Census data showing population below 50,000 threshold; list of counties served.',
 20),

(rbdg_id, 'Project Design', 'RBDG Project Design & Narrative', 'p1',
 'Project Type Classification',
 'RBDG has two project types: (1) Business Opportunity (BO) — technical assistance, training, market research, feasibility studies; (2) Business Enterprise (BE) — land acquisition, construction, equipment for rural business incubators or business parks.',
 10,
 '[
   {"label":"Project type clearly identified and activities match the eligible type","points":10},
   {"label":"Project type identified but some activities unclear","points":6},
   {"label":"Project type unclear or mixed","points":2}
 ]',
 'Project description clearly stating BO or BE type; list of proposed activities mapped to eligible uses.',
 30),

(rbdg_id, 'Project Design', 'RBDG Project Design & Narrative', 'p2',
 'Need and Community Benefit Narrative',
 'Clear statement of the economic need in the rural community and how the project addresses it. Include data on unemployment, poverty, median household income (MHI), population trends, and lack of services.',
 15,
 '[
   {"label":"Compelling, data-driven need statement with strong community benefit case","points":15},
   {"label":"Good narrative with some data","points":10},
   {"label":"General narrative lacking data","points":5},
   {"label":"Need not established","points":0}
 ]',
 'Census data, USDA ERS data, local economic studies, unemployment rates, MHI comparison to state/national average.',
 40),

(rbdg_id, 'Project Design', 'RBDG Project Design & Narrative', 'p3',
 'Jobs Created and Retained',
 'Number of full-time equivalent jobs to be created or retained as a direct result of the project. RBDG scoring rewards higher job impact.',
 15,
 '[
   {"label":"Clear, credible job creation projections with supporting methodology","points":15},
   {"label":"Job projections provided but methodology weak","points":10},
   {"label":"General job claims without support","points":5},
   {"label":"No job creation claimed or documented","points":0}
 ]',
 'Job creation/retention projections with methodology; letters from businesses committing to hire; wage and benefit information.',
 50),

(rbdg_id, 'Budget & Leverage', 'RBDG Budget & Leverage', 'b1',
 'Budget Completeness and Allowable Costs',
 'SF-424A budget is complete, costs are allowable under RBDG, and budget is proportional to the proposed activities. Administrative costs must not exceed the agency maximum.',
 10,
 '[
   {"label":"Complete SF-424A with all allowable costs clearly justified","points":10},
   {"label":"Budget mostly complete with minor gaps","points":6},
   {"label":"Incomplete or unclear budget","points":2},
   {"label":"Budget not prepared","points":0}
 ]',
 'Completed SF-424A; budget narrative explaining each line item; vendor quotes for equipment or services.',
 60),

(rbdg_id, 'Budget & Leverage', 'RBDG Budget & Leverage', 'b2',
 'Leverage — Non-Federal Matching Funds',
 'The extent to which the applicant has secured or committed non-federal funds to leverage the RBDG grant. Higher leverage ratios improve competitive standing.',
 15,
 '[
   {"label":"50% or more of total project cost from non-federal sources, with commitment letters","points":15},
   {"label":"25-49% non-federal match committed","points":10},
   {"label":"Some non-federal funds planned but not committed","points":5},
   {"label":"No matching funds","points":0}
 ]',
 'Commitment letters from banks, foundations, local government, or other funders showing amount and conditions.',
 70),

(rbdg_id, 'Compliance', 'RBDG Compliance Readiness', 'c1',
 'Civil Rights and Non-Discrimination Compliance',
 'Applicant has civil rights policies and procedures in place: non-discrimination policy, complaint procedure, limited English proficiency (LEP) plan, and equal opportunity statement.',
 5,
 '[
   {"label":"Full civil rights compliance documentation in place","points":5},
   {"label":"Partial compliance documentation","points":3},
   {"label":"Not prepared","points":0}
 ]',
 'Non-discrimination policy; LEP plan; civil rights training records; complaint log.',
 80),

(rbdg_id, 'Compliance', 'RBDG Compliance Readiness', 'c2',
 'Environmental Review Readiness',
 'Applicant understands and is prepared for USDA environmental review requirements under NEPA. BE projects typically require more environmental documentation than BO projects.',
 10,
 '[
   {"label":"Environmental review documentation prepared or plan in place","points":10},
   {"label":"Aware of requirements but documentation not started","points":5},
   {"label":"Not aware of or prepared for environmental review","points":0}
 ]',
 'Environmental questionnaire; phase I environmental assessment (if applicable); floodplain/wetland determination.',
 90)

ON CONFLICT DO NOTHING;

-- ══════════════════════════════════════════════════════════
-- IRP RUBRIC (Intermediary Relending Program)
-- ══════════════════════════════════════════════════════════

INSERT INTO scoring_rubrics (program_type, version, title, description, max_points)
VALUES (
  'irp', '2024',
  'USDA IRP Readiness Rubric',
  'Intermediary Relending Program readiness assessment. IRP provides low-interest loans to intermediaries (CDFIs, nonprofits, public bodies) that on-lend to rural businesses and communities. This rubric assesses organizational readiness to apply for and manage IRP funds.',
  100
)
ON CONFLICT (program_type, version) DO NOTHING;

SELECT id INTO irp_id FROM scoring_rubrics WHERE program_type = 'irp' AND version = '2024';
IF irp_id IS NULL THEN RETURN; END IF;

INSERT INTO scoring_criteria (rubric_id, section_code, section_label, criterion_code, criterion_label, description, max_points, point_bands, evidence_hint, sort_order)
VALUES

(irp_id, 'Eligibility', 'IRP Eligibility', 'ie1',
 'Eligible Intermediary Type',
 'IRP eligible intermediaries: private nonprofit community development organizations, nonprofit entities organized under state law as nonprofit, Indian tribes, public agencies, and cooperatives. Must be located in rural areas or serving rural borrowers.',
 15,
 '[
   {"label":"Confirmed eligible intermediary with complete documentation","points":15},
   {"label":"Likely eligible but documentation incomplete","points":8},
   {"label":"Eligibility unclear","points":0}
 ]',
 'Nonprofit determination letter, articles of incorporation, IRS 501(c)(3) letter, organizational chart.',
 10),

(irp_id, 'Financial Capacity', 'IRP Financial Capacity', 'if1',
 'Audited Financial Statements and Fund Management',
 'Three years of audited financial statements demonstrating organizational financial health, ability to manage loan funds, and experience with restricted funding sources.',
 20,
 '[
   {"label":"3 years of clean audits with strong fund balance and federal grant management","points":20},
   {"label":"Audits available with minor findings","points":14},
   {"label":"Financial statements available but unaudited","points":8},
   {"label":"No financial documentation","points":0}
 ]',
 'Audited financial statements for 3 prior years; Single Audit (if applicable); management letter responses.',
 20),

(irp_id, 'Lending Experience', 'IRP Lending History', 'il1',
 'Prior Lending Portfolio and Performance',
 'History of making loans to rural businesses or communities. Number of loans made, total dollar amount, repayment performance, and default rates over prior 3 years.',
 25,
 '[
   {"label":"Strong 3-year lending history with low default rate and documented portfolio performance","points":25},
   {"label":"Good lending history with some performance data","points":18},
   {"label":"Limited lending history","points":10},
   {"label":"No prior lending experience","points":0}
 ]',
 'Loan portfolio summary: count, dollar amount, rural %, on-time rate, defaults, loss reserve level.',
 30),

(irp_id, 'Compliance', 'IRP Compliance Readiness', 'ic1',
 'Written Loan Fund Policies',
 'Written loan policies covering: eligible borrowers, eligible uses, loan sizing, interest rate policy, collateral requirements, underwriting standards, servicing, collections, and workout procedures.',
 20,
 '[
   {"label":"Comprehensive written loan policies covering all key areas","points":20},
   {"label":"Policies present but gaps in key areas","points":13},
   {"label":"Partial policies only","points":7},
   {"label":"No written loan policies","points":0}
 ]',
 'Loan policy and procedures manual; underwriting guidelines; collections and workout policy.',
 40),

(irp_id, 'Compliance', 'IRP Compliance Readiness', 'ic2',
 '2 CFR 200 Compliance Readiness',
 'Readiness to comply with Uniform Guidance (2 CFR 200): financial management standards, procurement, property management, reporting, record-keeping, and subrecipient monitoring.',
 10,
 '[
   {"label":"Full 2 CFR 200 compliance systems in place (financial management, procurement, reporting)","points":10},
   {"label":"Partially compliant with gaps identified and plan to address","points":6},
   {"label":"Limited compliance infrastructure","points":2},
   {"label":"No 2 CFR 200 compliance experience","points":0}
 ]',
 'Financial management system documentation; procurement policy; records retention schedule; prior federal audit results.',
 50),

(irp_id, 'Program Design', 'IRP Program Design', 'ip1',
 'Relending Plan and Rural Business Impact',
 'Plan for how IRP funds will be relent to rural businesses: target borrowers, loan sizing, terms, geographic focus, expected number of loans, and job creation projections.',
 10,
 '[
   {"label":"Detailed relending plan with specific targets, rural focus, and credible job impact","points":10},
   {"label":"Good plan with some specificity","points":7},
   {"label":"General plan without specifics","points":3},
   {"label":"No relending plan","points":0}
 ]',
 'Written relending plan: target borrowers, loan products, geographic area, 3-year volume projections, job creation estimates.',
 60)

ON CONFLICT DO NOTHING;

RAISE NOTICE 'RBDG rubric seeded: %, IRP rubric seeded: %', rbdg_id, irp_id;

END $$;

-- RLF Ops rubric (placeholder — full content in later phase)
INSERT INTO scoring_rubrics (program_type, version, title, description, max_points)
VALUES (
  'rlf_ops', '2024',
  'RLF Operational Readiness Review',
  'Assesses whether an existing or proposed revolving loan fund has the policies, procedures, governance, financial controls, and compliance systems needed to operate effectively.',
  100
)
ON CONFLICT (program_type, version) DO NOTHING;

INSERT INTO scoring_rubrics (program_type, version, title, description, max_points)
VALUES (
  'full_binder', '2024',
  'Full Application Binder Gap Analysis',
  'Comprehensive review of an RMAP or RBDG application binder against the complete checklist of required documents, forms, and attachments. Identifies missing or incomplete items.',
  100
)
ON CONFLICT (program_type, version) DO NOTHING;
