-- ============================================================
-- Cap Fund Academy — Lesson Resources (Downloadable Templates)
-- File: 21_lesson_resources.sql
-- Idempotent: ON CONFLICT DO NOTHING (uses unique slug pattern)
-- Run after: all cert content SQL files
-- NOTE: URLs use /templates/ path — update to Supabase Storage URLs
--       when files are uploaded to the evidence-uploads bucket.
-- ============================================================

-- Helper: insert a lesson resource by lesson slug
-- Each resource is attached to the first lesson of the relevant module

-- ============================================================
-- CERT 1: Microfinance Foundations
-- ============================================================
INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Borrower Persona Map Template', '/templates/cert01-borrower-persona-map.pdf', 'template', 1
FROM lessons WHERE slug = 'cert01-microfinance-landscape'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Client Protection Checklist', '/templates/cert01-client-protection-checklist.pdf', 'checklist', 2
FROM lessons WHERE slug = 'cert01-microfinance-landscape'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Borrower Readiness Scorecard', '/templates/cert01-borrower-readiness-scorecard.pdf', 'template', 3
FROM lessons WHERE slug = 'cert01-microfinance-landscape'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Microfinance Glossary', '/templates/cert01-microfinance-glossary.pdf', 'pdf', 4
FROM lessons WHERE slug = 'cert01-microfinance-landscape'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, '30-Day TA Session Plan Template', '/templates/cert01-ta-session-plan.pdf', 'template', 5
FROM lessons WHERE slug = 'cert01-microfinance-landscape'
ON CONFLICT DO NOTHING;

-- ============================================================
-- CERT 2: RLF Design & Capitalization
-- ============================================================
INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'RLF Capital Flow Diagram', '/templates/cert02-rlf-flow-diagram.pdf', 'template', 1
FROM lessons WHERE slug = 'cert02-rlf-design-capitalization'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Loan Product Matrix Template', '/templates/cert02-loan-product-matrix.xlsx', 'template', 2
FROM lessons WHERE slug = 'cert02-rlf-design-capitalization'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Capital Stack Roadmap Template', '/templates/cert02-capitalization-roadmap.pdf', 'template', 3
FROM lessons WHERE slug = 'cert02-rlf-design-capitalization'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Loan Committee Charter Template', '/templates/cert02-loan-committee-charter.docx', 'template', 4
FROM lessons WHERE slug = 'cert02-rlf-design-capitalization'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, '3-Year RLF Pro Forma Model', '/templates/cert02-rlf-pro-forma.xlsx', 'template', 5
FROM lessons WHERE slug = 'cert02-rlf-design-capitalization'
ON CONFLICT DO NOTHING;

-- ============================================================
-- CERT 3: USDA RMAP Eligibility, Application & Scoring
-- ============================================================
INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'RMAP Eligibility Checklist', '/templates/cert03-rmap-eligibility-checklist.pdf', 'checklist', 1
FROM lessons WHERE slug = 'cert03-rmap-eligibility-application'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'RMAP Application Binder Checklist', '/templates/cert03-application-binder-checklist.pdf', 'checklist', 2
FROM lessons WHERE slug = 'cert03-rmap-eligibility-application'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'RMAP 45-Point Evidence Matrix', '/templates/cert03-45-point-evidence-matrix.xlsx', 'template', 3
FROM lessons WHERE slug = 'cert03-rmap-eligibility-application'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Experienced Microlender Scoring Workbook', '/templates/cert03-experienced-scoring-workbook.xlsx', 'template', 4
FROM lessons WHERE slug = 'cert03-rmap-eligibility-application'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Less-Experienced Applicant Scoring Workbook', '/templates/cert03-less-experienced-workbook.xlsx', 'template', 5
FROM lessons WHERE slug = 'cert03-rmap-eligibility-application'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'TA-Only Scoring Workbook', '/templates/cert03-ta-only-workbook.xlsx', 'template', 6
FROM lessons WHERE slug = 'cert03-rmap-eligibility-application'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Quarterly Submission Calendar Template', '/templates/cert03-quarterly-submission-calendar.pdf', 'template', 7
FROM lessons WHERE slug = 'cert03-rmap-eligibility-application'
ON CONFLICT DO NOTHING;

