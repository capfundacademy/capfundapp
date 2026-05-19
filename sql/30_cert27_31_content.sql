-- ============================================================
-- Cap Fund Academy — Cert 27–31 Content
-- Cert 27: Secondary Market & Mortgage Liquidity
-- Cert 28: CDFI, Treasury & Community Investment
-- Cert 29: SSBCI, State & Local Capital Access
-- Cert 30: EDA Revolving Loan Fund
-- Cert 31: EPA, Water & Environmental RLF
-- Run after: 27_cert_seeds_18_35.sql
-- ============================================================

DO $block$
DECLARE
  v_cert uuid; v_mod uuid; v_quiz uuid;
BEGIN

-- ═══════════════════════════════════════════════════════════════
-- CERT 27: Secondary Market & Mortgage Liquidity
-- ═══════════════════════════════════════════════════════════════
SELECT id INTO v_cert FROM certifications WHERE cert_number = 27;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert, 'Secondary Market Fundamentals for Lenders', 1, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert AND sort_order = 1; END IF;

INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'Why Secondary Markets Matter for Community Lenders', 'why-secondary-markets-matter-for-community-lenders',
$$## Why Secondary Markets Matter for Community Lenders

Secondary markets are the mechanism that allows mortgage lenders to convert long-term, illiquid loans into cash — enabling them to originate more loans with the same capital. Without secondary markets, most lenders would run out of lending capacity after funding their first portfolio of 30-year mortgages.

**How Secondary Markets Work**
A primary market lender (bank, credit union, CDFI) originates a mortgage loan. Rather than holding that loan until maturity, the lender sells it to a secondary market entity — Ginnie Mae, Fannie Mae, or Freddie Mac. The lender receives cash, which it can use to originate more loans. The secondary market entity pools the loans into mortgage-backed securities (MBS) and sells them to investors.

**Ginnie Mae**
The Government National Mortgage Association (Ginnie Mae) guarantees MBS backed by FHA, VA, USDA, and HUD Section 184 loans. Ginnie Mae itself does not buy or sell loans — it guarantees the timely payment of principal and interest on MBS. To issue Ginnie Mae MBS, you must be an approved Ginnie Mae issuer — a rigorous process requiring significant volume, operational infrastructure, and capital.

**Fannie Mae and Freddie Mac**
Government-sponsored enterprises that purchase conforming conventional mortgage loans from approved lenders. Their loan purchase programs provide liquidity for lenders originating conventional mortgage products. Becoming a Fannie Mae or Freddie Mac seller/servicer requires meeting specific financial, operational, and volume requirements.

**When to Partner Instead of Participate Directly**
For most CDFIs and community lenders, becoming a Ginnie Mae issuer or GSE seller/servicer is not the right path — the requirements are demanding and the volume thresholds are high. Instead, the strategic play is to originate government-insured loans (FHA, VA, USDA) and sell them to existing approved issuers/servicers through a correspondent lending relationship. This provides secondary market access without full approval overhead.

**Key Terms**
- **MBS**: Mortgage-Backed Securities — pools of mortgages sold to investors.
- **Correspondent lender**: A lender that originates loans but sells them to another entity for secondary market delivery.
- **Ginnie Mae issuer**: An approved participant that pools government-insured loans into MBS.

**Practical Checklist**
- [ ] Identify Ginnie Mae issuers and GSE seller/servicers in your region
- [ ] Research correspondent lending agreements as a pathway to secondary market access
- [ ] Review volume requirements for Ginnie Mae issuer approval
- [ ] Understand how selling loans affects your servicing revenue
- [ ] Develop a liquidity strategy for your loan origination program
$$, 1, 8, 'approved')
ON CONFLICT DO NOTHING;

INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert, 'Secondary Market & Mortgage Liquidity Assessment', 75, 40, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order) VALUES
(v_quiz, 'What is the primary function of secondary mortgage markets?', '[{"id":"a","text":"To provide direct loans to homebuyers"},{"id":"b","text":"To allow lenders to sell loans and recycle capital for new origination"},{"id":"c","text":"To guarantee loans against default"},{"id":"d","text":"To regulate mortgage interest rates"}]', 'b', 'Secondary markets allow lenders to sell originated loans to investors, converting illiquid long-term loans into cash that can be used to originate new loans.', 1),
(v_quiz, 'Which entity guarantees mortgage-backed securities backed by FHA, VA, and USDA loans?', '[{"id":"a","text":"Fannie Mae"},{"id":"b","text":"Freddie Mac"},{"id":"c","text":"Ginnie Mae"},{"id":"d","text":"The Federal Reserve"}]', 'c', 'Ginnie Mae (Government National Mortgage Association) guarantees the timely payment on MBS backed by government-insured and guaranteed mortgage loans.', 2),
(v_quiz, 'What is a correspondent lender?', '[{"id":"a","text":"A lender that services but does not originate loans"},{"id":"b","text":"A lender that originates loans and sells them to another entity for secondary market delivery"},{"id":"c","text":"A federal agency that purchases conforming loans"},{"id":"d","text":"A subprime mortgage broker"}]', 'b', 'Correspondent lenders originate loans in their own name but sell them to larger institutions (aggregators or issuers) that then deliver them into the secondary market.', 3),
(v_quiz, 'For most CDFIs, the most practical way to access secondary mortgage market liquidity is:', '[{"id":"a","text":"Become a Ginnie Mae issuer"},{"id":"b","text":"Establish a correspondent lending relationship with an approved issuer"},{"id":"c","text":"Apply for GSE seller/servicer approval"},{"id":"d","text":"Create a bank subsidiary"}]', 'b', 'Correspondent lending relationships allow CDFIs to originate government-backed mortgages and sell them to approved issuers — gaining secondary market liquidity without meeting direct issuer requirements.', 4),
(v_quiz, 'Fannie Mae and Freddie Mac are known as:', '[{"id":"a","text":"Federal Reserve banks"},{"id":"b","text":"Government-Sponsored Enterprises (GSEs)"},{"id":"c","text":"FHA-approved mortgagees"},{"id":"d","text":"Ginnie Mae subsidiaries"}]', 'b', 'Fannie Mae and Freddie Mac are Government-Sponsored Enterprises (GSEs) — privately owned companies with an implicit federal backstop that purchase conventional conforming mortgages.', 5),
(v_quiz, 'What is a mortgage-backed security (MBS)?', '[{"id":"a","text":"A government guarantee of individual mortgages"},{"id":"b","text":"A pool of mortgages sold to investors as a security"},{"id":"c","text":"A mortgage insurance policy"},{"id":"d","text":"A secondary market application"}]', 'b', 'An MBS is a financial security backed by a pool of mortgage loans — investors receive the principal and interest payments from the underlying mortgages.', 6),
(v_quiz, 'Which of the following is a key challenge for community lenders seeking Ginnie Mae issuer approval?', '[{"id":"a","text":"Geographic service area restrictions"},{"id":"b","text":"High volume thresholds and significant operational infrastructure requirements"},{"id":"c","text":"CDFI certification not accepted"},{"id":"d","text":"Federal grant fund limitations"}]', 'b', 'Ginnie Mae issuer approval requires significant loan origination volume, operational infrastructure, capital requirements, and compliance systems that are beyond most small CDFIs and community lenders.', 7),
(v_quiz, 'When a lender sells a mortgage to the secondary market, what does it retain if it keeps the servicing rights?', '[{"id":"a","text":"The full loan principal"},{"id":"b","text":"Monthly servicing fee revenue from the borrower"},{"id":"c","text":"The government guarantee"},{"id":"d","text":"Full credit risk on the loan"}]', 'b', 'When a lender sells a loan but retains servicing rights, it continues to collect monthly payments and earns a servicing fee (typically 0.25-0.50% annually) — a revenue stream that does not require the lender to hold the loan risk.', 8),
(v_quiz, 'What types of loans does Ginnie Mae pool into MBS?', '[{"id":"a","text":"Conventional conforming loans"},{"id":"b","text":"FHA, VA, USDA, and HUD Section 184 loans"},{"id":"c","text":"Jumbo mortgages only"},{"id":"d","text":"Commercial real estate loans"}]', 'b', 'Ginnie Mae specifically pools government-insured and guaranteed loans — FHA, VA, USDA rural housing, and HUD Section 184 — into MBS with a full faith and credit guarantee.', 9),
(v_quiz, 'The main benefit of secondary market participation for a mortgage lender is:', '[{"id":"a","text":"Avoiding all compliance requirements"},{"id":"b","text":"Recycling capital to originate more loans after selling existing ones"},{"id":"c","text":"Receiving government grant subsidies"},{"id":"d","text":"Eliminating servicing responsibilities"}]', 'b', 'By selling loans to the secondary market, lenders replenish their capital and can continue originating new loans — dramatically increasing their community impact beyond what their own balance sheet alone could support.', 10)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- CERT 28: CDFI, Treasury & Community Investment
-- ═══════════════════════════════════════════════════════════════
SELECT id INTO v_cert FROM certifications WHERE cert_number = 28;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert, 'CDFI Certification & Treasury Programs', 1, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert AND sort_order = 1; END IF;

INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'What is a CDFI and How Do You Get Certified?', 'what-is-a-cdfi-and-how-do-you-get-certified',
$$## What is a CDFI and How Do You Get Certified?

Community Development Financial Institutions (CDFIs) are specialized mission-driven lenders, investors, and financial services providers that deliver responsible, affordable capital to underserved people and communities. The CDFI Fund, an office within the U.S. Treasury Department, certifies CDFIs and administers financial and technical assistance programs.

**What Makes an Organization a CDFI?**
To be certified as a CDFI by the Treasury's CDFI Fund, an organization must meet five core criteria:

1. **Primary mission**: Community development must be the organization's primary purpose.
2. **Financing entity**: The organization must provide capital (loans, equity, guarantees) — not just grants or services.
3. **Target market**: The CDFI must primarily serve a defined low-income target market.
4. **Developmental services**: The CDFI must provide non-financial services alongside capital — technical assistance, financial counseling, etc.
5. **Community accountability**: Governed by or accountable to the communities it serves.

**Types of Certified CDFIs**
- Community Development Banks
- Community Development Credit Unions
- Community Development Loan Funds (the most common type for nonprofits)
- Community Development Venture Capital Funds
- Community Development Entities (for New Markets Tax Credit)
- Microenterprise Development Organizations

**Why CDFI Certification Matters**
Certification unlocks access to: CDFI Program Financial Assistance (FA) awards, CDFI Program Technical Assistance (TA) awards, Native CDFI Assistance Program, Capital Magnet Fund, New Markets Tax Credit allocations, Bank Enterprise Award, and Small Dollar Loan Program. CDFI-certified organizations also become more attractive to banks seeking Community Reinvestment Act (CRA) credit.

**The Application Process**
The CDFI certification application is submitted through the CDFI Fund's Awards Management Information System (AMIS). Key requirements include: organizational description, financing entity evidence, target market documentation, developmental services evidence, and accountability documentation. Processing typically takes several months.

**Key Terms**
- **CDFI Fund**: The U.S. Treasury office that certifies CDFIs and administers related programs.
- **Target market**: The low-income or underserved population a CDFI primarily serves.
- **FA**: Financial Assistance — CDFI Fund grants for lending capital and operating support.

**Practical Checklist**
- [ ] Review CDFI certification criteria at cdfifund.gov
- [ ] Assess your organization against the five certification criteria
- [ ] Identify your target market and document your track record serving it
- [ ] Create an AMIS account and review the current certification application
- [ ] Connect with a CDFI that has gone through the certification process for guidance
$$, 1, 10, 'approved'),

