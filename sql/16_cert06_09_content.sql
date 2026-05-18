-- ============================================================
-- Cap Fund Academy — Cert 6-9 Full Content
-- File: 16_cert06_09_content.sql
-- Idempotent: ON CONFLICT DO NOTHING
-- Run after: 04_cert_seeds.sql
-- ============================================================

-- ============================================================
-- CERT 6: USDA RBDG Rural Business Development Grant & RLF
-- ============================================================
DO $$
DECLARE
  cert_id   uuid;
  mod1_id   uuid;
  mod2_id   uuid;
  mod3_id   uuid;
  mod4_id   uuid;
  mod5_id   uuid;
  quiz_id   uuid;
BEGIN

SELECT id INTO cert_id FROM certifications WHERE cert_number = 6;
IF cert_id IS NULL THEN
  RAISE EXCEPTION 'Cert 6 not found — run 04_cert_seeds.sql first';
END IF;

UPDATE certifications SET
  learning_outcomes = ARRAY[
    'Distinguish Business Opportunity and Business Enterprise project types under RBDG',
    'Identify eligible and ineligible applicants and project activities for RBDG',
    'Design an RBDG-eligible Revolving Loan Fund (RLF) project including startup and working capital parameters',
    'Create a compliant scope of work, budget structure, and narrative for an RBDG application',
    'Score an RBDG application using leverage ratio, economic distress, and applicant experience criteria'
  ],
  status = 'approved'
WHERE id = cert_id;

-- ============================================================
-- MODULE 1: RBDG Overview
-- ============================================================
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'RBDG Overview',
  'Understand eligible applicants, the two project types, what RBDG funds, and what is ineligible.',
  1, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod1_id FROM modules WHERE certification_id = cert_id AND sort_order = 1;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod1_id,
  'RBDG Program Structure and Eligible Applicants',
  'cert06-rbdg-overview',
  E'## What Is RBDG?\n\nThe Rural Business Development Grant (RBDG) program, authorized under 7 U.S.C. 1932(c) and administered by USDA Rural Development, provides competitive grants to eligible entities that support rural small businesses. RBDG replaced the former Rural Business Opportunity Grant (RBOG) program and shares administrative space with RBEG (Rural Business Enterprise Grant) in agency practice.\n\nRBDG grants are awarded through a competitive process. There is no annual application deadline in the traditional sense — USDA publishes a Notice of Solicitation of Applications (NOSA) each program year, typically through the Federal Register and Grants.gov, and applicants must respond within the announced window.\n\n## Eligible Applicants\n\nNot every organization can apply for RBDG. The eligible applicant list is specific:\n\n- **Rural public entities** — towns, counties, municipalities, and other units of general local government in rural areas\n- **Nonprofit corporations and associations** — organized under state law, with IRS determination or equivalent proof of nonprofit status\n- **Federally-recognized Indian tribes** — acting in their governmental capacity\n- **Rural electric cooperatives** — specifically those operating in rural areas\n- **Public and quasi-public agencies** — regional planning commissions, economic development districts, and similar entities\n\nFor-profit businesses, private individuals, state government agencies acting alone, and urban-based entities are generally NOT eligible. A nonprofit headquartered in a city may still be eligible if it demonstrates service to rural areas, but this requires clear documentation in the application.\n\n## The Two RBDG Project Types\n\nRBDG divides all projects into two categories. Understanding the difference is fundamental — scoring criteria, budget requirements, and compliance obligations differ between them.\n\n### Business Opportunity Projects\nBusiness Opportunity projects support the planning and feasibility side of rural economic development. These projects are designed to help rural areas identify, evaluate, and position themselves to attract or grow businesses. Examples include:\n\n- Feasibility studies for new rural enterprises\n- Training and technical assistance for rural businesses and entrepreneurs\n- Leadership and entrepreneurship development programs\n- Community economic development planning\n- Establishment and operation of a **Revolving Loan Fund (RLF)** to provide startup capital and working capital loans to rural small businesses\n- Business incubator planning and development\n- Market research and business plan development assistance\n\nThe key characteristic: Business Opportunity projects primarily benefit rural communities broadly, not a single business.\n\n### Business Enterprise Projects\nBusiness Enterprise projects support direct assistance to specific rural businesses. These are more targeted and involve:\n\n- Acquisition or development of real estate for rural business use\n- Construction, expansion, or modernization of rural business facilities\n- Purchase of equipment for a specific rural business\n- Working capital for a specific rural business (in limited circumstances)\n- Technical assistance to a specific rural business\n\nThe key characteristic: Business Enterprise projects directly benefit an identified rural small business, not a program or community broadly.\n\n## What Is NOT Eligible\n\nCertain activities are expressly excluded from RBDG funding regardless of project type:\n\n- **Projects in urban areas** — all assisted businesses and activities must be in rural areas (populations under 50,000)\n- **Assistance to large businesses** — RBDG serves small businesses as defined by SBA size standards\n- **Construction of buildings for rental or lease** purely for investment return\n- **Charitable, religious, or political activities** as the primary purpose\n- **Projects with no nexus to rural small business development** — general community development unconnected to business creation or support\n- **Businesses ineligible for USDA rural development programs** (e.g., businesses engaged in gambling, illegal activities, or activities prohibited by 7 CFR 4280)\n\n## Rural Area Requirement\n\nAll RBDG-assisted businesses and beneficiaries must be located in rural areas. Per USDA Rural Development policy, a rural area is any area not within a city or town with a population exceeding 50,000. Some RBDG activities (particularly Business Opportunity projects with regional scope) may serve multiple rural communities — in these cases, the applicant must demonstrate that the preponderance of benefit flows to rural areas.\n\n## Program Year and Funding\n\nRBDG is funded annually through the appropriations process. Award amounts vary by year. USDA state offices administer RBDG locally, and each state office has discretion over which projects to fund within national program guidelines. Applicants should contact their USDA Rural Development state office to understand local priorities before submitting an application.',
  'RBDG funds rural economic development through two project types. Learn who can apply, what each project type funds, and what is excluded.',
  20, 1, 'approved')
