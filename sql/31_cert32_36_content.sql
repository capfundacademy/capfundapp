-- ============================================================
-- Cap Fund Academy — Cert 32–36 Content
-- Cert 32: Infrastructure, Energy, Transportation & Utility Finance
-- Cert 33: Export, Trade & International Sales Finance
-- Cert 34: Tribal & Native Lending Programs
-- Cert 35: Student Loan & Legacy Servicing Awareness
-- Cert 36: Capital Stack Design & Partnership Strategy
-- Run after: 27_cert_seeds_18_35.sql
-- ============================================================

DO $block$
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

INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'USDA Community Facilities, Rural Electric & Broadband Programs', 'usda-community-facilities-rural-electric-broadband-programs',
$BODY$## USDA Community Facilities, Rural Electric & Broadband Programs

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
$BODY$, 1, 9, 'approved'),

(v_mod, 'DOE Energy Programs, DOT TIFIA/RRIF & Infrastructure Capital Stacks', 'doe-energy-programs-dot-tifiarrif-infrastructure-capital-stacks',
$BODY$## DOE Energy Programs, DOT TIFIA/RRIF & Infrastructure Capital Stacks

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
$BODY$, 2, 9, 'approved')
ON CONFLICT DO NOTHING;

INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert, 'Infrastructure, Energy, Transportation & Utility Finance Assessment', 75, 45, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order) VALUES
(v_quiz, 'USDA Community Facilities loans can finance which type of project?', '[{"id":"a","text":"Rural business operating expenses"},{"id":"b","text":"Rural hospitals, schools, and essential community buildings"},{"id":"c","text":"Agricultural land purchases"},{"id":"d","text":"Urban transit systems"}]', 'b', 'USDA Community Facilities finances essential community facilities in rural areas — hospitals, clinics, schools, public safety, libraries, and other critical community services.', 1),
(v_quiz, 'RUS stands for:', '[{"id":"a","text":"Rural Urban Services"},{"id":"b","text":"Rural Utilities Service"},{"id":"c","text":"Regional Underwriting System"},{"id":"d","text":"Rural United States"}]', 'b', 'RUS — Rural Utilities Service — is the USDA agency that administers electric, telecommunications, and water/waste programs for rural areas.', 2),
(v_quiz, 'What broadband speed threshold does USDA ReConnect use to define underserved rural areas?', '[{"id":"a","text":"25/3 Mbps"},{"id":"b","text":"50/10 Mbps"},{"id":"c","text":"100/20 Mbps"},{"id":"d","text":"1 Gbps/100 Mbps"}]', 'c', 'USDA ReConnect defines eligible areas as those where at least 90% of households lack broadband service at 100/20 Mbps (100 Mbps download / 20 Mbps upload).', 3),
(v_quiz, 'The DOE Tribal Energy Loan Guarantee Program (TELGP) is designed for:', '[{"id":"a","text":"Tribal government grant applications"},{"id":"b","text":"Energy infrastructure on tribal lands with up to 90% loan guarantee"},{"id":"c","text":"Urban solar energy projects"},{"id":"d","text":"Agricultural energy conservation"}]', 'b', 'TELGP provides loan guarantees of up to 90% for energy infrastructure development on tribal lands, specifically designed to support tribal energy sovereignty.', 4),
(v_quiz, 'The Rural Energy Savings Program (RESP) provides loans to cooperatives at what interest rate?', '[{"id":"a","text":"Market rate"},{"id":"b","text":"Below-market rate set annually"},{"id":"c","text":"Zero percent (0%)"},{"id":"d","text":"The 10-year Treasury rate"}]', 'c', 'RESP provides zero-interest loans to electric cooperatives and similar entities, which then on-lend to rural households and businesses for energy efficiency improvements.', 5),
(v_quiz, 'TIFIA is administered by which department?', '[{"id":"a","text":"USDA"},{"id":"b","text":"DOE"},{"id":"c","text":"Department of Transportation"},{"id":"d","text":"Department of Commerce"}]', 'c', 'TIFIA (Transportation Infrastructure Finance and Innovation Act) is administered by the U.S. Department of Transportation, providing credit assistance for major transportation infrastructure projects.', 6),
(v_quiz, 'What is the minimum project size for rural TIFIA credit assistance?', '[{"id":"a","text":"$1 million"},{"id":"b","text":"$5 million"},{"id":"c","text":"$10 million"},{"id":"d","text":"$50 million"}]', 'c', 'TIFIA has a minimum project size of $10 million for rural projects — lower than the $50 million minimum for non-rural projects, but still requiring significant project scale.', 7),
(v_quiz, 'DOT RRIF financing is primarily used for:', '[{"id":"a","text":"Highway bridge replacement"},{"id":"b","text":"Railroad rehabilitation and improvement"},{"id":"c","text":"Port infrastructure development"},{"id":"d","text":"Airport runway upgrades"}]', 'b', 'RRIF (Railroad Rehabilitation and Improvement Financing) provides direct loans and guarantees specifically for railroad track improvement, equipment, and related infrastructure.', 8),
(v_quiz, 'A rural hospital project wants to stack multiple capital sources. Which combination is most appropriate?', '[{"id":"a","text":"SBA 7(a) + NMTC + USDA Community Facilities + CDFI loan"},{"id":"b","text":"RMAP + IRP + RBDG + federal grant"},{"id":"c","text":"FHA Title II + VA + USDA Section 502"},{"id":"d","text":"TIFIA + RRIF + DOE Title 17"}]', 'a', 'A rural hospital project would typically stack USDA Community Facilities guaranteed debt, New Markets Tax Credit equity, CDFI loan fund participation, and potentially state grants — all sources designed for essential facility projects.', 9),
(v_quiz, 'USDA Community Facilities direct loans are made at approximately what interest rate?', '[{"id":"a","text":"Prime rate plus 2%"},{"id":"b","text":"The current 10-year Treasury rate"},{"id":"c","text":"SBA base rate"},{"id":"d","text":"Federal funds rate"}]', 'b', 'USDA Community Facilities direct loan rates are based on the current 10-year Treasury rate — among the lowest long-term borrowing rates available to rural communities.', 10)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- CERT 33: Export, Trade & International Sales Finance
-- ═══════════════════════════════════════════════════════════════
SELECT id INTO v_cert FROM certifications WHERE cert_number = 33;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert, 'Export Finance Programs: EXIM & SBA', 1, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert AND sort_order = 1; END IF;

INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'EXIM Bank & SBA Export Programs: Tools for Small Business Exporters', 'exim-bank-sba-export-programs-tools-for-small-business-exporters',
$BODY$## EXIM Bank & SBA Export Programs: Tools for Small Business Exporters

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
$BODY$, 1, 9, 'approved')
ON CONFLICT DO NOTHING;

INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert, 'Export, Trade & International Sales Finance Assessment', 75, 40, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order) VALUES
(v_quiz, 'EXIM Bank''s primary mission is to:', '[{"id":"a","text":"Regulate international banks operating in the U.S."},{"id":"b","text":"Help U.S. businesses sell goods and services internationally through financing tools"},{"id":"c","text":"Provide domestic small business loans"},{"id":"d","text":"Manage the U.S. trade deficit"}]', 'b', 'EXIM Bank is the U.S. government''s official export credit agency, helping U.S. businesses compete internationally through working capital guarantees, credit insurance, and buyer financing.', 1),
(v_quiz, 'What does EXIM''s Working Capital Guarantee protect the lender against?', '[{"id":"a","text":"Currency exchange rate changes"},{"id":"b","text":"Exporter default on the pre-export working capital loan"},{"id":"c","text":"Foreign government interference"},{"id":"d","text":"Product quality disputes"}]', 'b', 'EXIM''s Working Capital Guarantee protects the commercial lender if the exporter defaults on the working capital loan used to produce or procure goods for export.', 2),
(v_quiz, 'Which SBA program provides the fastest turnaround for exporter working capital?', '[{"id":"a","text":"SBA International Trade Loan"},{"id":"b","text":"SBA Export Working Capital Program"},{"id":"c","text":"SBA Export Express"},{"id":"d","text":"SBA CAPLine"}]', 'c', 'SBA Export Express uses the lender''s own underwriting with SBA''s streamlined approval — fast turnaround for working capital and fixed assets up to $500,000 for exporters.', 3),
(v_quiz, 'The SBA Export Working Capital Program is based on:', '[{"id":"a","text":"The exporter''s credit score alone"},{"id":"b","text":"Specific export purchase orders and receivables"},{"id":"c","text":"Fixed assets pledged as collateral"},{"id":"d","text":"Three years of financial statements"}]', 'b', 'The EWCP is transaction-based — credit availability is tied to actual export purchase orders and eligible receivables, not just the company''s overall financials.', 4),
(v_quiz, 'What is export credit insurance?', '[{"id":"a","text":"Insurance protecting foreign buyers from U.S. export fraud"},{"id":"b","text":"Insurance protecting U.S. exporters if foreign buyers fail to pay"},{"id":"c","text":"A type of cargo insurance for international shipments"},{"id":"d","text":"A guarantee on EXIM''s own loan portfolio"}]', 'b', 'Export credit insurance protects U.S. exporters against non-payment by foreign buyers due to commercial risk (buyer insolvency) or political risk (government interference, war, etc.).', 5),
(v_quiz, 'The SBA International Trade Loan is designed for businesses that:', '[{"id":"a","text":"Export agricultural products only"},{"id":"b","text":"Face competition from imports or are expanding into export markets"},{"id":"c","text":"Are starting their first international transaction"},{"id":"d","text":"Need working capital for domestic operations"}]', 'b', 'The SBA ITL serves businesses facing import competition OR expanding into export markets — addressing both sides of the trade challenge for American small businesses.', 6),
(v_quiz, 'USDA GSM-102 is a program that:', '[{"id":"a","text":"Provides loans to U.S. agricultural producers"},{"id":"b","text":"Guarantees payment to U.S. lenders on sales of U.S. agricultural products to foreign buyers"},{"id":"c","text":"Funds rural energy projects"},{"id":"d","text":"Supports USDA water infrastructure"}]', 'b', 'USDA GSM-102 is an export credit guarantee program — it guarantees U.S. bank payment if a foreign buyer''s bank fails to pay for U.S. agricultural exports.', 7),
(v_quiz, 'U.S. Export Assistance Centers are part of which agency?', '[{"id":"a","text":"SBA exclusively"},{"id":"b","text":"EXIM Bank exclusively"},{"id":"c","text":"A partnership of Commerce, SBA, and EXIM"},{"id":"d","text":"Department of State"}]', 'c', 'U.S. Export Assistance Centers are a partnership among the U.S. Department of Commerce (trade specialists), SBA (export loan programs), and EXIM Bank (credit tools) — providing a one-stop shop for exporters.', 8),
(v_quiz, 'What is the maximum SBA Export Working Capital Program loan size?', '[{"id":"a","text":"$500,000"},{"id":"b","text":"$1 million"},{"id":"c","text":"$2.5 million"},{"id":"d","text":"$5 million"}]', 'd', 'The SBA Export Working Capital Program provides revolving credit up to $5 million, backed by specific export purchase orders and receivables.', 9),
(v_quiz, 'A small manufacturer wants to fulfill a large foreign purchase order but lacks working capital. Which program is most appropriate?', '[{"id":"a","text":"USDA RMAP"},{"id":"b","text":"SBA Export Working Capital Program or EXIM Working Capital Guarantee"},{"id":"c","text":"FHA Title II mortgage"},{"id":"d","text":"EDA Revolving Loan Fund"}]', 'b', 'The SBA EWCP and EXIM Working Capital Guarantee are specifically designed for exporters who need pre-export working capital to fulfill purchase orders from foreign buyers.', 10)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- CERT 34: Tribal & Native Lending Programs
-- ═══════════════════════════════════════════════════════════════
SELECT id INTO v_cert FROM certifications WHERE cert_number = 34;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert, 'Tribal Capital Access: BIA, Native CDFIs & Sovereignty', 1, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert AND sort_order = 1; END IF;

INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'BIA Indian Loan Guarantee and Native CDFI Programs', 'bia-indian-loan-guarantee-and-native-cdfi-programs',
$BODY$## BIA Indian Loan Guarantee and Native CDFI Programs

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
$BODY$, 1, 10, 'approved')
ON CONFLICT DO NOTHING;

INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert, 'Tribal & Native Lending Programs Assessment', 75, 45, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order) VALUES
(v_quiz, 'Which federal agency administers the Indian Loan Guarantee and Insurance Program?', '[{"id":"a","text":"USDA Rural Development"},{"id":"b","text":"Bureau of Indian Affairs (BIA)"},{"id":"c","text":"HUD"},{"id":"d","text":"SBA"}]', 'b', 'The BIA Indian Loan Guarantee and Insurance Program is administered by the Bureau of Indian Affairs within the Department of the Interior.', 1),
(v_quiz, 'What minimum ownership percentage must a business have to qualify for a BIA loan guarantee as an Indian-owned business?', '[{"id":"a","text":"25%"},{"id":"b","text":"51%"},{"id":"c","text":"75%"},{"id":"d","text":"100%"}]', 'b', 'Businesses must be at least 51% owned by individuals who are members of federally recognized tribes or Alaska Natives to qualify for BIA loan guarantees.', 2),
(v_quiz, 'NACA stands for:', '[{"id":"a","text":"Native American Community Association"},{"id":"b","text":"Native American CDFI Assistance Program"},{"id":"c","text":"National Agency for Capital Access"},{"id":"d","text":"Native American Credit Alliance"}]', 'b', 'NACA — Native American CDFI Assistance Program — is the CDFI Fund''s program providing grants and technical assistance specifically to CDFIs that primarily serve Native communities.', 3),
(v_quiz, 'Tribal sovereign immunity primarily affects lending by:', '[{"id":"a","text":"Making tribal interest rates lower"},{"id":"b","text":"Protecting tribes from lawsuits in state courts without their consent"},{"id":"c","text":"Giving tribes priority access to federal programs"},{"id":"d","text":"Exempting tribes from federal tax obligations"}]', 'b', 'Tribal sovereign immunity means lenders cannot sue tribal governments in state courts without the tribe''s voluntary waiver — complicating standard loan enforcement and requiring specific legal protections.', 4),
(v_quiz, 'What is a limited waiver of sovereign immunity in the lending context?', '[{"id":"a","text":"A tribe''s consent to be sued in tribal court for a specific transaction"},{"id":"b","text":"A tribe''s agreement that the lender can use federal courts for the specific lending transaction"},{"id":"c","text":"A permanent agreement to waive all sovereign protections"},{"id":"d","text":"An exemption from federal lending regulations"}]', 'b', 'A limited waiver of sovereign immunity is a tribal consent — limited to a specific transaction — allowing the lender to enforce the loan in an agreed-upon jurisdiction (often federal court or tribal court) if the borrower defaults.', 5),
(v_quiz, 'What is the maximum BIA loan guarantee percentage?', '[{"id":"a","text":"70%"},{"id":"b","text":"80%"},{"id":"c","text":"90%"},{"id":"d","text":"100%"}]', 'c', 'BIA can guarantee up to 90% of qualifying loans made to eligible Native American borrowers and businesses.', 6),
(v_quiz, 'A major barrier to conventional mortgage lending on tribal trust land is:', '[{"id":"a","text":"Native borrowers'' low incomes"},{"id":"b","text":"The inability to obtain title insurance and foreclose through standard processes"},{"id":"c","text":"Federal laws prohibiting mortgage lending in tribal areas"},{"id":"d","text":"Lack of credit reporting for Native borrowers"}]', 'b', 'Tribal trust land cannot be alienated or foreclosed without federal approval, and title insurance is typically unavailable — making conventional mortgage lending impractical without specialized programs like HUD Section 184.', 7),
(v_quiz, 'Cultural humility in Native community lending includes:', '[{"id":"a","text":"Applying standard underwriting criteria without modification"},{"id":"b","text":"Understanding tribal governance, historical context, and building trust-based relationships"},{"id":"c","text":"Requiring tribal borrowers to use non-tribal advisors"},{"id":"d","text":"Limiting loans to individual tribal members only"}]', 'b', 'Effective lending in Native communities requires genuine cultural competency — understanding tribal decision-making processes, historical trauma from federal programs, and building authentic community relationships.', 8),
(v_quiz, 'Tribal SSBCI programs are administered by:', '[{"id":"a","text":"State economic development agencies on behalf of tribes"},{"id":"b","text":"Tribal governments that received direct SSBCI allocations from Treasury"},{"id":"c","text":"BIA on behalf of tribal governments"},{"id":"d","text":"SBA district offices"}]', 'b', 'The 2021 American Rescue Plan provided direct SSBCI allocations to tribal governments — unlike state SSBCI programs, tribal SSBCI is administered directly by the tribal government.', 9),
(v_quiz, 'Which organization directory is the best resource for finding Native CDFIs?', '[{"id":"a","text":"SBA''s lender finder tool"},{"id":"b","text":"nativecdfi.net"},{"id":"c","text":"USDA Rural Development directory"},{"id":"d","text":"FDIC bank locator"}]', 'b', 'The Native CDFI Network (nativecdfi.net) maintains a directory of CDFIs serving Native communities across the United States, Alaska, and Hawaii.', 10)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- CERT 35: Student Loan & Legacy Servicing Awareness
-- ═══════════════════════════════════════════════════════════════
SELECT id INTO v_cert FROM certifications WHERE cert_number = 35;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert, 'Federal Student Loan Programs: History and Awareness', 1, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert AND sort_order = 1; END IF;

INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'Why Federal Student Lending Is Not a New Private Lender Pathway', 'why-federal-student-lending-is-not-a-new-private-lender-pathway',
$BODY$## Why Federal Student Lending Is Not a New Private Lender Pathway

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
$BODY$, 1, 7, 'approved')
ON CONFLICT DO NOTHING;

INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert, 'Student Loan & Legacy Servicing Awareness Assessment', 75, 30, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order) VALUES
(v_quiz, 'Who originates all new federal student loans since 2010?', '[{"id":"a","text":"Approved private banks and credit unions"},{"id":"b","text":"The U.S. Department of Education through the Direct Loan Program"},{"id":"c","text":"CDFIs certified by the CDFI Fund"},{"id":"d","text":"State student loan authorities"}]', 'b', 'Since 2010, all new federal student loans are originated directly by the U.S. Department of Education — private lenders cannot originate new federally backed student loans.', 1),
(v_quiz, 'FFEL stands for:', '[{"id":"a","text":"Federal Finance for Educational Loans"},{"id":"b","text":"Federal Family Education Loan Program"},{"id":"c","text":"Federal Fund for Educational Lending"},{"id":"d","text":"Federal Fintech Education Loan"}]', 'b', 'FFEL — Federal Family Education Loan Program — was the pre-2010 model where private lenders originated student loans with federal guarantees. The program ended for new loans in 2010.', 2),
(v_quiz, 'Can a CDFI originate new federally backed student loans?', '[{"id":"a","text":"Yes, if they obtain CDFI Fund certification"},{"id":"b","text":"Yes, if they partner with an approved lender"},{"id":"c","text":"No, federal student loan origination is closed to new private or community lenders"},{"id":"d","text":"Yes, if they operate in a low-income area"}]', 'c', 'The Federal Direct Loan Program is a closed government-direct system. No new private lenders, CDFIs, or nonprofits can originate federally backed student loans.', 3),
(v_quiz, 'The Perkins Loan program ended for new loans in:', '[{"id":"a","text":"2010"},{"id":"b","text":"2015"},{"id":"c","text":"2017"},{"id":"d","text":"2020"}]', 'c', 'The Federal Perkins Loan program ended in September 2017 — no new Perkins Loans can be made, though existing portfolios remain outstanding.', 4),
(v_quiz, 'What can community organizations constructively do in the student lending space?', '[{"id":"a","text":"Originate federally guaranteed student loans"},{"id":"b","text":"Provide counseling, referrals, and advocacy to help borrowers navigate repayment options"},{"id":"c","text":"Apply to become federal student loan servicers"},{"id":"d","text":"Petition SBA for student loan guarantee authority"}]', 'b', 'Community organizations add value by providing student loan counseling, helping borrowers navigate income-driven repayment and PSLF, and referring students to appropriate institutional resources.', 5),
(v_quiz, 'PSLF stands for:', '[{"id":"a","text":"Private Student Loan Forgiveness"},{"id":"b","text":"Public Service Loan Forgiveness"},{"id":"c","text":"Perkins Student Loan Forgiveness"},{"id":"d","text":"Post-Secondary Lending Fund"}]', 'b', 'PSLF — Public Service Loan Forgiveness — forgives remaining federal student loan balances after 10 years of qualifying payments while working for a qualifying public service employer.', 6),
(v_quiz, 'Private student loans differ from federal student loans in that they:', '[{"id":"a","text":"Are eligible for income-driven repayment"},{"id":"b","text":"Carry full credit risk without federal insurance or guarantee"},{"id":"c","text":"Are originated by the Department of Education"},{"id":"d","text":"Qualify for PSLF forgiveness"}]', 'b', 'Private student loans lack federal backing — lenders bear the full credit risk. They typically have higher interest rates and fewer repayment options than federal loans.', 7),
(v_quiz, 'Who services the existing portfolio of FFEL loans?', '[{"id":"a","text":"U.S. Department of Education directly"},{"id":"b","text":"Private companies contracted by the Department of Education"},{"id":"c","text":"The original FFEL lenders"},{"id":"d","text":"State student loan authorities"}]', 'b', 'Existing FFEL loans are serviced by private companies (student loan servicers) under contract with the Department of Education — the original private lenders no longer service these loans.', 8),
(v_quiz, 'A community member asks your organization for help with their student loans. What is the best response?', '[{"id":"a","text":"Offer to refinance their federal loans through your CDFI"},{"id":"b","text":"Refer them to a HUD-approved housing counselor for student loan advice"},{"id":"c","text":"Provide student loan counseling, connect them with income-driven repayment options, and refer to their loan servicer"},{"id":"d","text":"Tell them student loans are not your area and offer no assistance"}]', 'c', 'Community organizations can provide genuine value by educating borrowers about their repayment options (IDR, PSLF), helping them contact their servicer, and providing financial counseling — even without being able to originate loans.', 9),
(v_quiz, 'Which of the following is a legitimate private student lending opportunity for CDFIs?', '[{"id":"a","text":"Originating FFEL loans under the legacy program"},{"id":"b","text":"Originating private student loans (without federal backing) to community members"},{"id":"c","text":"Partnering with the Department of Education to issue Direct Loans"},{"id":"d","text":"Refinancing Perkins Loans into the Direct Loan program"}]', 'b', 'CDFIs and community lenders can originate private student loans bearing full credit risk. This is a legitimate market opportunity but requires careful assessment of credit risk and mission alignment.', 10)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- CERT 36: Capital Stack Design & Partnership Strategy
-- ═══════════════════════════════════════════════════════════════
SELECT id INTO v_cert FROM certifications WHERE cert_number = 36;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert, 'Capital Stack Fundamentals', 1, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert AND sort_order = 1; END IF;

INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'Understanding the Capital Stack: Grant, Debt, Equity & Guarantees', 'understanding-the-capital-stack-grant-debt-equity-guarantees',
$BODY$## Understanding the Capital Stack: Grant, Debt, Equity & Guarantees

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
$BODY$, 1, 10, 'approved'),

(v_mod, 'Partner Pitch Strategy & Building a Funding Source Matrix', 'partner-pitch-strategy-building-a-funding-source-matrix',
$BODY$## Partner Pitch Strategy & Building a Funding Source Matrix

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
$BODY$, 2, 9, 'approved')
ON CONFLICT DO NOTHING;

INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert, 'Capital Stack Design & Partnership Strategy Assessment', 80, 50, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order) VALUES
(v_quiz, 'In a capital stack, which layer carries the highest risk?', '[{"id":"a","text":"Senior debt"},{"id":"b","text":"Grant capital"},{"id":"c","text":"Equity"},{"id":"d","text":"Government guarantees"}]', 'c', 'Equity sits at the bottom of the repayment priority — equity investors are last to be paid in a liquidation, absorbing the most risk. In exchange, they share in upside returns.', 1),
(v_quiz, 'What is "senior debt" in a capital stack?', '[{"id":"a","text":"The largest debt tranche regardless of priority"},{"id":"b","text":"First-priority debt with the first claim on collateral in case of default"},{"id":"c","text":"A government-guaranteed loan"},{"id":"d","text":"The most expensive layer of financing"}]', 'b', 'Senior debt has the highest repayment priority — in a default, senior lenders are paid first from collateral before subordinate lenders or equity investors receive anything.', 2),
(v_quiz, 'Grant capital is described as "equity" in a capital stack because:', '[{"id":"a","text":"It earns the highest returns"},{"id":"b","text":"It is non-repayable and absorbs risk, similar to equity investment"},{"id":"c","text":"It must be repaid if the project succeeds"},{"id":"d","text":"It is owned by the government"}]', 'b', 'Grant capital is non-repayable — like equity, it does not need to be serviced from cash flow. In a loss, grants are absorbed before debt. This risk-absorbing function is why grants are analogous to equity.', 3),
(v_quiz, 'CRA stands for:', '[{"id":"a","text":"Capital Revolving Account"},{"id":"b","text":"Community Reinvestment Act"},{"id":"c","text":"Certified Resource Administrator"},{"id":"d","text":"Capital Resource Allocation"}]', 'b', 'The Community Reinvestment Act requires regulated banks to meet the credit needs of all communities in their service area, including low- and moderate-income areas.', 4),
(v_quiz, 'A Program-Related Investment (PRI) is made by:', '[{"id":"a","text":"Government agencies for infrastructure projects"},{"id":"b","text":"Foundations from their program budget, at below-market rates, for charitable purposes"},{"id":"c","text":"Commercial banks seeking CRA credit"},{"id":"d","text":"CDFI Fund for certified CDFIs"}]', 'b', 'PRIs are foundation investments made at below-market rates from their program budget — they count toward the foundation''s required 5% annual distribution while supporting charitable purposes.', 5),
(v_quiz, 'What is the LIHTC?', '[{"id":"a","text":"A federal tax deduction for landlords"},{"id":"b","text":"Low-Income Housing Tax Credit — the primary equity source for affordable housing"},{"id":"c","text":"A local housing assistance program"},{"id":"d","text":"A USDA rural housing loan program"}]', 'b', 'LIHTC (Low-Income Housing Tax Credit) is the primary federal subsidy for affordable housing development, providing equity to developers in exchange for making units affordable to low-income renters for 30+ years.', 6),
(v_quiz, 'A funding source matrix is best described as:', '[{"id":"a","text":"A spreadsheet of all your borrowers and their loan terms"},{"id":"b","text":"A structured document mapping capital sources to eligible uses, amounts, and application cycles"},{"id":"c","text":"A grant application tracking tool"},{"id":"d","text":"A borrower credit scoring system"}]', 'b', 'A funding source matrix is a strategic resource document mapping every capital source in your area to its requirements, typical amounts, application cycles, and contacts — enabling rapid identification of capital options for specific projects.', 7),
(v_quiz, 'In a $10 million affordable housing project capital stack, what is the role of the subordinate CDFI loan?', '[{"id":"a","text":"It is the largest debt layer with first claim on collateral"},{"id":"b","text":"It fills the gap between senior debt and grant/equity, taking second position at a higher rate"},{"id":"c","text":"It replaces the bank loan"},{"id":"d","text":"It provides working capital for operations"}]', 'b', 'Subordinate (mezzanine) debt from CDFIs fills the gap in a project''s capital stack, accepting second-position collateral and higher interest rates in exchange for enabling projects that senior lenders alone cannot fund.', 8),
(v_quiz, 'What is a Mission-Related Investment (MRI)?', '[{"id":"a","text":"A PRI from a foundation''s program budget"},{"id":"b","text":"An investment made from a foundation''s endowment, aligned with its mission"},{"id":"c","text":"A government grant for community development"},{"id":"d","text":"A state capital access program"}]', 'b', 'MRIs are investments made from a foundation''s endowment (not program budget) that align with the foundation''s mission — they are not required to be below-market but represent growing source of capital for community development.', 9),
(v_quiz, 'The most productive reason for a CDFI to build relationships with CRA officers at local banks is:', '[{"id":"a","text":"To receive regulatory approval for new lending programs"},{"id":"b","text":"Because banks need CRA credit and CDFIs can offer investments, loans, and CRA-qualified deposits"},{"id":"c","text":"To gain access to Federal Reserve borrowing facilities"},{"id":"d","text":"To replace the CDFI''s foundation funding"}]', 'b', 'Banks have CRA obligations to fulfill and need documented community development investments — CDFIs can offer them exactly what they need (investments in CDFI funds, LIHTC equity, CRA-qualified loans) in exchange for the capital CDFIs need.', 10)
ON CONFLICT DO NOTHING;

END $block$;
