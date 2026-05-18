-- ============================================================
-- Cap Fund Academy — CRM Schema
-- File: 11_crm_schema.sql
-- Idempotent: safe to re-run
-- Run after: 10_funnel_schema.sql
-- ============================================================

-- ============================================================
-- funnel_stages — pipeline stage definitions (admin-editable)
-- ============================================================
CREATE TABLE IF NOT EXISTS funnel_stages (
  id          uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name        text NOT NULL,
  slug        text UNIQUE NOT NULL,
  color       text NOT NULL DEFAULT '#6B7280',
  sort_order  integer NOT NULL DEFAULT 0,
  is_active   boolean NOT NULL DEFAULT true
);

INSERT INTO funnel_stages (name, slug, color, sort_order) VALUES
  ('New Lead',        'new_lead',        '#6B7280', 10),
  ('Quiz Completed',  'quiz_completed',  '#2D1FB1', 20),
  ('Checklist',       'checklist',       '#7C3AED', 30),
  ('Webinar',         'webinar',         '#0891B2', 40),
  ('Nurture',         'nurture',         '#F59E0B', 50),
  ('Sales Call',      'sales_call',      '#F97316', 60),
  ('Proposal Sent',   'proposal_sent',   '#EF4444', 70),
  ('Customer',        'customer',        '#16A34A', 80),
  ('Unsubscribed',    'unsubscribed',    '#9CA3AF', 90)
ON CONFLICT (slug) DO NOTHING;

