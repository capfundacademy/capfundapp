// ============================================================================
// email-send.js — Email adapter (Resend default, swappable via EMAIL_PROVIDER)
// Supports: Resend (default), SMTP (nodemailer), Brevo
// Auth: admin only for direct send; internal calls from other functions
// EMAIL_PROVIDER env var: 'resend' (default) | 'smtp' | 'brevo'
// ============================================================================

const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL         = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const EMAIL_PROVIDER       = process.env.EMAIL_PROVIDER || 'resend';
const FROM_DEFAULT         = 'Cap Fund Academy <support@capfundacademy.com>';

const CORS = {
  'Access-Control-Allow-Origin':  '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
};
const ok  = (b) => ({ statusCode: 200, headers: { ...CORS, 'Content-Type': 'application/json' }, body: JSON.stringify(b) });
const err = (s, m) => ({ statusCode: s, headers: { ...CORS, 'Content-Type': 'application/json' }, body: JSON.stringify({ error: m }) });

// ── Provider adapters ─────────────────────────────────────────────────────

async function sendViaResend({ to, from, subject, html, replyTo }) {
  const apiKey = process.env.RESEND_API_KEY;
  if (!apiKey) throw new Error('RESEND_API_KEY not set');
  const res = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: { 'Authorization': `Bearer ${apiKey}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({ from: from || FROM_DEFAULT, to: Array.isArray(to) ? to : [to], subject, html, reply_to: replyTo })
  });
  if (!res.ok) { const t = await res.text(); throw new Error(`Resend error ${res.status}: ${t}`); }
  return res.json();
}

async function sendViaBrevo({ to, from, subject, html }) {
  const apiKey = process.env.BREVO_API_KEY;
  if (!apiKey) throw new Error('BREVO_API_KEY not set');
  const fromParts = (from || FROM_DEFAULT).match(/^(.+?) <(.+)>$/) || [null, 'Cap Fund Academy', 'support@capfundacademy.com'];
  const res = await fetch('https://api.brevo.com/v3/smtp/email', {
    method: 'POST',
    headers: { 'api-key': apiKey, 'Content-Type': 'application/json' },
    body: JSON.stringify({
      sender: { name: fromParts[1], email: fromParts[2] },
      to: Array.isArray(to) ? to.map(e => ({ email: e })) : [{ email: to }],
      subject, htmlContent: html
    })
  });
  if (!res.ok) { const t = await res.text(); throw new Error(`Brevo error ${res.status}: ${t}`); }
  return res.json();
}

async function sendViaSMTP({ to, from, subject, html }) {
  // SMTP via fetch to a relay endpoint — set SMTP_RELAY_URL + SMTP_RELAY_KEY env vars
  // to point to a self-hosted relay (e.g. Postal, Mailhog) or use Resend/Brevo instead
  const relayUrl = process.env.SMTP_RELAY_URL;
  if (!relayUrl) throw new Error('SMTP_RELAY_URL not configured. Use EMAIL_PROVIDER=resend or EMAIL_PROVIDER=brevo instead.');
  const res = await fetch(relayUrl, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${process.env.SMTP_RELAY_KEY || ''}` },
    body: JSON.stringify({ from: from || FROM_DEFAULT, to: Array.isArray(to) ? to : [to], subject, html })
  });
  if (!res.ok) throw new Error(`SMTP relay error: ${res.status}`);
  return res.json();
}

// ── Template variable replacement ────────────────────────────────────────

function applyTemplate(template, variables) {
  let result = template;
  Object.entries(variables || {}).forEach(([key, value]) => {
    result = result.replaceAll(`{{${key}}}`, value || '');
  });
  return result;
}

// ── Main send function ────────────────────────────────────────────────────

async function sendEmail({ to, from, subject, html, replyTo }) {
  switch (EMAIL_PROVIDER) {
    case 'brevo': return sendViaBrevo({ to, from, subject, html });
    case 'smtp':  return sendViaSMTP({ to, from, subject, html });
    default:      return sendViaResend({ to, from, subject, html, replyTo });
  }
}

// ── Netlify handler ───────────────────────────────────────────────────────

exports.handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') return { statusCode: 204, headers: CORS, body: '' };
  if (event.httpMethod !== 'POST')    return err(405, 'Method not allowed');

  const authHeader = event.headers.authorization || event.headers.Authorization;
  if (!authHeader?.startsWith('Bearer ')) return err(401, 'Missing bearer token');

  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false }
  });

  const { data: userData, error: userErr } = await admin.auth.getUser(authHeader.slice(7));
  if (userErr || !userData?.user) return err(401, 'Invalid session');

  const { data: requester } = await admin.from('profiles').select('role').eq('id', userData.user.id).maybeSingle();
  if (!['super_admin','admin'].includes(requester?.role)) return err(403, 'Admin access required');

  let body;
  try { body = JSON.parse(event.body || '{}'); }
  catch { return err(400, 'Invalid JSON'); }

  const { to, subject, html, template_slug, template_vars, lead_id, sequence_step_id } = body;

  if (!to) return err(400, 'to is required');

  let finalSubject = subject;
  let finalHtml = html;

  // Load template if slug provided
  if (template_slug) {
    const { data: tmpl } = await admin.from('email_templates').select('*').eq('slug', template_slug).eq('is_active', true).maybeSingle();
    if (!tmpl) return err(404, `Template not found: ${template_slug}`);
    finalSubject = applyTemplate(tmpl.subject, template_vars);
    finalHtml    = applyTemplate(tmpl.body_html, template_vars);
  }

  if (!finalSubject || !finalHtml) return err(400, 'subject and html (or template_slug) required');

  try {
    const result = await sendEmail({ to, subject: finalSubject, html: finalHtml });

    // Log the send
    const recipients = Array.isArray(to) ? to : [to];
    for (const email of recipients) {
      await admin.from('email_sends').insert({
        lead_id: lead_id || null,
        user_id: userData.user.id,
        step_id: sequence_step_id || null,
        to_email: email,
        subject: finalSubject,
        status: 'sent',
        provider_id: result?.id || null,
      });
    }

    // Log CRM event if lead_id provided
    if (lead_id) {
      await admin.from('crm_events').insert({
        lead_id,
        user_id: userData.user.id,
        event_type: 'email_sent',
        title: `Email sent: ${finalSubject}`,
        metadata: { template_slug, provider: EMAIL_PROVIDER }
      });
    }

    return ok({ sent: true, provider: EMAIL_PROVIDER, id: result?.id });
  } catch (e) {
    console.error('email-send error:', e.message);
    return err(500, `Send failed (${EMAIL_PROVIDER}): ${e.message}`);
  }
};

// Export send function for internal use by other functions
exports.sendEmail      = sendEmail;
exports.applyTemplate  = applyTemplate;
