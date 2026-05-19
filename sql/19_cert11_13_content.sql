-- ============================================================
-- Cap Fund Academy — Certs 11-13 Full Content
-- File: 19_cert11_13_content.sql
-- Idempotent: ON CONFLICT DO NOTHING
-- Run after: 04_cert_seeds.sql
-- ============================================================

-- ============================================================
-- CERT 11: RLF Accounting, Fund Administration, Reporting & Audit Readiness
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

SELECT id INTO cert_id FROM certifications WHERE cert_number = 11;
IF cert_id IS NULL THEN
  RAISE EXCEPTION 'Cert 11 not found — run 04_cert_seeds.sql first';
END IF;

UPDATE certifications SET
  learning_outcomes = ARRAY[
    'Map RLF capital, loan repayments, program income, grants, administrative costs, and reserves to separate restricted fund accounts',
    'Calculate RMRF and LLRF reserve requirements and design account controls that comply with USDA requirements',
    'Build a reporting calendar covering quarterly USDA narratives, SF-270 requests, annual audits, and portfolio reports',
    'Assemble an audit-ready file for a USDA site visit including loan files, board minutes, invoices, procurement records, and bank reconciliations',
    'Define the core RLF portfolio metrics — capital deployed, PAR, delinquency rate, write-off rate, liquidity ratio — and build a dashboard to track them',
    'Distinguish allowable program income uses from restricted RLF capital and apply 2 CFR 200 to fund accounting decisions',
    'Prepare for a single audit by understanding the $750,000 expenditure threshold and maintaining compliant financial management systems'
  ],
  status = 'approved'
WHERE id = cert_id;

