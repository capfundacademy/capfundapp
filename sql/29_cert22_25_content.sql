-- ============================================================
-- Cap Fund Academy — Cert 22–26 Content
-- Cert 22: USDA Rural Business & OneRD Guaranteed Lending
-- Cert 23: USDA Housing & Multifamily Lending
-- Cert 24: USDA Farm & Agriculture Credit
-- Cert 25: FHA, VA, USDA Mortgage & Native Housing Lending
-- Cert 26: FHA Multifamily, Healthcare & HUD Risk-Sharing
-- Run after: 27_cert_seeds_18_35.sql
-- ============================================================


-- ═══════════════════════════════════════════════════════════════
-- CERT 22: USDA Rural Business & OneRD Guaranteed Lending
-- ═══════════════════════════════════════════════════════════════

-- ── Cert 22 ─────────────────────────────────────

INSERT INTO modules (certification_id, title, sort_order, status)
SELECT id, 'USDA Rural Development & OneRD Platform Overview', 1, 'approved' FROM certifications WHERE cert_number = 22
ON CONFLICT DO NOTHING;


INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status)
SELECT m.id, 'USDA Rural Development: The Full Lending Ecosystem', 'usda-rural-development-the-full-lending-ecosystem',
$BODY$## USDA Rural Development: The Full Lending Ecosystem

USDA Rural Development (RD) is one of the most comprehensive rural financing ecosystems in the United States. It encompasses business lending, housing finance, water and utility infrastructure, telecommunications, energy, and community facilities — all within a single agency. Understanding the full scope of what RD does is the foundation for building capital access strategies for rural communities.

**What USDA Rural Development Does**
USDA RD provides loans, loan guarantees, and grants to rural communities, businesses, homeowners, and utilities through three mission areas: (1) Rural Business-Cooperative Service (RBS), (2) Rural Housing Service (RHS), and (3) Rural Utilities Service (RUS). Each mission area administers multiple programs, and many projects can stack funding from multiple programs.

**The OneRD Guarantee Loan Initiative**
OneRD is USDA's consolidated platform for four major guaranteed lending programs: Business & Industry (B&I), Community Facilities (CF), Water & Waste Disposal (WWD), and Rural Energy for America Program (REAP). The OneRD platform standardized the application, approval, and servicing processes across these four programs under a single set of regulations (7 CFR Part 5001).

This means that an organization that learns the OneRD guarantee platform can access four separate federal lending programs — a major efficiency for lenders who serve rural communities.

**B&I Guaranteed Loan Program**
The Business & Industry program guarantees loans made by eligible lenders to rural businesses, cooperatives, and rural communities for a broad range of purposes including working capital, equipment, real estate, debt refinancing, and business acquisition. Maximum loan amount: $25 million. Guarantee rates: 80% for loans up to $5M, 70% up to $10-M, 60% above $10-M.

**Rural Eligibility**
All OneRD programs require that projects be in eligible rural areas — defined as communities with populations under specific thresholds (varies by program, generally under 50,000). Eligibility can be verified using USDA's online eligibility mapping tool.

**Key Terms**
- **OneRD**: USDA's consolidated guaranteed lending platform covering B&I, CF, WWD, and REAP.
- **B&I**: Business & Industry Guaranteed Loan — USDA's primary rural business lending guarantee.
- **Rural eligibility**: A community or area that meets USDA's population and character requirements.

**Practical Checklist**
- [ ] Verify rural eligibility for your service area using eligibility.sc.egov.usda.gov
- [ ] Review OneRD regulations at 7 CFR Part 5001
- [ ] Identify USDA-approved lenders operating in your region
- [ ] Attend a USDA Rural Development lender training webinar
- [ ] Map your target borrowers to specific OneRD programs
$BODY$, 1, 10, 'approved'
FROM modules m JOIN certifications c ON m.certification_id = c.id
WHERE c.cert_number = 22 AND m.sort_order = 1
ON CONFLICT DO NOTHING;

INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status)
SELECT m.id, 'B&I Loan Packaging, Eligibility & Lender Requirements', 'bi-loan-packaging-eligibility-lender-requirements',
$BODY$## B&I Loan Packaging, Eligibility & Lender Requirements

The Business & Industry Guaranteed Loan program is USDA's most widely used rural business lending tool. As a community lender or technical assistance provider, understanding how to package a B&I loan — or refer a borrower to an approved lender — is a high-value skill.

**Eligible Lenders**
B&I loans must be made by approved lenders — typically federal or state-chartered banks, savings institutions, credit unions, insurance companies, or other federally regulated lenders. Nonprofit CDFIs and community development organizations are generally NOT eligible to be B&I lenders directly, but can partner with approved lenders or serve as technical assistance providers.

**Eligible Borrowers and Projects**
B&I borrowers can include: corporations, partnerships, cooperatives, individuals, public bodies, and nonprofits. Projects must be in eligible rural areas and create or retain jobs. Eligible uses include: real estate, equipment, working capital, debt refinancing (with restrictions), and business acquisition.

**Loan Packaging Requirements**
A complete B&I application includes: credit analysis and underwriting memo, financial statements (3 years), business plan and projections, feasibility study (for larger loans), appraisals, environmental review, and documentation of the project's rural eligibility.

