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

INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'The Decision to Lend: Responsibilities and Realities', 'the-decision-to-lend-responsibilities-and-realities',
$BODY$## The Decision to Lend: Responsibilities and Realities

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
$BODY$, 1, 8, 'approved'),

(v_mod, 'The Five Major Government Lending Models', 'the-five-major-government-lending-models',
$BODY$## The Five Major Government Lending Models

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
$BODY$, 2, 9, 'approved')
ON CONFLICT DO NOTHING;

-- Module 2
INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert18, 'Choosing the Right Lender Model for Your Organization', 2, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert18 AND sort_order = 2; END IF;

INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'Matching Your Mission to a Lending Program', 'matching-your-mission-to-a-lending-program',
$BODY$## Matching Your Mission to a Lending Program

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
$BODY$, 1, 7, 'approved')
ON CONFLICT DO NOTHING;

-- Quiz for Cert 18
INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert18, 'Government Lending Models Foundations Assessment', 75, 40, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert18; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order) VALUES
(v_quiz, 'Which lending model involves an organization receiving federal funds and relending them to end borrowers at a spread?', '[{"id":"a","text":"Government-guaranteed model"},{"id":"b","text":"Intermediary relending model"},{"id":"c","text":"Secondary market model"},{"id":"d","text":"Investment fund model"}]', 'b', 'The intermediary relending model is used by programs like USDA RMAP, IRP, and the SBA Microloan program, where the intermediary receives subsidized capital and relends it to eligible borrowers.', 1),
(v_quiz, 'What is a revolving loan fund?', '[{"id":"a","text":"A fund that grows by charging high interest rates"},{"id":"b","text":"A fund where repaid principal is recycled into new loans"},{"id":"c","text":"A fund backed by a federal guarantee on every loan"},{"id":"d","text":"A fund that only makes loans to banks"}]', 'b', 'An RLF recycles repaid principal into new loans, allowing a single initial capitalization to support multiple loan generations over time.', 2),
(v_quiz, 'Which of the following is NOT one of the four matching criteria for selecting a lending program?', '[{"id":"a","text":"Mission alignment"},{"id":"b","text":"Political connections"},{"id":"c","text":"Organizational capacity"},{"id":"d","text":"Financial soundness"}]', 'b', 'The four matching criteria are mission alignment, organizational capacity, financial soundness, and community relationships. Political connections are not a program criterion.', 3),
(v_quiz, 'A nonprofit wants to make $10,000–$50,000 microloans to rural entrepreneurs using USDA funds. Which lending model fits best?', '[{"id":"a","text":"SBA 7(a) approved lender"},{"id":"b","text":"Ginnie Mae issuer"},{"id":"c","text":"USDA RMAP intermediary relender"},{"id":"d","text":"CDFI Bond Guarantee participant"}]', 'c', 'USDA RMAP is specifically designed for microentrepreneurs in rural areas, and the program uses the intermediary relending model where nonprofits borrow USDA funds and relend them to eligible borrowers.', 4),
(v_quiz, 'What is the primary purpose of a government loan guarantee?', '[{"id":"a","text":"To eliminate the lender''s need to underwrite loans"},{"id":"b","text":"To cover a defined percentage of losses in case of borrower default"},{"id":"c","text":"To provide free capital to nonprofit lenders"},{"id":"d","text":"To allow lenders to charge unlimited interest rates"}]', 'b', 'A government guarantee promises to cover a percentage of the outstanding loan principal if the borrower defaults, reducing the lender''s loss exposure.', 5),
(v_quiz, 'Which organization type is most likely to become a Ginnie Mae issuer?', '[{"id":"a","text":"A rural nonprofit microlender"},{"id":"b","text":"A mortgage company or housing finance agency"},{"id":"c","text":"A community development corporation with no lending history"},{"id":"d","text":"A tribal government without an existing loan fund"}]', 'b', 'Ginnie Mae issuer approval is designed for mortgage companies and housing finance agencies that originate government-insured mortgage loans at scale.', 6),
(v_quiz, 'What does "spread" mean in the context of an intermediary relending program?', '[{"id":"a","text":"The geographic area a lender serves"},{"id":"b","text":"The difference between the rate the intermediary pays and the rate it charges borrowers"},{"id":"c","text":"The amount of collateral required per loan"},{"id":"d","text":"The percentage of loans that go into default"}]', 'b', 'The spread is the interest rate margin — the intermediary borrows at a subsidized rate and charges borrowers a higher rate, using the difference to cover operating costs.', 7),
(v_quiz, 'Before applying for any government lending program, which document is most critical to have ready?', '[{"id":"a","text":"A press release announcing the program"},{"id":"b","text":"Two years of audited financial statements"},{"id":"c","text":"A list of prospective borrowers"},{"id":"d","text":"A signed letter from a U.S. Senator"}]', 'b', 'Government lending programs universally require audited financial statements to assess your organization''s financial soundness and management quality.', 8),
(v_quiz, 'The New Markets Tax Credit (NMTC) program is associated with which lending model?', '[{"id":"a","text":"Government-guaranteed loans"},{"id":"b","text":"Intermediary relending"},{"id":"c","text":"Investment fund models (CDFI/NMTC/SBIC)"},{"id":"d","text":"Secondary market programs"}]', 'c', 'NMTC is an investment fund model where Community Development Entities receive tax credit allocations and deploy them as loans or equity to qualifying businesses in low-income communities.', 9),
(v_quiz, 'Which of the following best describes an "approved lender" in government lending?', '[{"id":"a","text":"An organization that has received a federal grant"},{"id":"b","text":"An organization with authority to originate loans under a government guarantee program"},{"id":"c","text":"A lender that only serves approved geographic areas"},{"id":"d","text":"An intermediary that has passed a federal audit"}]', 'b', 'An approved lender has received agency authorization to originate loans under a government guarantee program (like SBA 7(a) or USDA B&I), and makes its own underwriting decisions.', 10)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- CERT 19: Lending Entity, Licensing & Compliance Readiness
-- ═══════════════════════════════════════════════════════════════
SELECT id INTO v_cert19 FROM certifications WHERE cert_number = 19;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert19, 'Choosing the Right Lending Entity Structure', 1, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert19 AND sort_order = 1; END IF;

INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'Nonprofit Loan Fund vs. CDFI vs. For-Profit Lender', 'nonprofit-loan-fund-vs-cdfi-vs-for-profit-lender',
$BODY$## Nonprofit Loan Fund vs. CDFI vs. For-Profit Lender

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
$BODY$, 1, 8, 'approved'),

(v_mod, 'State Lending Licenses, NMLS, and SAM.gov Registration', 'state-lending-licenses-nmls-and-samgov-registration',
$BODY$## State Lending Licenses, NMLS, and SAM.gov Registration

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
$BODY$, 2, 9, 'approved')
ON CONFLICT DO NOTHING;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert19, 'BSA, AML, OFAC, Fair Lending & Loan Committee Governance', 2, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert19 AND sort_order = 2; END IF;

INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'Bank Secrecy Act, Anti-Money Laundering & OFAC Screening', 'bank-secrecy-act-anti-money-laundering-ofac-screening',
$BODY$## Bank Secrecy Act, Anti-Money Laundering & OFAC Screening

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
$BODY$, 1, 9, 'approved')
ON CONFLICT DO NOTHING;

-- Quiz for Cert 19
INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert19, 'Lending Entity, Licensing & Compliance Assessment', 80, 45, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert19; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order) VALUES
(v_quiz, 'Which federal registration is required for organizations that want to receive USDA grants or program loans?', '[{"id":"a","text":"NMLS"},{"id":"b","text":"SAM.gov"},{"id":"c","text":"IRS Form 1023"},{"id":"d","text":"State lending license"}]', 'b', 'SAM.gov (System for Award Management) registration is required for all organizations seeking federal grants, contracts, or direct payments, including USDA programs.', 1),
(v_quiz, 'A nonprofit is applying for USDA RMAP intermediary status. Does it need a state lending license?', '[{"id":"a","text":"Yes, always required"},{"id":"b","text":"Depends on state law — a nonprofit lending exemption may apply"},{"id":"c","text":"No, federal programs preempt all state requirements"},{"id":"d","text":"Only if making loans over $50,000"}]', 'b', 'Whether a state lending license is required depends on state law. Many states have nonprofit lender exemptions, but this must be verified with a licensed attorney in each state.', 2),
(v_quiz, 'What is the primary purpose of OFAC screening?', '[{"id":"a","text":"To verify a borrower''s credit score"},{"id":"b","text":"To check that borrowers are not on the federal sanctions list"},{"id":"c","text":"To confirm a borrower''s SAM.gov registration"},{"id":"d","text":"To comply with state lending license requirements"}]', 'b', 'OFAC screening checks borrowers against the Specially Designated Nationals list maintained by the Office of Foreign Assets Control, ensuring you do not do business with sanctioned parties.', 3),
(v_quiz, 'Which entity structure unlocks access to CDFI Fund awards, Capital Magnet Fund, and New Markets Tax Credit?', '[{"id":"a","text":"Any 501(c)(3) nonprofit"},{"id":"b","text":"An organization certified as a CDFI by the U.S. Treasury"},{"id":"c","text":"An SBA-approved lender"},{"id":"d","text":"A Certified Development Company"}]', 'b', 'CDFI certification by the U.S. Treasury CDFI Fund is required to access CDFI Program financial and technical assistance awards, Capital Magnet Fund, and NMTC allocations.', 4),
(v_quiz, 'What replaced the DUNS number for SAM.gov registrations?', '[{"id":"a","text":"EIN (Employer Identification Number)"},{"id":"b","text":"UEI (Unique Entity Identifier)"},{"id":"c","text":"CAGE code"},{"id":"d","text":"NMLS number"}]', 'b', 'In April 2022, the UEI (Unique Entity Identifier) replaced the DUNS number for all federal contracting and grant purposes in SAM.gov.', 5),
(v_quiz, 'A Certified Development Company (CDC) administers which SBA loan program?', '[{"id":"a","text":"SBA 7(a)"},{"id":"b","text":"SBA Express"},{"id":"c","text":"SBA 504"},{"id":"d","text":"SBA Microloan"}]', 'c', 'CDCs are nonprofit corporations licensed by SBA to administer the SBA 504 loan program, which provides long-term fixed-rate financing for real estate and major equipment.', 6),
(v_quiz, 'Which BSA report is required for cash transactions over $10,000?', '[{"id":"a","text":"Suspicious Activity Report (SAR)"},{"id":"b","text":"Currency Transaction Report (CTR)"},{"id":"c","text":"OFAC Screening Report"},{"id":"d","text":"Annual AML Audit"}]', 'b', 'The Currency Transaction Report (CTR) must be filed for cash transactions exceeding $10,000 in a single business day.', 7),
(v_quiz, 'An organization wants to make SBA 504 loans. What entity structure must it establish?', '[{"id":"a","text":"CDFI"},{"id":"b","text":"SBIC"},{"id":"c","text":"CDC (Certified Development Company)"},{"id":"d","text":"A for-profit mortgage company"}]', 'c', 'Only SBA-licensed Certified Development Companies (CDCs) can administer SBA 504 loans. CDCs must apply to SBA for authorization.', 8),
(v_quiz, 'What does a loan committee governance policy primarily address?', '[{"id":"a","text":"Marketing and borrower outreach"},{"id":"b","text":"The process for approving, rejecting, and documenting loan decisions"},{"id":"c","text":"How to file Currency Transaction Reports"},{"id":"d","text":"State lending license renewal procedures"}]', 'b', 'Loan committee governance policies define the composition, quorum, decision-making authority, conflict of interest rules, and documentation requirements for loan approval decisions.', 9),
(v_quiz, 'Which of the following is a required element of a written AML program?', '[{"id":"a","text":"A relationship with a commercial bank"},{"id":"b","text":"An independent testing function and designated compliance officer"},{"id":"c","text":"CDFI certification"},{"id":"d","text":"A state money transmitter license"}]', 'b', 'A strong written AML program includes internal controls, a designated compliance officer, ongoing employee training, and an independent testing function to verify the program''s effectiveness.', 10)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- CERT 20: SBA 7(a) & Small Business Lending
-- ═══════════════════════════════════════════════════════════════
SELECT id INTO v_cert20 FROM certifications WHERE cert_number = 20;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert20, 'The SBA 7(a) Lending Ecosystem', 1, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert20 AND sort_order = 1; END IF;

INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'SBA 7(a) Overview: Programs, Eligibility, and Lender Types', 'sba-7a-overview-programs-eligibility-and-lender-types',
$BODY$## SBA 7(a) Overview: Programs, Eligibility, and Lender Types

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
$BODY$, 1, 10, 'approved')
ON CONFLICT DO NOTHING;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert20, 'SBA Express, Export Programs & CAPLines', 2, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert20 AND sort_order = 2; END IF;

INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'Partnering with SBA Lenders: Strategy for Community Organizations', 'partnering-with-sba-lenders-strategy-for-community-organizations',
$BODY$## Partnering with SBA Lenders: Strategy for Community Organizations

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
$BODY$, 1, 8, 'approved')
ON CONFLICT DO NOTHING;

-- Quiz for Cert 20
INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert20, 'SBA 7(a) & Small Business Lending Assessment', 75, 50, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert20; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order) VALUES
(v_quiz, 'What is the SBA guarantee percentage for a standard 7(a) loan over $150,000?', '[{"id":"a","text":"85%"},{"id":"b","text":"75%"},{"id":"c","text":"90%"},{"id":"d","text":"50%"}]', 'b', 'SBA guarantees up to 85% for loans up to $150,000 and 75% for loans above that threshold.', 1),
(v_quiz, 'Which SBA 7(a) product offers approval within 36 hours and a 50% guarantee?', '[{"id":"a","text":"Standard 7(a)"},{"id":"b","text":"SBA Express"},{"id":"c","text":"Export Express"},{"id":"d","text":"CAPLine"}]', 'b', 'SBA Express offers a 36-hour turnaround and a 50% guarantee, allowing lenders to use their own underwriting processes for loans up to $500,000.', 2),
(v_quiz, 'What is the maximum loan amount under the SBA 7(a) program?', '[{"id":"a","text":"$2 million"},{"id":"b","text":"$3.5 million"},{"id":"c","text":"$5 million"},{"id":"d","text":"$10 million"}]', 'c', 'The SBA 7(a) program has a maximum loan amount of $5 million.', 3),
(v_quiz, 'Which SBA lender type is specifically designed for nonprofits and CDFIs?', '[{"id":"a","text":"SBA Express lender"},{"id":"b","text":"Community Advantage SBLC"},{"id":"c","text":"Preferred Lender Program (PLP)"},{"id":"d","text":"Certified Lender Program (CLP)"}]', 'b', 'Community Advantage Small Business Lending Companies are a licensed class of SBA 7(a) lender specifically designed for nonprofits, CDFIs, and mission-driven organizations.', 4),
(v_quiz, 'What type of financing do CAPLines provide?', '[{"id":"a","text":"Long-term real estate mortgages"},{"id":"b","text":"Revolving lines of credit for specific business purposes"},{"id":"c","text":"Export credit insurance"},{"id":"d","text":"Working capital for foreign buyers"}]', 'b', 'CAPLines provide four types of revolving lines of credit for seasonal, contract, builder, and working capital needs.', 5),
(v_quiz, 'For SBA 7(a) eligibility, a borrower must demonstrate what regarding conventional financing?', '[{"id":"a","text":"They have never applied to a bank"},{"id":"b","text":"They were unable to obtain financing on reasonable terms through conventional channels"},{"id":"c","text":"They have a minimum credit score of 680"},{"id":"d","text":"They are located in a rural area"}]', 'b', 'SBA 7(a) eligibility requires that the borrower cannot obtain credit elsewhere on reasonable terms — the program is designed to fill gaps in conventional lending.', 6),
(v_quiz, 'The Export Working Capital Program (EWCP) is designed for:', '[{"id":"a","text":"Domestic manufacturers expanding facilities"},{"id":"b","text":"Businesses that need working capital to support export sales"},{"id":"c","text":"Importers seeking foreign buyer financing"},{"id":"d","text":"Nonprofit organizations exporting services"}]', 'b', 'EWCP provides revolving lines of credit for businesses with export sales, allowing them to access capital based on export purchase orders and receivables.', 7),
(v_quiz, 'What is the most common strategy for a CDFI that wants to connect borrowers to SBA 7(a) capital without becoming an SBA lender?', '[{"id":"a","text":"Apply for a state lending license"},{"id":"b","text":"Build referral partnerships with SBA-approved lenders"},{"id":"c","text":"Acquire an SBIC license"},{"id":"d","text":"Apply directly to SBA for guarantee authority"}]', 'b', 'Building referral partnerships with SBA-approved banks and credit unions is the most common and efficient strategy for CDFIs that want to leverage 7(a) capital for their borrowers.', 8),
(v_quiz, 'Which business types are generally INELIGIBLE for SBA 7(a) loans?', '[{"id":"a","text":"Manufacturing companies"},{"id":"b","text":"Real estate investment firms and gambling businesses"},{"id":"c","text":"Retail businesses and restaurants"},{"id":"d","text":"Professional service firms"}]', 'b', 'Certain industries are ineligible for SBA 7(a) loans, including real estate investment, gambling, pyramid sales, and businesses engaged in lending.', 9),
(v_quiz, 'A nonprofit organization with three years of small business lending experience wants to originate SBA 7(a) loans up to $350,000. What is the most appropriate pathway?', '[{"id":"a","text":"Apply for standard SBA lender approval"},{"id":"b","text":"Apply for a Community Advantage SBLC license"},{"id":"c","text":"Partner with a commercial bank as a loan packager"},{"id":"d","text":"Apply for an SBIC license from SBA"}]', 'b', 'The Community Advantage SBLC pathway requires nonprofit or mission-driven status, at least two years of lending experience, and is specifically designed for loans up to $350,000 in underserved markets.', 10)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- CERT 21: SBA Microloan, CDC/504 & SBIC
-- ═══════════════════════════════════════════════════════════════
SELECT id INTO v_cert21 FROM certifications WHERE cert_number = 21;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert21, 'The SBA Microloan Program: Intermediary Model', 1, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert21 AND sort_order = 1; END IF;

INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'SBA Microloan Program: How Intermediaries Work', 'sba-microloan-program-how-intermediaries-work',
$BODY$## SBA Microloan Program: How Intermediaries Work

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
$BODY$, 1, 9, 'approved'),

(v_mod, 'CDC/504 Program: Fixed-Rate Project Finance for Small Business', 'cdc504-program-fixed-rate-project-finance-for-small-business',
$BODY$## CDC/504 Program: Fixed-Rate Project Finance for Small Business

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
$BODY$, 2, 8, 'approved')
ON CONFLICT DO NOTHING;

-- Quiz for Cert 21
INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert21, 'SBA Microloan, CDC/504 & SBIC Assessment', 75, 50, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert21; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order) VALUES
(v_quiz, 'What is the maximum SBA Microloan amount?', '[{"id":"a","text":"$25,000"},{"id":"b","text":"$50,000"},{"id":"c","text":"$100,000"},{"id":"d","text":"$150,000"}]', 'b', 'The SBA Microloan program caps individual loans at $50,000, with most loans averaging around $13,000.', 1),
(v_quiz, 'In the SBA Microloan intermediary model, who lends money directly to the end borrower?', '[{"id":"a","text":"SBA directly"},{"id":"b","text":"An SBA-approved bank"},{"id":"c","text":"A nonprofit intermediary"},{"id":"d","text":"A state development agency"}]', 'c', 'SBA makes loans to nonprofit intermediaries, who then relend those funds to eligible small business borrowers.', 2),
(v_quiz, 'What is a mandatory service that SBA Microloan intermediaries must provide to borrowers?', '[{"id":"a","text":"Free legal representation"},{"id":"b","text":"Technical assistance and training"},{"id":"c","text":"Tax preparation services"},{"id":"d","text":"Real estate consulting"}]', 'b', 'Every SBA Microloan intermediary is required to provide technical assistance and training to borrowers — the program is built on the principle that capital alone is insufficient for microentrepreneur success.', 3),
(v_quiz, 'In an SBA 504 loan structure, what percentage does the CDC typically provide?', '[{"id":"a","text":"50%"},{"id":"b","text":"30%"},{"id":"c","text":"40%"},{"id":"d","text":"20%"}]', 'c', 'The CDC provides approximately 40% of the project cost through an SBA-guaranteed debenture. The private lender provides 50%, and the borrower contributes 10%.', 4),
(v_quiz, 'What is the job creation requirement for an SBA 504 loan?', '[{"id":"a","text":"One job per $100,000 in SBA exposure"},{"id":"b","text":"One job per $65,000 in SBA exposure"},{"id":"c","text":"Ten jobs per project"},{"id":"d","text":"No job requirement for real estate projects"}]', 'b', 'Standard 504 loans must create or retain one full-time equivalent job per $65,000 in SBA exposure ($75,000 for small manufacturers) within two years.', 5),
(v_quiz, 'SBA Microloan funds CANNOT be used for which purpose?', '[{"id":"a","text":"Working capital"},{"id":"b","text":"Inventory"},{"id":"c","text":"Real estate purchase"},{"id":"d","text":"Machinery and equipment"}]', 'c', 'SBA Microloan proceeds cannot be used for real estate or to pay existing debts. Eligible uses include working capital, inventory, supplies, furniture, equipment, and leasehold improvements.', 6),
(v_quiz, 'What is an SBIC?', '[{"id":"a","text":"A state-backed investment company"},{"id":"b","text":"An SBA-licensed fund that makes equity and debt investments in small businesses"},{"id":"c","text":"A community development bank"},{"id":"d","text":"An SBA Microloan intermediary with enhanced powers"}]', 'b', 'SBICs (Small Business Investment Companies) are private investment funds licensed by SBA that use private capital leveraged with SBA-guaranteed debt to make loans and equity investments in small businesses.', 7),
(v_quiz, 'Which entity type is eligible to apply for SBA Microloan intermediary status?', '[{"id":"a","text":"For-profit lenders only"},{"id":"b","text":"Commercial banks with SBA approval"},{"id":"c","text":"Nonprofit organizations with demonstrated small business lending experience"},{"id":"d","text":"State government agencies"}]', 'c', 'Only nonprofit organizations with demonstrated small business lending experience with low-income borrowers can apply to become SBA Microloan intermediaries.', 8),
(v_quiz, 'The CDC/504 program is most appropriate for financing which type of asset?', '[{"id":"a","text":"Operating expenses and payroll"},{"id":"b","text":"Commercial real estate and major equipment"},{"id":"c","text":"International trade receivables"},{"id":"d","text":"Marketing and advertising campaigns"}]', 'b', '504 loans are specifically designed for long-term fixed assets — commercial real estate, construction, and major equipment — not working capital or operating costs.', 9),
(v_quiz, 'If a community organization wants to help borrowers access SBA 504 financing without becoming a CDC, what is the best strategy?', '[{"id":"a","text":"Apply for SBA lender status"},{"id":"b","text":"Build referral partnerships with regional CDCs"},{"id":"c","text":"Apply directly to SBA for 504 guarantee authority"},{"id":"d","text":"Create a separate for-profit CDC entity"}]', 'b', 'Building referral relationships with CDCs is the most efficient strategy for organizations that want to help borrowers access 504 financing without the complexity of becoming a CDC.', 10)
ON CONFLICT DO NOTHING;

END $block$;