-- MODULE 1
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'RLF Fund Accounting',
  'Master restricted fund accounting for revolving loan funds. Covers account structure, fund segregation, loan receivables, allowance for loan losses, program income, and the chart of accounts for a USDA-funded RLF.',
  1, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod1_id FROM modules WHERE certification_id = cert_id AND sort_order = 1;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod1_id,
  'RLF Fund Accounting Fundamentals',
  'cert11-rlf-fund-accounting',
  E'## Why RLF Accounting Is Different\n\nA revolving loan fund does not operate like a general operating account. It is a restricted fund — capital provided by federal grantors or lenders with specific restrictions on how it may be used, how income from it is treated, and how it must be reported. Failure to maintain proper fund accounting is one of the most common findings in USDA site visits and audits, and it can result in disallowed costs, repayment demands, or suspension of the award.\n\nThe core principle of RLF fund accounting is **segregation**: every dollar that enters the RLF must be traceable to its source, and every dollar that leaves must be traceable to an authorized use. This requires a chart of accounts that separates RLF funds from the organization''s general operating funds — not just in reporting, but in actual bank accounts.\n\n## The RLF Capital Cycle\n\nUnderstanding the capital cycle is essential before designing the accounting system:\n\n1. **Capitalization** — Federal grant (RBDG) or federal loan (RMAP, IRP) funds are received and deposited into the RLF revolving fund\n2. **Disbursement** — Funds are loaned to eligible borrowers\n3. **Repayment** — Borrowers make principal and interest payments\n4. **Program income** — Interest income and fees earned on outstanding loans\n5. **Re-lending** — Principal repayments are available for new loans\n6. **Reserves** — A portion of interest income (for RMAP: the Loan Loss Reserve Fund) is set aside for defaults\n7. **Administration** — A portion of program income may be used for RLF administrative costs, within program limits\n\n## Required Account Structure\n\n**For RMAP-funded RLFs:**\n\nUSDA requires that RMAP funds be maintained in two accounts:\n\n**RMRF (Rural Microentrepreneur Revolving Fund):**\nThe primary revolving fund. Receives RMAP grant funds and principal repayments from microloans. Used exclusively for making new microloans. Cannot be used for administrative costs.\n\n**LLRF (Loan Loss Reserve Fund):**\n5% of outstanding RMAP-funded microloan principal must be maintained in this account at all times. The LLRF is funded from RMAP grant funds at origination and from interest income. It is used to cover losses on defaulted RMAP-funded microloans.\n\n**Interest income from RMAP microloans:**\nAfter funding the LLRF requirement, interest income may be used for:\n- Additional microloan capital (deposited to RMRF)\n- Eligible administrative costs (with limits)\n- TA&T program costs\n\n**For RBDG-funded RLFs:**\n\nRBDG grant funds must be held in a separate interest-bearing account. Interest earned on idle RBDG funds is program income that must be used for authorized RLF purposes or returned to the federal government.\n\n## Chart of Accounts for an RLF\n\nA properly designed RLF chart of accounts separates:\n\n**Assets:**\n- Cash — RMRF Operating Account (bank account 1)\n- Cash — LLRF Reserve Account (bank account 2)\n- Cash — RBDG RLF Account (bank account 3, if applicable)\n- Cash — General Operating Account (bank account 4 — general funds, never commingled)\n- Loans Receivable — RMAP Microloans\n- Loans Receivable — RBDG RLF Loans\n- Allowance for Loan Losses (contra-asset, reduces net receivable)\n- Accrued Interest Receivable\n\n**Liabilities:**\n- RMAP Loan Payable to USDA (for RMAP direct loan principal outstanding)\n- IRP Loan Payable to USDA (if applicable)\n- Deferred Program Income\n\n**Net Assets / Fund Balances (for nonprofits):**\n- With Donor/Grantor Restrictions — RMAP RLF Capital\n- With Donor/Grantor Restrictions — RBDG RLF Capital\n- Without Restrictions — General Operating\n\n**Revenue:**\n- Microloan Interest Income (RMAP)\n- Microloan Fee Income (RMAP)\n- RLF Loan Interest Income (RBDG)\n- USDA Grant Revenue (RMAP TA grant)\n- USDA Grant Revenue (RBDG)\n\n**Expenses:**\n- Loan Loss Provision (increases allowance for loan losses)\n- RLF Administrative Salaries\n- RLF Administrative Other\n- TA Program Expenses\n\n## Loan Receivable Accounting\n\nWhen a microloan is disbursed:\n- **Debit:** Loans Receivable — RMAP Microloans\n- **Credit:** Cash — RMRF Operating Account\n\nWhen a borrower makes a payment (principal + interest):\n- **Debit:** Cash — RMRF (principal portion)\n- **Debit:** Cash — RMRF (interest portion, before LLRF allocation)\n- **Credit:** Loans Receivable — RMAP Microloans (principal)\n- **Credit:** Microloan Interest Income (interest)\n\nWhen the LLRF is funded from interest:\n- **Debit:** LLRF Contribution Expense (or Interest to LLRF)\n- **Credit:** Cash — LLRF Reserve Account\n\n## Allowance for Loan Losses (ALL)\n\nThe allowance for loan losses is a contra-asset that reduces the net reported value of the loan portfolio to its estimated collectible amount. It is not a cash account — it is an accounting estimate.\n\n**Calculating the ALL:**\nMost RLFs use a historical loss rate method:\n1. Determine your historical loss rate (charge-offs ÷ average outstanding portfolio over a period)\n2. Apply that rate to the current outstanding portfolio\n3. The result is the required ALL balance\n\nFor new RLFs with no loss history, a peer comparison rate (e.g., 3-5% for microenterprise portfolios) is used as an estimate.\n\n**Journal entry to establish or adjust the ALL:**\n- **Debit:** Loan Loss Provision (income statement expense)\n- **Credit:** Allowance for Loan Losses (balance sheet contra-asset)\n\nWhen a loan is actually charged off (declared uncollectible):\n- **Debit:** Allowance for Loan Losses\n- **Credit:** Loans Receivable\n\nAny subsequent recovery on a charged-off loan:\n- **Debit:** Cash\n- **Credit:** Allowance for Loan Losses (or a Recovery account)',
  'RLF fund accounting requires complete segregation of restricted capital across separate RMRF, LLRF, and RBDG accounts. A proper chart of accounts tracks loan receivables, allowance for loan losses, program income, and reserves by source.',
  24, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 2
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'RMRF/LLRF Controls and Reserve Management',
  'Set up RMRF and LLRF account controls. Calculate reserve requirements, design replenishment procedures, and implement the internal controls that protect restricted RLF capital from misuse.',
  2, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod2_id FROM modules WHERE certification_id = cert_id AND sort_order = 2;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod2_id,
  'RMRF and LLRF Account Controls',
  'cert11-rmrf-llrf-controls',
  E'## The RMRF and LLRF: Legal Requirements\n\nUSDA regulations at 7 CFR 4280.336 establish the specific requirements for maintaining the Revolving Microentrepreneur Revolving Fund (RMRF) and the Loan Loss Reserve Fund (LLRF). These requirements are not optional accounting preferences — they are legal obligations that USDA verifies at every site visit.\n\n**RMRF requirements:**\n- Must be maintained in a separate interest-bearing account\n- May only receive: RMAP grant funds from USDA, principal repayments from RMAP-funded microloans, and any program income authorized by USDA for deposit\n- May only be used for: making new RMAP-funded microloans to eligible microenterprises\n- May not be commingled with general operating funds or other grant funds\n- First lien security interest required on all collateral securing RMAP microloans\n\n**LLRF requirements:**\n- Must be maintained in a separate interest-bearing account, distinct from the RMRF\n- Must equal at least 5% of the outstanding principal balance of all RMAP-funded microloans at all times\n- Is funded initially from RMAP grant funds at the time of closing\n- Is replenished from RMAP microloan interest income when the balance falls below 5%\n- Is used exclusively to cover losses (charge-offs) on defaulted RMAP-funded microloans\n- Cannot be used for administrative costs or TA expenses\n\n## Calculating the LLRF Requirement\n\nThe LLRF balance must always equal or exceed 5% of outstanding RMAP microloan principal.\n\n**Example calculation:**\n\n| Outstanding RMAP Principal | Required LLRF Balance |\n|---------------------------|----------------------|\n| $200,000 | $10,000 |\n| $350,000 | $17,500 |\n| $500,000 | $25,000 |\n\n**LLRF monitoring process:**\n1. Pull the outstanding RMAP loan schedule at month-end\n2. Sum the outstanding principal balances\n3. Multiply by 5%\n4. Compare to actual LLRF account balance\n5. If LLRF is below required level, replenish from interest income before any other use of interest\n\n**LLRF replenishment journal entry:**\n- Debit: LLRF Replenishment Expense (or transfer from Interest Income)\n- Credit: Cash — LLRF Account\n\n## Segregation of Duties for RMRF/LLRF\n\nThe most important internal control for restricted RLF accounts is segregation of duties. No single person should have both the ability to authorize transactions and the ability to execute them.\n\n**Required segregation for RMRF/LLRF:**\n\n| Function | Person 1 (Loan Officer) | Person 2 (Accountant) | Person 3 (ED/CFO) |\n|----------|------------------------|----------------------|------------------|\n| Authorize loan disbursement | X | | |\n| Execute wire/check from RMRF | | X | |\n| Reconcile RMRF monthly | | | X |\n| Authorize LLRF replenishment | | | X |\n| Execute LLRF transfer | | X | |\n| Reconcile LLRF monthly | | | X |\n\nFor small organizations where full three-way segregation is impossible, compensating controls include:\n- Monthly bank statement review by the board treasurer or finance committee\n- Dual signatures on checks above a threshold\n- Read-only online bank access for the Executive Director\n\n## Bank Account Structure\n\nUSDA expects the following minimum bank account structure for an RMAP-funded organization:\n\n1. **RMRF Account** — labeled as "RMAP Rural Microentrepreneur Revolving Fund — [Organization Name]"\n2. **LLRF Account** — labeled as "RMAP Loan Loss Reserve Fund — [Organization Name]"\n3. **General Operating Account** — for all non-RMAP activities\n4. **RMAP TA Grant Account** (optional but recommended) — for tracking TA grant receipts and expenditures separately\n\nIf your organization also holds RBDG funds:\n5. **RBDG RLF Account** — for RBDG-capitalized RLF\n\nAll RMRF and LLRF accounts must be:\n- FDIC-insured or held in a federally insured credit union\n- Interest-bearing\n- Held at a federally insured depository institution\n- Never invested in equity securities or uninsured instruments\n\n## Program Income Rules\n\n2 CFR 200.307 governs how program income — interest and fees earned on RMAP-funded microloans — must be managed.\n\n**Permitted uses of RMAP program income:**\n1. **First priority:** Fund the LLRF to the 5% requirement\n2. **Second priority:** With USDA approval, fund reasonable and necessary RLF administrative costs\n3. **Third priority:** Re-lend as additional RMAP microloans (deposit to RMRF)\n\n**Program income that cannot be used for:**\n- General operating expenses unrelated to the RMAP program\n- Compensation of organizational leadership in excess of the federally benchmarked rate\n- Lobbying or political activities\n- Any unallowable cost under 2 CFR 200 Subpart E\n\n**Program income tracking:**\nMaintain a separate program income ledger that shows:\n- Month and year earned\n- Amount (interest vs. fees)\n- Allocation decision (LLRF / admin / RMRF)\n- Authorization (who approved the allocation)\n\nThis ledger is a standard item in USDA site visit document requests.',
  'RMRF must stay separate from all other funds and fund only RMAP microloans. LLRF must equal 5% of outstanding RMAP principal at all times. Segregation of duties and a program income ledger are required controls.',
  20, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 3
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Reporting Calendar and USDA Submissions',
  'Build the complete RLF reporting calendar covering quarterly narrative reports, SF-270 drawdown requests, annual portfolio reports, job creation reporting, and single audit coordination.',
  3, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod3_id FROM modules WHERE certification_id = cert_id AND sort_order = 3;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod3_id,
  'USDA Reporting Requirements and Calendar',
  'cert11-usda-reporting-calendar',
  E'## The USDA Reporting Burden\n\nReceiving USDA RMAP or RBDG funding means accepting an ongoing reporting relationship with USDA Rural Development. Reporting is not optional, and late or incomplete reports can result in technical default on the grant agreement, suspension of future drawdowns, and referral to USDA''s Office of Inspector General.\n\nBuilding a reporting calendar — and assigning specific owners to each deliverable — is the most effective way to stay compliant without crisis-mode report writing.\n\n## RMAP Reporting Requirements\n\n**Quarterly Activity Reports**\nDue within 30 days after the end of each federal fiscal year quarter (January 30, April 30, July 30, October 30).\n\nRequired content:\n- Number of microloans made during the quarter\n- Dollar amount of microloans made\n- Number of microenterprises assisted with TA\n- Type and hours of TA provided\n- Number of jobs created and retained\n- Demographic data on borrowers (race, ethnicity, gender, veteran status)\n- LLRF balance and RMRF balance\n- Delinquency statistics (30+, 60+, 90+ days)\n- Any defaults or charge-offs during the quarter\n\n**Annual Performance Report**\nDue October 30 (30 days after federal fiscal year end). More comprehensive than quarterly, covering the full year''s lending and TA activity, portfolio performance, financial summary, and narrative on program outcomes.\n\n**RMRF Financial Statement**\nAnnual financial statement for the RMRF account, prepared and submitted to USDA. Must be reviewed or audited depending on the organization''s expenditure level.\n\n**SF-270 Request for Advance or Reimbursement**\nUsed to request grant fund drawdowns from USDA. For RMAP TA grants, organizations typically submit SF-270s quarterly or as needed. Requirements:\n- Itemized by budget category\n- Supported by backup documentation (payroll records, invoices, receipts)\n- Submitted through the appropriate USDA system (RD Apply or state office process)\n- Must reconcile to the general ledger\n\n**RLF Portfolio Report**\nSome state offices require a separate loan-level portfolio report listing every outstanding microloan with: borrower name (or code), original amount, disbursement date, outstanding balance, payment status (current/30/60/90+), collateral type, and last payment date.\n\n## RBDG Reporting Requirements\n\n**Quarterly Progress Reports**\nRequired format varies by state office. Generally covers:\n- Activities completed during the quarter aligned to the approved scope of work\n- Expenditures vs. budget\n- Jobs created or retained\n- RLF activity (loans made, repayments received, outstanding balance)\n\n**SF-270 Drawdowns**\nSame as RMAP — submit quarterly or as needed, with full backup documentation.\n\n**Final Performance Report**\nDue within 90 days after the grant period ends. Comprehensive summary of all activities, outcomes, and financial expenditures. Often requires USDA state office approval before the grant is fully closed out.\n\n## Building the Reporting Calendar\n\nA reporting calendar should show, for each report:\n- **Report name and program**\n- **Due date** (federal deadline, not the date you start writing)\n- **Internal deadline** (2-3 weeks before due date for internal review)\n- **Data required** (what financial and program data must be compiled)\n- **Data owner** (who provides the data)\n- **Report writer** (who assembles the report)\n- **Reviewer** (who reviews before submission)\n- **Submission method** (online system, email, mail)\n\n**Annual Reporting Calendar for an RMAP Microlender:**\n\n| Due Date | Report | Internal Prep Start |\n|----------|--------|---------------------|\n| Jan 30 | RMAP Q1 Activity Report | Jan 10 |\n| Apr 30 | RMAP Q2 Activity Report | Apr 10 |\n| Jul 30 | RMAP Q3 Activity Report | Jul 10 |\n| Oct 30 | RMAP Q4 Activity Report + Annual Performance Report | Oct 1 |\n| Varies | SF-270 TA Grant Drawdown | Rolling, as needed |\n| 90 days post-grant-end | Final closeout report | 60 days post-grant-end |\n\n## Single Audit Coordination\n\nOrganizations that expend $750,000 or more in federal awards during a fiscal year must have a single audit conducted by an independent CPA firm. For RLF operators with multiple federal grants, this threshold can be reached more quickly than expected.\n\n**Pre-audit preparation checklist:**\n- Updated financial statements through the audit period\n- Trial balance reconciled to bank statements\n- Loan schedule reconciled to general ledger loan receivable accounts\n- LLRF account reconciliation\n- Federal expenditure schedule (Schedule of Expenditures of Federal Awards — SEFA)\n- Grant agreements for all active awards\n- Prior audit reports and any management letter responses\n- Board minutes for the audit period\n- Procurement documentation for all significant purchases\n- Personnel records supporting payroll charges to federal grants\n\n**SEFA preparation:**\nThe Schedule of Expenditures of Federal Awards lists every federal grant expended during the fiscal year, organized by CFDA (Catalog of Federal Domestic Assistance) number. RMAP has its own CFDA number; RBDG has a separate one. The SEFA is an audited schedule — errors in the SEFA trigger audit findings.\n\n**Communicating with auditors:**\n- Designate one staff member as the primary audit contact\n- Provide auditors with the trial balance and supporting schedules before fieldwork begins\n- Respond to audit requests within 24 hours during fieldwork\n- Review the draft management letter carefully — proposed findings can often be corrected before finalization\n- Implement management letter recommendations within the timeframe stated in your written response',
  'RMAP requires quarterly activity reports, an annual performance report, and SF-270 drawdown requests with full backup documentation. A reporting calendar with internal deadlines prevents last-minute scrambles and technical defaults.',
  20, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 4
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Audit Readiness and Portfolio Dashboard',
  'Build an audit-ready loan file system and define the portfolio metrics dashboard that USDA expects to see in every site visit and annual report.',
  4, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod4_id FROM modules WHERE certification_id = cert_id AND sort_order = 4;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod4_id,
  'Audit-Ready Loan Files and Portfolio Metrics',
  'cert11-audit-ready-portfolio-metrics',
  E'## What Auditors Look for in an RLF Site Visit\n\nUSDA conducts site visits of RMAP-approved microlenders, typically within the first two years of an award and then periodically thereafter. The site visit team reviews documentation, interviews staff, and assesses whether the organization is operating in compliance with the grant agreement, USDA regulations, and its own loan policies.\n\nThe most common site visit findings are:\n1. Loan files missing required documentation\n2. LLRF balance below 5% requirement\n3. No written loan committee meeting minutes\n4. Program income not properly tracked or allocated\n5. TA logs missing or incomplete\n6. Adverse action notices not issued or not timely\n7. No environmental screening worksheet in the loan file\n\nEvery one of these findings is preventable with proper file organization and routine internal reviews.\n\n## The Audit-Ready Loan File\n\nEvery closed RMAP microloan should have a physical or electronic loan file containing these documents in a consistent order:\n\n**Pre-Loan Documents:**\n- Completed loan application (signed, dated)\n- Borrower''s business plan or narrative\n- Personal financial statement(s) (borrower and guarantors)\n- Business financial statements (if existing business): 2-3 years of tax returns or P&Ls\n- Cash flow projection or repayment analysis\n- Credit report(s)\n- Credit elsewhere determination/denial letters\n- Environmental screening worksheet\n- Civil rights applicant demographic data form\n\n**Loan Approval Documents:**\n- Loan committee approval minutes (dated, signed by all members present)\n- Adverse action notice (if applicable) or approval letter\n- Loan agreement/promissory note (signed)\n- Security agreement(s) and UCC filing documentation\n- Insurance certificate (property, business owner, life insurance on principal if required)\n- Disbursement authorization\n\n**Post-Closing Documents:**\n- Disbursement confirmation and wire/check record\n- Payment history/ledger card\n- Annual financial review notes (for outstanding loans)\n- Any modification, extension, or workout agreements\n- Collection correspondence (if applicable)\n- Default notice and charge-off documentation (if applicable)\n\n## Internal Loan File Audit Protocol\n\nConduct an internal loan file audit quarterly. Review 20% of active loan files each quarter, rotating through the portfolio:\n\n1. Pull the loan file\n2. Check each required document against the loan file checklist\n3. Note any missing or expired documents\n4. Assign a person to obtain missing documents\n5. Re-inspect the file 30 days later\n6. Document the audit in a log (date reviewed, reviewer, findings, resolution)\n\nAn internal file audit log demonstrates to USDA that you have an active quality control process — even if individual files have gaps, a documented audit process is evidence of institutional commitment to compliance.\n\n## Core RLF Portfolio Metrics\n\nEvery RLF operator should track these metrics monthly and report them to the board and USDA:\n\n**Capital Deployed:**\n- Total loans originated year-to-date (number and dollar amount)\n- Total outstanding principal balance\n- Capital deployed as a percentage of available RMRF balance\n\n**Repayment Performance:**\n- Portfolio at Risk (PAR) — percentage of outstanding portfolio with payments 30+ days late\n  - PAR 30: 30-59 days\n  - PAR 60: 60-89 days\n  - PAR 90: 90+ days (severe delinquency)\n- Delinquency rate by dollar amount\n- On-time payment rate\n\n**Credit Quality:**\n- Default rate (loans declared in default as % of all loans originated)\n- Charge-off rate (loans written off as % of average outstanding portfolio)\n- Recovery rate (dollars recovered on charged-off loans as % of charged-off amount)\n- Allowance for Loan Losses as % of outstanding portfolio\n\n**LLRF Health:**\n- LLRF balance\n- LLRF as % of outstanding RMAP principal (must be ≥ 5%)\n- LLRF replenishment in the period\n\n**Program Impact:**\n- Jobs created (new positions)\n- Jobs retained (existing positions preserved by microloan)\n- Businesses assisted\n- Demographics: % borrowers who are women, minorities, veterans, low-income\n- TA hours delivered and businesses receiving TA\n\n## Dashboard Format\n\nThe portfolio dashboard should be a single page (or screen) that shows all core metrics at a glance, with comparison to prior month and year-to-date totals. Present it at every board meeting.\n\n**Simple dashboard layout:**\n\n```\nCAP FUND ACADEMY | RLF PORTFOLIO DASHBOARD | Month/Year\n\nCAPITAL DEPLOYED           REPAYMENT PERFORMANCE\nLoans YTD:  ##  / $###K    PAR 30:    #.#%\nOutstanding: $###K          PAR 60:    #.#%\nUtilization: ##%            PAR 90:    #.#%\n\nCREDIT QUALITY             LLRF HEALTH\nDefault Rate:  #.#%         LLRF Balance: $##,###\nCharge-Off:    #.#%         Required:     $##,###\nALL Balance:   $##,###      Status:       ✓ Compliant\n\nPROGRAM IMPACT\nJobs Created:  ##           Borrowers — Women:  ##%\nJobs Retained: ##           Borrowers — Minority: ##%\nTA Hours:      ###          Borrowers — Low-Income: ##%\n```\n\nThis dashboard takes less than 30 minutes to update each month if the underlying ledgers are maintained correctly.',
  'Audit-ready loan files require 20+ specific documents in consistent order. An internal quarterly file audit documents your quality control process. The portfolio dashboard tracks capital deployment, PAR, LLRF health, and community impact.',
  18, 1, 'approved')
ON CONFLICT DO NOTHING;

-- QUIZ for Cert 11
INSERT INTO quizzes (id, certification_id, title, passing_score, status)
VALUES (uuid_generate_v4(), cert_id,
  'RLF Accounting, Reporting & Audit Readiness Knowledge Check',
  80, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO quiz_id FROM quizzes WHERE certification_id = cert_id;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order)