**Partnering with Approved Lenders**
For community organizations that cannot be direct B&I lenders, the most effective strategy is to: (1) identify approved B&I lenders in your region, (2) build referral relationships, (3) provide technical assistance to borrowers preparing applications, and (4) help document the community impact and rural eligibility of projects.

**Key Terms**
- **B&I guarantee rate**: The percentage SBA guarantees in case of default (60–80% depending on loan size).
- **Feasibility study**: An analysis of a project's financial and market viability, required for larger projects.
- **Environmental review**: An assessment of potential environmental impacts required for all OneRD loans.

**Practical Checklist**
- [ ] Identify B&I-approved lenders in your area (contact your USDA state office)
- [ ] Review the B&I eligibility checklist in 7 CFR Part 5001
- [ ] Develop a borrower preparation checklist for B&I applications
- [ ] Learn USDA's environmental review requirements for guaranteed loans
$BODY$, 2, 9, 'approved'
FROM modules m JOIN certifications c ON m.certification_id = c.id
WHERE c.cert_number = 22 AND m.sort_order = 1
ON CONFLICT DO NOTHING;



INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
SELECT id, 'USDA Rural Business & OneRD Assessment', 75, 50, 'approved' FROM certifications WHERE cert_number = 22
ON CONFLICT DO NOTHING;


WITH qid AS (
  SELECT q.id AS quiz_id FROM quizzes q JOIN certifications c ON q.certification_id = c.id
  WHERE c.cert_number = 22 AND q.title = 'USDA Rural Business & OneRD Assessment')
INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order)
SELECT qid.quiz_id, v.question_text, v.options::jsonb, v.correct_option_id, v.explanation, v.sort_order
FROM qid CROSS JOIN (VALUES
  ('The OneRD platform consolidates which four USDA programs?', '[{"id":"a","text":"RMAP, IRP, RBDG, REDLG"},{"id":"b","text":"B&I, Community Facilities, Water & Waste, REAP"},{"id":"c","text":"Section 502, 504, 515, 538"},{"id":"d","text":"FSA Farm Loans, BIA, CDFI, EDA"}]', 'b', 'OneRD consolidates Business & Industry (B&I), Community Facilities (CF), Water & Waste Disposal (WWD), and Rural Energy for America Program (REAP) under a single regulatory framework (7 CFR Part 5001).', 1),
  ('What is the maximum B&I loan amount?', '[{"id":"a","text":"$5 million"},{"id":"b","text":"$10 million"},{"id":"c","text":"$25 million"},{"id":"d","text":"$50 million"}]', 'c', 'The Business & Industry Guaranteed Loan program has a maximum loan amount of $25 million.', 2),
  ('What guarantee rate does the B&I program provide for loans up to $5 million?', '[{"id":"a","text":"60%"},{"id":"b","text":"70%"},{"id":"c","text":"80%"},{"id":"d","text":"90%"}]', 'c', 'B&I guarantee rates are 80% for loans up to $5 million, 70% for loans $5-10 million, and 60% for loans over $10 million.', 3),
  ('Can a nonprofit CDFI be a direct B&I lender?', '[{"id":"a","text":"Yes, any nonprofit can apply"},{"id":"b","text":"No, only federally regulated financial institutions can be approved B&I lenders"},{"id":"c","text":"Yes, if they have CDFI certification"},{"id":"d","text":"Only if they partner with a commercial bank"}]', 'b', 'B&I approved lenders must be federally regulated financial institutions (banks, credit unions, insurance companies). Nonprofits can partner with approved lenders but generally cannot be direct B&I lenders.', 4),
  ('Under what regulation does the OneRD platform operate?', '[{"id":"a","text":"7 CFR Part 4280"},{"id":"b","text":"7 CFR Part 5001"},{"id":"c","text":"2 CFR Part 200"},{"id":"d","text":"13 CFR Part 120"}]', 'b', 'The OneRD Guarantee Loan Initiative operates under 7 CFR Part 5001, which standardized the application and servicing processes for B&I, CF, WWD, and REAP programs.', 5),
  ('What tool can be used to verify rural eligibility for USDA programs?', '[{"id":"a","text":"SAM.gov"},{"id":"b","text":"Grants.gov"},{"id":"c","text":"eligibility.sc.egov.usda.gov"},{"id":"d","text":"sba.gov/funding-programs"}]', 'c', 'USDA provides an online eligibility mapping tool at eligibility.sc.egov.usda.gov for verifying whether a specific address or area qualifies as rural under various USDA programs.', 6),
  ('What is a feasibility study, and when is it required for B&I loans?', '[{"id":"a","text":"A credit report — required for all loans"},{"id":"b","text":"An environmental analysis — required for loans over $1 million"},{"id":"c","text":"An analysis of financial and market viability — required for larger or complex projects"},{"id":"d","text":"A demographic study — required for all rural loans"}]', 'c', 'A feasibility study analyzes the financial projections, market demand, and viability of a project. USDA requires feasibility studies for larger B&I loans and complex projects.', 7),
  ('Which of the following is an eligible use of B&I loan proceeds?', '[{"id":"a","text":"Political campaign contributions"},{"id":"b","text":"Purchase of a rural manufacturing facility"},{"id":"c","text":"Charitable grants to community organizations"},{"id":"d","text":"Personal expenses of business owners"}]', 'b', 'B&I loans can be used for eligible business purposes including real estate, equipment, working capital, and business acquisition — all in eligible rural areas.', 8),
  ('The Rural Energy for America Program (REAP) is part of which platform?', '[{"id":"a","text":"SBA programs"},{"id":"b","text":"USDA OneRD"},{"id":"c","text":"HUD risk-sharing"},{"id":"d","text":"EPA environmental finance"}]', 'b', 'REAP (Rural Energy for America Program) is one of the four programs consolidated under the USDA OneRD platform, providing guaranteed loans and grants for renewable energy and energy efficiency projects.', 9),
  ('A community organization wants to help rural businesses access B&I financing. What is their most effective role?', '[{"id":"a","text":"Apply to become an approved B&I lender"},{"id":"b","text":"Provide technical assistance to borrowers and build referral relationships with approved lenders"},{"id":"c","text":"Establish a state-chartered bank"},{"id":"d","text":"Apply for CDFI certification first"}]', 'b', 'Community organizations are most effective as technical assistance providers and referral partners — helping borrowers prepare applications and connecting them with approved B&I lenders.', 10)
) AS v(question_text, options, correct_option_id, explanation, sort_order)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- CERT 23: USDA Housing & Multifamily Lending
-- ═══════════════════════════════════════════════════════════════

