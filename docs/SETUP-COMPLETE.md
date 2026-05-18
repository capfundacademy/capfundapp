# Cap Fund Academy — Master Setup Guide

**Platform:** Cap Fund Academy  
**Domain:** capfundacademy.com  
**Support:** support@capfundacademy.com  
**Owner:** Julius Jackson / Life House Reentry  
**Stack:** React 18 + Supabase + Netlify + Stripe + OpenAI + Resend

---

## Architecture Overview

```
Browser (React 18 SPA)
    ↓ reads from
Supabase (Postgres + Auth + RLS + Realtime + Storage)
    ↓ server-side calls via
Netlify Functions (Node.js serverless)
    ↓ integrates with
OpenAI · Stripe · Resend
```

Single-file React app (`index.html`) — no build step, no npm install needed for the frontend. All secrets live in Netlify Functions — never in the browser.

---

## Phase Completion Status

| Phase | What was built | SQL files | Status |
|---|---|---|---|
| 1 | Foundation, landing page, trust center, auth | 01, 02 | ✅ |
| 2 | LMS core — 17 certs, lessons, quiz, certificates | 03, 04, 05 | ✅ |
| 3 | AI Scoring Engine — RMAP/RBDG/IRP rubrics | 06, 07, 08 | ✅ |
| 4 | Stripe checkout, commerce, org licenses | 09 | ✅ |
| 5 | Lead funnels, quiz, checklist, VSL | 10 | ✅ |
| 6 | CRM, email automation, sequences | 11 | ✅ |
| 7 | Content Engine, compliance checker | 12 | ✅ |
| 8 | Autopilot Dashboard, scheduled functions | 13 | ✅ |
| 9 | Security hardening, RLS audit, docs | 14 | ✅ |

---

## SQL Execution Order

Run these files in Supabase SQL Editor **in order**. All files are idempotent — safe to re-run.

```
01_base_schema.sql          — profiles, orgs, leads, auth trigger
02_settings_schema.sql      — admin_settings with defaults
03_lms_schema.sql           — certifications, modules, lessons, quizzes
04_cert_seeds.sql           — 17 cert shells + 5 master credentials
05_cert01_content.sql       — full Cert 1 lessons + 20-question quiz
06_application_schema.sql   — workspaces, scoring runs, evidence files
07_rmap_rubric_seed.sql     — RMAP 7 CFR 4280.316 criteria verbatim
08_rbdg_irp_rubric_seed.sql — RBDG, IRP, rlf_ops, full_binder rubrics
09_commerce_schema.sql      — offers, orders, enrollments, org seats
10_funnel_schema.sql        — quiz questions, quiz responses, funnel pages
11_crm_schema.sql           — funnel stages, CRM events/tasks, email templates
12_content_schema.sql       — brand voice, forbidden claims, social posts
13_autopilot_schema.sql     — autopilot runs, exceptions, alert rules
14_security_hardening.sql   — RLS audit, retention settings, cleanup functions
```

---

## Netlify Functions Deployed

| Function | Trigger | Purpose |
|---|---|---|
| `ai-scoring.js` | HTTP POST | RMAP/RBDG/IRP AI readiness scoring |
| `content-generate.js` | HTTP POST | AI social/blog/ad content generation |
| `email-send.js` | HTTP POST | Transactional email (Resend/Brevo/SMTP) |
| `enroll-student.js` | HTTP POST | Manual admin enrollment |
| `lead-capture.js` | HTTP POST | Public lead form handler |
| `sign-upload.js` | HTTP POST | Supabase Storage presigned upload URL |
| `sign-read.js` | HTTP POST | Supabase Storage presigned read URL |
| `stripe-checkout.js` | HTTP POST | Create Stripe Checkout Session |
| `stripe-webhook.js` | HTTP POST | Stripe payment/subscription webhooks |
| `abandoned-checkout.js` | Scheduled (*/2hr) | Recovery emails for pending orders |
| `daily-nurture.js` | Scheduled (9am UTC) | Lead nurture + inactivity reengagement |
| `weekly-digest.js` | Scheduled (Mon 8am UTC) | Admin KPI summary email |
| `renewal-reminder.js` | Scheduled (10am UTC) | Subscription renewal reminders |
| `exception-detect.js` | Scheduled (hourly) | Exception detection + admin alerts |

---

## Environment Variables

See `docs/ENVIRONMENT-VARIABLES.md` for the complete list with sources.

**Critical path (must be set for basic function):**
1. `SUPABASE_URL` + `SUPABASE_ANON_KEY` → update `window.ENV` in `index.html`
2. `SUPABASE_SERVICE_ROLE_KEY` → Netlify env vars
3. `RESEND_API_KEY` → Netlify env vars
4. `OPENAI_API_KEY` → Netlify env vars
5. `STRIPE_SECRET_KEY` + `STRIPE_WEBHOOK_SECRET` → Netlify env vars
6. `URL` = `https://capfundacademy.com` → Netlify env vars

---

## Supabase Setup Checklist

