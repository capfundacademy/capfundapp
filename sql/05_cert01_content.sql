-- ============================================================
-- Cap Fund Academy — Cert 1 Full Content
-- File: 05_cert01_content.sql
-- Idempotent: ON CONFLICT DO NOTHING
-- Run after: 04_cert_seeds.sql
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

-- Get or verify cert 1 exists
SELECT id INTO cert_id FROM certifications WHERE cert_number = 1;
IF cert_id IS NULL THEN
  RAISE EXCEPTION 'Cert 1 not found — run 04_cert_seeds.sql first';
END IF;

-- Update learning outcomes
UPDATE certifications SET
  learning_outcomes = ARRAY[
    'Define microfinance, microenterprise, MDO, microlender, RMRF, and TA as used in federal rural capital programs',
    'Explain why microfinance exists and how it differs from traditional banking for rural borrowers',
    'Distinguish client-centered from institution-centered lending practices',
    'Identify over-lending, high-cost, repayment mismatch, and weak borrower preparation risks',
    'Conduct a structured borrower readiness interview',
    'Design a basic 30-day technical assistance plan for a microborrower',
    'Apply the seven client protection principles to a loan scenario'
  ],
  status = 'approved'
WHERE id = cert_id;

-- ============================================================
-- MODULE 1: The Microfinance Landscape
-- ============================================================
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'The Microfinance Landscape',
  'Establish the foundational vocabulary, institutional context, and regulatory framework for microfinance and rural capital access programs.',
  1, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod1_id FROM modules WHERE certification_id = cert_id AND sort_order = 1;

-- Lesson 1.1
INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod1_id,
  'What Is Microfinance and Why Does It Exist?',
  'what-is-microfinance',
  E'## What Is Microfinance?\n\nMicrofinance is the provision of small financial services — loans, savings, insurance, and technical assistance — to individuals and businesses that are excluded from or underserved by traditional financial institutions. In the context of the United States rural economy, microfinance most commonly takes the form of microloans: business loans of $50,000 or less made to microenterprises located in rural areas.\n\nThe term "microfinance" is often used interchangeably with "microlending" or "microcredit," though technically microfinance is the broader category. Microlending refers specifically to the loan function. For purposes of this certification, we use both terms, but our primary focus is on the USDA Rural Microentrepreneur Assistance Program (RMAP) framework.\n\n## Why Does Microfinance Exist?\n\nTraditional banks exist to serve creditworthy borrowers with sufficient collateral, established credit history, and loan requests large enough to justify the bank''s origination costs. A community bank that spends $3,000 to underwrite a loan needs to make that cost worthwhile — which means small loans are economically unattractive to conventional lenders.\n\nThis creates a structural gap. Rural entrepreneurs who need $5,000 to buy equipment, $15,000 to purchase inventory, or $30,000 to cover startup costs are invisible to the traditional credit market. They may have:\n\n- No formal credit history or thin credit files\n- Insufficient collateral for bank underwriting standards\n- Business models that are informal or pre-revenue\n- Geographic isolation from bank branches\n- Distrust of financial institutions based on historical exclusion\n\nMicrofinance organizations (also called Microenterprise Development Organizations, or MDOs) exist specifically to fill this gap. They accept higher risk, provide smaller loans, and pair lending with technical assistance (TA) to improve borrower outcomes.\n\n## The Regulatory Definition of Microenterprise\n\nUnder 7 CFR 4280 (the federal rule governing RMAP), a **microenterprise** is:\n\n1. A sole proprietorship located in a rural area, OR\n2. A business entity located in a rural area with not more than 10 full-time-equivalent employees\n\nAll microenterprises assisted under RMAP must be located in **rural areas** as defined by USDA — any area of a state not in a city or town with a population greater than 50,000 inhabitants.\n\nA **microentrepreneur** is an owner and operator (or prospective owner/operator) of a microenterprise who is unable to obtain sufficient training, technical assistance, or credit other than through the RMAP program.\n\nA **microborrower** is a microentrepreneur who has received a loan from a microlender under RMAP.\n\n## Nonprofit and For-Profit Models\n\nIn the U.S., most microlenders are nonprofit organizations. This is because:\n\n- Federal programs like RMAP are restricted to nonprofit MDOs, Indian tribes, and public institutions of higher education\n- Nonprofit status aligns with the mission-driven nature of serving excluded borrowers\n- Tax-exempt status allows MDOs to accept grants and donations to subsidize below-market lending\n\nFor-profit microlenders do exist in the U.S. market (some online lenders offer micro-sized loans), but they typically charge higher interest rates and are not eligible for USDA RMAP funding.\n\n## The USDA RMAP Context\n\nThe Rural Microentrepreneur Assistance Program (RMAP), administered by USDA Rural Development under CFDA 10.870, is the primary federal program for capitalized rural microlending. It provides:\n\n- **Direct loans** to microlenders to capitalize a Rural Microloan Revolving Fund (RMRF)\n- **Technical assistance grants** to microlenders to provide TA and training to microborrowers\n- **TA-only grants** to MDOs that have other capital sources for lending\n\nUnder RMAP, microloans are capped at **$50,000** with a maximum term of **10 years** and a fixed interest rate. The microlender — not USDA — makes the actual loan to the microborrower.\n\n## Comparison to Traditional Banking\n\n| Factor | Traditional Bank | RMAP Microlender |\n|--------|-----------------|------------------|\n| Loan minimum | Often $50,000+ | No minimum |\n| Loan maximum | Unlimited | $50,000 |\n| Underwriting | Credit score, collateral, income | Capacity, character, business viability |\n| TA requirement | None | Required by regulation |\n| Eligible borrowers | Creditworthy with history | Underserved, excluded, rural |\n| Funding source | Deposits, capital markets | USDA RMAP loan + non-federal match |\n| Mission | Profit for shareholders | Mission-driven community development |\n\n## Key Terms Glossary\n\n**MDO** — Microenterprise Development Organization. The eligible applicant for RMAP funds.\n\n**RMRF** — Rural Microloan Revolving Fund. The exclusive interest-bearing account from which microloans are made.\n\n**LLRF** — Loan Loss Reserve Fund. An interest-bearing account maintained by the microlender equal to at least 5% of the total amount owed to USDA, used to cover delinquencies.\n\n**TA** — Technical Assistance. Training, business planning, financial coaching, and support services provided to microborrowers.\n\n**RMAP** — Rural Microentrepreneur Assistance Program. The USDA Rural Development program under 7 CFR 4280.\n\n**CFR** — Code of Federal Regulations. The binding federal rulebook. RMAP rules are in 7 CFR Part 4280, Subpart I.',
  'Microfinance fills the gap left by traditional banks for rural entrepreneurs. Learn the definitions, regulatory framework, and why the USDA RMAP program exists.',
  18, 1, 'approved')
