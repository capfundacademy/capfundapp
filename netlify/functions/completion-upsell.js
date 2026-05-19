// ============================================================================
// completion-upsell.js — Triggered when a student passes a cert quiz
// Sends a congratulations email + upsell to the next cert or credential bundle
// Called from: stripe-webhook.js (enrollment) or QuizPlayer (on pass)
// Auth: internal calls only — validated via service role
// ============================================================================

const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL         = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const SITE_URL             = process.env.URL || 'https://capfundacademy.com';

const CORS = {
  'Access-Control-Allow-Origin':  '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
};
const ok  = b => ({ statusCode: 200, headers: { ...CORS, 'Content-Type': 'application/json' }, body: JSON.stringify(b) });
const err = (s, m) => ({ statusCode: s, headers: CORS, body: JSON.stringify({ error: m }) });

// Credential bundles — what to pitch after completing X certs
const CREDENTIAL_UPSELLS = [
  {
    after_cert: 4,
    credential: 'Rural Microfinance Associate',
    slug: 'rural-microfinance-associate',
    next_label: 'Revolving Loan Fund Practitioner (Certs 1–9)',
    next_slug: 'rlf-practitioner',
    price: '$2,997',
    savings: 'Save $980 vs. buying individually',
  },
  {
    after_cert: 9,
    credential: 'Revolving Loan Fund Practitioner',
    slug: 'rlf-practitioner',
    next_label: 'USDA Rural Capital Program Specialist (Certs 1–13)',
    next_slug: 'usda-rural-capital-specialist',
    price: '$3,997',
    savings: 'Save $1,474 vs. buying individually',
  },
  {
    after_cert: 13,
    credential: 'USDA Rural Capital Program Specialist',
    slug: 'usda-rural-capital-specialist',
    next_label: 'Certified RLF Executive (Certs 1–15)',
    next_slug: 'certified-rlf-executive',
    price: '$4,997',
    savings: 'Save $1,468 vs. buying individually',
  },
  {
    after_cert: 15,
    credential: 'Certified RLF Executive',
    slug: 'certified-rlf-executive',
    next_label: 'Master Administrator — All 17 Certs',
    next_slug: 'master-administrator',
    price: '$5,997',
    savings: 'Save $1,965 vs. buying individually',
  },
  {
    after_cert: 17,
    credential: 'Master Rural Microfinance & RLF Administrator',
    slug: 'master-administrator',
    next_label: null, // highest tier — pitch org license instead
    price: null,
  },
];