VALUES
(quiz_id,
  'What is the primary purpose of the Loan Loss Reserve Fund (LLRF) in an RMAP-funded RLF?',
  '[{"id":"a","text":"To cover RLF administrative costs when program income is insufficient"},{"id":"b","text":"To cover losses (charge-offs) on defaulted RMAP-funded microloans"},{"id":"c","text":"To hold grant funds before they are disbursed as microloans"},{"id":"d","text":"To fund the Technical Assistance and Training program"}]',
  'b',
  'The LLRF exists exclusively to cover losses on defaulted RMAP-funded microloans. It cannot be used for administrative costs, TA expenses, or any other purpose. It must equal at least 5% of outstanding RMAP microloan principal at all times.',
  1),
(quiz_id,
  'An RMAP microlender has $350,000 in outstanding RMAP microloan principal. What is the minimum required LLRF balance?',
  '[{"id":"a","text":"$7,000"},{"id":"b","text":"$10,500"},{"id":"c","text":"$17,500"},{"id":"d","text":"$35,000"}]',
  'c',
  '5% of $350,000 = $17,500. The LLRF must equal or exceed 5% of the total outstanding RMAP-funded microloan principal balance at all times.',
  2),
(quiz_id,
  'Which of the following is an allowable use of RMRF funds?',
  '[{"id":"a","text":"Paying staff salaries for RLF administrative functions"},{"id":"b","text":"Funding the organization''s general operating reserve"},{"id":"c","text":"Making new RMAP-eligible microloans to rural microenterprises"},{"id":"d","text":"Funding TA program expenses"}]',
  'c',
  'The RMRF may only be used for making new RMAP-eligible microloans to eligible microenterprises. Administrative costs, TA expenses, and general operating uses are not authorized uses of RMRF funds.',
  3),
(quiz_id,
  'Under RMAP regulations, program income (microloan interest and fees) must be used in what priority order?',
  '[{"id":"a","text":"Administrative costs first, then LLRF, then re-lending"},{"id":"b","text":"LLRF replenishment first, then authorized administrative costs, then re-lending"},{"id":"c","text":"Re-lending first, then LLRF, then administrative costs"},{"id":"d","text":"Program income has no required priority order — the organization decides"}]',
  'b',
  'Under 2 CFR 200.307 and RMAP grant agreement requirements, program income must first fund the LLRF to the 5% requirement, then may fund authorized administrative costs (with USDA approval), and then may be deposited to the RMRF for re-lending.',
  4),
(quiz_id,
  'The Allowance for Loan Losses (ALL) on the balance sheet is best described as:',
  '[{"id":"a","text":"A cash reserve account held at the bank"},{"id":"b","text":"A contra-asset that reduces the net reported value of the loan portfolio to its estimated collectible amount"},{"id":"c","text":"The same account as the LLRF"},{"id":"d","text":"A liability representing amounts owed to USDA for defaulted loans"}]',
  'b',
  'The ALL is a contra-asset — an accounting estimate of expected credit losses that reduces the gross loan receivable to net realizable value. It is not a cash account, not the same as the LLRF, and not a liability.',
  5),
(quiz_id,
  'RMAP quarterly activity reports are due within how many days after the end of each federal fiscal year quarter?',
  '[{"id":"a","text":"15 days"},{"id":"b","text":"30 days"},{"id":"c","text":"45 days"},{"id":"d","text":"60 days"}]',
  'b',
  'RMAP quarterly activity reports are due within 30 days after the end of each federal fiscal year quarter: January 30, April 30, July 30, and October 30.',
  6),
(quiz_id,
  'Which of the following is the most common site visit finding for RMAP microlenders?',
  '[{"id":"a","text":"Interest rates charged above USDA maximums"},{"id":"b","text":"Loan files missing required documentation"},{"id":"c","text":"RMRF funds commingled with the LLRF"},{"id":"d","text":"Board minutes not approved at the next meeting"}]',
  'b',
  'Incomplete loan files — missing required documents such as environmental screening worksheets, adverse action notices, or signed loan agreements — are the most common site visit finding. This is preventable with a file checklist and internal quarterly file audits.',
  7),
(quiz_id,
  'What is Portfolio at Risk (PAR) 30?',
  '[{"id":"a","text":"The percentage of loans that have been charged off in the past 30 days"},{"id":"b","text":"The percentage of the outstanding portfolio where payments are 30 or more days past due"},{"id":"c","text":"The dollar amount of loans that mature within 30 days"},{"id":"d","text":"The reserve amount required for loans at risk of default"}]',
  'b',
  'PAR 30 is the percentage of the total outstanding portfolio (by principal balance) where payments are 30 or more days past due. It is the primary early-warning indicator of portfolio quality. PAR 60 and PAR 90 track more severe delinquency.',
  8),
(quiz_id,
  'When is a single audit required for a nonprofit RLF operator?',
  '[{"id":"a","text":"Whenever the organization receives any federal grant"},{"id":"b","text":"When the organization expends $750,000 or more in federal awards during a fiscal year"},{"id":"c","text":"When the organization has more than $1,000,000 in outstanding loans"},{"id":"d","text":"Only when USDA specifically requests one"}]',
  'b',
  'Under 2 CFR 200 Subpart F, a single audit (A-133 audit) is required when a non-federal entity expends $750,000 or more in federal awards during its fiscal year. This threshold counts expenditures across all federal sources — RMAP, RBDG, SBA, HUD, etc.',
  9),
(quiz_id,
  'The Schedule of Expenditures of Federal Awards (SEFA) is:',
  '[{"id":"a","text":"A quarterly report submitted to USDA showing loan disbursements"},{"id":"b","text":"An audited schedule listing every federal grant expended during the fiscal year, organized by CFDA number"},{"id":"c","text":"A budget template required with every SF-270 drawdown request"},{"id":"d","text":"A financial statement required by the CDFI Fund"}]',
  'b',
  'The SEFA is an audited schedule that lists every federal award expended during the fiscal year, organized by CFDA (Catalog of Federal Domestic Assistance) number. It is required for all entities subject to single audit and is examined by the auditor for accuracy.',
  10),
(quiz_id,
  'What is the correct segregation of duties standard for RMRF disbursements?',
  '[{"id":"a","text":"The loan officer who approved the loan should also execute the wire to prevent errors"},{"id":"b","text":"The person who authorizes the disbursement should be different from the person who executes the wire and different from the person who reconciles the account"},{"id":"c","text":"The board must vote on every individual disbursement"},{"id":"d","text":"Only the Executive Director may authorize and execute RMRF disbursements"}]',
  'b',
  'Proper segregation requires that authorization, execution, and reconciliation of RMRF transactions be performed by different individuals. No single person should control the entire disbursement cycle. For small organizations, compensating controls like board treasurer review of statements are acceptable.',
  11),
(quiz_id,
  'An organization charges off a $10,000 defaulted microloan. What is the correct accounting entry?',
  '[{"id":"a","text":"Debit Loan Loss Expense $10,000 / Credit Cash $10,000"},{"id":"b","text":"Debit Allowance for Loan Losses $10,000 / Credit Loans Receivable $10,000"},{"id":"c","text":"Debit LLRF Account $10,000 / Credit Loans Receivable $10,000"},{"id":"d","text":"Debit General Expense $10,000 / Credit RMRF Account $10,000"}]',
  'b',
  'A charge-off reduces both the Allowance for Loan Losses (previously established as an estimate of losses) and the Loans Receivable account. It does not affect the income statement at the time of charge-off because the expense was already recognized when the allowance was established.',
  12),
(quiz_id,
  'Which document is NOT typically included in an RMAP microloan file?',
  '[{"id":"a","text":"Environmental screening worksheet"},{"id":"b","text":"Borrower demographic data form"},{"id":"c","text":"Copy of the borrower''s USDA eligibility determination from USDA Rural Development"},{"id":"d","text":"Loan committee approval minutes"}]',
  'c',
  'The microlender — not USDA Rural Development — determines individual borrower eligibility for microloans. USDA determines the microlender''s eligibility to participate in RMAP. Individual borrowers do not receive separate USDA eligibility determinations.',
  13),
(quiz_id,
  'How often should an internal loan file audit be conducted, and what percentage of files should be reviewed each cycle?',
  '[{"id":"a","text":"Annually, reviewing 100% of files"},{"id":"b","text":"Monthly, reviewing 5% of files"},{"id":"c","text":"Quarterly, reviewing 20% of active loan files"},{"id":"d","text":"Only when USDA requests a site visit"}]',
  'c',
  'Best practice is a quarterly internal loan file audit reviewing 20% of active files each quarter, rotating through the portfolio so that every file is reviewed at least annually. The audit should be documented in a log, which demonstrates an active quality control process to USDA.',
  14),
(quiz_id,
  'Program income tracking for RMAP requires a ledger that shows:',
  '[{"id":"a","text":"Only the total interest income received during the fiscal year"},{"id":"b","text":"Month earned, amount by type (interest/fees), allocation decision, and authorization for each allocation"},{"id":"c","text":"Only the LLRF deposits made from interest income"},{"id":"d","text":"A comparison of actual interest income to the projections in the original grant application"}]',
  'b',
  'The program income ledger must show month and year earned, amount by type (interest vs. fees), allocation decision (LLRF / admin / RMRF), and who authorized each allocation. This detail is required by USDA to verify that program income is being used in compliance with 2 CFR 200.307 and the grant agreement.',
  15)
ON CONFLICT DO NOTHING;

END $$;

-- ============================================================
-- CERT 12: Application Assembly, Evidence Documentation & AI-Assisted Scoring
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

SELECT id INTO cert_id FROM certifications WHERE cert_number = 12;
IF cert_id IS NULL THEN
  RAISE EXCEPTION 'Cert 12 not found — run 04_cert_seeds.sql first';
END IF;

UPDATE certifications SET
  learning_outcomes = ARRAY[
    'Assemble a reviewer-centered application packet using consistent labeling, tabbing, and index conventions that USDA reviewers expect',
    'Build an evidence crosswalk that maps every narrative claim to a specific scoring criterion, exhibit, and point value',
    'Rewrite weak narrative sections using the metrics-dates-capacity framework that distinguishes competitive from non-competitive applications',
    'Use AI scoring tools responsibly to identify gaps, prioritize fixes, and plan correction sprints with owners and deadlines',
    'Conduct a complete pre-submission quality review against the applicable scoring rubric',
    'Build a 30-day correction plan that closes the highest-value evidence gaps before submission',
    'Distinguish advisory AI scoring from authoritative USDA review and communicate scoring limitations accurately to organizational leadership'
  ],
  status = 'approved'
WHERE id = cert_id;