-- ============================================================
-- Extend leads with CRM fields
-- ============================================================
ALTER TABLE public.leads
  ADD COLUMN IF NOT EXISTS stage_id    uuid REFERENCES funnel_stages(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS notes       text,
  ADD COLUMN IF NOT EXISTS assigned_to uuid REFERENCES auth.users(id) ON DELETE SET NULL;

-- ============================================================
-- crm_events — activity log per lead
-- ============================================================
CREATE TABLE IF NOT EXISTS crm_events (
  id          uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  lead_id     uuid NOT NULL REFERENCES leads(id) ON DELETE CASCADE,
  user_id     uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  event_type  text NOT NULL,  -- 'note'|'email_sent'|'stage_change'|'task_created'|'quiz'|'purchase'|'login'
  title       text NOT NULL,
  body        text,
  metadata    jsonb NOT NULL DEFAULT '{}',
  created_at  timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- crm_tasks — follow-up tasks per lead
-- ============================================================
CREATE TABLE IF NOT EXISTS crm_tasks (
  id            uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  lead_id       uuid NOT NULL REFERENCES leads(id) ON DELETE CASCADE,
  assigned_to   uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  title         text NOT NULL,
  due_at        timestamptz,
  completed     boolean NOT NULL DEFAULT false,
  completed_at  timestamptz,
  priority      text NOT NULL DEFAULT 'normal',  -- low|normal|high
  created_at    timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- email_templates — reusable email template library
-- ============================================================
CREATE TABLE IF NOT EXISTS email_templates (
  id          uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name        text NOT NULL,
  slug        text UNIQUE NOT NULL,
  subject     text NOT NULL,
  body_html   text NOT NULL,
  category    text,   -- 'nurture'|'onboarding'|'transactional'|'broadcast'
  variables   text[], -- list of {{variable}} names used
  is_active   boolean NOT NULL DEFAULT true,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

-- ============================================================
-- Triggers
-- ============================================================
DROP TRIGGER IF EXISTS set_updated_at ON email_templates;
CREATE TRIGGER set_updated_at BEFORE UPDATE ON email_templates FOR EACH ROW EXECUTE FUNCTION tg_set_updated_at();

-- ============================================================
-- RLS
-- ============================================================
ALTER TABLE funnel_stages  ENABLE ROW LEVEL SECURITY;
ALTER TABLE crm_events     ENABLE ROW LEVEL SECURITY;
ALTER TABLE crm_tasks      ENABLE ROW LEVEL SECURITY;
ALTER TABLE email_templates ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "stages_read"   ON funnel_stages;
DROP POLICY IF EXISTS "stages_write"  ON funnel_stages;
CREATE POLICY "stages_read"  ON funnel_stages FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY "stages_write" ON funnel_stages FOR ALL   USING (get_my_role() IN ('super_admin','admin'));

DROP POLICY IF EXISTS "crm_events_admin" ON crm_events;
CREATE POLICY "crm_events_admin" ON crm_events FOR ALL USING (get_my_role() IN ('super_admin','admin','instructor'));

DROP POLICY IF EXISTS "crm_tasks_admin" ON crm_tasks;
CREATE POLICY "crm_tasks_admin" ON crm_tasks FOR ALL USING (get_my_role() IN ('super_admin','admin','instructor'));

DROP POLICY IF EXISTS "templates_read"  ON email_templates;
DROP POLICY IF EXISTS "templates_write" ON email_templates;
CREATE POLICY "templates_read"  ON email_templates FOR SELECT USING (get_my_role() IN ('super_admin','admin'));
CREATE POLICY "templates_write" ON email_templates FOR ALL   USING (get_my_role() IN ('super_admin','admin'));

-- ============================================================
-- Seed email sequences (extends 10_funnel_schema.sql sequences)
-- ============================================================
INSERT INTO email_sequences (name, trigger_event, result_tag, is_active) VALUES
  ('Welcome — General',           'welcome',              NULL,         true),
  ('Quiz Result — Beginner',       'quiz_complete',        'beginner',   true),
  ('Quiz Result — Developing',     'quiz_complete',        'developing', true),
  ('Quiz Result — Ready to Apply', 'quiz_complete',        'ready',      true),
  ('Quiz Result — Advanced',       'quiz_complete',        'advanced',   true),
  ('Checklist Download Nurture',   'checklist_download',   NULL,         true),
  ('Webinar Registration',         'webinar_signup',       NULL,         true),
  ('Sales Nurture — 7 Day',        'quiz_complete',        NULL,         true),
  ('Student Onboarding',           'purchase',             NULL,         true),
  ('Cert Completion',              'cert_complete',        NULL,         true),
  ('Testimonial Request',          'cert_complete',        NULL,         true),
  ('Inactivity Reengagement',      'no_activity_30_days',  NULL,         true),
  ('Renewal Reminder',             'subscription_renewal', NULL,         true)
ON CONFLICT DO NOTHING;

-- ============================================================
-- Seed email templates
-- ============================================================
INSERT INTO email_templates (name, slug, subject, body_html, category, variables) VALUES

('Welcome — New Lead', 'welcome-new-lead',
 'Welcome to Cap Fund Academy',
 '<h2>Welcome, {{name}}!</h2><p>Thank you for your interest in rural capital access training. We help nonprofits, CDFIs, and rural development organizations build the skills to access USDA RMAP, RBDG, IRP, and revolving loan fund programs.</p><p><strong>Your free resources:</strong></p><ul><li><a href="{{site_url}}/?page=quiz">RLF Readiness Quiz</a> — find out where your organization stands</li><li><a href="{{site_url}}/?page=checklist">RMAP Evidence Checklist</a> — know what USDA reviewers look for</li></ul><p>Questions? Reply to this email or contact us at <a href="mailto:support@capfundacademy.com">support@capfundacademy.com</a>.</p>',
 'onboarding', ARRAY['name','site_url']),

('Quiz Result — Beginner', 'quiz-result-beginner',
 'Your RLF Readiness Score: Building the Foundations',
 '<h2>Your Score: {{score}}% — Building the Foundations</h2><p>Your organization is in the early stages of building the capacity needed for USDA rural capital programs. That is completely normal — every strong microlender started here.</p><p><strong>Your recommended starting point:</strong> <a href="{{site_url}}">Cert 1: Microfinance Foundations & Borrower-Centered Lending</a></p><p>This certification covers the core vocabulary, regulatory framework, and client protection principles that form the foundation of every successful RMAP application.</p><p><a href="{{site_url}}" style="background:#F97316;color:white;padding:12px 24px;border-radius:8px;text-decoration:none;font-weight:bold">Start Cert 1 →</a></p>',
 'nurture', ARRAY['name','score','site_url']),

('Quiz Result — Ready to Apply', 'quiz-result-ready',
 'Your Score: {{score}}% — You Are Ready to Apply',
 '<h2>Your Score: {{score}}% — Ready to Apply</h2><p>Congratulations — your organization has strong fundamentals. With the right evidence documentation and scoring strategy, you could submit a competitive RMAP application this cycle.</p><p><strong>Your highest-leverage next step:</strong> Run your application data through our AI Scoring Engine to see exactly how you would score against the 7 CFR 4280.316 criteria.</p><p><a href="{{site_url}}" style="background:#F97316;color:white;padding:12px 24px;border-radius:8px;text-decoration:none;font-weight:bold">Access AI Scoring Engine →</a></p>',
 'nurture', ARRAY['name','score','site_url']),

('Student Onboarding — Day 1', 'student-onboarding-day1',
 'Your Cap Fund Academy access is ready',
 '<h2>Welcome to Cap Fund Academy, {{name}}!</h2><p>Your enrollment in <strong>{{offer_title}}</strong> is confirmed. Here is how to get started:</p><ol><li><strong>Log in</strong> at <a href="{{site_url}}">capfundacademy.com</a></li><li><strong>Start Cert 1</strong> — Microfinance Foundations & Borrower-Centered Lending</li><li><strong>Create your Application Workspace</strong> — click "Score My App" in the top nav</li></ol><p>If you have any questions, reply to this email or reach us at <a href="mailto:support@capfundacademy.com">support@capfundacademy.com</a>.</p>',
 'onboarding', ARRAY['name','offer_title','site_url']),

('Cert Completion Congratulations', 'cert-completion',
 'Certificate earned: {{cert_title}}',
 '<h2>Congratulations, {{name}}!</h2><p>You have successfully completed <strong>{{cert_title}}</strong> with a score of {{score}}%.</p><p>Your certificate is available in your dashboard. <a href="{{site_url}}">View and print your certificate →</a></p><p><strong>What is next?</strong> {{next_cert_suggestion}}</p>',
 'transactional', ARRAY['name','cert_title','score','next_cert_suggestion','site_url']),

('Inactivity — 30 Days', 'inactivity-30-days',
 'We miss you — your rural capital training is waiting',
 '<h2>Hi {{name}},</h2><p>You enrolled in Cap Fund Academy {{days_since}} days ago but have not logged in recently. Your certifications and AI scoring workspace are waiting.</p><p>Rural funding cycles move fast — RMAP applications are accepted quarterly. Getting your application documentation organized now gives you a competitive edge.</p><p><a href="{{site_url}}" style="background:#2D1FB1;color:white;padding:12px 24px;border-radius:8px;text-decoration:none;font-weight:bold">Resume Your Training →</a></p>',
 'nurture', ARRAY['name','days_since','site_url']),

('Testimonial Request', 'testimonial-request',
 'Quick question about your experience, {{name}}',
 '<h2>Hi {{name}},</h2><p>You recently completed <strong>{{cert_title}}</strong> — congratulations again!</p><p>We would love to feature your story. Would you be willing to share a quick testimonial about your experience with Cap Fund Academy?</p><p>Just reply to this email with a sentence or two, or <a href="mailto:support@capfundacademy.com?subject=Testimonial from {{name}}">click here to send it directly</a>.</p><p>Thank you for being part of our community.</p>',
 'nurture', ARRAY['name','cert_title'])

ON CONFLICT (slug) DO NOTHING;
