# Cap Fund Academy

**Rural Capital Access Certification Platform**
capfundacademy.com | support@capfundacademy.com

Cap Fund Academy is an independent training and certification platform delivering 17 stackable certifications in microfinance, revolving loan funds, USDA RMAP, RBDG, IRP, underwriting, compliance, and automated business operations.

---

## Quick Start

### Prerequisites
- Supabase project with SQL schema applied (see `sql/`)
- Netlify account

### Local development
No build step needed. Open `index.html` directly in a browser, or:

```bash
# Optional: serve locally
npx serve .
# or
python3 -m http.server 8080
```

### Configure environment
Edit the `window.ENV` block near the top of `index.html`:
```js
window.ENV = {
  SUPABASE_URL: 'https://YOUR_PROJECT.supabase.co',
  SUPABASE_ANON_KEY: 'YOUR_ANON_KEY'
};
```

### Apply database schema
Run SQL files in order in your Supabase SQL editor:
1. `sql/01_base_schema.sql`
2. `sql/02_settings_schema.sql`

### Deploy to Netlify
Connect this repo to Netlify. Build settings:
- Build command: (leave empty)
- Publish directory: `.`

---

## Phase Status

| Phase | Status | Description |
|---|---|---|
| 1 | ✅ Complete | Foundation: landing page, trust center, auth, base schema, lead capture |
| 2 | ✅ Complete | LMS: 17 certifications, lesson player, quiz engine, progress tracking, certificates, admin dashboard, content review workflow |
| 3 | ✅ Complete | Stripe checkout, certificate generation (print/PDF), organization seat management, org dashboard |
| 4 | ✅ Complete | AI RMAP/RBDG/IRP scoring engine, AI study coach (DWY), application workspace, autopilot dashboard |
| 5 | ✅ Complete | CRM, email nurture, content engine, social media automation, sales funnel (quiz, checklist, VSL, pricing), master credential tracker |
| 6 | ✅ Complete | 87 downloadable template files (checklists, SOPs, worksheets) for all 17 certifications; lesson_resources integration; required artifact tracking |
| 7 | Planned | Public blog/resource center, affiliate tracking UI, public directory of certified professionals |

### SQL Run Order (Supabase)
```
01_base_schema.sql
02_settings_schema.sql
03_lms_schema.sql
04_cert_seeds.sql
05_cert01_content.sql
06_application_schema.sql
07_rmap_rubric_seed.sql
08_rbdg_irp_rubric_seed.sql
09_commerce_schema.sql
10_funnel_schema.sql
11_crm_schema.sql
12_content_schema.sql
13_autopilot_schema.sql
14_security_hardening.sql
15_cert02_05_content.sql
16_cert06_09_content.sql
17_cert10_13_content.sql   ← includes only Cert 10; Certs 11-13 in file 19
18_cert14_17_content.sql
19_cert11_13_content.sql
19_coach_access.sql
20_artifact_schema.sql
21_lesson_resources.sql
fix_user_creation.sql
```

---

## File Structure

```
capfundacademy-lms/
├── index.html              # Full single-page app
├── netlify.toml            # Netlify config
├── package.json
├── .gitignore
├── assets/
│   └── logo.svg
├── sql/
│   ├── 01_base_schema.sql
│   └── 02_settings_schema.sql
├── netlify/
│   └── functions/          # Serverless functions (Phase 2+)
└── docs/
    ├── ARCHITECTURE.md
    ├── BRAND-GUIDE.md
    ├── TRUST-CENTER-COPY.md
    └── DEPLOYMENT.md
```

---

## Disclaimer

Cap Fund Academy is an independent training and certification platform. It is not affiliated with, endorsed by, or certified by USDA or any government agency. Training is designed to help organizations understand and prepare for microlending, revolving loan funds, rural capital access programs, RMAP, RBDG, IRP, and related community finance best practices. Cap Fund Academy does not guarantee funding, eligibility, approval, or award decisions.

---

© 2026 Cap Fund Academy. All rights reserved. Life House Reentry.
