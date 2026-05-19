-- ============================================================
-- Cap Fund Academy — Certs 10-13 Full Content
-- File: 17_cert10_13_content.sql
-- Idempotent: ON CONFLICT DO NOTHING
-- Run after: 04_cert_seeds.sql
-- ============================================================

-- ============================================================
-- CERT 10: Federal Compliance, Civil Rights, Environmental Review & 2 CFR 200
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

SELECT id INTO cert_id FROM certifications WHERE cert_number = 10;
IF cert_id IS NULL THEN
  RAISE EXCEPTION 'Cert 10 not found — run 04_cert_seeds.sql first';
END IF;

UPDATE certifications SET
  learning_outcomes = ARRAY[
    'Apply civil rights obligations under ECOA, Title VI, ADA, and Section 504 to RLF operations',
    'Maintain required demographic data and limited English proficiency protocols',
    'Conduct an environmental review and complete a screening worksheet for a microloan project',
    'Identify categorical exclusions and triggers for a Phase I Environmental Site Assessment',
    'Apply 2 CFR 200 Uniform Guidance cost principles to allowable and unallowable expenditures',
    'Implement procurement standards, record retention, and internal controls required under 2 CFR 200',
    'Complete required certifications: SAM/UEI, debarment, lobbying, conflict of interest, and drug-free workplace'
  ],
  status = 'approved'
WHERE id = cert_id;