-- MODULE 1
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Reviewer-Centered Application Assembly',
  'Build a USDA application packet from the reviewer''s perspective. Covers organization principles, consistent labeling, exhibit numbering, index design, and the physical and electronic submission formats USDA expects.',
  1, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod1_id FROM modules WHERE certification_id = cert_id AND sort_order = 1;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod1_id,
  'Assembling a Reviewer-Centered Application Packet',
  'cert12-reviewer-centered-assembly',
  E'## The Reviewer''s Perspective\n\nUSDA RMAP and RBDG applications are reviewed by Rural Development staff who read dozens of applications each quarter. They are not your advocates — they are evaluators applying a scoring rubric to determine how many points each section earns. An application that is hard to navigate, inconsistently labeled, or missing evidence does not get the benefit of the doubt. It gets low scores.\n\nReviewer-centered assembly means building the packet from the reviewer''s perspective: make it as easy as possible to find what you claim, verify it, and assign points. Every organizational decision should serve the reviewer, not the applicant.\n\n## The Assembly Hierarchy\n\nA well-assembled USDA application has four levels of organization:\n\n1. **Cover letter** — one page, professionally formatted, summarizing the request (program applied for, amount requested, organization name, contact)\n2. **Application form** — the completed USDA RD form, signed by authorized representative\n3. **Narrative sections** — organized to match the scoring criteria order, not the order that feels natural to you\n4. **Evidence exhibits** — numbered or lettered sequentially, with each exhibit referenced from the narrative\n\n## Exhibit Numbering System\n\nUse a single, consistent exhibit numbering system throughout the entire packet. Every exhibit gets a number at the start of assembly and keeps that number through all revisions.\n\n**Recommended system:**\n- Exhibits numbered sequentially: Exhibit 1, Exhibit 2, Exhibit 3...\n- Each exhibit has a cover sheet: "Exhibit [Number]: [Title] — [Source] — [Date]"\n- Exhibit cover sheet appears before the exhibit content\n- Exhibits are assembled in the order they are first referenced in the narrative\n\n**Within each exhibit:**\n- Single-page exhibits need no internal organization\n- Multi-page exhibits should have a title page and page numbers within the exhibit\n- Lengthy exhibits (financial statements, loan histories) should have tabs or bookmarks for key sections referenced in the narrative\n\n## Building the Application Index\n\nThe index is the reviewer''s roadmap. It should appear immediately after the cover letter and list:\n\n- Each section of the narrative with page number\n- Each exhibit with exhibit number and description\n- Each required form with its location in the packet\n\n**Index format:**\n\n```\nAPPLICATION INDEX\n\nNARRATIVE SECTIONS\nSection A: Organizational Capacity .............. Page 3\nSection B: Microlending Experience .............. Page 8\nSection C: Technical Assistance Program ......... Page 15\nSection D: Financial Soundness .................. Page 21\nSection E: Community Impact ..................... Page 26\n\nREQUIRED FORMS\nForm RD 4280-4: Application for RMAP ............ Page 32\nForm AD-1047: Debarment Certification ........... Page 35\nForm SF-LLL: Lobbying Disclosure ................ Page 36\n\nEVIDENCE EXHIBITS\nExhibit 1: Organizational Chart ................. Page 38\nExhibit 2: Board of Directors Biographies ....... Page 40\nExhibit 3: Current Loan Portfolio Summary ....... Page 47\n...\n```\n\n## Narrative Section Organization\n\nOrganize narrative sections to match the USDA scoring rubric order — not the order they appear in the application form, and not the order that tells your organization''s story in a way that feels natural to you.\n\n**For RMAP experienced microlender applicants, the scoring criteria order is:**\n1. Organizational capacity (45 points)\n2. Microlending experience — loan history metrics (30 points)\n3. Technical assistance program (15 points)\n4. Financial soundness (20 points)\n5. Community impact and need (15 points)\n\n**Structural rules for each narrative section:**\n- Open with a one-sentence summary of how many points you believe this section earns and why\n- Write in direct, declarative sentences: "Our loan committee meets monthly. Evidence: Exhibit 8, Board Minutes, 2023-2025."\n- After every major claim, include: "Evidence: Exhibit [X], [Description]"\n- Use bullet points and short paragraphs, not long flowing prose — reviewers scan, they do not read\n- Do not make unsupported claims — if you cannot provide evidence for a statement, do not make it\n\n## Physical vs. Electronic Submission\n\n**Physical submission (check with your State Office):**\n- All documents single-sided or double-sided consistently\n- Bound with binder clips (not staples for multi-page packets)\n- Tabbed dividers between major sections\n- Exhibits tabbed and numbered on the physical tab\n- Submit the number of copies specified by the State Office (often 2-3)\n\n**Electronic submission (RD Apply or email):**\n- Single PDF with bookmarks matching the index structure\n- Maximum file size compliance (check with State Office)\n- File named: "[Organization Name] — RMAP Application — [Quarter/Year]"\n- Exhibits as a separate PDF or embedded within the main PDF\n- Confirm receipt with the State Office contact after submission\n\n## The Pre-Assembly Quality Check\n\nBefore final assembly, run through this checklist:\n\n☐ Every exhibit referenced in the narrative has been created and included\n☐ Every exhibit number in the narrative matches the exhibit''s actual number\n☐ All required forms are signed by the authorized representative\n☐ SAM.gov registration is active and UEI matches the organization name in the application\n☐ Financial statements are for the correct fiscal years (most recent 2-3 years)\n☐ Application narrative addresses every scored criterion — no scoring category is left unaddressed\n☐ No claim is made without a cited exhibit\n☐ The index accurately reflects the content and page numbers in the assembled packet\n☐ The packet has been reviewed by someone who did not write it',
  'Reviewer-centered assembly means organizing the packet from the evaluator''s perspective: consistent exhibit numbering, a complete index, narrative sections in scoring criteria order, and every claim supported by a cited exhibit.',
  18, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 2
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Evidence Crosswalks and Scoring Workbooks',
  'Build an evidence crosswalk that maps every narrative claim to its scoring criterion, exhibit, point value, and risk level. Use the crosswalk as a gap-detection tool before finalizing the application.',
  2, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod2_id FROM modules WHERE certification_id = cert_id AND sort_order = 2;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod2_id,
  'Building an Evidence Crosswalk and Scoring Workbook',
  'cert12-evidence-crosswalk',
  E'## What Is an Evidence Crosswalk?\n\nAn evidence crosswalk is a structured spreadsheet or table that maps every scored criterion in the USDA rubric to: (1) the claim in your narrative, (2) the exhibit that supports the claim, (3) the exhibit page or section, (4) the maximum points for that criterion, (5) your self-assessed score, and (6) the risk that the reviewer scores lower.\n\nThe crosswalk serves two purposes:\n1. **Quality control** — if you cannot fill in the exhibit column for a criterion, you have a gap that will cost you points\n2. **Scoring strategy** — the crosswalk shows you which criteria have the highest point values and the highest gaps, so you can prioritize where to spend your evidence-gathering time\n\n## Crosswalk Structure\n\n| Criterion | Max Points | Narrative Reference | Evidence Claim | Exhibit # | Exhibit Description | Self-Score | Risk Level |\n|-----------|-----------|--------------------|--------------------|-----------|---------------------|------------|------------|\n| Rural service area documentation | 5 | Section A, p. 4 | "Our service area comprises 8 rural counties..." | Exhibit 12 | USDA ERS RUCA codes + Census 2020 data | 5 | Low |\n| Board governance and succession plan | 5 | Section A, p. 5 | "Our board has a documented succession policy..." | Exhibit 13 | Board succession policy, adopted 2024 | 3 | High — policy exists but not board-approved |\n| 3-year microloan history — rural % | 10 | Section B, p. 9 | "74% of our microloans in 2023-2025 went to rural borrowers..." | Exhibit 18 | Loan history database export with rural designation | 9 | Low |\n\n## RMAP Scoring Workbook\n\nFor the RMAP experienced microlender pathway, the scoring workbook mirrors the criteria in 7 CFR 4280.316. Build one tab per scoring category:\n\n**Tab 1: Organizational Capacity (45 points total)**\n- Evidence of rural service area (5 pts)\n- Organizational history and mission alignment (5 pts)\n- Board governance, meeting frequency, minutes (5 pts)\n- Loan committee experience and composition (5 pts)\n- Staff capacity and qualifications (10 pts)\n- Written loan policies and procedures (10 pts)\n- Succession plan and key person controls (5 pts)\n\n**Tab 2: Microlending Experience — Loan History (30 points)**\n- 3-year microloan portfolio summary (volume, dollar, rural %) (10 pts)\n- Percentage of loans to rural microenterprises (10 pts)\n- Delinquency and default rates (5 pts)\n- On-time payment rate (5 pts)\n\n**Tab 3: Technical Assistance Program (15 points)**\n- Types and delivery methods of TA provided (5 pts)\n- TA documentation and outcome tracking (5 pts)\n- TA-to-loan connection — how TA improves repayment (5 pts)\n\n**Tab 4: Financial Soundness (20 points)**\n- Audited or reviewed financial statements (10 pts)\n- LLRF adequacy and RMRF utilization (5 pts)\n- Organizational financial sustainability (5 pts)\n\n**Tab 5: Community Impact (15 points)**\n- Jobs created/retained documentation (5 pts)\n- Letters of support from relevant community partners (5 pts)\n- Demographic data on borrowers served (5 pts)\n\n## Self-Scoring Protocol\n\nFor each criterion, assign a score using this disciplined protocol:\n\n1. **Read the regulatory text for the criterion** — do not score from memory or assumption\n2. **Pull the evidence you have for this criterion**\n3. **Score conservatively** — if you are uncertain whether your evidence fully meets the criterion, score at 60-70% of maximum\n4. **Note the specific risk** — what exactly could cause a reviewer to score lower than your self-assessment?\n5. **Prioritize by gap** — the criteria with the largest gap between maximum and self-score (especially on high-point criteria) get first attention in evidence gathering\n\n**Red flags that should always score at 50% or lower:**\n- No written policy exists for a criterion requiring one\n- Evidence is more than 3 years old\n- Data claimed in narrative cannot be verified by an exhibit\n- The claim requires the reviewer to make an assumption in your favor\n\n## Using the Crosswalk to Find Evidence Gaps\n\n**Gap analysis process:**\n\n1. Complete the crosswalk for all criteria\n2. Sum your self-assessed scores by category\n3. Identify criteria where you scored below 70% of maximum (these are your gaps)\n4. For each gap, ask: "What specific evidence could I obtain or create that would increase this score?"\n5. Create a gap resolution list: evidence needed, source, person responsible, deadline\n\n**Common evidence gaps and how to close them:**\n\n| Gap | Evidence Needed | Source | Timeline to Obtain |\n|-----|----------------|--------|-------------------|\n| No succession plan | Written succession policy | Board action | 2-4 weeks |\n| Loan history rural % not documented | Borrower address validation against USDA RUCA codes | Internal data + USDA ERS tool | 1-2 weeks |\n| No TA outcome data | TA evaluation summaries, enrollment records | Internal records cleanup | 2-4 weeks |\n| Board minutes show infrequent meetings | Meeting schedule going forward (does not fix history) | Board action | Ongoing |\n| No letters of support | Letters from SBDC, bank, chamber, county | Outreach to partners | 3-6 weeks |',
  'An evidence crosswalk maps every scored criterion to a narrative claim, exhibit, point value, and risk level. Self-scoring conservatively and prioritizing gaps by point value drives the most efficient pre-submission improvement effort.',
  18, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 3
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Narrative Strengthening',
  'Rewrite weak application narrative using the metrics-dates-capacity framework. Learn how competitive applications differ from non-competitive ones and apply the principles to your own sections.',
  3, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod3_id FROM modules WHERE certification_id = cert_id AND sort_order = 3;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod3_id,
  'Writing Competitive Application Narrative',
  'cert12-narrative-strengthening',
  E'## Why Most Application Narrative Is Weak\n\nMost USDA application narrative is written by people who know their organization well and assume the reviewer will fill in gaps with charitable interpretation. USDA reviewers do not do this. They score what is on the page, not what they infer.\n\nThe most common weaknesses in USDA application narrative:\n\n1. **Vague claims without metrics** — "We have significant experience in microlending" scores less than "We originated 47 microloans totaling $1.2M to rural microenterprises in Jackson and Perry Counties between 2022 and 2024."\n\n2. **Claims without dates** — "Our board adopted a succession policy" is weaker than "Our board adopted a written succession policy in March 2024. See Exhibit 13."\n\n3. **Expertise without names and credentials** — "Our staff is experienced in lending" is weaker than "Our Loan Officer, Jane Smith, has 12 years of community development lending experience including 7 years managing microloan portfolios. See Exhibit 5, Staff Résumés."\n\n4. **Aspirational language** — "We plan to serve rural microenterprises" (future tense for things that should be documented as already existing) undermines the credibility of the entire application.\n\n5. **Narrative that does not match evidence** — claiming 80% rural loans but the exhibit shows 62% is an immediate scoring penalty and raises credibility questions for other sections.\n\n## The Metrics-Dates-Capacity Framework\n\nEvery strong narrative section follows this framework:\n\n**Metrics:** Use specific, verifiable numbers. Not "many" or "significant" — use the actual count, dollar amount, percentage, or rate.\n\n**Dates:** Anchor every claim to a time period. "2022-2024" not "recent years." "March 2024" not "last spring."\n\n**Capacity:** Name the specific person, system, or policy that delivers the claimed capability. Not "we have processes" but "Our Loan Policy Manual (Exhibit 6, Section 4.2) specifies that loan committee quorum requires three members and all loan decisions are documented in written minutes within 5 business days."\n\n## Weak vs. Strong Narrative Examples\n\n**Organizational Capacity — Weak:**\n"Our organization has been serving rural communities for many years. We have an experienced board and staff who are dedicated to microlending. Our board meets regularly and reviews our loan activity."\n\n**Organizational Capacity — Strong:**\n"Rural Community Development Partners was incorporated in June 2018 as a Mississippi 501(c)(3) nonprofit with a stated mission of expanding access to capital for rural microenterprises in our 7-county service area. Our 9-member board of directors includes 3 members with commercial lending backgrounds, 2 CPAs with nonprofit accounting experience, and a former USDA Rural Development state director. The board meets monthly (12 meetings per year) with an average attendance rate of 87% across 2022-2024. See Exhibit 8, Board Member Biographies and Exhibit 9, Board Meeting Minutes Summary, 2022-2024."\n\n**Technical Assistance — Weak:**\n"We provide technical assistance to microenterprise borrowers to help them succeed. We offer workshops and one-on-one counseling."\n\n**Technical Assistance — Strong:**\n"Between January 2022 and December 2024, we delivered 1,847 hours of microenterprise technical assistance to 94 businesses across our service area. Services included: quarterly business planning workshops (12 sessions, average 8 attendees), monthly 1:1 financial coaching sessions (average 42 active clients per month), and referral-based business plan review (37 plans reviewed). 68% of microloan borrowers received at least 4 hours of TA in the 12 months prior to loan approval. Our TA outcomes tracking shows that borrowers who received 4+ hours of pre-loan TA have a 12% lower delinquency rate than borrowers with less than 4 hours. See Exhibit 14, TA Program Log Summary and Exhibit 15, TA-to-Loan Outcome Analysis."\n\n## Rewriting Your Weakest Sections\n\n**Step 1: Identify the weakest sections using your crosswalk.** The sections with the largest gap between maximum score and self-assessed score are the candidates for rewriting.\n\n**Step 2: Pull all available evidence for that section.** What data do you actually have? What can you compile in the time available?\n\n**Step 3: Apply the metrics-dates-capacity framework.** Rewrite each paragraph using specific numbers, dates, and named people or systems.\n\n**Step 4: Cross-reference every claim to an exhibit.** If you cannot cross-reference a claim, delete or soften it.\n\n**Step 5: Read the rewritten section from the reviewer''s perspective.** Ask: "Would I give this full points based only on what I can verify in the exhibits?"\n\n## Evidence You Can Build Before Submission\n\nSome evidence gaps can be closed before submission with focused effort:\n\n- **Board resolutions** — Can be adopted at the next board meeting (2-4 weeks)\n- **Staff résumés** — Can be updated in days\n- **Letters of support** — Can be drafted and sent for signature in 2-3 weeks; plan 4-6 weeks for return\n- **Internal data analysis** — Loan history reports, TA tracking summaries, demographic analysis can be compiled from existing records in 1-2 weeks\n- **Policy documents** — Simple policies (succession plan, conflict of interest) can be drafted and board-approved in 2-4 weeks\n\nEvidence that takes longer:\n- **Audited financials** — Require an audit engagement, minimum 4-6 weeks\n- **Portfolio track record** — Cannot be manufactured; requires actual lending history\n- **3rd party partnerships** — Require relationship development, cannot be created overnight\n\nPrioritize the evidence that can be obtained within your submission timeline and that covers the highest-value scoring criteria.',
  'Weak narrative lacks metrics, dates, and named capacity. The metrics-dates-capacity framework transforms vague claims into scoreable evidence. Every claim must be cross-referenced to an exhibit, and evidence gaps can often be closed with targeted effort before submission.',
  16, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 4
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'AI Scoring Lab and 30-Day Correction Plan',
  'Use AI scoring tools to identify the highest-priority evidence gaps, generate a structured 30-day correction plan, and understand how to interpret and communicate AI scoring results responsibly.',
  4, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod4_id FROM modules WHERE certification_id = cert_id AND sort_order = 4;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod4_id,
  'Using AI Scoring Responsibly and Building a Correction Plan',
  'cert12-ai-scoring-correction-plan',
  E'## What AI Scoring Can and Cannot Do\n\nCap Fund Academy''s AI scoring engine uses a large language model (OpenAI) to evaluate your application inputs against the USDA scoring rubric stored in the database. The AI assigns estimated scores, identifies evidence gaps, suggests improvements, and generates a priority fix list.\n\n**What AI scoring can do well:**\n- Systematically check whether your narrative addresses each criterion in the rubric\n- Identify obvious evidence gaps (no exhibit cited, vague language, missing required policy)\n- Rank criteria by gap size (maximum minus estimated score) to prioritize your effort\n- Generate a structured list of specific, actionable improvements\n- Estimate your competitive readiness relative to the scoring thresholds\n\n**What AI scoring cannot do:**\n- Verify the accuracy of your data inputs (garbage in, garbage out)\n- Read PDF exhibits — it evaluates your narrative and inputs, not your actual documents\n- Predict USDA reviewers'' individual scoring judgments\n- Guarantee that improving a criterion will result in a higher actual score\n- Provide legal or compliance advice\n\n**Critical disclaimer:**\nAI scoring is advisory only. Cap Fund Academy''s AI scoring results do not guarantee eligibility, funding, approval, or any specific USDA determination. The scoring rubric in the database reflects the regulations as of the date it was last updated. Always verify current regulatory requirements against the actual CFR provisions at ecfr.gov.\n\n## The AI Scoring Workflow\n\n**Step 1: Complete the Application Workspace**\nIn your Cap Fund Academy application workspace, fill in every input field for your target program (RMAP, RBDG, or combined). More complete inputs produce more accurate scoring. Incomplete inputs produce generic output.\n\n**Step 2: Upload key narrative sections**\nFor the sections you want scored most precisely, paste your draft narrative directly into the workspace. The AI will evaluate the narrative for the metrics-dates-capacity framework and criterion coverage.\n\n**Step 3: Run the scoring agent**\nThe scoring agent produces a structured JSON output containing:\n- `total_score_estimate` — estimated total score\n- `section_scores` — estimated points per section\n- `strengths` — what is working well\n- `weaknesses` — specific gaps reducing your score\n- `missing_evidence` — evidence the rubric requires but you have not provided\n- `risk_flags` — claims that may attract USDA scrutiny\n- `recommended_next_actions` — prioritized list of improvements\n- `estimated_readiness_level` — Not Ready / Emerging / Competitive / Strong / Submission-Ready\n\n**Step 4: Download the readiness report**\nThe readiness report summarizes all scoring results in a format you can share with your board or leadership team.\n\n**Step 5: Build the correction plan**\nFrom the `recommended_next_actions` list, build a 30-day correction plan.\n\n## Building the 30-Day Correction Plan\n\nThe correction plan translates AI scoring output into accountable action items. Format:\n\n| Priority | Criterion | Current Score | Target Score | Evidence Gap | Action Required | Owner | Deadline |\n|----------|-----------|--------------|-------------|--------------|-----------------|-------|----------|\n| 1 | Succession plan | 0/5 | 5/5 | No written policy exists | Draft and board-approve succession policy | Executive Director + Board Chair | Week 1 |\n| 2 | Letters of support | 2/5 | 5/5 | Only 1 letter obtained | Obtain letters from SBDC, community bank, county ED | Program Director | Week 3 |\n| 3 | TA outcome data | 5/15 | 12/15 | TA logs exist but not analyzed | Compile TA hours by borrower, calculate TA-to-loan outcomes | Loan Officer | Week 2 |\n\n**Correction plan rules:**\n- Every item has a specific named owner\n- Every item has a specific deadline (not "ASAP")\n- Items are ranked by impact (points × feasibility within timeline)\n- After the correction sprint, re-run the AI scoring agent to measure improvement\n- Compare pre-correction and post-correction scores to validate the effort\n\n## Communicating AI Scores to Leadership\n\nWhen presenting AI scoring results to your board or executive leadership:\n\n1. **Lead with the disclaimer** — "This is an advisory estimate, not a USDA determination."\n2. **Present the score range** — "Our estimated score is between X and Y points out of 125 total. The competitive threshold is approximately 90 points."\n3. **Focus on the action list** — "The AI identified 5 high-priority evidence gaps. Here is our plan to close them in the next 30 days."\n4. **Set appropriate expectations** — "Improving our score estimate does not guarantee we will be funded. USDA makes final determinations based on the actual application documents, not our self-assessment."\n5. **Show the trajectory** — If you have run multiple scoring cycles, show the score trend from the first cycle to the most recent. Improvement in the score estimate is evidence that your correction effort is working.\n\n## Re-Scoring After Corrections\n\nAfter implementing the 30-day correction plan:\n1. Update the application workspace with revised narrative\n2. Re-run the AI scoring agent\n3. Compare section scores between the pre-correction and post-correction runs\n4. If a section score did not improve after correction, review why — either the correction did not fully address the gap, or the AI is identifying a deeper issue\n5. Repeat the correction-rescore cycle until you reach the target readiness level\n\nThe re-scoring process is one of the most valuable capabilities of the Cap Fund Academy scoring engine. It allows you to test the impact of specific improvements before committing them to a final application.',
  'AI scoring identifies evidence gaps, ranks them by priority, and generates a structured correction plan. It is advisory only — it cannot verify document accuracy or predict USDA decisions. Run multiple score cycles before submission to validate correction effort.',
  16, 1, 'approved')
