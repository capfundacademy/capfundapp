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

-- ============================================================
-- CERT 7: IRP and Federal Capital Stack Strategy
-- ============================================================
DO $$
DECLARE
  cert_id   uuid;
  mod1_id   uuid;
  mod2_id   uuid;
  mod3_id   uuid;
  mod4_id   uuid;
  quiz_id   uuid;
BEGIN

SELECT id INTO cert_id FROM certifications WHERE cert_number = 7;
IF cert_id IS NULL THEN
  RAISE EXCEPTION 'Cert 7 not found — run 04_cert_seeds.sql first';
END IF;

UPDATE certifications SET
  learning_outcomes = ARRAY[
    'Compare grant vs. debt capitalization strategies for rural revolving loan funds',
    'Explain how the IRP (Intermediary Relending Program) works and who is eligible',
    'Build a phased three-stage funding roadmap sequencing RBDG, RMAP, and IRP',
    'Assess staff capacity and compliance burden when adding federal programs',
    'Create blended-fund controls including account segregation, program income tracking, and source mapping'
  ],
  status = 'approved'
WHERE id = cert_id;

-- ============================================================
-- MODULE 1: IRP and Federal Capital Sources
-- ============================================================
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'IRP and Federal Capital Sources',
  'Understand the Intermediary Relending Program, how it compares to RMAP and RBDG, and the full landscape of federal and non-federal rural capital sources.',
  1, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod1_id FROM modules WHERE certification_id = cert_id AND sort_order = 1;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod1_id,
  'The Intermediary Relending Program and the Federal Capital Landscape',
  'cert07-irp-capital-sources',
  E'## What Is the Intermediary Relending Program (IRP)?\n\nThe Intermediary Relending Program (IRP) is a USDA Rural Development loan program authorized under 7 U.S.C. 1932(b). Unlike RMAP (which is partly grant-funded) and RBDG (which is entirely grant-funded), IRP is a **direct loan program** — USDA lends money to eligible intermediary organizations at a favorable below-market interest rate, and those intermediaries relend the funds to rural businesses and individuals.\n\n**How IRP works:**\n1. USDA approves an IRP loan to a qualifying intermediary (CDFI, nonprofit, or similar)\n2. The intermediary deposits the funds into an IRP revolving fund\n3. The intermediary relends the funds to rural businesses at rates and terms it determines, within program limits\n4. As businesses repay, funds revolve back and are relent\n5. The intermediary makes quarterly payments to USDA on the direct loan\n\n**IRP loan terms from USDA to intermediary:**\n- Interest rate: 1% fixed\n- Maximum term: 30 years\n- Maximum loan amount per IRP application: $2,000,000 (intermediary may hold multiple IRP loans)\n\n**IRP relending terms (intermediary to borrower):**\n- Maximum loan amount to any one borrower: $400,000\n- Maximum term: 30 years\n- Interest rate: Market rate or below — intermediary sets the rate\n\n## Eligible IRP Intermediaries\n\nNot every organization qualifies as an IRP intermediary. Eligible applicants include:\n\n- **Public bodies** — state, tribal, or local government entities\n- **Nonprofit entities** — corporations organized under state nonprofit law\n- **Cooperatives** — including electric cooperatives\n\nThe intermediary must demonstrate:\n- Technical, managerial, and financial capacity to operate a lending program\n- A service area that is primarily rural\n- A record of providing capital or services to rural businesses\n\nCDFIs with active RMAP or RBDG programs are well-positioned to apply for IRP — they already have the lending infrastructure and compliance systems in place.\n\n## How IRP Compares to RMAP and RBDG\n\n| Factor | RBDG | RMAP | IRP |\n|--------|------|------|-----|\n| Federal instrument | Grant | Direct loan (to intermediary) | Direct loan (to intermediary) |\n| USDA repayment required | No | Yes | Yes |\n| Rate to intermediary | N/A (grant) | Fixed (see 7 CFR 4280) | 1% fixed |\n| Max per borrower | No statutory cap | $50,000 | $400,000 |\n| Borrower type | Rural small businesses | Rural microenterprises (≤10 FTE) | Rural businesses broadly |\n| TA requirement | Not mandatory | Mandatory | Not mandatory |\n| Eligible intermediaries | Broader | Nonprofits, tribes, public HEIs | Public bodies, nonprofits, coops |\n\n## Other Federal and Non-Federal Capital Sources\n\n### EDA Revolving Loan Funds\nThe U.S. Economic Development Administration (EDA) administers its own RLF program under the Public Works and Economic Development Act. EDA RLF awards are grants, similar to RBDG. EDA prioritizes areas with significant economic distress. EDA RLFs can make larger loans (up to $500,000 or more) and are often used for real estate and infrastructure financing for rural businesses.\n\n### CDFI Fund Awards\nThe Community Development Financial Institutions Fund (Treasury) provides:\n- **Financial Assistance (FA) awards** — grants of up to $2M per application cycle to certified CDFIs for capital and operations\n- **Technical Assistance (TA) grants** — smaller grants for emerging CDFIs to build capacity\n- **CDFI Bond Guarantee Program** — long-term, fixed-rate bond financing for larger CDFIs\n\nCDFI certification is a prerequisite for CDFI Fund awards. The certification process takes 3-12 months and requires demonstrating a primary mission of community development lending, a predominant focus on underserved communities, and a track record of financial products and services.\n\n### CRA Bank Investments\nUnder the Community Reinvestment Act (CRA), federally regulated banks receive credit for investments in CDFIs and community development loan funds. Banks seeking CRA credit may:\n- Make equity-equivalent investments (EQ2s) in CDFI capital pools\n- Provide low-interest loans to CDFIs\n- Make grants to CDFIs for operations and TA\n\nBuilding relationships with regional and community banks seeking CRA credit can provide significant non-federal capital at favorable terms.\n\n### Philanthropic Capital\nFoundations and community foundations provide:\n- **Program-related investments (PRIs)** — loans or equity at below-market rates that count as charitable program activities\n- **Mission-related investments (MRIs)** — endowment investments aligned with foundation mission\n- **Operating grants** — unrestricted or restricted support for RLF operations and TA\n\nPhilanthropic capital is typically the most flexible (fewest restrictions) and highest-leverage relative to administrative burden.\n\n### State Rural Funds\nMost states operate rural economic development funds, often administered by state departments of agriculture, commerce, or community development. These vary widely by state but may include:\n- State-funded revolving loan programs\n- Rural economic development tax credit programs\n- State CDFI support programs\n- Agricultural development funds\n\nResearch your state''s rural development office and economic development authority for available capital programs.',
  'IRP is a 1% fixed-rate USDA loan to intermediaries who relend to rural businesses. Understand IRP alongside RBDG, RMAP, EDA, CDFI Fund, CRA, and state sources.',
  22, 1, 'approved')
ON CONFLICT DO NOTHING;

-- ============================================================
-- MODULE 2: Sequencing Capital
-- ============================================================
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Sequencing Capital',
  'Build a three-phase federal funding roadmap: start with RBDG, add RMAP when microlending capacity exists, add IRP when portfolio and systems are proven.',
  2, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod2_id FROM modules WHERE certification_id = cert_id AND sort_order = 2;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod2_id,
  'The Three-Phase Federal Funding Roadmap',
  'cert07-sequencing-capital',
  E'## Why Sequencing Order Matters\n\nOrganizations entering rural lending do not need to pursue every federal program simultaneously. In fact, attempting to manage RBDG, RMAP, and IRP concurrently from the start is a common mistake that leads to compliance failures, staff burnout, and poor loan outcomes.\n\nThe key insight is that **each program builds on the operational infrastructure of the prior one.** Programs have increasing compliance complexity, reporting burden, and staff capacity requirements. The right sequencing builds competence and systems incrementally.\n\n## Phase 1: RBDG First (Years 0-2)\n\n**Why start with RBDG:**\n\n- It is a grant — no USDA repayment obligation reduces financial pressure\n- It has the broadest eligible use scope (planning, TA, or RLF)\n- Compliance burden is manageable for a new lending organization\n- It allows you to build a lending track record before taking on USDA debt obligations\n- A small RBDG RLF ($100,000-$300,000) can demonstrate lending capacity at scale\n\n**Phase 1 Milestones:**\n\n| Timeline | Activity |\n|----------|----------|\n| Month 1-3 | Apply for RBDG (prepare application, collect commitment letters) |\n| Month 4-8 | USDA review and award |\n| Month 8-12 | Set up RLF account, adopt loan fund policy, originate first loans |\n| Year 1-2 | Build portfolio of 8-20 loans; document outcomes (jobs, businesses, repayment) |\n| Year 2 | Compile 24 months of lending data for RMAP application |\n\n**What you are building in Phase 1:**\n- Loan origination workflow\n- Underwriting process and credit policy\n- Loan committee structure\n- Borrower file documentation system\n- Basic financial tracking for program income\n- TA delivery capacity (prepare for RMAP''s mandatory TA requirement)\n\n## Phase 2: Add RMAP (Years 2-4)\n\n**When to add RMAP:**\n\nApply for RMAP when you can demonstrate:\n- At least 1-2 years of active microlending (from your RBDG RLF or other source)\n- A functioning TA program with documented outcomes\n- Staff capacity to manage additional compliance obligations (annual reporting, site visits, LLRF maintenance)\n- An RMRF design with a clear non-federal match source\n\n**What RMAP adds to the stack:**\n\n- Dedicated microloan capital (USDA direct loan to the intermediary, up to the approved RMRF level)\n- Mandatory TA&T funding (separate grant component)\n- Regulatory framework (7 CFR 4280) with specific performance metrics\n- USDA scoring that rewards your Phase 1 lending track record\n\n**Phase 2 Milestones:**\n\n| Timeline | Activity |\n|----------|----------|\n| Month 1-3 | Prepare RMAP application (using 2 years of RBDG lending data as evidence) |\n| Month 4-8 | USDA review and award |\n| Month 8-12 | Establish RMRF and LLRF accounts; originate first RMAP microloans |\n| Year 3-4 | Run parallel RBDG RLF and RMAP RMRF for different borrower tiers |\n\n**Differentiated use of the two RLFs:**\n\n| Borrower Size/Need | Recommended Fund |\n|--------------------|------------------|\n| Startups, <$25,000 | RMAP RMRF (with mandatory TA) |\n| Established businesses, $25,000-$150,000 | RBDG RLF |\n| Businesses needing TA only | RMAP TA grant |\n\n## Phase 3: Add IRP (Years 4-7)\n\n**When to add IRP:**\n\nIRP is appropriate when you can demonstrate:\n- A proven loan portfolio with 3+ years of repayment history\n- Systems capable of managing the 1% USDA loan repayment obligation\n- Staff capacity to underwrite and service larger loans ($100,000-$400,000)\n- Demand for loan sizes above the RMAP $50,000 cap\n- Financial strength to carry the IRP debt service (quarterly payments to USDA)\n\n**What IRP adds to the stack:**\n\n- Access to larger loan sizes (up to $400,000 per borrower)\n- 1% cost of funds — allows competitive below-market relending rates\n- 30-year term — supports real estate and long-term capital projects\n- No TA mandate — gives flexibility to serve business borrowers who do not need TA\n\n**Phase 3 Milestones:**\n\n| Timeline | Activity |\n|----------|----------|\n| Year 4 | Prepare IRP application with 3+ years of portfolio data |\n| Year 5 | IRP award; establish IRP relending fund separate from RBDG and RMAP accounts |\n| Year 5-7 | Three-tier lending operation: RMAP (micro), RBDG (small), IRP (medium) |\n\n## Three-Phase Funding Roadmap Template\n\n| Phase | Program | Capital Type | Max/Borrower | Primary Borrower |\n|-------|---------|--------------|--------------|------------------|\n| 1 | RBDG | Grant | No cap (policy-set) | Small rural businesses |\n| 2 | RMAP | USDA Loan | $50,000 | Rural microenterprises |\n| 3 | IRP | USDA Loan | $400,000 | Rural businesses (larger) |',
  'Sequence RBDG, RMAP, and IRP in three phases to build lending capacity incrementally. Each phase builds the infrastructure the next requires.',
  20, 1, 'approved')
ON CONFLICT DO NOTHING;