-- MODULE 1
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Civil Rights and Non-Discrimination',
  'Master the civil rights statutes binding on USDA-funded RLFs: ECOA, Title VI, ADA, Section 504. Learn demographic recordkeeping, LEP plans, and complaint procedures.',
  1, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod1_id FROM modules WHERE certification_id = cert_id AND sort_order = 1;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod1_id,
  'Civil Rights Obligations for USDA-Funded RLFs',
  'cert10-civil-rights-obligations',
  E'## Why Civil Rights Compliance Is Non-Negotiable\n\nEvery organization that receives federal financial assistance — including USDA RMAP loans and grants — accepts binding civil rights obligations as a condition of that assistance. These are not aspirational policies. Violations can result in suspension of federal funding, debarment, and civil litigation. Auditors specifically examine civil rights compliance in every USDA site visit.\n\nFour statutes form the core framework for USDA-funded RLFs:\n\n1. **Equal Credit Opportunity Act (ECOA) — 15 U.S.C. § 1691**\n2. **Title VI of the Civil Rights Act of 1964 — 42 U.S.C. § 2000d**\n3. **Americans with Disabilities Act (ADA) — 42 U.S.C. § 12101**\n4. **Section 504 of the Rehabilitation Act of 1973 — 29 U.S.C. § 794**\n\n## Equal Credit Opportunity Act (ECOA)\n\nECOA prohibits discrimination in any aspect of a credit transaction on the basis of race, color, religion, national origin, sex, marital status, age (provided the applicant has the capacity to contract), or the fact that all or part of the applicant''s income derives from a public assistance program.\n\n**For RLF microlenders, ECOA requires:**\n\n- Consistent, documented underwriting criteria applied equally to all applicants\n- Written adverse action notices when a loan is denied or offered on less favorable terms, delivered within 30 days of the application decision\n- The adverse action notice must state the specific reasons for denial (not a generic "did not meet underwriting criteria")\n- Prohibition on asking about an applicant''s race, color, religion, national origin, or sex for underwriting purposes (though demographic data is collected separately for monitoring)\n\n**Common ECOA findings in USDA audits:**\n- Adverse action notices missing or delivered late\n- Adverse action reasons that are vague or inconsistently applied\n- No written credit policy, making it impossible to demonstrate consistent application\n\n## Title VI of the Civil Rights Act of 1964\n\nTitle VI prohibits discrimination on the basis of race, color, or national origin in any program or activity receiving federal financial assistance. For RLFs, this means:\n\n- All program services — outreach, TA, lending — must be equally accessible to persons of all racial, color, and national origin groups in the service area\n- Marketing materials must reach non-English-speaking populations if they are present in the service area\n- Demographic data must be collected and analyzed to detect disparate impact\n- A written **Limited English Proficiency (LEP) Plan** is required if the service area has meaningful LEP populations (see below)\n\nTitle VI extends to disparate impact — neutral policies that disproportionately exclude protected classes may be violations even without discriminatory intent.\n\n## ADA and Section 504\n\nThe ADA (Title II for public entities, Title III for places of public accommodation) and Section 504 require that persons with disabilities have equal access to your programs and services.\n\n**For RLF offices and TA programs:**\n- Physical office space must be accessible (ramps, accessible restrooms, accessible parking)\n- Program communications must be available in accessible formats upon request (large print, screen-reader-compatible documents)\n- TA sessions must be accessible (captioning, ASL interpretation upon request)\n- Online platforms must meet WCAG 2.1 AA accessibility standards\n- Staff must be trained to provide accommodations without making applicants feel singled out\n\nSection 504 additionally requires federal assistance recipients to designate a **Section 504 Coordinator** if they have 15 or more employees. Even smaller organizations must have a Section 504 grievance procedure.\n\n## Demographic Recordkeeping\n\nUSDA requires RLF operators to collect and maintain demographic data on all loan applicants and borrowers, including those who do not complete an application. Required data elements include:\n\n- Race (using federal race categories)\n- Ethnicity (Hispanic/Latino or not)\n- Sex/gender\n- Veteran status\n- Low-income status\n- Geographic location (rural/urban)\n\nThis data is collected on a **voluntary self-identification basis** — applicants cannot be required to provide it. However, if an applicant declines to self-identify, staff may note visual observation for monitoring purposes (with a clear notation that it is observed, not self-reported).\n\nAll demographic data is maintained separately from the credit file and cannot be used in underwriting decisions. Cross-contaminating the credit file with demographic data is itself a compliance violation.\n\n## Limited English Proficiency (LEP) Plan\n\nUnder Executive Order 13166 (Improving Access to Services for Persons with Limited English Proficiency), federally assisted programs must take reasonable steps to ensure meaningful access for LEP individuals.\n\n**Your LEP plan must:**\n1. Identify the languages spoken in your service area (use Census data)\n2. Assess the frequency with which LEP individuals encounter your program\n3. Describe the resources available for language assistance (bilingual staff, interpretation services, translated documents)\n4. Establish staff training requirements for LEP situations\n5. Be updated at least every three years\n\nFor rural areas with significant Spanish-speaking populations, translated loan applications, adverse action notices, and program flyers are the minimum standard.\n\n## Complaint Procedure\n\nEvery USDA-funded RLF must maintain a written civil rights complaint procedure that:\n\n- Is posted prominently in the office and on the organization''s website\n- Is available in the languages of the service area\n- Identifies the contact person for complaints\n- Describes the timeline for response (typically 45-90 days)\n- Preserves the complainant''s right to also file with the USDA Office of Civil Rights\n- Maintains a log of all complaints received and their resolution\n\n**What auditors look for:** A written complaint procedure, evidence it is posted/distributed, a complaint log (even if empty — the log itself proves the system exists), and at least one staff training record on civil rights annually.',
  'ECOA, Title VI, ADA, and Section 504 create binding civil rights obligations for every USDA-funded RLF. Learn what auditors look for and how to stay compliant.',
  22, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 2
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Environmental Review',
  'Understand NEPA environmental review requirements for USDA-funded microloans, categorical exclusions, Phase I triggers, and the environmental screening worksheet.',
  2, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod2_id FROM modules WHERE certification_id = cert_id AND sort_order = 2;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod2_id,
  'Environmental Review for Microloan Projects',
  'cert10-environmental-review',
  E'## NEPA and Why It Applies to Your RLF\n\nThe National Environmental Policy Act (NEPA), 42 U.S.C. § 4321 et seq., requires federal agencies to assess the environmental impact of their actions before committing federal resources. When USDA provides a loan or grant to capitalize your RLF, USDA is taking a federal action — and every project funded with those federal dollars inherits environmental review obligations.\n\nThis does not mean that every $5,000 microloan triggers a full Environmental Impact Statement. USDA has established a tiered review system that categorizes most microloan projects as requiring minimal review. But you must understand the tiers, complete the required screening, and — critically — obtain environmental clearance **before** obligating funds.\n\n## The Three-Tier NEPA System\n\n### Tier 1: Categorical Exclusion (CE)\nA categorical exclusion is a category of actions that USDA has determined, by regulation, do not individually or cumulatively have a significant effect on the environment. Most RMAP microloans fall into categorical exclusions.\n\n**Common categorical exclusions for microloans:**\n- Working capital loans (no physical change to any site)\n- Purchase of equipment that is not site-specific and does not involve ground disturbance\n- Business planning and technical assistance\n- Purchase of inventory\n- Loans to existing businesses in existing commercial spaces\n\nFor a CE, you complete the environmental screening worksheet, document the CE category, and proceed. No further analysis is required.\n\n### Tier 2: Environmental Assessment (EA)\nAn EA is required when a project does not clearly fit within a categorical exclusion and may have some environmental effect, but a full EIS is not obviously needed. An EA results in either a Finding of No Significant Impact (FONSI) or a decision to proceed to EIS.\n\nEAs are uncommon for microloans but may be triggered by projects involving:\n- New construction (even a small building)\n- Physical renovation that disturbs soil or involves hazardous materials\n- Projects in or near wetlands, floodplains, or historic properties\n\n### Tier 3: Environmental Impact Statement (EIS)\nAn EIS is required for major federal actions significantly affecting the quality of the human environment. This is extremely rare for microloans and effectively never occurs in RMAP practice.\n\n## When a Phase I Environmental Site Assessment Is Required\n\nA Phase I Environmental Site Assessment (ESA) is an assessment of a property''s environmental condition conducted by a qualified environmental professional. Under ASTM Standard E1527-21, a Phase I investigates recognized environmental conditions (RECs) — the presence or likely presence of hazardous substances or petroleum products.\n\n**A Phase I is required for RMAP microloans when:**\n\n1. **Real property is involved as collateral** — If the microloan is secured by a mortgage or deed of trust on real property, USDA requires a Phase I\n2. **The project involves purchase of real property** — Even if the loan is small\n3. **There is reason to believe the property has environmental concerns** — Prior industrial use, underground storage tanks, dry cleaning operations on or near the site\n4. **The project involves new construction** — Ground disturbance always requires environmental review\n5. **The property is in or near a brownfield area** — Contamination risk triggers Phase I requirement\n\n**Phase I is generally NOT required for:**\n- Working capital loans with no real property collateral\n- Equipment loans where equipment is not affixed to real property\n- Loans secured only by business assets (UCC filing)\n- TA-only grants\n\n## Site-Specific Project Triggers\n\nBeyond Phase I, certain project characteristics trigger additional environmental screening:\n\n**Floodplain:** Is the project site in a 100-year floodplain (FEMA Zone A or V)? Floodplain development requires a floodplain analysis and, in some cases, an 8-step decision-making process under Executive Order 11988.\n\n**Wetlands:** Is the project site in or adjacent to wetlands? Executive Order 11990 requires avoidance of impacts to wetlands.\n\n**Historic Properties:** Does the project involve ground disturbance or modification of a building 50+ years old? Section 106 of the National Historic Preservation Act (NHPA) requires consultation with the State Historic Preservation Office (SHPO).\n\n**Threatened and Endangered Species:** Is the project in habitat for listed species? Section 7 of the Endangered Species Act may require consultation with U.S. Fish & Wildlife Service.\n\n**Sole Source Aquifer:** Is the project in a sole source aquifer protection area? Projects involving potential contamination of drinking water sources require additional review.\n\n## Timing: Environmental Clearance Before Funds Are Obligated\n\nThis is the most commonly violated environmental rule in USDA program audits: **funds cannot be obligated (committed) before environmental clearance is obtained.**\n\nObligating funds means any action that commits USDA or the recipient to spend money on a specific project — signing a loan agreement, issuing a commitment letter, or approving a loan for a specific purpose before environmental review is complete.\n\nIf you sign a loan commitment letter and then discover the property has a recognized environmental condition requiring Phase II investigation, you have already violated the environmental review timing requirement.\n\n**Correct process:**\n1. Applicant submits loan application with project description\n2. Complete environmental screening worksheet\n3. Determine CE category, or determine EA/Phase I is needed\n4. Complete Phase I (if required) and obtain USDA environmental clearance\n5. Sign loan commitment letter\n6. Close loan\n\n## Completing the Environmental Screening Worksheet\n\nUSDA provides a standard environmental screening worksheet (form available from your USDA Rural Development State Office). The worksheet covers:\n\n- **Project description** — What will be built, purchased, or changed?\n- **Location** — Address, county, state, GPS coordinates if applicable\n- **Floodplain status** — FEMA FIRM panel number and zone\n- **Wetlands** — National Wetlands Inventory check\n- **Historic properties** — Age of structure, SHPO lookup\n- **Species** — FWS IPaC (Information, Planning, and Conservation) system check\n- **Hazardous materials** — Prior use of site, Phase I status\n- **CE determination** — Which categorical exclusion applies, or why further review is needed\n\nEven for the simplest working capital loan, complete and retain the environmental screening worksheet. The worksheet is your documentation that you conducted review — its absence is an automatic audit finding.',
  'NEPA environmental review is required before obligating RMAP funds. Learn the CE/EA/EIS tiers, when a Phase I is required, and how to complete the screening worksheet.',
  20, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 3
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  '2 CFR 200 Uniform Guidance',
  'Apply 2 CFR 200 cost principles, procurement standards, record retention, internal controls, and single audit requirements to your USDA-funded RLF.',
  3, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod3_id FROM modules WHERE certification_id = cert_id AND sort_order = 3;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod3_id,
  '2 CFR 200 Uniform Guidance for RLF Operators',
  'cert10-2cfr200-uniform-guidance',
  E'## What Is 2 CFR 200?\n\nTitle 2 of the Code of Federal Regulations, Part 200 — commonly called "Uniform Guidance" or simply "2 CFR 200" — is the single set of rules governing the administration of all federal grants and cooperative agreements. It was issued by the Office of Management and Budget (OMB) in 2013 (effective 2014) and superseded eight prior circulars including OMB Circulars A-21, A-87, A-110, and A-133.\n\nIf your organization receives USDA RMAP technical assistance grants, RBDG grants, or any other federal financial assistance, 2 CFR 200 governs how you must manage those funds. USDA has incorporated 2 CFR 200 by reference into all RMAP and RBDG grant agreements.\n\n## Allowable vs. Unallowable Costs\n\nThe central concept of 2 CFR 200 cost principles is that federal grant funds may only pay for costs that are:\n\n1. **Allowable** — Permitted under 2 CFR 200 Subpart E and the specific program regulations\n2. **Allocable** — Directly related to the federal award and allocated on a reasonable basis\n3. **Reasonable** — Would be recognized as necessary and reasonable by a prudent person\n4. **Consistent** — Treated consistently with how the organization treats similar costs in non-federal activities\n\n**Common allowable costs for RLF/TA grants:**\n- Staff salaries and fringe benefits (for employees working on the grant)\n- Office space (rent allocated to the portion used for grant activities)\n- Supplies and materials used for TA delivery\n- Travel costs for client meetings and training (must follow federal travel per diem rates or the organization''s travel policy, whichever is less)\n- Subcontractor costs (with proper procurement)\n- Indirect costs (if the organization has a negotiated indirect cost rate agreement, or uses the 10% de minimis rate under 2 CFR 200.414)\n\n**Common unallowable costs:**\n- Alcohol purchases\n- Entertainment, recreation, or social activities\n- Lobbying and political activities (2 CFR 200.450)\n- Bad debts or losses from uncollectible loans (cannot charge loan losses to a TA grant)\n- Fines and penalties\n- Costs incurred outside the award period\n- Contributions and donations made by your organization to others\n- Executive compensation above the federal benchmark ($221,900 for 2024)\n- Fundraising costs (for the organization''s own fundraising activities)\n\n## Cost Allocation\n\nMany RLF organizations operate multiple programs — the lending program, the TA program, other grants, unrestricted programs. When staff time, rent, or other costs benefit more than one program, they must be allocated among programs on a reasonable, documented basis.\n\n**Acceptable allocation methods:**\n- **Direct allocation** — Track actual time or usage per program (most defensible)\n- **FTE ratio** — Allocate shared costs based on the ratio of FTEs working on each program\n- **Square footage** — Allocate rent based on the proportion of office space used per program\n- **Revenue ratio** — Allocate indirect costs based on relative revenue from each program\n\n**What 2 CFR 200 prohibits:** Arbitrary allocation, double-charging (billing the same cost to two federal grants), and "convenience" allocation that does not reflect actual usage.\n\nYour cost allocation methodology must be documented in a written **Cost Allocation Plan (CAP)** and applied consistently.\n\n## Procurement Standards\n\n2 CFR 200.317-326 establishes procurement standards for entities spending federal grant funds on goods and services. The thresholds (as of 2024):\n\n| Purchase Amount | Required Method |\n|----------------|----------------|\n| Under $10,000 (micro-purchase) | Can purchase without competition if price is reasonable |\n| $10,000 - $250,000 | Informal procurement — get 2+ price/rate quotes |\n| Over $250,000 | Formal competitive procurement (RFP or IFB) |\n\nAll procurement must:\n- Avoid conflicts of interest (no purchases from related parties without prior approval)\n- Be documented (keep records of quotes, bids, selection rationale)\n- Use clear specifications that do not unnecessarily restrict competition\n- Prohibit geographic preferences that favor local vendors over equally qualified distant vendors\n\n## Record Retention\n\nUnder 2 CFR 200.334, records related to federal awards must be retained for **three years from the date of submission of the final financial report** for the award. For RMAP TA grants, this means 3 years after you submit your final SF-425 federal financial report for each grant year.\n\n**Records that must be retained:**\n- Financial records (general ledger, bank statements, invoices, receipts)\n- Grant agreement and all amendments\n- All programmatic reports submitted to USDA\n- Personnel records supporting payroll charges to the grant\n- Procurement documentation\n- Subrecipient monitoring records\n- All correspondence with USDA regarding the award\n\nIf litigation, a claim, or audit is initiated before the 3-year period expires, records must be retained until resolution of the matter.\n\n## Internal Controls\n\n2 CFR 200.303 requires that non-federal entities maintain internal controls providing reasonable assurance that the entity is managing federal awards in compliance with laws, regulations, and grant conditions. Key internal controls for RLFs:\n\n**Segregation of duties:** The person who approves loan disbursements should not be the same person who signs checks or transfers funds. The bookkeeper should not also be the person who reconciles the bank account.\n\n**Authorization controls:** All expenditures above a threshold (e.g., $500) require secondary approval. Loan approvals require full committee or board review.\n\n**Reconciliation:** Bank accounts reconciled monthly; RMRF balance reconciled to outstanding loan schedule.\n\n**Documentation requirements:** No payment without a supporting invoice or voucher. No reimbursement without receipts.\n\n**Supervision:** Supervisors review and approve timesheets before payroll is processed.\n\n## Financial Management System Standards\n\n2 CFR 200.302 requires that financial management systems for federal awards provide:\n\n- Accurate, current, and complete records of all financial transactions\n- Records that identify the source and application of funds for each federal award\n- Effective control over and accountability for all funds\n- Comparison of actual expenditures with budget amounts for each award\n- Written procedures for determining allowability of costs\n- Written procedures for cash management (minimizing time between draw and disbursement)\n\n## The Single Audit Threshold\n\nThe most consequential provision of 2 CFR 200 for growing RLF organizations is the **single audit requirement** under Subpart F.\n\nAny non-federal entity that expends **$750,000 or more in federal awards during its fiscal year** must have a single audit (also called an A-133 audit) conducted by an independent auditor. The single audit examines not just the financial statements but also compliance with federal program requirements.\n\nThe $750,000 threshold counts all federal expenditures across all federal awards — RMAP, RBDG, SBA, HUD, USDA Rural Development, and any other federal source. Organizations approaching this threshold must plan for the additional cost and complexity of a single audit ($15,000–$40,000 depending on complexity).\n\nOrganizations below $750,000 are not subject to single audit but may still be subject to USDA program-specific audits.',
  '2 CFR 200 Uniform Guidance governs how federal grant funds must be managed. Master cost principles, procurement, record retention, internal controls, and the single audit threshold.',
  24, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 4
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Certifications, Conflict of Interest, and Debarment',
  'Complete required federal certifications: SAM/UEI, debarment, lobbying, drug-free workplace, conflict of interest, and insider transaction policy.',
  4, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod4_id FROM modules WHERE certification_id = cert_id AND sort_order = 4;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod4_id,
  'Federal Certifications, Debarment, and Conflict of Interest',
  'cert10-certifications-debarment-coi',
  E'## Required Federal Certifications for USDA Applicants\n\nEvery organization applying for USDA RMAP or RBDG funding must complete a suite of required certifications before an award can be made. These certifications are not formalities — they are legal representations that, if false, can result in debarment, recovery of funds, and criminal referral under 18 U.S.C. § 1001 (false statements to the federal government).\n\n## SAM Registration and Unique Entity Identifier (UEI)\n\nThe System for Award Management (SAM.gov) is the federal government''s primary database for entities doing business with the government. All USDA grant and loan recipients must:\n\n1. **Register in SAM.gov** and maintain an active registration throughout the period of the award\n2. **Obtain a Unique Entity Identifier (UEI)** — a 12-character alphanumeric identifier assigned by SAM.gov that replaced the DUNS number in April 2022\n3. **Renew SAM registration annually** — registrations expire after 12 months; a lapsed registration can delay or halt funding\n\n**Common SAM issues that delay USDA awards:**\n- Expired SAM registration (most common)\n- Incorrect EIN associated with the SAM record\n- Entity name mismatch between SAM and IRS records\n- Missing or outdated financial institution information for EFT payments\n\nBegin your SAM registration or renewal at least 6-8 weeks before your application deadline. SAM processing can take 2-4 weeks, and IRS validation adds additional time.\n\n## Debarment and Suspension Certification\n\nUnder 2 CFR Part 180 (the government-wide debarment regulations, incorporated into USDA regulations at 2 CFR Part 417), applicants must certify that:\n\n- The organization is not debarred, suspended, proposed for debarment, or declared ineligible by any federal agency\n- The organization''s principals (officers, directors, key employees) are not debarred or suspended\n- The organization will not make subawards or contracts with debarred entities\n\n**Checking debarment status:**\n- Search SAM.gov Exclusions database before submitting an application\n- Search for all organizational principals by name\n- Document your search results (print/screenshot with date) and retain in the application file\n\nIf a principal of your organization is debarred or suspended, the organization is generally ineligible for federal awards until the exclusion is lifted or the principal is removed.\n\n## Lobbying Certification\n\nUnder the Byrd Amendment (31 U.S.C. § 1352) and implementing regulations at 2 CFR Part 418, applicants for federal grants and loans over $100,000 must certify that:\n\n- No appropriated federal funds have been paid or will be paid to any person for influencing or attempting to influence a federal officer or employee, or a Member of Congress, in connection with the award\n- If non-federal funds are used for lobbying related to the award, a Disclosure Form SF-LLL must be completed\n\nThis certification specifically targets **direct lobbying** related to the specific award. It does not prohibit general advocacy or public education activities unrelated to a specific federal funding decision.\n\nKey distinction: Using federal grant funds to lobby Congress for more RMAP funding is prohibited. Hosting a community meeting about the importance of rural microfinance is not.\n\n## Drug-Free Workplace Certification\n\nUnder the Drug-Free Workplace Act of 1988 and implementing regulations at 2 CFR Part 421, federal grantees must certify that they will:\n\n- Publish a drug-free workplace policy statement and give it to all employees working on the grant\n- Establish a drug-free awareness program covering the dangers of drug abuse and available counseling resources\n- Notify employees that, as a condition of employment on the federal award, they must comply with the policy\n- Notify the federal agency within 10 days if an employee is convicted of a drug statute violation occurring in the workplace\n\nFor most small RLF nonprofits, this means adopting a written drug-free workplace policy, including it in the employee handbook, and distributing it at hire.\n\n## Conflict of Interest Disclosure\n\n2 CFR 200.112 requires that non-federal entities maintain written conflict of interest policies and disclose in writing to the federal awarding agency any potential conflict of interest affecting the federal award.\n\n**Required elements of a conflict of interest policy:**\n- Definition of conflict of interest (financial interest, personal relationship, or other situation creating a divided loyalty)\n- Disclosure requirements — when and how employees, officers, and board members must disclose conflicts\n- Recusal procedure — persons with conflicts must recuse from related decisions\n- Review process — who reviews disclosed conflicts and makes determinations\n- Consequences for failure to disclose\n\n**USDA-specific conflict of interest requirements for RLFs:**\n- Loan officers may not participate in the credit decision on loans to family members, business partners, or entities in which they have a financial interest\n- Board members who have a financial relationship with a loan applicant must recuse from the loan approval vote and document the recusal in board minutes\n- The organization''s written loan policy must prohibit insider transactions (loans to officers, directors, or their immediate family members) or establish a rigorous pre-approval process with USDA notification\n\n## Insider Transaction Policy\n\nAn insider transaction is any loan or financial transaction between the RLF and a person who has an insider relationship to the organization — an officer, director, board member, key employee, or their immediate family.\n\nUnder 7 CFR 4280, insider transactions are presumptively prohibited. If your loan policy allows insider transactions under any circumstances, it must include:\n\n- A definition of "insider" that covers all principals and their immediate families\n- Mandatory written disclosure before application\n- Mandatory recusal of the insider from all aspects of the loan process\n- USDA prior approval (for RMAP microlenders)\n- Documentation in the loan file of the recusal and approval process\n\nThe safest practice: adopt a written policy that prohibits all insider transactions. This eliminates the compliance risk and is easy to document.\n\n## 2 CFR 200 Procurement Conflict of Interest Rules\n\nBeyond the general conflict of interest policy, 2 CFR 200.318(c) contains specific procurement conflict rules:\n\n- No employee, officer, or agent may participate in the selection, award, or administration of a contract supported by federal funds in which they have a real or apparent conflict of interest\n- A conflict exists when the employee, officer, agent, or any of their family members, partners, or organizations they control has a financial or other interest in or a tangible personal benefit from a firm being considered for the contract\n- Violations must be referred to appropriate authorities\n\nDocument every procurement decision, including who participated in the evaluation and a certification that no conflicts of interest existed.',
  'SAM/UEI registration, debarment certification, lobbying, drug-free workplace, conflict of interest, and insider transaction rules are required for every USDA award.',
  20, 1, 'approved')