ON CONFLICT DO NOTHING;

-- Lesson 1.2
INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod1_id,
  'Understanding Microenterprise Development Organizations',
  'understanding-mdos',
  E'## What Is an MDO?\n\nA Microenterprise Development Organization (MDO) is the entity that applies for RMAP funds and, if approved, serves as the microlender or TA provider in a rural community. Under 7 CFR 4280, an MDO must be one of the following:\n\n1. **A nonprofit entity** — A corporation or organization organized under state law as a nonprofit, with evidence that at least 51% of the persons who control the organization are U.S. citizens\n2. **A Federally-recognized Indian tribe** — Where the tribe certifies that no MDO serves the tribe and no RMAP exists under the jurisdiction of the Indian tribe\n3. **A public institution of higher education** — A state college, community college, or university that is publicly supported\n\nPrivate for-profit companies, individuals, and state or local governments are NOT eligible to apply as MDOs.\n\n## What Does an MDO Do?\n\nAn MDO does one or more of the following for the benefit of rural microentrepreneurs:\n\n1. **Provides training and technical assistance** — Business planning, financial literacy, marketing, bookkeeping, permit assistance, credit building\n2. **Makes microloans or facilitates access to capital** — Direct lending from an RMRF, or referrals and connections to capital sources\n3. **Demonstrates a record of delivering** (or an effective plan to develop) these services\n\nThe key regulatory phrase is "for the benefit of rural microentrepreneurs." An MDO''s work must be oriented toward rural borrowers and businesses, not urban ones.\n\n## Types of MDOs in the RMAP Ecosystem\n\nMDOs come in several organizational forms:\n\n**Community Development Financial Institutions (CDFIs)** — CDFIs are specialized financial institutions certified by the CDFI Fund (U.S. Treasury) to provide credit, capital, and financial services to underserved communities. Many CDFIs apply for RMAP as MDOs. CDFIs may also access CDFI Fund grants, New Markets Tax Credits, and bank CRA investments in addition to RMAP.\n\n**Small Business Development Centers (SBDCs) and SCORE chapters** — Some of these TA-focused organizations apply as TA-only MDOs. They do not make loans but provide intensive business counseling.\n\n**Community Action Agencies** — Nonprofit anti-poverty organizations that often provide microenterprise TA as part of a broader community services portfolio.\n\n**Reentry and Workforce Organizations** — Organizations like Life House Reentry that serve returning citizens and other economically excluded populations in rural areas may apply as MDOs to provide both TA and lending.\n\n**Community Colleges and Land-Grant Universities** — Some higher education institutions apply as MDOs to provide TA and training, particularly through extension programs.\n\n## MDO Pathways Under RMAP\n\nNot all MDOs are the same. RMAP recognizes several distinct applicant pathways based on experience:\n\n| Pathway | Description | Application Sections |\n|---------|-------------|---------------------|\n| Experienced Microlender (>3 years) + loan + TA grant | MDO with 3+ years of microlending history, requesting both RMRF capitalization and TA grant | Pages 2, 3, 4, 5 of checklist |\n| Experienced Microlender + loan only | Same as above but no TA grant requested | Pages 2, 3, 4, 5 |\n| Less-experienced Microlender (<3 years) + loan + TA | MDO with under 3 years of microlending, requesting both | Pages 2, 3, 6 |\n| Less-experienced Microlender + loan only | Under 3 years, loan only | Pages 2, 3, 6 |\n| TA-only | MDO with other capital sources, requesting only TA grant | Pages 2, 3, 7 |\n| Reapplication | Existing MDO after 5 years of participation | Page 8 |\n\nThis pathway distinction is critical for scoring. An experienced microlender is scored under 4280.316(b), while a less-experienced applicant is scored under 4280.316(c), and a TA-only applicant under 4280.316(d). Different criteria, different maximum points.\n\n## The Role of the Loan Loss Reserve Fund\n\nEvery RMAP microlender must establish and maintain a **Loan Loss Reserve Fund (LLRF)** — an interest-bearing deposit account equal to at least **5% of the total amount owed to USDA** under the program.\n\nThe LLRF exists to absorb delinquency losses. When a microborrower defaults and the RMRF falls short, the LLRF covers the gap. This protects USDA''s position as first-lien holder on the RMRF.\n\nIf an MDO cannot maintain the required 5% LLRF balance, it has violated a condition of the RMAP agreement and may face suspension or acceleration of the outstanding USDA loan.\n\n## Cost Share Requirement\n\nAll RMAP microlenders must meet a **federal cost share requirement**: the federal share of each microborrower''s project cost may not exceed 75%. The remaining 25% must come from non-federal sources.\n\nMDOs can satisfy this in two ways:\n\n1. **Microborrower project level** — Each individual microloan is capped at 75% of the project cost; the borrower finds 25% from non-federal sources (cash, grants, in-kind)\n2. **RMRF level** — The RMRF itself is capitalized with no more than 75% USDA funds and at least 25% non-federal funds, allowing the microlender to make 100% project financing loans\n\nUnderstanding this cost share requirement is essential for structuring your RMRF and communicating with potential microborrowers about what they need to bring to a loan.',
  'MDOs are the eligible applicants for RMAP. Understand who qualifies, what they do, and the different RMAP pathways based on lending experience.',
  16, 2, 'approved')