-- ============================================================
-- MODULE 3: Capacity and Compliance Burden
-- ============================================================
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Capacity and Compliance Burden',
  'Assess staff requirements, reporting load, audit requirements, TA caseload, and delinquency management for each program tier.',
  3, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod3_id FROM modules WHERE certification_id = cert_id AND sort_order = 3;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod3_id,
  'Stress-Testing Staff Capacity Across Multiple Federal Programs',
  'cert07-capacity-compliance',
  E'## The Compliance Burden Reality\n\nEvery federal lending program comes with a compliance tail — reporting requirements, audit obligations, monitoring visits, and regulatory constraints that require dedicated staff time. Organizations that underestimate this burden add programs faster than their capacity can support, leading to:\n\n- Missed reporting deadlines (a compliance violation that can jeopardize awards)\n- Inadequate borrower monitoring (leading to higher delinquency rates)\n- Staff burnout and turnover\n- Quality-of-service deterioration for borrowers\n- USDA dissatisfaction and potential grant/loan suspension\n\n## Staff Requirements by Program\n\n### RBDG RLF (Phase 1)\n\n| Role | Estimated FTE | Key Responsibilities |\n|------|--------------|---------------------|\n| Program Director | 0.25 | Oversight, reporting, USDA relationship |\n| Loan Officer | 0.5 | Origination, underwriting, closing |\n| Loan Servicing/Admin | 0.25 | Payment processing, file maintenance |\n| **Total RBDG** | **1.0 FTE** | |\n\nAt 10-20 active loans, one FTE equivalent can manage RBDG operations. Below this loan volume, RBDG functions can be absorbed by existing staff.\n\n### RMAP Addition (Phase 2 — incremental to RBDG)\n\n| Role | Incremental FTE | Key Responsibilities |\n|------|----------------|---------------------|\n| TA Coordinator | 0.5 | Mandatory TA delivery, outcome tracking |\n| Loan Officer (RMAP-specific) | 0.25 | RMAP origination (separate from RBDG) |\n| Compliance/Reporting | 0.25 | USDA annual report, LLRF monitoring |\n| **Total RMAP Increment** | **1.0 FTE** | |\n\nAdding RMAP doubles your compliance surface. The mandatory TA requirement is the largest incremental load — it requires active case management of every microborrower.\n\n### IRP Addition (Phase 3 — incremental to RBDG + RMAP)\n\n| Role | Incremental FTE | Key Responsibilities |\n|------|----------------|---------------------|\n| Senior Loan Officer | 0.5 | IRP underwriting (larger, more complex loans) |\n| Portfolio Manager | 0.5 | Portfolio risk monitoring, delinquency management |\n| Finance/Accounting | 0.25 | IRP debt service tracking, separate fund accounting |\n| **Total IRP Increment** | **1.25 FTE** | |\n\n## Reporting Load Comparison\n\n| Program | Report Type | Frequency | Estimated Hours/Report |\n|---------|------------|-----------|------------------------|\n| RBDG | Performance report | Semi-annual or annual | 4-8 hours |\n| RMAP | Annual performance report | Annual | 12-20 hours |\n| RMAP | LLRF reconciliation | Monthly | 2 hours |\n| IRP | Financial report to USDA | Quarterly | 3-5 hours |\n| IRP | Annual portfolio report | Annual | 8-12 hours |\n| All | Single Audit (if >$750K federal) | Annual | 40-80 hours prep |\n\n## The Stress Test: Adding IRP to an RMAP Program Simultaneously\n\n**Scenario:** An organization operating a 2-year-old RMAP program (30 active microloans) decides to apply for IRP in the same year it is applying for RMAP reauthorization.\n\n**The risk:** Both programs require intensive staff attention during application and in early implementation. If both are awarded simultaneously:\n\n- Staff managing RMAP reauthorization documentation are simultaneously onboarding IRP systems\n- IRP requires separate accounting and a new loan underwriting standard (larger loans, different risk profile)\n- RMAP TA obligations remain constant regardless of IRP launch\n- If a key staff member departs during this period, the program could face reporting failures on both programs simultaneously\n\n**The safer approach:** Complete RMAP reauthorization first (confirm award and establish systems), then apply for IRP in the following program year.\n\n## Delinquency Management Capacity\n\nDelinquency management is the most time-intensive and emotionally demanding compliance function. Budget staff time accordingly:\n\n- **Current portfolio (0 days past due):** Monthly statement review, annual financial review — 0.5 hours/loan/month\n- **30-day delinquency:** Outreach call, document conversation — 1-2 hours/loan\n- **60-day delinquency:** Second call, demand notice, TA referral — 3-4 hours/loan\n- **90+ day delinquency:** Formal collections, workout assessment, legal review — 5-10 hours/loan\n- **Default/legal action:** 20-50 hours/loan through resolution\n\nFor RMAP-funded loans, USDA notification is required at specific delinquency thresholds (see 7 CFR 4280). IRP has comparable notification requirements. Missing these notifications is a compliance violation.\n\nA portfolio delinquency rate above 10% (PAR-30) is a warning sign that capacity is stretched — either the loan quality is deteriorating or servicing attention is insufficient.',
  'Each federal program adds real compliance burden. Understand staff requirements, reporting load, and how to stress-test capacity before adding IRP to an active RMAP program.',
  21, 1, 'approved')
ON CONFLICT DO NOTHING;

-- ============================================================
-- MODULE 4: Blended Fund Controls
-- ============================================================
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Blended Fund Controls',
  'Implement account segregation, program income tracking, blended-rate calculations, source mapping, and a multi-source RLF controls checklist.',
  4, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod4_id FROM modules WHERE certification_id = cert_id AND sort_order = 4;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod4_id,
  'Account Segregation, Source Mapping, and Blended Fund Controls',
  'cert07-blended-fund-controls',
  E'## Why Blended Fund Controls Are Critical\n\nWhen an organization operates multiple federally-funded loan programs simultaneously — RBDG RLF, RMAP RMRF, and IRP relending fund — each program''s funds must be accounted for separately and precisely. This is not optional. Federal regulations require it, USDA site visits test it, and Single Audits examine it.\n\nCommingling restricted fund sources is one of the most common and serious findings in federal program audits. It can result in:\n\n- Repayment demands for disallowed costs\n- Suspension of the funding award\n- Debarment from future federal awards\n- Reputational damage in the USDA Rural Development network\n\n## Account Segregation for Restricted Funds\n\n**Rule: One program, one account (minimum).**\n\nEach restricted federal fund source must have its own dedicated bank account:\n\n| Fund | Account Purpose | Who Controls |\n|------|----------------|-------------|\n| RBDG RLF | Lending from RBDG grant capital | Grantee board |\n| RMAP RMRF | Lending from USDA RMAP loan | USDA is first-lien on account |\n| RMAP LLRF | Loan loss reserve (≥5% of USDA balance) | Grantee; USDA has interest |\n| IRP Relending Fund | Lending from IRP loan capital | USDA holds security interest |\n| IRP Debt Service Reserve | Funds set aside for quarterly IRP payments | Grantee |\n| Operating Account | General operations (not restricted funds) | Grantee |\n\nEach account should have a separate general ledger cost center or fund code in your accounting system. Interaccount transfers must be documented, authorized, and permitted under the applicable program rules.\n\n## Program Income Tracking\n\nProgram income from each restricted fund must be tracked back to its source:\n\n- Interest and fees collected on RBDG RLF loans → credited to RBDG program income account\n- Interest and fees collected on RMAP RMRF loans → credited to RMRF (per 7 CFR 4280)\n- Principal repayments on IRP loans → credited to IRP relending fund\n\nProgram income **cannot be commingled** with operating income or other program income without explicit authorization.\n\n**Practical tracking system:**\n\nFor each loan in your portfolio, your loan management system or spreadsheet should record:\n- Loan ID\n- Funding source (RBDG / RMAP / IRP)\n- Outstanding principal by source\n- Interest rate\n- Payment received (principal / interest split)\n- Account credited for each payment\n\n## Blended-Rate Calculations\n\nIf a single borrower receives a loan funded from multiple sources (a blended loan), the interest rate charged must be calculated to reflect the weighted average cost of the sources:\n\n**Example:**\n\nA borrower receives a $100,000 loan funded 50% from RBDG RLF (priced at 5%) and 50% from IRP relending fund (priced at 4%).\n\nBlended rate = (0.50 × 5%) + (0.50 × 4%) = **4.5%**\n\nThe blended rate must be documented in the loan file. Each payment must be allocated back to the source accounts in proportion to the outstanding principal from each source.\n\n**Note:** In most cases, USDA program requirements make it preferable to make separate loans from each fund rather than blending within a single note. Separate loans are cleaner to track and audit. Blending should only be used when operationally necessary and when the loan management system can handle the allocation.\n\n## Source Mapping for Each Loan\n\nEvery active loan in your portfolio must have a documented source map — a record of which restricted fund(s) capitalized the loan. This source map is the foundation of your fund reconciliation:\n\n**Loan Source Map (Example):**\n\n| Loan # | Borrower | Original Balance | RBDG $ | RMAP $ | IRP $ | Current Balance |\n|--------|---------|-----------------|--------|--------|-------|----------------|\n| 2024-001 | [Name] | $45,000 | $45,000 | $0 | $0 | $38,200 |\n| 2024-002 | [Name] | $150,000 | $50,000 | $0 | $100,000 | $142,000 |\n| 2024-003 | [Name] | $25,000 | $0 | $25,000 | $0 | $21,500 |\n\n## Multi-Source RLF Controls Checklist\n\nUse this checklist at least quarterly:\n\n**Account Segregation**\n☐ Each federal fund source has a dedicated bank account\n☐ No interaccount transfers without written authorization and documentation\n☐ Operating expenses are NOT paid from restricted loan fund accounts\n\n**Program Income**\n☐ All loan repayments posted to the correct source account within 3 business days\n☐ Program income report reconciled to bank statement monthly\n☐ Program income used only for authorized purposes\n\n**Loan Source Mapping**\n☐ Every active loan has a documented funding source in the loan management system\n☐ Source map reconciles to each fund account balance\n☐ Blended loans (if any) have documented rate calculations and payment allocation rules\n\n**Compliance Calendar**\n☐ Reporting deadlines for all active programs posted and assigned\n☐ LLRF balance verified against 5% minimum monthly\n☐ UCC continuation deadline tracker current\n☐ Insurance tracking current for all collateralized loans\n\n**Audit Readiness**\n☐ Fund account statements, reconciliations, and source maps available for each fund\n☐ Loan files complete (application, underwriting, closing docs, payment history)\n☐ Program income tracking matches financial statements',
  'Blended fund controls — account segregation, program income tracking, source mapping, and a controls checklist — protect your organization from federal audit findings.',
  20, 1, 'approved')
ON CONFLICT DO NOTHING;

-- ============================================================
-- QUIZ for Cert 7
-- ============================================================
INSERT INTO quizzes (id, certification_id, title, passing_score, status)
VALUES (uuid_generate_v4(), cert_id,
  'IRP and Federal Capital Stack Strategy Knowledge Check',
  80, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO quiz_id FROM quizzes WHERE certification_id = cert_id;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order)
VALUES
(quiz_id,
  'What interest rate does USDA charge the intermediary on an IRP direct loan?',
  '[{"id":"a","text":"3% fixed"},{"id":"b","text":"Prime rate"},{"id":"c","text":"1% fixed"},{"id":"d","text":"0% (no interest)"}]',
  'c',
  'IRP loans from USDA to eligible intermediaries carry a 1% fixed interest rate. The intermediary relends the funds to rural businesses at rates it determines, earning a spread to cover operating costs.',
  1),

(quiz_id,
  'What is the maximum loan amount an IRP intermediary may make to a single rural business borrower?',
  '[{"id":"a","text":"$50,000"},{"id":"b","text":"$150,000"},{"id":"c","text":"$250,000"},{"id":"d","text":"$400,000"}]',
  'd',
  'Under the IRP program, the maximum loan to any single borrower is $400,000. This is significantly higher than the RMAP $50,000 microloan cap, making IRP suited for larger rural business capital needs.',
  2),

(quiz_id,
  'Which program should an organization typically pursue FIRST when building a federal capital stack?',
  '[{"id":"a","text":"IRP — because it has the highest loan limit"},{"id":"b","text":"RBDG — because it is grant-funded with lower compliance burden"},{"id":"c","text":"RMAP — because it includes mandatory TA support"},{"id":"d","text":"CDFI Fund — because it is available immediately"}]',
  'b',
  'RBDG is the recommended first step because it is grant-funded (no USDA repayment), has a broad eligible use scope, and allows an organization to build a lending track record before taking on USDA debt obligations.',
  3),

(quiz_id,
  'What is the primary reason NOT to apply for RMAP and IRP simultaneously as a new organization?',
  '[{"id":"a","text":"USDA prohibits holding both programs at the same time"},{"id":"b","text":"Both programs require different collateral types that conflict"},{"id":"c","text":"The combined compliance and reporting burden can overwhelm staff capacity before systems are proven"},{"id":"d","text":"IRP interest rates exceed RMAP rates making the blended cost too high"}]',
  'c',
  'Adding multiple federal programs simultaneously — especially before systems and staff capacity are proven — is a primary cause of compliance failures. The safer approach is to prove one program at a time.',
  4),