ON CONFLICT DO NOTHING;

-- QUIZ for Cert 10
INSERT INTO quizzes (id, certification_id, title, passing_score, status)
VALUES (uuid_generate_v4(), cert_id,
  'Federal Compliance, Civil Rights & 2 CFR 200 Knowledge Check',
  80, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO quiz_id FROM quizzes WHERE certification_id = cert_id;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order)
VALUES
(quiz_id,
  'Which statute prohibits discrimination in credit transactions on the basis of race, color, religion, national origin, sex, marital status, or age?',
  '[{"id":"a","text":"Title VI of the Civil Rights Act"},{"id":"b","text":"Equal Credit Opportunity Act (ECOA)"},{"id":"c","text":"Section 504 of the Rehabilitation Act"},{"id":"d","text":"ADA Title III"}]',
  'b',
  'ECOA (15 U.S.C. § 1691) prohibits discrimination in any aspect of a credit transaction on the basis of race, color, religion, national origin, sex, marital status, or age. Title VI covers federally assisted programs broadly but is not specific to credit transactions.',
  1),
(quiz_id,
  'An RMAP microlender denies a loan application. Under ECOA, an adverse action notice must be delivered within how many days?',
  '[{"id":"a","text":"10 days"},{"id":"b","text":"30 days"},{"id":"c","text":"60 days"},{"id":"d","text":"90 days"}]',
  'b',
  'Under ECOA and Regulation B, a written adverse action notice with specific reasons must be delivered within 30 days of a completed application or the credit decision.',
  2),
