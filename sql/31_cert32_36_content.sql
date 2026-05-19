-- ============================================================
-- Cap Fund Academy — Cert 32–36 Content
-- Cert 32: Infrastructure, Energy, Transportation & Utility Finance
-- Cert 33: Export, Trade & International Sales Finance
-- Cert 34: Tribal & Native Lending Programs
-- Cert 35: Student Loan & Legacy Servicing Awareness
-- Cert 36: Capital Stack Design & Partnership Strategy
-- Run after: 27_cert_seeds_18_35.sql
-- ============================================================

DO $$
DECLARE
  v_cert uuid; v_mod uuid; v_quiz uuid;
BEGIN

-- ═══════════════════════════════════════════════════════════════
-- CERT 32: Infrastructure, Energy, Transportation & Utility Finance
-- ═══════════════════════════════════════════════════════════════
SELECT id INTO v_cert FROM certifications WHERE cert_number = 32;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert, 'Rural Infrastructure Finance: USDA, DOE & Broadband', 1, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert AND sort_order = 1; END IF;

INSERT INTO lessons (module_id, title, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'USDA Community Facilities, Rural Electric & Broadband Programs',
$$## USDA Community Facilities, Rural Electric & Broadband Programs

Rural infrastructure — hospitals, schools, fire stations, broadband networks, electric systems — requires long-term, patient capital that commercial markets often cannot provide. USDA's infrastructure finance programs fill this gap, financing billions in rural community facilities each year.

**Community Facilities Direct and Guaranteed Loans**
USDA's Community Facilities program (part of the OneRD platform) provides direct loans and loan guarantees for essential community facilities in rural areas. Eligible facilities include: hospitals, clinics, schools, public safety buildings, libraries, childcare centers, municipal buildings, and other essential services.

Direct loans are made by USDA itself at low interest rates. Guaranteed loans are made by approved private lenders with USDA guaranteeing 80-90% of the loan. Rural eligible areas (under 20,000 population) qualify. Interest rates for direct loans can be as low as the 10-year Treasury rate.

**Rural Electric Infrastructure: RUS Electric Programs**
USDA's Rural Utilities Service (RUS) provides loans, grants, and loan guarantees to rural electric cooperatives, utilities, and municipalities for generation, transmission, and distribution infrastructure. The Electric Program includes direct loans (at Treasury rate) and guaranteed loans for larger projects.

**USDA ReConnect Program**
ReConnect provides grants, loans, and loan-grant combinations to deploy broadband infrastructure in rural areas lacking sufficient service. Projects must serve rural areas where at least 90% of households lack broadband at 100/20 Mbps. Awards can range from $100,000 to $25 million, with larger amounts available for some applicants.

**Telecommunications and Distance Learning/Telemedicine Programs**
RUS also administers telecommunications loans for voice and data infrastructure, plus the Distance Learning and Telemedicine (DLT) grant program for rural broadband-enabled educational and healthcare services.

**Key Terms**
- **Community Facilities**: USDA program for essential community buildings and infrastructure.
- **RUS**: Rural Utilities Service — USDA agency for electric, telecom, and water programs.
- **ReConnect**: USDA program for rural broadband deployment.

**Practical Checklist**
- [ ] Identify critical community facilities in your service area that need capital
- [ ] Review USDA Community Facilities program eligibility requirements
- [ ] Research ReConnect program NOFAs at usda.gov/reconnect
- [ ] Identify rural electric cooperatives in your region and their capital needs
- [ ] Develop a community facilities capital stack template
$$, 1, 9, 'approved'),

(v_mod, 'DOE Energy Programs, DOT TIFIA/RRIF & Infrastructure Capital Stacks',
$$## DOE Energy Programs, DOT TIFIA/RRIF & Infrastructure Capital Stacks

Beyond USDA, several other federal agencies operate infrastructure lending programs for energy, transportation, and rural development. Understanding the full landscape enables community organizations to build comprehensive capital access strategies.

**DOE Title 17 Loan Guarantee Program**
The Department of Energy's Title 17 program provides loan guarantees for innovative energy technology projects — from utility-scale renewable energy to advanced manufacturing and clean energy storage. Projects must use new or significantly improved technologies. Loan terms up to 30 years. This program is typically not accessible to small rural organizations without significant scale and technical expertise, but it is an important tool for larger regional energy projects.

**DOE Rural Energy Savings Program (RESP)**
RESP provides zero-interest loans to electric cooperatives and similar entities to finance energy efficiency loans to rural households and businesses. The cooperative borrows from USDA at 0% interest and on-lends to end users for efficiency improvements — insulation, HVAC, lighting, and similar upgrades.

**DOE Tribal Energy Loan Guarantee Program (TELGP)**
Specifically designed for tribal governments and tribal enterprises, TELGP provides loan guarantees for energy infrastructure development on tribal lands — solar, wind, biomass, and energy efficiency projects. Maximum guarantee: 90%. A critical tool for tribal energy sovereignty.

**DOT TIFIA (Transportation Infrastructure Finance and Innovation Act)**
TIFIA provides credit assistance (loans, loan guarantees, standby lines of credit) for major transportation projects — highways, bridges, transit systems, rail, intermodal facilities, and port infrastructure. Minimum project size is $10 million for rural projects. TIFIA is a competitive program that requires significant project development and financial sophistication.

**DOT RRIF (Railroad Rehabilitation and Improvement Financing)**
RRIF provides direct loans and loan guarantees for railroad track improvement, equipment acquisition, and station rehabilitation. Short-line railroads in rural areas are the primary beneficiaries.

**Building a Rural Infrastructure Capital Stack**
Most rural infrastructure projects require multiple capital layers. A rural health clinic might stack: USDA Community Facilities guarantee (senior debt), State revolving fund or state agency loan (subordinate debt), USDA RBDG grant (equity replacement), New Markets Tax Credit equity, and CDFI loan fund participation.

**Key Terms**
- **TIFIA**: DOT's credit program for major transportation infrastructure.
- **RRIF**: DOT program for railroad rehabilitation and improvement.
- **Capital stack**: The combination of debt, equity, grants, and guarantees funding a single project.

**Practical Checklist**
- [ ] Identify infrastructure projects in your community that need gap financing
- [ ] Research TELGP for any tribal energy development in your area
- [ ] Review TIFIA minimum project eligibility for rural transportation needs
- [ ] Develop a capital stack template showing multiple infrastructure funding layers
- [ ] Identify state infrastructure banks in your state
$$, 2, 9, 'approved')
ON CONFLICT DO NOTHING;

INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert, 'Infrastructure, Energy, Transportation & Utility Finance Assessment', 75, 45, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, sort_order) VALUES
(v_quiz, 'USDA Community Facilities loans can finance which type of project?', 'Rural business operating expenses', 'Rural hospitals, schools, and essential community buildings', 'Agricultural land purchases', 'Urban transit systems', 'B', 'USDA Community Facilities finances essential community facilities in rural areas — hospitals, clinics, schools, public safety, libraries, and other critical community services.', 1),
(v_quiz, 'RUS stands for:', 'Rural Urban Services', 'Rural Utilities Service', 'Regional Underwriting System', 'Rural United States', 'B', 'RUS — Rural Utilities Service — is the USDA agency that administers electric, telecommunications, and water/waste programs for rural areas.', 2),
(v_quiz, 'What broadband speed threshold does USDA ReConnect use to define underserved rural areas?', '25/3 Mbps', '50/10 Mbps', '100/20 Mbps', '1 Gbps/100 Mbps', 'C', 'USDA ReConnect defines eligible areas as those where at least 90% of households lack broadband service at 100/20 Mbps (100 Mbps download / 20 Mbps upload).', 3),
(v_quiz, 'The DOE Tribal Energy Loan Guarantee Program (TELGP) is designed for:', 'Tribal government grant applications', 'Energy infrastructure on tribal lands with up to 90% loan guarantee', 'Urban solar energy projects', 'Agricultural energy conservation', 'B', 'TELGP provides loan guarantees of up to 90% for energy infrastructure development on tribal lands, specifically designed to support tribal energy sovereignty.', 4),
(v_quiz, 'The Rural Energy Savings Program (RESP) provides loans to cooperatives at what interest rate?', 'Market rate', 'Below-market rate set annually', 'Zero percent (0%)', 'The 10-year Treasury rate', 'C', 'RESP provides zero-interest loans to electric cooperatives and similar entities, which then on-lend to rural households and businesses for energy efficiency improvements.', 5),
(v_quiz, 'TIFIA is administered by which department?', 'USDA', 'DOE', 'Department of Transportation', 'Department of Commerce', 'C', 'TIFIA (Transportation Infrastructure Finance and Innovation Act) is administered by the U.S. Department of Transportation, providing credit assistance for major transportation infrastructure projects.', 6),
(v_quiz, 'What is the minimum project size for rural TIFIA credit assistance?', '$1 million', '$5 million', '$10 million', '$50 million', 'C', 'TIFIA has a minimum project size of $10 million for rural projects — lower than the $50 million minimum for non-rural projects, but still requiring significant project scale.', 7),
(v_quiz, 'DOT RRIF financing is primarily used for:', 'Highway bridge replacement', 'Railroad rehabilitation and improvement', 'Port infrastructure development', 'Airport runway upgrades', 'B', 'RRIF (Railroad Rehabilitation and Improvement Financing) provides direct loans and guarantees specifically for railroad track improvement, equipment, and related infrastructure.', 8),
(v_quiz, 'A rural hospital project wants to stack multiple capital sources. Which combination is most appropriate?', 'SBA 7(a) + NMTC + USDA Community Facilities + CDFI loan', 'RMAP + IRP + RBDG + federal grant', 'FHA Title II + VA + USDA Section 502', 'TIFIA + RRIF + DOE Title 17', 'A', 'A rural hospital project would typically stack USDA Community Facilities guaranteed debt, New Markets Tax Credit equity, CDFI loan fund participation, and potentially state grants — all sources designed for essential facility projects.', 9),
(v_quiz, 'USDA Community Facilities direct loans are made at approximately what interest rate?', 'Prime rate plus 2%', 'The current 10-year Treasury rate', 'SBA base rate', 'Federal funds rate', 'B', 'USDA Community Facilities direct loan rates are based on the current 10-year Treasury rate — among the lowest long-term borrowing rates available to rural communities.', 10)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- CERT 33: Export, Trade & International Sales Finance
-- ═══════════════════════════════════════════════════════════════
SELECT id INTO v_cert FROM certifications WHERE cert_number = 33;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert, 'Export Finance Programs: EXIM & SBA', 1, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert AND sort_order = 1; END IF;

