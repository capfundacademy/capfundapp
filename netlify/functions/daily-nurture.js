// ============================================================================
// daily-nurture.js — Daily lead nurture progression
// Checks for leads who completed quiz/checklist but received no follow-up
// Sends next sequence email based on funnel stage + result_tag
// Scheduled: daily at 9am UTC
// ============================================================================

const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL         = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const RESEND_API_KEY       = process.env.RESEND_API_KEY;
const SITE_URL             = process.env.URL || 'https://capfundacademy.com';
const FROM                 = 'Cap Fund Academy <support@capfundacademy.com>';

async function sendEmail(to, subject, html) {
  if (!RESEND_API_KEY) return null;
  const res = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: { 'Authorization': `Bearer ${RESEND_API_KEY}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({ from: FROM, to: [to], subject, html })
  });
  return res.ok ? await res.json() : null;
}

function applyVars(tmpl, vars) {
  let s = tmpl;
  Object.entries(vars).forEach(([k, v]) => { s = s.replaceAll(`{{${k}}}`, v || ''); });
  return s;
}

exports.handler = async () => {
  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false }
  });

  const runId = (await admin.from('autopilot_runs').insert({
    function_name: 'daily-nurture', status: 'running', started_at: new Date().toISOString()
  }).select().single()).data?.id;

  let processed = 0, failed = 0;

  try {
    const twoDaysAgo = new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString();
    const sevenDaysAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString();

    // 1. Quiz completers with no email sent in last 2 days → send day-2 nurture
    const { data: quizLeads } = await admin.from('leads')
      .select('id,name,email,result_tag,quiz_score,organization')
      .eq('funnel_stage', 'quiz_complete')
      .not('email', 'is', null)
      .lt('last_activity', twoDaysAgo)
      .limit(50);

    for (const lead of quizLeads || []) {
      try {
        // Check no email already sent in last 48h
        const { count } = await admin.from('email_sends')
          .select('*', { count: 'exact', head: true })
          .eq('lead_id', lead.id)
          .gte('sent_at', twoDaysAgo);
        if ((count || 0) > 0) continue;

        const tag = lead.result_tag || 'developing';
        const subjects = {
          beginner:   'The one resource that moves the needle for new microlenders',
          developing: 'The 3 documents USDA reviewers check first (and how to prepare them)',
          ready:      'Your RMAP application: what to do this week to be competitive',
          advanced:   'How practitioners use AI scoring to find scoring gaps before submission',
        };
        const ctaLabels = {
          beginner: 'Start Cert 1 Free Preview →',
          developing: 'See the RMAP Evidence Checklist →',
          ready: 'Run Your AI Score →',
          advanced: 'Access the Master Capstone →',
        };

        const html = `<div style="font-family:Arial,sans-serif;max-width:560px;margin:0 auto;color:#0F1631">
          <img src="${SITE_URL}/assets/logo-white.png" alt="Cap Fund Academy" style="height:40px;background:#2D1FB1;padding:8px;border-radius:8px;margin-bottom:20px"/>
          <h2>Hi ${lead.name || 'there'},</h2>
          <p>Following up on your RLF Readiness Quiz result (${lead.quiz_score || 0}% — ${tag}).</p>
          <p>Based on where you are, here is the single most valuable next step you can take right now:</p>
          <p style="background:#F8FAFC;padding:16px;border-left:4px solid #2D1FB1;border-radius:0 8px 8px 0">${subjects[tag] || subjects.developing}</p>
          <a href="${SITE_URL}" style="display:inline-block;padding:12px 24px;background:#F97316;color:white;font-weight:bold;border-radius:8px;text-decoration:none;margin-top:8px">${ctaLabels[tag] || 'Explore Cap Fund Academy →'}</a>
          <p style="margin-top:24px;font-size:11px;color:#9CA3AF">Cap Fund Academy is an independent training platform not affiliated with USDA or any government agency.</p>
        </div>`;

        const result = await sendEmail(lead.email, subjects[tag] || 'Your next step with Cap Fund Academy', html);
        if (result?.id) {
          await admin.from('email_sends').insert({ lead_id: lead.id, to_email: lead.email, subject: subjects[tag], status: 'sent', provider_id: result.id });
          await admin.from('leads').update({ last_activity: new Date().toISOString(), funnel_stage: 'nurture' }).eq('id', lead.id);
          processed++;
        }
      } catch (e) { console.error('Nurture email failed for lead', lead.id, e.message); failed++; }
    }

    // 2. Inactivity reengagement: students inactive 30+ days
    const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString();
    const { data: inactiveStudents } = await admin.from('profiles')
      .select('id,full_name,email,created_at')
      .eq('role', 'student')
      .lt('updated_at', thirtyDaysAgo)
      .limit(20);

    for (const student of inactiveStudents || []) {
      try {
        const { count } = await admin.from('email_sends')
          .select('*', { count: 'exact', head: true })
          .eq('to_email', student.email)
          .gte('sent_at', sevenDaysAgo);
        if ((count || 0) > 0) continue;

        const daysSince = Math.floor((Date.now() - new Date(student.created_at).getTime()) / 86400000);
        const html = `<div style="font-family:Arial,sans-serif;max-width:560px;margin:0 auto;color:#0F1631">
          <img src="${SITE_URL}/assets/logo-white.png" alt="Cap Fund Academy" style="height:40px;background:#2D1FB1;padding:8px;border-radius:8px;margin-bottom:20px"/>
          <h2>Hi ${student.full_name || 'there'},</h2>
          <p>You enrolled in Cap Fund Academy ${daysSince} days ago — your certifications and AI scoring workspace are still waiting for you.</p>
          <p>Rural funding cycles move fast. RMAP applications are accepted quarterly. Getting your documentation organized now gives you a real edge.</p>
          <a href="${SITE_URL}" style="display:inline-block;padding:12px 24px;background:#2D1FB1;color:white;font-weight:bold;border-radius:8px;text-decoration:none">Resume Your Training →</a>
          <p style="margin-top:24px;font-size:11px;color:#9CA3AF">Cap Fund Academy · <a href="mailto:support@capfundacademy.com">support@capfundacademy.com</a></p>
        </div>`;

        const result = await sendEmail(student.email, `Your rural capital training is waiting, ${student.full_name || 'there'}`, html);
        if (result?.id) {
          await admin.from('email_sends').insert({ to_email: student.email, subject: 'Your training is waiting', status: 'sent', provider_id: result.id });
          processed++;
        }
      } catch (e) { console.error('Inactivity email failed for student', student.id, e.message); failed++; }
    }

    const summary = { quizNurtured: (quizLeads || []).length, processed, failed };
    if (runId) await admin.from('autopilot_runs').update({ status: failed > 0 ? 'partial' : 'success', completed_at: new Date().toISOString(), records_processed: processed, records_failed: failed, summary }).eq('id', runId);

    console.log('Daily nurture complete:', summary);
    return { statusCode: 200, body: JSON.stringify(summary) };
  } catch (e) {
    console.error('daily-nurture error:', e.message);
    if (runId) await admin.from('autopilot_runs').update({ status: 'failed', completed_at: new Date().toISOString(), error_message: e.message }).eq('id', runId);
    return { statusCode: 500, body: e.message };
  }
};