(quiz_id,
  'Under NEPA, a categorical exclusion (CE) means:',
  '[{"id":"a","text":"The project is exempt from all environmental review"},{"id":"b","text":"USDA has determined the category of action does not individually or cumulatively have a significant environmental effect"},{"id":"c","text":"The borrower has certified there are no environmental concerns"},{"id":"d","text":"The project is located in a rural area and therefore excluded from environmental rules"}]',
  'b',
  'A CE is a category of actions that USDA has determined by regulation do not have significant environmental effects. It requires completing a screening worksheet, but no full EA or EIS is needed.',
  3),
(quiz_id,
  'A Phase I Environmental Site Assessment is required for an RMAP microloan when:',
  '[{"id":"a","text":"The loan exceeds $25,000"},{"id":"b","text":"The borrower has been in business less than two years"},{"id":"c","text":"Real property is being used as collateral for the loan"},{"id":"d","text":"The loan is for working capital only"}]',
  'c',
  'A Phase I ESA is required when real property is involved as collateral, when the project involves purchase of real property, or when there is reason to believe a property has environmental concerns. Working capital loans with no real property collateral typically qualify for a categorical exclusion.',
  4),
(quiz_id,
  'Under NEPA, when must environmental clearance be obtained relative to obligating funds?',
  '[{"id":"a","text":"Within 30 days after the loan closes"},{"id":"b","text":"Before funds are obligated (committed) to a specific project"},{"id":"c","text":"Before the final loan payment is made"},{"id":"d","text":"Within 60 days of the environmental finding"}]',
  'b',
  'Environmental clearance must be obtained BEFORE funds are obligated. Signing a commitment letter or loan agreement before completing environmental review is a violation of NEPA timing requirements and a common audit finding.',
  5),