ON CONFLICT DO NOTHING;

-- ============================================================
-- MODULE 2: Client Protection Principles
-- ============================================================
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Client Protection Principles',
  'Apply the seven client protection standards to microfinance practice and distinguish responsible lending from harmful loan structures.',
  2, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod2_id FROM modules WHERE certification_id = cert_id AND sort_order = 2;

-- Lesson 2.1
INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod2_id,
  'Borrower-Centered Lending',
  'borrower-centered-lending',
  E'## What Is Borrower-Centered Lending?\n\nBorrower-centered lending puts the financial wellbeing of the borrower at the center of every loan decision. It stands in contrast to institution-centered lending, where loan volume, interest income, or grant reporting requirements drive lending decisions regardless of whether individual borrowers are truly ready or suitable.\n\nIn a borrower-centered model, the question before every loan decision is: **"Is this loan in this borrower''s best interest at this time?"** That question sounds simple. In practice, answering it honestly requires discipline, training, and a clear framework.\n\n## The Seven Client Protection Principles\n\nThe Smart Campaign (now part of the Social Performance Task Force) established seven Client Protection Principles widely adopted in responsible microfinance:\n\n### 1. Appropriate Product Design\nLoan products must be designed for the actual needs and repayment capacity of rural microentrepreneurs. A 10-year term may make sense for equipment that generates income over 10 years. A 6-month term for a seasonal business with 90-day revenue cycles would be harmful.\n\n**In practice:** Match loan size, term, and repayment schedule to the borrower''s projected cash flow. Avoid one-size-fits-all structures.\n\n### 2. Avoidance of Over-Indebtedness\nOver-lending — giving a borrower more credit than they can repay — is one of the most common and harmful practices in microfinance. A loan that cannot be repaid destroys the borrower''s credit, business, and financial stability.\n\n**In practice:** Conduct a genuine repayment capacity analysis. Ask to see bank statements, tax returns, or cash flow projections. If the borrower cannot demonstrate how they will repay the loan, do not make the loan.\n\n### 3. Transparency\nBorrowers must understand the full cost of their loan before signing: the interest rate (and whether it is APR or flat rate), all fees, insurance requirements, prepayment penalties if any, and what happens if they miss a payment.\n\n**In practice:** Provide a written loan summary in plain language before closing. Review it verbally with the borrower. RMAP microloans must carry a fixed interest rate — make sure borrowers understand this and what it means.\n\n### 4. Responsible Pricing\nInterest rates and fees must be set at a level that covers the cost of the lending program without exploiting the borrower''s lack of alternatives. A 40% APR on a $5,000 loan to a rural entrepreneur who cannot access any other credit is harmful, even if it is technically legal.\n\n**In practice:** RMAP microloans have a fixed rate set by USDA for the microlender''s cost of capital. The spread you charge microborrowers above your cost of funds should reflect your actual operating costs, not a profit maximization strategy.\n\n### 5. Fair and Respectful Treatment\nBorrowers must be treated with dignity and without discrimination. Collections practices must be ethical. Staff must not use harassment, threats, or public shaming to collect delinquent loans.\n\n**In practice:** Document your collections policy. Train staff on fair debt collection standards. Establish a formal complaint mechanism.\n\n### 6. Privacy of Client Data\nBorrower financial information is confidential. MDOs must have written data privacy policies and must not share borrower data without explicit consent, except as required by law or the USDA agreement.\n\n**In practice:** Secure borrower files physically and digitally. Obtain written consent before sharing any borrower data with partners, researchers, or the public.\n\n### 7. Mechanisms for Complaint Resolution\nBorrowers must have a clear, accessible, and responsive way to raise concerns or complaints. This is not optional under responsible microfinance standards.\n\n**In practice:** Post your complaint process in your office, loan documents, and website. Log complaints and track resolution. Review complaint patterns annually for systemic issues.\n\n## Institution-Centered vs. Borrower-Centered: A Comparison\n\n| Practice | Institution-Centered | Borrower-Centered |\n|----------|---------------------|-------------------|\n| Loan approval | Volume-driven | Capacity-driven |\n| Product design | Standardized | Tailored to cash flow |\n| Pricing transparency | Fine print | Plain language, upfront |\n| Collections | Aggressive, pressure-based | Structured, dignified |\n| Over-lending | Common | Actively prevented |\n| Complaint process | Absent or inaccessible | Clear, logged, reviewed |\n\n## What "Credit Elsewhere" Means\n\nRMAP requires that microborrowers be unable to obtain sufficient credit elsewhere. This is not just a formality — it is a statutory requirement under the authorizing legislation.\n\nIn practice, "credit elsewhere" means:\n- The borrower has been denied by a conventional lender, OR\n- The terms available from a conventional lender (e.g., 24% APR on a credit card) are not reasonable for the proposed use, OR\n- No conventional lender is willing to make a loan in the amount and on the terms needed\n\nMDOs typically document this with a credit elsewhere certification, a denial letter from another lender, or an explanation of why conventional credit is unavailable or unsuitable.',
  'The seven client protection principles form the ethical foundation of responsible microfinance. Learn how to apply them to every loan decision.',
  20, 1, 'approved')
ON CONFLICT DO NOTHING;