ON CONFLICT DO NOTHING;

-- ============================================================
-- MODULE 2: RBDG RLF Design
-- ============================================================
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'RBDG RLF Design',
  'Design an RBDG-funded Revolving Loan Fund including loan parameters, security requirements, and how it differs from RMAP RMRF.',
  2, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod2_id FROM modules WHERE certification_id = cert_id AND sort_order = 2;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod2_id,
  'Designing an RBDG-Funded Revolving Loan Fund',
  'cert06-rbdg-rlf-design',
  E'## How RBDG Funds an RLF\n\nEstablishing a Revolving Loan Fund is one of the most common and impactful uses of RBDG Business Opportunity funds. Under this structure, the RBDG grant award is deposited into a restricted RLF account. The grantee then lends those funds to eligible rural small businesses. As borrowers repay, the funds revolve back into the RLF and are re-lent — creating a self-sustaining capital pool from a one-time grant.\n\nThis is distinct from USDA RMAP, where USDA makes a **direct loan** to the microlender to capitalize the RMRF. Under RBDG, the funds are a **grant** — there is no repayment obligation to USDA for the initial capitalization. This makes RBDG-funded RLF capital particularly valuable: it is permanent grant capital, not debt.\n\n## Loan Parameters for RBDG RLF\n\nUnlike RMAP, which has a statutory $50,000 microloan cap, RBDG does not impose a fixed maximum loan size. However, the grantee''s approved loan fund design governs parameters. Typical RBDG RLF designs include:\n\n| Parameter | Typical Range |\n|-----------|---------------|\n| Minimum loan size | $5,000 |\n| Maximum loan size | $150,000–$250,000 (or as approved) |\n| Maximum term | 10 years (equipment/real estate); 3–5 years (working capital) |\n| Interest rate | Fixed or variable; must be at or below market for similar risk |\n| Eligible uses | Startup capital, working capital, equipment, real estate |\n\n**Startup capital loans** are a key RBDG RLF feature. New businesses in rural areas often cannot access traditional bank financing at formation. An RBDG RLF can specifically target pre-revenue or early-stage businesses.\n\n**Working capital loans** provide short-term liquidity for rural businesses managing cash flow gaps, seasonal fluctuations, or growth-related working capital needs.\n\n## Security Requirements\n\nRBDG RLF loans must be adequately secured to protect the revolving fund. Standard security requirements include:\n\n- **UCC-1 financing statements** filed in the appropriate state jurisdiction for all personal property collateral (equipment, inventory, receivables) — governed by UCC Article 9\n- **Deed of trust or mortgage** for any real property collateral\n- **Personal guarantees** from principals owning 20% or more of the business\n- **Corporate guarantees** when applicable\n- **Assignment of life insurance** for key-person risk on larger loans\n\nThe grantee''s written loan fund policy must specify minimum collateral coverage ratios. A common standard is 100–150% collateral coverage (collateral value equals or exceeds the outstanding loan balance).\n\nFor startup businesses with limited hard collateral, RBDG RLFs may accept:\n- Future receivables or contracts as collateral\n- Business equipment being purchased with the loan\n- Character-based underwriting supplemented by a personal guarantee\n\n## How RBDG RLF Differs from RMAP RMRF\n\n| Factor | RBDG RLF | RMAP RMRF |\n|--------|----------|----------|\n| Capitalization type | Grant (no repayment to USDA) | Loan (must be repaid to USDA) |\n| Maximum loan size | No statutory cap (set by grantee policy) | $50,000 per microborrower |\n| Eligible borrowers | Rural small businesses broadly | Microenterprises (≤10 FTE) |\n| TA requirement | Not mandatory (but encouraged) | Mandatory by regulation |\n| Loan Loss Reserve | Not specifically required by RBDG | Required at 5% of USDA balance |\n| Revolving income | Stays in RLF (program income) | Stays in RMRF |\n| Eligible applicants | Broader (public entities, nonprofits, tribes) | Narrower (nonprofits, tribes, public higher ed) |\n\nThis comparison matters for capital stack strategy: RBDG provides grant-based RLF capital with fewer restrictions on loan size and borrower type, making it an ideal first-stage fund. RMAP adds dedicated microloan capital with built-in TA requirements. Together, they can serve a broader spectrum of rural borrowers.\n\n## Program Income Rules for RBDG RLF\n\nLoan repayments flowing back into an RBDG RLF constitute **program income** under 2 CFR 200.307. The grantee must use program income for the same authorized purposes as the original grant — re-lending to rural small businesses. Program income may not be used for:\n\n- General operating expenses of the grantee organization (unless approved)\n- Non-rural activities\n- Activities outside the approved grant scope\n\nGrantees must track program income separately and report it in annual performance reports to USDA.\n\n## Building the RLF Policy Document\n\nBefore RBDG funds can be disbursed into an RLF, the grantee must have a written **Loan Fund Policy** approved by their governing board. Required sections include:\n\n1. Fund purpose and eligible borrowers\n2. Geographic service area\n3. Eligible and ineligible loan uses\n4. Loan size range (minimum and maximum)\n5. Interest rate methodology\n6. Term limits by loan type\n7. Collateral and security requirements\n8. Underwriting criteria\n9. Approval authority (staff vs. board/loan committee)\n10. Delinquency and default procedures\n11. Program income management\n\nThis policy document is typically submitted as part of the RBDG application and must be in place before USDA releases funds.',
  'RBDG grant capital can establish a permanent Revolving Loan Fund. Learn loan parameters, security requirements, and how RBDG RLF compares to RMAP RMRF.',
  22, 1, 'approved')