exports.handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') return { statusCode: 204, headers: CORS, body: '' };
  if (event.httpMethod !== 'POST') return err(405, 'Method not allowed');

  let body;
  try { body = JSON.parse(event.body || '{}'); } catch { return err(400, 'Invalid JSON'); }

  const { user_id, cert_number, cert_title, recipient_name, score } = body;
  if (!user_id || !cert_number) return err(400, 'user_id and cert_number required');

  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false },
  });

  // Get user email
  const { data: profile } = await admin.from('profiles').select('email, full_name').eq('id', user_id).single();
  if (!profile?.email) return err(404, 'User profile not found');

  const name      = recipient_name || profile.full_name || 'there';
  const certNum   = Number(cert_number);
  const upsell    = CREDENTIAL_UPSELLS.find(u => u.after_cert === certNum);
  const nextCert  = certNum < 36 ? certNum + 1 : null;

  // ── Build email HTML ──────────────────────────────────────────────────────
  let upsellBlock = '';
  if (upsell?.next_label) {
    upsellBlock = `
      <div style="background:#eff6ff;border:2px solid #2D1FB1;border-radius:12px;padding:24px;margin:24px 0;text-align:center;">
        <div style="font-size:12px;color:#2D1FB1;font-weight:700;text-transform:uppercase;letter-spacing:1px;margin-bottom:8px;">
          🏆 You just earned: ${upsell.credential}
        </div>
        <div style="font-size:18px;font-weight:800;color:#0F1631;margin-bottom:8px;">
          Ready for the next credential?
        </div>
        <div style="font-size:14px;color:#6b7280;margin-bottom:16px;">
          ${upsell.next_label} — ${upsell.price}<br/>
          <span style="color:#16a34a;font-weight:600;">${upsell.savings}</span>
        </div>
        <a href="${SITE_URL}?upgrade=${upsell.next_slug}"
           style="display:inline-block;background:#F97316;color:#fff;font-weight:700;padding:12px 28px;border-radius:10px;text-decoration:none;font-size:14px;">
          Upgrade Now — ${upsell.price} →
        </a>
      </div>`;
  } else if (certNum === 17) {
    upsellBlock = `
      <div style="background:#2D1FB1;border-radius:12px;padding:24px;margin:24px 0;text-align:center;">
        <div style="font-size:18px;font-weight:900;color:#FFD23F;margin-bottom:8px;">🏆 RMAP/RLF Core Track Complete!</div>
        <div style="font-size:14px;color:rgba(255,255,255,0.85);margin-bottom:16px;">
          You've mastered the RMAP/RLF curriculum. Now expand into the full All Things Lender ecosystem —
          SBA, CDFI, EDA, FHA, EPA, tribal lending, infrastructure finance, and more.
        </div>
        <a href="${SITE_URL}"
           style="display:inline-block;background:#F97316;color:#fff;font-weight:700;padding:12px 28px;border-radius:10px;text-decoration:none;font-size:14px;">
          Continue to Cert 18: Government Lending Models →
        </a>
      </div>`;
  } else if (certNum === 36) {
    upsellBlock = `
      <div style="background:#0F1631;border-radius:12px;padding:24px;margin:24px 0;text-align:center;">
        <div style="font-size:20px;font-weight:900;color:#FFD23F;margin-bottom:8px;">🎓 You did it. All 36 Certifications.</div>
        <div style="font-size:14px;color:rgba(255,255,255,0.7);margin-bottom:16px;">
          You are a Master Capital Access Architect. Share your credential with your network — and help your team get certified too.
        </div>
        <a href="${SITE_URL}?offer=org-license-5-seats"
           style="display:inline-block;background:#F97316;color:#fff;font-weight:700;padding:12px 28px;border-radius:10px;text-decoration:none;font-size:14px;margin-right:8px;">
          Get an Organization License ($5,000)
        </a>
      </div>`;
  } else if (nextCert) {
    upsellBlock = `
      <div style="background:#f0fdf4;border:1px solid #86efac;border-radius:12px;padding:20px;margin:24px 0;text-align:center;">
        <div style="font-size:14px;color:#166534;font-weight:600;margin-bottom:8px;">Keep the momentum going →</div>
        <div style="font-size:16px;font-weight:700;color:#0F1631;margin-bottom:12px;">Cert ${nextCert} is next in your track</div>
        <a href="${SITE_URL}"
           style="display:inline-block;background:#2D1FB1;color:#fff;font-weight:700;padding:10px 24px;border-radius:8px;text-decoration:none;font-size:13px;">
          Continue to Cert ${nextCert} →
        </a>
      </div>`;
  }

  const emailHtml = `<!DOCTYPE html><html><head><meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1.0"/>
  </head><body style="font-family:Inter,sans-serif;background:#F8FAFC;margin:0;padding:20px;">
  <div style="max-width:560px;margin:0 auto;background:#fff;border-radius:16px;overflow:hidden;box-shadow:0 4px 24px rgba(0,0,0,0.08);">
    <div style="background:#0F1631;padding:24px 32px;text-align:center;">
      <img src="${SITE_URL}/assets/logo-cfa.png" alt="Cap Fund Academy" style="height:52px;width:auto;"/>
    </div>
    <div style="padding:32px;">
      <h1 style="font-size:22px;font-weight:800;color:#0F1631;margin:0 0 8px;">Congratulations, ${name}! 🎉</h1>
      <p style="color:#6b7280;font-size:14px;margin:0 0 20px;">
        You passed <strong style="color:#2D1FB1;">Cert ${certNum}: ${cert_title}</strong> with a score of <strong>${score}%</strong>.
        Your certificate has been issued and is waiting for you in your dashboard.
      </p>
      <div style="background:#f8fafc;border-radius:10px;padding:16px;margin-bottom:20px;text-align:center;">
        <div style="font-size:36px;font-weight:900;color:#2D1FB1;">${score}%</div>
        <div style="font-size:12px;color:#9ca3af;text-transform:uppercase;letter-spacing:1px;">Final Score</div>
        <div style="font-size:13px;color:#0F1631;font-weight:600;margin-top:4px;">Cert ${certNum} of 17 Complete</div>
      </div>
      ${upsellBlock}
      <div style="text-align:center;margin-top:20px;">
        <a href="${SITE_URL}" style="display:inline-block;background:#2D1FB1;color:#fff;font-weight:700;padding:12px 28px;border-radius:10px;text-decoration:none;font-size:14px;">
          View My Certificate →
        </a>
      </div>
    </div>
    <div style="background:#f8fafc;padding:16px 32px;border-top:1px solid #e5e7eb;text-align:center;">
      <p style="font-size:11px;color:#9ca3af;margin:0;">
        Cap Fund Academy · support@capfundacademy.com · capfundacademy.com<br/>
        Independent training platform · Not affiliated with USDA
      </p>
    </div>
  </div></body></html>`;

  // Send via email-send function (internal call)
  const sendRes = await fetch(`${SITE_URL}/.netlify/functions/email-send`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      to:       profile.email,
      subject:  `🎉 You passed Cert ${certNum}: ${cert_title} — ${score}%`,
      html:     emailHtml,
      _internal: true,
    }),
  });

  return ok({ sent: sendRes.ok, to: profile.email, cert_number: certNum, upsell_tier: upsell?.credential || null });
};
