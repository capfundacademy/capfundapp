-- ============================================================
-- Cap Fund Academy — Blog, Affiliate, and Directory Schema
-- File: 22_blog_affiliate_schema.sql
-- Idempotent: safe to re-run
-- Run after: 03_lms_schema.sql, 01_base_schema.sql
-- ============================================================

-- ============================================================
-- blog_posts
-- ============================================================
CREATE TABLE IF NOT EXISTS blog_posts (
  id               uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  title            text NOT NULL,
  slug             text UNIQUE NOT NULL,
  category         text NOT NULL DEFAULT 'general',
  excerpt          text,
  content          text,
  meta_title       text,
  meta_description text,
  featured         boolean NOT NULL DEFAULT false,
  status           text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','published','archived')),
  author_name      text NOT NULL DEFAULT 'Cap Fund Academy',
  published_at     timestamptz,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now()
);

DO $$ BEGIN
  CREATE INDEX IF NOT EXISTS blog_posts_status_idx ON blog_posts (status, published_at DESC);
EXCEPTION WHEN duplicate_table THEN NULL;
END $$;

DROP TRIGGER IF EXISTS set_updated_at ON blog_posts;
CREATE TRIGGER set_updated_at BEFORE UPDATE ON blog_posts FOR EACH ROW EXECUTE FUNCTION tg_set_updated_at();

ALTER TABLE blog_posts ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "blog_posts_public"  ON blog_posts;
DROP POLICY IF EXISTS "blog_posts_admin"   ON blog_posts;
CREATE POLICY "blog_posts_public" ON blog_posts FOR SELECT USING (status = 'published');
CREATE POLICY "blog_posts_admin"  ON blog_posts FOR ALL   USING (get_my_role() IN ('super_admin','admin','instructor'));