ON CONFLICT DO NOTHING;

-- QUIZ for Cert 12
INSERT INTO quizzes (id, certification_id, title, passing_score, status)
VALUES (uuid_generate_v4(), cert_id,
  'Application Assembly, Evidence & AI Scoring Knowledge Check',
  80, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO quiz_id FROM quizzes WHERE certification_id = cert_id;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order)
VALUES
(quiz_id,
  'What is the primary purpose of an evidence crosswalk in a USDA application?',
  '[{"id":"a","text":"To provide a summary of the organization''s mission and history for the cover letter"},{"id":"b","text":"To map every scored criterion to a narrative claim, exhibit, point value, and risk level for gap detection"},{"id":"c","text":"To satisfy the USDA environmental review requirement"},{"id":"d","text":"To create the index of exhibits for the application packet"}]',
  'b',
  'An evidence crosswalk maps every scored criterion to the narrative claim, supporting exhibit, maximum point value, and self-assessed score. It serves two purposes: quality control (revealing gaps where evidence is missing) and scoring strategy (prioritizing the highest-value, highest-gap criteria for improvement).',
  1),
(quiz_id,
  'The metrics-dates-capacity framework for narrative strengthening requires:',
  '[{"id":"a","text":"A metric (specific number), a date (specific time period), and a named person, system, or policy that delivers the capability"},{"id":"b","text":"A market size estimate, a project timeline, and a budget projection"},{"id":"c","text":"A testimonial from a borrower, a date of service, and a staff capacity statement"},{"id":"d","text":"A financial metric, a compliance date, and a capacity-building plan"}]',
  'a',
  'The metrics-dates-capacity framework requires: Metrics (specific verifiable numbers, not "many" or "significant"), Dates (anchored to specific years or months, not "recent" or "last spring"), and Capacity (named person, system, or policy, not generic "we have processes").',
  2),
(quiz_id,
  'When self-scoring your application against the USDA rubric, which approach is most appropriate?',
  '[{"id":"a","text":"Score at maximum for any criterion where you have some evidence, to set an optimistic target"},{"id":"b","text":"Score conservatively — if uncertain whether evidence fully meets the criterion, score at 60-70% of maximum"},{"id":"c","text":"Ask a USDA Rural Development field officer to pre-score your application"},{"id":"d","text":"Score based on the national average award score for your program type"}]',
  'b',
  'Self-scoring should be conservative. If you are uncertain whether your evidence fully meets a criterion, score at 60-70% of maximum and note the specific risk. Optimistic self-scoring produces a false sense of readiness and may lead to not addressing real gaps.',
  3),
(quiz_id,
  'In a well-assembled USDA application, narrative sections should be organized:',
  '[{"id":"a","text":"In the order that tells your organization''s story most compellingly"},{"id":"b","text":"Alphabetically by section title"},{"id":"c","text":"To match the scoring criteria order in the applicable regulation, not the natural storytelling order"},{"id":"d","text":"With the strongest sections first and the weakest sections last"}]',
  'c',
  'Narrative sections should be organized to match the USDA scoring rubric criteria order — not the order that feels natural to the applicant. Reviewers apply the rubric in order; matching that structure makes their work easier and reduces the risk of a criterion being overlooked.',
  4),
(quiz_id,
  'Which of the following is an evidence gap that can typically be closed within 2-4 weeks before submission?',
  '[{"id":"a","text":"A 3-year audited financial statement"},{"id":"b","text":"A 3-year microloan portfolio track record"},{"id":"c","text":"A written board succession policy adopted by board resolution"},{"id":"d","text":"A Community Development Financial Institution (CDFI) certification"}]',
  'c',
  'A written succession policy can be drafted and adopted by board resolution within 2-4 weeks. Audited financials require an audit engagement (minimum 4-6 weeks, often much longer). A 3-year portfolio track record requires actual lending history that cannot be manufactured. CDFI certification takes 3-12 months.',
  5),
(quiz_id,
  'What does the AI scoring engine''s `estimated_readiness_level` field communicate?',
  '[{"id":"a","text":"The USDA Rural Development field officer''s pre-assessment of the application''s fundability"},{"id":"b","text":"A categorized estimate of competitive strength: Not Ready, Emerging, Competitive, Strong, or Submission-Ready"},{"id":"c","text":"A percentile ranking of the application against all other applicants in the current quarter"},{"id":"d","text":"A binary determination of whether the organization meets the minimum eligibility threshold"}]',
  'b',
  'The `estimated_readiness_level` provides a categorized estimate of competitive strength on a five-level scale. It is advisory only — it does not constitute a USDA determination of eligibility or fundability.',
  6),