-- ── Cert 23 ─────────────────────────────────────

INSERT INTO modules (certification_id, title, sort_order, status)
SELECT id, 'USDA Single-Family Housing Programs', 1, 'approved' FROM certifications WHERE cert_number = 23
ON CONFLICT DO NOTHING;


INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status)
SELECT m.id, 'Section 502 Guaranteed and Direct Home Loan Programs', 'section-502-guaranteed-and-direct-home-loan-programs',
$BODY$## Section 502 Guaranteed and Direct Home Loan Programs

USDA's Section 502 programs help low- and moderate-income rural residents purchase, build, rehabilitate, or repair homes. There are two distinct pathways: the Section 502 Guaranteed Loan Program (administered through private lenders) and the Section 502 Direct Loan Program (administered directly by USDA).

**Section 502 Guaranteed Loan Program**
The guaranteed program works like FHA or VA mortgage insurance — USDA guarantees loans made by approved private lenders (banks, mortgage companies, credit unions). The guarantee covers up to 90% of the loan in case of default, making it attractive for lenders serving rural markets.

Key features: No down payment required. Competitive interest rates. Loans up to $359,000 (varies by area). Income limits apply (generally 115% of area median income). Must be a primary residence in an eligible rural area.

To become an approved Section 502 guaranteed lender, organizations must meet USDA's lender eligibility requirements, which generally require being a regulated financial institution. CDFIs can partner with approved lenders to serve rural homebuyers.

**Section 502 Direct Loan Program**
The direct program is administered by USDA itself — USDA is the actual lender. These loans target very low- and low-income rural households who cannot obtain financing through conventional or guaranteed programs. Interest rates can be as low as 1% with payment assistance subsidies.

As a community organization, your role with the direct program is typically as a referral partner and application assistance provider — helping borrowers understand eligibility, gather documentation, and submit applications to USDA.

**Key Terms**
- **Section 502 Guaranteed**: USDA guarantees loans made by private lenders to rural homebuyers.
- **Section 502 Direct**: USDA makes loans directly to very low-income rural households.
- **Payment assistance**: A subsidy that reduces the effective interest rate for very low-income borrowers.

**Practical Checklist**
- [ ] Verify eligible rural area status for your service area at eligibility.sc.egov.usda.gov
- [ ] Identify Section 502 guaranteed lenders in your region
- [ ] Review income limits for your county at rd.usda.gov
- [ ] Develop a homebuyer readiness checklist for rural clients
- [ ] Create a referral process for clients who qualify for Section 502 Direct
$BODY$, 1, 9, 'approved'
FROM modules m JOIN certifications c ON m.certification_id = c.id
WHERE c.cert_number = 23 AND m.sort_order = 1
ON CONFLICT DO NOTHING;

INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status)
SELECT m.id, 'Rural Multifamily Housing: Section 538, 515 & Farm Labor Housing', 'rural-multifamily-housing-section-538-515-farm-labor-housing',
$BODY$## Rural Multifamily Housing: Section 538, 515 & Farm Labor Housing

USDA's multifamily housing programs finance affordable rental housing development in rural areas. For developers, housing organizations, and community lenders building rural capital stacks, understanding these programs opens significant financing opportunities.

**Section 538 Guaranteed Rural Rental Housing**
Section 538 guarantees loans made by approved private lenders for the construction or improvement of affordable rural rental housing. The guarantee covers up to 90% of the loan, making it a powerful de-risking tool for private lenders willing to serve rural markets.

Eligible projects include new construction or substantial rehabilitation of affordable rental properties. Projects must be in eligible rural areas and include income restrictions — a percentage of units must be rented to low- or moderate-income households. Loan terms can extend to 40 years.

**Section 515 Rural Rental Housing Direct Program**
Section 515 is a direct loan program through which USDA finances affordable rural rental housing at very favorable terms (effective rates as low as 1%). The portfolio of existing Section 515 properties represents billions in affordable housing across rural America. While new Section 515 awards are rare, understanding the existing portfolio is critical for preservation work and refinancing strategies.

