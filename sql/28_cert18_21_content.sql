-- ============================================================
-- Cap Fund Academy — Cert 18–21 Content
-- Cert 18: Government Lending Models Foundations
-- Cert 19: Lending Entity, Licensing & Compliance Readiness
-- Cert 20: SBA 7(a) & Small Business Lending
-- Cert 21: SBA Microloan, CDC/504 & SBIC
-- Run after: 27_cert_seeds_18_35.sql
-- ============================================================

DO $block$
DECLARE
  v_cert18 uuid; v_cert19 uuid; v_cert20 uuid; v_cert21 uuid;
  v_mod uuid; v_quiz uuid;
BEGIN

-- ═══════════════════════════════════════════════════════════════
-- CERT 18: Government Lending Models Foundations
-- ═══════════════════════════════════════════════════════════════
SELECT id INTO v_cert18 FROM certifications WHERE cert_number = 18;

-- Module 1
INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert18, 'What It Means to Become a Lender', 1, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert18 AND sort_order = 1; END IF;

INSERT INTO lessons (module_id, title, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'The Decision to Lend: Responsibilities and Realities',
$$## The Decision to Lend: Responsibilities and Realities

Becoming a lender is not a transaction — it is a transformation. When your organization decides to lend capital to borrowers, you take on legal, regulatory, ethical, and fiduciary responsibilities that define how you operate for years to come.

**What Does It Mean to Be a Lender?**

A lender originates, documents, disburses, services, and collects on loans. Depending on the program, you may also be required to provide technical assistance, track borrower outcomes, maintain portfolio records, submit annual reports to a federal agency, and undergo third-party audits.

Most community-based organizations that become lenders start with one of three motivations: (1) they want to fill a capital gap in their community, (2) they are applying for a government program that requires them to relend funds, or (3) they are building a self-sustaining revenue stream to support their mission.

**Lender vs. Intermediary vs. Relender**

Not all lending organizations do the same thing. An *approved lender* originates loans under its own underwriting authority, often with a government guarantee behind each loan (such as an SBA 7(a) lender or USDA Business & Industry approved lender). An *intermediary* receives a pool of capital from a government agency and relends it to end borrowers — this is the model used in USDA RMAP, IRP, and SBA Microloan programs. A *relender* is similar to an intermediary but may operate under a revolving fund structure where repaid principal is re-lent to new borrowers.

Understanding which model your organization is pursuing is the first step. Each model has different eligibility requirements, federal oversight expectations, and compliance burdens.

**Key Terms**
- **Loan origination**: The process of evaluating, approving, and closing a loan.
- **Underwriting authority**: The legal right to make lending decisions based on your own policies.
- **Revolving loan fund (RLF)**: A fund where repaid principal is recycled into new loans.
- **Intermediary**: An organization that borrows from a government program and relends to end borrowers.

**Practical Checklist**
- [ ] Identify your organization's primary lending motivation
- [ ] Determine whether you will be an approved lender, intermediary, or relender
- [ ] Review your organizational bylaws to confirm lending authority
- [ ] Assess your board's appetite for credit risk
- [ ] Identify a legal advisor with nonprofit lending experience
$$, 1, 8, 'approved'),

(v_mod, 'The Five Major Government Lending Models',
$$## The Five Major Government Lending Models

The United States government supports community and commercial lending through five distinct structural models. Understanding each model helps you determine where your organization fits and which programs are accessible to you without becoming a federally regulated bank.

**Model 1: Government-Guaranteed Loans**
In this model, a private or community lender originates a loan, and a federal agency guarantees a portion of the principal in case of default. The SBA 7(a) program, USDA Business & Industry Guaranteed Loans, and USDA OneRD programs all use this structure. You must be an approved lender to originate these loans, which requires meeting agency-specific eligibility standards and going through a formal lender approval process.

**Model 2: Relending Programs (Intermediary Model)**
The federal government provides a pool of loan funds to an intermediary (often a nonprofit or CDFI), which then relends those funds to eligible end borrowers at a spread. USDA RMAP, USDA IRP, and the SBA Microloan program all use this model. The intermediary receives capital at a subsidized rate and charges borrowers a higher rate, using the spread to cover operating costs.

**Model 3: Revolving Loan Funds**
An RLF is a fund established with an initial grant or loan, where repaid principal is continuously recycled to make new loans. EDA RLFs, EPA Brownfields RLFs, and CDBG RLFs all use this structure. The fund grows over time as principal is repaid, and the organization managing it is responsible for long-term sustainability, compliance, and reporting.

**Model 4: Secondary Market Programs**
Organizations that originate mortgage loans can sell those loans to secondary market entities (Ginnie Mae, Fannie Mae, Freddie Mac) to recapitalize and originate new loans. This model requires becoming an approved issuer or seller/servicer, a rigorous process suited to mortgage companies and housing finance agencies.

**Model 5: Investment Fund Models (CDFI, NMTC, SBIC)**
Some organizations capitalize a loan fund or investment vehicle using equity or quasi-equity sources — CDFI awards, New Markets Tax Credit allocations, SBIC licenses, or Program-Related Investments from foundations. These funds can make loans, investments, or guarantees and are governed by their own regulatory frameworks.

**Key Terms**
- **Guarantee**: A federal promise to cover a defined percentage of loan losses.
- **Spread**: The difference between the rate an intermediary pays and the rate it charges borrowers.
- **Capitalization**: The process of raising initial funds to operate a loan fund.
- **Secondary market**: The market where originated loans are bought and sold.

**Practical Checklist**
- [ ] Map your target program to one of the five lending models
- [ ] Research whether your organization type is eligible for that model
- [ ] Identify the federal agency or program that governs the model
- [ ] Determine what approval or certification is required to participate
$$, 2, 9, 'approved')
ON CONFLICT DO NOTHING;