(quiz_id,
  'Program income from an RBDG RLF (loan repayments flowing back into the fund) must be used for:',
  '[{"id":"a","text":"General organizational operating expenses"},{"id":"b","text":"The same authorized purposes as the original grant — re-lending to rural small businesses"},{"id":"c","text":"Matching funds for a new RMAP application"},{"id":"d","text":"Repayment of the USDA IRP loan"}]',
  'b',
  'Under 2 CFR 200.307, program income must be used for the same authorized purposes as the original grant. For an RBDG RLF, that means re-lending to rural small businesses — not general operations or other programs.',
  5),

(quiz_id,
  'An organization makes a $100,000 loan funded 50% from its RBDG RLF (priced at 6%) and 50% from its IRP fund (priced at 4%). What is the blended interest rate?',
  '[{"id":"a","text":"4%"},{"id":"b","text":"5%"},{"id":"c","text":"6%"},{"id":"d","text":"10%"}]',
  'b',
  'Blended rate = (0.50 × 6%) + (0.50 × 4%) = 3% + 2% = 5%. The blended rate must be documented in the loan file and each payment allocated back to source accounts proportionally.',
  6),

(quiz_id,
  'Which of the following is NOT an eligible IRP intermediary applicant?',
  '[{"id":"a","text":"A rural nonprofit corporation"},{"id":"b","text":"A state public body"},{"id":"c","text":"A private for-profit lending company"},{"id":"d","text":"A rural electric cooperative"}]',
  'c',
  'IRP eligible intermediaries are public bodies, nonprofit entities, and cooperatives. Private for-profit lenders are not eligible applicants for IRP.',
  7),

(quiz_id,
  'What is the minimum Loan Loss Reserve Fund (LLRF) balance requirement under RMAP?',
  '[{"id":"a","text":"2% of the RMRF balance"},{"id":"b","text":"5% of the total amount owed to USDA"},{"id":"c","text":"10% of outstanding microloans"},{"id":"d","text":"$50,000 flat"}]',
  'b',
  'Under 7 CFR 4280, the LLRF must be maintained at not less than 5% of the total amount owed by the microlender to USDA. Monthly reconciliation of this balance is a compliance requirement.',
  8),

(quiz_id,
  'What Treasury program provides Financial Assistance grants of up to $2M per cycle to certified CDFIs?',
  '[{"id":"a","text":"USDA Rural Development Rural Microentrepreneur Assistance Program"},{"id":"b","text":"SBA Microloan Program"},{"id":"c","text":"CDFI Fund Financial Assistance (FA) Award Program"},{"id":"d","text":"Federal Home Loan Bank Affordable Housing Program"}]',
  'c',
  'The CDFI Fund (U.S. Treasury) provides Financial Assistance awards of up to $2M per award cycle to CDFI-certified organizations for capital and operations. CDFI certification is a prerequisite.',
  9),

(quiz_id,
  'In a multi-source RLF operation, what is the fundamental rule for account segregation?',
  '[{"id":"a","text":"All federal funds can share one account as long as a spreadsheet tracks the sources"},{"id":"b","text":"Each federal fund source must have its own dedicated bank account"},{"id":"c","text":"RBDG and RMAP can share an account because both are USDA programs"},{"id":"d","text":"Account segregation is optional if the organization has a Single Audit"}]',
  'b',
  'Each restricted federal fund source must have its own dedicated bank account. Commingling restricted funds is one of the most serious federal audit findings and can result in award suspension.',
  10),

(quiz_id,
  'CRA (Community Reinvestment Act) bank investments in CDFIs are most useful to rural lending organizations as:',
  '[{"id":"a","text":"A substitute for federal grant programs"},{"id":"b","text":"A source of non-federal capital at favorable terms that banks provide to earn CRA credit"},{"id":"c","text":"A mechanism for lending to agricultural operations"},{"id":"d","text":"A way to avoid USDA compliance requirements"}]',
  'b',
  'Banks seeking CRA credit may provide equity-equivalent investments, low-interest loans, or grants to CDFIs. This non-federal capital can serve as matching funds, RLF capitalization, or operating support at favorable rates.',
  11),

(quiz_id,
  'A Portfolio at Risk (PAR-30) rate above what threshold is a warning sign that capacity may be stretched?',
  '[{"id":"a","text":"3%"},{"id":"b","text":"5%"},{"id":"c","text":"10%"},{"id":"d","text":"20%"}]',
  'c',
  'A PAR-30 rate (loans 30+ days past due as a percentage of total portfolio) above 10% signals that either loan quality is deteriorating or servicing attention is insufficient — both indicating potential capacity strain.',
  12),

(quiz_id,
  'An organization''s total federal expenditures across all programs reach $800,000 in one fiscal year. What audit requirement is triggered?',
  '[{"id":"a","text":"An internal audit only"},{"id":"b","text":"A program-specific audit for the largest program"},{"id":"c","text":"A Single Audit (formerly A-133) covering all federal awards"},{"id":"d","text":"No additional audit; the threshold is $1,000,000"}]',
  'c',
  'Under 2 CFR 200.501, organizations expending $750,000 or more in total federal awards in a fiscal year must have a Single Audit. The threshold applies to total federal expenditures, not any single award.',
  13),

(quiz_id,
  'In the three-phase funding roadmap, which program tier is designed to serve rural businesses needing loans above $50,000?',
  '[{"id":"a","text":"RMAP RMRF"},{"id":"b","text":"RBDG RLF (within policy-set limits)"},{"id":"c","text":"IRP relending fund (up to $400,000)"},{"id":"d","text":"SBA 7(a) program"}]',
  'c',
  'IRP in Phase 3 addresses the gap above the RMAP $50,000 cap. With a $400,000 per-borrower maximum, IRP serves rural businesses needing larger capital for equipment, real estate, or growth.',
  14),

(quiz_id,
  'What is the purpose of maintaining a loan source map in a multi-fund lending operation?',
  '[{"id":"a","text":"To report total loan volume to SBA for CRA credit"},{"id":"b","text":"To document which restricted fund capitalized each loan so payments can be allocated correctly and funds reconciled"},{"id":"c","text":"To satisfy the RMAP TA documentation requirement"},{"id":"d","text":"To calculate the leverage ratio for future RBDG applications"}]',
  'b',
  'A loan source map records which restricted fund(s) capitalized each loan, enabling correct payment allocation back to source accounts, fund reconciliation, and audit trail for federal reviewers.',
  15)
ON CONFLICT DO NOTHING;

END $$;

-- ============================================================
-- CERT 8: Underwriting, Credit Policy & Portfolio Risk
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

SELECT id INTO cert_id FROM certifications WHERE cert_number = 8;
IF cert_id IS NULL THEN
  RAISE EXCEPTION 'Cert 8 not found — run 04_cert_seeds.sql first';
END IF;

UPDATE certifications SET
  learning_outcomes = ARRAY[
    'Create a written microloan credit policy covering all required sections',
    'Analyze cash flow and calculate repayment capacity using the 5 Cs framework and DSCR',
    'Set collateral and security standards including UCC Article 9 filings and personal guarantees',
    'Manage loan committee structure, quorum, conflict of interest, and decision documentation',
    'Monitor portfolio risk using PAR, default rate, concentration risk, and loan loss reserve adequacy'
  ],
  status = 'approved'
WHERE id = cert_id;

-- ============================================================
-- MODULE 1: Credit Policy Framework
-- ============================================================
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Credit Policy Framework',
  'Understand the purpose, required sections, and regulatory connection of a written microloan credit policy.',
  1, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod1_id FROM modules WHERE certification_id = cert_id AND sort_order = 1;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod1_id,
  'Building a Written Microloan Credit Policy',
  'cert08-credit-policy-framework',
  E'## Why a Written Credit Policy Is Non-Negotiable\n\nA written credit policy is the governing document for every lending decision your organization makes. Without it, loan decisions are inconsistent, fair lending compliance is unprovable, and USDA site visits will find deficiencies. With a strong written policy, every loan officer operates from the same standards, loan committee members have a framework for decisions, and your organization can demonstrate to USDA, auditors, and bank partners that you operate a professional program.\n\nFor RMAP microlenders, a credit policy is effectively required — 7 CFR 4280 expects microlenders to have documented lending standards as part of operating a prudent RMRF. For RBDG RLFs, USDA expects the Loan Fund Policy to include credit standards. For IRP intermediaries, underwriting standards are part of the program agreement.\n\n## Required Sections of a Microloan Credit Policy\n\n### 1. Fund Purpose and Mission Alignment\nState clearly why the lending program exists and what population it serves. Example:\n\n> "The [Organization] Microloan Program exists to provide affordable, responsible capital to rural microenterprises in [service area] that cannot obtain sufficient credit from conventional financial institutions. Our lending is guided by client protection principles and designed to promote long-term business viability, not just loan volume."\n\n### 2. Eligible Borrowers\nDefine who may borrow:\n- Entity types (sole proprietorships, LLCs, S-corps, partnerships)\n- Geographic requirement (must be in defined rural service area)\n- Business stage (startup, existing, or both)\n- Industry restrictions (list ineligible sectors)\n- RMAP-specific: no more than 10 FTE for RMRF loans\n\n### 3. Eligible Uses of Loan Proceeds\nList permitted uses:\n- Equipment purchase\n- Working capital (inventory, supplies, operating expenses)\n- Leasehold improvements\n- Business acquisition (with conditions)\n- Startup costs\n\nList ineligible uses explicitly:\n- Refinancing existing debt (unless policy specifically allows)\n- Residential construction\n- Speculative real estate\n- Personal expenses\n- Tax payments or penalties\n- Gambling or illegal activities\n\n### 4. Loan Sizes and Terms\nState minimum and maximum loan amounts, maximum term by use type, and whether the program offers multiple facilities to the same borrower.\n\n### 5. Interest Rate Methodology\nDescribe how rates are set:\n- Fixed or variable?\n- Reference index if variable (Prime, SOFR)\n- Spread above cost of funds\n- Minimum and maximum rates\n- Rate differentiation by risk tier (if applicable)\n\n### 6. Collateral and Security Requirements\nSee Module 3 for detail. Policy must state:\n- Minimum collateral coverage ratio\n- Types of acceptable collateral\n- When personal guarantees are required\n- When collateral may be waived (character-based lending standards)\n\n### 7. Underwriting Criteria\nState the minimum standards for loan approval:\n- Minimum DSCR\n- Credit history review process (not necessarily a minimum score)\n- Required documentation (tax returns, bank statements, business plan)\n- Business plan or projections requirements for startups\n\n### 8. Exceptions Authority\nDefine who can approve exceptions to policy and under what conditions. An exception is any loan that does not meet one or more standard policy requirements. Policy should require:\n- Written documentation of the exception\n- Approval by loan committee or designated senior officer\n- Explanation of compensating factors\n- Aggregate exception reporting to the board quarterly\n\n### 9. Approval Authority\nDefine the approval matrix:\n\n| Loan Size | Approval Authority |\n|-----------|-------------------|\n| Up to $10,000 | Loan Officer + Program Director |\n| $10,001-$25,000 | Loan Committee |\n| $25,001-$50,000 | Full Loan Committee with quorum |\n| Above $50,000 | Loan Committee + Board ratification |\n\n## Policy vs. Procedure\n\n**Credit Policy** = What you will and will not do (the standards)\n**Credit Procedure** = How you do it (the operational steps)\n\nThe policy is approved by the board and changes infrequently. Procedures are operational documents updated by staff as workflows evolve. Keep them separate — this makes policy changes a board matter while allowing staff to refine procedures without board approval for every workflow adjustment.\n\n## RMAP Compliance Connection\n\nYour credit policy must be consistent with 7 CFR 4280 requirements. Specifically:\n- Your eligible borrower definition must align with RMAP microenterprise definition (no more than 10 FTE, rural area)\n- Your maximum loan size in the RMRF policy cannot exceed $50,000\n- Your interest rate methodology must produce fixed rates (not variable) for RMRF loans\n- Your ineligible use list must include all RMAP-prohibited uses\n\nDuring a USDA site visit, your credit policy will be reviewed against your loan files to confirm consistent application.',
  'A written credit policy is the governing document for every lending decision. Learn the required sections, the policy vs. procedure distinction, and the RMAP compliance connection.',
  20, 1, 'approved')
ON CONFLICT DO NOTHING;