**Farm Labor Housing Programs (Section 514/516)**
Sections 514 and 516 provide loans and grants for housing and related facilities for domestic farm laborers. Section 514 is a direct loan program; Section 516 provides grants to nonprofits, public agencies, and tribal organizations. These programs address one of the most under-resourced housing needs in rural America.

**Building a Rural Housing Capital Stack**
Most rural affordable housing projects require multiple capital layers. A typical stack might include: Section 538 guaranteed loan (senior debt), Low-Income Housing Tax Credit equity, HOME funds (via state HFA), USDA Housing Preservation Grants, and Community Development Block Grant.

**Key Terms**
- **Section 538**: USDA guarantee for multifamily rural rental housing loans.
- **Section 515**: USDA direct loan for affordable rural rental housing.
- **Capital stack**: The combination of financing sources funding a single project.

**Practical Checklist**
- [ ] Identify Section 538-approved lenders in your state
- [ ] Review existing Section 515 properties in your service area (USDA has a portfolio map)
- [ ] Research your State Housing Finance Agency's rural housing programs
- [ ] Learn the LIHTC application timeline in your state
- [ ] Develop a capital stack template for a hypothetical rural housing project
$BODY$, 1, 9, 'approved'
FROM modules m JOIN certifications c ON m.certification_id = c.id
WHERE c.cert_number = 23 AND m.sort_order = 1
ON CONFLICT DO NOTHING;



INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
SELECT id, 'USDA Housing & Multifamily Lending Assessment', 75, 45, 'approved' FROM certifications WHERE cert_number = 23
ON CONFLICT DO NOTHING;


WITH qid AS (
  SELECT q.id AS quiz_id FROM quizzes q JOIN certifications c ON q.certification_id = c.id
  WHERE c.cert_number = 23 AND q.title = 'USDA Housing & Multifamily Lending Assessment')
INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order)
SELECT qid.quiz_id, v.question_text, v.options::jsonb, v.correct_option_id, v.explanation, v.sort_order
FROM qid CROSS JOIN (VALUES
  ('What is the maximum USDA guarantee percentage for Section 502 Guaranteed loans?', '[{"id":"a","text":"75%"},{"id":"b","text":"80%"},{"id":"c","text":"90%"},{"id":"d","text":"100%"}]', 'c', 'USDA guarantees up to 90% of Section 502 Guaranteed loans, significantly reducing lender risk for rural mortgage origination.', 1),
  ('Who administers the Section 502 Direct Loan Program?', '[{"id":"a","text":"FHA-approved mortgage lenders"},{"id":"b","text":"State housing finance agencies"},{"id":"c","text":"USDA Rural Development directly"},{"id":"d","text":"Ginnie Mae-approved issuers"}]', 'c', 'USDA Rural Development is the direct lender in the Section 502 Direct program — USDA makes the loans itself to very low- and low-income rural borrowers.', 2),
  ('Section 538 guarantees loans for what type of rural property?', '[{"id":"a","text":"Single-family homeownership"},{"id":"b","text":"Multifamily affordable rental housing"},{"id":"c","text":"Commercial real estate"},{"id":"d","text":"Agricultural land"}]', 'b', 'Section 538 provides loan guarantees for the construction or improvement of affordable rural rental housing (multifamily).', 3),
  ('What income level does Section 502 Direct primarily serve?', '[{"id":"a","text":"150% of area median income"},{"id":"b","text":"115% of area median income"},{"id":"c","text":"Very low- and low-income households"},{"id":"d","text":"Moderate-income households only"}]', 'c', 'The Section 502 Direct Loan Program targets very low- and low-income rural households who cannot obtain financing through conventional or guaranteed programs.', 4),
  ('Farm Labor Housing (Section 514/516) serves which population?', '[{"id":"a","text":"Rural homebuyers seeking first mortgages"},{"id":"b","text":"Domestic farm laborers in need of affordable housing"},{"id":"c","text":"Farmers seeking operating loans"},{"id":"d","text":"Rural seniors needing repair assistance"}]', 'b', 'USDA Sections 514 and 516 specifically address the housing needs of domestic farm laborers in rural areas — one of the most underserved rural populations.', 5),
  ('What is a Section 502 Guaranteed borrower income limit?', '[{"id":"a","text":"Below poverty level only"},{"id":"b","text":"80% of area median income"},{"id":"c","text":"115% of area median income"},{"id":"d","text":"No income limit"}]', 'c', 'Section 502 Guaranteed borrowers must generally have incomes at or below 115% of the area median income.', 6),
  ('Section 515 is best described as:', '[{"id":"a","text":"A state-level housing grant program"},{"id":"b","text":"A USDA direct loan program for affordable rural rental housing"},{"id":"c","text":"An FHA insurance program for rural mortgages"},{"id":"d","text":"A CDFI program for rural developers"}]', 'b', 'Section 515 is a USDA direct loan program that has financed affordable rural rental housing at below-market interest rates — the existing portfolio represents decades of rural housing investment.', 7),
  ('A rural affordable housing project typically requires multiple capital layers. This is called:', '[{"id":"a","text":"A USDA consolidated application"},{"id":"b","text":"A capital stack"},{"id":"c","text":"A guarantee pool"},{"id":"d","text":"A relending structure"}]', 'b', 'A capital stack is the combination of multiple financing sources — grants, debt, equity, tax credits — that together fund a single project.', 8),
  ('To originate Section 502 Guaranteed loans directly, an organization must:', 'Be a nonprofit with CDFI certification', 'Meet USDA lender eligibility as a regulated financial institution', 'Have five years of rural housing experience', 'Submit a feasibility study to USDA', 'B', 'Section 502 Guaranteed lenders must meet USDA's lender eligibility requirements, which generally require being a federally regulated financial institution.', 9),
  ('What is the role of a community organization in the Section 502 Direct program?', '[{"id":"a","text":"Originate and service direct USDA loans"},{"id":"b","text":"Provide referrals, application assistance, and homebuyer counseling"},{"id":"c","text":"Administer the USDA guarantee"},{"id":"d","text":"Manage the Section 502 loan servicing portfolio"}]', 'b', 'Since USDA originates Section 502 Direct loans itself, community organizations serve most effectively as referral partners and application assistance providers.', 10)
) AS v(question_text, options, correct_option_id, explanation, sort_order)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- CERT 24: USDA Farm & Agriculture Credit
-- ═══════════════════════════════════════════════════════════════

-- ── Cert 24 ─────────────────────────────────────

INSERT INTO modules (certification_id, title, sort_order, status)
SELECT id, 'FSA Guaranteed and Direct Farm Loan Programs', 1, 'approved' FROM certifications WHERE cert_number = 24
ON CONFLICT DO NOTHING;


INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status)
SELECT m.id, 'USDA FSA Loan Programs: Overview for Lenders and TA Providers', 'usda-fsa-loan-programs-overview-for-lenders-and-ta-providers',
$BODY$## USDA FSA Loan Programs: Overview for Lenders and TA Providers