-- Module 2
INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert18, 'Choosing the Right Lender Model for Your Organization', 2, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert18 AND sort_order = 2; END IF;

INSERT INTO lessons (module_id, title, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'Matching Your Mission to a Lending Program',
$$## Matching Your Mission to a Lending Program

Not every lending program is the right fit for every organization. Before pursuing lender approval, applying for intermediary status, or establishing a revolving loan fund, you must honestly assess your organization's mission, capacity, financial health, and community relationships.

**The Four Matching Criteria**

1. **Mission alignment**: Does the program's target borrower match the population you serve? USDA RMAP serves rural microentrepreneurs. SBA Microloan targets underserved small businesses. EDA RLFs focus on job creation and economic adjustment. A mismatch between your mission and the program's mandate creates friction in every application and every loan you make.

2. **Organizational capacity**: Do you have trained staff who can underwrite loans, manage a portfolio, and comply with federal reporting requirements? Every government lending program will audit your capacity. If you cannot demonstrate experience or a credible plan to build it, you will not be approved.

3. **Financial soundness**: Government programs want to see that your organization is financially stable. You need audited financial statements, a clean audit history, reserves, and a sustainable operating model. Organizations in financial distress cannot access most government lending programs.

4. **Community relationships**: Lending programs expect you to have existing relationships with the borrowers you plan to serve. Your network, referral sources, and community credibility matter as much as your organizational profile.

**The Decision Matrix**

When evaluating lending programs, ask: (1) Who are my target borrowers? (2) What dollar range do I want to lend? (3) Am I willing to provide technical assistance? (4) Can I sustain the compliance burden? (5) Do I have or can I build the required organizational history?

**Key Terms**
- **Mission alignment**: The degree to which a program's goals match your organization's purpose.
- **Organizational capacity**: Your staff, systems, and processes for lending operations.
- **Financial soundness**: Demonstrated stability through audited financials and reserves.

**Practical Checklist**
- [ ] Write a one-paragraph description of your target borrower
- [ ] Identify the average loan size you want to make
- [ ] List your current staff with lending or financial management experience
- [ ] Pull your last two years of audited financial statements
- [ ] List three to five community organizations that could refer borrowers to you
$$, 1, 7, 'approved')
ON CONFLICT DO NOTHING;

-- Quiz for Cert 18
INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert18, 'Government Lending Models Foundations Assessment', 75, 40, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert18; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, sort_order) VALUES
(v_quiz, 'Which lending model involves an organization receiving federal funds and relending them to end borrowers at a spread?', 'Government-guaranteed model', 'Intermediary relending model', 'Secondary market model', 'Investment fund model', 'B', 'The intermediary relending model is used by programs like USDA RMAP, IRP, and the SBA Microloan program, where the intermediary receives subsidized capital and relends it to eligible borrowers.', 1),
(v_quiz, 'What is a revolving loan fund?', 'A fund that grows by charging high interest rates', 'A fund where repaid principal is recycled into new loans', 'A fund backed by a federal guarantee on every loan', 'A fund that only makes loans to banks', 'B', 'An RLF recycles repaid principal into new loans, allowing a single initial capitalization to support multiple loan generations over time.', 2),
(v_quiz, 'Which of the following is NOT one of the four matching criteria for selecting a lending program?', 'Mission alignment', 'Political connections', 'Organizational capacity', 'Financial soundness', 'B', 'The four matching criteria are mission alignment, organizational capacity, financial soundness, and community relationships. Political connections are not a program criterion.', 3),
(v_quiz, 'A nonprofit wants to make $10,000–$50,000 microloans to rural entrepreneurs using USDA funds. Which lending model fits best?', 'SBA 7(a) approved lender', 'Ginnie Mae issuer', 'USDA RMAP intermediary relender', 'CDFI Bond Guarantee participant', 'C', 'USDA RMAP is specifically designed for microentrepreneurs in rural areas, and the program uses the intermediary relending model where nonprofits borrow USDA funds and relend them to eligible borrowers.', 4),
(v_quiz, 'What is the primary purpose of a government loan guarantee?', 'To eliminate the lender''s need to underwrite loans', 'To cover a defined percentage of losses in case of borrower default', 'To provide free capital to nonprofit lenders', 'To allow lenders to charge unlimited interest rates', 'B', 'A government guarantee promises to cover a percentage of the outstanding loan principal if the borrower defaults, reducing the lender''s loss exposure.', 5),
(v_quiz, 'Which organization type is most likely to become a Ginnie Mae issuer?', 'A rural nonprofit microlender', 'A mortgage company or housing finance agency', 'A community development corporation with no lending history', 'A tribal government without an existing loan fund', 'B', 'Ginnie Mae issuer approval is designed for mortgage companies and housing finance agencies that originate government-insured mortgage loans at scale.', 6),
(v_quiz, 'What does "spread" mean in the context of an intermediary relending program?', 'The geographic area a lender serves', 'The difference between the rate the intermediary pays and the rate it charges borrowers', 'The amount of collateral required per loan', 'The percentage of loans that go into default', 'B', 'The spread is the interest rate margin — the intermediary borrows at a subsidized rate and charges borrowers a higher rate, using the difference to cover operating costs.', 7),
(v_quiz, 'Before applying for any government lending program, which document is most critical to have ready?', 'A press release announcing the program', 'Two years of audited financial statements', 'A list of prospective borrowers', 'A signed letter from a U.S. Senator', 'B', 'Government lending programs universally require audited financial statements to assess your organization''s financial soundness and management quality.', 8),
(v_quiz, 'The New Markets Tax Credit (NMTC) program is associated with which lending model?', 'Government-guaranteed loans', 'Intermediary relending', 'Investment fund models (CDFI/NMTC/SBIC)', 'Secondary market programs', 'C', 'NMTC is an investment fund model where Community Development Entities receive tax credit allocations and deploy them as loans or equity to qualifying businesses in low-income communities.', 9),
(v_quiz, 'Which of the following best describes an "approved lender" in government lending?', 'An organization that has received a federal grant', 'An organization with authority to originate loans under a government guarantee program', 'A lender that only serves approved geographic areas', 'An intermediary that has passed a federal audit', 'B', 'An approved lender has received agency authorization to originate loans under a government guarantee program (like SBA 7(a) or USDA B&I), and makes its own underwriting decisions.', 10)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- CERT 19: Lending Entity, Licensing & Compliance Readiness
-- ═══════════════════════════════════════════════════════════════
SELECT id INTO v_cert19 FROM certifications WHERE cert_number = 19;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert19, 'Choosing the Right Lending Entity Structure', 1, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert19 AND sort_order = 1; END IF;