-- ============================================================
-- CERT 4: RMAP Microlender Operations
-- ============================================================
INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'OGC Closing Timeline Checklist', '/templates/cert04-ogc-closing-checklist.pdf', 'checklist', 1
FROM lessons WHERE slug = 'cert04-rmap-microlender-operations'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'RMRF/LLRF Account Plan Template', '/templates/cert04-rmrf-llrf-account-plan.docx', 'template', 2
FROM lessons WHERE slug = 'cert04-rmap-microlender-operations'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Microloan File Checklist', '/templates/cert04-microloan-file-checklist.pdf', 'checklist', 3
FROM lessons WHERE slug = 'cert04-rmap-microlender-operations'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Ineligible Use Screening Tool', '/templates/cert04-ineligible-use-screen.pdf', 'checklist', 4
FROM lessons WHERE slug = 'cert04-rmap-microlender-operations'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Microlender Duty Checklist', '/templates/cert04-microlender-duty-checklist.pdf', 'checklist', 5
FROM lessons WHERE slug = 'cert04-rmap-microlender-operations'
ON CONFLICT DO NOTHING;

-- ============================================================
-- CERT 5: RMAP Technical Assistance & Training
-- ============================================================
INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'TA Service Catalog Template', '/templates/cert05-ta-service-catalog.docx', 'template', 1
FROM lessons WHERE slug = 'cert05-ta-program-design'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'TA Session Log Template', '/templates/cert05-ta-session-log.xlsx', 'template', 2
FROM lessons WHERE slug = 'cert05-ta-program-design'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Borrower Evaluation Form', '/templates/cert05-borrower-evaluation-form.pdf', 'template', 3
FROM lessons WHERE slug = 'cert05-ta-program-design'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Success Story Template', '/templates/cert05-success-story-template.docx', 'template', 4
FROM lessons WHERE slug = 'cert05-ta-program-design'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'TA-to-Loan Tracker', '/templates/cert05-ta-to-loan-tracker.xlsx', 'template', 5
FROM lessons WHERE slug = 'cert05-ta-program-design'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'TA Budget and Report Pack', '/templates/cert05-ta-budget-report-pack.xlsx', 'template', 6
FROM lessons WHERE slug = 'cert05-ta-program-design'
ON CONFLICT DO NOTHING;

-- ============================================================
-- CERT 6: USDA RBDG
-- ============================================================
INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'RBDG Eligibility Checklist', '/templates/cert06-rbdg-eligibility-checklist.pdf', 'checklist', 1
FROM lessons WHERE slug = 'cert06-rbdg-overview'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'RBDG RLF Project Template', '/templates/cert06-rbdg-rlf-template.docx', 'template', 2
FROM lessons WHERE slug = 'cert06-rbdg-overview'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'RBDG Narrative Map', '/templates/cert06-rbdg-narrative-map.pdf', 'template', 3
FROM lessons WHERE slug = 'cert06-rbdg-overview'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'RBDG Scoring Workbook', '/templates/cert06-rbdg-scoring-workbook.xlsx', 'template', 4
FROM lessons WHERE slug = 'cert06-rbdg-overview'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'RBDG Budget Template', '/templates/cert06-rbdg-budget-template.xlsx', 'template', 5
FROM lessons WHERE slug = 'cert06-rbdg-overview'
ON CONFLICT DO NOTHING;