-- Lesson 2.2
INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod2_id,
  'Responsible Loan Terms and Borrower Education',
  'responsible-loan-terms',
  E'## RMAP Loan Term Requirements\n\nUnder 7 CFR 4280, RMAP microloans must meet specific structural requirements:\n\n- **Maximum loan amount:** $50,000 per microborrower\n- **Maximum term:** 10 years\n- **Interest rate:** Fixed rate (set at origination, does not change)\n- **Insurance:** Borrowers may be required to maintain insurance on collateral\n- **Credit elsewhere:** Borrowers must certify they cannot obtain sufficient credit elsewhere\n\nWithin these outer limits, microlenders have flexibility to design loan terms that match the borrower''s business needs.\n\n## Fixed vs. Variable Rate\n\nRMAP microloans must carry a **fixed interest rate**. This is a borrower protection — rural microentrepreneurs on thin margins cannot absorb rate volatility.\n\nThe microlender''s cost of funds from USDA is a fixed rate. The spread the microlender charges above that rate should reflect:\n- Loan origination and servicing costs\n- Expected loss reserve contribution\n- TA program costs (if the TA is bundled with lending)\n- A reasonable administrative margin\n\n**Example:** If USDA charges the microlender 3% on the RMRF, and the microlender''s operating costs add 4%, the microborrower rate might be 6-7% — below market for high-risk borrowers, but sustainable for the program.\n\n## Matching Term to Business Purpose\n\nLoan term should align with the economic life of the asset being financed and the borrower''s projected repayment capacity.\n\n| Business Use | Suggested Term Range |\n|-------------|---------------------|\n| Working capital (inventory, supplies) | 12-36 months |\n| Equipment with 5-7 year useful life | 48-84 months |\n| Leasehold improvements | 36-60 months |\n| Business acquisition | 60-120 months |\n| Mixed use (equipment + working capital) | Blended, or split facilities |\n\nAvoid giving a 10-year loan for a 2-year asset. The borrower will be paying for something that no longer exists.\n\n## Fee Transparency Requirements\n\nEvery fee must be disclosed in writing before loan closing. Common fees in microlending include:\n\n- **Origination fee** (typically 1-3% of loan amount)\n- **Application fee** (often nominal or waived for small loans)\n- **Late payment fee** (must be disclosed and reasonable)\n- **Prepayment provisions** (RMAP microloans generally should allow prepayment without penalty)\n\nAll fees must be included in the **Annual Percentage Rate (APR)** calculation, not hidden as separate charges.\n\n## Borrower Education Before Closing\n\nResponsible microlending requires that borrowers understand what they are signing. This is both an ethical requirement and, under RMAP, a practical necessity — borrowers who understand their loans are less likely to default.\n\nA minimum pre-closing borrower education session should cover:\n\n1. **Loan amount and purpose** — What the money is for and what it cannot be used for\n2. **Interest rate and total interest cost** — Both rate and total dollar amount over the life of the loan\n3. **Monthly payment amount and due date** — Exact amount, exact date\n4. **Grace period if any** — How many days before a payment is considered late\n5. **Late fee** — Exact amount or percentage\n6. **What happens at default** — Acceleration, collections process, impact on credit\n7. **Collateral** — What is pledged, what happens if the loan defaults\n8. **Insurance requirements** — What must be maintained\n9. **LLRF contribution** — If the microlender passes any LLRF cost to the borrower, this must be disclosed\n10. **Complaint process** — How the borrower can raise concerns\n\n## Ineligible Uses Under RMAP\n\nNot every business use is eligible for RMAP microloan funds. The following are prohibited:\n\n- **Construction or rehabilitation of residential housing** (even if used for a business)\n- **Lines of credit** (RMAP microloans must be for a defined purpose, not revolving credit)\n- **Agricultural production** (unless the borrower meets specific microenterprise criteria)\n- **Insider transactions** (loans to officers, directors, or family members of the MDO)\n- **Religious activities** (when the primary purpose is religious instruction or worship)\n- **Gambling or illegal activities**\n- **Businesses operating outside the eligible rural area**\n\nDeveloping a written ineligible use screen and training your loan officers to apply it consistently is essential for maintaining RMAP compliance.',
  'RMAP microloans must follow specific structural requirements. Learn how to set responsible loan terms and conduct pre-closing borrower education.',
  15, 2, 'approved')
ON CONFLICT DO NOTHING;

-- ============================================================
-- MODULE 3: Borrower Readiness Assessment
-- ============================================================
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Borrower Readiness Assessment',
  'Build the skills to evaluate business and financial readiness, conduct a structured borrower interview, and connect borrowers to technical assistance.',
  3, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod3_id FROM modules WHERE certification_id = cert_id AND sort_order = 3;