-- ============================================================
-- MODULE 2: Underwriting Fundamentals
-- ============================================================
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Underwriting Fundamentals',
  'Apply the 5 Cs of credit, analyze cash flow for microenterprises, read bank statements and tax returns, and calculate DSCR.',
  2, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod2_id FROM modules WHERE certification_id = cert_id AND sort_order = 2;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod2_id,
  'The 5 Cs of Credit and Cash Flow Analysis for Microenterprises',
  'cert08-underwriting-fundamentals',
  E'## The 5 Cs of Credit\n\nThe 5 Cs of Credit is the foundational framework for evaluating any loan request. In microlending, the weight assigned to each C differs from traditional banking — character and capacity typically matter more than capital and collateral for small loans to underserved borrowers.\n\n### 1. Character\nCharacter is the borrower''s demonstrated commitment to meeting financial obligations. For microentrepreneurs:\n\n- **Credit report review:** Look for patterns, not perfection. Medical collections and one-time hardship events are different from repeated missed obligations across multiple creditors.\n- **References:** Business references, supplier relationships, prior employer contacts\n- **Interview observations:** Does the borrower know their business? Are they honest about challenges? Do they follow through on pre-application commitments?\n- **Prior loan history:** Did they repay previous business or personal loans? Contact prior lenders if permitted.\n\n**Red flag:** A borrower who minimizes or denies past financial difficulties that appear clearly on the credit report is a character concern — not the difficulty itself, but the dishonesty about it.\n\n### 2. Capacity\nCapacity is the borrower''s ability to repay the loan from business cash flow. This is the most analytically rigorous of the 5 Cs.\n\n**For existing businesses:** Analyze 2-3 years of actual financial history (bank statements, tax returns, or prepared financial statements).\n\n**For startups:** Analyze projected cash flow, stress-tested at 70% of projected revenue.\n\nCapacity analysis produces the **Debt Service Coverage Ratio (DSCR)**:\n\nDSCR = Net Operating Income divided by Total Annual Debt Service\n\nWhere:\n- Net Operating Income = Revenue minus Operating Expenses (before debt payments and depreciation)\n- Total Annual Debt Service = Annual principal + interest on all business debt including the proposed loan\n\n| DSCR | Interpretation |\n|------|----------------|\n| Below 1.0 | Insufficient cash flow — loan cannot be repaid from operations |\n| 1.0 to 1.10 | Breakeven — very limited cushion, high risk |\n| 1.10 to 1.25 | Marginal — acceptable only with strong character and collateral |\n| 1.25 to 1.50 | Adequate — standard approval range for microlenders |\n| Above 1.50 | Strong — comfortable approval |\n\n### 3. Capital\nCapital is the borrower''s own financial investment in the business. More invested capital means:\n- The borrower has "skin in the game"\n- The loan-to-value ratio is lower\n- The borrower is less likely to walk away from the business\n\nFor microloans, capital injection can take many forms:\n- Personal savings invested in equipment or inventory\n- Sweat equity (owner''s labor in building out the business)\n- Grants received by the business\n- Family contributions\n\n### 4. Collateral\nCollateral is the secondary repayment source — what you can liquidate if the loan goes bad. (See Module 3 for full collateral analysis.)\n\n**Important:** In microlending, collateral is the backstop, not the foundation. If a loan can only be repaid through collateral liquidation, the business cash flow is insufficient and the loan should not be made. Collateral protects the fund from total loss — it does not make a bad loan good.\n\n### 5. Conditions\nConditions are the external factors affecting repayment probability:\n- Local and national economic trends\n- Industry conditions (is this business type thriving or declining in the service area?)\n- Regulatory environment (new licensing requirements, zoning changes)\n- Competition (is a major competitor entering the market?)\n- Purpose of the loan (does the specific use make business sense?)\n\n## How to Read a Bank Statement\n\nBank statements are the most reliable source of actual cash flow for microenterprises. Key analysis steps:\n\n1. **Average monthly deposits:** Add all deposits for 12 months and divide by 12. This is your revenue proxy.\n2. **Consistency check:** Are deposits consistent month-to-month, or highly variable? High variability indicates seasonal business or income instability.\n3. **Average monthly balance:** Low average balance (near zero) indicates the borrower is operating with no cushion.\n4. **NSF/overdraft frequency:** Frequent non-sufficient fund fees signal chronic cash flow problems.\n5. **Large unexplained deposits:** Investigate — may indicate non-business income (tax refund, sale of asset) that overstates regular revenue.\n6. **Large unusual withdrawals:** May indicate undisclosed debt payments or business obligations not reflected in stated expenses.\n\n## How to Read a Tax Return for Microloan Underwriting\n\nFor sole proprietors, the Schedule C (Profit or Loss from Business) is the primary document:\n\n- **Line 1 (Gross receipts):** Total revenue\n- **Lines 8-27 (Expenses):** Operating expenses\n- **Line 31 (Net profit/loss):** Bottom line, but add back depreciation (a non-cash expense) and any owner compensation shown as expense\n\nAdjusted Net Income = Schedule C Net Profit + Depreciation + Excess Owner Draw\n\nFor LLCs filing as partnerships (Form 1065), look at the K-1 for the borrower''s distributive share.\n\nFor S-corps (Form 1120-S), combine borrower''s W-2 wages + K-1 ordinary income.\n\n## The Repayment Capacity Calculation: Step by Step\n\n**Step 1:** Gather 2 years of tax returns (or 12 months of bank statements for businesses without returns)\n**Step 2:** Calculate Average Annual Net Income (add back depreciation)\n**Step 3:** Add the proposed annual debt service\n**Step 4:** Calculate DSCR = Step 2 divided by Step 3\n**Step 5:** Compare DSCR to your credit policy minimum\n**Step 6:** Document your calculation in the loan file with the source documents attached',
  'The 5 Cs framework — Character, Capacity, Capital, Collateral, Conditions — guides microloan underwriting. Learn cash flow analysis, bank statement review, tax return interpretation, and DSCR calculation.',
  22, 1, 'approved')
ON CONFLICT DO NOTHING;

-- ============================================================
-- MODULE 3: Collateral and Security
-- ============================================================
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Collateral and Security',
  'Understand collateral types, UCC Article 9 filings, personal guarantees, and when to require vs. waive collateral.',
  3, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod3_id FROM modules WHERE certification_id = cert_id AND sort_order = 3;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod3_id,
  'Collateral Types, UCC Filings, and Security Standards in Microlending',
  'cert08-collateral-security',
  E'## Types of Collateral in Microlending\n\nMicroloan collateral differs from traditional bank collateral because microentrepreneurs often lack hard assets. Effective microlenders know how to work within this reality:\n\n### Equipment\nEquipment purchased with loan proceeds is the most common and cleanest collateral for microloans:\n- Lender files a UCC-1 financing statement against the equipment\n- Equipment must be appraised or valued (purchase price or FMV, whichever is lower)\n- Depreciation must be factored into ongoing collateral coverage — a $20,000 truck financed with a $15,000 loan will be worth far less in year 3\n- The lender should be named as loss payee on the borrower''s property/equipment insurance policy\n\n**Collateral coverage ratio for equipment:** Typically 100-125% of loan balance\n\n### Inventory\nInventory is liquid but volatile collateral:\n- Value fluctuates with market conditions\n- Perishable inventory (food, flowers) has near-zero liquidation value\n- Non-perishable inventory (hardware, clothing) is more stable\n- Requires ongoing monitoring — inventory can disappear quickly\n\nInventory collateral is generally discounted 50-75% of stated value for collateral coverage purposes.\n\n### Accounts Receivable\nFor businesses with established customer accounts:\n- Receivables under 90 days are the most valuable\n- Receivables from government or large corporate customers are most reliable\n- Requires UCC-1 filing and periodic aging report review\n- Less common in rural microenterprise lending where most businesses are cash-based\n\n### Personal Assets\nWhen business assets are insufficient:\n- Personal vehicle (UCC or lien on title)\n- Personal real estate (deed of trust/mortgage — note: this is significant and should be used judiciously)\n- Savings or investment accounts (blocked accounts or assignments)\n\nFor personal real estate collateral, consult legal counsel — state homestead exemptions may limit enforceability, and the foreclosure process is costly and time-consuming.\n\n## UCC Filings: How They Work (UCC Article 9)\n\nUnder **UCC Article 9** (Uniform Commercial Code, Article 9 — Secured Transactions), a lender perfects a security interest in personal property by filing a **UCC-1 Financing Statement** with the appropriate state filing office (usually the Secretary of State).\n\n**Key UCC concepts:**\n\n**Attachment:** The security interest attaches when:\n1. The lender gives value (makes the loan)\n2. The debtor has rights in the collateral\n3. The security agreement is authenticated (signed)\n\n**Perfection:** A perfected security interest is effective against third parties (including other creditors and a bankruptcy trustee). Perfection occurs upon filing the UCC-1.\n\n**Priority:** The general rule is first-to-file wins. If another creditor has already filed a UCC-1 against the same collateral, they have priority.\n\n**Lapse:** A UCC-1 financing statement **lapses after 5 years** unless a continuation statement is filed within 6 months before lapse. RLF operators must track UCC continuation deadlines for every loan.\n\n**Termination:** When a loan is repaid, the lender must file a UCC-3 termination statement within 20 days of a written demand from the debtor.\n\n**Practical steps for every secured microloan:**\n1. Include security agreement in the loan documents (describes the collateral)\n2. File UCC-1 with the Secretary of State in the state where the debtor is located (for organizations) or where the debtor resides (for individuals)\n3. Record the UCC filing date and 5-year lapse date in your loan management system\n4. Set a calendar reminder 6 months before lapse to file continuation\n5. Obtain lien search results before closing to confirm no prior lienholders\n\n## Personal Guarantees\n\nA personal guarantee makes the individual business owner personally liable for the business loan. For microloans:\n\n- **Full personal guarantee:** The guarantor is liable for 100% of the outstanding balance. Standard for all owners with 20% or more ownership.\n- **Limited guarantee:** Liability capped at a specific dollar amount or percentage. Less common in microlending.\n- **Spousal guarantee:** Some states require spousal consent for guarantees that encumber community property. Consult legal counsel by state.\n\n**When to require a personal guarantee:** On virtually all microloans. The guarantee:\n- Aligns the borrower''s personal financial interest with loan repayment\n- Provides an additional collection avenue\n- Signals to the borrower that this is a serious obligation\n\n**Guaranty document:** Must be a separate, signed document — not just a clause in the loan agreement. Use a standard guarantee form reviewed by legal counsel.\n\n## When to Require Collateral vs. Character-Based Lending\n\n**Always require at minimum:** Personal guarantee + UCC on equipment purchased with loan proceeds\n\n**May reduce collateral requirement when:**\n- Loan amount is very small (under $5,000)\n- Strong DSCR (above 1.5) demonstrates robust repayment capacity\n- Character indicators are exceptionally strong (long business history, strong references, prior loan repayment)\n- TA support is intense (weekly coaching significantly reduces default risk)\n\n**Document the rationale** for any collateral waiver or reduction in the loan file. The credit policy should define when the loan committee may approve character-based lending and require written compensating factors.',
  'Collateral in microlending includes equipment, inventory, receivables, and personal assets. Learn UCC Article 9 filing requirements, personal guarantees, and when collateral may be reduced for character-based lending.',
  21, 1, 'approved')
ON CONFLICT DO NOTHING;

