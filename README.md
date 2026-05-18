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
| 1 | Complete | Foundation: landing page, trust center, auth, base schema, lead capture |
| 2 | Planned | Course player, content management, email automation, admin dashboard |
| 3 | Planned | Stripe payments, certificate generation, affiliate tracking |
| 4 | Planned | AI RMAP Scoring Engine, organization dashboard, reporting |
| 5 | Planned | API, white-label, public directory of certified professionals |

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