-- Lesson 3.1
INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod3_id,
  'Evaluating Business and Financial Readiness',
  'evaluating-borrower-readiness',
  E'## Why Readiness Assessment Matters\n\nThe single biggest driver of microloan default is not bad faith — it is unpreparedness. Borrowers who receive loans before their business is ready to generate sufficient revenue cannot repay, regardless of their intentions. A thorough readiness assessment protects both the borrower and the lending program.\n\nFor RMAP compliance, borrower readiness assessment also supports your scoring on organizational quality (4280.316(a)(4)) and your TA programming outcomes.\n\n## The Five Dimensions of Borrower Readiness\n\n### 1. Business Purpose Clarity\nThe borrower must clearly articulate:\n- What business they are in or starting\n- What the loan proceeds will specifically purchase or fund\n- How that investment will increase revenue or reduce costs\n- When the investment will start generating a return\n\n**Red flag:** A borrower who cannot clearly state what they will do with the money, or whose stated use does not match their business model.\n\n### 2. Repayment Capacity\nRepayment capacity is the borrower''s demonstrated or projected ability to make monthly loan payments from business cash flow. Assess:\n\n- **Existing businesses:** Review 2-3 years of bank statements, tax returns, or financial statements. Calculate average monthly net income after expenses. The loan payment should not exceed 30-40% of average monthly net income.\n- **Startups:** Build a 12-month cash flow projection together with the borrower. Be conservative — use 60-70% of projected revenue in year one. Apply a stress test: what happens if revenue is 30% lower than projected?\n\n**The Debt Service Coverage Ratio (DSCR):** A simple but powerful tool.\n\nDSCR = Net Operating Income ÷ Total Annual Debt Service\n\nA DSCR of 1.0 means income barely covers debt payments. Responsible microlenders typically require DSCR ≥ 1.25 for established businesses and ≥ 1.10 for startups with strong TA support.\n\n### 3. Existing Records\nWhile rural microentrepreneurs often lack perfect records, the existence of *some* financial documentation signals business seriousness:\n\n- Bank statements (business or personal if no business account)\n- Most recent tax return(s)\n- Sales receipts, invoices, or cash register records\n- Any existing contracts or purchase orders\n- Utility bills or lease in the business name\n\n**Coaching opportunity:** A borrower with no records is often not loan-ready today but could be within 60-90 days with TA support to set up basic bookkeeping.\n\n### 4. Personal Credit Context\nRMAP does not require a minimum credit score — this is by design, because many rural microentrepreneurs have thin or damaged credit files. However, personal credit still tells a story:\n\n- **Thin file (no credit history):** Not a disqualifier. Develop a plan to build credit alongside the loan.\n- **Derogatory marks from medical or emergency expenses:** Distinguish between financial hardship and financial irresponsibility.\n- **Pattern of missed obligations:** Investigate. Is this a cash flow timing issue or a willingness-to-pay issue?\n- **Active collections or judgments:** May indicate competing claims on future cash flow. Document and assess impact on repayment capacity.\n\n### 5. Business Legality and Permits\nThe business must be legal and properly registered:\n\n- State business registration (LLC, sole proprietorship, corporation)\n- Federal EIN (Employer Identification Number) from IRS\n- Local business license where required\n- Professional licenses relevant to the business type\n- Zoning compliance for the business location\n\n**RMAP note:** Loans to businesses without required licenses or permits create compliance risk for the microlender.\n\n## The Borrower Readiness Interview\n\nA structured readiness interview typically runs 45-90 minutes and covers:\n\n1. **Business description** — What do you do? Who are your customers? How long have you been operating?\n2. **Use of funds** — Walk me through exactly how you will use this loan.\n3. **Revenue and expenses** — What does a typical month look like? What are your biggest expenses?\n4. **Repayment plan** — How will you make the monthly payment? From what source?\n5. **Credit history** — Have you borrowed money before? How did that go? Any past challenges?\n6. **TA needs** — What part of running your business feels hardest right now?\n7. **Goals** — Where do you want this business to be in 2 years? In 5 years?\n\nDocument every interview. Your notes become part of the loan file and support your RMAP compliance documentation.',
  'Learn the five dimensions of borrower readiness and how to conduct a structured interview that protects both the borrower and your lending program.',
  22, 1, 'approved')
ON CONFLICT DO NOTHING;

-- Lesson 3.2
INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod3_id,
  'The Microenterprise Technical Assistance Connection',
  'ta-connection',
  E'## Why TA Is Not Optional\n\nUnder RMAP, technical assistance is not a nice-to-have feature — it is a regulatory requirement. Every microlender must provide TA and training to their microborrowers. Every TA-only MDO must demonstrate a meaningful TA program. And for the experienced microlender scoring pathway, your TA outcomes contribute directly to your application score.\n\nBeyond compliance, the research is clear: microloans paired with TA have significantly lower default rates than loans made without support. The TA-loan combination is the model that works.\n\n## What TA Looks Like in Microfinance\n\nTechnical assistance in the RMAP context encompasses:\n\n**Business planning support** — Helping borrowers develop a written business plan or at minimum a one-page business summary that covers the product/service, target market, pricing, and financial projections.\n\n**Financial literacy training** — Separating business and personal finances, understanding a profit and loss statement, managing cash flow, filing taxes, building business credit.\n\n**Marketing and customer acquisition** — Social media basics, pricing strategy, word-of-mouth referral systems, simple marketing plans.\n\n**Bookkeeping systems** — Setting up QuickBooks, Wave, or a simple spreadsheet. Creating habits around recording income and expenses daily.\n\n**Permit and compliance assistance** — Helping borrowers identify required licenses, navigate state registration, apply for an EIN.\n\n**Peer learning groups** — Connecting borrowers with each other to share challenges and solutions. Peer networks reduce isolation and improve accountability.\n\n## The 30-Day TA Plan\n\nFor loan-ready borrowers, a 30-day pre-closing TA plan might include:\n\n| Week | Activity | Deliverable |\n|------|----------|-------------|\n| Week 1 | Business plan review and gap fill | Updated 1-page business summary |\n| Week 2 | Cash flow projection build | 12-month cash flow spreadsheet |\n| Week 3 | Bookkeeping system setup | Active bookkeeping account |\n| Week 4 | Financial literacy session | Completed financial literacy checklist |\n\nFor borrowers who are not yet loan-ready, a 60-90 day TA plan might include:\n\n- Months 1-2: Business concept validation, market research, permit acquisition\n- Month 3: Financial projections, bookkeeping setup, loan application preparation\n- Loan decision at end of month 3 based on demonstrated progress\n\n## Referral Partnerships\n\nNo MDO can provide every type of TA internally. Build a referral network that includes:\n\n- **Small Business Development Centers (SBDCs)** — Free business counseling funded by SBA\n- **SCORE** — Volunteer mentoring by retired executives\n- **Women''s Business Centers (WBCs)** — SBA-funded centers focused on women entrepreneurs\n- **State cooperative extension offices** — Agricultural and rural business TA\n- **Community colleges** — Business courses, certificate programs, entrepreneurship support\n- **Legal aid organizations** — For contract review, entity formation, and employment law questions\n\nDocument every referral. Your RMAP reporting should track outcomes from referral TA, not just in-house TA.\n\n## Measuring TA Outcomes\n\nRMAP scoring for experienced microlenders includes an assessment of TA outcomes. Track:\n\n- **Number of TA sessions delivered** (group and individual)\n- **Businesses assisted** (unduplicated count)\n- **Businesses that subsequently received a microloan** (TA-to-loan conversion)\n- **Business survival rate** (% of TA clients still operating at 12 months)\n- **Jobs created or retained**\n- **Revenue growth** (self-reported at follow-up)\n- **Client satisfaction** (survey score)\n\nStart tracking these metrics from day one, even before your first RMAP application. Three years of outcome data is exactly what experienced microlender scoring requires.',
  'Technical assistance is both a regulatory requirement and the single most effective way to reduce microloan default. Learn how to build, connect, and measure TA programs.',
  18, 2, 'approved')