-- ============================================================
-- MODULE 4: Loan Committee and Decision Process
-- ============================================================
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Loan Committee and Decision Process',
  'Structure a loan committee, manage quorum and conflict of interest, present loans effectively, and document decisions.',
  4, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod4_id FROM modules WHERE certification_id = cert_id AND sort_order = 4;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod4_id,
  'Loan Committee Structure, Decision Authority, and Documentation',
  'cert08-loan-committee',
  E'## Who Serves on a Loan Committee\n\nA loan committee is the governance body that reviews and approves (or declines) loan applications above the loan officer''s individual authority. Committee composition matters for both quality and compliance:\n\n**Recommended composition for a microloan committee:**\n\n| Member Type | Role | Why Important |\n|-------------|------|---------------|\n| Program Director or CEO | Chair | Organizational accountability |\n| Loan Officer (non-voting presenter) | Presents loans | Conflict — should not vote on loans they originated |\n| Financial professional (CPA, CFO, banker) | Underwriting review | Technical financial analysis |\n| Community member with local business knowledge | Market context | Understands local conditions |\n| Board member (rotating) | Governance oversight | Ensures board visibility into lending |\n\n**Minimum committee size:** 3 voting members. More is better for diversity of perspective but harder to convene.\n\n## Quorum Rules\n\nThe credit policy must define quorum — the minimum number of voting members required to conduct official business:\n\n- **Typical quorum:** Majority of voting members (e.g., 3 of 5)\n- **Consequences of no quorum:** Meeting cannot be held; decisions are deferred\n- **Remote participation:** Policy should specify whether video conference participation counts toward quorum (it typically does if all members can hear and participate)\n\nDocument quorum in every meeting minute: "A quorum of [X] of [Y] voting members was present."\n\n## Conflict of Interest Policy\n\nConflict of interest is a serious compliance and governance issue for loan committees. Your written conflict of interest policy must address:\n\n**Defined conflicts include:**\n- Committee member has a financial interest in the applicant business (ownership, supplier, customer)\n- Committee member is related to the applicant (spouse, sibling, child, parent)\n- Committee member has a personal relationship that could impair objectivity\n- The applicant''s organization has a business relationship with the committee member''s employer\n\n**Required procedures:**\n1. Disclose at the start of each meeting — each member verbally states any conflict with applications on the agenda\n2. Member with conflict recuses from discussion and vote on that application\n3. Recusal is documented in meeting minutes\n4. The recused member physically leaves the room (or video call) during discussion\n\n**Annual conflict of interest disclosure:** All loan committee members should complete a written conflict of interest disclosure annually, on file with the organization.\n\n## Presenting a Loan for Committee Decision\n\nThe loan officer (non-voting) presents each loan application. A complete loan presentation includes:\n\n1. **Borrower Profile** — Name, business name, structure, years in operation, industry\n2. **Loan Request** — Amount, use of proceeds (itemized), proposed term, rate, monthly payment\n3. **Financial Analysis** — Revenue trend, expenses, net cash flow, DSCR, existing debt\n4. **Collateral** — Collateral offered, estimated value, coverage ratio, personal guarantee status\n5. **Character Assessment** — Credit summary, reference summary, interview observations\n6. **TA Plan** — Current TA engagement, post-closing TA plan\n7. **Staff Recommendation** — Approve / Deny / Conditional Approval with rationale and any exceptions\n\n## Approval, Denial, and Conditional Approval\n\n**Approval:** Loan is approved as presented. Loan officer proceeds to closing.\n\n**Conditional Approval:** Loan is approved subject to specified conditions being met before closing. Common conditions:\n- Borrower obtains required business license\n- Borrower provides updated bank statements\n- Borrower completes specific TA session\n- Additional collateral is secured\n\n**Denial:** Loan is not approved. The denial must be:\n- Communicated to the borrower in writing within the timeframe specified in your credit policy (often 10 business days)\n- Based on specific, documented credit reasons (not vague)\n- ECOA-compliant — if the borrower requests a statement of reasons, you must provide it\n\n## Documenting the Decision with Minutes\n\nLoan committee minutes are legal documents. They must record:\n\n- Date, time, and location of meeting\n- Members present (with quorum confirmation)\n- Any conflict disclosures and recusals\n- Each loan presented (borrower name, loan amount)\n- Motion, second, and vote count for each decision (including how each voting member voted, or "unanimous")\n- Any conditions attached to approvals\n- Any policy exceptions noted and the compensating factors cited\n- Adjournment time\n\nMinutes must be signed by the chair and secretary, approved at the next meeting, and retained permanently as part of the loan file.',
  'A properly structured loan committee with clear quorum, conflict of interest, and documentation standards protects your organization legally and demonstrates USDA compliance.',
  20, 1, 'approved')
ON CONFLICT DO NOTHING;

-- ============================================================
-- MODULE 5: Portfolio Risk Management
-- ============================================================
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Portfolio Risk Management',
  'Calculate PAR, delinquency, default, and write-off rates. Manage concentration risk and loan loss reserve adequacy.',
  5, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod5_id FROM modules WHERE certification_id = cert_id AND sort_order = 5;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod5_id,
  'Portfolio Risk Metrics, Concentration Risk, and Loss Reserve Management',
  'cert08-portfolio-risk',
  E'## Why Portfolio Risk Management Matters\n\nIndividual loan quality matters. Portfolio quality determines whether your revolving loan fund survives. A single bad loan is a problem. A systemic pattern of bad loans — concentrated in one sector, originated by one loan officer, or structured without adequate underwriting — can drain a fund and threaten your USDA program standing.\n\nPortfolio risk management is the practice of measuring, monitoring, and managing the collective health of all loans in your fund.\n\n## Key Portfolio Risk Metrics\n\n### Portfolio at Risk (PAR)\n\nPAR is the most widely used portfolio quality metric in microfinance:\n\n**PAR-30** = Outstanding balance of loans with any payment 30+ days past due divided by total outstanding loan portfolio\n\n**PAR-90** = Outstanding balance of loans with any payment 90+ days past due divided by total outstanding loan portfolio\n\nNote: PAR measures the ENTIRE outstanding balance of a delinquent loan, not just the overdue payment.\n\n**Example:**\nPortfolio of 50 loans, total outstanding $500,000.\n3 loans totaling $45,000 have payments 30+ days past due.\nPAR-30 = $45,000 divided by $500,000 = 9%\n\n**Benchmark targets:**\n\n| PAR-30 | Rating |\n|--------|--------|\n| Under 5% | Excellent |\n| 5% to 10% | Acceptable |\n| 10% to 15% | Concerning — investigate |\n| Above 15% | Critical — immediate action required |\n\n### Delinquency Rate\n\nDelinquency Rate = Total overdue payments divided by total payments due in period\n\nThis is useful for cash flow planning but less conservative than PAR for portfolio health assessment.\n\n### Default Rate\n\nDefault Rate = Number of loans declared in default in a period divided by total loans originated in same period\n\nA loan is in default when it crosses the threshold defined in your credit policy (typically 90-180 days past due). Once declared in default, the full balance becomes immediately due (acceleration).\n\n### Write-Off Rate\n\nWrite-Off Rate = Amount written off in a period divided by average outstanding portfolio in same period\n\nA write-off is a formal accounting action removing an uncollectible loan from the books. It does not eliminate the legal obligation — collection efforts can continue post write-off.\n\n**Note for RMAP:** Write-offs of RMRF loans must be reported to USDA and may require USDA approval depending on the program agreement terms.\n\n## Concentration Risk\n\nConcentration risk is the danger that too many loans share a common risk factor.\n\n| Concentration Type | Risk | Example |\n|-------------------|------|--------|\n| Sector concentration | Industry downturn | 40% of portfolio is restaurants |\n| Geographic concentration | Local economic shock | 60% of portfolio is one county |\n| Loan officer concentration | Individual quality variance | One officer originated 70% of loans |\n| Vintage concentration | Cohort underwriting errors | 50% originated in same 6-month period |\n| Single borrower | Individual failure | One borrower is 20% of total portfolio |\n\n**Concentration limits** should be written into your credit policy. Common limits:\n- No single industry may exceed 25% of total portfolio\n- No single borrower may represent more than 10% of total portfolio\n\n## Loan Loss Reserve: Calculation and Adequacy\n\nA **Loan Loss Reserve (LLR)** is an accounting provision reducing the stated value of the loan portfolio to reflect expected losses.\n\n**Method 1 (Simple):** Apply a flat reserve rate to total outstanding portfolio\n- Example: 5% of $500,000 = $25,000 reserve\n\n**Method 2 (Tiered by delinquency):** Apply higher rates to riskier loans\n\n| Loan Status | Reserve Rate |\n|-------------|-------------|\n| Current (0 days) | 1-2% |\n| 1-30 days past due | 5-10% |\n| 31-60 days past due | 20-30% |\n| 61-90 days past due | 50% |\n| 90+ days past due | 75-100% |\n\n## Portfolio Dashboard Template\n\nReview this dashboard monthly with program leadership:\n\n| Metric | This Month | Last Month | Target |\n|--------|-----------|-----------|--------|\n| Active loans | | | |\n| Total outstanding ($) | | | |\n| PAR-30 | | | Under 5% |\n| PAR-90 | | | Under 2% |\n| Loans in default | | | 0 |\n| Write-offs (YTD) | | | |\n| Loss reserve balance | | | Adequate |\n| LLRF balance (RMAP) | | | 5%+ of USDA |\n| New delinquencies | | | |',
  'PAR, default rate, write-off rate, concentration risk, and loan loss reserve adequacy are the essential metrics of portfolio health. Learn to calculate and monitor each.',
  22, 1, 'approved')
ON CONFLICT DO NOTHING;

-- ============================================================
-- QUIZ for Cert 8
-- ============================================================
INSERT INTO quizzes (id, certification_id, title, passing_score, status)
VALUES (uuid_generate_v4(), cert_id,
  'Underwriting, Credit Policy and Portfolio Risk Knowledge Check',
  80, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO quiz_id FROM quizzes WHERE certification_id = cert_id;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order)
VALUES
(quiz_id,
  'A DSCR of 1.35 means:',
  '[{"id":"a","text":"The loan is 135% collateralized"},{"id":"b","text":"Net operating income covers debt service 1.35 times, with a 35% cushion"},{"id":"c","text":"The interest rate is 1.35% above prime"},{"id":"d","text":"The borrower has 135 days to repay"}]',
  'b',
  'DSCR = Net Operating Income divided by Total Annual Debt Service. A ratio of 1.35 means income is 35% greater than required debt service — a comfortable cushion indicating the business can service the debt.',
  1),

(quiz_id,
  'Which of the 5 Cs of credit carries the most weight in microlending for underserved borrowers?',
  '[{"id":"a","text":"Collateral — because assets protect the fund"},{"id":"b","text":"Capital — because borrowers must have large down payments"},{"id":"c","text":"Character — because trust and willingness to repay matter most when collateral is limited"},{"id":"d","text":"Conditions — because market trends predict repayment"}]',
  'c',
  'In microlending, character — the borrower''s demonstrated commitment to meeting obligations — typically carries the most weight because many rural microentrepreneurs lack the collateral and capital that traditional underwriting relies on.',
  2),

(quiz_id,
  'Under UCC Article 9, a UCC-1 financing statement lapses after how many years if not continued?',
  '[{"id":"a","text":"3 years"},{"id":"b","text":"5 years"},{"id":"c","text":"7 years"},{"id":"d","text":"10 years"}]',
  'b',
  'Under UCC Article 9, a financing statement lapses 5 years after filing. A continuation statement must be filed within 6 months before the lapse date to maintain perfection of the security interest.',
  3),

(quiz_id,
  'PAR-30 is calculated as:',
  '[{"id":"a","text":"Total overdue payments divided by total payments due"},{"id":"b","text":"Outstanding balance of loans 30+ days past due divided by total outstanding portfolio"},{"id":"c","text":"Number of delinquent loans divided by total active loans"},{"id":"d","text":"Write-offs in the period divided by average portfolio balance"}]',
  'b',
  'PAR-30 measures the ENTIRE outstanding balance of loans with any payment 30+ days past due as a percentage of total outstanding portfolio. This is more conservative than tracking only overdue payment amounts.',
  4),

(quiz_id,
  'What is the difference between a credit policy and a credit procedure?',
  '[{"id":"a","text":"They are the same document with different names"},{"id":"b","text":"Credit policy sets standards (what); credit procedures describe operations (how). Policy is board-approved; procedures are staff-managed."},{"id":"c","text":"Credit policy covers federal programs; procedures cover local programs"},{"id":"d","text":"Credit procedures apply to individual loans; policy applies to the entire portfolio"}]',
  'b',
  'Credit policy defines standards (what you will and will not do) and is approved by the board. Credit procedures describe operational steps (how you execute) and can be updated by staff without board approval for each revision.',
  5),

(quiz_id,
  'When a loan committee member has a financial interest in an applicant business, the proper procedure is:',
  '[{"id":"a","text":"The member may vote but must disclose the relationship"},{"id":"b","text":"The member discloses, recuses from discussion and vote, and physically leaves for that agenda item"},{"id":"c","text":"The application is automatically denied"},{"id":"d","text":"The conflict is noted in the minutes but the member may still vote"}]',
  'b',
  'A loan committee member with a conflict must disclose, recuse from discussion AND vote, and physically leave the room during that application''s review. Staying in the room — even silently — impairs independence and creates compliance risk.',
  6),

(quiz_id,
  'For a Schedule C sole proprietor, which adjustment is made to net profit to calculate underwriting income?',
  '[{"id":"a","text":"Subtract all business expenses"},{"id":"b","text":"Add back depreciation (a non-cash expense) to net profit"},{"id":"c","text":"Subtract owner compensation"},{"id":"d","text":"Divide by 12 to get monthly income"}]',
  'b',
  'Depreciation is a non-cash expense that reduces taxable income but does not reduce actual cash available for debt service. Adding it back to Schedule C net profit gives a more accurate picture of cash available to repay the loan.',
  7),