INSERT INTO lessons (module_id, title, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'EXIM Bank & SBA Export Programs: Tools for Small Business Exporters',
$$## EXIM Bank & SBA Export Programs: Tools for Small Business Exporters

Export finance helps American businesses sell goods and services internationally by providing working capital for production, protecting against non-payment risk, and financing foreign buyer purchases. Two federal agencies lead export finance for small businesses: the Export-Import Bank of the United States (EXIM) and the Small Business Administration (SBA).

**Export-Import Bank (EXIM) of the United States**
EXIM is the official U.S. export credit agency. It provides working capital guarantees, export credit insurance, and buyer financing to help U.S. businesses compete in global markets.

Key EXIM programs for small businesses:
- **Working Capital Guarantee**: Guarantees loans made by commercial lenders to U.S. exporters for pre-export working capital. Lender makes the loan; EXIM guarantees up to 90%.
- **Export Credit Insurance**: Protects exporters against non-payment by foreign buyers due to commercial or political risk.
- **Medium and Long-Term Guarantees**: For larger export transactions where the foreign buyer needs financing for the purchase.

**SBA Export Programs**
SBA offers three export-specific programs within the 7(a) framework:
- **SBA Export Express**: Fast-turnaround working capital and fixed assets for exporters up to $500,000. 90% SBA guarantee.
- **SBA Export Working Capital Program (EWCP)**: Transaction-based revolving credit for exporters with specific export purchase orders. Up to $5 million.
- **SBA International Trade Loan (ITL)**: For businesses that face competition from imports OR are expanding into export markets. Long-term financing up to $5 million.

**USDA/FAS Agricultural Export Programs**
The USDA Foreign Agricultural Service (FAS) administers several programs supporting agricultural exports:
- **GSM-102 Export Credit Guarantee**: A payment guarantee for sales of U.S. agricultural products to foreign buyers. Covers lender risk on the buyer's financing.
- **Facility Guarantee Program**: For agricultural infrastructure in emerging markets.

**Building a Finance Pathway for an Exporter**
For a small business beginning to export: (1) identify the SBA program that fits the transaction size and need; (2) connect with an SBA Export Lender or EXIM-authorized lender in your region; (3) refer to your state's export assistance center (U.S. Export Assistance Center) for holistic export support including market research, trade missions, and regulatory guidance.

**Key Terms**
- **Export credit insurance**: Insurance protecting exporters if foreign buyers default.
- **EWCP**: SBA Export Working Capital Program — revolving credit backed by export orders.
- **EXIM**: Export-Import Bank — the U.S. government's official export credit agency.

**Practical Checklist**
- [ ] Identify exporters in your network who need export working capital
- [ ] Locate the nearest U.S. Export Assistance Center at export.gov
- [ ] Review SBA Export Express eligibility requirements
- [ ] Connect with EXIM-authorized lenders in your region
- [ ] Learn the USDA GSM-102 program for agricultural exporters
$$, 1, 9, 'approved')
ON CONFLICT DO NOTHING;

INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert, 'Export, Trade & International Sales Finance Assessment', 75, 40, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, sort_order) VALUES
(v_quiz, 'EXIM Bank''s primary mission is to:', 'Regulate international banks operating in the U.S.', 'Help U.S. businesses sell goods and services internationally through financing tools', 'Provide domestic small business loans', 'Manage the U.S. trade deficit', 'B', 'EXIM Bank is the U.S. government''s official export credit agency, helping U.S. businesses compete internationally through working capital guarantees, credit insurance, and buyer financing.', 1),
(v_quiz, 'What does EXIM''s Working Capital Guarantee protect the lender against?', 'Currency exchange rate changes', 'Exporter default on the pre-export working capital loan', 'Foreign government interference', 'Product quality disputes', 'B', 'EXIM''s Working Capital Guarantee protects the commercial lender if the exporter defaults on the working capital loan used to produce or procure goods for export.', 2),
(v_quiz, 'Which SBA program provides the fastest turnaround for exporter working capital?', 'SBA International Trade Loan', 'SBA Export Working Capital Program', 'SBA Export Express', 'SBA CAPLine', 'C', 'SBA Export Express uses the lender''s own underwriting with SBA''s streamlined approval — fast turnaround for working capital and fixed assets up to $500,000 for exporters.', 3),
(v_quiz, 'The SBA Export Working Capital Program is based on:', 'The exporter''s credit score alone', 'Specific export purchase orders and receivables', 'Fixed assets pledged as collateral', 'Three years of financial statements', 'B', 'The EWCP is transaction-based — credit availability is tied to actual export purchase orders and eligible receivables, not just the company''s overall financials.', 4),
(v_quiz, 'What is export credit insurance?', 'Insurance protecting foreign buyers from U.S. export fraud', 'Insurance protecting U.S. exporters if foreign buyers fail to pay', 'A type of cargo insurance for international shipments', 'A guarantee on EXIM''s own loan portfolio', 'B', 'Export credit insurance protects U.S. exporters against non-payment by foreign buyers due to commercial risk (buyer insolvency) or political risk (government interference, war, etc.).', 5),
(v_quiz, 'The SBA International Trade Loan is designed for businesses that:', 'Export agricultural products only', 'Face competition from imports or are expanding into export markets', 'Are starting their first international transaction', 'Need working capital for domestic operations', 'B', 'The SBA ITL serves businesses facing import competition OR expanding into export markets — addressing both sides of the trade challenge for American small businesses.', 6),
(v_quiz, 'USDA GSM-102 is a program that:', 'Provides loans to U.S. agricultural producers', 'Guarantees payment to U.S. lenders on sales of U.S. agricultural products to foreign buyers', 'Funds rural energy projects', 'Supports USDA water infrastructure', 'B', 'USDA GSM-102 is an export credit guarantee program — it guarantees U.S. bank payment if a foreign buyer''s bank fails to pay for U.S. agricultural exports.', 7),
(v_quiz, 'U.S. Export Assistance Centers are part of which agency?', 'SBA exclusively', 'EXIM Bank exclusively', 'A partnership of Commerce, SBA, and EXIM', 'Department of State', 'C', 'U.S. Export Assistance Centers are a partnership among the U.S. Department of Commerce (trade specialists), SBA (export loan programs), and EXIM Bank (credit tools) — providing a one-stop shop for exporters.', 8),
(v_quiz, 'What is the maximum SBA Export Working Capital Program loan size?', '$500,000', '$1 million', '$2.5 million', '$5 million', 'D', 'The SBA Export Working Capital Program provides revolving credit up to $5 million, backed by specific export purchase orders and receivables.', 9),
(v_quiz, 'A small manufacturer wants to fulfill a large foreign purchase order but lacks working capital. Which program is most appropriate?', 'USDA RMAP', 'SBA Export Working Capital Program or EXIM Working Capital Guarantee', 'FHA Title II mortgage', 'EDA Revolving Loan Fund', 'B', 'The SBA EWCP and EXIM Working Capital Guarantee are specifically designed for exporters who need pre-export working capital to fulfill purchase orders from foreign buyers.', 10)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- CERT 34: Tribal & Native Lending Programs
-- ═══════════════════════════════════════════════════════════════
SELECT id INTO v_cert FROM certifications WHERE cert_number = 34;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert, 'Tribal Capital Access: BIA, Native CDFIs & Sovereignty', 1, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert AND sort_order = 1; END IF;

INSERT INTO lessons (module_id, title, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'BIA Indian Loan Guarantee and Native CDFI Programs',
$$## BIA Indian Loan Guarantee and Native CDFI Programs

Access to capital in tribal communities faces unique legal, historical, and structural barriers. Tribal trust land, sovereign immunity, limited credit infrastructure, and geographic isolation have historically limited the flow of private capital to Native communities. A growing ecosystem of federal programs and Native CDFIs is working to change this.

**BIA Indian Loan Guarantee and Insurance Program**
The Bureau of Indian Affairs (BIA) operates the Indian Loan Guarantee and Insurance Program, which provides loan guarantees for loans made to federally recognized tribes, Alaska Native entities, individual Indians, and businesses with at least 51% Indian ownership. The guarantee can be up to 90% of the loan amount.

Eligible purposes include: business acquisition, expansion, equipment, real estate (where tribal land can be used as collateral with proper authorization), and working capital. Lenders interested in using BIA guarantees must apply through the appropriate BIA regional office.

**Native CDFIs**
Native CDFIs are community development financial institutions that are led by, accountable to, and primarily serving Native communities. The CDFI Fund's Native American CDFI Assistance (NACA) program provides specialized grants and technical assistance to Native CDFIs.

Native CDFIs operate in some of the most underserved financial environments in the United States — often the only capital providers within hundreds of miles. They face unique challenges: limited credit data on borrowers, complex collateral issues on trust land, and borrowers with limited prior lending experience.

**Tribal SSBCI**
Tribal governments received direct SSBCI allocations in the 2021 American Rescue Plan. Tribal SSBCI programs operate similarly to state programs — loan participation, loan guarantees, collateral support, capital access programs, and venture capital — but are administered directly by tribal governments.

**Sovereignty Considerations**
Tribal sovereign immunity can complicate lending — lenders cannot sue tribal governments in state courts without the tribe's consent to waive sovereign immunity. For loans to tribal businesses or enterprises (as opposed to individual tribal members), lenders typically require limited waivers of sovereign immunity for the specific lending transaction.

**Cultural Humility in Lending**
Effective lending in Native communities requires genuine cultural competency — understanding tribal governance structures, community decision-making processes, the historical context of federal programs, and building relationships based on trust rather than transaction.

**Key Terms**
- **BIA**: Bureau of Indian Affairs — the federal agency for tribal affairs, including the loan guarantee program.
- **Native CDFI**: A CDFI led by and primarily serving Native American, Alaska Native, or Native Hawaiian communities.
- **Sovereign immunity**: A tribal government's legal protection from lawsuits without its consent.

**Practical Checklist**
- [ ] Identify Native CDFIs operating in your region at nativecdfi.net
- [ ] Review BIA loan guarantee program requirements at bia.gov
- [ ] Research whether tribal governments in your area received SSBCI allocations
- [ ] Develop a cultural competency training plan for your lending staff
- [ ] Connect with the CDFI Fund's Native Initiatives team for guidance
$$, 1, 10, 'approved')
ON CONFLICT DO NOTHING;

INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert, 'Tribal & Native Lending Programs Assessment', 75, 45, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, sort_order) VALUES
(v_quiz, 'Which federal agency administers the Indian Loan Guarantee and Insurance Program?', 'USDA Rural Development', 'Bureau of Indian Affairs (BIA)', 'HUD', 'SBA', 'B', 'The BIA Indian Loan Guarantee and Insurance Program is administered by the Bureau of Indian Affairs within the Department of the Interior.', 1),
(v_quiz, 'What minimum ownership percentage must a business have to qualify for a BIA loan guarantee as an Indian-owned business?', '25%', '51%', '75%', '100%', 'B', 'Businesses must be at least 51% owned by individuals who are members of federally recognized tribes or Alaska Natives to qualify for BIA loan guarantees.', 2),
(v_quiz, 'NACA stands for:', 'Native American Community Association', 'Native American CDFI Assistance Program', 'National Agency for Capital Access', 'Native American Credit Alliance', 'B', 'NACA — Native American CDFI Assistance Program — is the CDFI Fund''s program providing grants and technical assistance specifically to CDFIs that primarily serve Native communities.', 3),
(v_quiz, 'Tribal sovereign immunity primarily affects lending by:', 'Making tribal interest rates lower', 'Protecting tribes from lawsuits in state courts without their consent', 'Giving tribes priority access to federal programs', 'Exempting tribes from federal tax obligations', 'B', 'Tribal sovereign immunity means lenders cannot sue tribal governments in state courts without the tribe''s voluntary waiver — complicating standard loan enforcement and requiring specific legal protections.', 4),
(v_quiz, 'What is a limited waiver of sovereign immunity in the lending context?', 'A tribe''s consent to be sued in tribal court for a specific transaction', 'A tribe''s agreement that the lender can use federal courts for the specific lending transaction', 'A permanent agreement to waive all sovereign protections', 'An exemption from federal lending regulations', 'B', 'A limited waiver of sovereign immunity is a tribal consent — limited to a specific transaction — allowing the lender to enforce the loan in an agreed-upon jurisdiction (often federal court or tribal court) if the borrower defaults.', 5),
(v_quiz, 'What is the maximum BIA loan guarantee percentage?', '70%', '80%', '90%', '100%', 'C', 'BIA can guarantee up to 90% of qualifying loans made to eligible Native American borrowers and businesses.', 6),
(v_quiz, 'A major barrier to conventional mortgage lending on tribal trust land is:', 'Native borrowers'' low incomes', 'The inability to obtain title insurance and foreclose through standard processes', 'Federal laws prohibiting mortgage lending in tribal areas', 'Lack of credit reporting for Native borrowers', 'B', 'Tribal trust land cannot be alienated or foreclosed without federal approval, and title insurance is typically unavailable — making conventional mortgage lending impractical without specialized programs like HUD Section 184.', 7),
(v_quiz, 'Cultural humility in Native community lending includes:', 'Applying standard underwriting criteria without modification', 'Understanding tribal governance, historical context, and building trust-based relationships', 'Requiring tribal borrowers to use non-tribal advisors', 'Limiting loans to individual tribal members only', 'B', 'Effective lending in Native communities requires genuine cultural competency — understanding tribal decision-making processes, historical trauma from federal programs, and building authentic community relationships.', 8),
(v_quiz, 'Tribal SSBCI programs are administered by:', 'State economic development agencies on behalf of tribes', 'Tribal governments that received direct SSBCI allocations from Treasury', 'BIA on behalf of tribal governments', 'SBA district offices', 'B', 'The 2021 American Rescue Plan provided direct SSBCI allocations to tribal governments — unlike state SSBCI programs, tribal SSBCI is administered directly by the tribal government.', 9),
(v_quiz, 'Which organization directory is the best resource for finding Native CDFIs?', 'SBA''s lender finder tool', 'nativecdfi.net', 'USDA Rural Development directory', 'FDIC bank locator', 'B', 'The Native CDFI Network (nativecdfi.net) maintains a directory of CDFIs serving Native communities across the United States, Alaska, and Hawaii.', 10)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- CERT 35: Student Loan & Legacy Servicing Awareness
-- ═══════════════════════════════════════════════════════════════
SELECT id INTO v_cert FROM certifications WHERE cert_number = 35;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert, 'Federal Student Loan Programs: History and Awareness', 1, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert AND sort_order = 1; END IF;