(quiz_id,
  'Under 2 CFR 200, the single audit threshold for non-federal entities is:',
  '[{"id":"a","text":"$500,000 in federal expenditures per fiscal year"},{"id":"b","text":"$750,000 in federal expenditures per fiscal year"},{"id":"c","text":"$1,000,000 in federal expenditures per fiscal year"},{"id":"d","text":"$250,000 in federal expenditures per fiscal year"}]',
  'b',
  'Under 2 CFR 200 Subpart F, any non-federal entity that expends $750,000 or more in federal awards during its fiscal year must have a single audit conducted by an independent auditor.',
  6),
(quiz_id,
  'Which of the following is an UNALLOWABLE cost under 2 CFR 200?',
  '[{"id":"a","text":"Staff salary for an employee working on the TA grant"},{"id":"b","text":"Office rent allocated to the grant-funded program"},{"id":"c","text":"Alcohol purchased for a staff appreciation event"},{"id":"d","text":"Travel to visit a microborrower at their business location"}]',
  'c',
  'Alcohol is explicitly unallowable under 2 CFR 200.423. Staff salaries, allocated rent, and client-related travel are allowable if allocable, reasonable, and properly documented.',
  7),
(quiz_id,
  'A Limited English Proficiency (LEP) plan is required under:',
  '[{"id":"a","text":"2 CFR 200.303"},{"id":"b","text":"Executive Order 13166"},{"id":"c","text":"ECOA Regulation B"},{"id":"d","text":"Section 504 of the Rehabilitation Act"}]',
  'b',
  'Executive Order 13166 (Improving Access to Services for Persons with Limited English Proficiency) requires federally assisted programs to take reasonable steps to ensure meaningful access for LEP individuals, including maintaining an LEP plan.',
  8),