(quiz_id,
  'A portfolio with 40% of its loans in the restaurant industry is an example of:',
  '[{"id":"a","text":"Vintage concentration"},{"id":"b","text":"Geographic concentration"},{"id":"c","text":"Sector concentration"},{"id":"d","text":"Single-borrower concentration"}]',
  'c',
  'Sector concentration occurs when too many loans share the same industry risk. A 40% restaurant concentration means an industry downturn could simultaneously impair a large portion of the portfolio.',
  8),

(quiz_id,
  'What is the purpose of a personal guarantee on a microloan?',
  '[{"id":"a","text":"It transfers ownership of the business to the lender upon default"},{"id":"b","text":"It makes the individual business owner personally liable for the loan, aligning their financial interest with repayment"},{"id":"c","text":"It replaces the need for collateral"},{"id":"d","text":"It is required by USDA RMAP for all loans above $10,000"}]',
  'b',
  'A personal guarantee makes the individual owner personally liable for the business loan, creating personal financial consequences for non-repayment. It aligns the borrower''s personal interest with repayment and provides an additional collection avenue.',
  9),

(quiz_id,
  'Which loan committee role should NOT cast a vote on loans they have originated?',
  '[{"id":"a","text":"The board member representative"},{"id":"b","text":"The community financial professional"},{"id":"c","text":"The loan officer who presented the loan"},{"id":"d","text":"The program director"}]',
  'c',
  'The loan officer who originated and presented a loan has an inherent conflict of interest. Standard practice is for the presenting loan officer to be a non-voting presenter, maintaining committee independence.',
  10),

(quiz_id,
  'A tiered loan loss reserve applies higher reserve rates to:',
  '[{"id":"a","text":"Larger loan balances regardless of delinquency status"},{"id":"b","text":"Loans to borrowers in high-unemployment counties"},{"id":"c","text":"Loans that are more delinquent, reflecting higher probability of loss"},{"id":"d","text":"Loans originated in the most recent quarter"}]',
  'c',
  'A tiered reserve applies progressively higher rates as delinquency increases — reflecting the increasing probability of loss as time past due grows. A current loan carries a 1-2% reserve; a 90+ day delinquent loan may require 100%.',
  11),

(quiz_id,
  'What is the key distinction between a write-off and loan forgiveness?',
  '[{"id":"a","text":"A write-off eliminates the borrower''s legal obligation; forgiveness does not"},{"id":"b","text":"A write-off is an accounting action removing the loan from the books; the legal obligation continues and collection may proceed"},{"id":"c","text":"Write-offs require USDA approval; forgiveness does not"},{"id":"d","text":"There is no difference — they are interchangeable terms"}]',
  'b',
  'A write-off is a financial accounting action — it removes the uncollectible balance from the books. It does NOT eliminate the borrower''s legal obligation to repay. The lender can continue collection efforts post-write-off.',
  12),

(quiz_id,
  'Inventory offered as collateral for a microloan should typically be discounted by what percentage for collateral coverage purposes?',
  '[{"id":"a","text":"0% — full face value"},{"id":"b","text":"10-15%"},{"id":"c","text":"50-75%"},{"id":"d","text":"110% to account for future appreciation"}]',
  'c',
  'Inventory is discounted 50-75% for collateral purposes because of volatility, perishability, and liquidation difficulty. A borrower''s stated inventory value of $40,000 might only be credited at $10,000-$20,000 for coverage purposes.',
  13),

(quiz_id,
  'Which condition when reviewing bank statements requires immediate investigation during underwriting?',
  '[{"id":"a","text":"Deposits are consistent month-to-month"},{"id":"b","text":"The average balance is above $5,000"},{"id":"c","text":"Frequent NSF (non-sufficient fund) fees appearing multiple months"},{"id":"d","text":"The borrower makes regular payroll deposits"}]',
  'c',
  'Frequent NSF fees signal chronic cash flow problems — the borrower regularly spends more than available. This is a significant red flag for repayment capacity and must be explored in depth before making a credit decision.',
  14),

(quiz_id,
  'Before filing a UCC-1 against collateral, a lender should conduct a lien search to:',
  '[{"id":"a","text":"Determine the borrower''s credit score"},{"id":"b","text":"Confirm no prior lienholders have already filed against the same collateral"},{"id":"c","text":"Verify the borrower''s business registration"},{"id":"d","text":"Calculate the loan-to-value ratio"}]',
  'b',
  'A UCC search at the Secretary of State reveals existing filings against the borrower''s assets. Under UCC Article 9, first-to-file has priority. Prior liens may significantly impair the lender''s collateral position.',
  15)
ON CONFLICT DO NOTHING;

END $$;

-- ============================================================
-- CERT 9: Loan Servicing, Collections, Workouts & Default Management
-- ============================================================
DO $$
DECLARE
  cert_id   uuid;
  mod1_id   uuid;
  mod2_id   uuid;
  mod3_id   uuid;
  mod4_id   uuid;
  quiz_id   uuid;
BEGIN

SELECT id INTO cert_id FROM certifications WHERE cert_number = 9;
IF cert_id IS NULL THEN
  RAISE EXCEPTION 'Cert 9 not found — run 04_cert_seeds.sql first';
END IF;

UPDATE certifications SET
  learning_outcomes = ARRAY[
    'Build a complete loan servicing lifecycle workflow from boarding through annual review',
    'Identify early warning indicators of delinquency and implement proactive outreach at day 1',
    'Create a collections contact cadence and document workout options including modification and restructuring',
    'Manage the default declaration, charge-off process, USDA notification, and post-charge-off recovery'
  ],
  status = 'approved'
WHERE id = cert_id;

-- ============================================================
-- MODULE 1: Loan Servicing Lifecycle
-- ============================================================
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Loan Servicing Lifecycle',
  'Build a complete loan servicing system from boarding through payment processing, covenant monitoring, annual reviews, and servicing calendar.',
  1, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod1_id FROM modules WHERE certification_id = cert_id AND sort_order = 1;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod1_id,
  'The Loan Servicing Lifecycle: From Boarding to Annual Review',
  'cert09-servicing-lifecycle',
  E'## What Is Loan Servicing?\n\nLoan servicing is everything that happens after a loan closes — from the moment funds are disbursed until the loan is fully repaid, charged off, or resolved. Effective servicing is the operational foundation of a healthy revolving loan fund. Poor servicing leads to preventable delinquencies, compliance failures, and fund deterioration.\n\nMany microlenders invest heavily in loan origination but underinvest in servicing. This is a mistake: a loan that closes perfectly and is then serviced poorly will default just as surely as a badly underwritten loan.\n\n## Step 1: Loan Boarding\n\nLoan boarding is the process of entering a new loan into your servicing system immediately after closing. Boarding must occur within 1-3 business days of disbursement.\n\n**What is boarded (recorded in the servicing system):**\n\n- Borrower legal name and contact information\n- Business name, address, and phone\n- Loan number (unique identifier)\n- Disbursement date\n- Loan amount (original principal)\n- Interest rate\n- Term (number of payments)\n- Payment amount\n- Payment due date\n- Maturity date\n- Funding source (RBDG / RMAP / IRP — for source mapping)\n- Collateral description and UCC filing number(s)\n- Insurance requirements (carrier, policy number, renewal date, loss payee confirmation)\n- Personal guarantor name(s)\n- TA coordinator assigned\n- Loan committee approval date and minutes reference\n\n**Common boarding errors:**\n- Wrong interest rate entered (causes payment calculation errors for the life of the loan)\n- Missing collateral or insurance data (creates compliance blind spots)\n- Wrong payment due date (borrower receives incorrect payment notices)\n\nReview every boarding entry against the signed loan documents before the first payment is due.\n\n## Step 2: Payment Processing and Posting\n\nPayments must be processed accurately, on time, and posted to the correct accounts:\n\n**Payment receipt methods:**\n- ACH (automatic bank debit — preferred for delinquency prevention)\n- Check (must be deposited and posted promptly)\n- Online payment portal (if available)\n- In-person cash (generate and retain receipt immediately)\n\n**Payment posting:**\nEach payment is allocated between:\n1. Interest (accrued since last payment)\n2. Principal (reduces outstanding balance)\n\nThis allocation follows the loan''s amortization schedule. If a borrower pays more than the scheduled amount, the excess must be applied per your credit policy (typically to principal, not next month''s payment — unless the borrower specifies otherwise).\n\n**Critical rule:** Post payments to the correct fund account. A payment on an RMAP RMRF loan goes into the RMRF account. A payment on an RBDG RLF loan goes into the RBDG RLF account. Never mix.\n\n**Generate and send payment receipts or statements** to borrowers monthly. Borrowers should always know their current balance, last payment, next payment due, and remaining term.\n\n## Step 3: Covenant Monitoring\n\nCovenants are ongoing obligations the borrower agreed to in the loan documents beyond making payments:\n\n- **Insurance maintenance:** Business property insurance, liability insurance, vehicle insurance (for vehicle collateral). The lender should be named as additional insured or loss payee. Track renewal dates and obtain proof annually.\n- **Business licensure:** Borrower must maintain all required licenses. Verify annually.\n- **Financial reporting:** Some loan agreements require annual financial statements or tax returns. Build these into the servicing calendar.\n- **Change of business ownership:** Borrower must notify lender before transferring ownership. Most loan agreements include a change of control clause that makes the loan due on transfer.\n- **Additional debt limitations:** Some credit policies prohibit borrowers from taking on new significant debt without lender consent during the loan term.\n\n## Step 4: Annual Reviews\n\nFor loans with terms greater than 12 months, conduct an annual review of each active loan:\n\n**Annual review components:**\n\n1. **Financial update:** Request current bank statements and most recent tax return. Recalculate DSCR with current data.\n2. **Business status check:** Is the business still operating? Same location? Same ownership?\n3. **Payment history review:** Any late payments in the past year? Trends?\n4. **Collateral condition:** Is collateral still in place and insured? Equipment still operational?\n5. **TA engagement review:** For RMAP loans, document the TA provided in the past year and planned for next year.\n6. **Risk rating update:** Update the internal risk rating based on current financial condition and payment history.\n\n**Document the annual review** in the loan file with the date, findings, and any action items.\n\n## Building a Servicing Calendar\n\nA servicing calendar prevents things from falling through the cracks. Build a calendar that tracks:\n\n| Frequency | Activity |\n|-----------|----------|\n| Daily | Payment posting; check for returned ACH payments |\n| Weekly | Review upcoming payment due dates; flag any approaching delinquency |\n| Monthly | Statements to borrowers; LLRF balance check (RMAP); delinquency report |\n| Quarterly | Covenant check (insurance, licenses); portfolio dashboard review |\n| Annually | Annual review for each active loan; UCC continuation check; compliance report |\n| As-needed | Delinquency outreach; workout discussions; default declarations |\n\n## What Must Be Documented at Each Stage\n\nDocumentation is the proof of servicing. If it is not in the file, it did not happen for audit purposes:\n\n| Stage | Required Documentation |\n|-------|----------------------|\n| Boarding | Signed loan documents, boarding checklist, first payment notice |\n| Payments | Payment receipts, amortization schedule, posting confirmation |\n| Covenant monitoring | Insurance certificates (annual), license copies, compliance notes |\n| Annual review | Financial documents received, DSCR calculation, risk rating update |\n| TA delivery | Session logs, attendance records, topics covered |\n| All | Date-stamped notes of any borrower contact (calls, emails, in-person) |',
  'Effective loan servicing starts at boarding and continues through payment processing, covenant monitoring, and annual review. A servicing calendar prevents critical items from falling through the cracks.',
  22, 1, 'approved')
ON CONFLICT DO NOTHING;