INSERT INTO lessons (module_id, title, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'Nonprofit Loan Fund vs. CDFI vs. For-Profit Lender',
$$## Nonprofit Loan Fund vs. CDFI vs. For-Profit Lender

The entity structure you choose will determine which programs you can access, what regulations apply, and how investors and grantors perceive your organization. Most community lenders start as nonprofit loan funds, but the choice has long-term consequences worth understanding before you begin.

**Option 1: Nonprofit Loan Fund**
A 501(c)(3) or 501(c)(4) organization that operates a loan fund alongside its mission activities. This is the most common structure for first-time government program intermediaries. Advantages: existing donor relationships, grant eligibility, public trust, and IRS tax exemption. Disadvantages: limited ability to retain earnings, no equity investors, governance restrictions, and potential IRS scrutiny if lending becomes a primary activity.

**Option 2: CDFI-Certified Entity**
A nonprofit or for-profit entity certified by the CDFI Fund as a Community Development Financial Institution. CDFI certification unlocks access to CDFI Program financial and technical assistance awards, Capital Magnet Fund, New Markets Tax Credit allocations, and Bank Enterprise Award funding. To become a CDFI, you must demonstrate that your primary mission is community development lending, that you serve a defined target market, and that you provide development services alongside capital.

**Option 3: For-Profit Lending Entity (LLC or Corporation)**
Suitable for organizations that want to raise equity capital, partner with investors, or scale beyond grant-dependent operations. For-profit lenders can access SBA 7(a) lender approval and some USDA programs, but generally cannot receive grants or tax-exempt bond financing. They are subject to more state lending regulations and CFPB oversight.

**Option 4: CDC, SBIC, or Utility Intermediary**
Certified Development Companies (CDCs) administer SBA 504 loans. Small Business Investment Companies (SBICs) are licensed by SBA to make equity and debt investments. Utility intermediaries can administer USDA REDLG loans. Each requires a specific federal licensing process.

**Key Terms**
- **CDFI**: Community Development Financial Institution — a specialized entity certified by the U.S. Treasury.
- **CDC**: Certified Development Company — a nonprofit licensed by SBA to administer 504 loans.
- **SBIC**: Small Business Investment Company — an SBA-licensed investment fund.

**Practical Checklist**
- [ ] Review your current entity structure and bylaws
- [ ] Determine whether your primary activities are charitable/developmental
- [ ] Research CDFI certification eligibility requirements
- [ ] Consult a nonprofit attorney before changing entity structure
- [ ] Identify which programs you are targeting and their entity requirements
$$, 1, 8, 'approved'),