(v_mod, 'CDFI Fund Programs: FA, TA, Capital Magnet Fund & NMTC', 'cdfi-fund-programs-fa-ta-capital-magnet-fund-nmtc',
$$## CDFI Fund Programs: FA, TA, Capital Magnet Fund & NMTC

Once certified as a CDFI, your organization can apply for multiple Treasury-administered programs that provide capital, grants, and tax credit allocations. Understanding each program's purpose and requirements positions you to build a diversified funding strategy.

**CDFI Program Financial Assistance (FA) Awards**
FA awards are grants or loans from the CDFI Fund to certified CDFIs to expand their lending capacity. Award amounts range from $250,000 to $2 million per round. FA awards require a matching investment from non-federal sources — dollar-for-dollar match. FA awards come in two categories: Financial Assistance (for capital) and Technical Assistance (for organizational capacity building). Application periods open approximately once per year.

**Capital Magnet Fund (CMF)**
CMF provides grants to CDFIs and nonprofit housing organizations for affordable housing and related economic development activities. CMF funds must be used to attract private capital — the program requires at least ten dollars of private investment for every one dollar of CMF award. CDFIs and nonprofit organizations that are not CDFIs can apply. Awards typically range from $1 million to $15 million.

**New Markets Tax Credit (NMTC)**
The NMTC program allows Community Development Entities (CDEs) to raise equity capital from investors in exchange for federal tax credits. CDEs deploy this equity into Qualified Low-Income Community Investments (QLICIs) — loans and equity investments in low-income communities. NMTC is one of the most complex but powerful financing tools available — a single allocation can leverage $7 in private investment for every $1 of tax credit.

To participate in NMTC, an organization must be certified as a CDE (separate from CDFI certification), apply for an allocation from the CDFI Fund, raise investor equity, and deploy it into qualifying investments.

**CDFI Bond Guarantee Program**
A program that allows eligible CDFIs to issue bonds guaranteed by the federal government and use the proceeds to expand lending capital. Bonds must be at least $100 million and are guaranteed for up to 29.5 years. A powerful tool for large, established CDFIs seeking long-term capital at low cost.

**Key Terms**
- **FA award**: CDFI Fund grant for capital and operating support — requires matching investment.
- **CMF**: Capital Magnet Fund — grants for affordable housing leveraging private capital.
- **CDE**: Community Development Entity — the certification needed to apply for NMTC allocations.
- **QLICI**: Qualified Low-Income Community Investment — the loans/equity deployed with NMTC proceeds.

**Practical Checklist**
- [ ] Review the CDFI Fund's current Notice of Guarantee Availability (NOGA)
- [ ] Calculate your matching investment capacity before applying for FA
- [ ] Research the Capital Magnet Fund if your mission includes affordable housing
- [ ] Assess whether NMTC is appropriate for your organization size and capacity
- [ ] Identify CDEs operating in your region for potential partnership
$$, 2, 10, 'approved')
ON CONFLICT DO NOTHING;

INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert, 'CDFI, Treasury & Community Investment Assessment', 80, 50, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order) VALUES
(v_quiz, 'How many core criteria must be met for CDFI certification?', '[{"id":"a","text":"Three"},{"id":"b","text":"Four"},{"id":"c","text":"Five"},{"id":"d","text":"Six"}]', 'c', 'CDFI certification requires meeting five criteria: primary mission, financing entity, target market, developmental services, and community accountability.', 1),
(v_quiz, 'What is the matching requirement for CDFI Program Financial Assistance awards?', '[{"id":"a","text":"No match required"},{"id":"b","text":"Two-to-one match"},{"id":"c","text":"Dollar-for-dollar match from non-federal sources"},{"id":"d","text":"Ten-to-one match"}]', 'c', 'CDFI FA awards require a dollar-for-dollar matching investment from non-federal sources — for every dollar of FA award, the CDFI must raise one dollar from private, state, or local sources.', 2),
(v_quiz, 'Which CDFI Fund program provides grants specifically for affordable housing with a 10:1 private investment leverage requirement?', '[{"id":"a","text":"CDFI Financial Assistance"},{"id":"b","text":"Capital Magnet Fund"},{"id":"c","text":"CDFI Bond Guarantee Program"},{"id":"d","text":"Native CDFI Assistance"}]', 'b', 'The Capital Magnet Fund requires CDFIs and nonprofits to attract at least $10 in private investment for every $1 of CMF award — one of the most leveraged grant programs available.', 3),
(v_quiz, 'What is a Community Development Entity (CDE)?', '[{"id":"a","text":"Any nonprofit with CDFI certification"},{"id":"b","text":"An organization certified by the CDFI Fund to apply for New Markets Tax Credit allocations"},{"id":"c","text":"A state economic development agency"},{"id":"d","text":"A bank with CRA obligations"}]', 'b', 'CDEs are entities certified by the CDFI Fund with authority to apply for NMTC allocations. CDE certification is separate from CDFI certification.', 4),
(v_quiz, 'What does QLICI stand for?', '[{"id":"a","text":"Qualified Lender Investment in Community Infrastructure"},{"id":"b","text":"Qualified Low-Income Community Investment"},{"id":"c","text":"Quality Loan Initiative for Community Impact"},{"id":"d","text":"Qualified Lending Institution for Community Investment"}]', 'b', 'QLICI (Qualified Low-Income Community Investment) is the term for loans and equity investments made by CDEs using New Markets Tax Credit proceeds in low-income communities.', 5),
(v_quiz, 'The NMTC program allows investors to receive tax credits in exchange for:', '[{"id":"a","text":"Donating to affordable housing programs"},{"id":"b","text":"Providing equity capital to CDEs for investment in low-income communities"},{"id":"c","text":"Making loans directly to small businesses"},{"id":"d","text":"Purchasing government bonds"}]', 'b', 'NMTC provides federal tax credits to investors who provide equity capital to certified CDEs, which then deploy that capital as loans and equity in qualified low-income communities.', 6),
(v_quiz, 'Which CDFI program requires a minimum bond issuance of $100 million?', '[{"id":"a","text":"CDFI Financial Assistance award"},{"id":"b","text":"Capital Magnet Fund"},{"id":"c","text":"CDFI Bond Guarantee Program"},{"id":"d","text":"Native CDFI Assistance Program"}]', 'c', 'The CDFI Bond Guarantee Program requires minimum bond issuances of $100 million, making it appropriate only for large, established CDFIs seeking long-term capital at low cost.', 7),
(v_quiz, 'A nonprofit organization wants CDFI certification but does not make loans. Can it be certified?', '[{"id":"a","text":"Yes, any nonprofit qualifies"},{"id":"b","text":"No, CDFIs must provide capital (loans, equity, guarantees) as a primary activity"},{"id":"c","text":"Yes, if it provides technical assistance"},{"id":"d","text":"Only if it partners with an existing CDFI"}]', 'b', 'CDFI certification requires that the organization be a financing entity — it must provide capital products (loans, equity, guarantees) not just grants or services.', 8),
(v_quiz, 'CRA stands for:', '[{"id":"a","text":"Community Reinvestment Act"},{"id":"b","text":"Certified Rural Administrator"},{"id":"c","text":"Capital Revolving Account"},{"id":"d","text":"Community Regulatory Authority"}]', 'a', 'The Community Reinvestment Act (CRA) requires banks to demonstrate lending in the communities where they take deposits — investments in CDFIs often help banks meet CRA obligations.', 9),
(v_quiz, 'What type of organization administers the CDFI Fund?', '[{"id":"a","text":"Small Business Administration"},{"id":"b","text":"U.S. Treasury Department"},{"id":"c","text":"Federal Reserve Board"},{"id":"d","text":"Department of Housing and Urban Development"}]', 'b', 'The CDFI Fund is an office within the U.S. Department of the Treasury responsible for certifying CDFIs, certifying CDEs, and administering related financial assistance programs.', 10)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- CERT 29: SSBCI, State & Local Capital Access
-- ═══════════════════════════════════════════════════════════════
SELECT id INTO v_cert FROM certifications WHERE cert_number = 29;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert, 'State Small Business Credit Initiative (SSBCI)', 1, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert AND sort_order = 1; END IF;

INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'SSBCI Overview: State-Administered Capital Access Programs', 'ssbci-overview-state-administered-capital-access-programs',
$$## SSBCI Overview: State-Administered Capital Access Programs

The State Small Business Credit Initiative (SSBCI) is a federal program that allocates capital to states, territories, and tribal governments to expand access to small business financing. SSBCI was first enacted in 2010 following the financial crisis and was dramatically expanded in 2021 with $10 billion in new funding from the American Rescue Plan.

**How SSBCI Works**
The U.S. Treasury distributes SSBCI funds to states, which then deploy them through various capital access programs designed to leverage private lending. SSBCI is unique in that states have significant flexibility to design programs that match their local economies and credit gaps — within Treasury's guidelines.

**Five Categories of SSBCI Programs**
1. **State Loan Participation Programs**: The state purchases a portion of a private lender's loan to a small business, reducing the lender's risk. The lender retains the servicing relationship.

2. **State Loan Guarantee Programs**: The state guarantees a portion of a private loan, similar to an SBA guarantee but at the state level.

3. **Collateral Support Programs**: The state deposits funds with a lender to serve as additional collateral for a borrower who lacks sufficient assets. The collateral "pledge" reduces the lender's risk without actually requiring the state to hold a lien.

4. **Capital Access Programs (CAP)**: A matching reserve model — for each loan, the state and borrower each contribute a small percentage into a reserve fund. The reserve covers losses if the borrower defaults.

5. **Venture Capital Programs**: States use SSBCI funds to capitalize venture funds that make equity investments in small businesses, particularly in underserved communities.

**SSBCI and Underserved Entrepreneurs**
A significant portion of the 2021 SSBCI funding is targeted to very small businesses (under 10 employees), businesses in low- and moderate-income communities, and businesses owned by socially and economically disadvantaged individuals (SEDI).

**Key Terms**
- **SSBCI**: State Small Business Credit Initiative — federal program funding state capital access programs.
- **CAP reserve**: A matching loss reserve fund built from contributions by the state and borrowers.
- **SEDI**: Socially and Economically Disadvantaged Individual — an SSBCI priority target group.

**Practical Checklist**
- [ ] Identify which SSBCI programs are operating in your state
- [ ] Contact your state economic development agency for SSBCI program details
- [ ] Determine whether your organization can partner with SSBCI-funded programs
- [ ] Review SSBCI program guidelines at home.treasury.gov/ssbci
- [ ] Identify lenders participating in your state's SSBCI programs
$$, 1, 9, 'approved')
ON CONFLICT DO NOTHING;

INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert, 'SSBCI, State & Local Capital Access Assessment', 75, 45, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order) VALUES
(v_quiz, 'SSBCI funds are distributed by:', '[{"id":"a","text":"SBA to approved lenders directly"},{"id":"b","text":"U.S. Treasury to states, territories, and tribal governments"},{"id":"c","text":"FHA to mortgage lenders"},{"id":"d","text":"EDA to regional development organizations"}]', 'b', 'SSBCI funds flow from the U.S. Treasury to state, territorial, and tribal government recipients, who then deploy them through capital access programs.', 1),
(v_quiz, 'In an SSBCI State Loan Participation Program, what does the state do?', '[{"id":"a","text":"Provides direct loans to small businesses"},{"id":"b","text":"Purchases a portion of a private lender''s loan to reduce the lender''s risk"},{"id":"c","text":"Guarantees 100% of private loans"},{"id":"d","text":"Deposits collateral at the Federal Reserve"}]', 'b', 'In a loan participation program, the state co-lends alongside a private lender, purchasing a portion of the loan and thus reducing the lender''s exposure and risk.', 2),
(v_quiz, 'SSBCI Capital Access Programs (CAP) use what type of reserve structure?', '[{"id":"a","text":"Government-only reserve funded entirely by Treasury"},{"id":"b","text":"A matching reserve where both the state and borrower contribute"},{"id":"c","text":"A loan guarantee backed by SBA"},{"id":"d","text":"A hedge fund mechanism"}]', 'b', 'CAP programs use a matching reserve — for each loan, both the state and the borrower contribute a percentage into a reserve fund that covers losses, creating a shared-risk structure.', 3),
(v_quiz, 'What is the key distinction of SSBCI Collateral Support Programs?', '[{"id":"a","text":"They provide direct equity investments"},{"id":"b","text":"They deposit funds with lenders to serve as additional collateral without requiring the state to hold a lien"},{"id":"c","text":"They guarantee loans at 90%"},{"id":"d","text":"They replace the borrower''s down payment"}]', 'b', 'Collateral support programs pledge state funds as additional collateral to help borrowers who lack sufficient assets, reducing lender risk without the state actually owning a lien position.', 4),
(v_quiz, 'SEDI stands for:', '[{"id":"a","text":"State Economic Development Initiative"},{"id":"b","text":"Socially and Economically Disadvantaged Individual"},{"id":"c","text":"Small Enterprise Debt Investment"},{"id":"d","text":"State Emergency Deployment Institution"}]', 'b', 'SEDI (Socially and Economically Disadvantaged Individual) is a priority target group in SSBCI 2.0, with a significant portion of funding directed toward businesses owned by SEDI entrepreneurs.', 5),
(v_quiz, 'CDBG revolving loan funds are administered by:', '[{"id":"a","text":"SBA"},{"id":"b","text":"HUD through entitlement communities"},{"id":"c","text":"USDA Rural Development"},{"id":"d","text":"Treasury CDFI Fund"}]', 'b', 'CDBG (Community Development Block Grant) revolving loan funds are established using HUD CDBG grants and are administered by entitlement communities (cities and counties) that receive direct CDBG allocations.', 6),
(v_quiz, 'Which SSBCI program type makes equity investments rather than loans?', '[{"id":"a","text":"State Loan Guarantee Programs"},{"id":"b","text":"Capital Access Programs"},{"id":"c","text":"Venture Capital Programs"},{"id":"d","text":"Collateral Support Programs"}]', 'c', 'SSBCI Venture Capital Programs allow states to capitalize venture funds that make equity investments in small businesses, particularly in underserved communities.', 7),
(v_quiz, 'A community organization wants to help its borrowers access SSBCI programs. What is the first step?', '[{"id":"a","text":"Apply to Treasury for SSBCI funds directly"},{"id":"b","text":"Contact the state economic development agency to identify operating SSBCI programs and participating lenders"},{"id":"c","text":"Apply for SBA lender approval"},{"id":"d","text":"Establish a state-chartered bank"}]', 'b', 'States administer SSBCI programs, so contacting your state economic development agency is the right first step to identify which SSBCI programs are available and how lenders and borrowers can participate.', 8),
(v_quiz, 'HOME-funded housing loan pools are administered by:', '[{"id":"a","text":"HUD and state housing finance agencies"},{"id":"b","text":"SBA district offices"},{"id":"c","text":"USDA Rural Development"},{"id":"d","text":"Treasury CDFI Fund"}]', 'a', 'HOME Investment Partnerships program funds from HUD flow to states and localities, which can use them to capitalize housing loan pools, revolving funds, and direct homebuyer assistance programs.', 9),
(v_quiz, 'How large was the SSBCI funding expansion in the 2021 American Rescue Plan?', '[{"id":"a","text":"$1 billion"},{"id":"b","text":"$5 billion"},{"id":"c","text":"$10 billion"},{"id":"d","text":"$25 billion"}]', 'c', 'The American Rescue Plan Act of 2021 expanded SSBCI with $10 billion — dramatically larger than the original 2010 program — to support small business recovery and underserved entrepreneur access to capital.', 10)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- CERT 30: EDA Revolving Loan Fund
-- ═══════════════════════════════════════════════════════════════
SELECT id INTO v_cert FROM certifications WHERE cert_number = 30;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert, 'EDA Economic Development Finance & RLF Structure', 1, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert AND sort_order = 1; END IF;

INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'EDA RLF: Purpose, Eligible Recipients, and Program Requirements', 'eda-rlf-purpose-eligible-recipients-and-program-requirements',
$$## EDA RLF: Purpose, Eligible Recipients, and Program Requirements

The Economic Development Administration (EDA), within the U.S. Department of Commerce, administers Revolving Loan Fund programs as part of its mission to drive economic development in distressed communities. EDA RLFs are used to fill financing gaps, create jobs, and attract private investment in economically challenged areas.

**What is an EDA Revolving Loan Fund?**
An EDA RLF is a pool of funds established with an EDA grant or loan, which an eligible organization then uses to make loans to businesses in eligible areas. As loans are repaid, the funds "revolve" back into the fund and are relent to new borrowers — allowing a single initial grant to support multiple generations of lending.

**Who Can Receive EDA RLF Awards?**
Eligible recipients include: states, political subdivisions, nonprofit organizations, and institutions of higher education. Native American tribes, regional planning organizations, and economic development districts are also eligible. Private for-profit entities cannot receive EDA RLF awards directly.

**Economic Distress Requirement**
EDA programs require that projects be in areas that meet EDA's economic distress criteria — typically defined as areas with: per capita income less than 80% of the national average, unemployment rate at least one percentage point above the national average, or a special need as determined by EDA.

**RLF Plan Requirements**
Organizations receiving EDA RLF funds must develop and maintain a comprehensive RLF Plan that includes: lending policies, underwriting standards, job creation and retention requirements, eligible borrowers, loan size limits, interest rates, and portfolio management procedures.

**Job Creation and Retention**
EDA RLFs are measured by their economic impact. The primary metric is job creation and retention. Borrowers must demonstrate projected job outcomes, and recipients must track and report actual jobs created or retained over time.

**Prudent Lending Standards**
EDA requires RLF operators to apply prudent lending standards — meaning underwriting must be rigorous enough to protect the fund's long-term viability. EDA does not want RLFs to make loans that would be clearly bad credit risks. The goal is gap financing, not charity.

**Key Terms**
- **EDA**: Economic Development Administration — a division of the U.S. Department of Commerce.
- **RLF Plan**: Required document governing all EDA RLF lending policies and procedures.
- **Economic distress**: EDA criteria for eligible investment areas based on income and unemployment.