ON CONFLICT DO NOTHING;

-- ============================================================
-- MODULE 4: Microenterprise TA Basics
-- ============================================================
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Microenterprise TA Basics',
  'Build practical TA skills: business planning, pricing, bookkeeping, and customer acquisition for rural microentrepreneurs.',
  4, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod4_id FROM modules WHERE certification_id = cert_id AND sort_order = 4;

-- Lesson 4.1
INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod4_id,
  'Business Planning, Pricing, and Bookkeeping for Microborrowers',
  'business-planning-pricing-bookkeeping',
  E'## The One-Page Business Plan\n\nMost rural microentrepreneurs do not need a 40-page MBA-style business plan. They need a clear, honest one-page document that answers the questions a loan officer and a microborrower both need answered.\n\nA one-page business plan template for microborrowers:\n\n**Business Name and Owner:** ________________________________\n\n**What we sell:** (product or service, in plain language)\n\n**Who buys it:** (target customer, their location, why they buy)\n\n**How we find customers:** (word of mouth, social media, local market, etc.)\n\n**What we charge:** (price per unit/service, any packages or discounts)\n\n**Monthly revenue goal:** $ _______ (how many units at what price)\n\n**Monthly expenses:** Rent $ _____ | Supplies $ _____ | Labor $ _____ | Other $ _____\n\n**Monthly net income goal:** $ _______ (revenue minus expenses)\n\n**Loan use:** (exactly what will the loan buy, in how many units, from where)\n\n**How the loan will increase revenue or reduce costs:** ________________\n\n**How monthly loan payment will be covered:** ________________\n\n## Pricing for Profitability\n\nOne of the most common errors rural microentrepreneurs make is underpricing. They price based on what they think customers will pay rather than what they need to charge to be profitable.\n\n**The Break-Even Price Formula:**\n\nBreak-Even Price = (Fixed Costs ÷ Units Sold) + Variable Cost Per Unit\n\n**Example:**\nA microborrower makes handmade candles. Monthly fixed costs (rent of studio, insurance) = $400. Variable costs per candle (wax, wick, jar, label) = $3.50. She sells 150 candles per month.\n\nBreak-even price = ($400 ÷ 150) + $3.50 = $2.67 + $3.50 = **$6.17 per candle**\n\nIf she sells at $6, she loses money. If she sells at $12, she makes $5.83 gross margin per candle × 150 = **$874.50 monthly gross profit** before her own labor.\n\nHelp every microborrower run this calculation for their primary product or service. Many are shocked to discover they are operating at a loss.\n\n## Cash vs. Accrual Accounting Basics\n\nFor most rural microentrepreneurs, **cash basis accounting** is appropriate and simpler:\n\n- **Revenue is recorded when cash is received**\n- **Expenses are recorded when cash is paid**\n- Matches how the borrower actually experiences money\n\n**Accrual basis** records revenue when earned and expenses when incurred, regardless of cash timing. This is required for larger businesses and provides a more accurate long-term picture, but is more complex.\n\nFor RMAP loan underwriting, cash basis bank statements and tax returns are the most useful documents. For growing microbusinesses with invoicing and accounts receivable, helping them understand accrual concepts will serve them as they scale.\n\n**Key concepts to teach every microborrower:**\n1. Separate business and personal bank accounts (non-negotiable)\n2. Log every transaction (income and expense) weekly at minimum\n3. Reconcile monthly (compare records to bank statement)\n4. Save for taxes quarterly (25-30% of net profit for self-employment tax)\n\n## Permit and License Checklist\n\nHelp microborrowers complete this checklist before loan closing:\n\n☐ State business registration (LLC, sole proprietorship filing)\n☐ Federal EIN from IRS (free at IRS.gov, takes 10 minutes)\n☐ Local business license (city/county — fees vary)\n☐ Industry-specific license (contractor, food handler, cosmetologist, etc.)\n☐ Seller''s permit (if selling taxable goods — required in most states)\n☐ Zoning confirmation (business activity is allowed at the business address)\n☐ Home occupation permit (if operating from a residence)\n☐ USDA value-added or cottage food license (if producing food products)\n\nA borrower who is operating without required permits is creating liability for both themselves and your lending program.\n\n## Simple Customer Acquisition for Rural Microenterprises\n\nMarketing does not need to be expensive or complex for rural microenterprises. Focus on the highest-ROI channels:\n\n**Word of mouth and referrals** — The highest conversion rate and zero cost. Teach borrowers to actively ask satisfied customers for referrals. A simple "If you know someone who could use [service], please send them my way" is enough.\n\n**Facebook and Nextdoor** — Free to use, highly local, effective for rural service businesses. Help borrowers set up a business page and post 2-3 times per week.\n\n**Local markets and events** — Farmers markets, community fairs, pop-up events. Great for product-based businesses with low customer acquisition cost.\n\n**Flyers at community anchors** — Laundromats, churches, feed stores, community centers. Still effective in rural areas where foot traffic concentrates.\n\n**Google Business Profile** — Free listing that puts the business on Google Maps and search. Essential for any business that serves walk-in or call-in customers. Setup takes 30 minutes.\n\nFor each microborrower, help them identify their **one primary customer acquisition channel** and build a simple 30-day plan around it. Complexity is the enemy of execution for new entrepreneurs.',
  'Practical TA tools every microloan officer should know: one-page business plans, break-even pricing, basic bookkeeping, and zero-cost customer acquisition.',
  20, 1, 'approved')
