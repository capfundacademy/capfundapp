-- ============================================================
-- Cap Fund Academy — Certification & Master Credential Seeds
-- File: 04_cert_seeds.sql
-- Idempotent: ON CONFLICT DO NOTHING on cert_number
-- Run after: 03_lms_schema.sql
-- ============================================================

-- ============================================================
-- Certifications (17 total)
-- ============================================================
INSERT INTO certifications (cert_number, title, slug, description, hours_min, hours_max, price_default, status, sort_order)
VALUES
  (1,
   'Microfinance Foundations & Borrower-Centered Lending',
   'microfinance-foundations',
   'Master the fundamentals of microfinance, microenterprise development organizations, borrower-centered lending principles, and the USDA RMAP regulatory framework. Build the foundational knowledge every RLF practitioner needs.',
   8, 10, 497.00, 'draft', 1),

  (2,
   'Revolving Loan Fund Design & Capitalization',
   'rlf-design-capitalization',
   'Design a compliant, sustainable revolving loan fund from the ground up. Covers fund structure, capitalization strategies, loan loss reserve requirements, board governance, and written loan fund policies.',
   10, 12, 497.00, 'draft', 2),

  (3,
   'USDA RMAP Eligibility, Application & Scoring',
   'rmap-eligibility-application-scoring',
   'A deep dive into USDA Rural Microentrepreneur Assistance Program eligibility requirements, the complete application process, and every scoring criterion in 7 CFR 4280.316. Learn how USDA reviewers score applications and how to maximize your points.',
   14, 16, 597.00, 'draft', 3),

  (4,
   'RMAP Microlender Operations, Loan Closing & Compliance',
   'rmap-microlender-operations',
   'Operational compliance for RMAP-approved microlenders. Covers loan origination, closing documentation, grant agreement obligations, annual reporting, site visits, and maintaining good standing with USDA Rural Development.',
   10, 12, 497.00, 'draft', 4),

  (5,
   'RMAP Technical Assistance & Training Program',
   'rmap-technical-assistance-training',
   'Design and deliver a compliant USDA RMAP Technical Assistance and Training (TA&T) program. Covers eligible TA activities, documentation requirements, the 25% TA cap, outcome tracking, and building TA partnerships.',
   8, 10, 497.00, 'draft', 5),

  (6,
   'USDA RBDG Rural Business Development Grant & RLF',
   'rbdg-rural-business-development-grant',
   'Master the Rural Business Development Grant program — eligibility, application strategy, RLF establishment requirements, and how RBDG capital stacks with RMAP. Includes case studies on successful fund capitalization through RBDG.',
   14, 16, 597.00, 'draft', 6),

  (7,
   'IRP and Federal Capital Stack Strategy',
   'irp-federal-capital-stack-strategy',
   'Understand the Intermediary Relending Program and how to build a diversified federal capital stack using IRP, RMAP, RBDG, CDFI Fund, and state RLF programs. Covers interest rate spreads, re-lending requirements, and portfolio management.',
   8, 10, 497.00, 'draft', 7),

  (8,
   'Underwriting, Credit Policy & Portfolio Risk',
   'underwriting-credit-policy-portfolio-risk',
   'Build a rigorous underwriting framework for microloans and small business loans. Covers cash flow analysis, global debt service, collateral valuation, credit scoring, loan policy development, and portfolio risk management.',
   12, 14, 597.00, 'draft', 8),

  (9,
   'Loan Servicing, Collections, Workouts & Default Management',
   'loan-servicing-collections-workouts',
   'Manage the full post-closing loan lifecycle. Covers payment processing, delinquency monitoring, collection procedures, loan modifications, workouts, forbearance agreements, and federal reporting for defaulted RMAP/RBDG loans.',
   10, 12, 497.00, 'draft', 9),

  (10,
   'Federal Compliance, Civil Rights, Environmental Review & 2 CFR 200',
   'federal-compliance-civil-rights-environmental',
   'Navigate the complete federal compliance landscape for USDA-funded RLF programs. Covers 2 CFR 200 Uniform Guidance, civil rights obligations (Section 504, Title VI, Equal Credit Opportunity Act), environmental review requirements, and record retention.',
   12, 14, 597.00, 'draft', 10),

  (11,
   'RLF Accounting, Fund Administration, Reporting & Audit Readiness',
   'rlf-accounting-administration-reporting',
   'Master RLF fund accounting, separate account requirements, financial statement preparation, USDA annual report submission, single audit preparation, and the financial management systems USDA requires.',
   12, 14, 597.00, 'draft', 11),

  (12,
   'Application Assembly, Evidence Documentation & AI-Assisted Scoring',
   'application-assembly-evidence-documentation',
   'Build a complete, evidence-rich USDA program application. Covers the evidence documentation framework, letters of support strategy, organizational capacity documentation, and how to use AI tools to assess and strengthen your application.',
   10, 12, 497.00, 'draft', 12),

  (13,
   'Community Outreach, Partnerships, Job Creation & Economic Impact',
   'community-outreach-partnerships-economic-impact',
   'Demonstrate measurable community impact. Covers borrower outreach strategy, partnership development with local lenders and CDFIs, job creation tracking, economic impact measurement, and building the community narrative USDA looks for.',
   8, 10, 497.00, 'draft', 13),

  (14,
   'Automated Offer, Sales Funnel & Enrollment Operations',
   'automated-offer-sales-funnel-enrollment',
   'Build an automated enrollment system for your certification business. Covers offer design, sales funnel architecture, payment processing, enrollment automation, onboarding sequences, and the operational systems to scale to hundreds of students.',
   10, 12, 497.00, 'draft', 14),

  (15,
   'Content Engine, Social Media Automation & Ads',
   'content-engine-social-media-automation-ads',
   'Build a content marketing engine that generates leads on autopilot. Covers content strategy for the rural finance niche, social media automation, paid advertising fundamentals, email nurture sequences, and audience building.',
   10, 12, 497.00, 'draft', 15),

  (16,
   'CRM, Applications, Customer Success & Business Operations',
   'crm-applications-customer-success-operations',
   'Operate a professional certification business. Covers CRM setup and automation, application management, customer success workflows, refund handling, student support systems, and the back-office operations of a scalable training company.',
   8, 10, 497.00, 'draft', 16),

  (17,
   'Master Capstone: USDA-Ready Microlending/RLF Program and Automated Certification Business',
   'master-capstone-usda-rlf-certification-business',
   'The culminating capstone integrating all 16 prior certifications. You will design a complete, submission-ready USDA microlending or RLF program AND build the operational architecture of an automated certification business. Includes live case review and instructor feedback.',
   16, 20, 997.00, 'draft', 17)