-- ============================================================
-- affiliates
-- ============================================================
CREATE TABLE IF NOT EXISTS affiliates (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id         uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  code            text UNIQUE NOT NULL,
  commission_rate numeric(5,2) NOT NULL DEFAULT 10.00,
  status          text NOT NULL DEFAULT 'active' CHECK (status IN ('active','paused','terminated')),
  total_earned    numeric(10,2) NOT NULL DEFAULT 0,
  total_paid      numeric(10,2) NOT NULL DEFAULT 0,
  notes           text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

DROP TRIGGER IF EXISTS set_updated_at ON affiliates;
CREATE TRIGGER set_updated_at BEFORE UPDATE ON affiliates FOR EACH ROW EXECUTE FUNCTION tg_set_updated_at();

ALTER TABLE affiliates ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "affiliates_own"   ON affiliates;
DROP POLICY IF EXISTS "affiliates_admin" ON affiliates;
CREATE POLICY "affiliates_own"   ON affiliates FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "affiliates_admin" ON affiliates FOR ALL    USING (get_my_role() IN ('super_admin','admin'));

-- ============================================================
-- referrals
-- ============================================================
CREATE TABLE IF NOT EXISTS referrals (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  affiliate_id    uuid NOT NULL REFERENCES affiliates(id) ON DELETE CASCADE,
  order_id        uuid REFERENCES orders(id) ON DELETE SET NULL,
  referred_email  text,
  order_amount    numeric(10,2),
  commission      numeric(10,2),
  status          text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','approved','paid','voided')),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

DROP TRIGGER IF EXISTS set_updated_at ON referrals;
CREATE TRIGGER set_updated_at BEFORE UPDATE ON referrals FOR EACH ROW EXECUTE FUNCTION tg_set_updated_at();

ALTER TABLE referrals ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "referrals_own"   ON referrals;
DROP POLICY IF EXISTS "referrals_admin" ON referrals;
CREATE POLICY "referrals_own"   ON referrals FOR SELECT USING (affiliate_id IN (SELECT id FROM affiliates WHERE user_id = auth.uid()));
CREATE POLICY "referrals_admin" ON referrals FOR ALL    USING (get_my_role() IN ('super_admin','admin'));

-- ============================================================
-- Public directory opt-in columns on profiles
-- ============================================================
DO $$ BEGIN
  ALTER TABLE profiles ADD COLUMN public_listing boolean NOT NULL DEFAULT false;
EXCEPTION WHEN duplicate_column THEN NULL;
END $$;

DO $$ BEGIN
  ALTER TABLE profiles ADD COLUMN public_bio text;
EXCEPTION WHEN duplicate_column THEN NULL;
END $$;

DO $$ BEGIN
  ALTER TABLE profiles ADD COLUMN public_org text;
EXCEPTION WHEN duplicate_column THEN NULL;
END $$;

DO $$ BEGIN
  ALTER TABLE profiles ADD COLUMN public_state text;
EXCEPTION WHEN duplicate_column THEN NULL;
END $$;

-- ============================================================
-- Seed starter blog posts (10 posts across all SEO categories)
-- ============================================================
INSERT INTO blog_posts (title, slug, category, excerpt, content, meta_title, meta_description, featured, status, published_at)
VALUES

(
  'What Is USDA RMAP? A Complete Guide for Rural Nonprofits',
  'what-is-usda-rmap-guide',
  'rmap-readiness',
  'The USDA Rural Microentrepreneur Assistance Program (RMAP) provides up to $500,000 in microloan capital to approved rural lenders. Here is everything you need to know before applying.',
  E'## What Is USDA RMAP?\n\nThe Rural Microentrepreneur Assistance Program (RMAP) is a USDA Rural Development program authorized under the Food, Conservation, and Energy Act of 2008 and codified at 7 CFR Part 4280 Subpart D. It provides two types of assistance to approved Microenterprise Development Organizations (MDOs):\n\n1. **Direct loans** from USDA to the MDO, used to capitalize a rural microenterprise revolving loan fund (RMRF)\n2. **Grants** to the MDO to fund technical assistance and training (TA&T) services for rural microentrepreneurs\n\n## Who Is Eligible?\n\nTo apply for RMAP, your organization must be:\n- A private, nonprofit organization, public agency, or federally recognized Indian tribe\n- Have a primary mission of economic development or microenterprise development\n- Have a service area that is primarily rural (USDA-designated)\n- Have an active SAM.gov registration with a current UEI\n\nMicroloans funded by RMAP may only be made to rural microenterprises — businesses with 10 or fewer full-time equivalent employees located in a rural area.\n\n## How Much Can You Borrow?\n\nUSDA RMAP loans to MDOs can be up to $500,000 per application cycle. MDOs may hold multiple RMAP loans simultaneously. The maximum microloan to any individual borrower under RMAP is $50,000, with a maximum term of 10 years.\n\n## The Application Process\n\nRMAP applications are accepted on a rolling basis and reviewed quarterly. USDA uses a competitive scoring rubric with a maximum of 125 points across five categories:\n\n- Organizational capacity (45 points)\n- Microlending experience (30 points)\n- Technical assistance program (15 points)\n- Financial soundness (20 points)\n- Community impact (15 points)\n\nApplications are scored at the USDA National Office level, not the state office. Competition is national.\n\n## What Most Organizations Get Wrong\n\nThe most common reasons RMAP applications fail to score competitively:\n\n1. **No written loan policy** — USDA requires a complete written loan fund policy covering all elements in 7 CFR 4280.315. An absence of a written policy is an automatic deduction.\n2. **Weak TA documentation** — Organizations that provide TA but do not track it cannot demonstrate the program''s impact.\n3. **Missing evidence exhibits** — Every narrative claim must be supported by a cited, labeled exhibit. Unsupported claims do not earn points.\n4. **Expired SAM.gov registration** — An expired registration can delay or prevent an award.\n\n## How Cap Fund Academy Can Help\n\nCap Fund Academy''s RMAP certification track (Certifications 1-5) takes organizations from microfinance fundamentals through application assembly, evidence documentation, and AI-assisted scoring. Our RMAP Application Readiness Binder template provides a complete framework for organizing your submission.\n\n*Cap Fund Academy is an independent training platform. It is not affiliated with or endorsed by USDA. Training does not guarantee funding or eligibility.*',
  'USDA RMAP Guide for Rural Nonprofits | Cap Fund Academy',
  'Complete guide to the USDA Rural Microentrepreneur Assistance Program (RMAP) — eligibility, loan amounts, scoring criteria, and common application mistakes.',
  true, 'published', now() - interval '7 days'
),

(
  'How to Start a Revolving Loan Fund: The 5 Essential Steps',
  'how-to-start-revolving-loan-fund',
  'revolving-loan-funds',
  'A revolving loan fund (RLF) can provide sustainable capital for rural businesses for decades. Here are the five foundational steps every organization must take before making its first loan.',
  E'## What Is a Revolving Loan Fund?\n\nA revolving loan fund (RLF) is a pool of capital that is loaned to borrowers, repaid with interest, and then loaned again to new borrowers. Unlike a grant program that spends down its capital, a well-designed RLF can operate indefinitely from the same initial pool of funds, growing slowly over time through interest income and additional capitalization.\n\nRLFs are used by nonprofits, CDFIs, community development corporations, county economic development agencies, and tribal organizations to provide capital to small businesses and microenterprises that cannot access conventional bank financing.\n\n## Step 1: Define Your Fund Purpose and Target Market\n\nBefore you design anything else, answer these questions:\n- Who will you lend to? (What business types, sizes, geographies?)\n- What will you lend for? (What eligible loan purposes?)\n- How much will loans be? (Minimum and maximum loan sizes)\n- What gap in the existing capital market are you filling?\n\nYour answers define your loan products and drive every subsequent design decision.\n\n## Step 2: Secure Your Capitalization Strategy\n\nAn RLF needs capital before it can make loans. Common sources:\n\n- **USDA RBDG (Rural Business Development Grant)** — grants for establishing rural RLFs, typically $50,000 to $500,000\n- **USDA RMAP** — direct loans at favorable rates to approved rural microenterprise lenders\n- **EDA Revolving Loan Funds** — Economic Development Administration grants for economic development RLFs\n- **CDFI Fund awards** — grants to certified CDFIs for lending capital\n- **Foundations and PRIs** — program-related investments from philanthropic sources\n- **Bank CRA investments** — capital from federally regulated banks seeking CRA credit\n\nMost successful RLFs combine two or more sources to reduce dependence on any single funder.\n\n## Step 3: Write Your Loan Fund Policy\n\nA written loan fund policy is required by USDA and expected by most funders. It should cover:\n- Loan authority and committee structure\n- Eligible borrowers and loan purposes\n- Loan terms (amount, rate, term, collateral, guarantee)\n- Underwriting standards\n- Application and closing process\n- Collections and default procedures\n- Conflict of interest rules\n- Account management (RMRF/LLRF for RMAP funds)\n\n## Step 4: Establish Your Governance Structure\n\nAn RLF needs a loan committee with clear authority, documented procedures, and regular meetings. Loan committee members should have relevant experience (lending, accounting, business development). All loan decisions must be documented in written minutes.\n\n## Step 5: Build Your TA Infrastructure\n\nThe most sustainable RLFs provide technical assistance alongside capital. Borrowers who receive pre- and post-loan TA have lower default rates and better business outcomes. Your TA program should include business planning support, financial management training, and follow-up coaching.\n\n*Cap Fund Academy is an independent training platform. Not affiliated with or endorsed by USDA.*',
  'How to Start a Revolving Loan Fund (5 Steps) | Cap Fund Academy',
  'Learn the 5 essential steps to starting a revolving loan fund: defining your market, capitalization strategy, loan policy, governance, and TA infrastructure.',
  true, 'published', now() - interval '14 days'
),

(
  'USDA RBDG vs RMAP: Which Rural Capital Program Is Right for Your Organization?',
  'rbdg-vs-rmap-comparison',
  'rbdg-readiness',
  'USDA offers two major programs for rural business capital — RBDG and RMAP. Understanding the key differences helps you target your application effort and sequence your capital stack correctly.',
  E'## RBDG and RMAP: Two Different Tools for Rural Capital\n\nThe USDA Rural Business Development Grant (RBDG) and the Rural Microentrepreneur Assistance Program (RMAP) are both administered by USDA Rural Development, but they serve different organizational needs and have different eligibility requirements, competitive dynamics, and fund uses.\n\n## RBDG: The Grant Program\n\n**What it is:** RBDG is a grant program under 7 CFR Part 4280 Subpart E that provides competitive grants to rural public bodies and nonprofits for business opportunity and business enterprise projects.\n\n**Key features:**\n- Grants (no repayment required)\n- No statutory cap on individual awards, but typical awards range from $50,000 to $500,000\n- Can fund RLF establishment for rural small businesses (not limited to microenterprises)\n- Eligible for a broader range of business development activities (incubators, TA, training)\n- Eligible applicants: rural public bodies (counties, municipalities, tribal governments) and nonprofits\n\n**RBDG RLF loans:** May be made to rural small businesses generally — not limited to microenterprises with 10 or fewer employees.\n\n## RMAP: The Microloan Program\n\n**What it is:** RMAP is a direct loan program from USDA to approved MDOs, combined with TA grants, specifically for rural microenterprise lending.\n\n**Key features:**\n- Direct loans from USDA (not grants — repayment required)\n- Maximum loan to MDO: $500,000 per application\n- Microloans to borrowers capped at $50,000, maximum 10-year term\n- Borrowers must be rural microenterprises (≤10 FTE)\n- TA grant component funds microenterprise technical assistance\n- Requires a separate RMRF and LLRF account structure\n\n## Side-by-Side Comparison\n\n| Factor | RBDG | RMAP |\n|--------|------|------|\n| Federal instrument | Grant | Direct loan |\n| Repayment to USDA | No | Yes |\n| Maximum borrower loan | No cap (program-defined) | $50,000 |\n| Borrower eligibility | Rural small businesses | Rural microenterprises (≤10 FTE) |\n| TA component | Not required | Required |\n| Best for | Establishing new RLF | Scaling microloan program |\n\n## The Recommended Sequence\n\nFor most organizations, the optimal capital stack sequence is:\n\n1. **Start with RBDG** to establish the RLF and demonstrate a lending track record\n2. **Apply for RMAP** once you have microloan history and a proven TA program\n3. **Add IRP** when you have substantial capacity and need large-scale relending capital\n\nThis sequence works because RMAP''s competitive scoring gives significant weight to prior microlending experience — which you build through the RBDG-funded RLF.\n\n*Cap Fund Academy is an independent training platform. Not affiliated with or endorsed by USDA.*',
  'USDA RBDG vs RMAP Comparison | Cap Fund Academy',
  'Compare USDA RBDG and RMAP programs side-by-side: eligibility, loan limits, repayment requirements, and which program to apply for first.',
  false, 'published', now() - interval '21 days'
),

(
  '2 CFR 200 Uniform Guidance: What Rural Nonprofit Lenders Must Know',
  '2-cfr-200-uniform-guidance-rural-nonprofits',
  'rlf-accounting-compliance',
  '2 CFR 200 governs how federal grant funds must be managed. For rural nonprofits operating USDA-funded RLFs, understanding allowable costs, procurement, and record retention is essential to staying audit-ready.',
  E'## What Is 2 CFR 200?\n\nTitle 2 of the Code of Federal Regulations, Part 200 — commonly called "Uniform Guidance" or "2 CFR 200" — is the OMB regulation governing administration of all federal grants and cooperative agreements. If your organization receives USDA RMAP technical assistance grants, RBDG grants, or any other federal financial assistance, 2 CFR 200 governs how you manage those funds.\n\n## The Five Core Requirements\n\n### 1. Allowable Costs\nFederal grant funds may only pay for costs that are allowable, allocable, reasonable, and consistently applied. Common unallowable costs for rural nonprofit RLFs include:\n- Alcohol purchases\n- Entertainment and recreation\n- Lobbying and political activities\n- Bad debts or loan losses (cannot charge defaults to a TA grant)\n- Executive compensation above the federal benchmark\n\n### 2. Cost Allocation\nIf your organization operates multiple programs, shared costs (rent, staff time, utilities) must be allocated using a documented Cost Allocation Plan (CAP). Arbitrary allocation or double-charging are violations.\n\n### 3. Procurement Standards\nPurchases with federal grant funds must follow 2 CFR 200 procurement thresholds:\n- Under $10,000: micro-purchase (no competition required if price is reasonable)\n- $10,000-$250,000: informal procurement (2+ price quotes required)\n- Over $250,000: formal competitive procurement (RFP or IFB)\n\n### 4. Record Retention\nRecords related to federal awards must be retained for 3 years after submission of the final financial report. This includes financial records, grant agreements, payroll records, procurement documentation, and all correspondence with USDA.\n\n### 5. Internal Controls\nYour organization must maintain internal controls providing reasonable assurance that federal funds are managed in compliance with all requirements. Key controls include segregation of duties, authorization policies, monthly reconciliations, and supervision of time charges to federal grants.\n\n## The Single Audit Threshold\n\nAny organization that expends $750,000 or more in federal awards during a fiscal year must have a single audit conducted by an independent CPA. For growing RLF organizations with multiple federal sources, this threshold can be reached quickly.\n\n## What USDA Auditors Look For\n\nDuring site visits and audits, USDA specifically examines:\n- Whether program income (microloan interest) is tracked and allocated correctly\n- Whether RMRF and LLRF accounts are maintained separately\n- Whether all expenditures from the TA grant are allowable and documented\n- Whether the organization''s Cost Allocation Plan is written and consistently applied\n\n*Cap Fund Academy is an independent training platform. Not affiliated with or endorsed by USDA.*',
  '2 CFR 200 Guide for Rural Nonprofit Lenders | Cap Fund Academy',
  'What rural nonprofits running USDA-funded revolving loan funds must know about 2 CFR 200 Uniform Guidance: allowable costs, procurement, record retention, and single audit.',
  false, 'published', now() - interval '28 days'
),

(
  'RMAP Application Scoring: How USDA Reviews Your Application',
  'rmap-application-scoring-how-usda-reviews',
  'rmap-readiness',
  'Understanding how USDA scores RMAP applications is the single most valuable thing you can do before assembling your packet. Here is a plain-English breakdown of the scoring rubric.',
  E'## How USDA Scores RMAP Applications\n\nUSDA scores RMAP applications using a competitive rubric with a maximum of 125 points. Applications are reviewed at the national level on a quarterly basis. Organizations that score above a threshold determined by available funding and quarterly competition are selected for awards.\n\n## The Five Scoring Categories\n\n### Category A: Organizational Capacity (45 points)\nThe highest-weighted category. USDA looks for:\n- Evidence that the service area is rural (USDA designation)\n- Strong board governance with relevant experience\n- Documented loan committee with clear authority\n- Qualified lending staff\n- Complete written loan fund policy\n- Succession plan for key personnel\n\n**Common gap:** Organizations with strong missions but weak governance documentation lose 10-15 points in this category.\n\n### Category B: Microlending Experience (30 points)\nFor experienced microlenders only. USDA reviews:\n- Volume and dollar amount of microloans originated in the prior 3 fiscal years\n- Percentage of loans made to rural microenterprises\n- Delinquency and default rates\n- On-time payment rates\n\n**Common gap:** Organizations that made microloans but did not track rural designations for each borrower cannot document rural percentages.\n\n### Category C: Technical Assistance Program (15 points)\nUSDA scores your TA program on:\n- Types of TA offered (individual counseling, group workshops, online)\n- Documentation of TA hours and outcomes\n- Connection between TA and loan repayment outcomes\n\n**Common gap:** Organizations that provide TA but do not log sessions, track attendees, and measure outcomes cannot score well in this category.\n\n### Category D: Financial Soundness (20 points)\nUSDA reviews:\n- Audited or reviewed financial statements for the 2-3 most recent years\n- LLRF adequacy (must be ≥5% of outstanding RMAP principal)\n- Revenue diversity and organizational sustainability\n\n**Common gap:** Organizations without current audited financials lose significant points.\n\n### Category E: Community Impact (15 points)\nUSDA scores:\n- Jobs created and retained (documented, not projected)\n- Letters of support from relevant partners\n- Demographic data on borrowers served\n\n**Common gap:** Letters of support from generic community contacts score less than specific letters of commitment from SBDCs, banks, and county economic development offices.\n\n## Self-Scoring Before Submission\n\nBefore submitting, score your own application against this rubric. If you cannot justify a score above the midpoint in any category, identify the specific evidence gap and address it. Cap Fund Academy''s AI scoring tool and evidence crosswalk workbook (available with Certification 12) provide a structured framework for this process.\n\n*Cap Fund Academy is an independent training platform. Not affiliated with or endorsed by USDA.*',
  'RMAP Application Scoring Guide | Cap Fund Academy',
  'How USDA scores RMAP applications: a plain-English breakdown of all 125 scoring points across organizational capacity, microlending experience, TA, financial soundness, and community impact.',
  true, 'published', now() - interval '3 days'
),

(
  'Microlending Basics: What Every Rural Lender Needs to Know',
  'microlending-basics-rural-lender',
  'microlending-basics',
  'Microlending for rural small businesses requires understanding borrower-centered principles, credit assessment for thin-file borrowers, and the regulatory framework that governs federal programs.',
  E'## What Is Microlending?\n\nMicrolending is the practice of making small loans — typically under $50,000 — to small businesses and microenterprises that cannot access conventional bank financing. Rural microlenders fill a critical gap in the capital market: banks find small loans unprofitable to underwrite, leaving many rural entrepreneurs without access to affordable business capital.\n\nRural microlenders in the United States typically operate under one or more federal programs — USDA RMAP, RBDG, IRP, or SBA Microloan — and provide technical assistance alongside capital.\n\n## The Borrower-Centered Lending Philosophy\n\nEffective microlenders start from the borrower''s perspective, not the lender''s. Rather than asking "does this borrower meet our criteria?" they ask "what does this borrower need to succeed, and can a loan be part of that?"\n\nThis means:\n- Assessing repayment capacity realistically, not optimistically\n- Sizing the loan to the business need, not the maximum allowed\n- Providing TA before and after the loan, not just at closing\n- Structuring repayment schedules to match the borrower''s cash flow\n\n## Credit Assessment for Thin-File Borrowers\n\nMany rural microentrepreneurs have limited or no credit history with traditional bureaus. Microlenders use alternative credit signals:\n- Rent payment history\n- Utility payment history\n- Cell phone and internet payment history\n- Evidence of savings and financial management\n- Character references from community members\n- Business account activity\n\n## The Six Cs of Microloan Underwriting\n\nSuccessful microloan underwriting assesses all six Cs:\n1. **Character** — payment history, references, community standing\n2. **Capacity** — monthly cash flow relative to proposed payment\n3. **Capital** — borrower''s own investment in the business\n4. **Collateral** — assets that can secure the loan\n5. **Conditions** — loan purpose, market conditions, business viability\n6. **Credit** — credit history (using alternative data when traditional history is thin)\n\n## Protecting Borrowers\n\nResponsible microlenders follow client protection principles:\n- Disclose all costs, fees, and rates in writing before signing\n- Assess repayment capacity using realistic projections\n- Avoid over-lending (matching loan size to demonstrated need)\n- Treat all borrowers with dignity and respect in collections\n- Maintain a complaint resolution process\n\n*Cap Fund Academy is an independent training platform. Not affiliated with or endorsed by USDA.*',
  'Microlending Basics for Rural Lenders | Cap Fund Academy',
  'Essential microlending concepts for rural lenders: borrower-centered philosophy, credit assessment for thin-file borrowers, the six Cs of underwriting, and client protection principles.',
  false, 'published', now() - interval '35 days'
),

(
  'IRP: The Intermediary Relending Program Explained',
  'irp-intermediary-relending-program-explained',
  'irp-readiness',
  'The USDA Intermediary Relending Program offers 30-year loans at 1% to eligible intermediaries. Here is what IRP is, who qualifies, and how it fits into a rural capital stack.',
  E'## What Is the IRP?\n\nThe Intermediary Relending Program (IRP) is a USDA Rural Development direct loan program authorized under 7 U.S.C. 1932(b). USDA lends money to eligible intermediary organizations at 1% fixed interest for up to 30 years. The intermediaries then relend the funds to rural businesses and individuals at market rates, earning an interest rate spread that supports their operations.\n\nUnlike RMAP (which is partly grant-funded) and RBDG (which is entirely grant-funded), IRP funds must be repaid to USDA. This makes IRP a debt instrument for the intermediary, not a grant.\n\n## IRP Loan Terms\n\n**From USDA to the intermediary:**\n- Interest rate: 1% fixed\n- Maximum term: 30 years\n- Maximum per application: $2,000,000\n\n**From the intermediary to borrowers:**\n- Maximum loan per borrower: $400,000\n- Maximum term: 30 years\n- Interest rate: market rate or below (intermediary sets the rate)\n\n## Who Is Eligible?\n\nEligible IRP intermediaries are limited to:\n- Public bodies (state, tribal, or local government entities)\n- Nonprofit entities organized under state nonprofit law\n- Cooperatives\n\nThe intermediary must demonstrate capacity to operate a lending program, a primarily rural service area, and a track record of providing capital or services to rural businesses.\n\n## IRP in the Capital Stack\n\nMost successful rural lenders approach the capital stack in phases:\n1. **Phase 1:** RBDG grant to establish the RLF and build a lending track record\n2. **Phase 2:** RMAP direct loan to scale the microloan program\n3. **Phase 3:** IRP for larger loans (up to $400,000) when organizational capacity supports it\n\nIRP is best suited for organizations that have already demonstrated successful microlending and TA operations under RMAP or RBDG and want to serve larger rural businesses that need more than the $50,000 RMAP maximum.\n\n## The Interest Rate Spread\n\nAt 1% to the intermediary, IRP creates a sustainable interest rate spread. If the intermediary relends at 6%, the 5-point spread generates income to cover:\n- USDA loan repayment\n- Loan loss reserves\n- Administrative costs\n- TA program costs\n\nThis spread is what makes IRP financially sustainable for intermediaries over a 30-year horizon.\n\n*Cap Fund Academy is an independent training platform. Not affiliated with or endorsed by USDA.*',
  'IRP Intermediary Relending Program Explained | Cap Fund Academy',
  'How USDA''s Intermediary Relending Program works: 1% fixed rate, 30-year terms, eligibility requirements, and how IRP fits into a rural capital stack after RBDG and RMAP.',
  false, 'published', now() - interval '42 days'
),

(
  'Rural Economic Development: 5 Ways RLFs Create Lasting Impact',
  'rural-economic-development-rlf-impact',
  'rural-economic-development',
  'Revolving loan funds are uniquely positioned to create measurable, sustained rural economic impact. Here are five specific mechanisms through which RLFs build rural economies that traditional banking cannot replicate.',
  E'## The Rural Capital Gap\n\nRural communities across the United States face a persistent capital access gap. Commercial banks have consolidated, closed rural branches, and raised minimum loan thresholds that exclude the small loan sizes rural microenterprises need. The result: rural entrepreneurs with viable businesses and genuine repayment capacity cannot access affordable capital.\n\nRevolving loan funds, particularly those funded through USDA programs, are specifically designed to fill this gap. Here are five ways they create measurable, lasting impact.\n\n## 1. Job Creation at the Margin\n\nUSDA-funded RLFs target the businesses that create the most jobs per dollar invested: rural microenterprises. A $30,000 microloan to a rural home services business that allows the owner to hire two part-time employees may not make headlines, but multiplied across hundreds of borrowers, the impact is substantial.\n\nCapital Fund Academy certification graduates track job creation using USDA-required methods: counting new FTE positions created and existing positions retained, verified at 12-month follow-up rather than projected at loan origination.\n\n## 2. Keeping Capital Local\n\nWhen USDA capitalizes a local RLF, those dollars circulate in the local economy repeatedly. As principal is repaid, it is re-loaned to new borrowers in the same community. A single $200,000 RBDG capitalization can generate $600,000-$1,000,000 in local loans over a decade as the fund revolves.\n\n## 3. Building Financial Inclusion\n\nThe most impactful RLFs specifically serve borrowers who have been excluded from conventional banking: women-owned businesses, minority-owned businesses, veteran entrepreneurs, and low-income rural residents. USDA tracks these demographics and scores RLF applications in part on their success in reaching underserved populations.\n\n## 4. Anchoring Technical Assistance\n\nUSDA RMAP requires approved microlenders to provide technical assistance to borrowers. This TA requirement is not a bureaucratic checkbox — it is a design feature that increases loan performance. Research consistently shows that borrowers who receive pre-loan business planning TA have lower delinquency rates.\n\n## 5. Demonstrating Credit Worthiness\n\nA successful RLF loan can be a rural entrepreneur''s first documented credit history, opening doors to larger conventional loans in the future. Many RMAP microlenders partner with local banks to provide a credit-building pathway for borrowers who graduate from microloans to conventional financing.\n\n*Cap Fund Academy is an independent training platform. Not affiliated with or endorsed by USDA.*',
  'How RLFs Create Rural Economic Impact | Cap Fund Academy',
  'Five specific ways revolving loan funds create lasting rural economic development: job creation, local capital circulation, financial inclusion, TA anchoring, and credit building.',
  false, 'published', now() - interval '49 days'
),

(
  'USDA Environmental Review Requirements for Microlenders',
  'usda-environmental-review-microlenders',
  'grant-application-preparation',
  'NEPA environmental review is required before obligating RMAP funds for any microloan project. Most microloans qualify for a categorical exclusion — but you must complete the screening worksheet before closing.',
  E'## Why Environmental Review Matters for RMAP Microlenders\n\nWhen USDA provides loan or grant capital to capitalize your revolving loan fund, every project funded with those dollars inherits environmental review obligations under the National Environmental Policy Act (NEPA). This does not mean every $5,000 microloan requires an Environmental Impact Statement — but it does mean that every loan requires at least a completed environmental screening worksheet.\n\nThe most common environmental compliance finding in USDA site visits: funds were obligated (a commitment letter was signed or a loan was closed) before environmental clearance was obtained.\n\n## The Three-Tier System\n\n**Tier 1: Categorical Exclusion (CE)**\nMost RMAP microloans qualify for a categorical exclusion — a category that USDA has determined does not have a significant environmental effect. Common CEs for microloans:\n- Working capital loans with no physical site changes\n- Equipment purchases not affixed to real property\n- Inventory purchases\n- Loans to existing businesses in existing spaces with no physical changes\n\nFor a CE, complete the environmental screening worksheet, document the CE category, and proceed.\n\n**Tier 2: Environmental Assessment (EA)**\nRequired when a project does not clearly fit a CE and may have some environmental effect. EAs are uncommon for microloans.\n\n**Tier 3: Environmental Impact Statement (EIS)**\nRequired for major federal actions with significant environmental effects. Effectively never occurs for RMAP microloans.\n\n## When a Phase I Environmental Site Assessment Is Required\n\nA Phase I ESA is required when:\n- Real property is used as collateral\n- The loan involves purchase of real property\n- There is reason to believe the property has environmental concerns\n- The project involves new construction or ground disturbance\n\n## The Critical Rule: Clearance Before Commitment\n\nEnvironmental clearance must be obtained before any action that commits funds to a specific project. Signing a loan commitment letter before completing environmental review is a violation — and it is the most common RMAP compliance finding.\n\n**Correct sequence:**\n1. Receive loan application\n2. Complete environmental screening worksheet\n3. Determine CE or initiate EA/Phase I\n4. Obtain environmental clearance\n5. Sign commitment letter\n6. Close loan\n\n*Cap Fund Academy is an independent training platform. Not affiliated with or endorsed by USDA.*',
  'USDA Environmental Review for RMAP Microlenders | Cap Fund Academy',
  'NEPA environmental review requirements for USDA RMAP microlenders: categorical exclusions, Phase I ESA triggers, and the critical timing rule — clearance before commitment.',
  false, 'published', now() - interval '56 days'
),

(
  'Technical Assistance for Microentrepreneurs: What Works and What Does Not',
  'technical-assistance-microentrepreneurs-what-works',
  'technical-assistance-entrepreneurs',
  'Not all TA is equally effective. Research on microenterprise development consistently identifies specific TA approaches that improve loan repayment rates and business survival — and others that do not.',
  E'## The Evidence on TA Effectiveness\n\nNot all technical assistance is equally effective. USDA RMAP requires approved microlenders to provide TA to microentrepreneurs, but the regulations leave program design to the MDO. This flexibility means some organizations design TA programs that genuinely improve borrower outcomes — and others design programs that satisfy reporting requirements without moving the needle.\n\n## What the Research Shows\n\n**High-impact TA approaches:**\n\n1. **One-on-one business planning counseling** — individualized sessions that address a borrower''s specific situation consistently outperform group-only approaches. The most effective sessions are goal-oriented, with clear action items and follow-up.\n\n2. **Pre-loan TA** — TA provided before the loan application, focused on loan readiness (cash flow analysis, business planning, financial recordkeeping), is associated with lower delinquency rates in multiple studies.\n\n3. **Financial management coaching** — teaching borrowers to read their own financial statements, track income and expenses, and project cash flow produces durable skills that persist beyond the loan relationship.\n\n4. **Peer groups and cohort learning** — structured peer groups where borrowers share challenges and solutions create accountability and reduce isolation for rural entrepreneurs.\n\n**Lower-impact TA approaches:**\n\n- One-time workshops with no follow-up\n- Generic small business content not tailored to the rural microenterprise context\n- Mandatory TA that borrowers experience as a burden rather than a benefit\n- TA delivered by advisors without practical business experience\n\n## The TA Documentation Requirement\n\nUSDA requires RMAP-approved MDOs to document all TA activities. Required documentation includes:\n- Date and duration of each session\n- Topics covered\n- Attendees or client served\n- Objectives and outcomes\n- Connection to microloan activity\n\nOrganizations that provide excellent TA but do not document it cannot demonstrate the program''s impact in USDA applications — and lose points in the technical assistance scoring category.\n\n## Building a TA Program That Scores Well\n\nThe most competitive RMAP TA programs demonstrate:\n- A structured curriculum, not ad hoc sessions\n- Systematic outcome tracking (business survival, revenue growth, loan repayment)\n- A documented connection between TA completion and loan performance\n- A variety of delivery formats (individual, group, distance)\n- Partnerships with SBDCs, community colleges, or other TA providers\n\n*Cap Fund Academy is an independent training platform. Not affiliated with or endorsed by USDA.*',
  'Technical Assistance for Microentrepreneurs: What Works | Cap Fund Academy',
  'Research-backed TA approaches that improve microloan repayment rates and business survival for rural microentrepreneurs. Plus USDA documentation requirements.',
  false, 'published', now() - interval '63 days'
)

ON CONFLICT (slug) DO NOTHING;