ON CONFLICT DO NOTHING;

-- ============================================================
-- MODULE 3: Scope, Narrative, and Application
-- ============================================================
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Scope, Narrative, and Application',
  'Write a compelling RBDG project need statement, scope, narrative, and job creation projections.',
  3, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod3_id FROM modules WHERE certification_id = cert_id AND sort_order = 3;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod3_id,
  'Writing the RBDG Project Need Statement and Narrative',
  'cert06-rbdg-narrative',
  E'## The Project Need Statement\n\nThe need statement is the foundation of your RBDG application. It answers the question: **Why does this rural community need this project right now?** USDA reviewers read dozens of applications. A need statement backed by current, specific data stands out from vague or generic descriptions.\n\n### Data Sources for Your Need Statement\n\nUse verifiable, publicly available sources:\n\n- **U.S. Census Bureau American Community Survey (ACS)** — median household income (MHI), poverty rate, population, employment by industry\n- **Bureau of Labor Statistics (BLS)** — unemployment rate at county level\n- **USDA Economic Research Service (ERS)** — rural classification, persistent poverty county designations\n- **State Department of Labor** — local area unemployment statistics\n- **Federal Reserve community development reports** — credit gap analyses for rural areas\n- **SBA Office of Advocacy** — small business lending deserts by county\n\n### Need Statement Template\n\n> *[County/service area] has a population of [X], with a median household income of $[Y] compared to the state median of $[Z] ([%] below). The county unemployment rate is [X]%, compared to the state rate of [Y]%. [X]% of residents live below the poverty line. Despite [number] rural businesses operating in the area, access to small business capital remains severely constrained: [source] documents that [county] is a small business lending desert, with fewer than [X] SBA loans originated in the past [Y] years.\n\n> Small businesses in this region face a critical capital gap. Traditional lenders require collateral and credit history that many rural entrepreneurs — including returning citizens, agricultural transition workers, and minority entrepreneurs — cannot provide. [Organization name] proposes to establish a $[X] Revolving Loan Fund to fill this gap by providing startup capital and working capital loans of $[range] to rural small businesses in [service area].*\n\n## Service Area Documentation\n\nClearly define the geographic service area. For each county or community in the service area, document:\n\n- Population (current census data)\n- Rural classification (rural area per USDA definition)\n- Poverty rate\n- Unemployment rate\n- Median household income relative to state and national benchmarks\n- Any USDA-designated distress indicators (persistent poverty, high unemployment, low income)\n\nA simple table works well:\n\n| County | Population | Poverty Rate | Unemployment | MHI | vs. State MHI |\n|--------|------------|--------------|--------------|-----|---------------|\n| [Name] | [X] | [X]% | [X]% | $[X] | -[X]% |\n\n## Coordination With Other Programs\n\nRBDG applications score higher when they demonstrate coordination with complementary programs. Document existing relationships with:\n\n- USDA RMAP microlenders in the service area (are you applying to complement an existing microloan program?)\n- SBA lenders and SBA microloan intermediaries\n- CDFI Fund-certified lenders\n- State rural revolving loan funds\n- Economic Development Administration (EDA) programs\n- Local banks and credit unions (as referral partners for deals too large for the RLF)\n\nCoordination letters from these partners — even brief letters confirming the partnership and expressing support — strengthen both the narrative and the leverage section of the application.\n\n## Job Creation Projections\n\nJob creation is a core RBDG outcome metric. USDA will ask how many jobs the project is expected to create or retain. Be specific and defensible:\n\n**For RLF projects:** Project the number of loans you expect to make in the first 1, 2, and 3 years. For each loan tranche, estimate average jobs created per loan based on comparable programs or your own lending history.\n\nExample projection table:\n\n| Year | Projected Loans | Avg. Loan Size | Jobs Created per Loan | Total Jobs |\n|------|----------------|----------------|-----------------------|------------|\n| 1 | 8 | $35,000 | 1.5 | 12 |\n| 2 | 12 | $40,000 | 1.5 | 18 |\n| 3 | 15 | $45,000 | 2.0 | 30 |\n| **Total** | **35** | | | **60** |\n\nDo not inflate these numbers. Reviewers are experienced and will flag projections that are implausible given fund size and service area. Conservative, well-documented projections are more credible than ambitious but unsupported ones.\n\n## The Compelling Narrative: Structure\n\nA strong RBDG narrative follows this structure:\n\n1. **Community Context** (need statement — data-driven, 1-2 paragraphs)\n2. **Project Description** (what you will do, for whom, how — 2-3 paragraphs)\n3. **Organizational Capacity** (your track record, staff, systems — 1-2 paragraphs)\n4. **Partnerships and Leverage** (other funds, in-kind, commitments — 1 paragraph)\n5. **Expected Outcomes** (jobs, loans, businesses served — 1 paragraph with data table)\n6. **Sustainability** (how the RLF or project continues after the grant period — 1 paragraph)\n\nWrite in active voice. Quantify everything you can. Avoid jargon that USDA reviewers may not recognize. Have someone unfamiliar with your organization read the narrative before submission — if they can understand it, USDA reviewers will too.',
  'A data-rich need statement and well-structured narrative are the foundation of a successful RBDG application. Learn the template and data sources.',
  21, 1, 'approved')