(quiz_id,
  'Under 2 CFR 200 procurement standards, an informal procurement with 2+ price quotes is required for purchases between:',
  '[{"id":"a","text":"$0 and $10,000"},{"id":"b","text":"$10,000 and $250,000"},{"id":"c","text":"$250,000 and $500,000"},{"id":"d","text":"Any amount over $50,000"}]',
  'b',
  'The 2 CFR 200 micro-purchase threshold is $10,000 (no competition required if price is reasonable). Purchases from $10,000 to $250,000 require informal procurement with at least 2 price or rate quotes. Above $250,000 requires formal competitive procurement.',
  9),
(quiz_id,
  'SAM.gov registration must be renewed how often?',
  '[{"id":"a","text":"Every 6 months"},{"id":"b","text":"Annually"},{"id":"c","text":"Every 2 years"},{"id":"d","text":"Only at initial registration"}]',
  'b',
  'SAM.gov registrations expire after 12 months and must be renewed annually. A lapsed registration can delay or halt federal funding. Organizations should set calendar reminders 60 days before expiration.',
  10),
(quiz_id,
  'An organization''s board member has a financial interest in a company applying for an RLF loan. Under conflict of interest rules, the board member must:',
  '[{"id":"a","text":"Disclose the interest and vote in favor of the loan to demonstrate impartiality"},{"id":"b","text":"Recuse from all aspects of the loan decision and document the recusal in board minutes"},{"id":"c","text":"Notify USDA in writing within 90 days of the loan closing"},{"id":"d","text":"Reduce the loan amount by 25% to account for the conflict"}]',
  'b',
  'Under 2 CFR 200.112 and RLF conflict of interest policy requirements, a board member with a financial interest in an applicant must recuse from all aspects of the loan decision (discussion and vote) and the recusal must be documented in board minutes.',
  11),