INSERT INTO lessons (module_id, title, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'Why Federal Student Lending Is Not a New Private Lender Pathway',
$$## Why Federal Student Lending Is Not a New Private Lender Pathway

Many organizations exploring capital access opportunities ask about student loan lending. This lesson provides essential awareness: federal student lending is a closed, government-direct system — not a pathway for new private or community lenders to originate federally backed student loans.

**The Federal Direct Loan Program**
Since 2010, all new federal student loans have been originated directly by the U.S. Department of Education through the William D. Ford Federal Direct Loan Program. Students apply through FAFSA; the Department originates, disburses, and services the loans through contracted federal servicers. There is no private lender, CDFI, bank, or nonprofit intermediary that can originate new federal student loans. This pathway is closed to new entrants.

**The Legacy FFEL Portfolio**
Prior to 2010, federal student loans were made through the Federal Family Education Loan (FFEL) program — a model where private lenders originated student loans with federal guarantees. FFEL was discontinued for new loans in 2010, but a large portfolio of existing FFEL loans remains outstanding, serviced by private companies under contract.

**Perkins Loans**
The Federal Perkins Loan program allowed colleges and universities to originate campus-based student loans. The program ended in 2017. Existing Perkins loan portfolios are managed by institutions themselves or assigned to servicers.

**What Community Organizations Can Do**
While you cannot originate new federal student loans, community organizations can:
- Provide student loan counseling and financial literacy education
- Help borrowers navigate income-driven repayment options and Public Service Loan Forgiveness
- Refer students to institutional aid counselors and financial aid offices
- Offer emergency assistance and bridge loans for students in financial crisis
- Advocate for student loan policy reform

**Private Student Loans**
Private student loans (originated by banks, credit unions, and fintech lenders) are a separate market. CDFIs and community lenders can originate private student loans, but without federal insurance they carry full credit risk. Organizations should carefully assess this market before entering.

**Key Terms**
- **Federal Direct Loan**: The current federal student loan program — Department of Education is the lender.
- **FFEL**: Federal Family Education Loan — discontinued private-lender model.
- **Servicer**: A company contracted by the Department of Education to manage loan repayment.

**Practical Checklist**
- [ ] Develop a student loan awareness resource for your community
- [ ] Train staff on income-driven repayment options and PSLF eligibility
- [ ] Build a referral list of college financial aid offices and student loan counselors
- [ ] Review whether any clients have FFEL or Perkins loans requiring special attention
- [ ] Assess whether private student lending fits your organization''s mission and risk tolerance
$$, 1, 7, 'approved')
ON CONFLICT DO NOTHING;

INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert, 'Student Loan & Legacy Servicing Awareness Assessment', 75, 30, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, sort_order) VALUES
(v_quiz, 'Who originates all new federal student loans since 2010?', 'Approved private banks and credit unions', 'The U.S. Department of Education through the Direct Loan Program', 'CDFIs certified by the CDFI Fund', 'State student loan authorities', 'B', 'Since 2010, all new federal student loans are originated directly by the U.S. Department of Education — private lenders cannot originate new federally backed student loans.', 1),
(v_quiz, 'FFEL stands for:', 'Federal Finance for Educational Loans', 'Federal Family Education Loan Program', 'Federal Fund for Educational Lending', 'Federal Fintech Education Loan', 'B', 'FFEL — Federal Family Education Loan Program — was the pre-2010 model where private lenders originated student loans with federal guarantees. The program ended for new loans in 2010.', 2),
(v_quiz, 'Can a CDFI originate new federally backed student loans?', 'Yes, if they obtain CDFI Fund certification', 'Yes, if they partner with an approved lender', 'No, federal student loan origination is closed to new private or community lenders', 'Yes, if they operate in a low-income area', 'C', 'The Federal Direct Loan Program is a closed government-direct system. No new private lenders, CDFIs, or nonprofits can originate federally backed student loans.', 3),
(v_quiz, 'The Perkins Loan program ended for new loans in:', '2010', '2015', '2017', '2020', 'C', 'The Federal Perkins Loan program ended in September 2017 — no new Perkins Loans can be made, though existing portfolios remain outstanding.', 4),
(v_quiz, 'What can community organizations constructively do in the student lending space?', 'Originate federally guaranteed student loans', 'Provide counseling, referrals, and advocacy to help borrowers navigate repayment options', 'Apply to become federal student loan servicers', 'Petition SBA for student loan guarantee authority', 'B', 'Community organizations add value by providing student loan counseling, helping borrowers navigate income-driven repayment and PSLF, and referring students to appropriate institutional resources.', 5),
(v_quiz, 'PSLF stands for:', 'Private Student Loan Forgiveness', 'Public Service Loan Forgiveness', 'Perkins Student Loan Forgiveness', 'Post-Secondary Lending Fund', 'B', 'PSLF — Public Service Loan Forgiveness — forgives remaining federal student loan balances after 10 years of qualifying payments while working for a qualifying public service employer.', 6),
(v_quiz, 'Private student loans differ from federal student loans in that they:', 'Are eligible for income-driven repayment', 'Carry full credit risk without federal insurance or guarantee', 'Are originated by the Department of Education', 'Qualify for PSLF forgiveness', 'B', 'Private student loans lack federal backing — lenders bear the full credit risk. They typically have higher interest rates and fewer repayment options than federal loans.', 7),
(v_quiz, 'Who services the existing portfolio of FFEL loans?', 'U.S. Department of Education directly', 'Private companies contracted by the Department of Education', 'The original FFEL lenders', 'State student loan authorities', 'B', 'Existing FFEL loans are serviced by private companies (student loan servicers) under contract with the Department of Education — the original private lenders no longer service these loans.', 8),
(v_quiz, 'A community member asks your organization for help with their student loans. What is the best response?', 'Offer to refinance their federal loans through your CDFI', 'Refer them to a HUD-approved housing counselor for student loan advice', 'Provide student loan counseling, connect them with income-driven repayment options, and refer to their loan servicer', 'Tell them student loans are not your area and offer no assistance', 'C', 'Community organizations can provide genuine value by educating borrowers about their repayment options (IDR, PSLF), helping them contact their servicer, and providing financial counseling — even without being able to originate loans.', 9),
(v_quiz, 'Which of the following is a legitimate private student lending opportunity for CDFIs?', 'Originating FFEL loans under the legacy program', 'Originating private student loans (without federal backing) to community members', 'Partnering with the Department of Education to issue Direct Loans', 'Refinancing Perkins Loans into the Direct Loan program', 'B', 'CDFIs and community lenders can originate private student loans bearing full credit risk. This is a legitimate market opportunity but requires careful assessment of credit risk and mission alignment.', 10)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- CERT 36: Capital Stack Design & Partnership Strategy
-- ═══════════════════════════════════════════════════════════════
SELECT id INTO v_cert FROM certifications WHERE cert_number = 36;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert, 'Capital Stack Fundamentals', 1, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert AND sort_order = 1; END IF;

