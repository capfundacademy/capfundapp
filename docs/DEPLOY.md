# Cap Fund Academy — Deployment Guide

## Fresh Deployment (New Instance)

### Step 1 — GitHub
```bash
git clone https://github.com/capfundacademy/capfundapp.git
cd capfundapp
```

### Step 2 — Supabase
1. Create new project at supabase.com
2. Copy **Project URL** and **anon key** from Settings → API
3. Copy **service_role key** from Settings → API (keep secret)
4. Update `index.html` window.ENV block with URL and anon key
5. Run SQL files 01–14 in order via SQL Editor (see SETUP-COMPLETE.md)
6. Create `evidence` storage bucket (private, 25MB)
7. Enable Email auth in Authentication → Providers
8. Create admin user: `support@capfundacademy.com`

### Step 3 — Netlify
1. New site → import from GitHub → select `capfundacademy/capfundapp`
2. Build settings: publish directory = `.`, no build command
3. Add environment variables (see ENVIRONMENT-VARIABLES.md)
4. Deploy

### Step 4 — Stripe
1. Create Stripe account
2. Add webhook: `https://your-site.netlify.app/.netlify/functions/stripe-webhook`
3. Events: `checkout.session.completed`, `payment_intent.payment_failed`, `charge.refunded`, `customer.subscription.*`
4. Add `STRIPE_SECRET_KEY` and `STRIPE_WEBHOOK_SECRET` to Netlify

### Step 5 — Resend
1. Create account at resend.com
2. Add domain → add DNS records → verify
3. Create API key → add `RESEND_API_KEY` to Netlify

### Step 6 — OpenAI
1. Get API key from platform.openai.com
2. Add `OPENAI_API_KEY` to Netlify

### Step 7 — Custom Domain
1. Netlify → Domain Management → Add custom domain → `capfundacademy.com`
2. Update DNS at registrar to point to Netlify nameservers
3. HTTPS provisions automatically

### Step 8 — Go Live
1. Swap Stripe test keys (`sk_test_`) for live keys (`sk_live_`)
2. Update `STRIPE_WEBHOOK_SECRET` with live webhook secret
3. Run smoke tests from SETUP-COMPLETE.md
4. Trigger Netlify deploy

---

## Updating the Site

```bash
# Make changes to index.html or SQL files
git add -A
git commit -m "Description of change"
git push
# Netlify auto-deploys on push
```

SQL changes: run new SQL files in Supabase SQL Editor after pushing code.

---

## Switching Email Providers

Change `EMAIL_PROVIDER` env var in Netlify:
- `resend` (default) — requires `RESEND_API_KEY`
- `brevo` — requires `BREVO_API_KEY`
- `smtp` — requires `SMTP_RELAY_URL` + `SMTP_RELAY_KEY`

No code changes needed.

---

## Upgrading AI Model

In `netlify/functions/ai-scoring.js` and `content-generate.js`:
```javascript
const MODEL = 'gpt-4o';  // upgrade from gpt-4o-mini
```

---

## Rollback

```bash
git revert HEAD
git push
# Or in Netlify dashboard → Deploys → select a prior deploy → Publish deploy
```