(quiz_id,
  'Which of the following is a legitimate limitation of AI application scoring?',
  '[{"id":"a","text":"AI scoring cannot evaluate more than 10 scoring criteria at one time"},{"id":"b","text":"AI scoring cannot read PDF exhibits — it evaluates narrative and inputs, not the actual documents"},{"id":"c","text":"AI scoring requires a minimum of 3 prior USDA award cycles to benchmark"},{"id":"d","text":"AI scoring is only available for RMAP applications, not RBDG"}]',
  'b',
  'The AI scoring engine evaluates the narrative and data you enter into the application workspace — it does not read PDF exhibits. This means the quality and completeness of your text inputs directly determines the quality of the scoring output. Garbage in, garbage out.',
  7),
(quiz_id,
  'In the 30-day correction plan, which criterion should receive the highest priority?',
  '[{"id":"a","text":"The criterion with the most detailed regulatory language"},{"id":"b","text":"The criterion where you are strongest, to maximize your total score"},{"id":"c","text":"The criterion with the largest gap between maximum points and self-assessed score, especially on high-point criteria"},{"id":"d","text":"The criterion that is easiest to improve, regardless of point value"}]',
  'c',
  'Prioritize by impact: the criteria with the largest gap between maximum and self-assessed score, weighted by point value. A 5-point gap on a 30-point criterion is more valuable to close than a 5-point gap on a 5-point criterion.',
  8),
(quiz_id,
  'An exhibit cover sheet in a well-assembled application packet should include:',
  '[{"id":"a","text":"Only the exhibit number and the applicant organization''s name"},{"id":"b","text":"Exhibit number, title, source, and date"},{"id":"c","text":"The full text of the regulatory criterion the exhibit supports"},{"id":"d","text":"A signature from an authorized organizational representative"}]',
  'b',
  'Each exhibit cover sheet should include: exhibit number, a descriptive title, the source of the document (organization, agency, database), and the date. This makes the exhibit self-explanatory to a reviewer who may see it separated from the narrative.',
  9),
(quiz_id,
  'When presenting AI scoring results to your board, what should you lead with?',
  '[{"id":"a","text":"The total estimated score, to set expectations for the likelihood of funding"},{"id":"b","text":"A clear disclaimer that AI scoring is advisory only and does not guarantee any USDA determination"},{"id":"c","text":"A comparison of your score to competitors in your state"},{"id":"d","text":"The AI''s recommended next actions, without discussing the score"}]',
  'b',
  'Always lead with the disclaimer when presenting AI scoring results to leadership. Boards may make consequential decisions (committing staff time, hiring consultants, delaying other priorities) based on scoring results. They must understand the advisory nature of the tool.',
  10),
(quiz_id,
  'The correct sequence for the application assembly process is:',
  '[{"id":"a","text":"Write narrative → number exhibits → build index → assemble → quality check"},{"id":"b","text":"Number exhibits → write narrative → build index → quality check → assemble"},{"id":"c","text":"Build index → number exhibits → write narrative → assemble → quality check"},{"id":"d","text":"Quality check → write narrative → number exhibits → assemble → build index"}]',
  'a',
  'The correct sequence is: write the narrative (so you know what claims you are making) → create and number the exhibits (in the order they are first referenced) → build the index → assemble the packet → run the pre-submission quality check. The index cannot be built until exhibits are numbered and page counts are known.',
  11),
(quiz_id,
  'Which narrative language pattern should be completely avoided in USDA applications?',
  '[{"id":"a","text":"Passive voice constructions such as "the loan was approved by the committee""},{"id":"b","text":"Future tense describing capabilities that should already exist, such as "we plan to implement a succession policy""},{"id":"c","text":"Bullet points instead of prose paragraphs"},{"id":"d","text":"Direct references to the regulatory section number being addressed"}]',
  'b',
  'Future tense for capabilities that should already exist ("we plan to," "we will implement") signals to reviewers that the organizational infrastructure is aspirational, not operational. Reviewers score what exists, not what is planned.',
  12),
(quiz_id,
  'After implementing the 30-day correction plan, you should:',
  '[{"id":"a","text":"Submit the application immediately without further review"},{"id":"b","text":"Re-run the AI scoring agent, compare pre- and post-correction section scores, and repeat the cycle if needed"},{"id":"c","text":"Have the application reviewed by USDA before final submission"},{"id":"d","text":"Reduce the correction plan to the top 3 remaining gaps and declare the application submission-ready"}]',
  'b',
  'After the correction sprint, re-run the AI scoring agent and compare section scores between the pre-correction and post-correction runs. If a section did not improve as expected, investigate why and address deeper gaps. Repeat the correction-rescore cycle until reaching target readiness.',
  13),
(quiz_id,
  'What is a "risk flag" in the AI scoring output?',
  '[{"id":"a","text":"A criterion where the maximum point value exceeds 10 points"},{"id":"b","text":"A claim in the narrative that may attract USDA reviewer scrutiny or skepticism"},{"id":"c","text":"A compliance certification that is missing from the application"},{"id":"d","text":"A data input field left blank in the application workspace"}]',
  'b',
  'Risk flags are specific narrative claims that may attract USDA reviewer scrutiny — for example, claiming 90% rural loans when rural is not defined or documented, or referencing financial data that appears inconsistent with the submitted financial statements.',
  14),
(quiz_id,
  'What is the minimum recommended timeline to obtain letters of support from community partners before a USDA application deadline?',
  '[{"id":"a","text":"48-72 hours"},{"id":"b","text":"1-2 weeks"},{"id":"c","text":"4-6 weeks"},{"id":"d","text":"3-6 months"}]',
  'c',
  'Letters of support require reaching out to partners, drafting the letter (or providing a template for them to customize), obtaining the signature from an authorized representative, and receiving the signed letter. This process typically takes 4-6 weeks when partners are busy. Plan accordingly.',
  15)
ON CONFLICT DO NOTHING;

END $$;

-- ============================================================
-- CERT 13: Community Outreach, Partnerships, Job Creation & Economic Impact
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

SELECT id INTO cert_id FROM certifications WHERE cert_number = 13;
IF cert_id IS NULL THEN
  RAISE EXCEPTION 'Cert 13 not found — run 04_cert_seeds.sql first';
END IF;

UPDATE certifications SET
  learning_outcomes = ARRAY[
    'Map your organization''s partner ecosystem across SBDCs, chambers, banks, CDFIs, counties, and nonprofits with specific roles and referral expectations',
    'Distinguish letters of support from letters of commitment and design a strategy to obtain letters that maximize scoring impact',
    'Document jobs created and retained using USDA-compliant definitions and tracking systems',
    'Build an impact metrics framework tracking businesses assisted, survival rates, revenue growth, and demographic data',
    'Create a 90-day community outreach plan targeting rural microenterprise borrowers through trusted messengers and community touchpoints',
    'Track and present economic impact data in the format USDA expects for both application scoring and annual reporting',
    'Design a partnership sustainability strategy that maintains active relationships through lending cycles and program renewals'
  ],
  status = 'approved'
WHERE id = cert_id;