(v_mod, 'State Lending Licenses, NMLS, and SAM.gov Registration',
$$## State Lending Licenses, NMLS, and SAM.gov Registration

Before you make a single loan, you must understand whether your organization needs a state lending license, how to register with the Nationwide Multistate Licensing System (NMLS), and whether you need to be registered in SAM.gov to receive federal funds.

**State Lending Licenses**
Most states regulate commercial lending, particularly for loans to consumers or small businesses. Nonprofit organizations often receive exemptions from state money lender licensing requirements, but this varies significantly by state. Before beginning lending operations, consult with a licensed attorney in your state to determine whether you need a Commercial Finance Company license, a Small Loan Company license, or other authorization.

Note: USDA RMAP intermediaries are generally exempt from state lending license requirements because they are operating under a federal program, but this does not mean state law is irrelevant. Always verify with state counsel.

**NMLS (Nationwide Multistate Licensing System)**
NMLS registration is required for organizations that originate residential mortgage loans. If you plan to make mortgage loans — even if they are government-backed — you will need NMLS registration at the entity level and potentially licensing for individual loan originators. For organizations focused on commercial microloans and small business loans (not residential mortgages), NMLS is generally not required.

**SAM.gov Registration**
SAM.gov (System for Award Management) is the federal database for organizations that want to receive federal grants, contracts, or direct payments. If you are applying for USDA RMAP, RBDG, EDA RLF, or any other federal program, you must be registered in SAM.gov with an active and current record. Registration requires a CAGE code, DUNS number (now replaced by UEI), and up-to-date organizational information. SAM.gov registrations expire annually.

**Key Terms**
- **NMLS**: Nationwide Multistate Licensing System — the registration system for mortgage originators.
- **SAM.gov**: System for Award Management — required for all federal grant recipients.
- **UEI**: Unique Entity Identifier — replaced the DUNS number for SAM.gov registrations in 2022.

**Practical Checklist**
- [ ] Confirm state lending license requirements with a licensed attorney
- [ ] Check whether your state has a nonprofit lender exemption
- [ ] Register or update your SAM.gov record before any federal application deadline
- [ ] Confirm your UEI number is current and active
- [ ] If making mortgage loans, assess NMLS entity and individual licensing needs
$$, 2, 9, 'approved')
ON CONFLICT DO NOTHING;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert19, 'BSA, AML, OFAC, Fair Lending & Loan Committee Governance', 2, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert19 AND sort_order = 2; END IF;

INSERT INTO lessons (module_id, title, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'Bank Secrecy Act, Anti-Money Laundering & OFAC Screening',
$$## Bank Secrecy Act, Anti-Money Laundering & OFAC Screening

Every organization that handles loan proceeds must comply with federal anti-money laundering laws. Even nonprofit microlenders are subject to the Bank Secrecy Act (BSA), and failure to comply can result in civil penalties, criminal prosecution, and loss of program eligibility.

**Bank Secrecy Act (BSA)**
The BSA requires financial institutions to maintain records and file reports that help detect and prevent money laundering, tax evasion, and other financial crimes. Depending on your organization's structure and activities, you may be required to file Currency Transaction Reports (CTRs) for cash transactions over $10,000 and Suspicious Activity Reports (SARs) for transactions that raise red flags.

Nonprofit lenders making small business microloans are generally not "financial institutions" under the BSA definition, but if your organization is a bank, credit union, SBIC, or handles significant cash transactions, BSA obligations apply more directly. Regardless, developing internal monitoring practices consistent with BSA principles protects your organization.

**Anti-Money Laundering (AML) Program**
Best practice for any lending organization is to develop a written AML program that includes: (1) internal controls and policies, (2) designation of a compliance officer, (3) ongoing employee training, (4) independent testing of the program.

**OFAC Screening**
The Office of Foreign Assets Control (OFAC) administers U.S. economic sanctions. Before disbursing a loan to any individual or entity, you must screen the borrower against the OFAC Specially Designated Nationals (SDN) list. Most lending software includes automated OFAC screening. Manual screening is free through the OFAC website but requires process discipline to do consistently.

**Key Terms**
- **CTR**: Currency Transaction Report — required for cash transactions over $10,000.
- **SAR**: Suspicious Activity Report — required when a transaction raises red flags.
- **SDN List**: OFAC's list of prohibited parties — no U.S. person may do business with them.

**Practical Checklist**
- [ ] Consult legal counsel on BSA applicability to your organization type
- [ ] Develop a written AML program with designated compliance officer
- [ ] Implement OFAC screening for every new borrower before disbursement
- [ ] Train all lending staff on BSA/AML responsibilities
- [ ] Maintain records of all screening and monitoring activities
$$, 1, 9, 'approved')
ON CONFLICT DO NOTHING;

