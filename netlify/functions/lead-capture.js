// ============================================================================
// lead-capture.js — Upsert leads, save quiz responses, trigger email sequence
// Public endpoint — no auth required (honeypot anti-spam)
// ============================================================================

const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL         = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const RESEND_API_KEY       = process.env.RESEND_API_KEY;
const FROM_EMAIL           = 'Cap Fund Academy <support@capfundacademy.com>';
const SITE_URL             = process.env.URL || 'https://capfundacademy.com';

const CORS = {
  'Access-Control-Allow-Origin':  '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};
const ok  = (b) => ({ statusCode: 200, headers: { ...CORS, 'Content-Type': 'application/json' }, body: JSON.stringify(b) });
const err = (s, m) => ({ statusCode: s, headers: { ...CORS, 'Content-Type': 'application/json' }, body: JSON.stringify({ error: m }) });

function getResultTag(score) {
  if (score >= 80) return 'advanced';
  if (score >= 60) return 'ready';
  if (score >= 35) return 'developing';
  return 'beginner';
}

function getResultLabel(tag) {
  const labels = {
    beginner:   'Building the Foundations',
    developing: 'Developing Capacity',
    ready:      'Ready to Apply',
    advanced:   'Advanced Practitioner',
  };
  return labels[tag] || 'Emerging';
}

function getResultDescription(tag) {
  const desc = {
    beginner:   'Your organization is in the early stages of building the capacity needed for USDA rural capital programs. The right training and tools can accelerate your readiness significantly.',
    developing: 'You have meaningful foundational capacity but have key gaps to address before submitting a competitive RMAP or RBDG application. Focus on documentation and policy development.',
    ready:      'Your organization has strong fundamentals and could be competitive with the right application strategy. Completing the RMAP scoring modules will help you maximize your score.',
    advanced:   'You are an experienced practitioner. Your focus should be on optimization — maximizing your scoring evidence, strengthening your portfolio data, and refining your TA documentation.',
  };
  return desc[tag] || '';
}

async function sendEmail(to, subject, html) {
  if (!RESEND_API_KEY) return;
  try {
    await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: { 'Authorization': `Bearer ${RESEND_API_KEY}`, 'Content-Type': 'application/json' },
      body: JSON.stringify({ from: FROM_EMAIL, to: [to], subject, html })
    });
  } catch (e) {
    console.error('Email send failed:', e.message);
  }
}