The USDA Farm Service Agency (FSA) operates the primary federal agricultural lending system. FSA provides both guaranteed and direct loans for farm ownership, operating costs, and equipment — with special programs for beginning, socially disadvantaged, and veteran farmers.

**Guaranteed Farm Loans**
FSA guaranteed farm loans work like other government guarantee programs — FSA guarantees a portion of loans made by approved commercial lenders, typically banks and credit unions with agricultural lending experience. The guarantee reduces lender risk and encourages private capital flow to agricultural borrowers.

- **Guaranteed Farm Ownership (GFO) Loans**: For purchasing or improving farmland, constructing or improving farm buildings, or promoting soil and water conservation. Maximum loan: $600,000 (may increase with inflation adjustments). FSA guarantees up to 95%.
- **Guaranteed Operating Loans (GOL)**: For annual operating expenses — seed, feed, fertilizer, equipment, and living expenses. FSA guarantees up to 95%.
- **Land Contract Guarantee**: FSA can guarantee a seller-financed land contract, enabling a seller to finance the sale of their farm with federal protection against buyer default.

**Direct Farm Loans**
FSA also makes direct loans from its own funds to farmers who cannot obtain credit elsewhere. Direct loans have lower interest rates and more flexible terms. Key programs include:
- **Direct Farm Ownership Loans**: Up to $300,000 for beginning farmers (with down payment loan option).
- **Direct Operating Loans**: Up to $400,000 for annual expenses and equipment.
- **FSA Microloans**: Up to $50,000 for small-scale, beginning, and non-traditional farmers (simplified application, minimal documentation requirements).

**Special Emphasis Programs**
FSA prioritizes access for beginning farmers (defined as those with less than 10 years of farming experience), socially disadvantaged farmers (members of racial or ethnic minority groups), and veteran farmers. Reserved loan funds, lower interest rates, and simplified processes are available for these groups.

**Key Terms**
- **FSA**: Farm Service Agency — USDA's primary agricultural credit agency.
- **Beginning farmer**: A farmer with less than 10 years of farming experience.
- **FSA Microloan**: A streamlined FSA loan up to $50,000 for small-scale and beginning farmers.

**Practical Checklist**
- [ ] Identify beginning farmer borrowers in your network who may qualify for FSA programs
- [ ] Contact your local FSA county office for current loan limits and terms
- [ ] Review the Down Payment Farm Loan program for beginning farmer homesteaders
- [ ] Develop a referral process for agricultural borrowers who need FSA assistance
- [ ] Learn the Farm Credit System lenders in your region for partnership opportunities
$BODY$, 1, 9, 'approved'
FROM modules m JOIN certifications c ON m.certification_id = c.id
WHERE c.cert_number = 24 AND m.sort_order = 1
ON CONFLICT DO NOTHING;



INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
SELECT id, 'USDA Farm & Agriculture Credit Assessment', 75, 40, 'approved' FROM certifications WHERE cert_number = 24
ON CONFLICT DO NOTHING;


WITH qid AS (
  SELECT q.id AS quiz_id FROM quizzes q JOIN certifications c ON q.certification_id = c.id
  WHERE c.cert_number = 24 AND q.title = 'USDA Farm & Agriculture Credit Assessment')
INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order)
SELECT qid.quiz_id, v.question_text, v.options::jsonb, v.correct_option_id, v.explanation, v.sort_order
FROM qid CROSS JOIN (VALUES
  ('What percentage does FSA guarantee on guaranteed farm loans?', '[{"id":"a","text":"Up to 75%"},{"id":"b","text":"Up to 80%"},{"id":"c","text":"Up to 90%"},{"id":"d","text":"Up to 95%"}]', 'd', 'FSA guarantees up to 95% of guaranteed farm ownership and operating loans, one of the highest guarantee rates in any federal lending program.', 1),
  ('What is the maximum FSA Microloan amount?', '[{"id":"a","text":"$25,000"},{"id":"b","text":"$50,000"},{"id":"c","text":"$100,000"},{"id":"d","text":"$150,000"}]', 'b', 'FSA Microloans have a maximum of $50,000 and use a simplified application process designed for small-scale and beginning farmers.', 2),
  ('How is a "beginning farmer" defined for FSA purposes?', '[{"id":"a","text":"First-time loan applicant"},{"id":"b","text":"Farmer with less than 10 years of experience"},{"id":"c","text":"Farmer under age 35"},{"id":"d","text":"Farmer with less than 100 acres"}]', 'b', 'FSA defines a beginning farmer as someone with 10 years or fewer of farming experience — not age-based.', 3),
  ('Which FSA program can guarantee a seller-financed land sale?', '[{"id":"a","text":"Guaranteed Farm Ownership Loan"},{"id":"b","text":"Land Contract Guarantee"},{"id":"c","text":"FSA Microloan"},{"id":"d","text":"Beginning Farmer Down Payment Loan"}]', 'b', 'The FSA Land Contract Guarantee protects a seller who finances the purchase of their farm directly to a buyer — FSA guarantees the buyer''s payments to the seller.', 4),
  ('What is the maximum Guaranteed Farm Ownership loan amount?', '[{"id":"a","text":"$300,000"},{"id":"b","text":"$400,000"},{"id":"c","text":"$600,000"},{"id":"d","text":"$1 million"}]', 'c', 'The maximum Guaranteed Farm Ownership loan amount is $600,000 (subject to inflation adjustments), compared to $300,000 for the Direct Farm Ownership loan.', 5),
  ('Who administers the FSA guaranteed farm loan program?', '[{"id":"a","text":"FSA makes the loans directly"},{"id":"b","text":"Approved commercial lenders with FSA guarantees"},{"id":"c","text":"State agricultural agencies"},{"id":"d","text":"Farm Credit System only"}]', 'b', 'FSA guaranteed loans are made by approved commercial lenders (primarily banks and credit unions) with FSA providing the guarantee — FSA does not originate these loans.', 6),
  ('Socially disadvantaged farmers are defined as:', '[{"id":"a","text":"Farmers below the poverty line"},{"id":"b","text":"Members of racial or ethnic minority groups"},{"id":"c","text":"Farmers in designated disaster areas"},{"id":"d","text":"Farmers with more than $100,000 in debt"}]', 'b', 'For FSA purposes, socially disadvantaged farmers are members of racial or ethnic minority groups — a classification that unlocks priority access to certain loan programs and reserved funds.', 7),
  ('What is the Farm Credit System?', '[{"id":"a","text":"USDA''s direct lending division"},{"id":"b","text":"A network of federally chartered cooperative lenders serving agricultural markets"},{"id":"c","text":"SBA''s rural lending program"},{"id":"d","text":"A group of state agricultural agencies"}]', 'b', 'The Farm Credit System is a nationwide network of federally chartered cooperative lending institutions (Farm Credit Banks, Agricultural Credit Associations) that serve farmers, rural homeowners, and agricultural businesses.', 8),
  ('FSA Direct Operating Loans can be used for which purpose?', '[{"id":"a","text":"Purchasing farmland only"},{"id":"b","text":"Annual farm expenses including seed, feed, fertilizer, and equipment"},{"id":"c","text":"Building farm structures only"},{"id":"d","text":"Paying off existing farm debt"}]', 'b', 'FSA Direct Operating Loans cover annual production expenses — seed, feed, fertilizer, pesticides, fuel, farm supplies, and the personal living expenses of farmers during the growing season.', 9),
  ('A community organization working with beginning farmers wants to help them access federal credit. What is the most appropriate first step?', '[{"id":"a","text":"Apply to become an FSA-approved lender"},{"id":"b","text":"Contact the local FSA county office and learn about current program availability"},{"id":"c","text":"Establish a Farm Credit Association"},{"id":"d","text":"Apply for CDFI certification"}]', 'b', 'The local FSA county office is the primary point of contact for beginning farmer loans, program availability, and application assistance. Community organizations should build relationships with their county FSA office.', 10)
) AS v(question_text, options, correct_option_id, explanation, sort_order)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- CERT 25: FHA, VA, USDA Mortgage & Native Housing Lending
-- ═══════════════════════════════════════════════════════════════

-- ── Cert 25 ─────────────────────────────────────

INSERT INTO modules (certification_id, title, sort_order, status)
SELECT id, 'Government Mortgage Program Ecosystem', 1, 'approved' FROM certifications WHERE cert_number = 25
ON CONFLICT DO NOTHING;


INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status)
SELECT m.id, 'FHA, VA, and USDA Mortgage Programs: How They Work Together', 'fha-va-and-usda-mortgage-programs-how-they-work-together',
$BODY$## FHA, VA, and USDA Mortgage Programs: How They Work Together

Government mortgage insurance and guarantee programs — FHA, VA, and USDA — make homeownership accessible to millions of Americans who cannot qualify for conventional mortgages. Together, they represent the backbone of the affordable homeownership ecosystem.