ON CONFLICT DO NOTHING;

-- ============================================================
-- MODULE 4: RBDG Scoring and Leverage
-- ============================================================
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'RBDG Scoring and Leverage',
  'Understand how RBDG applications are evaluated: leverage ratio, economic distress, applicant experience, jobs, and matching funds.',
  4, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod4_id FROM modules WHERE certification_id = cert_id AND sort_order = 4;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod4_id,
  'RBDG Scoring Criteria, Leverage, and Matching Funds',
  'cert06-rbdg-scoring',
  E'## How RBDG Applications Are Evaluated\n\nRBDG is a competitive grant program. USDA state offices score applications using published criteria. While specific point allocations may vary by state office and program year Notice of Solicitation, the following factors are consistently evaluated across RBDG competitions:\n\n### 1. Leverage Ratio\nLeverage is typically the highest-weighted criterion. USDA wants to see that its grant dollars attract additional investment. Leverage includes:\n\n- Committed cash from other sources (other grants, bank loans, grantee reserves)\n- In-kind contributions (staff time, office space, equipment) at documented fair market value\n- Loans from partner CDFIs or banks committed to the project\n\n**Leverage ratio calculation:**\n\nLeverage Ratio = Total Non-Federal Funds ÷ RBDG Grant Request\n\nA project requesting $200,000 in RBDG that has documented $300,000 in matching funds has a leverage ratio of 1.5:1. Higher ratios score better.\n\n**Important:** Leverage must be **committed**, not aspirational. Commitment letters from each source are required. A letter saying "we intend to support this project" is weaker than a letter from a bank saying "we have approved a $X loan for this project, contingent on RBDG award."\n\n### 2. Economic Distress Indicators\nProjects serving areas with measurable economic distress score higher. USDA evaluates:\n\n- **Population decline** — Has the service area population declined over the past decade?\n- **Unemployment rate** — Is local unemployment above state or national averages?\n- **Median Household Income (MHI)** — Is MHI below 80% of state or national MHI?\n- **Poverty rate** — Is the poverty rate above state average?\n- **Persistent poverty** — Has the county been designated as persistently poor (20%+ poverty for 30+ years)?\n- **Low income census tracts** — Are project beneficiaries concentrated in low-income census tracts?\n\nDocument each indicator with a specific data source and citation. Do not assert distress — prove it.\n\n### 3. Applicant Experience and Organizational Capacity\nRBDG scores the applicant''s ability to execute the project:\n\n- Years of experience serving rural businesses\n- Number and dollar volume of loans or grants previously managed\n- Staff qualifications relevant to the project (loan officers, business advisors)\n- Prior USDA grants and compliance record\n- Board composition and governance quality\n- Prior revolving loan fund or lending experience\n\nOrganizations applying for their first RBDG award should document comparable experience with other programs (SBA microloan intermediary, CDFI Fund grantee, state RLF manager).\n\n### 4. Job Creation and Business Assistance\nUSDA counts projected jobs created and businesses assisted as outcome measures:\n\n- Jobs created (full-time equivalent, permanent)\n- Jobs retained (with documentation of risk)\n- Businesses assisted (unduplicated count)\n- New businesses started\n\nFor RLF projects, these projections flow from your lending volume assumptions. Higher projections (if credible and well-documented) score better.\n\n### 5. Rural Area Priority\nProjects exclusively serving rural areas score higher than those with mixed rural/urban service areas. If your service area includes any non-rural communities, clearly delineate that RBDG funds will only benefit rural portions.\n\n## Budget Structure and Matching Funds\n\nRBDG budgets must distinguish between:\n\n- **RBDG grant funds** — What you are requesting from USDA\n- **Matching funds** — Non-federal contributions (cash and in-kind)\n- **Program income** — Anticipated loan repayments (for RLF projects, project out years 2-5)\n\nA typical RBDG RLF budget structure:\n\n| Budget Category | RBDG Funds | Match | Total |\n|-----------------|-----------|-------|-------|\n| RLF Capitalization | $180,000 | $120,000 | $300,000 |\n| Loan Origination/Admin (Year 1) | $15,000 | $10,000 | $25,000 |\n| TA to Borrowers | $5,000 | $15,000 | $20,000 |\n| **Total** | **$200,000** | **$145,000** | **$345,000** |\n\nNote: RBDG does not have a statutory matching requirement in the same way some programs do, but leverage is a competitive scoring factor. Applicants without matching funds are at a significant competitive disadvantage.\n\n## Commitment Letters\n\nEvery source of matching funds must be documented with a commitment letter. A strong commitment letter:\n\n- Is on the partner organization''s letterhead\n- Is signed by an authorized officer\n- States the specific dollar amount committed\n- States the form (cash grant, loan, in-kind)\n- States the condition (e.g., "contingent on RBDG award")\n- States the anticipated disbursement timeline\n\nCollect commitment letters before submitting the application — they are typically required at time of submission, not as a post-award condition.',
  'RBDG scoring weighs leverage, economic distress, applicant experience, and job creation. Learn how to structure your budget and document matching funds.',
  20, 1, 'approved')