ON CONFLICT (cert_number) DO NOTHING;

-- ============================================================
-- Master Credentials (5 total)
-- ============================================================
INSERT INTO master_credentials (title, slug, description, required_cert_numbers)
VALUES
  (
    'Rural Microfinance Associate',
    'rural-microfinance-associate',
    'Foundational credential for practitioners entering the microfinance and rural lending field. Demonstrates mastery of microfinance principles, RLF design, RMAP eligibility, and microlender operations.',
    ARRAY[1,2,3,4]
  ),
  (
    'Revolving Loan Fund Practitioner',
    'revolving-loan-fund-practitioner',
    'Intermediate credential for RLF operators. Covers the complete loan lifecycle from fund design and USDA program mechanics through underwriting, servicing, and default management.',
    ARRAY[1,2,3,4,5,6,7,8,9]
  ),
  (
    'USDA Rural Capital Program Specialist',
    'usda-rural-capital-program-specialist',
    'Advanced credential for specialists in USDA rural capital programs. Demonstrates deep expertise in RMAP, RBDG, IRP, compliance, accounting, application assembly, and community economic impact.',
    ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13]
  ),
  (
    'Certified RLF Executive',
    'certified-rlf-executive',
    'Executive-level credential for leaders managing full-scale microlending programs and certification businesses. Adds automated operations, content marketing, and enrollment systems to the practitioner foundation.',
    ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
  ),
  (
    'Master Rural Microfinance & RLF Administrator',
    'master-rural-microfinance-rlf-administrator',
    'The highest credential in the Cap Fund Academy system. Awarded upon completion of all 17 certifications including the Master Capstone. Recognizes mastery of both USDA rural capital programs and the business systems to build a self-sustaining certification operation.',
    ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]
  )

ON CONFLICT (slug) DO NOTHING;