**FHA Mortgage Insurance**
The Federal Housing Administration (FHA), within HUD, insures mortgage loans made by approved mortgagees (lenders). FHA does not make loans — it insures them. Borrowers pay mortgage insurance premiums (MIP), which fund a reserve that reimburses lenders in case of default.

FHA's primary product is Title II single-family mortgage insurance — the standard FHA purchase loan that requires a 3.5% down payment for borrowers with credit scores of 580 or higher. FHA is the largest government mortgage insurance program by volume and serves a disproportionate share of first-time homebuyers and minority borrowers.

To originate FHA loans, a lender must be an FHA-approved mortgagee. The approval process requires: institutional accreditation, net worth requirements ($1 million minimum for supervised lenders), quality control plan, and compliance with HUD handbook requirements.

**VA Loan Guarantee**
The Department of Veterans Affairs guarantees mortgage loans made by VA-approved lenders to eligible veterans, service members, and surviving spouses. VA does not set a maximum loan amount, but guarantees a portion of each loan. VA loans require no down payment and no private mortgage insurance — making them the most favorable terms available for eligible borrowers.

**USDA Rural Housing**
Section 502 Guaranteed (covered in Cert 23) is USDA's primary rural homeownership mortgage guarantee product. USDA-approved lenders originate these loans, which require no down payment for eligible rural borrowers.

**The Combined Picture**
Many rural communities have borrowers eligible for multiple programs. A veteran living in a rural area might qualify for both VA and USDA. Building referral pathways to approved lenders for each program ensures your borrowers access the best terms available.

**Key Terms**
- **FHA-approved mortgagee**: A lender approved by FHA to originate FHA-insured loans.
- **MIP**: Mortgage Insurance Premium — FHA's insurance charge paid by borrowers.
- **VA entitlement**: A veteran's ability to use the VA loan guarantee benefit.

**Practical Checklist**
- [ ] Identify FHA, VA, and USDA-approved lenders in your service area
- [ ] Build a referral guide matching borrower profiles to the right program
- [ ] Review HUD's approved mortgagee list for local lenders
- [ ] Learn VA eligibility requirements for veterans in your network
- [ ] Develop a homebuyer counseling curriculum covering all three programs
$BODY$, 1, 9, 'approved'
FROM modules m JOIN certifications c ON m.certification_id = c.id
WHERE c.cert_number = 25 AND m.sort_order = 1
ON CONFLICT DO NOTHING;

INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status)
SELECT m.id, 'Native Housing Lending: HUD Indian Home Loan Guarantee Programs', 'native-housing-hud-indian-home-loan-guarantee',
$BODY$## HUD Section 184 & 184-A: Native Housing Lending Programs

The HUD Section 184 Indian Home Loan Guarantee Program is one of the most important and underutilized government mortgage programs in the United States. It was created specifically to address barriers to conventional mortgage lending in tribal communities — and it is growing rapidly.

**What is Section 184?**
Section 184 provides a federal guarantee for mortgage loans made to Native American, Alaska Native, and Native Hawaiian (through Section 184-A) households. The guarantee enables approved lenders to offer mortgages on tribal trust land, restricted allotments, and other Native-owned land — areas where conventional title insurance and mortgage underwriting have historically been unavailable.

**How Section 184 Works**
Approved lenders originate Section 184 loans, and HUD guarantees a portion in case of default. Key features: 2.25% down payment for loans over $50,000. Competitive interest rates. Loans available for purchase, construction, rehabilitation, and refinance. Available to federally recognized tribal members and their families, Alaska Natives, and members of certain state-recognized tribes.

**Becoming a Section 184 Lender**
Lenders must be approved by HUD's Section 184 program. Most are conventional mortgage lenders. CDFIs and Native CDFIs can apply for Section 184 approval, making this an important program for organizations serving Native communities.

**Section 184-A: Native Hawaiian Housing**
Section 184-A provides similar guarantees for loans on Hawaiian home lands and to eligible Native Hawaiian families. Administered through the Office of Native Hawaiian Relations within HUD.

**Building Native Housing Finance Capacity**
Organizations serving tribal communities should: (1) build relationships with Section 184-approved lenders, (2) develop homebuyer education programs that explain Section 184 benefits, (3) connect tribal members with housing counseling agencies, and (4) advocate for tribal land title solutions that enable more mortgage activity.

**Key Terms**
- **Trust land**: Land held in trust by the federal government for Native tribes or individuals.
- **Section 184**: HUD's Indian Home Loan Guarantee program for Native communities.
- **Section 184-A**: HUD's Native Hawaiian Housing Loan Guarantee program.

**Practical Checklist**
- [ ] Identify Section 184-approved lenders serving your region
- [ ] Review HUD's list of eligible tribal lands and entities for Section 184
- [ ] Develop a homebuyer education curriculum for tribal members
- [ ] Connect with your state's HUD-approved housing counseling agencies
- [ ] Research tribal CDFI programs that provide homeownership support
$BODY$, 2, 9, 'approved'
FROM modules m JOIN certifications c ON m.certification_id = c.id
WHERE c.cert_number = 25 AND m.sort_order = 1
ON CONFLICT DO NOTHING;



INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
SELECT id, 'FHA, VA, USDA Mortgage & Native Housing Assessment', 75, 45, 'approved' FROM certifications WHERE cert_number = 25
ON CONFLICT DO NOTHING;