ON CONFLICT DO NOTHING;

-- ============================================================
-- MODULE 5: Post-Award Compliance
-- ============================================================
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Post-Award Compliance',
  'Navigate environmental review, civil rights, 2 CFR 200, monitoring, and reporting requirements after an RBDG award.',
  5, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod5_id FROM modules WHERE certification_id = cert_id AND sort_order = 5;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod5_id,
  'RBDG Post-Award Compliance: Environmental Review, Civil Rights, and 2 CFR 200',
  'cert06-rbdg-compliance',
  E'## Environmental Review Requirements\n\nAll USDA Rural Development financial assistance, including RBDG grants, is subject to environmental review under the National Environmental Policy Act (NEPA) and USDA''s implementing regulations at 7 CFR Part 1970. The scope of review depends on the nature of the project.\n\n**For RLF Business Opportunity projects:** An RLF grant itself typically qualifies for a Categorical Exclusion (CE) — the lowest level of NEPA review — because it is a planning and capitalization activity with no direct physical impact. However, **each individual loan made from the RLF** may trigger project-level environmental review at the time of the loan, depending on the use of proceeds.\n\nLoans that fund ground disturbance, construction, or facility acquisition require environmental clearance before loan closing. The RLF operator must build this review into the loan closing process.\n\n**Practical steps:**\n- Include an environmental review checklist in your loan application intake\n- Identify any loans that may trigger review (construction, land acquisition, expansion)\n- Contact your USDA Rural Development state office environmental staff for guidance on specific loans\n- Never close a loan that triggers NEPA review without USDA clearance\n\n## Civil Rights Obligations\n\nRBDG grantees must comply with federal civil rights laws as a condition of the grant. Key requirements:\n\n**Title VI of the Civil Rights Act of 1964** — Prohibits discrimination on the basis of race, color, or national origin in any program receiving federal financial assistance. For RLF projects, this means you cannot deny loans or provide different loan terms based on these protected characteristics.\n\n**Equal Credit Opportunity Act (ECOA) and Regulation B** — Prohibits discrimination in credit transactions based on race, color, religion, national origin, sex, marital status, age, or receipt of public assistance. RLF lenders must comply even if they are not regulated financial institutions.\n\n**Section 504 of the Rehabilitation Act** — Prohibits discrimination against individuals with disabilities in federally funded programs. Your office, application process, and loan services must be accessible.\n\n**USDA nondiscrimination statement** — All RBDG grantee publications, websites, and loan materials must include the USDA nondiscrimination statement.\n\n**Fair Lending Documentation:**\n- Log every application received (date, applicant demographics if voluntarily provided, outcome)\n- Document the specific reason for any denial\n- Perform an annual review of denial rates by demographic category\n- Maintain records for at least 3 years (or as required by the grant agreement)\n\n## 2 CFR 200 Uniform Guidance Basics\n\nRBDG grants are subject to the Uniform Administrative Requirements, Cost Principles, and Audit Requirements for Federal Awards — commonly called the Uniform Guidance or 2 CFR 200. Key provisions for RBDG grantees:\n\n**Allowable Costs (2 CFR 200.405):** Grant funds may only be used for costs that are:\n- Allowable under the program regulations\n- Allocable to the grant\n- Reasonable (would a prudent person pay this?)\n- Consistently applied (same accounting treatment for federal and non-federal activities)\n\n**Program Income (2 CFR 200.307):** Loan repayments flowing back into the RBDG RLF are program income. They must be tracked separately and used for authorized RLF purposes.\n\n**Procurement Standards (2 CFR 200.317-.327):** If RBDG funds are used to procure services (e.g., hiring a consulting firm to provide TA to borrowers), the procurement must follow federal competition requirements. Micro-purchase threshold is $10,000; simplified acquisition threshold is $250,000.\n\n**Record Retention (2 CFR 200.334):** All financial and programmatic records must be retained for **3 years after the final expenditure report** is submitted. For ongoing RLF programs, this effectively means records must be kept as long as the RLF is active plus 3 years.\n\n**Single Audit (2 CFR 200.501):** Organizations expending $750,000 or more in federal awards in a fiscal year must have a Single Audit (formerly A-133 audit). Track your total federal expenditures — if RBDG plus other federal grants cross this threshold, a Single Audit is required.\n\n## Monitoring and Reporting\n\nRBDG grantees must submit performance reports to their USDA Rural Development state office. Typical reporting requirements:\n\n- **Semi-annual or annual performance reports** — number of loans made, dollars deployed, businesses assisted, jobs created/retained\n- **Financial reports** — RLF account balance, program income received and used\n- **Closeout report** — final accounting upon grant period end\n\nFor RLF projects, reporting continues as long as the RLF is active — this is an ongoing obligation, not just a grant-period requirement.\n\n**Build a compliance calendar** that includes:\n- Report due dates\n- Civil rights self-assessment (annual)\n- Environmental review checklist (each loan)\n- Board/loan committee meeting schedule\n- UCC continuation filing deadlines (UCC-1 financing statements expire after 5 years and must be continued)\n- Insurance certificate renewal tracking for borrowers',
  'RBDG post-award compliance includes NEPA environmental review, civil rights obligations, 2 CFR 200 cost principles, and ongoing monitoring and reporting.',
  19, 1, 'approved')