INSERT INTO lessons (module_id, title, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'Understanding the Capital Stack: Grant, Debt, Equity & Guarantees',
$$## Understanding the Capital Stack: Grant, Debt, Equity & Guarantees

A capital stack is the combination of all financing sources that fund a single project or enterprise. Understanding how to design and build effective capital stacks is one of the most critical skills for community lending professionals — it determines whether projects get built, what they cost, and whether they serve the community long-term.

**The Four Layers of Capital**

**1. Grant Capital**
Grants are non-repayable funds from government agencies, foundations, or corporations. They sit at the bottom of the risk spectrum — donors don't expect repayment. Grants function like equity in a capital stack: they absorb risk, reduce the debt burden, and make otherwise infeasible projects viable.

Sources: USDA RBDG, EDA grants, CDBG, HOME, HUD grants, foundation grants, state development grants, SBIR/STTR.

**2. Debt Capital**
Loans must be repaid with interest. Debt is typically structured in priority layers:
- **Senior debt**: First claim on collateral. Lowest risk, lowest interest rate. Usually the largest portion.
- **Subordinate debt**: Second claim on collateral. Higher risk, higher rate. Often from CDFIs, state programs, or mission investors.
- **Mezzanine**: Hybrid between debt and equity. May include participation in upside or conversion rights.

**3. Equity Capital**
Equity represents ownership interest. In a business, equity investors share in profits and losses. In real estate, equity covers the portion not financed by debt. Equity sources include: developer equity, investor equity, Low-Income Housing Tax Credits, New Markets Tax Credits, Opportunity Zone investments, and mission investors.

**4. Guarantees and Credit Enhancements**
Guarantees (SBA, USDA, BIA, state) reduce the risk of debt by promising to cover losses if a borrower defaults. Credit enhancements don't provide capital directly — they improve the terms on which capital can be raised.

**The Project Finance Principle**
Every source of capital has a cost, a risk expectation, and a use requirement. Grant capital is cheapest but restricted. Debt must be serviced from operating cash flow. Equity expects returns. Guarantees have fees. The art of capital stack design is matching the right capital to the right use — minimizing cost while meeting every source's requirements.

**Key Terms**
- **Senior debt**: First-priority debt with first claim on collateral in case of default.
- **Credit enhancement**: A mechanism that improves the terms on which debt can be raised (guarantees, reserves, subordinated capital).
- **LIHTC**: Low-Income Housing Tax Credit — the primary equity source for affordable housing.

**Practical Checklist**
- [ ] Map one real project in your community that needs multiple capital sources
- [ ] Identify which federal programs could provide grants, debt, or guarantees
- [ ] Calculate the debt service coverage for your hypothetical capital stack
- [ ] Identify two to three private capital sources that could provide subordinated debt
- [ ] Develop a template for presenting capital stacks to prospective investors
$$, 1, 10, 'approved'),

(v_mod, 'Partner Pitch Strategy & Building a Funding Source Matrix',
$$## Partner Pitch Strategy & Building a Funding Source Matrix

Knowing what capital sources exist is only half the battle. The other half is building relationships with capital providers, presenting compelling investment opportunities, and creating systems to track funding opportunities across multiple programs and sources.

**CRA Bank Partnerships**
The Community Reinvestment Act (CRA) requires banks to meet the credit needs of all communities in their service area, including low- and moderate-income neighborhoods. Banks earn CRA credit for: direct loans to small businesses and community development organizations, investments in CDFIs, LIHTC, and NMTC projects, and grants to community development organizations.

Building relationships with CRA officers at local and regional banks is one of the most productive strategies for CDFIs and RLF operators. Banks need CRA credit; you need capital. Offer them loans to your fund, investments in your NMTC allocation, and deposit accounts in underserved communities.

**Philanthropic Capital**
Foundations and philanthropic investors provide Program-Related Investments (PRIs) — below-market-rate loans or equity investments that serve the foundation's charitable purpose. PRIs count toward a foundation's required 5% annual distribution and represent patient, flexible capital.

Mission-related investments (MRIs) are similar but made from a foundation's endowment — not required to be below-market, but aligned with mission. Both PRIs and MRIs are growing sources of capital for CDFIs and community lending organizations.

**Public-Sector Partnerships**
Local governments, economic development agencies, and state programs are important capital partners. Build relationships with: city/county economic development departments, state capital access program administrators, USDA state offices, SBA district offices, and regional planning organizations.

**The Funding Source Matrix**
A funding source matrix is a structured document mapping every potential capital source to the project types it funds, eligible borrowers, typical amounts, application cycles, and contact information. Maintain an updated matrix for your service area — it becomes an invaluable tool for quickly identifying capital options for specific projects.

**Key Terms**
- **CRA**: Community Reinvestment Act — federal requirement for banks to serve all communities.
- **PRI**: Program-Related Investment — a below-market-rate foundation investment for charitable purposes.
- **Funding source matrix**: A structured database of capital sources, eligibility requirements, and application cycles.

**Practical Checklist**
- [ ] Identify CRA officers at 5 banks operating in your service area
- [ ] Build a one-page CRA investment pitch for your organization
- [ ] Research foundations in your region that make PRIs or MRIs
- [ ] Create a funding source matrix for your region and capital type
- [ ] Develop a quarterly calendar of capital source application deadlines
$$, 2, 9, 'approved')
ON CONFLICT DO NOTHING;

INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert, 'Capital Stack Design & Partnership Strategy Assessment', 80, 50, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, sort_order) VALUES
(v_quiz, 'In a capital stack, which layer carries the highest risk?', 'Senior debt', 'Grant capital', 'Equity', 'Government guarantees', 'C', 'Equity sits at the bottom of the repayment priority — equity investors are last to be paid in a liquidation, absorbing the most risk. In exchange, they share in upside returns.', 1),
(v_quiz, 'What is "senior debt" in a capital stack?', 'The largest debt tranche regardless of priority', 'First-priority debt with the first claim on collateral in case of default', 'A government-guaranteed loan', 'The most expensive layer of financing', 'B', 'Senior debt has the highest repayment priority — in a default, senior lenders are paid first from collateral before subordinate lenders or equity investors receive anything.', 2),
(v_quiz, 'Grant capital is described as "equity" in a capital stack because:', 'It earns the highest returns', 'It is non-repayable and absorbs risk, similar to equity investment', 'It must be repaid if the project succeeds', 'It is owned by the government', 'B', 'Grant capital is non-repayable — like equity, it does not need to be serviced from cash flow. In a loss, grants are absorbed before debt. This risk-absorbing function is why grants are analogous to equity.', 3),
(v_quiz, 'CRA stands for:', 'Capital Revolving Account', 'Community Reinvestment Act', 'Certified Resource Administrator', 'Capital Resource Allocation', 'B', 'The Community Reinvestment Act requires regulated banks to meet the credit needs of all communities in their service area, including low- and moderate-income areas.', 4),
(v_quiz, 'A Program-Related Investment (PRI) is made by:', 'Government agencies for infrastructure projects', 'Foundations from their program budget, at below-market rates, for charitable purposes', 'Commercial banks seeking CRA credit', 'CDFI Fund for certified CDFIs', 'B', 'PRIs are foundation investments made at below-market rates from their program budget — they count toward the foundation''s required 5% annual distribution while supporting charitable purposes.', 5),
(v_quiz, 'What is the LIHTC?', 'A federal tax deduction for landlords', 'Low-Income Housing Tax Credit — the primary equity source for affordable housing', 'A local housing assistance program', 'A USDA rural housing loan program', 'B', 'LIHTC (Low-Income Housing Tax Credit) is the primary federal subsidy for affordable housing development, providing equity to developers in exchange for making units affordable to low-income renters for 30+ years.', 6),
(v_quiz, 'A funding source matrix is best described as:', 'A spreadsheet of all your borrowers and their loan terms', 'A structured document mapping capital sources to eligible uses, amounts, and application cycles', 'A grant application tracking tool', 'A borrower credit scoring system', 'B', 'A funding source matrix is a strategic resource document mapping every capital source in your area to its requirements, typical amounts, application cycles, and contacts — enabling rapid identification of capital options for specific projects.', 7),
(v_quiz, 'In a $10 million affordable housing project capital stack, what is the role of the subordinate CDFI loan?', 'It is the largest debt layer with first claim on collateral', 'It fills the gap between senior debt and grant/equity, taking second position at a higher rate', 'It replaces the bank loan', 'It provides working capital for operations', 'B', 'Subordinate (mezzanine) debt from CDFIs fills the gap in a project''s capital stack, accepting second-position collateral and higher interest rates in exchange for enabling projects that senior lenders alone cannot fund.', 8),
(v_quiz, 'What is a Mission-Related Investment (MRI)?', 'A PRI from a foundation''s program budget', 'An investment made from a foundation''s endowment, aligned with its mission', 'A government grant for community development', 'A state capital access program', 'B', 'MRIs are investments made from a foundation''s endowment (not program budget) that align with the foundation''s mission — they are not required to be below-market but represent growing source of capital for community development.', 9),
(v_quiz, 'The most productive reason for a CDFI to build relationships with CRA officers at local banks is:', 'To receive regulatory approval for new lending programs', 'Because banks need CRA credit and CDFIs can offer investments, loans, and CRA-qualified deposits', 'To gain access to Federal Reserve borrowing facilities', 'To replace the CDFI''s foundation funding', 'B', 'Banks have CRA obligations to fulfill and need documented community development investments — CDFIs can offer them exactly what they need (investments in CDFI funds, LIHTC equity, CRA-qualified loans) in exchange for the capital CDFIs need.', 10)
ON CONFLICT DO NOTHING;

END $$;
