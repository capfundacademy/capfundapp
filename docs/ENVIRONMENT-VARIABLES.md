# Cap Fund Academy — Environment Variables

All variables must be set in **Netlify → Site Settings → Environment Variables** unless otherwise noted.  
Variables marked `index.html` must also be updated in the `window.ENV` block in `index.html`.

---

## Required — App will not function without these

| Variable | Where | Source | Example |
|---|---|---|---|
| `SUPABASE_URL` | Netlify + `index.html` | Supabase → Settings → API → Project URL | `https://xxxx.supabase.co` |
| `SUPABASE_ANON_KEY` | Netlify + `index.html` | Supabase → Settings → API → anon/public key | `eyJhbGci...` |
| `SUPABASE_SERVICE_ROLE_KEY` | Netlify only | Supabase → Settings → API → service_role key | `eyJhbGci...` |

**Update `index.html` window.ENV block:**
```html
<script>
window.ENV = {
  SUPABASE_URL: 'https://your-project.supabase.co',
  SUPABASE_ANON_KEY: 'your-anon-key-here'
};
</script>
```

---

## Payments — Required for Stripe checkout

| Variable | Where | Source |
|---|---|---|
| `STRIPE_SECRET_KEY` | Netlify | Stripe Dashboard → Developers → API Keys → Secret key (`sk_test_...` for test, `sk_live_...` for production) |
| `STRIPE_WEBHOOK_SECRET` | Netlify | Stripe → Webhooks → Add endpoint → `https://capfundacademy.com/.netlify/functions/stripe-webhook` → Signing secret (`whsec_...`) |

> **Test mode:** Use `sk_test_` and `pk_test_` keys during development. Switch to live keys before launch — this is a config-only change.

---

## Email — Required for all automated emails

| Variable | Where | Source |
|---|---|---|
| `RESEND_API_KEY` | Netlify | resend.com → API Keys → Create API Key (domain `globalinvestmentcompanies.com` must be verified) |
| `EMAIL_PROVIDER` | Netlify | `resend` (default) \| `brevo` \| `smtp` |

**Alternative providers:**
- Brevo: set `EMAIL_PROVIDER=brevo` + `BREVO_API_KEY`
- SMTP relay: set `EMAIL_PROVIDER=smtp` + `SMTP_RELAY_URL` + `SMTP_RELAY_KEY`

---

## AI — Required for scoring engine and content generation

| Variable | Where | Source |
|---|---|---|
| `OPENAI_API_KEY` | Netlify | platform.openai.com → API Keys → Create new secret key |

> The platform uses `gpt-4o-mini` by default (cost-efficient). Upgrade to `gpt-4o` for premium scoring by changing the `MODEL` constant in `ai-scoring.js`.

---

## Site — Required for correct email links and redirects

| Variable | Where | Value |
|---|---|---|
| `URL` | Netlify | `https://capfundacademy.com` (set automatically by Netlify for production, but set explicitly for safety) |

---

## Optional — Advanced configuration

| Variable | Default | Purpose |
|---|---|---|
| `STRIPE_PUBLISHABLE_KEY` | — | Stripe publishable key (for future client-side Stripe Elements) |
| `SMTP_RELAY_URL` | — | SMTP relay endpoint URL (if `EMAIL_PROVIDER=smtp`) |
| `SMTP_RELAY_KEY` | — | SMTP relay auth key |
| `BREVO_API_KEY` | — | Brevo transactional email API key (if `EMAIL_PROVIDER=brevo`) |

---

## Supabase Storage Setup

After setting env vars, create the `evidence` storage bucket in Supabase:

1. Supabase Dashboard → Storage → New bucket
2. Name: `evidence`
3. Public: **No** (private bucket)
4. File size limit: 25 MB
5. Allowed MIME types: `application/pdf, application/msword, application/vnd.openxmlformats-officedocument.*, image/*, text/plain, text/csv`

---

## First Admin User

Create `support@capfundacademy.com` in Supabase → Authentication → Users → Add user.  
The auth trigger in `01_base_schema.sql` auto-promotes this email to `super_admin`.