exports.handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') return { statusCode: 204, headers: CORS, body: '' };
  if (event.httpMethod !== 'POST')    return err(405, 'Method not allowed');

  let body;
  try { body = JSON.parse(event.body || '{}'); }
  catch { return err(400, 'Invalid JSON'); }

  // Honeypot anti-spam
  if (body.website || body.phone_confirm) return ok({ success: true }); // silently drop spam

  const { name, email, organization, source, answers, score, max_score, utm_source, utm_medium, utm_campaign, referrer } = body;

  if (!email || !email.includes('@')) return err(400, 'Valid email required');

  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false }
  });

  // Upsert lead
  const resultTag = score != null ? getResultTag(Math.round((score / (max_score || 100)) * 100)) : null;

  const { data: lead, error: leadErr } = await admin.from('leads').upsert({
    email: email.toLowerCase().trim(),
    name: name?.trim() || null,
    organization: organization?.trim() || null,
    source: source || 'website',
    quiz_score: score ?? null,
    result_tag: resultTag,
    utm_source: utm_source || null,
    utm_medium: utm_medium || null,
    utm_campaign: utm_campaign || null,
    referrer: referrer || null,
    last_activity: new Date().toISOString(),
    funnel_stage: score != null ? 'quiz_complete' : 'lead',
  }, { onConflict: 'email', ignoreDuplicates: false }).select().single();

  if (leadErr) {
    console.error('Lead upsert error:', leadErr.message);
  }

  // Save quiz response if answers provided
  if (answers && Object.keys(answers).length > 0 && lead) {
    await admin.from('quiz_responses').insert({
      lead_id: lead.id,
      email: email.toLowerCase().trim(),
      name: name?.trim() || null,
      organization: organization?.trim() || null,
      answers,
      score: score || 0,
      max_score: max_score || 100,
      result_tag: resultTag,
    });
  }

  // Send welcome / result email
  if (lead && email) {
    if (score != null) {
      // Quiz result email
      const pct = Math.round((score / (max_score || 100)) * 100);
      const label = getResultLabel(resultTag);
      const description = getResultDescription(resultTag);
      await sendEmail(email, `Your RLF Readiness Score: ${pct}% — ${label}`,
        `<div style="font-family:Arial,sans-serif;max-width:560px;margin:0 auto;color:#0F1631">
          <img src="${SITE_URL}/assets/logo.png" alt="Cap Fund Academy" style="height:48px;margin-bottom:24px"/>
          <h2 style="color:#2D1FB1">Your RLF Readiness Score: ${pct}%</h2>
          <h3 style="color:#F97316">${label}</h3>
          <p>${description}</p>
          <p>Based on your results, we recommend starting with our free RMAP Evidence Checklist and the Cert 3 preview (USDA RMAP Eligibility, Application & Scoring).</p>
          <a href="${SITE_URL}" style="display:inline-block;padding:12px 24px;background:#F97316;color:white;font-weight:bold;border-radius:8px;text-decoration:none;margin-top:16px">Explore Cap Fund Academy →</a>
          <p style="margin-top:32px;font-size:11px;color:#999">Cap Fund Academy is an independent training platform not affiliated with USDA or any government agency. Results are educational only.</p>
        </div>`
      );
    } else if (source === 'checklist') {
      // Lead magnet delivery email
      await sendEmail(email, 'Your Free RMAP Evidence Checklist is Ready',
        `<div style="font-family:Arial,sans-serif;max-width:560px;margin:0 auto;color:#0F1631">
          <img src="${SITE_URL}/assets/logo.png" alt="Cap Fund Academy" style="height:48px;margin-bottom:24px"/>
          <h2 style="color:#2D1FB1">Your RMAP Evidence Checklist</h2>
          <p>Thank you for downloading the RMAP Evidence Checklist. You can access it anytime at the link below.</p>
          <a href="${SITE_URL}/?page=rmap-checklist" style="display:inline-block;padding:12px 24px;background:#2D1FB1;color:white;font-weight:bold;border-radius:8px;text-decoration:none;margin-top:16px">View Checklist →</a>
          <p style="margin-top:16px">Want to go deeper? Our Cert 3 (USDA RMAP Eligibility, Application & Scoring) covers every scoring criterion from 7 CFR 4280.316 with practice labs and required artifact templates.</p>
          <a href="${SITE_URL}" style="display:inline-block;padding:12px 24px;background:#F97316;color:white;font-weight:bold;border-radius:8px;text-decoration:none">Explore Certifications →</a>
          <p style="margin-top:32px;font-size:11px;color:#999">Cap Fund Academy is an independent training platform not affiliated with USDA or any government agency.</p>
        </div>`
      );
    } else {
      // General welcome
      await sendEmail(email, 'Welcome to Cap Fund Academy',
        `<div style="font-family:Arial,sans-serif;max-width:560px;margin:0 auto;color:#0F1631">
          <img src="${SITE_URL}/assets/logo.png" alt="Cap Fund Academy" style="height:48px;margin-bottom:24px"/>
          <h2 style="color:#2D1FB1">Welcome to Cap Fund Academy</h2>
          <p>Thank you for your interest in rural capital access training. We help nonprofits, CDFIs, and rural development organizations understand and apply for USDA RMAP, RBDG, IRP, and revolving loan fund programs.</p>
          <p>Take our free RLF Readiness Quiz to find out exactly where your organization stands.</p>
          <a href="${SITE_URL}/?page=quiz" style="display:inline-block;padding:12px 24px;background:#F97316;color:white;font-weight:bold;border-radius:8px;text-decoration:none;margin-top:16px">Take the Free Quiz →</a>
          <p style="margin-top:32px;font-size:11px;color:#999">Cap Fund Academy is an independent training platform not affiliated with USDA or any government agency.</p>
        </div>`
      );
    }
  }

  return ok({ success: true, lead_id: lead?.id, result_tag: resultTag });
};