ON CONFLICT DO NOTHING;

-- ============================================================
-- QUIZ for Cert 1
-- ============================================================
INSERT INTO quizzes (id, certification_id, title, passing_score, status)
VALUES (uuid_generate_v4(), cert_id,
  'Microfinance Foundations Knowledge Check',
  80, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO quiz_id FROM quizzes WHERE certification_id = cert_id;

-- 20 Quiz Questions
INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order)
VALUES
(quiz_id,
  'What is the maximum loan amount for an RMAP microloan under 7 CFR 4280?',
  '[{"id":"a","text":"$25,000"},{"id":"b","text":"$50,000"},{"id":"c","text":"$100,000"},{"id":"d","text":"$250,000"}]',
  'b',
  'Under 7 CFR 4280, RMAP microloans are capped at $50,000 per microborrower with a maximum term of 10 years and a fixed interest rate.',
  1),

(quiz_id,
  'Which of the following entity types is eligible to apply for RMAP as an MDO?',
  '[{"id":"a","text":"A private for-profit corporation"},{"id":"b","text":"A state government agency"},{"id":"c","text":"A Federally-recognized Indian tribe"},{"id":"d","text":"An individual entrepreneur"}]',
  'c',
  'Eligible MDOs under RMAP are: nonprofit entities, Federally-recognized Indian tribes, and public institutions of higher education. Private for-profit entities, individuals, and state agencies are not eligible.',
  2),

(quiz_id,
  'What does the acronym RMRF stand for in the RMAP framework?',
  '[{"id":"a","text":"Rural Microenterprise Revolving Finance"},{"id":"b","text":"Rural Microloan Revolving Fund"},{"id":"c","text":"Regulated Microfinance Reserve Fund"},{"id":"d","text":"Rural Microlender Reporting Framework"}]',
  'b',
  'RMRF stands for Rural Microloan Revolving Fund — the exclusive interest-bearing account from which a microlender makes microloans under RMAP.',
  3),

(quiz_id,
  'What is the minimum Loan Loss Reserve Fund (LLRF) balance a microlender must maintain?',
  '[{"id":"a","text":"2% of total outstanding microloans"},{"id":"b","text":"3% of the total amount owed to USDA"},{"id":"c","text":"5% of the total amount owed to USDA"},{"id":"d","text":"10% of the RMRF balance"}]',
  'c',
  'The LLRF must be maintained at not less than 5% of the total amount owed by the microlender to USDA under the program.',
  4),

(quiz_id,
  'Which of the following is NOT an eligible use of RMAP microloan funds?',
  '[{"id":"a","text":"Purchase of business equipment"},{"id":"b","text":"Working capital for inventory"},{"id":"c","text":"A revolving line of credit for a rural retailer"},{"id":"d","text":"Leasehold improvements to a business space"}]',
  'c',
  'RMAP microloans must be for a defined purpose — revolving lines of credit are ineligible. Other ineligible uses include residential construction, insider transactions, religious activities, and gambling.',
  5),

(quiz_id,
  'What does "credit elsewhere" mean in the context of RMAP microloan eligibility?',
  '[{"id":"a","text":"The borrower has applied for credit in multiple states"},{"id":"b","text":"The borrower is unable to obtain sufficient credit from conventional sources on reasonable terms"},{"id":"c","text":"The borrower has active credit accounts at other lenders"},{"id":"d","text":"The microlender has funded loans in other geographic areas"}]',
  'b',
  '"Credit elsewhere" means the borrower cannot obtain sufficient training, technical assistance, or credit other than through RMAP. This is a statutory requirement for microborrower eligibility.',
  6),

(quiz_id,
  'Under the RMAP federal cost share requirement, the federal share of each microborrower project may not exceed:',
  '[{"id":"a","text":"50%"},{"id":"b","text":"65%"},{"id":"c","text":"75%"},{"id":"d","text":"90%"}]',
  'c',
  'The federal share of the eligible project cost may not exceed 75%. The remaining 25% must come from non-federal sources, either at the project level or the RMRF level.',
  7),

(quiz_id,
  'Which Client Protection Principle specifically addresses the risk of borrowers taking on more debt than they can repay?',
  '[{"id":"a","text":"Appropriate Product Design"},{"id":"b","text":"Responsible Pricing"},{"id":"c","text":"Avoidance of Over-Indebtedness"},{"id":"d","text":"Transparency"}]',
  'c',
  'The Avoidance of Over-Indebtedness principle directly addresses the risk of lending more than a borrower can repay. It requires genuine repayment capacity analysis before loan approval.',
  8),

(quiz_id,
  'A Debt Service Coverage Ratio (DSCR) of 1.0 means:',
  '[{"id":"a","text":"The business generates twice its debt payment"},{"id":"b","text":"Income barely covers debt payments with no cushion"},{"id":"c","text":"The business has no existing debt"},{"id":"d","text":"The loan is 100% collateralized"}]',
  'b',
  'DSCR = Net Operating Income ÷ Total Annual Debt Service. A ratio of 1.0 means income exactly equals debt payments — there is no cushion for unexpected expenses. Responsible microlenders typically require DSCR ≥ 1.25.',
  9),

(quiz_id,
  'How is RMAP administered by USDA?',
  '[{"id":"a","text":"Through SBA district offices"},{"id":"b","text":"Through USDA Rural Development under CFDA 10.870"},{"id":"c","text":"Through the CDFI Fund at U.S. Treasury"},{"id":"d","text":"Through state economic development agencies"}]',
  'b',
  'RMAP is administered by USDA Rural Development under CFDA 10.870, not the SBA or Treasury CDFI Fund.',
  10),