-- ============================================================
-- MODULE 2: Delinquency Prevention
-- ============================================================
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Delinquency Prevention',
  'Identify early warning indicators, implement proactive outreach at day 1, and connect delinquent borrowers to TA support.',
  2, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod2_id FROM modules WHERE certification_id = cert_id AND sort_order = 2;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod2_id,
  'Early Warning Indicators and Proactive Delinquency Prevention',
  'cert09-delinquency-prevention',
  E'## Prevention Is Cheaper Than Collection\n\nEvery hour spent on delinquency prevention saves 5-10 hours of collections work. The math is simple:\n\n- Proactive outreach call at day 1 of missed payment: 15-30 minutes\n- Collections effort at day 90: 5-10 hours minimum\n- Legal action and workout at day 180: 20-50 hours\n- Court judgment, charge-off, and recovery: 50-100+ hours\n\nOrganizations that invest in early warning systems and proactive outreach consistently maintain lower PAR rates and better portfolio health than organizations that wait for problems to escalate.\n\n## Early Warning Indicators\n\nSome borrowers telegraph delinquency before they miss a payment. Train your loan officers and servicing staff to watch for:\n\n**Financial warning signs:**\n- **Bounced check or returned ACH:** Even one NSF is a signal. Two or more in a 90-day window is a serious warning.\n- **Late payment trend:** Payments that arrive consistently a few days late, then a week late, then 15 days late are trending toward delinquency.\n- **Reduction in deposit amounts:** If you have access to business bank account activity (as some RLFs do through financial covenants), declining deposits signal declining revenue.\n- **Request for a payment extension:** A borrower who asks for an extra 10 days "just this once" may be experiencing cash flow stress.\n\n**Business operation warning signs:**\n- **TA cancellation:** A borrower who stops showing up to scheduled TA sessions or stops returning TA coordinator calls may be struggling or disengaged.\n- **Business location changes:** Unexplained move or loss of business location.\n- **Staff turnover:** For small businesses, losing key employees can disrupt operations significantly.\n- **Supplier relationship disruption:** A borrower who mentions losing a key supplier or customer is experiencing a business shock.\n- **Social media or marketplace signals:** Negative reviews, reduced posting activity, or announced closures on a borrower''s business Facebook page.\n\n**Life event warning signs:**\n- Health crisis (borrower or close family member)\n- Divorce or family disruption\n- Legal problems\n- Loss of a key employee who was also a partner or family member in the business\n\n## Proactive Outreach at Day 1 of Delinquency\n\n**The day 1 rule:** When a payment is not received by the end of the business day it is due, outreach begins the next business day. Not day 15. Not day 30. Day 1.\n\nWhy day 1?\n- Many missed payments are accidental (bounced ACH, bank account change, forgot the date)\n- Early contact resolves these administrative issues before they become real delinquency\n- Day 1 contact signals to the borrower that you are watching — this reduces strategic non-payment\n- Early intervention allows time for a workout solution if the problem is genuine\n\n**Day 1 outreach script (call):**\n\n> "Hi [Name], this is [Your name] from [Organization]. I''m calling because we didn''t receive your loan payment that was due on [date]. This may just be an administrative issue — sometimes ACH payments have a delay. Can you take a moment to check your account and let me know if the payment went through on your end? We want to make sure everything is okay with you and the business as well."\n\nNote the tone: collaborative, not threatening. You are checking in, not demanding.\n\n**Day 1 documentation:** Log the contact attempt (even if no answer) with date, time, and method. If you leave a voicemail, log the content of the message. If you reach the borrower, log the full conversation summary.\n\n## Cash Flow Check-Ins\n\nFor borrowers at elevated risk (recent delinquency history, flagged by early warning indicators, or in stressed industries), conduct monthly or quarterly cash flow check-ins:\n\n**Cash flow check-in agenda (15-20 minute call):**\n\n1. How is the business performing compared to your projections?\n2. What were your revenues this month? Your major expenses?\n3. Are there any upcoming cash needs we should plan for together?\n4. Is there anything threatening your ability to make your next loan payment?\n5. What TA support would be most helpful right now?\n\nDocument these conversations. If a borrower discloses a looming cash crisis during a check-in, you have an opportunity to be proactive — not reactive — about a workout solution.\n\n## Connecting Delinquent Borrowers to TA Support\n\nA borrower who is becoming delinquent almost always has a business problem that is causing the cash flow shortage. Technical assistance may solve the root cause:\n\n**TA interventions for at-risk borrowers:**\n\n| Business Problem | TA Response |\n|-----------------|-------------|\n| Revenue declining | Marketing support, pricing review, customer retention strategy |\n| Expenses too high | Cost reduction analysis, supplier negotiation coaching |\n| Cash flow timing | Invoice factoring options, payment terms negotiation |\n| Lost key customer | Customer diversification plan, business development coaching |\n| Staffing problems | HR support, workforce solutions referral |\n| Personal crisis affecting business | Referral to wraparound social services |\n\nFor RMAP-funded microloans, connecting a delinquent borrower to TA is not just good practice — it is consistent with the program''s statutory purpose of pairing lending with technical assistance.',
  'Prevention is far less costly than collections. Learn to identify early warning indicators, implement day 1 outreach, conduct cash flow check-ins, and connect at-risk borrowers to TA before delinquency deepens.',
  21, 1, 'approved')
ON CONFLICT DO NOTHING;

-- ============================================================
-- MODULE 3: Collections and Workout Process
-- ============================================================
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Collections and Workout Process',
  'Implement a collections contact cadence, issue demand notices, evaluate and document workout options including modification and restructuring.',
  3, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod3_id FROM modules WHERE certification_id = cert_id AND sort_order = 3;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod3_id,
  'Collections Cadence, Demand Notices, and Workout Documentation',
  'cert09-collections-workout',
  E'## The Collections Contact Cadence\n\nOnce a loan is delinquent, a structured contact cadence ensures consistent, documented outreach. Inconsistent or undocumented collections efforts are a compliance risk — USDA site visits will look for evidence of your collections process.\n\n**Standard Collections Cadence:**\n\n| Day | Action | Method | Documentation |\n|-----|--------|--------|---------------|\n| 1 | First outreach | Phone call | Call log with outcome |\n| 3 | Second outreach (if no response) | Phone + email | Log both attempts |\n| 10 | Third outreach | Phone | Log; note if contact made |\n| 15 | Written notice (Day 15 letter) | Certified mail | Copy in file; delivery confirmation |\n| 30 | Formal demand notice | Certified mail | Demand letter in file |\n| 45 | Workout discussion (if contact made) | In-person or phone | Workout memo |\n| 60 | Second formal demand | Certified mail + email | All in file |\n| 75 | Legal referral evaluation | Internal review | Committee memo |\n| 90 | Default declaration (if no resolution) | Board/committee action | Default notice letter |\n\n**Key principle:** Every contact attempt — whether successful or not — must be logged with the date, time, method, and result. "Called at 2:15 PM, no answer, left voicemail" is a complete log entry.\n\n## Demand Notices\n\nA demand notice is a formal written communication that:\n1. States the amount past due (principal and accrued interest)\n2. Demands payment by a specific date (typically 10-15 days from notice date)\n3. States the consequences of non-payment (acceleration, legal action, credit reporting)\n4. Is sent by certified mail (for proof of delivery)\n\n**Demand notice must NOT:**\n- Threaten violence or public shaming\n- Misrepresent the amount owed\n- Claim to be from a government agency (unless it is)\n- Use deceptive language\n\nThese prohibitions apply under the Fair Debt Collection Practices Act (FDCPA). While the FDCPA technically applies to third-party collectors, responsible microlenders apply these standards to their own collections communications.\n\n**Retain copies of all demand notices** with proof of mailing (certified mail receipt or return receipt card) in the loan file permanently.\n\n## Modification Options\n\nA loan modification changes the terms of the original loan agreement. Modifications are offered to borrowers who are experiencing genuine hardship but have a viable path to recovery. Modification options include:\n\n### Rate Reduction\nTemporarily or permanently reduce the interest rate to lower the monthly payment.\n- Example: Reduce from 7% to 4% for 12 months, then return to original rate\n- Best for: Borrowers with thin margins who need breathing room\n- Documentation: Loan modification agreement signed by borrower; updated amortization schedule\n\n### Term Extension\nExtend the remaining loan term to reduce the monthly payment by spreading principal repayment over more time.\n- Example: 36 months remaining extended to 60 months\n- Best for: Borrowers with steady but reduced cash flow\n- Note: Extending term increases total interest paid — borrower must understand this\n\n### Payment Deferral\nAllow the borrower to skip 1-3 months of payments, with those payments added to the end of the loan or paid as a lump sum.\n- Best for: Short-term cash flow disruptions (seasonal gap, lost contract that will be replaced)\n- Note: Interest continues to accrue during deferral — be transparent about this with the borrower\n- RMAP note: Payment deferrals on RMRF loans may require USDA notification depending on the program agreement\n\n### Partial Forgiveness\nReducing the principal balance owed. This is the most significant modification and should be rare:\n- Requires loan committee and typically board approval\n- Must be documented with clear rationale\n- May have tax consequences for the borrower (forgiven debt is income under IRS rules — advise borrower to consult a tax professional)\n- For RMAP loans: partial forgiveness of RMRF loan amounts may require USDA approval\n\n## Restructuring Standards\n\nA restructuring is a more comprehensive modification — changing multiple terms simultaneously. Restructurings are appropriate when:\n\n- The business is viable long-term but needs significant relief to survive a crisis\n- A single modification is insufficient to restore repayment capacity\n- The borrower has demonstrated good faith (communicating, providing documents, engaging with TA)\n\n**Before approving any restructuring:**\n1. Obtain current financial statements or bank statements\n2. Recalculate DSCR under proposed new terms — confirm the restructured loan is serviceable\n3. Get updated collateral valuation if significant time has passed\n4. Obtain board or loan committee approval per credit policy approval authority\n5. Execute a written workout agreement (not just a memo — a signed legal document)\n\n## Workout Agreement Documentation\n\nA workout agreement is a new or amended legal document that:\n- States the modified terms clearly\n- Releases the borrower from the old terms (or specifies which old terms remain in force)\n- Reaffirms the personal guarantee\n- States the consequences of default under the workout agreement\n- Is signed by all parties (borrower, guarantors, lender''s authorized officer)\n\nMaintain the workout agreement in the loan file permanently alongside the original loan documents. Update the servicing system to reflect modified terms on the day the agreement is executed.',
  'A structured collections cadence, compliant demand notices, and documented workout agreements protect your fund and your borrowers. Learn the full collections-to-workout process.',
  21, 1, 'approved')
ON CONFLICT DO NOTHING;