**Practical Checklist**
- [ ] Verify economic distress eligibility for your service area at eda.gov
- [ ] Review 13 CFR Part 307 (EDA RLF regulations)
- [ ] Draft an RLF Plan outline using EDA's template and guidance
- [ ] Identify EDA-funded RLF operators in your region for partnership
- [ ] Develop a job creation tracking methodology
$$, 1, 10, 'approved'),

(v_mod, 'Operating an EDA RLF: Portfolio Management, Compliance & Sustainability', 'operating-an-eda-rlf-portfolio-management-compliance-sustainability',
$$## Operating an EDA RLF: Portfolio Management, Compliance & Sustainability

Receiving an EDA RLF award is the beginning, not the end. The long-term challenge is building a compliant, sustainable loan fund that continues to serve your community for decades — not just until the next audit.

**Gap Financing Strategy**
EDA RLFs are not designed to be the only capital source for a project. They are designed to fill the gap between what private lenders will provide and what a project needs. A typical EDA RLF loan might cover 20–40% of a project, with a bank loan covering 50–60% and the borrower's equity covering the remainder.

When evaluating loans, EDA operators should ask: "Would this project happen without our gap financing?" If the private lender alone can fund it, the EDA loan is unnecessary. If the project cannot proceed without the gap — that is where EDA capital belongs.

**Portfolio Management Best Practices**
- Maintain a written loan file for every active loan with credit analysis, closing documents, and monitoring records.
- Conduct annual borrower reviews — request updated financial statements and verify job creation progress.
- Track delinquency with a defined delinquency management policy.
- Maintain loan loss reserves appropriate to portfolio risk.
- Report to EDA as required — EDA RLF recipients must submit semi-annual reports through EDA's reporting system (MEIS or similar platform).

**Sustainability Planning**
An EDA RLF should be designed to be self-sustaining over time. Interest income from the loan portfolio should cover operating costs — at minimum. Organizations should build a fee structure (origination fees, servicing fees) that supplements interest income. The goal is a fund that does not need continuous grant injections to survive.

**Key Terms**
- **Gap financing**: Capital that fills the difference between what private lenders provide and what a project needs.
- **MEIS**: Economic Development Administration's reporting system for grants and RLFs.
- **Portfolio delinquency**: Loans in the portfolio that are past due on payments.

**Practical Checklist**
- [ ] Develop a delinquency management policy with defined stages and interventions
- [ ] Create a standard annual borrower review package
- [ ] Calculate the interest income needed to cover your RLF operating costs
- [ ] Review EDA's semi-annual reporting requirements
- [ ] Build a 5-year fund sustainability model
$$, 2, 9, 'approved')
ON CONFLICT DO NOTHING;

INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert, 'EDA Revolving Loan Fund Assessment', 80, 45, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order) VALUES
(v_quiz, 'EDA (Economic Development Administration) is part of which federal department?', '[{"id":"a","text":"Department of Commerce"},{"id":"b","text":"Department of Agriculture"},{"id":"c","text":"Small Business Administration"},{"id":"d","text":"Department of Housing and Urban Development"}]', 'a', 'EDA is a division of the U.S. Department of Commerce, focused on driving economic development and job creation in distressed communities.', 1),
(v_quiz, 'Which entity type is NOT eligible to receive an EDA RLF award?', '[{"id":"a","text":"States and political subdivisions"},{"id":"b","text":"Nonprofit organizations"},{"id":"c","text":"For-profit businesses"},{"id":"d","text":"Native American tribes"}]', 'c', 'For-profit entities cannot receive EDA RLF awards directly. Eligible recipients include government entities, nonprofits, tribes, and educational institutions.', 2),
(v_quiz, 'What is "gap financing" in the EDA RLF context?', '[{"id":"a","text":"An emergency loan for businesses in distress"},{"id":"b","text":"Capital that fills the difference between private lender capacity and total project needs"},{"id":"c","text":"A government grant that replaces private lending"},{"id":"d","text":"A federal subsidy for small business operating costs"}]', 'b', 'Gap financing covers the portion of a project that conventional private lenders will not finance — EDA RLF loans are designed to fill this gap, not replace private capital.', 3),
(v_quiz, 'What document must EDA RLF operators maintain governing all lending policies?', '[{"id":"a","text":"CDFI certification application"},{"id":"b","text":"An RLF Plan approved by EDA"},{"id":"c","text":"A state lending license"},{"id":"d","text":"A SAM.gov registration"}]', 'b', 'EDA requires RLF recipients to maintain a comprehensive RLF Plan covering lending policies, underwriting standards, eligible borrowers, job requirements, and portfolio management.', 4),
(v_quiz, 'What regulation governs EDA RLF programs?', '[{"id":"a","text":"7 CFR Part 5001"},{"id":"b","text":"13 CFR Part 307"},{"id":"c","text":"2 CFR Part 200"},{"id":"d","text":"24 CFR Part 570"}]', 'b', 'EDA RLF programs are governed by 13 CFR Part 307, which establishes the requirements for Economic Adjustment Assistance revolving loan funds.', 5),
(v_quiz, 'What is the primary economic impact metric for EDA RLFs?', '[{"id":"a","text":"Total loan volume"},{"id":"b","text":"Jobs created or retained"},{"id":"c","text":"Number of businesses served"},{"id":"d","text":"Interest income generated"}]', 'b', 'EDA measures RLF impact primarily through job creation and retention — borrowers must project job outcomes and operators must track and report actual results.', 6),
(v_quiz, 'EDA economic distress eligibility typically requires which of the following?', '[{"id":"a","text":"Population below 5,000"},{"id":"b","text":"Per capita income below 80% of national average OR unemployment one point above national average"},{"id":"c","text":"Rural location only"},{"id":"d","text":"No private lenders operating in the area"}]', 'b', 'EDA economic distress criteria include: per capita income less than 80% of national average, unemployment at least one percentage point above national average, or special need determined by EDA.', 7),
(v_quiz, 'What should an EDA RLF operator ask before making a loan?', '[{"id":"a","text":"Is this borrower the largest employer in town?"},{"id":"b","text":"Would this project proceed without our gap financing?"},{"id":"c","text":"Does the borrower have a perfect credit score?"},{"id":"d","text":"Does the borrower have an existing relationship with a bank?"}]', 'b', 'The core test for EDA RLF lending is additionality — the loan should fill a genuine gap. If the project would proceed without EDA financing, the EDA loan is unnecessary and possibly not the best use of limited public capital.', 8),
(v_quiz, 'How often must EDA RLF recipients submit reports to EDA?', '[{"id":"a","text":"Monthly"},{"id":"b","text":"Quarterly"},{"id":"c","text":"Semi-annually"},{"id":"d","text":"Annually"}]', 'c', 'EDA RLF recipients are required to submit semi-annual reports documenting their lending activity, job creation, portfolio performance, and financial status.', 9),
(v_quiz, 'What is the long-term sustainability goal for an EDA RLF?', '[{"id":"a","text":"The fund should grow to $100 million within five years"},{"id":"b","text":"Interest and fee income should cover operating costs without continuous grant injections"},{"id":"c","text":"The fund should be transferred to a private lender within 10 years"},{"id":"d","text":"The state should take over fund management after 5 years"}]', 'b', 'A well-designed EDA RLF should be self-sustaining — generating enough interest and fee income to cover its operating costs so the fund can continue serving borrowers without constant new grant injections.', 10)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- CERT 31: EPA, Water & Environmental RLF
-- ═══════════════════════════════════════════════════════════════
SELECT id INTO v_cert FROM certifications WHERE cert_number = 31;