ON CONFLICT DO NOTHING;

-- ============================================================
-- QUIZ for Cert 6
-- ============================================================
INSERT INTO quizzes (id, certification_id, title, passing_score, status)
VALUES (uuid_generate_v4(), cert_id,
  'RBDG Rural Business Development Grant Knowledge Check',
  80, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO quiz_id FROM quizzes WHERE certification_id = cert_id;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order)
VALUES
(quiz_id,
  'Which of the following is an eligible RBDG applicant?',
  '[{"id":"a","text":"A private for-profit corporation"},{"id":"b","text":"A rural nonprofit corporation"},{"id":"c","text":"An individual entrepreneur"},{"id":"d","text":"A state government agency acting alone"}]',
  'b',
  'RBDG eligible applicants include rural public entities, nonprofit corporations, Federally-recognized Indian tribes, rural electric cooperatives, and public/quasi-public agencies. Private for-profit companies and individuals are not eligible.',
  1),

(quiz_id,
  'Under RBDG, which project type supports the establishment of a Revolving Loan Fund?',
  '[{"id":"a","text":"Business Enterprise project"},{"id":"b","text":"Business Opportunity project"},{"id":"c","text":"Community Development project"},{"id":"d","text":"Infrastructure project"}]',
  'b',
  'Establishing an RLF to provide startup and working capital to rural businesses is classified as a Business Opportunity project under RBDG — it benefits the rural community broadly rather than a single identified business.',
  2),

