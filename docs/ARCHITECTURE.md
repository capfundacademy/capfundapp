# Cap Fund Academy — Architecture

## Stack

| Layer | Technology |
|---|---|
| Frontend | Single-file React 18 + Babel Standalone + Tailwind CDN |
| Auth | Supabase Auth (email/password) |
| Database | Supabase (PostgreSQL) with RLS |
| Storage | Supabase Storage (Phase 2) |
| Functions | Netlify Functions (Node 18+) |
| Payments | Stripe (Phase 3) |
| Email | Resend (Phase 2) |
| AI Scoring | OpenAI GPT-4o (Phase 2) |
| Hosting | Netlify |

## File Structure

```
capfundacademy-lms/
├── index.html                  # Single-page React app (all views)
├── netlify.toml                # Build config, redirects, headers
├── package.json                # Dependency manifest
├── .gitignore
├── assets/
│   └── logo.svg                # Branded SVG wordmark
├── sql/
│   ├── 01_base_schema.sql      # Core tables + RLS (idempotent)
│   └── 02_settings_schema.sql  # Admin settings + seed data (idempotent)
├── netlify/
│   └── functions/              # Serverless functions (Phase 2+)
│       └── .gitkeep
└── docs/
    ├── ARCHITECTURE.md         # This file
    ├── BRAND-GUIDE.md
    ├── TRUST-CENTER-COPY.md
    └── DEPLOYMENT.md
```

## Key Architectural Decisions

### Single-file React pattern
All UI lives in `index.html`. React 18 + Babel Standalone compiled in-browser. No build step required. Tailwind via CDN. This matches the GIC LMS pattern and enables instant Netlify deploy without CI configuration.

### Supabase via esm.sh
```html
<script type="module" data-presets="react">
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.58.0';
```
`data-presets="react"` only — NOT `"env,react"` (breaks ESM imports).

### Environment config via window.ENV
Secrets are injected via a `<script>` block at top of body:
```js
window.ENV = {
  SUPABASE_URL: '...',
  SUPABASE_ANON_KEY: '...'
};
```
Replace these before production deploy (or use Netlify environment injection via a serverless function).

### RLS recursion prevention
`get_my_role()` is a `SECURITY DEFINER` function that reads from `profiles` bypassing RLS. All role-checking policies call this function rather than querying `profiles` directly, which would cause infinite recursion.

### Auth trigger auto-promotes super admin
The `handle_new_user()` trigger promotes `support@capfundacademy.com` to `super_admin` automatically on first login/signup.

## Phase Plan

| Phase | Scope |
|---|---|
| 1 (current) | Foundation: landing page, trust center, auth, base schema, lead capture |
| 2 | Course player, content management, email automation, admin dashboard |
| 3 | Stripe payments, certificate generation, affiliate tracking |
| 4 | AI RMAP Scoring Engine, organization dashboard, reporting |
| 5 | API, white-label, public directory of certified professionals |