-- Quiz for Cert 19
INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert19, 'Lending Entity, Licensing & Compliance Assessment', 80, 45, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert19; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, sort_order) VALUES
(v_quiz, 'Which federal registration is required for organizations that want to receive USDA grants or program loans?', 'NMLS', 'SAM.gov', 'IRS Form 1023', 'State lending license', 'B', 'SAM.gov (System for Award Management) registration is required for all organizations seeking federal grants, contracts, or direct payments, including USDA programs.', 1),
(v_quiz, 'A nonprofit is applying for USDA RMAP intermediary status. Does it need a state lending license?', 'Yes, always required', 'Depends on state law — a nonprofit lending exemption may apply', 'No, federal programs preempt all state requirements', 'Only if making loans over $50,000', 'B', 'Whether a state lending license is required depends on state law. Many states have nonprofit lender exemptions, but this must be verified with a licensed attorney in each state.', 2),
(v_quiz, 'What is the primary purpose of OFAC screening?', 'To verify a borrower''s credit score', 'To check that borrowers are not on the federal sanctions list', 'To confirm a borrower''s SAM.gov registration', 'To comply with state lending license requirements', 'B', 'OFAC screening checks borrowers against the Specially Designated Nationals list maintained by the Office of Foreign Assets Control, ensuring you do not do business with sanctioned parties.', 3),
(v_quiz, 'Which entity structure unlocks access to CDFI Fund awards, Capital Magnet Fund, and New Markets Tax Credit?', 'Any 501(c)(3) nonprofit', 'An organization certified as a CDFI by the U.S. Treasury', 'An SBA-approved lender', 'A Certified Development Company', 'B', 'CDFI certification by the U.S. Treasury CDFI Fund is required to access CDFI Program financial and technical assistance awards, Capital Magnet Fund, and NMTC allocations.', 4),
(v_quiz, 'What replaced the DUNS number for SAM.gov registrations?', 'EIN (Employer Identification Number)', 'UEI (Unique Entity Identifier)', 'CAGE code', 'NMLS number', 'B', 'In April 2022, the UEI (Unique Entity Identifier) replaced the DUNS number for all federal contracting and grant purposes in SAM.gov.', 5),
(v_quiz, 'A Certified Development Company (CDC) administers which SBA loan program?', 'SBA 7(a)', 'SBA Express', 'SBA 504', 'SBA Microloan', 'C', 'CDCs are nonprofit corporations licensed by SBA to administer the SBA 504 loan program, which provides long-term fixed-rate financing for real estate and major equipment.', 6),
(v_quiz, 'Which BSA report is required for cash transactions over $10,000?', 'Suspicious Activity Report (SAR)', 'Currency Transaction Report (CTR)', 'OFAC Screening Report', 'Annual AML Audit', 'B', 'The Currency Transaction Report (CTR) must be filed for cash transactions exceeding $10,000 in a single business day.', 7),
(v_quiz, 'An organization wants to make SBA 504 loans. What entity structure must it establish?', 'CDFI', 'SBIC', 'CDC (Certified Development Company)', 'A for-profit mortgage company', 'C', 'Only SBA-licensed Certified Development Companies (CDCs) can administer SBA 504 loans. CDCs must apply to SBA for authorization.', 8),
(v_quiz, 'What does a loan committee governance policy primarily address?', 'Marketing and borrower outreach', 'The process for approving, rejecting, and documenting loan decisions', 'How to file Currency Transaction Reports', 'State lending license renewal procedures', 'B', 'Loan committee governance policies define the composition, quorum, decision-making authority, conflict of interest rules, and documentation requirements for loan approval decisions.', 9),
(v_quiz, 'Which of the following is a required element of a written AML program?', 'A relationship with a commercial bank', 'An independent testing function and designated compliance officer', 'CDFI certification', 'A state money transmitter license', 'B', 'A strong written AML program includes internal controls, a designated compliance officer, ongoing employee training, and an independent testing function to verify the program''s effectiveness.', 10)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- CERT 20: SBA 7(a) & Small Business Lending
-- ═══════════════════════════════════════════════════════════════
SELECT id INTO v_cert20 FROM certifications WHERE cert_number = 20;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert20, 'The SBA 7(a) Lending Ecosystem', 1, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert20 AND sort_order = 1; END IF;

INSERT INTO lessons (module_id, title, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'SBA 7(a) Overview: Programs, Eligibility, and Lender Types',
$$## SBA 7(a) Overview: Programs, Eligibility, and Lender Types

The SBA 7(a) program is the U.S. Small Business Administration's primary loan guarantee program. It is the most flexible and widely used government small business lending tool in the country, with over $27 billion in annual loan volume. Understanding the full 7(a) ecosystem is essential for any lender working in small business capital access.

**The 7(a) Program Family**

The 7(a) program is not a single product — it is a family of guarantee products with different loan sizes, interest rates, uses of proceeds, and lender eligibility requirements:

- **Standard 7(a)**: Loans up to $5 million for most eligible business purposes. SBA guarantees up to 85% of loans up to $150,000 and 75% for larger amounts.
- **7(a) Small Loan**: Designed for loans of $350,000 or less, with a streamlined approval process.
- **SBA Express**: Lenders use their own underwriting guidelines. Approval within 36 hours. SBA guarantees 50%. Maximum $500,000.
- **Export Express**: For businesses needing export financing. 90% guarantee up to $500,000.
- **Export Working Capital Program (EWCP)**: Working capital for businesses with export sales. Up to $5 million.
- **International Trade Loan**: For businesses that compete against foreign imports or are expanding into export markets.
- **CAPLines**: Four types of revolving lines of credit for specific business purposes (seasonal, contract, builders, working capital).
- **7(a) Working Capital Pilot (WCP)**: A newer revolving credit product for businesses with $5–$150 million in annual revenue.
- **Community Advantage SBLC**: A licensed community-focused lender model designed to expand 7(a) access in underserved markets.

**Who Can Be an SBA 7(a) Lender?**
Banks, credit unions, and some CDFIs can apply for SBA lender approval. Community Advantage SBLCs are a special class of lender — nonprofits and mission-driven organizations with at least two years of lending experience can apply. This is the most accessible 7(a) lender pathway for community development organizations.

**SBA Eligibility Basics**
Borrowers must be: for-profit businesses, operate in the U.S., have invested equity, and be unable to obtain financing on reasonable terms through conventional channels. Certain business types are ineligible (real estate investment, gambling, pyramid sales, etc.).

**Key Terms**
- **Guarantee**: SBA's promise to cover a defined percentage of losses if the borrower defaults.
- **Community Advantage SBLC**: A mission-focused SBA 7(a) lender class for CDFIs and nonprofits.
- **CAPLine**: A revolving line of credit product within the 7(a) program family.

**Practical Checklist**
- [ ] Review the full SBA 7(a) program guide at sba.gov
- [ ] Identify which 7(a) product matches your target borrowers
- [ ] Determine if your organization could qualify as a Community Advantage SBLC
- [ ] Review SBA lender eligibility requirements for your entity type
- [ ] Identify two to three SBA-approved lenders in your area for partnership
$$, 1, 10, 'approved')
ON CONFLICT DO NOTHING;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert20, 'SBA Express, Export Programs & CAPLines', 2, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert20 AND sort_order = 2; END IF;

