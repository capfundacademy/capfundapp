# Cap Fund Academy — Deployment Guide

> Status: Phase 1 placeholder. Filled in across phases.

## Services to Provision Before Phase 2

### 1. Supabase Project
- Create project at supabase.com
- Region: US East (closest to rural program partners)
- Run SQL files in order:
  1. `sql/01_base_schema.sql`
  2. `sql/02_settings_schema.sql`
- Enable Email auth provider (Settings > Auth > Providers)
- Set Site URL to your Netlify domain
- Add redirect URLs: `https://capfundacademy.com/**`, `https://*.netlify.app/**`
- Collect: Project URL, anon key, service_role key

### 2. Netlify Site
- Connect GitHub repo to Netlify
- Set build command: (none — static file)
- Set publish directory: `.`
- Configure environment variables (see below)
- Enable Netlify Functions (auto-detected from `netlify/functions/`)

### 3. Stripe Account (Phase 3)
- Create products for each pricing tier
- Enable customer portal
- Collect: publishable key, secret key, webhook signing secret

### 4. Resend Account (Phase 2)
- Verify domain: capfundacademy.com
- Create API key
- Set up welcome email and lead magnet delivery templates

### 5. OpenAI API (Phase 4 — AI Scoring Engine)
- Create API key with GPT-4o access
- Set spending limits appropriate to usage

---

## Environment Variables

All variables set in Netlify UI under Site Settings > Environment Variables.

| Variable | Description | Required By |
|---|---|---|
| `SUPABASE_URL` | Supabase project URL | Phase 1 |
| `SUPABASE_ANON_KEY` | Supabase public anon key | Phase 1 |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase service role key (functions only) | Phase 2 |
| `STRIPE_PUBLISHABLE_KEY` | Stripe front-end key | Phase 3 |
| `STRIPE_SECRET_KEY` | Stripe server-side key (functions) | Phase 3 |
| `STRIPE_WEBHOOK_SECRET` | Stripe webhook signing secret | Phase 3 |
| `RESEND_API_KEY` | Resend email API key | Phase 2 |
| `OPENAI_API_KEY` | OpenAI API key for AI scoring | Phase 4 |

### Frontend (window.ENV) — index.html
Update the `window.ENV` block in `index.html` before deploy:
```js
window.ENV = {
  SUPABASE_URL: 'https://YOUR_PROJECT.supabase.co',
  SUPABASE_ANON_KEY: 'YOUR_ANON_KEY'
};
```

Only SUPABASE_URL and SUPABASE_ANON_KEY are safe to expose in client-side code.
All other keys must only be used in Netlify Functions (server-side).

---

## SQL Run Order

Run against your Supabase project using the SQL Editor (dashboard) or psql:

```bash
# Via psql
psql "$DATABASE_URL" -f sql/01_base_schema.sql
psql "$DATABASE_URL" -f sql/02_settings_schema.sql
```

Both files are idempotent — safe to re-run.

---

## Custom Domain

1. Add `capfundacademy.com` in Netlify Site Settings > Domain Management
2. Update DNS at registrar to point to Netlify nameservers
3. Netlify provisions TLS automatically via Let's Encrypt
4. Update Supabase redirect URLs to include the custom domain

---

## Phase 2 Additions

- Netlify Functions for: lead delivery email, webhook handlers
- Supabase Storage bucket for: course assets, certificate PDFs
- Additional SQL migrations in `sql/03_courses_schema.sql` etc.