(quiz_id,
  'What is the key difference in how RBDG and RMAP capitalize a revolving loan fund?',
  '[{"id":"a","text":"RMAP uses grants; RBDG uses loans"},{"id":"b","text":"RBDG uses grants (no repayment to USDA); RMAP uses direct loans that must be repaid"},{"id":"c","text":"Both use grants with identical repayment terms"},{"id":"d","text":"RBDG requires a 50% match; RMAP does not"}]',
  'b',
  'RBDG capitalizes RLFs with grant funds — there is no repayment obligation to USDA. RMAP makes a direct loan to the microlender to capitalize the RMRF, which the microlender must repay.',
  3),

(quiz_id,
  'Loan repayments flowing back into an RBDG RLF are classified as:',
  '[{"id":"a","text":"Unrestricted revenue"},{"id":"b","text":"Program income under 2 CFR 200.307"},{"id":"c","text":"Federal expenditures subject to drawdown"},{"id":"d","text":"Grantee match contributions"}]',
  'b',
  'Repayments into an RBDG RLF are program income under 2 CFR 200.307 and must be used for the same authorized purposes as the original grant — re-lending to rural small businesses.',
  4),

(quiz_id,
  'Which of the following is the HIGHEST-weighted scoring criterion in most RBDG competitions?',
  '[{"id":"a","text":"Applicant experience"},{"id":"b","text":"Job creation projections"},{"id":"c","text":"Leverage ratio (non-federal matching funds)"},{"id":"d","text":"Project budget size"}]',
  'c',
  'Leverage — the ratio of non-federal committed funds to the RBDG grant request — is typically the highest-weighted competitive criterion. It demonstrates community investment and multiplies the impact of federal dollars.',
  5),

(quiz_id,
  'A RBDG applicant requesting $200,000 has documented $300,000 in non-federal committed funds. What is the leverage ratio?',
  '[{"id":"a","text":"0.67:1"},{"id":"b","text":"1:1"},{"id":"c","text":"1.5:1"},{"id":"d","text":"2:1"}]',
  'c',
  'Leverage ratio = Non-Federal Funds ÷ RBDG Grant = $300,000 ÷ $200,000 = 1.5:1. A ratio above 1:1 means the applicant is bringing more non-federal resources than it is requesting from USDA.',
  6),

(quiz_id,
  'Which of the following best describes what a commitment letter for RBDG leverage must include?',
  '[{"id":"a","text":"A general statement of community support"},{"id":"b","text":"The partner''s strategic plan for rural development"},{"id":"c","text":"A specific dollar amount, form of contribution, and authorized signature"},{"id":"d","text":"A copy of the partner organization''s IRS Form 990"}]',
  'c',
  'A strong commitment letter specifies the dollar amount, the form of contribution (cash, loan, in-kind), the condition (e.g., contingent on RBDG award), and is signed by an authorized officer on letterhead. General support statements are insufficient.',
  7),

(quiz_id,
  'Under 7 CFR Part 1970, an RBDG RLF capitalization grant typically qualifies for which level of NEPA review?',
  '[{"id":"a","text":"Environmental Impact Statement (EIS)"},{"id":"b","text":"Environmental Assessment (EA)"},{"id":"c","text":"Categorical Exclusion (CE)"},{"id":"d","text":"No review required"}]',
  'c',
  'An RLF capitalization grant is a planning and financial assistance activity with no direct physical impact, typically qualifying for a Categorical Exclusion (CE) under 7 CFR Part 1970. However, individual loans from the RLF may trigger project-level review.',
  8),