- [ ] Create Supabase project
- [ ] Run SQL files 01–14 in order
- [ ] Create `evidence` storage bucket (private, 25MB limit)
- [ ] Enable email auth in Authentication → Providers → Email
- [ ] Add site URL to Authentication → URL Configuration → Site URL
- [ ] Add redirect URL: `https://capfundacademy.com`
- [ ] Create admin user: `support@capfundacademy.com` in Authentication → Users

---

## Stripe Setup Checklist

- [ ] Create Stripe account at stripe.com
- [ ] Copy test keys to Netlify env vars
- [ ] Create webhook endpoint: `https://capfundacademy.com/.netlify/functions/stripe-webhook`
- [ ] Select events: `checkout.session.completed`, `payment_intent.payment_failed`, `charge.refunded`, `customer.subscription.updated`, `customer.subscription.deleted`
- [ ] Copy webhook signing secret (`whsec_...`) to `STRIPE_WEBHOOK_SECRET`
- [ ] Before launch: replace test keys with live keys

---

## Resend Email Setup Checklist

- [ ] Create Resend account at resend.com
- [ ] Add domain: `capfundacademy.com` → add DNS records provided
- [ ] Verify domain (usually within minutes)
- [ ] Create API key → copy to `RESEND_API_KEY`
- [ ] Test: send a test email from the Resend dashboard

---

## Smoke Test Checklist (run after deploy)

### Public site
- [ ] Homepage loads at capfundacademy.com with correct logo + favicon
- [ ] Footer shows white logo and USDA non-affiliation disclaimer
- [ ] Trust Center page loads and shows all 6 disclaimer sections
- [ ] Free Quiz: 12 questions render, email capture shows, result appears
- [ ] RMAP Checklist: email gate works, checklist unlocks after submission
- [ ] VSL/Training page loads with lead capture form
- [ ] Pricing page shows 6 offer cards loaded from database

### Authentication
- [ ] Login modal opens
- [ ] `support@capfundacademy.com` logs in → lands on Admin with Autopilot tab
- [ ] Student account logs in → lands on Student Dashboard
- [ ] Sign out works

### LMS
- [ ] Certification catalog loads all 17 certs
- [ ] Cert 1 opens → modules and lessons visible
- [ ] Lesson player renders markdown content correctly
- [ ] "Mark Complete" updates progress
- [ ] Quiz loads 20 questions → score calculates correctly
- [ ] Certificate claims on passing score

### AI Scoring Engine
- [ ] "Score My App" nav link visible when logged in
- [ ] New workspace creates successfully
- [ ] Criteria load for RMAP workspace
- [ ] AI Score button (requires OPENAI_API_KEY) returns structured result
- [ ] Compliance badge shows green ✅ on clean content

### Payments (test mode)
- [ ] Click "Get Started" on any offer → redirects to Stripe Checkout
- [ ] Use Stripe test card `4242 4242 4242 4242` → payment succeeds
- [ ] Webhook fires → order marked paid → enrollment created

### Admin
- [ ] Autopilot Dashboard shows KPIs
- [ ] CRM → All Leads → leads captured from quiz appear
- [ ] Content Engine → generate LinkedIn post → compliance check runs
- [ ] Approve post in queue → status changes to approved
- [ ] Export CSV downloads approved posts

### Email (requires RESEND_API_KEY)
- [ ] Submit quiz → check inbox for quiz result email
- [ ] Download checklist → check inbox for delivery email
- [ ] Weekly digest: trigger `weekly-digest` function manually in Netlify → check inbox

---

## Compliance & Legal Reminders

1. **USDA Non-Affiliation:** The verbatim disclaimer appears in the site footer, Trust Center, every certificate, every AI scoring result, and every email. Do not remove or alter it.

2. **Privacy Policy, Terms of Service, Refund Policy, Accessibility Statement:** Placeholder links exist in the footer and Trust Center. Replace with attorney-reviewed documents before accepting payments.

3. **AI Scoring:** Every scoring result carries: *"AI scoring outputs are estimates based on publicly available USDA scoring criteria. Results are advisory only and do not represent USDA's review or determination."* Never remove this disclaimer.

4. **Content Compliance:** The Content Engine checks all AI-generated content against 18 forbidden phrases before saving. The `forbidden_claims` table is admin-editable — add more phrases as needed.

5. **Data Retention:** Configurable in Admin Settings. Default: leads 730 days, email logs 365 days, scoring runs 365 days. Run `cleanup_old_logs()` via a scheduled function or manual SQL to enforce retention.

---

## Architecture Decisions Log

| Decision | Why |
|---|---|
| Single-file React (no build) | Deploy instantly, no CI/CD complexity, matches GIC LMS pattern |
| Supabase Storage (not DO Spaces) | All data in one platform, simpler billing, easier local dev |
| Resend (not SendGrid) | Modern API, free tier, domain-based sending, easy swap |
| gpt-4o-mini default | Cost-efficient for scoring and content, upgrade path to gpt-4o available |
| RLS everywhere | Defense in depth — even if a function has a bug, database enforces access control |
| Idempotent SQL | Safe to re-run any file without destructive side effects |
| Forbidden claims in DB | Admin can add phrases without code changes; content team can manage compliance |