INSERT INTO lessons (module_id, title, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'Partnering with SBA Lenders: Strategy for Community Organizations',
$$## Partnering with SBA Lenders: Strategy for Community Organizations

Most community development organizations will not become SBA 7(a) lenders directly — the capital requirements, compliance burden, and operational demands are significant. However, building strong referral and co-lending relationships with existing SBA lenders is a high-value strategy that helps your borrowers access capital you cannot provide alone.

**The Referral Partnership Model**
The most common approach for CDFIs, nonprofits, and RLF operators is to build formal referral partnerships with SBA-approved banks and credit unions. When a borrower needs a loan larger than your fund can provide, or needs a product you don't offer, you refer them to an SBA lender — ideally with a warm introduction and a summary of their capacity.

In exchange, SBA lenders often refer borrowers who don't yet meet their credit standards to community lenders for pre-loan technical assistance, credit-building, or smaller bridge loans. This creates a two-way pipeline that benefits both organizations and serves more borrowers.

**The Community Advantage SBLC Pathway**
If your organization wants to originate 7(a) loans directly, the Community Advantage Small Business Lending Company (SBLC) license is the most accessible pathway. Requirements include: nonprofit or mission-focused entity, at least two years of business lending experience, a portfolio of at least ten loans, a strong underwriting process, and an application submitted to SBA.

Community Advantage SBLCs can make 7(a) loans up to $350,000 with SBA's 85% guarantee, enabling them to serve borrowers that conventional banks overlook.

**Packaging and Referral Best Practices**
When referring a borrower to an SBA lender: (1) prepare a one-page borrower summary with revenue, credit, purpose, and ask; (2) include a recommendation letter from your organization; (3) provide any technical assistance records or financial projections you've helped the borrower develop. This increases conversion rates and builds your reputation with SBA lenders.

**Key Terms**
- **Community Advantage SBLC**: A licensed SBA 7(a) lender specifically for nonprofits and CDFIs.
- **Packaging**: Preparing a borrower's loan file for submission to an SBA lender.
- **Referral pipeline**: A systematic relationship for directing qualified borrowers between organizations.

**Practical Checklist**
- [ ] Identify three to five SBA-approved lenders in your service area
- [ ] Develop a formal referral agreement template
- [ ] Create a one-page borrower summary format for referrals
- [ ] Research the Community Advantage SBLC application requirements
- [ ] Establish a tracking system for referred borrowers
$$, 1, 8, 'approved')
ON CONFLICT DO NOTHING;