WITH qid AS (
  SELECT q.id AS quiz_id FROM quizzes q JOIN certifications c ON q.certification_id = c.id
  WHERE c.cert_number = 25 AND q.title = 'FHA, VA, USDA Mortgage & Native Housing Assessment')
INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order)
SELECT qid.quiz_id, v.question_text, v.options::jsonb, v.correct_option_id, v.explanation, v.sort_order
FROM qid CROSS JOIN (VALUES
  ('FHA mortgage insurance is administered by which agency?', '[{"id":"a","text":"USDA Rural Development"},{"id":"b","text":"Department of Veterans Affairs"},{"id":"c","text":"HUD Federal Housing Administration"},{"id":"d","text":"Fannie Mae"}]', 'c', 'The Federal Housing Administration (FHA) is a division of HUD that insures mortgage loans made by approved private lenders.', 1),
  ('What is the minimum down payment for FHA Title II loans with a credit score of 580 or higher?', '[{"id":"a","text":"0%"},{"id":"b","text":"3.5%"},{"id":"c","text":"5%"},{"id":"d","text":"10%"}]', 'b', 'FHA requires a 3.5% down payment for borrowers with credit scores of 580 or higher — one of the lowest down payment requirements among conventional mortgage programs.', 2),
  ('VA loans are available to which group?', '[{"id":"a","text":"All low-income borrowers in rural areas"},{"id":"b","text":"Veterans, service members, and eligible surviving spouses"},{"id":"c","text":"Native American borrowers only"},{"id":"d","text":"First-time homebuyers nationwide"}]', 'b', 'VA mortgage guarantees are available to eligible veterans, active-duty service members, and qualifying surviving spouses as a benefit of military service.', 3),
  ('What is the primary purpose of HUD Section 184?', '[{"id":"a","text":"To insure multifamily housing loans"},{"id":"b","text":"To provide mortgage guarantees for loans on tribal trust land and to Native borrowers"},{"id":"c","text":"To finance rural multifamily development"},{"id":"d","text":"To guarantee farm operating loans"}]', 'b', 'HUD Section 184 was created specifically to address barriers to mortgage lending in tribal communities, providing guarantees for loans to Native American and Alaska Native borrowers.', 4),
  ('Which mortgage program requires NO down payment and NO private mortgage insurance?', '[{"id":"a","text":"FHA Title II"},{"id":"b","text":"USDA Section 502 Guaranteed"},{"id":"c","text":"VA Loan Guarantee"},{"id":"d","text":"Fannie Mae HomeReady"}]', 'c', 'VA loans require no down payment and no private mortgage insurance — the most favorable terms available to eligible borrowers.', 5),
  ('To originate FHA-insured mortgages, a lender must:', '[{"id":"a","text":"Have CDFI certification"},{"id":"b","text":"Be an FHA-approved mortgagee with a net worth of at least $1 million"},{"id":"c","text":"Be a state-chartered bank"},{"id":"d","text":"Register with NMLS only"}]', 'b', 'FHA approval requires institutional accreditation, minimum net worth ($1 million for supervised lenders), a quality control plan, and compliance with HUD handbook requirements.', 6),
  ('Section 184-A serves which population?', '[{"id":"a","text":"Alaska Native communities"},{"id":"b","text":"Native Hawaiian families"},{"id":"c","text":"American Indian tribal members in the continental U.S."},{"id":"d","text":"All indigenous peoples in the United States"}]', 'b', 'Section 184-A specifically serves Native Hawaiian families, providing mortgage guarantees for loans on Hawaiian home lands — a parallel program to Section 184.', 7),
  ('What is a key reason conventional mortgage lending has historically been limited on tribal trust land?', '[{"id":"a","text":"Tribal members have low credit scores"},{"id":"b","text":"Title insurance and conventional mortgage underwriting cannot apply to trust land"},{"id":"c","text":"USDA prohibits mortgage lending in tribal areas"},{"id":"d","text":"There is no demand for homeownership in tribal communities"}]', 'b', 'Tribal trust land cannot be foreclosed on through conventional processes, and title insurance is difficult or impossible to obtain, making conventional mortgage lending impractical without a federal guarantee.', 8),
  ('A rural housing counseling agency wants to help veteran borrowers in a rural area find the best mortgage terms. Which program combination should they explore first?', '[{"id":"a","text":"FHA and Fannie Mae"},{"id":"b","text":"VA Loan Guarantee and USDA Section 502 Guaranteed"},{"id":"c","text":"USDA B&I and REAP"},{"id":"d","text":"HUD Section 184 and SBA Microloan"}]', 'b', 'Veterans living in eligible rural areas may qualify for both VA and USDA Section 502 programs. The VA typically offers better terms (no down payment, no MIP), but USDA can be an alternative for veterans who don''t use VA benefits.', 9),
  ('Which of the following is a key first step for a community organization serving tribal members who want to buy homes?', '[{"id":"a","text":"Obtain a state lending license"},{"id":"b","text":"Identify Section 184-approved lenders and build homebuyer education capacity"},{"id":"c","text":"Apply to become a Ginnie Mae issuer"},{"id":"d","text":"Apply for an FSA guarantee"}]', 'b', 'Building relationships with Section 184-approved lenders and developing homebuyer education programming are the most actionable first steps for organizations serving tribal homebuyers.', 10)
) AS v(question_text, options, correct_option_id, explanation, sort_order)
ON CONFLICT DO NOTHING;