-- MODULE 1
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Building Your Partner Ecosystem',
  'Map and activate the partner network that generates microloan referrals, strengthens USDA applications, and sustains the RLF through lending cycles.',
  1, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod1_id FROM modules WHERE certification_id = cert_id AND sort_order = 1;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod1_id,
  'Mapping and Activating Your Microlending Partner Ecosystem',
  'cert13-partner-ecosystem',
  E'## Why Partnerships Matter for USDA Applications\n\nUSDA RMAP and RBDG applications score points for coordination with other organizations and programs. But the value of partnerships extends far beyond application scoring. A strong partner network generates a consistent pipeline of qualified microloan referrals, provides TA co-delivery capacity, lends credibility to your letters of support, and creates the community narrative that USDA looks for in competitive applications.\n\nBuilding a partner ecosystem is not a one-time activity before an application — it is an ongoing relationship development investment that pays dividends across multiple program cycles.\n\n## Partner Categories for Rural Microlenders\n\n**Category 1: Business Development Partners**\nThese organizations work directly with microentrepreneurs and refer clients who need capital.\n\n- **SBDCs (Small Business Development Centers)** — Free business consulting services to small businesses, co-funded by SBA. Every state has multiple SBDC locations. SBDC advisors are the most consistent source of referrals for qualified microloan applicants.\n- **SCORE chapters** — Volunteer mentors for small businesses. Less consistent referral source than SBDCs but valuable for credibility and letters of support.\n- **Chambers of Commerce** — Access to local business community, event sponsorship, and referral relationships. Rural chambers are often smaller but more tightly connected to local business owners.\n- **Women''s Business Centers (WBCs)** — SBA-funded centers specifically serving women entrepreneurs. Valuable if women-owned businesses are a target market.\n- **Veteran Business Outreach Centers (VBOCs)** — For organizations targeting veteran entrepreneurs.\n\n**Category 2: Financial System Partners**\nThese organizations interact with applicants who cannot access conventional credit.\n\n- **Community banks and credit unions** — Often refer borrowers who do not meet their credit thresholds. Building a formal loan referral relationship with local banks strengthens both your pipeline and your USDA application.\n- **Other CDFIs** — Non-competing CDFIs in your area may focus on larger loans or different geographies. Referral agreements with complementary CDFIs fill gaps in your service area.\n- **Minority Depository Institutions (MDIs)** — If your service area has MDIs, a referral relationship demonstrates community financial inclusion commitment.\n\n**Category 3: Government and Anchor Partners**\nThese organizations provide institutional credibility and often control access to communities.\n\n- **USDA Rural Development state and local offices** — The most important relationship for RMAP applicants. RD staff can provide pre-application guidance, technical assistance referrals, and inform you about competitive score thresholds.\n- **County economic development offices** — Often have existing relationships with rural businesses and entrepreneurs.\n- **State departments of agriculture and rural development** — Coordinate with state-level rural programs.\n- **Tribal councils and tribal economic development organizations** — Essential for organizations serving tribal communities.\n- **Community Action Agencies** — Deep relationships in low-income rural communities.\n\n**Category 4: Education and Workforce Partners**\nThese organizations provide TA co-delivery and connect microentrepreneurs with skill-building resources.\n\n- **Community colleges** — Often have small business programs, entrepreneurship curricula, and spaces for group TA workshops.\n- **Extension services (USDA/Land Grant universities)** — Cooperative Extension has programs for rural entrepreneurs, farmers, and beginning businesses.\n- **Workforce development boards** — Connect self-employment microenterprise to workforce training for individuals transitioning to entrepreneurship.\n\n## Building the Partner Map\n\nA partner map is a structured document showing every active and potential partner, their role in your ecosystem, the current relationship status, and the next action needed.\n\n**Partner map columns:**\n- Organization name and type\n- Primary contact (name, email, phone)\n- Role in ecosystem (referral source, TA co-delivery, letter of support, co-lending)\n- Current relationship status (cold, warm, active, MOU signed)\n- Referrals received in past 12 months (count)\n- Next scheduled touch (meeting, call, event)\n- Notes\n\n**Relationship cultivation cadence:**\n- **Active partners** (referrals in past 12 months): Monthly touchpoint — email or call, plus quarterly in-person or video meeting\n- **Warm partners** (relationship established, no recent referrals): Quarterly touchpoint\n- **Cold contacts** (identified but not yet contacted): Initial outreach within 30 days of adding to map\n\n## MOUs and Referral Agreements\n\nFor your most important partners, formalize the relationship with a Memorandum of Understanding (MOU) or referral agreement. An MOU is a non-binding written document that:\n- Describes each organization''s role in the partnership\n- Specifies the types of referrals or services to be exchanged\n- Includes a term (typically 1-3 years, renewable)\n- Is signed by authorized representatives of both organizations\n\n**What an MOU does for USDA applications:**\nSigned MOUs are strong evidence of established partnerships. A letter of support from an organization with which you have an MOU is more credible than one from a casual contact.\n\n**What an MOU does NOT do:**\nAn MOU does not guarantee referrals, funding, or loan volume. It is a statement of intent, not a contract. Its value is in the documented relationship, not in any legally binding commitment.',
  'A partner ecosystem map tracks organizations across business development, financial, government, and education categories. Active partners with signed MOUs provide the strongest letters of support and most consistent referral pipelines for USDA applications.',
  18, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 2
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Letters of Support and Commitment Strategy',
  'Design a letters strategy that maximizes USDA scoring impact. Learn the difference between letters of support and letters of commitment, and how to obtain letters that go beyond the generic.',
  2, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod2_id FROM modules WHERE certification_id = cert_id AND sort_order = 2;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod2_id,
  'Letters of Support and Commitment: Strategy and Templates',
  'cert13-letters-strategy',
  E'## Support vs. Commitment: The Distinction That Matters\n\nUSDA distinguishes between letters of support and letters of commitment. Understanding this distinction affects both which organizations you approach and what you ask them to say.\n\n**Letter of support:**\nAn expression of endorsement for your program from an organization that values your work in the community. Signatories state that they support your mission and believe your microlending program serves an important need.\n\n*Value to USDA:* Demonstrates community standing and credibility. Contributes to community impact scoring.\n\n**Letter of commitment:**\nA more specific letter in which the signing organization commits to a specific action that supports the project — typically: a specific number of referrals per year, a co-investment or matching fund contribution, co-delivery of TA services, or access to specific facilities or programs.\n\n*Value to USDA:* Stronger evidence of leverage, community coordination, and organizational capacity. Contributes more scoring points than generic support letters.\n\n**Example of a weak letter of support:**\n"To Whom It May Concern: XYZ Organization supports Rural Community Development Partners'' microlending program. Their work in our community is important and we encourage USDA to support their application."\n\n**Example of a strong letter of commitment:**\n"On behalf of Piney Woods SBDC, I am pleased to commit to the following in support of Rural Community Development Partners'' RMAP microlending program: (1) We will refer an estimated 30-40 qualified microenterprise applicants per year to RCDP for microloan consideration; (2) We will provide business planning workshops on a quarterly basis, with priority scheduling for RCDP microloan applicants; (3) Our center advisors will co-facilitate RCDP''s pre-loan TA program for at least 50 hours annually. These commitments are consistent with our ongoing partnership, formalized in the MOU signed in March 2024."\n\n## Who Should Sign Your Letters\n\nThe organizational position of the signatory matters. A letter signed by an Executive Director, President, or Director carries more weight than one signed by a Program Staff member.\n\n**High-value signatories:**\n- State USDA Rural Development Director or Area Director (if willing)\n- SBDC Regional Director\n- County Commission Chair or County Administrator\n- Community bank President or CEO\n- Community college President\n- CDFI Executive Director\n- Tribal Council Chairman\n\n**Letters to avoid relying on:**\n- Personal friends of organizational leadership (no institutional standing)\n- Organizations outside your service area with no direct connection to your program\n- Unsigned or template-copy letters (obvious to reviewers)\n- Letters that repeat the same language verbatim (suggests they were all drafted by the applicant with no customization by the signer)\n\n## The Letter Request Process\n\n**Step 1: Prioritize your letter targets**\nAim for 5-7 high-quality letters from organizations with strong institutional standing and direct connection to your program. More letters of low quality do not outperform fewer letters of high quality.\n\n**Step 2: Request by phone or video call, not just email**\nA personal ask from your Executive Director to their counterpart is more effective than an email blast. Call first, then follow up with a written request and a draft for their reference.\n\n**Step 3: Provide a draft for their customization**\nProvide a draft letter with blanks for them to fill in specific commitments. Make it clear the draft is a starting point — you want them to customize it to reflect their actual relationship with your program and their genuine commitments.\n\n**Step 4: Set a clear deadline**\nRequest the signed letter 2 weeks before your submission deadline. Partners will often miss even explicit deadlines — plan for follow-ups.\n\n**Step 5: Thank and acknowledge**\nAfter submission, send a thank-you note to every letter writer. This maintains the relationship for future applications.\n\n## Including Letters in the Application Packet\n\n- All letters must be dated within 6 months of your application submission (older letters signal a stale relationship)\n- Letters must be on the signing organization''s letterhead\n- Letters must be signed (wet signature on physical copies; for electronic submission, use scanned signature or DocuSign)\n- Organize letters in the same order they are referenced in the narrative\n- Reference each letter in the narrative: "Piney Woods SBDC has committed to 30-40 annual referrals and co-facilitation of our pre-loan TA program. See Exhibit 22, Letter of Commitment from Piney Woods SBDC Director, dated March 15, 2026."',
  'Letters of commitment — naming specific referral numbers, co-delivery commitments, or matching contributions — score higher than generic support letters. Request letters from institutional leaders, provide a draft, set a clear deadline, and reference each letter explicitly in the narrative.',
  16, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 3
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Impact Metrics: Jobs, Businesses, and Economic Data',
  'Build an impact measurement system that tracks jobs created and retained, businesses assisted, survival rates, revenue growth, and the demographic data USDA requires for annual reporting and scoring.',
  3, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod3_id FROM modules WHERE certification_id = cert_id AND sort_order = 3;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod3_id,
  'Measuring and Reporting Community Economic Impact',
  'cert13-impact-metrics',
  E'## Why Impact Data Is Both a Scoring and a Survival Tool\n\nUSDA scores community impact as part of the RMAP application rubric. But impact data serves a second, equally important purpose: it is the evidence that your RLF is doing what it was funded to do. Organizations that maintain rigorous impact tracking have the data they need to defend their program during site visits, justify renewals, attract new funders, and demonstrate community return on investment to local government partners.\n\nOrganizations without impact data are vulnerable. When USDA asks "how many jobs have your microloans supported in the past three years?" and you cannot answer with documentation, you lose scoring points on the application and credibility in the ongoing program relationship.\n\n## USDA Job Creation and Retention Definitions\n\nUSDA uses specific definitions for job metrics that differ from general usage:\n\n**Jobs Created:**\nNew, full-time equivalent (FTE) positions that did not exist before the microloan was made. A new employee hired as a result of the funded business expansion counts as one job created. Part-time jobs should be converted to FTE equivalents (two half-time positions = 1 FTE).\n\n**Jobs Retained:**\nExisting FTE positions that would have been eliminated without the microloan. This is documented through borrower self-certification: the borrower states that without the capital, they would have had to reduce staff or close.\n\n**Documentation required for both:**\n- Borrower self-certification at time of loan (what positions currently exist and what is projected)\n- Annual follow-up with borrower documenting actual employment at 12 months post-disbursement\n- Comparison of pre-loan vs. post-loan employment count\n\n**Key rule:** You may only count jobs that are verifiable through documentation. USDA reviewers will ask for the underlying data. Estimating or rounding up without documentation is a compliance risk.\n\n## The Impact Tracking System\n\nEvery borrower record should include these impact data fields:\n\n**At loan origination:**\n- Business name and owner demographics (race, ethnicity, gender, veteran status, low-income certification)\n- Business type and industry\n- Current employment (FTE employees)\n- Projected new employment from the funded project\n- Whether existing jobs would be at risk without the loan\n- Business age (start-up or existing)\n\n**At 6-month follow-up:**\n- Current employment (FTE)\n- Business still operating (yes/no)\n- Business revenue trend (increased, same, decreased)\n- Loan payment status (current, delinquent, paid off)\n\n**At 12-month follow-up:**\n- Current employment (FTE) — official USDA count date\n- Jobs created (vs. pre-loan baseline)\n- Jobs retained (vs. self-certification)\n- Business still operating\n- Revenue trend\n- TA received and estimated impact of TA on business outcomes\n\n**At loan maturity:**\n- Final employment count\n- Total jobs created over life of loan\n- Business survival (still operating at maturity)\n\n## Demographic Data Collection\n\nUSDA requires demographic data on all microloan applicants and borrowers for civil rights compliance monitoring and impact reporting.\n\n**Required demographic fields:**\n- Race (using federal race categories: American Indian/Alaska Native, Asian, Black/African American, Native Hawaiian/Pacific Islander, White)\n- Ethnicity (Hispanic/Latino or Not Hispanic/Latino)\n- Sex (Male, Female, or Decline to state)\n- Veteran status (Veteran, Non-Veteran, or Decline to state)\n- Low-income indicator (household income at or below 80% of area median income)\n\n**Collection method:**\nAll demographic data is collected on a voluntary self-identification basis on a form separate from the credit application. If an applicant declines to self-identify, staff may use visual observation with a clear notation that the data is observer-reported.\n\nThis data is stored separately from the credit file and may not be used in underwriting decisions.\n\n## Building the Impact Dashboard\n\nThe impact dashboard aggregates impact data across the entire portfolio for management and reporting purposes.\n\n**Portfolio-level impact metrics:**\n\n| Metric | Definition | Reporting Frequency |\n|--------|------------|---------------------|\n| Total borrowers served (cumulative) | Count of unique borrowers since program inception | Annual |\n| Active borrowers | Borrowers with loans currently outstanding | Quarterly |\n| Jobs created (cumulative) | Total new FTE positions documented | Annual |\n| Jobs retained (cumulative) | Total existing FTE positions documented as retained | Annual |\n| Businesses surviving at 12 months | % of loan cohort still operating at 12-month follow-up | Annual |\n| Average business revenue growth | % change in borrower revenue from pre-loan to 12-month | Annual |\n| Women-owned businesses | % of borrowers who are women-owned | Quarterly |\n| Minority-owned businesses | % of borrowers in racial/ethnic minority categories | Quarterly |\n| Veteran-owned businesses | % of borrowers who are veterans | Quarterly |\n| Low-income borrowers | % of borrowers meeting low-income definition | Quarterly |\n| Rural borrowers | % of borrowers in USDA-designated rural areas | Quarterly |\n\n## Common Impact Measurement Mistakes\n\n1. **Counting committed jobs from the loan application rather than verified jobs at 12-month follow-up.** Commitment and reality often differ. Only count verified jobs.\n\n2. **No 12-month follow-up system.** Without a scheduled follow-up process, job count data is never collected. Build the 12-month follow-up into the loan servicing SOP.\n\n3. **Counting jobs for loans where no follow-up documentation exists.** If you cannot document the job count, you cannot claim it in a USDA report or application.\n\n4. **Inconsistent FTE calculation.** Define your FTE formula and apply it consistently: (total hours worked per week by all employees) ÷ 40 = FTE count.\n\n5. **Mixing jobs created with jobs retained in the total without USDA tracking.** USDA tracks these separately. Your system must too.',
  'USDA job metrics require documented evidence at loan origination and 12-month follow-up. An impact dashboard tracking employment, business survival, revenue growth, and demographics by borrower serves both USDA reporting and future application scoring.',
  18, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 4
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Community Outreach and 90-Day Plan',
  'Design a 90-day outreach campaign that reaches rural microenterprise borrowers through trusted messengers, community events, and targeted digital channels.',
  4, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod4_id FROM modules WHERE certification_id = cert_id AND sort_order = 4;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod4_id,
  'Rural Community Outreach and the 90-Day Plan',
  'cert13-community-outreach',
  E'## The Rural Outreach Challenge\n\nReaching rural microentrepreneurs is fundamentally different from urban outreach. Population density is low, digital access is uneven, and trust in formal financial institutions is often low — especially in communities with historical barriers to capital access. Rural microentrepreneurs do not search Google for "microloan near me." They hear about programs from people they trust.\n\nEffective rural outreach is built on trusted messenger relationships, community presence, and patient relationship development. A microlender that treats outreach as a one-time event rather than an ongoing community presence will struggle to build a sustainable lending pipeline.\n\n## Trusted Messengers in Rural Communities\n\nA trusted messenger is a person or organization that a rural community member will trust with a financial recommendation. Different communities have different trusted messengers:\n\n**Universal trusted messengers:**\n- Pastors, ministers, and faith community leaders\n- Local grocery store owners and hardware store proprietors\n- Farm supply co-op managers\n- Rural health clinic administrators\n- School principals and coaches\n- Local elected officials (county supervisor, city alderman)\n\n**Context-specific messengers:**\n- Tribal council members and traditional leaders (for tribal communities)\n- Reentry case managers and community supervision officers (for reentry populations)\n- Agricultural extension agents (for farming communities)\n- Veterans service organization officers (for veteran communities)\n- Hispanic community leaders, church pastors, and Spanish-language radio hosts (for Hispanic rural communities)\n\n**Activating trusted messengers:**\n1. Meet in person — not by email or phone initially\n2. Explain your program in plain language: "We make small business loans from $1,000 to $50,000 to people who can''t get a bank loan. There''s no application fee. We help you build a business plan as part of the process."\n3. Leave behind a simple one-page program flyer in the community''s language(s)\n4. Ask them directly: "Do you know anyone who has been trying to start or grow a small business but can''t get financing?"\n5. Follow up with any referrals they make within 48 hours — slow follow-up signals that you are not serious, which reflects poorly on the messenger\n\n## Community Presence Channels\n\n**Farmers markets and community events:**\nBeing physically present at community gathering points builds name recognition. A table with a simple display, a bowl of candy, and a one-page flyer generates conversations. The goal is not to close loan applications at the event — it is to establish a face and create enough curiosity that someone follows up.\n\n**Faith community presentations:**\nA 5-minute presentation during the announcements period of a rural church service reaches families that no other channel touches. Coordinate with the pastor in advance. Have a handout ready. Do not make a pitch — make an introduction: "We help rural business owners access capital. If you know someone who needs a small business loan, here''s how to reach us."\n\n**Partner organization waiting rooms:**\nAsk SBDCs, community action agencies, health clinics, and social service organizations to display your program flyer in their waiting rooms. These are places where your target borrowers already wait.\n\n**Local radio:**\nIn many rural areas, AM and FM community radio reaches demographics that no digital channel touches. A 30-second PSA or a 5-minute interview spot on a local rural radio station is often free or low-cost and highly effective.\n\n## The 90-Day Outreach Plan\n\nA 90-day outreach plan structures your community presence activities into a manageable calendar with specific goals, channels, messengers, and metrics.\n\n**Month 1: Foundation**\n- Map your service area communities (which towns, zip codes, counties)\n- Identify the 5 highest-priority trusted messengers in your area\n- Schedule and conduct in-person meetings with all 5 messengers\n- Place program flyers in 10 partner locations (clinics, SBDCs, chambers, churches)\n- Attend one community market or event with a program table\n- Goal: 3-5 inbound referral calls or inquiries from trusted messenger activation\n\n**Month 2: Activation**\n- Follow up with all Month 1 contacts; confirm referral pipeline\n- Schedule one faith community presentation\n- Submit one local radio PSA or arrange one interview\n- Conduct one group outreach event (workshop or information session)\n- Begin collecting demographic data on all inquiries (not just borrowers)\n- Goal: 8-12 active loan inquiries; 2-4 complete applications received\n\n**Month 3: Conversion and Measurement**\n- Move active inquiries to application review\n- Conduct loan committee reviews for complete applications\n- Begin TA process with qualified applicants not yet ready to borrow\n- Measure: inquiries received, applications submitted, loans closed, TA participants\n- Review which trusted messenger channels generated the most referrals\n- Update the partner map with relationship status and referral counts\n- Identify the top-performing outreach channels for continued investment\n\n## Tracking Outreach Effectiveness\n\nFor each closed microloan, record the referral source in the loan origination system:\n- How did this borrower hear about the program?\n- Which specific partner, messenger, or channel referred them?\n- How long between first contact and loan application?\n\nThis referral source data tells you which outreach channels are generating qualified borrowers — and which are generating inquiries that do not convert. Over time, you can concentrate outreach investment in the highest-converting channels and trusted messengers.',
  'Rural outreach requires trusted messengers — pastors, farm supply managers, tribal leaders, and local officials — not digital advertising. A 90-day outreach plan with specific messenger activation, community presence, and referral tracking builds a sustainable lending pipeline.',
  16, 1, 'approved')