(quiz_id,
  'Which federal law prohibits RBDG RLF lenders from discriminating based on race, color, religion, national origin, sex, or marital status in credit transactions?',
  '[{"id":"a","text":"Community Reinvestment Act (CRA)"},{"id":"b","text":"Equal Credit Opportunity Act (ECOA)"},{"id":"c","text":"Fair Housing Act"},{"id":"d","text":"Bank Secrecy Act"}]',
  'b',
  'The Equal Credit Opportunity Act (ECOA) and its implementing Regulation B prohibit discrimination in credit transactions. RBDG RLF operators must comply with ECOA regardless of whether they are chartered financial institutions.',
  9),

(quiz_id,
  'Under 2 CFR 200.334, how long must RBDG grantees retain financial and programmatic records?',
  '[{"id":"a","text":"1 year after award closeout"},{"id":"b","text":"3 years after the final expenditure report is submitted"},{"id":"c","text":"5 years after the grant period ends"},{"id":"d","text":"Until the next USDA site visit"}]',
  'b',
  'Under 2 CFR 200.334, records must be retained for 3 years after submission of the final expenditure report. For active RLF programs, this effectively means records are maintained as long as the fund is active plus 3 years.',
  10),

(quiz_id,
  'At what federal expenditure threshold does an organization trigger a Single Audit requirement under 2 CFR 200.501?',
  '[{"id":"a","text":"$250,000"},{"id":"b","text":"$500,000"},{"id":"c","text":"$750,000"},{"id":"d","text":"$1,000,000"}]',
  'c',
  'Organizations expending $750,000 or more in total federal awards in a fiscal year must have a Single Audit. RBDG grantees receiving additional federal funds should track total federal expenditures carefully.',
  11),

(quiz_id,
  'Which of the following is NOT a typical eligible use of RBDG Business Enterprise project funds?',
  '[{"id":"a","text":"Purchase of equipment for a specific rural business"},{"id":"b","text":"Construction of a rural business facility"},{"id":"c","text":"Providing a revolving loan fund for general community use"},{"id":"d","text":"Technical assistance to a specific identified rural business"}]',
  'c',
  'A revolving loan fund for general community use is a Business Opportunity activity, not a Business Enterprise activity. Business Enterprise projects directly benefit a specific identified rural business.',
  12),

(quiz_id,
  'What must be included in an RBDG RLF Loan Fund Policy before USDA releases grant funds?',
  '[{"id":"a","text":"A list of the first 10 planned borrowers"},{"id":"b","text":"Sections covering eligible borrowers, loan parameters, collateral requirements, and approval authority"},{"id":"c","text":"A guarantee from a local bank"},{"id":"d","text":"SBA microloan intermediary certification"}]',
  'b',
  'The Loan Fund Policy must be approved by the governing board and include fund purpose, eligible borrowers, geographic area, loan parameters (size, term, rate), collateral requirements, underwriting criteria, approval authority, and default procedures.',
  13),

(quiz_id,
  'For UCC-1 financing statements filed to secure RBDG RLF loans, what happens after 5 years if no action is taken?',
  '[{"id":"a","text":"The lien automatically converts to a judgment lien"},{"id":"b","text":"The financing statement lapses and the security interest is no longer perfected"},{"id":"c","text":"USDA takes over the security interest"},{"id":"d","text":"The loan automatically accelerates"}]',
  'b',
  'Under UCC Article 9, a financing statement lapses and ceases to be effective 5 years after filing unless a continuation statement is filed within 6 months before lapse. RLF operators must track UCC continuation deadlines.',
  14),

(quiz_id,
  'Which USDA publication should an applicant monitor to learn when RBDG applications are being accepted?',
  '[{"id":"a","text":"The USDA Annual Budget Report"},{"id":"b","text":"The Notice of Solicitation of Applications (NOSA) in the Federal Register and Grants.gov"},{"id":"c","text":"The SBA Lending Statistics Quarterly Report"},{"id":"d","text":"The CDFI Fund Annual Award Announcement"}]',
  'b',
  'USDA publishes a Notice of Solicitation of Applications (NOSA) each program year through the Federal Register and Grants.gov that announces the application window, funding priorities, and submission requirements for RBDG.',
  15)
ON CONFLICT DO NOTHING;

END $$;