-- Quiz for Cert 20
INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert20, 'SBA 7(a) & Small Business Lending Assessment', 75, 50, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert20; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, sort_order) VALUES
(v_quiz, 'What is the SBA guarantee percentage for a standard 7(a) loan over $150,000?', '85%', '75%', '90%', '50%', 'B', 'SBA guarantees up to 85% for loans up to $150,000 and 75% for loans above that threshold.', 1),
(v_quiz, 'Which SBA 7(a) product offers approval within 36 hours and a 50% guarantee?', 'Standard 7(a)', 'SBA Express', 'Export Express', 'CAPLine', 'B', 'SBA Express offers a 36-hour turnaround and a 50% guarantee, allowing lenders to use their own underwriting processes for loans up to $500,000.', 2),
(v_quiz, 'What is the maximum loan amount under the SBA 7(a) program?', '$2 million', '$3.5 million', '$5 million', '$10 million', 'C', 'The SBA 7(a) program has a maximum loan amount of $5 million.', 3),
(v_quiz, 'Which SBA lender type is specifically designed for nonprofits and CDFIs?', 'SBA Express lender', 'Community Advantage SBLC', 'Preferred Lender Program (PLP)', 'Certified Lender Program (CLP)', 'B', 'Community Advantage Small Business Lending Companies are a licensed class of SBA 7(a) lender specifically designed for nonprofits, CDFIs, and mission-driven organizations.', 4),
(v_quiz, 'What type of financing do CAPLines provide?', 'Long-term real estate mortgages', 'Revolving lines of credit for specific business purposes', 'Export credit insurance', 'Working capital for foreign buyers', 'B', 'CAPLines provide four types of revolving lines of credit for seasonal, contract, builder, and working capital needs.', 5),
(v_quiz, 'For SBA 7(a) eligibility, a borrower must demonstrate what regarding conventional financing?', 'They have never applied to a bank', 'They were unable to obtain financing on reasonable terms through conventional channels', 'They have a minimum credit score of 680', 'They are located in a rural area', 'B', 'SBA 7(a) eligibility requires that the borrower cannot obtain credit elsewhere on reasonable terms — the program is designed to fill gaps in conventional lending.', 6),
(v_quiz, 'The Export Working Capital Program (EWCP) is designed for:', 'Domestic manufacturers expanding facilities', 'Businesses that need working capital to support export sales', 'Importers seeking foreign buyer financing', 'Nonprofit organizations exporting services', 'B', 'EWCP provides revolving lines of credit for businesses with export sales, allowing them to access capital based on export purchase orders and receivables.', 7),
(v_quiz, 'What is the most common strategy for a CDFI that wants to connect borrowers to SBA 7(a) capital without becoming an SBA lender?', 'Apply for a state lending license', 'Build referral partnerships with SBA-approved lenders', 'Acquire an SBIC license', 'Apply directly to SBA for guarantee authority', 'B', 'Building referral partnerships with SBA-approved banks and credit unions is the most common and efficient strategy for CDFIs that want to leverage 7(a) capital for their borrowers.', 8),
(v_quiz, 'Which business types are generally INELIGIBLE for SBA 7(a) loans?', 'Manufacturing companies', 'Real estate investment firms and gambling businesses', 'Retail businesses and restaurants', 'Professional service firms', 'B', 'Certain industries are ineligible for SBA 7(a) loans, including real estate investment, gambling, pyramid sales, and businesses engaged in lending.', 9),
(v_quiz, 'A nonprofit organization with three years of small business lending experience wants to originate SBA 7(a) loans up to $350,000. What is the most appropriate pathway?', 'Apply for standard SBA lender approval', 'Apply for a Community Advantage SBLC license', 'Partner with a commercial bank as a loan packager', 'Apply for an SBIC license from SBA', 'B', 'The Community Advantage SBLC pathway requires nonprofit or mission-driven status, at least two years of lending experience, and is specifically designed for loans up to $350,000 in underserved markets.', 10)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- CERT 21: SBA Microloan, CDC/504 & SBIC
-- ═══════════════════════════════════════════════════════════════
SELECT id INTO v_cert21 FROM certifications WHERE cert_number = 21;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert21, 'The SBA Microloan Program: Intermediary Model', 1, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert21 AND sort_order = 1; END IF;

INSERT INTO lessons (module_id, title, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'SBA Microloan Program: How Intermediaries Work',
$$## SBA Microloan Program: How Intermediaries Work

The SBA Microloan program provides small loans — up to $50,000 — through nonprofit intermediary lenders. Unlike most SBA programs that guarantee loans made by banks, the Microloan program provides direct federal funds to intermediaries, who then relend those funds to eligible small businesses and nonprofit childcare centers.

**How the Program Works**
SBA makes direct loans to approved nonprofit intermediaries at interest rates below market rate (typically 1.00–1.25%). The intermediary then relends those funds to eligible end borrowers at rates that reflect the spread needed to sustain operations (typically 8–13%). The intermediary keeps the interest income to fund operations, and repaid principal revolves back into new loans.

**What Intermediaries Must Provide**
Every SBA Microloan intermediary is required to provide technical assistance (TA) and training to microloan borrowers. TA can include business planning, financial management, marketing, and loan readiness support. At least a portion of SBA funds must be used to provide TA — the program is built on the premise that capital alone is not enough for microentrepreneurs to succeed.

**Eligible Borrowers**
Loans can be made to for-profit small businesses and nonprofit childcare centers that need capital for working capital, inventory, supplies, furniture, fixtures, machinery, or equipment. Microloans cannot be used for real estate or to pay existing debts.

**Becoming a Microloan Intermediary**
To become an SBA Microloan intermediary, you must: (1) be a nonprofit with a tax-exempt ruling, (2) have demonstrated lending experience with low-income borrowers, (3) have an established technical assistance program, (4) submit an application to your local SBA district office, and (5) meet SBA's financial standards including matching requirements.

**Key Terms**
- **Microloan intermediary**: A nonprofit that receives SBA funds and relends them as microloans.
- **Technical assistance (TA)**: Business training and advisory services provided alongside loans.
- **Revolving**: Repaid principal cycles back into the fund for new loans.

**Practical Checklist**
- [ ] Review SBA Microloan intermediary requirements at sba.gov
- [ ] Assess your organization's technical assistance capacity
- [ ] Identify existing SBA Microloan intermediaries in your region for partnership
- [ ] Develop a concept for your TA program
- [ ] Contact your local SBA district office for application information
$$, 1, 9, 'approved'),