ON CONFLICT DO NOTHING;

-- QUIZ for Cert 13
INSERT INTO quizzes (id, certification_id, title, passing_score, status)
VALUES (uuid_generate_v4(), cert_id,
  'Community Outreach, Partnerships & Impact Knowledge Check',
  80, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO quiz_id FROM quizzes WHERE certification_id = cert_id;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order)
VALUES
(quiz_id,
  'What distinguishes a letter of commitment from a letter of support in a USDA application?',
  '[{"id":"a","text":"A letter of commitment is signed by a government official; a letter of support is signed by a private organization"},{"id":"b","text":"A letter of commitment includes specific action commitments (referral numbers, co-delivery hours); a letter of support expresses general endorsement"},{"id":"c","text":"A letter of commitment is required by USDA; a letter of support is optional"},{"id":"d","text":"A letter of commitment is on government letterhead; a letter of support is on private letterhead"}]',
  'b',
  'A letter of commitment names specific commitments — referral numbers, TA co-delivery hours, matching funds. A letter of support expresses general endorsement without specific commitments. Letters of commitment score higher because they demonstrate concrete leverage and coordination, not just goodwill.',
  1),
(quiz_id,
  'How does USDA define "jobs created" for RMAP microloan impact reporting?',
  '[{"id":"a","text":"Any job the borrower projects they will create when they apply for the loan"},{"id":"b","text":"New, full-time equivalent positions that did not exist before the microloan, documented at 12-month follow-up"},{"id":"c","text":"Any employment relationship at the borrower''s business, including the owner''s self-employment"},{"id":"d","text":"Jobs created in any business in the microlender''s service area during the grant period"}]',
  'b',
  'Jobs created are new FTE positions that did not exist before the microloan, verified through documentation at the 12-month follow-up — not the projections made at application time. Only documented jobs may be counted in USDA reports.',
  2),
(quiz_id,
  'An MOU (Memorandum of Understanding) with a partner organization is best described as:',
  '[{"id":"a","text":"A legally binding contract requiring the partner to make a specific number of referrals annually"},{"id":"b","text":"A non-binding written document describing each organization''s role, signed by authorized representatives"},{"id":"c","text":"A USDA-required document for all letters of support signatories"},{"id":"d","text":"A financial agreement governing how revenue is shared between the microlender and its partners"}]',
  'b',
  'An MOU is non-binding — it is a statement of intent that formalizes the relationship and describes each organization''s role. Its value in a USDA application is as evidence of an established, documented partnership, not as a legally enforceable commitment.',
  3),
(quiz_id,
  'At what point in the lending process must demographic data on borrowers be collected?',
  '[{"id":"a","text":"Only for borrowers who request accommodation under Section 504"},{"id":"b","text":"At loan approval, after the credit decision is made"},{"id":"c","text":"On a voluntary self-identification form, on a form separate from the credit application"},{"id":"d","text":"Only for borrowers in designated underserved census tracts"}]',
  'c',
  'Demographic data must be collected on a voluntary self-identification basis using a form separate from the credit application. It cannot be used in underwriting decisions. If a borrower declines to self-identify, staff may use visual observation with a clear notation.',
  4),
(quiz_id,
  'Why is a pastor or faith community leader considered a trusted messenger for rural microloan outreach?',
  '[{"id":"a","text":"Faith leaders are registered USDA-approved financial counselors"},{"id":"b","text":"Faith leaders have existing trusted relationships with community members who may not engage with formal financial institutions"},{"id":"c","text":"Faith communities provide co-lending capital for microloans"},{"id":"d","text":"USDA gives additional scoring credit for faith community partnerships"}]',
  'b',
  'Trusted messengers are effective because they have pre-existing relationships of trust with community members — especially communities with historical barriers to capital access. A referral from a pastor or community leader converts at much higher rates than a cold outreach, because the trusted messenger''s credibility transfers to the referral.',
  5),
(quiz_id,
  'Which of the following is a common impact measurement mistake?',
  '[{"id":"a","text":"Conducting 12-month borrower follow-up to verify job counts"},{"id":"b","text":"Counting jobs committed at loan application rather than verified jobs at 12-month follow-up"},{"id":"c","text":"Separating jobs created from jobs retained in the impact database"},{"id":"d","text":"Collecting demographic data on all loan applicants, including those who are denied"}]',
  'b',
  'Counting committed jobs from the application rather than verified jobs at 12-month follow-up is the most common impact measurement mistake. Business projections often do not match reality. USDA expects verified, documented job counts — not estimates.',
  6),
(quiz_id,
  'What is the recommended timeline for requesting signed letters of support before a USDA application deadline?',
  '[{"id":"a","text":"48-72 hours before the deadline"},{"id":"b","text":"1-2 weeks before the deadline"},{"id":"c","text":"4-6 weeks before the deadline"},{"id":"d","text":"The same day the application is being assembled"}]',
  'c',
  'Request letters 4-6 weeks before the submission deadline to account for busy schedules, institutional approval processes, and the time needed for customization and signature. Plan for follow-up reminders — partners often miss deadlines even with explicit requests.',
  7),
(quiz_id,
  'The 90-day outreach plan Month 1 focus should be:',
  '[{"id":"a","text":"Closing the first microloan to demonstrate immediate program activity"},{"id":"b","text":"Mapping the service area, identifying and meeting with 5 trusted messengers, and placing flyers in 10 partner locations"},{"id":"c","text":"Running paid digital advertising targeting rural small business owners on Facebook"},{"id":"d","text":"Building the partner map database and scheduling meetings for Month 2"}]',
  'b',
  'Month 1 is foundation-building: map the service area communities, identify and meet with the 5 highest-priority trusted messengers, and place flyers at 10 partner locations. The goal is 3-5 inbound referral calls or inquiries from trusted messenger activation.',
  8),
(quiz_id,
  'For FTE calculation, if a borrower employs three part-time workers each working 20 hours per week, how many FTEs is that?',
  '[{"id":"a","text":"3 FTEs"},{"id":"b","text":"1.5 FTEs"},{"id":"c","text":"0.5 FTEs"},{"id":"d","text":"2 FTEs"}]',
  'b',
  '(3 workers × 20 hours) ÷ 40 hours/week = 1.5 FTEs. The standard FTE formula is total hours worked per week by all employees ÷ 40. This formula must be applied consistently across all borrowers.',
  9),
(quiz_id,
  'Which partner category generates the most consistent referral pipeline for rural microlenders?',
  '[{"id":"a","text":"Tribal councils and tribal economic development organizations"},{"id":"b","text":"SBDCs (Small Business Development Centers), which provide free business counseling and regularly encounter applicants who need capital"},{"id":"c","text":"State departments of agriculture"},{"id":"d","text":"Minority Depository Institutions"}]',
  'b',
  'SBDCs are the most consistent referral source because their advisors regularly work with small business owners who have a capital need but cannot access conventional bank financing — precisely the RMAP target borrower. Building a strong SBDC referral relationship should be a first priority for any new microlender.',
  10),
(quiz_id,
  'Letters of support included in a USDA application should be dated:',
  '[{"id":"a","text":"Within 12 months of the application submission"},{"id":"b","text":"Within 6 months of the application submission"},{"id":"c","text":"Within 2 years of the application submission"},{"id":"d","text":"Any date, as long as they are signed by an authorized representative"}]',
  'b',
  'Letters should be dated within 6 months of submission. Older letters signal a stale relationship — a partner who wrote a letter two years ago may no longer have an active working relationship with your organization, which undermines the credibility of the support claim.',
  11),
(quiz_id,
  'Jobs retained are documented through:',
  '[{"id":"a","text":"A projection statement in the loan application narrative"},{"id":"b","text":"Borrower self-certification stating which existing positions would have been eliminated without the loan, verified at 12-month follow-up"},{"id":"c","text":"State unemployment insurance records for the borrower''s business"},{"id":"d","text":"A letter from the borrower''s bank confirming the business would have closed without the loan"}]',
  'b',
  'Jobs retained are documented through borrower self-certification at loan origination (stating which existing positions were at risk without the capital) and then verified at 12-month follow-up. Both elements are required — the certification at origination establishes the baseline, and the follow-up confirms the outcome.',
  12),
(quiz_id,
  'Which outreach channel is most effective for reaching rural communities with limited internet access?',
  '[{"id":"a","text":"Google Ads targeting small business owners in rural zip codes"},{"id":"b","text":"Instagram and TikTok content marketing"},{"id":"c","text":"Local AM/FM community radio PSAs and trusted messenger referrals"},{"id":"d","text":"LinkedIn outreach to rural business owners"}]',
  'c',
  'Community radio and trusted messenger referrals reach rural demographics that digital channels do not. In many rural areas, AM/FM radio penetration is high even where broadband internet is limited. Trusted messengers (pastors, local business owners, extension agents) reach households that have no digital presence at all.',
  13),
(quiz_id,
  'What is the primary purpose of tracking referral source data for each closed microloan?',
  '[{"id":"a","text":"To satisfy USDA civil rights reporting requirements"},{"id":"b","text":"To identify which outreach channels generate the most qualified borrowers and concentrate investment in the highest-converting sources"},{"id":"c","text":"To measure the partner''s performance against their MOU commitments"},{"id":"d","text":"To calculate the administrative cost per loan for grant reporting purposes"}]',
  'b',
  'Referral source tracking identifies which outreach channels — which trusted messengers, partner organizations, or community events — generate borrowers who actually complete applications and close loans. This allows you to concentrate outreach investment in the highest-converting sources rather than spreading effort equally across all channels.',
  14),
(quiz_id,
  'A rural microlender''s impact dashboard should be reviewed at what frequency?',
  '[{"id":"a","text":"Annually, as part of the USDA performance report"},{"id":"b","text":"Only when preparing a USDA application"},{"id":"c","text":"Monthly by management and quarterly by the board of directors"},{"id":"d","text":"Only when requested by USDA during a site visit"}]',
  'c',
  'The impact dashboard should be reviewed monthly by management (to monitor trends and identify issues) and quarterly by the board (at board meetings, as part of the regular program report). Regular board review of impact data is itself evidence of governance engagement for USDA scoring purposes.',
  15)
ON CONFLICT DO NOTHING;

END $$;