(quiz_id,
  'Under RMAP, a "rural area" is defined as:',
  '[{"id":"a","text":"Any county with fewer than 10,000 residents"},{"id":"b","text":"Any area outside a city with more than 50,000 inhabitants per the latest decennial census"},{"id":"c","text":"Any area designated as rural by the state governor"},{"id":"d","text":"Any area more than 50 miles from a major metropolitan area"}]',
  'b',
  'Under 7 CFR 4280, rural area means any area of a state not in a city or town that has a population of more than 50,000 inhabitants according to the latest applicable decennial census.',
  11),

(quiz_id,
  'Which of the following best describes "institution-centered" lending?',
  '[{"id":"a","text":"Loan decisions driven by what is best for the borrower''s long-term financial health"},{"id":"b","text":"Loan decisions driven by volume targets, fee income, or reporting requirements regardless of borrower readiness"},{"id":"c","text":"Lending that prioritizes institutional borrowers over individual entrepreneurs"},{"id":"d","text":"Lending from a federally chartered institution such as a bank or credit union"}]',
  'b',
  'Institution-centered lending prioritizes the lender''s metrics (loan volume, fee income, grant requirements) over the borrower''s actual readiness and long-term wellbeing — the opposite of the client protection standard.',
  12),

(quiz_id,
  'A microborrower break-even price calculation shows the product must sell for at least $8 to cover costs. The borrower is currently charging $6. What is the most appropriate TA response?',
  '[{"id":"a","text":"Approve the loan anyway — the borrower will figure out pricing"},{"id":"b","text":"Decline the loan without explanation"},{"id":"c","text":"Work with the borrower to revise pricing before loan closing; do not close until pricing is sustainable"},{"id":"d","text":"Reduce the loan amount to compensate for the pricing gap"}]',
  'c',
  'The correct response is to address the pricing problem through TA before loan closing. A loan to a borrower with unsustainable pricing is a loan set up to default. Reducing the loan amount does not fix the underlying business problem.',
  13),

(quiz_id,
  'What is the maximum term for an RMAP microloan?',
  '[{"id":"a","text":"5 years"},{"id":"b","text":"7 years"},{"id":"c","text":"10 years"},{"id":"d","text":"15 years"}]',
  'c',
  'RMAP microloans have a maximum term of 10 years. The interest rate must be fixed at origination.',
  14),

(quiz_id,
  'A microenterprise under RMAP regulations must have:',
  '[{"id":"a","text":"Fewer than 25 full-time equivalent employees"},{"id":"b","text":"No more than 10 full-time equivalent employees and be located in a rural area"},{"id":"c","text":"Annual revenue of less than $1 million"},{"id":"d","text":"Been in operation for at least one year"}]',
  'b',
  'A microenterprise under 7 CFR 4280 is a business with no more than 10 FTE employees located in a rural area. There is no minimum revenue or operational history requirement in the definition.',
  15),

(quiz_id,
  'Which of the following is the most reliable early indicator that a microborrower may default?',
  '[{"id":"a","text":"The borrower has never had a bank account"},{"id":"b","text":"The borrower cannot clearly explain how they will make the monthly payment"},{"id":"c","text":"The borrower has a thin credit file"},{"id":"d","text":"The business has been operating for less than one year"}]',
  'b',
  'Inability to articulate a repayment plan — where the money will come from, in what amount, on what timeline — is the most reliable early warning sign. Thin credit files and new businesses are common in microfinance and do not by themselves predict default.',
  16),

(quiz_id,
  'What is the primary purpose of a Loan Loss Reserve Fund (LLRF)?',
  '[{"id":"a","text":"To fund TA programs for microborrowers"},{"id":"b","text":"To cover shortages in the RMRF caused by microloan delinquencies or losses"},{"id":"c","text":"To reimburse USDA for administrative costs"},{"id":"d","text":"To capitalize a second RMRF"}]',
  'b',
  'The LLRF is specifically designed to cover shortages in the RMRF caused by delinquencies or losses on microloans, protecting USDA''s position as first-lien holder.',
  17),

(quiz_id,
  'Which free resource should every microborrower set up to appear in local Google search and Maps results?',
  '[{"id":"a","text":"A paid Google Ads account"},{"id":"b","text":"A Google Business Profile"},{"id":"c","text":"A Google Analytics property"},{"id":"d","text":"A YouTube channel"}]',
  'b',
  'A Google Business Profile is a free listing that puts a business on Google Maps and local search results. It is one of the highest-ROI zero-cost marketing actions for rural microenterprises.',
  18),

(quiz_id,
  'Under the RMRF-level cost share option, the RMRF must be capitalized with:',
  '[{"id":"a","text":"100% USDA funds"},{"id":"b","text":"At least 50% non-federal funds"},{"id":"c","text":"No more than 75% USDA funds and at least 25% non-federal funds"},{"id":"d","text":"Equal shares of federal and non-federal funds"}]',
  'c',
  'Under the RMRF-level option (7 CFR 4280.311(d)(2)), the RMRF must be capitalized with no more than 75% USDA loan funds and not less than 25% non-federal funds.',
  19),

(quiz_id,
  'Which of the following Client Protection Principles requires that borrowers have a clear, accessible way to raise concerns?',
  '[{"id":"a","text":"Privacy of Client Data"},{"id":"b","text":"Fair and Respectful Treatment"},{"id":"c","text":"Mechanisms for Complaint Resolution"},{"id":"d","text":"Transparency"}]',
  'c',
  'The Mechanisms for Complaint Resolution principle requires MDOs to establish and communicate a clear, accessible complaint process. This is logged, tracked, and reviewed annually.',
  20)
ON CONFLICT DO NOTHING;

END $$;