(quiz_id,
  'Under the Byrd Amendment (31 U.S.C. § 1352), a lobbying certification is required for federal awards over:',
  '[{"id":"a","text":"$25,000"},{"id":"b","text":"$50,000"},{"id":"c","text":"$100,000"},{"id":"d","text":"$250,000"}]',
  'c',
  'The Byrd Amendment requires a lobbying certification for federal grants and loans over $100,000, certifying that no appropriated funds have been used to lobby Congress or federal officials in connection with the specific award.',
  12),
(quiz_id,
  'Which document establishes the basis for allocating shared costs among multiple programs?',
  '[{"id":"a","text":"The indirect cost rate agreement"},{"id":"b","text":"The Cost Allocation Plan (CAP)"},{"id":"c","text":"The single audit report"},{"id":"d","text":"The SF-425 federal financial report"}]',
  'b',
  'A Cost Allocation Plan (CAP) documents the methodology for allocating shared costs among multiple programs or funding sources. It must be written, consistently applied, and retained for audit.',
  13),
(quiz_id,
  'Under 2 CFR 200.334, records related to a federal award must be retained for how long after submission of the final financial report?',
  '[{"id":"a","text":"1 year"},{"id":"b","text":"2 years"},{"id":"c","text":"3 years"},{"id":"d","text":"5 years"}]',
  'c',
  'Under 2 CFR 200.334, records must be retained for 3 years from the date of submission of the final financial report for the award. Records must be retained longer if litigation, a claim, or audit is in progress.',
  14),
(quiz_id,
  'Which of the following best describes an insider transaction under RMAP rules?',
  '[{"id":"a","text":"A loan made to a borrower who has previously defaulted on another loan"},{"id":"b","text":"A loan made to an officer, director, board member, or their immediate family"},{"id":"c","text":"A loan that exceeds the $50,000 RMAP maximum"},{"id":"d","text":"A loan to a borrower outside the rural service area"}]',
  'b',
  'An insider transaction is a loan or financial transaction between the RLF and a person with an insider relationship to the organization — officers, directors, board members, key employees, or their immediate families. These are presumptively prohibited under 7 CFR 4280.',
  15)
ON CONFLICT DO NOTHING;

END $$;
