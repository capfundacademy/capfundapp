-- ============================================================
-- Cap Fund Academy — All Things Lender Expanded Certifications
-- File: 27_cert_seeds_18_35.sql
-- Adds 18 net-new certifications (numbers 18-35)
-- Existing certs 1-17 cover RMAP/RLF core — these add the
-- full "All Things Lender" government lending ecosystem.
-- Run after: 04_cert_seeds.sql
-- ============================================================

INSERT INTO certifications (
  cert_number, title, slug, description,
  hours_min, hours_max, price_default, status, sort_order
)
VALUES

-- ── Level 1: Foundations ─────────────────────────────────────
(18,
 'Government Lending Models Foundations',
 'government-lending-models-foundations',
 'Understand every major government-backed lending model — approved lenders, intermediaries, relenders, secondary market participants, and investment fund models. Build the conceptual map that helps you choose the right path for your organization.',
 8, 10, 497.00, 'draft', 18),

(19,
 'Lending Entity, Licensing & Compliance Readiness',
 'lending-entity-licensing-compliance',
 'Navigate entity structure, state lending licenses, NMLS registration, SAM.gov and Grants.gov readiness, BSA/AML controls, OFAC screening, fair lending requirements, loan committee governance, and the compliance calendar every lender needs.',
 12, 15, 597.00, 'draft', 19),

-- ── SBA Programs ─────────────────────────────────────────────
(20,
 'SBA 7(a) & Small Business Lending',
 'sba-7a-small-business-lending',
 'Master the full SBA 7(a) lending ecosystem — Standard 7(a), SBA Small, SBA Express, Export Express, Export Working Capital, International Trade Loan, CAPLines, the 7(a) Working Capital Pilot, and the Community Advantage SBLC model. Learn how to package loans and partner with approved SBA lenders.',
 15, 20, 597.00, 'draft', 20),

(21,
 'SBA Microloan, CDC/504 & SBIC',
 'sba-microloan-cdc-504-sbic',
 'Become an expert on the SBA Microloan intermediary model, CDC/504 project finance, and the SBIC investment vehicle. Learn how to design borrower support systems, partner with Certified Development Companies, and understand when mission capital meets investment capital.',
 15, 20, 597.00, 'draft', 21),

-- ── USDA Rural Programs ───────────────────────────────────────
(22,
 'USDA Rural Business & OneRD Guaranteed Lending',
 'usda-rural-business-onerd-guaranteed',
 'Navigate the USDA OneRD platform — Business & Industry Guaranteed Loans, REAP, Community Facilities, Water & Waste Disposal, and Timber Production programs. Learn rural eligibility rules, loan packaging, risk management, and how to partner with USDA-approved lenders.',
 18, 24, 697.00, 'draft', 22),

(23,
 'USDA Housing & Multifamily Lending',
 'usda-housing-multifamily-lending',
 'Master USDA Rural Development housing programs — Section 502 Guaranteed and Direct, Section 504 Repair, Rural Housing Site Loans, Section 538 Multifamily Guarantees, Section 515 Direct Multifamily, Farm Labor Housing 514/516, and Housing Preservation Grants. Build rural housing capital stacks.',
 18, 24, 697.00, 'draft', 23),

(24,
 'USDA Farm & Agriculture Credit',
 'usda-farm-agriculture-credit',
 'Understand FSA guaranteed farm ownership and operating loans, land contract guarantees, FSA microloans, direct farm loan awareness, Farm Credit System structure, and financing strategies for beginning, socially disadvantaged, and rural farmers.',
 12, 15, 597.00, 'draft', 24),

-- ── FHA / VA / HUD ────────────────────────────────────────────
(25,
 'FHA, VA, USDA Mortgage & Native Housing Lending',
 'fha-va-usda-mortgage-native-housing',
 'Build expertise on government mortgage programs — FHA-approved mortgagee requirements, FHA Title II single-family lending, FHA Title I property improvement, VA lender approval, USDA rural housing lender approval, HUD Section 184 Native housing, and HUD Section 184A Native Hawaiian programs.',
 20, 25, 697.00, 'draft', 25),

(26,
 'FHA Multifamily, Healthcare & HUD Risk-Sharing',
 'fha-multifamily-healthcare-hud-risk-sharing',
 'Navigate FHA multifamily finance — MAP lender model, FHA 221(d)(4), 223(f), 223(a)(7), 241(a), FHA 232 Lean 232 healthcare, FHA 242 hospital mortgage, HUD 542(b) and 542(c) risk-sharing, and HUD Section 108. Structure project finance pathways for affordable housing and healthcare facilities.',
 18, 24, 697.00, 'draft', 26),

-- ── Secondary Markets ─────────────────────────────────────────
(27,
 'Secondary Market & Mortgage Liquidity',
 'secondary-market-mortgage-liquidity',
 'Understand Ginnie Mae issuer, Fannie Mae seller/servicer, and Freddie Mac seller/servicer approval paths, loan sale basics, servicing obligations, mortgage pipeline liquidity, and when to partner instead of becoming a direct market participant.',
 12, 15, 597.00, 'draft', 27),

-- ── CDFI & Community Investment ───────────────────────────────
(28,
 'CDFI, Treasury & Community Investment',
 'cdfi-treasury-community-investment',
 'Master CDFI certification requirements, target market strategy, community accountability, financial products design, CDFI Program FA/TA awards, Native American CDFI Assistance, CDFI Bond Guarantee, Capital Magnet Fund, New Markets Tax Credit, Community Development Entity model, Bank Enterprise Award, and Small Dollar Loan programs.',
 24, 30, 797.00, 'draft', 28),