-- ============================================================
-- CERT 7: IRP and Federal Capital Stack Strategy
-- ============================================================
INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Capital Sources Comparison Matrix', '/templates/cert07-capital-options-matrix.xlsx', 'template', 1
FROM lessons WHERE slug = 'cert07-irp-capital-sources'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, '3-Phase Federal Funding Roadmap', '/templates/cert07-3-phase-funding-roadmap.pdf', 'template', 2
FROM lessons WHERE slug = 'cert07-irp-capital-sources'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Staff Capacity Stress Test Model', '/templates/cert07-capacity-stress-test.xlsx', 'template', 3
FROM lessons WHERE slug = 'cert07-irp-capital-sources'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Blended Fund Controls Checklist', '/templates/cert07-blended-fund-controls.pdf', 'checklist', 4
FROM lessons WHERE slug = 'cert07-irp-capital-sources'
ON CONFLICT DO NOTHING;

-- ============================================================
-- CERT 8: Underwriting, Credit Policy & Portfolio Risk
-- ============================================================
INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Credit Policy Outline Template', '/templates/cert08-credit-policy-outline.docx', 'template', 1
FROM lessons WHERE slug = 'cert08-credit-policy'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Underwriting Memo Template', '/templates/cert08-underwriting-memo.docx', 'template', 2
FROM lessons WHERE slug = 'cert08-credit-policy'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Collateral Checklist', '/templates/cert08-collateral-checklist.pdf', 'checklist', 3
FROM lessons WHERE slug = 'cert08-credit-policy'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Loan Committee Decision Memo Template', '/templates/cert08-loan-committee-decision-memo.docx', 'template', 4
FROM lessons WHERE slug = 'cert08-credit-policy'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Portfolio Risk Metrics Dictionary', '/templates/cert08-risk-metrics-dictionary.pdf', 'pdf', 5
FROM lessons WHERE slug = 'cert08-credit-policy'
ON CONFLICT DO NOTHING;

-- ============================================================
-- CERT 9: Loan Servicing, Collections, Workouts & Default
-- ============================================================
INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Loan Servicing SOP Template', '/templates/cert09-servicing-sop.docx', 'template', 1
FROM lessons WHERE slug = 'cert09-servicing-lifecycle'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Delinquency Prevention Checklist', '/templates/cert09-delinquency-prevention-checklist.pdf', 'checklist', 2
FROM lessons WHERE slug = 'cert09-servicing-lifecycle'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Loan Workout Memo Template', '/templates/cert09-workout-memo.docx', 'template', 3
FROM lessons WHERE slug = 'cert09-servicing-lifecycle'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Charge-Off and Default SOP', '/templates/cert09-chargeoff-sop.docx', 'template', 4
FROM lessons WHERE slug = 'cert09-servicing-lifecycle'
ON CONFLICT DO NOTHING;

-- ============================================================
-- CERT 10: Federal Compliance
-- ============================================================
INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Civil Rights Compliance Checklist', '/templates/cert10-civil-rights-checklist.pdf', 'checklist', 1
FROM lessons WHERE slug = 'cert10-civil-rights-obligations'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Environmental Screening Worksheet', '/templates/cert10-environmental-screening-worksheet.pdf', 'template', 2
FROM lessons WHERE slug = 'cert10-environmental-review'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, '2 CFR 200 Allowable Cost Checklist', '/templates/cert10-2cfr200-cost-checklist.pdf', 'checklist', 3
FROM lessons WHERE slug = 'cert10-2cfr200-uniform-guidance'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Federal Certifications Map (SAM, Debarment, Lobbying, Drug-Free)', '/templates/cert10-certifications-map.pdf', 'checklist', 4
FROM lessons WHERE slug = 'cert10-certifications-debarment-coi'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Conflict of Interest Addendum Template', '/templates/cert10-coi-addendum.docx', 'template', 5
FROM lessons WHERE slug = 'cert10-certifications-debarment-coi'
ON CONFLICT DO NOTHING;

