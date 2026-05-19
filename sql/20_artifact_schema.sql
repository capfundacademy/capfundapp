-- ============================================================
-- Cap Fund Academy — Artifact Schema + Required Artifact Seeds
-- File: 20_artifact_schema.sql
-- Idempotent: safe to re-run
-- Run after: 04_cert_seeds.sql
-- ============================================================

-- Add required_artifact columns to certifications
ALTER TABLE certifications
  ADD COLUMN IF NOT EXISTS required_artifact_title       text,
  ADD COLUMN IF NOT EXISTS required_artifact_description text;

-- Seed required artifact titles and descriptions for all 17 certs
UPDATE certifications SET
  required_artifact_title       = 'Borrower-Centered Microfinance Readiness Toolkit',
  required_artifact_description = 'A complete toolkit demonstrating your understanding of borrower-centered lending principles. Includes a borrower persona map, client protection checklist, borrower readiness scorecard, and a 30-day microenterprise TA session plan. Submitted as a single organized document or folder.'
WHERE cert_number = 1;

UPDATE certifications SET
  required_artifact_title       = 'Complete RLF Design and Capitalization Plan',
  required_artifact_description = 'A comprehensive revolving loan fund design document covering fund purpose, target market, eligible borrowers, loan products (size, rate, term, collateral), capitalization strategy, governance structure, and a 3-year RLF pro forma. Must include a loan committee charter and conflict-of-interest policy.'
WHERE cert_number = 2;

UPDATE certifications SET
  required_artifact_title       = 'RMAP Application Readiness Binder',
  required_artifact_description = 'A complete USDA RMAP application readiness binder including: eligibility checklist, binder index, 45-point evidence matrix mapped to scoring criteria, pathway selection rationale (experienced/less-experienced/TA-only), scoring workbook with self-assessed point values, and quarterly submission calendar.'
WHERE cert_number = 3;

UPDATE certifications SET
  required_artifact_title       = 'RMAP Microlender Operations Manual',
  required_artifact_description = 'An operations manual covering the post-selection RMAP lifecycle: letter of conditions checklist, OGC closing timeline, RMRF/LLRF account plan and SOPs, microlender duty checklist, microloan file checklist, and an ineligible use screening tool.'
WHERE cert_number = 4;

UPDATE certifications SET
  required_artifact_title       = 'RMAP Technical Assistance Program Plan',
  required_artifact_description = 'A complete TA&T program plan including: TA service catalog, TA log template, evaluation form, success story template, TA-to-loan tracker, budget and reporting pack aligned to USDA quarterly narrative requirements.'
WHERE cert_number = 5;

UPDATE certifications SET
  required_artifact_title       = 'RBDG RLF/Business Support Application Draft',
  required_artifact_description = 'A draft USDA RBDG application for an RLF or business support center project. Includes eligibility checklist, project narrative outline, RBDG scoring workbook with self-scored points, project budget and leverage documentation, and a post-award compliance plan.'
WHERE cert_number = 6;

UPDATE certifications SET
  required_artifact_title       = 'Federal Capital Stack Strategy Plan',
  required_artifact_description = 'A phased capital stack strategy document covering: capital options matrix comparing RBDG, RMAP, IRP, EDA, CDFI Fund, CRA, and philanthropic sources; a 3-phase funding roadmap; staff capacity stress test; and a blended-fund controls checklist.'
WHERE cert_number = 7;

UPDATE certifications SET
  required_artifact_title       = 'Microloan Credit Policy and Underwriting Manual',
  required_artifact_description = 'A complete written microloan credit policy including: credit policy outline with all required sections, underwriting memo template, collateral checklist, loan committee decision memo template, and a portfolio risk metrics dictionary.'
WHERE cert_number = 8;

UPDATE certifications SET
  required_artifact_title       = 'Loan Servicing and Workout Manual',
  required_artifact_description = 'A comprehensive loan servicing and workout manual covering: servicing SOP and calendar, delinquency prevention checklist, collection contact cadence, workout memo template, and charge-off SOP with USDA reporting requirements.'
WHERE cert_number = 9;

UPDATE certifications SET
  required_artifact_title       = 'Federal Compliance and Monitoring Binder',
  required_artifact_description = 'A federal compliance binder demonstrating readiness for a USDA site visit. Includes: civil rights compliance checklist (ECOA, Title VI, ADA, Section 504), environmental screening worksheet, 2 CFR 200 cost checklist, compliance certifications map (SAM/UEI, debarment, lobbying, drug-free workplace), and a conflict-of-interest addendum template.'
WHERE cert_number = 10;

UPDATE certifications SET
  required_artifact_title       = 'RLF Accounting and Audit Readiness System',
  required_artifact_description = 'A complete RLF accounting and audit readiness system including: chart of accounts mapping for restricted RLF funds, RMRF/LLRF control worksheet and reserve calculation, reporting calendar and tracker, audit file checklist, and a portfolio dashboard specification with all required metrics.'
WHERE cert_number = 11;

UPDATE certifications SET
  required_artifact_title       = 'Scored Application Binder and Improvement Plan',
  required_artifact_description = 'A complete scored application binder with: assembly SOP, evidence crosswalk workbook mapping each claim to a scoring criterion and exhibit, narrative checklist, AI scoring lab report, and a 30-day correction plan with specific owners and deadlines for each gap identified.'
WHERE cert_number = 12;

UPDATE certifications SET
  required_artifact_title       = 'Partnership and Impact Documentation Packet',
  required_artifact_description = 'A comprehensive partnership and impact documentation packet including: partner outreach list with contact information and relationship type, letter of support/commitment packet with signed examples, impact dashboard specification, and a 90-day community outreach plan.'
WHERE cert_number = 13;

UPDATE certifications SET
  required_artifact_title       = 'Complete Certification Sales Funnel Kit',
  required_artifact_description = 'A complete sales funnel kit for a certification business: offer one-sheet with tiers and guarantees, lead magnet + quiz map, sales page wireframe and copy framework, email sequence templates (welcome, nurture, sales, abandoned checkout, onboarding), and an enrollment automation map.'
WHERE cert_number = 14;

UPDATE certifications SET
  required_artifact_title       = 'Autonomous Content and Ad Operations System',
  required_artifact_description = 'A complete content and advertising operations system: 90-day content calendar by pillar, weekly content batch (10+ pieces), scheduler SOP for approval-based publishing, paid ad campaign plan with targeting and budget, and a marketing KPI dashboard spec.'
WHERE cert_number = 15;

UPDATE certifications SET
  required_artifact_title       = 'Automated Enrollment and Student Success Operating System',
  required_artifact_description = 'A complete enrollment and student success operating system: CRM pipeline schema with all stages and automation rules, application review SOP, student onboarding sequence and activation checklist, support ticket triage SOP, and an operations scoreboard with all KPIs defined.'
WHERE cert_number = 16;

UPDATE certifications SET
  required_artifact_title       = 'Master Launch Portfolio',
  required_artifact_description = 'The culminating portfolio demonstrating mastery of all 16 prior certifications. Must include: complete RLF program design, USDA application readiness binder (RMAP or RBDG pathway), compliance and finance documentation, TA and impact system, sales funnel, marketing automation system, and operations documentation. Submitted as a single organized portfolio with a cover memo and reviewer scorecard.'
WHERE cert_number = 17;