-- ============================================================
-- MODULE 4: Default, Charge-Off, and Recovery
-- ============================================================
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Default, Charge-Off, and Recovery',
  'Manage default declaration, charge-off authority, loss reserve draw-down, USDA notification, and post-charge-off recovery.',
  4, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod4_id FROM modules WHERE certification_id = cert_id AND sort_order = 4;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod4_id,
  'Default Declaration, Charge-Off Process, and Recovery Management',
  'cert09-default-chargeoff-recovery',
  E'## Default Decision Criteria\n\nDefault is a formal declaration that a borrower has failed to meet their loan obligations. Once declared, the full outstanding balance becomes immediately due (acceleration). Default is a serious action — it triggers legal remedies, credit reporting consequences, and USDA notification obligations. It should be declared deliberately, based on your credit policy criteria, not reactively.\n\n**Events that trigger default consideration:**\n\n- **Payment delinquency:** Most commonly, 90-180 days of non-payment after formal demand. Your credit policy should specify the number of days past due that constitutes payment default.\n- **Covenant breach:** Failure to maintain required insurance, losing required business licenses, unauthorized transfer of collateral\n- **Material misrepresentation:** Discovery that the borrower provided false information in the loan application\n- **Insolvency or bankruptcy filing:** A borrower who files for bankruptcy protection triggers an automatic stay — consult legal counsel immediately\n- **Business closure:** The borrower ceases operations without notifying the lender or arranging repayment\n- **Death of the sole proprietor** (for unincorporated businesses)\n\n**Before declaring default:**\n1. Confirm the default event meets the criteria in your credit policy\n2. Confirm all required collections efforts have been completed and documented\n3. Confirm no workout agreement is in place that modifies the default trigger\n4. Obtain loan committee (or board) approval per your credit policy approval authority for default declarations\n\n## Charge-Off Authority and Board Approval\n\nA charge-off is the accounting decision to remove an uncollectible loan from the active loan portfolio. It is a write-down of the asset on the balance sheet, funded by drawing on the loan loss reserve.\n\n**Charge-off is NOT:**\n- Loan forgiveness (the legal obligation continues)\n- The end of collections efforts\n- Notification to USDA that the loan is closed\n\n**Charge-off authority:**\n\nMost microlenders require **board approval** for charge-offs above a specified threshold. This is appropriate — charge-offs affect fund capitalization and may require USDA notification. A common authority structure:\n\n| Charge-off Amount | Approval Required |\n|------------------|-----------------|\n| Under $5,000 | Executive Director or Program Director |\n| $5,001 to $25,000 | Loan Committee |\n| Above $25,000 | Full Board of Directors |\n\n**Charge-off documentation required:**\n- Board or committee meeting minutes authorizing the charge-off\n- Written justification memo (history of the loan, collections efforts, reason for charge-off)\n- Updated loan file with final status\n- Updated portfolio and loss reserve records\n\n## Loss Reserve Draw-Down\n\nWhen a loan is charged off, the loss reserve absorbs the loss:\n\n**Accounting entry at charge-off:**\n- Debit: Loan Loss Reserve (reduces the reserve account)\n- Credit: Loans Receivable (removes the loan balance from the asset)\n\nAfter the draw-down, assess whether the remaining loss reserve is adequate for the current portfolio risk. If the reserve falls below your policy minimum or the tiered calculation minimum, replenish it:\n- For RBDG RLF: Use program income (loan interest and fees) to replenish\n- For RMAP RMRF: Maintain LLRF at required 5% of USDA balance\n- For IRP: Follow program agreement reserve requirements\n\n## USDA Notification Requirements for RMAP Defaults\n\nFor RMAP-funded RMRF loans, the microlender has specific USDA notification obligations when a loan defaults. Under 7 CFR 4280:\n\n- The microlender must notify the USDA Rural Development state office when a microloan enters default\n- USDA must be notified before or concurrent with any legal action to collect\n- USDA may require the microlender to exhaust specific remedies before pursuing others\n- USDA approval may be required before certain workout modifications or charge-offs\n\n**Practical rule:** Before taking any significant action on a defaulted RMAP RMRF loan — legal action, collateral liquidation, principal forgiveness, charge-off — contact your USDA state office loan specialist and document the guidance received.\n\nFor IRP-funded loans, similar notification obligations apply under the IRP program agreement. Review your specific agreement language.\n\n## Recovery Efforts Post-Charge-Off\n\nCharge-off does not end collection efforts. Many microlenders continue pursuing recovery for years after charge-off:\n\n**Recovery strategies:**\n\n- **Continued contact:** Regular contact with the borrower (within FDCPA standards) to explore payment arrangements\n- **Payment plans:** A charged-off borrower who begins making voluntary payments is recovering a portion of the loss — document payments and apply to the charged-off balance\n- **Collateral liquidation:** If UCC filings are in place and current, the lender may enforce its security interest and liquidate collateral. Proceeds are credited against the charged-off balance.\n- **Personal guarantee enforcement:** If the personal guarantor has assets, legal action against the guarantor may produce recovery\n- **Tax refund interception:** Not available to microlenders directly, but in some states, judgments can attach to state tax refunds\n- **Settlement:** A borrower may offer a lump sum settlement for less than the full balance — sometimes accepting 30-50 cents on the dollar is better than continued non-recovery\n\n**Document all recovery activity** in the charged-off loan file. Recovery proceeds must be credited to the appropriate fund account (RBDG RLF, RMAP RMRF, or IRP relending fund) from which the loan originated.\n\n## Reporting Defaulted Loans\n\n**Internal reporting:**\n- All defaulted loans must appear on the monthly portfolio delinquency/default report\n- The board should receive a quarterly summary of defaulted and charged-off loans\n- Recovery activity should be tracked and reported quarterly\n\n**USDA reporting:**\n- RMAP annual performance reports require disclosure of loans in default, charged off, and recovered\n- Failure to accurately report defaults is a material compliance violation\n- The LLRF balance must reflect any draw-downs related to charge-offs\n\n**Credit bureau reporting:**\nMicrolenders that report to credit bureaus (many do not, but some do) must follow Fair Credit Reporting Act (FCRA) requirements for accurate and timely reporting of defaults. If you do not currently report, consider whether doing so aligns with your mission — it creates accountability for borrowers but may also harm credit files for vulnerable populations.',
  'Default declaration, charge-off, USDA notification, and post-charge-off recovery require precise documentation and regulatory compliance. Learn every step of the process.',
  22, 1, 'approved')
ON CONFLICT DO NOTHING;

-- ============================================================
-- QUIZ for Cert 9
-- ============================================================
INSERT INTO quizzes (id, certification_id, title, passing_score, status)
VALUES (uuid_generate_v4(), cert_id,
  'Loan Servicing, Collections, Workouts and Default Management Knowledge Check',
  80, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO quiz_id FROM quizzes WHERE certification_id = cert_id;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order)
VALUES
(quiz_id,
  'When should loan boarding occur after loan closing and disbursement?',
  '[{"id":"a","text":"Within 30 days"},{"id":"b","text":"At the end of the fiscal quarter"},{"id":"c","text":"Within 1-3 business days"},{"id":"d","text":"On the date the first payment is due"}]',
  'c',
  'Loan boarding must occur within 1-3 business days of disbursement. Delays in boarding create gaps in servicing — the borrower may make a payment before the loan is in the system, leading to posting errors.',
  1),

(quiz_id,
  'According to the day 1 delinquency rule, when should outreach to a borrower with a missed payment begin?',
  '[{"id":"a","text":"Day 30 — the standard grace period for microloans"},{"id":"b","text":"Day 15 — when the first demand letter is sent"},{"id":"c","text":"The next business day after the missed payment due date"},{"id":"d","text":"Day 90 — when the loan is classified as in default"}]',
  'c',
  'Proactive outreach begins the next business day after a missed payment. Many missed payments are administrative errors (bounced ACH, forgotten date) that are easily resolved with an early call.',
  2),

(quiz_id,
  'Which of the following is the strongest early warning indicator of potential delinquency?',
  '[{"id":"a","text":"The borrower has fewer than 5 employees"},{"id":"b","text":"The borrower is in a rural area"},{"id":"c","text":"The borrower cancels multiple TA sessions and stops returning calls"},{"id":"d","text":"The borrower''s loan term exceeds 5 years"}]',
  'c',
  'TA cancellations and communication withdrawal are behavioral early warning indicators that often precede payment problems. Borrowers who disengage from support systems are frequently experiencing business or personal crises.',
  3),

(quiz_id,
  'What is a payment deferral workout option?',
  '[{"id":"a","text":"Permanently reducing the interest rate"},{"id":"b","text":"Forgiving a portion of the principal balance"},{"id":"c","text":"Allowing the borrower to skip 1-3 payments, added to the end of the loan, while interest continues to accrue"},{"id":"d","text":"Extending the loan term by 10 years"}]',
  'c',
  'A payment deferral allows the borrower to skip payments for a defined period, with deferred payments added to the end of the term. Interest continues to accrue during the deferral period — this must be clearly disclosed to the borrower.',
  4),

(quiz_id,
  'A demand notice sent to a delinquent borrower must be sent by which method to create a record of delivery?',
  '[{"id":"a","text":"Email with read receipt"},{"id":"b","text":"Certified mail"},{"id":"c","text":"Text message"},{"id":"d","text":"In-person hand delivery only"}]',
  'b',
  'Demand notices must be sent by certified mail to create a legally defensible proof of delivery. Email read receipts are not sufficient proof. Certified mail return receipts are retained in the loan file.',
  5),

(quiz_id,
  'Before a USDA RMAP RMRF loan can be charged off, what notification obligation exists?',
  '[{"id":"a","text":"No notification is required — charge-off is an internal accounting decision"},{"id":"b","text":"The borrower must be notified 90 days in advance"},{"id":"c","text":"The USDA Rural Development state office must be notified, and USDA may require specific remedies before charge-off"},{"id":"d","text":"The SBA must approve all RMAP charge-offs"}]',
  'c',
  'Under 7 CFR 4280, RMAP microlenders must notify USDA when a loan defaults, and USDA may require the microlender to exhaust specific remedies before pursuing certain actions including charge-off. Always contact the USDA state office before significant default actions.',
  6),

(quiz_id,
  'What is the accounting entry when a microloan is charged off?',
  '[{"id":"a","text":"Debit: Loans Receivable; Credit: Cash"},{"id":"b","text":"Debit: Loan Loss Reserve; Credit: Loans Receivable"},{"id":"c","text":"Debit: Cash; Credit: Loan Loss Reserve"},{"id":"d","text":"Debit: Operating Expense; Credit: Loans Receivable"}]',
  'b',
  'At charge-off, the Loan Loss Reserve is debited (reduced) and Loans Receivable is credited (removed from the books). The loss reserve absorbs the charge-off loss.',
  7),

(quiz_id,
  'A borrower whose loan has been charged off begins making voluntary payments. What should the lender do?',
  '[{"id":"a","text":"Refuse the payments — the loan is closed"},{"id":"b","text":"Apply payments to the charged-off balance and document recovery in the loan file"},{"id":"c","text":"Return the payments to the borrower since the debt is forgiven"},{"id":"d","text":"Apply payments to future origination fees"}]',
  'b',
  'Charge-off does not end the legal obligation or collection efforts. Voluntary payments on a charged-off loan are recovery — they must be accepted, applied to the charged-off balance, credited to the correct fund account, and documented.',
  8),

(quiz_id,
  'Which of the following events does NOT typically constitute a default trigger under a standard microloan agreement?',
  '[{"id":"a","text":"90 days of non-payment after formal demand"},{"id":"b","text":"Discovery that the borrower provided false information in the application"},{"id":"c","text":"The borrower hires an additional employee"},{"id":"d","text":"The borrower files for bankruptcy protection"}]',
  'c',
  'Hiring an additional employee is generally a positive business development, not a default trigger. Default triggers include payment delinquency, covenant breach, material misrepresentation, bankruptcy filing, and business closure.',
  9),

(quiz_id,
  'For which modification option must the lender advise the borrower to consult a tax professional?',
  '[{"id":"a","text":"Rate reduction"},{"id":"b","text":"Term extension"},{"id":"c","text":"Payment deferral"},{"id":"d","text":"Partial principal forgiveness"}]',
  'd',
  'Forgiven debt is treated as taxable income under IRS rules. Partial principal forgiveness may create an unexpected tax liability for the borrower. The lender should advise borrowers to consult a tax professional before agreeing to forgiveness.',
  10),

(quiz_id,
  'What is the primary purpose of a loan servicing calendar?',
  '[{"id":"a","text":"To schedule loan committee meetings"},{"id":"b","text":"To track payment due dates, covenant deadlines, annual reviews, and compliance obligations so nothing falls through the cracks"},{"id":"c","text":"To schedule USDA site visits"},{"id":"d","text":"To plan TA session delivery for all borrowers"}]',
  'b',
  'A servicing calendar organizes all recurring servicing obligations — payment tracking, insurance renewals, annual reviews, UCC continuations, LLRF checks, and reporting deadlines — ensuring consistent compliance across the entire loan portfolio.',
  11),

(quiz_id,
  'Under what circumstance may a term extension modification increase the total cost to the borrower?',
  '[{"id":"a","text":"It never increases total cost — extending the term always saves money"},{"id":"b","text":"When the extended term results in more interest paid over the life of the loan"},{"id":"c","text":"Only when the interest rate is also increased"},{"id":"d","text":"When the lender charges an extension fee greater than one month''s payment"}]',
  'b',
  'A term extension reduces the monthly payment but spreads repayment over more time — increasing total interest paid over the life of the loan. The borrower must understand this trade-off before agreeing to the modification.',
  12),

(quiz_id,
  'What RMAP TA connection is appropriate when a borrower''s declining revenue is identified during a cash flow check-in?',
  '[{"id":"a","text":"Immediate default declaration"},{"id":"b","text":"Referral to marketing support, pricing review, or customer retention strategy"},{"id":"c","text":"Automatic workout agreement"},{"id":"d","text":"USDA notification and program suspension"}]',
  'b',
  'RMAP pairs lending with TA for exactly this reason — when a cash flow check-in reveals declining revenue, the response is TA intervention (marketing, pricing, customer retention) to address the root cause, not immediate collections escalation.',
  13),

(quiz_id,
  'How long must demand notices and collections documentation be retained in the loan file?',
  '[{"id":"a","text":"1 year after loan payoff"},{"id":"b","text":"3 years after loan payoff"},{"id":"c","text":"Permanently — demand notices and collections records are legal documents"},{"id":"d","text":"Until the next USDA site visit"}]',
  'c',
  'Demand notices, collections logs, workout agreements, and default documentation are legal records that must be retained permanently in the loan file. They may be needed for legal proceedings years after the loan is resolved.',
  14),

(quiz_id,
  'When a charged-off loan''s personal guarantee is enforced and recovery proceeds are collected, where must those proceeds be credited?',
  '[{"id":"a","text":"The organization''s general operating account"},{"id":"b","text":"A new reserve fund for future charge-offs"},{"id":"c","text":"The specific fund account (RBDG RLF, RMAP RMRF, or IRP) from which the original loan was made"},{"id":"d","text":"Directly to USDA as repayment"}]',
  'c',
  'Recovery proceeds — whether from collateral liquidation, personal guarantee enforcement, or voluntary payments — must be credited to the specific restricted fund account from which the charged-off loan was originally funded.',
  15)
ON CONFLICT DO NOTHING;

END $$;