-- ============================================================
-- CERT 11: RLF Accounting & Audit Readiness
-- ============================================================
INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'RLF Chart of Accounts Template', '/templates/cert11-chart-of-accounts.xlsx', 'template', 1
FROM lessons WHERE slug = 'cert11-rlf-fund-accounting'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'RMRF/LLRF Control Worksheet', '/templates/cert11-rmrf-llrf-control-worksheet.xlsx', 'template', 2
FROM lessons WHERE slug = 'cert11-rmrf-llrf-controls'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'LLRF Reserve Calculation Tool', '/templates/cert11-llrf-reserve-calculator.xlsx', 'template', 3
FROM lessons WHERE slug = 'cert11-rmrf-llrf-controls'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'USDA Reporting Calendar Template', '/templates/cert11-reporting-calendar.xlsx', 'template', 4
FROM lessons WHERE slug = 'cert11-usda-reporting-calendar'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Loan File Audit Checklist', '/templates/cert11-loan-file-audit-checklist.pdf', 'checklist', 5
FROM lessons WHERE slug = 'cert11-audit-ready-portfolio-metrics'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'RLF Portfolio Dashboard Template', '/templates/cert11-portfolio-dashboard.xlsx', 'template', 6
FROM lessons WHERE slug = 'cert11-audit-ready-portfolio-metrics'
ON CONFLICT DO NOTHING;

-- ============================================================
-- CERT 12: Application Assembly & AI Scoring
-- ============================================================
INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Application Assembly SOP', '/templates/cert12-assembly-sop.pdf', 'template', 1
FROM lessons WHERE slug = 'cert12-reviewer-centered-assembly'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Evidence Crosswalk Workbook', '/templates/cert12-evidence-crosswalk-workbook.xlsx', 'template', 2
FROM lessons WHERE slug = 'cert12-evidence-crosswalk'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Narrative Strengthening Checklist', '/templates/cert12-narrative-checklist.pdf', 'checklist', 3
FROM lessons WHERE slug = 'cert12-narrative-strengthening'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, '30-Day Correction Plan Template', '/templates/cert12-30-day-correction-plan.xlsx', 'template', 4
FROM lessons WHERE slug = 'cert12-ai-scoring-correction-plan'
ON CONFLICT DO NOTHING;

-- ============================================================
-- CERT 13: Community Outreach, Partnerships & Impact
-- ============================================================
INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Partner Ecosystem Map Template', '/templates/cert13-partner-ecosystem-map.xlsx', 'template', 1
FROM lessons WHERE slug = 'cert13-partner-ecosystem'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'MOU Template (Microlender–Partner)', '/templates/cert13-mou-template.docx', 'template', 2
FROM lessons WHERE slug = 'cert13-partner-ecosystem'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Letter of Support Draft Template', '/templates/cert13-letter-of-support-template.docx', 'template', 3
FROM lessons WHERE slug = 'cert13-letters-strategy'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Letter of Commitment Draft Template', '/templates/cert13-letter-of-commitment-template.docx', 'template', 4
FROM lessons WHERE slug = 'cert13-letters-strategy'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Impact Metrics Dashboard Template', '/templates/cert13-impact-dashboard.xlsx', 'template', 5
FROM lessons WHERE slug = 'cert13-impact-metrics'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, '90-Day Outreach Plan Template', '/templates/cert13-90-day-outreach-plan.xlsx', 'template', 6
FROM lessons WHERE slug = 'cert13-community-outreach'
ON CONFLICT DO NOTHING;