(v_mod, 'CDC/504 Program: Fixed-Rate Project Finance for Small Business',
$$## CDC/504 Program: Fixed-Rate Project Finance for Small Business

The SBA 504 program is one of the most powerful and underutilized tools in small business lending. It provides long-term, fixed-rate financing for major assets — commercial real estate, heavy equipment, and facility improvements — at below-market rates. But it requires a Certified Development Company (CDC) to administer, and the structure involves three parties.

**The Three-Party 504 Structure**
A typical 504 project involves: (1) a private lender (bank or credit union) that provides 50% of the project cost as a conventional first mortgage; (2) the CDC, which provides 40% as an SBA-guaranteed debenture; and (3) the borrower, who contributes 10% as equity (sometimes more for new businesses or special-purpose properties).

This structure means no single lender takes on the full risk. The private lender holds a first lien, the CDC holds a subordinated second lien backed by SBA guarantee, and the borrower's equity cushion provides additional protection.

**Eligible Projects and Uses**
504 loans can be used for: commercial real estate purchase or construction, long-term machinery and equipment, leasehold improvements, and energy efficiency projects. They cannot be used for working capital, inventory, or refinancing.

**Job Creation Requirement**
504 loans must meet public policy goals. The most common is the job creation/retention requirement — for every $65,000 in SBA exposure ($75,000 for small manufacturers), the project must create or retain one full-time equivalent job within two years.

**Partnering with CDCs**
Most community organizations will not become CDCs — the licensing process requires significant investment in compliance infrastructure. However, building relationships with CDCs in your area creates a powerful referral pathway for borrowers with real estate or equipment needs.

**Key Terms**
- **CDC**: Certified Development Company — the nonprofit that administers the 40% SBA debenture.
- **Debenture**: A long-term debt instrument backed by SBA guarantee that funds the CDC portion.
- **First/second lien**: The priority order of creditors' claims on collateral.

**Practical Checklist**
- [ ] Identify CDCs operating in your state (search sba.gov for CDC directory)
- [ ] Understand the job creation documentation requirements
- [ ] Map your borrowers with real estate or equipment needs to the 504 program
- [ ] Build a referral relationship with your regional CDC
$$, 2, 8, 'approved')
ON CONFLICT DO NOTHING;

-- Quiz for Cert 21
INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert21, 'SBA Microloan, CDC/504 & SBIC Assessment', 75, 50, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert21; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, sort_order) VALUES
(v_quiz, 'What is the maximum SBA Microloan amount?', '$25,000', '$50,000', '$100,000', '$150,000', 'B', 'The SBA Microloan program caps individual loans at $50,000, with most loans averaging around $13,000.', 1),
(v_quiz, 'In the SBA Microloan intermediary model, who lends money directly to the end borrower?', 'SBA directly', 'An SBA-approved bank', 'A nonprofit intermediary', 'A state development agency', 'C', 'SBA makes loans to nonprofit intermediaries, who then relend those funds to eligible small business borrowers.', 2),
(v_quiz, 'What is a mandatory service that SBA Microloan intermediaries must provide to borrowers?', 'Free legal representation', 'Technical assistance and training', 'Tax preparation services', 'Real estate consulting', 'B', 'Every SBA Microloan intermediary is required to provide technical assistance and training to borrowers — the program is built on the principle that capital alone is insufficient for microentrepreneur success.', 3),
(v_quiz, 'In an SBA 504 loan structure, what percentage does the CDC typically provide?', '50%', '30%', '40%', '20%', 'C', 'The CDC provides approximately 40% of the project cost through an SBA-guaranteed debenture. The private lender provides 50%, and the borrower contributes 10%.', 4),
(v_quiz, 'What is the job creation requirement for an SBA 504 loan?', 'One job per $100,000 in SBA exposure', 'One job per $65,000 in SBA exposure', 'Ten jobs per project', 'No job requirement for real estate projects', 'B', 'Standard 504 loans must create or retain one full-time equivalent job per $65,000 in SBA exposure ($75,000 for small manufacturers) within two years.', 5),
(v_quiz, 'SBA Microloan funds CANNOT be used for which purpose?', 'Working capital', 'Inventory', 'Real estate purchase', 'Machinery and equipment', 'C', 'SBA Microloan proceeds cannot be used for real estate or to pay existing debts. Eligible uses include working capital, inventory, supplies, furniture, equipment, and leasehold improvements.', 6),
(v_quiz, 'What is an SBIC?', 'A state-backed investment company', 'An SBA-licensed fund that makes equity and debt investments in small businesses', 'A community development bank', 'An SBA Microloan intermediary with enhanced powers', 'B', 'SBICs (Small Business Investment Companies) are private investment funds licensed by SBA that use private capital leveraged with SBA-guaranteed debt to make loans and equity investments in small businesses.', 7),
(v_quiz, 'Which entity type is eligible to apply for SBA Microloan intermediary status?', 'For-profit lenders only', 'Commercial banks with SBA approval', 'Nonprofit organizations with demonstrated small business lending experience', 'State government agencies', 'C', 'Only nonprofit organizations with demonstrated small business lending experience with low-income borrowers can apply to become SBA Microloan intermediaries.', 8),
(v_quiz, 'The CDC/504 program is most appropriate for financing which type of asset?', 'Operating expenses and payroll', 'Commercial real estate and major equipment', 'International trade receivables', 'Marketing and advertising campaigns', 'B', '504 loans are specifically designed for long-term fixed assets — commercial real estate, construction, and major equipment — not working capital or operating costs.', 9),
(v_quiz, 'If a community organization wants to help borrowers access SBA 504 financing without becoming a CDC, what is the best strategy?', 'Apply for SBA lender status', 'Build referral partnerships with regional CDCs', 'Apply directly to SBA for 504 guarantee authority', 'Create a separate for-profit CDC entity', 'B', 'Building referral relationships with CDCs is the most efficient strategy for organizations that want to help borrowers access 504 financing without the complexity of becoming a CDC.', 10)
ON CONFLICT DO NOTHING;

END $block$;