-- ── State & Local ─────────────────────────────────────────────
(29,
 'SSBCI, State & Local Capital Access',
 'ssbci-state-local-capital-access',
 'Navigate the State Small Business Credit Initiative, state loan guarantees, loan participation programs, collateral support programs, Capital Access Program reserves, State Housing Finance Agency programs, CDBG revolving loan funds, HOME-funded housing loan pools, and local economic development loan funds.',
 15, 20, 597.00, 'draft', 29),

-- ── EDA RLF ───────────────────────────────────────────────────
(30,
 'EDA Revolving Loan Fund',
 'eda-revolving-loan-fund',
 'Build expertise on EDA economic development finance — RLF purpose and structure, eligible recipients and borrowers, Economic Adjustment Assistance RLFs, RLF plan requirements, gap financing strategy, prudent lending standards, job creation and retention documentation, portfolio management, reporting, compliance, and long-term sustainability.',
 18, 24, 697.00, 'draft', 30),

-- ── Environmental Finance ─────────────────────────────────────
(31,
 'EPA, Water & Environmental RLF',
 'epa-water-environmental-rlf',
 'Finance environmental cleanup and water infrastructure — Clean Water and Drinking Water State Revolving Funds, EPA Brownfields RLF, cleanup loans and subgrants, WIFIA project finance, USDA water/waste programs, environmental underwriting risks, public benefit documentation, and partnering with state environmental agencies.',
 15, 20, 597.00, 'draft', 31),

-- ── Infrastructure & Energy ───────────────────────────────────
(32,
 'Infrastructure, Energy, Transportation & Utility Finance',
 'infrastructure-energy-transportation-finance',
 'Build capital stacks for rural infrastructure — USDA Community Facilities, rural electric and telecom loans, USDA ReConnect broadband, Rural Energy Savings, DOE Title 17, DOE Tribal Energy Loan Guarantee, ATVM, DOT TIFIA and RRIF, State Infrastructure Banks, HRSA Health Center Facility Loan Guarantee, and public-private capital structures.',
 20, 25, 697.00, 'draft', 32),

-- ── Export Finance ────────────────────────────────────────────
(33,
 'Export, Trade & International Sales Finance',
 'export-trade-international-finance',
 'Finance small business exporters — EXIM Working Capital Guarantee, EXIM medium and long-term guarantees, EXIM export credit insurance, SBA Export Express, SBA Export Working Capital, SBA International Trade Loan, USDA/FAS agricultural export credit guarantees, and foreign buyer finance structures.',
 12, 15, 497.00, 'draft', 33),

-- ── Tribal Programs ───────────────────────────────────────────
(34,
 'Tribal & Native Lending Programs',
 'tribal-native-lending-programs',
 'Build capital access strategies for tribal communities — BIA Indian Loan Guarantee and Insurance Program, HUD Section 184 and 184A, Native CDFIs, Native American CDFI Assistance, Tribal SSBCI, DOE Tribal Energy Loan Guarantee, tribal government partnerships, sovereignty and legal considerations, and culturally responsive lending.',
 18, 24, 697.00, 'draft', 34),

-- ── Loan Servicing Awareness ──────────────────────────────────
(35,
 'Student Loan & Legacy Servicing Awareness',
 'student-loan-legacy-servicing',
 'Understand federal student loan program history, the Federal Direct Loan Program, FFEL and Perkins legacy portfolios, the difference between servicing and direct lending, and why federal student lending is not a new private lender pathway. Build a student loan referral and education guide for your borrowers.',
 6, 8, 397.00, 'draft', 35),

-- ── Capital Stack Strategy ────────────────────────────────────
(36,
 'Capital Stack Design & Partnership Strategy',
 'capital-stack-design-partnership',
 'Build a complete capital stack for a community lending platform — grant vs. debt capital, guarantees and credit enhancement, loan participation, tax credits, PRI and mission investment, CRA bank partnerships, philanthropic capital, public-sector partnerships, capital stack risk, partner pitch strategy, and funding source matrix design.',
 15, 20, 597.00, 'draft', 36)

ON CONFLICT (cert_number) DO NOTHING;

-- ── Master Credential Updates ─────────────────────────────────
-- Add new master credentials for the expanded curriculum
INSERT INTO master_credentials (title, slug, description, required_cert_numbers)
VALUES
  ('Capital Access Foundations Certificate',
   'capital-access-foundations',
   'Demonstrates foundational knowledge of government-backed lending models and capital access pathways.',
   ARRAY[18, 19]),

  ('Government Lending Program Associate',
   'government-lending-associate',
   'Understands SBA, USDA, HUD, CDFI, EDA, EPA, and state/local lending programs.',
   ARRAY[18, 19, 20, 21, 22, 23, 24, 25]),

  ('Revolving Loan Fund & Relending Practitioner',
   'rlf-relending-practitioner',
   'Can design, operate, and sustain loan funds and relending programs across multiple federal programs.',
   ARRAY[18, 19, 1, 2, 3, 4, 5, 6, 7, 30, 11, 8, 9]),

  ('Government Lending & Capital Access Strategist',
   'government-lending-strategist',
   'Builds program strategies, application-readiness systems, and multi-lane capital access platforms.',
   ARRAY[18, 19, 20, 21, 22, 28, 29, 30, 36, 22]),

  ('Master Capital Access Architect',
   'master-capital-access-architect',
   'The highest credential — designs a complete multi-lane capital access platform across all government lending programs. Requires completion of required core certifications, one specialty track, and a 15-deliverable capstone portfolio review.',
   ARRAY[18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36])

ON CONFLICT (slug) DO NOTHING;