-- ============================================================
-- CERT 14: Sales Funnel & Enrollment
-- ============================================================
INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Offer One-Sheet Template', '/templates/cert14-offer-one-sheet.docx', 'template', 1
FROM lessons WHERE slug = 'cert14-premium-offer-design'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Sales Funnel Wireframe', '/templates/cert14-sales-funnel-wireframe.pdf', 'template', 2
FROM lessons WHERE slug = 'cert14-sales-funnel-architecture'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Email Sequence Templates (7-Part)', '/templates/cert14-email-sequence-templates.docx', 'template', 3
FROM lessons WHERE slug = 'cert14-sales-funnel-architecture'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Enrollment Automation Map', '/templates/cert14-enrollment-automation-map.pdf', 'template', 4
FROM lessons WHERE slug = 'cert14-payment-enrollment-automation'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Student Onboarding SOP', '/templates/cert14-student-onboarding-sop.docx', 'template', 5
FROM lessons WHERE slug = 'cert14-student-onboarding-activation'
ON CONFLICT DO NOTHING;

-- ============================================================
-- CERT 15: Content Engine, Social Media & Ads
-- ============================================================
INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, '90-Day Content Calendar Template', '/templates/cert15-90-day-content-calendar.xlsx', 'template', 1
FROM lessons WHERE slug = 'cert15-content-strategy-rural-finance'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Weekly Content Batch Template (10 Posts)', '/templates/cert15-weekly-content-batch.docx', 'template', 2
FROM lessons WHERE slug = 'cert15-social-media-automation'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Social Scheduler SOP', '/templates/cert15-scheduler-sop.pdf', 'template', 3
FROM lessons WHERE slug = 'cert15-social-media-automation'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Ad Campaign Plan + UTM Sheet', '/templates/cert15-ad-campaign-plan.xlsx', 'template', 4
FROM lessons WHERE slug = 'cert15-paid-advertising-fundamentals'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Marketing KPI Dashboard Template', '/templates/cert15-marketing-kpi-dashboard.xlsx', 'template', 5
FROM lessons WHERE slug = 'cert15-email-sequences-audience-building'
ON CONFLICT DO NOTHING;

-- ============================================================
-- CERT 16: CRM, Customer Success & Operations
-- ============================================================
INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'CRM Pipeline Schema Template', '/templates/cert16-crm-pipeline-schema.xlsx', 'template', 1
FROM lessons WHERE slug = 'cert16-crm-setup-automation'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Application Review SOP', '/templates/cert16-application-review-sop.docx', 'template', 2
FROM lessons WHERE slug = 'cert16-application-management'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Student Success Playbook Template', '/templates/cert16-student-success-playbook.docx', 'template', 3
FROM lessons WHERE slug = 'cert16-customer-success'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Operations Scoreboard Template', '/templates/cert16-ops-scoreboard.xlsx', 'template', 4
FROM lessons WHERE slug = 'cert16-financial-systems-sops-scaling'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'SOP Library Template (7 Core SOPs)', '/templates/cert16-sop-library.docx', 'template', 5
FROM lessons WHERE slug = 'cert16-financial-systems-sops-scaling'
ON CONFLICT DO NOTHING;

-- ============================================================
-- CERT 17: Master Capstone
-- ============================================================
INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Master Capstone Portfolio Checklist', '/templates/cert17-capstone-portfolio-checklist.pdf', 'checklist', 1
FROM lessons WHERE slug = 'cert17-usda-application-capstone'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Pre-Submission Application Checklist (16-Point)', '/templates/cert17-pre-submission-checklist.pdf', 'checklist', 2
FROM lessons WHERE slug = 'cert17-usda-application-capstone'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Business Architecture 7-Layer Template', '/templates/cert17-business-architecture-template.docx', 'template', 3
FROM lessons WHERE slug = 'cert17-certification-business-capstone'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, 'Case Review Submission Cover Memo Template', '/templates/cert17-case-review-cover-memo.docx', 'template', 4
FROM lessons WHERE slug = 'cert17-case-review-preparation'
ON CONFLICT DO NOTHING;

INSERT INTO lesson_resources (lesson_id, title, url, resource_type, sort_order)
SELECT id, '90-Day Launch Plan Template', '/templates/cert17-90-day-launch-plan.xlsx', 'template', 5
FROM lessons WHERE slug = 'cert17-integration-launch-plan'
ON CONFLICT DO NOTHING;