INSERT INTO modules (certification_id, title, sort_order, status)
VALUES (v_cert, 'Environmental Finance: SRFs, Brownfields & WIFIA', 1, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_mod;
IF v_mod IS NULL THEN SELECT id INTO v_mod FROM modules WHERE certification_id = v_cert AND sort_order = 1; END IF;

INSERT INTO lessons (module_id, title, slug, content, sort_order, read_time_minutes, status) VALUES
(v_mod, 'Clean Water and Drinking Water State Revolving Funds', 'clean-water-and-drinking-water-state-revolving-funds',
$$## Clean Water and Drinking Water State Revolving Funds

The Clean Water State Revolving Fund (CWSRF) and Drinking Water State Revolving Fund (DWSRF) are among the largest and oldest revolving loan fund programs in the United States. Together, they have provided over $200 billion in financing for water and wastewater infrastructure across the country.

**How State Revolving Funds Work**
EPA capitalizes state revolving funds with annual grants to states. States must provide a 20% match from state funds. States then use this capital to make loans to local governments, utilities, and eligible nonprofit organizations for water and wastewater infrastructure. As loans are repaid, funds revolve back and are relent to new projects — creating a perpetual source of infrastructure capital.

**Clean Water SRF (CWSRF)**
CWSRF funds are used for: wastewater treatment plant construction and upgrades, collection systems, nonpoint source pollution control, estuary and coastal projects, and green infrastructure. Any municipality or publicly owned entity is eligible. Nonprofits may be eligible for certain project types.

Interest rates are typically below-market — states can offer subsidized rates, forgiven principal (principal forgiveness), or interest-free periods. For affordability-stressed communities, some states offer up to 100% principal forgiveness — essentially turning a loan into a grant.

**Drinking Water SRF (DWSRF)**
DWSRF funds finance: public water system infrastructure, source water protection, emergency response upgrades, and lead service line replacement. Projects must protect public health.

**Who Can Access SRF Funds?**
Directly: municipalities, public utilities, and state agencies. Community organizations can help borrowers (particularly small rural water systems and nonprofits) navigate the application process, develop project plans, and connect with state SRF programs.

**Key Terms**
- **CWSRF**: Clean Water State Revolving Fund — for wastewater and water quality projects.
- **DWSRF**: Drinking Water State Revolving Fund — for public drinking water infrastructure.
- **Principal forgiveness**: A grant-like forgiveness of a portion of an SRF loan, providing additional subsidy.

**Practical Checklist**
- [ ] Identify your state's CWSRF and DWSRF program administrators
- [ ] Review the current NOFA and application requirements for each
- [ ] Assess whether rural water systems in your area could use SRF funding
- [ ] Develop a project readiness guide for small water system borrowers
- [ ] Explore whether your state offers principal forgiveness for disadvantaged communities
$$, 1, 9, 'approved'),

(v_mod, 'EPA Brownfields RLF & Environmental Underwriting', 'epa-brownfields-rlf-environmental-underwriting',
$$## EPA Brownfields RLF & Environmental Underwriting

Brownfields are contaminated or potentially contaminated properties that have been abandoned or underused due to environmental concerns. EPA's Brownfields program provides grants that can be used to establish revolving loan funds specifically for assessing and cleaning up these sites.

**EPA Brownfields RLF Grants**
EPA awards Brownfields RLF grants to eligible applicants (states, tribes, local governments, nonprofits) to capitalize loan funds for cleanup projects. RLF recipients can make loans and subgrants (up to 30% of the RLF award) to eligible entities for brownfield assessment and cleanup.

Grant amounts typically range from $1 million to $5 million per award. EPA issues Notices of Funding Availability (NOFAs) approximately once per year.

**Eligible Uses**
- Loans and subgrants for environmental site assessments
- Cleanup of contaminated properties
- Site preparation activities that support reuse

**Environmental Underwriting Risks**
Lending against brownfield properties requires specialized underwriting skills. Key risks include:
- **Environmental liability**: Lenders can face liability if they foreclose on a contaminated property. Proper environmental reviews (Phase I and Phase II assessments) before closing are essential.
- **Cleanup cost uncertainty**: Estimated cleanup costs can escalate significantly. Build contingencies into your underwriting.
- **Community opposition**: Brownfield redevelopment can face community opposition. Document community engagement.

**Phase I and Phase II Environmental Assessments**
A Phase I environmental assessment is a records review and site inspection to identify "recognized environmental conditions" — potential contamination. If a Phase I identifies concerns, a Phase II assessment involves soil and groundwater sampling to confirm and quantify contamination. Both are standard practice before any lending on potentially contaminated properties.

**Key Terms**
- **Brownfield**: A contaminated or potentially contaminated property with real or perceived environmental issues.
- **Phase I ESA**: Environmental Site Assessment — records review and inspection for recognized environmental conditions.
- **Phase II ESA**: Physical sampling to confirm and characterize contamination found in a Phase I.

**Practical Checklist**
- [ ] Review EPA's current Brownfields RLF NOFA at epa.gov/brownfields
- [ ] Develop an environmental review policy for your lending program
- [ ] Identify environmental consultants in your area who perform Phase I/II assessments
- [ ] Research brownfield sites in your community that need cleanup financing
- [ ] Learn your state's brownfield program and cleanup fund resources
$$, 2, 9, 'approved')
ON CONFLICT DO NOTHING;

INSERT INTO quizzes (certification_id, title, passing_score, time_limit_minutes, status)
VALUES (v_cert, 'EPA, Water & Environmental RLF Assessment', 75, 45, 'approved')
ON CONFLICT DO NOTHING RETURNING id INTO v_quiz;
IF v_quiz IS NULL THEN SELECT id INTO v_quiz FROM quizzes WHERE certification_id = v_cert; END IF;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order) VALUES
(v_quiz, 'Which federal agency administers the Clean Water State Revolving Fund (CWSRF)?', '[{"id":"a","text":"USDA Rural Development"},{"id":"b","text":"U.S. Environmental Protection Agency (EPA)"},{"id":"c","text":"Department of Transportation"},{"id":"d","text":"HUD"}]', 'b', 'EPA administers both the Clean Water and Drinking Water State Revolving Fund programs, providing annual capitalization grants to states.', 1),
(v_quiz, 'What is "principal forgiveness" in the context of SRF programs?', '[{"id":"a","text":"A loan that earns interest for the borrower"},{"id":"b","text":"A grant-like forgiveness of a portion of an SRF loan, providing additional subsidy"},{"id":"c","text":"A fee waiver for environmental assessments"},{"id":"d","text":"A federal guarantee on SRF loans"}]', 'b', 'Principal forgiveness converts a portion of an SRF loan into a de facto grant — the borrower does not have to repay that portion of the principal. States use this tool for their most financially challenged communities.', 2),
(v_quiz, 'What is a brownfield property?', '[{"id":"a","text":"A rural farmland undergoing conservation"},{"id":"b","text":"A contaminated or potentially contaminated property abandoned due to environmental concerns"},{"id":"c","text":"A floodplain with development restrictions"},{"id":"d","text":"A federal superfund site under EPA cleanup"}]', 'b', 'Brownfields are properties contaminated by hazardous substances, pollutants, or contaminants — their actual or perceived contamination complicates reuse and development without EPA or state intervention.', 3),
(v_quiz, 'A Phase I Environmental Site Assessment primarily involves:', '[{"id":"a","text":"Collecting soil and groundwater samples"},{"id":"b","text":"Records review and site inspection to identify recognized environmental conditions"},{"id":"c","text":"Estimating cleanup costs"},{"id":"d","text":"Filing with EPA for cleanup authorization"}]', 'b', 'A Phase I ESA is a records review and site inspection — no sampling. It identifies "recognized environmental conditions" that may warrant further investigation through a Phase II.', 4),
(v_quiz, 'What percentage of an EPA Brownfields RLF award can be made as subgrants (rather than loans)?', '[{"id":"a","text":"Up to 10%"},{"id":"b","text":"Up to 20%"},{"id":"c","text":"Up to 30%"},{"id":"d","text":"Up to 50%"}]', 'c', 'EPA allows Brownfields RLF recipients to use up to 30% of their award as subgrants (non-repayable assistance) for assessment and cleanup activities.', 5),
(v_quiz, 'The state match requirement for EPA SRF capitalization grants is:', '[{"id":"a","text":"10%"},{"id":"b","text":"20%"},{"id":"c","text":"30%"},{"id":"d","text":"No match required"}]', 'b', 'States must provide a 20% match from state funds for EPA SRF capitalization grants — for every $5 in EPA grants, states contribute $1 in state funds.', 6),
(v_quiz, 'WIFIA is a federal infrastructure lending program administered by:', '[{"id":"a","text":"USDA Rural Development"},{"id":"b","text":"EPA"},{"id":"c","text":"Department of Transportation"},{"id":"d","text":"SBA"}]', 'b', 'WIFIA (Water Infrastructure Finance and Innovation Act) is an EPA credit program providing low-interest loans for large water and wastewater infrastructure projects.', 7),
(v_quiz, 'What is a key environmental underwriting risk for lenders considering brownfield properties as collateral?', '[{"id":"a","text":"Low property values in rural areas"},{"id":"b","text":"Environmental liability if the lender forecloses on a contaminated property"},{"id":"c","text":"Zoning restrictions preventing redevelopment"},{"id":"d","text":"Lack of appraisers familiar with brownfield properties"}]', 'b', 'Lenders can face CERCLA liability if they foreclose on a contaminated property and take ownership — making proper environmental review and lender liability protections essential before closing.', 8),
(v_quiz, 'CWSRF funds are primarily used for:', '[{"id":"a","text":"Residential mortgage lending in rural areas"},{"id":"b","text":"Wastewater treatment, collection systems, and water quality projects"},{"id":"c","text":"Brownfield site assessments only"},{"id":"d","text":"Agricultural water rights purchases"}]', 'b', 'The Clean Water SRF finances wastewater treatment, collection systems, nonpoint source pollution control, estuary and coastal projects, and green infrastructure.', 9),
(v_quiz, 'A nonprofit wants to help small rural water systems access DWSRF funding. What is the most appropriate role?', '[{"id":"a","text":"Become a state SRF fund administrator"},{"id":"b","text":"Provide technical assistance and help systems navigate the state SRF application"},{"id":"c","text":"Apply for SRF funds on the water system''s behalf"},{"id":"d","text":"Obtain an EPA brownfields grant"}]', 'b', 'Nonprofits most effectively serve as technical assistance providers — helping small and disadvantaged water systems understand SRF eligibility, prepare applications, and navigate the state SRF program.', 10)
ON CONFLICT DO NOTHING;

END $block$;
