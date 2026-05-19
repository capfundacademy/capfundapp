-- ============================================================
-- Cap Fund Academy — Certs 14-17 Full Content
-- File: 18_cert14_17_content.sql
-- Idempotent: ON CONFLICT DO NOTHING
-- Run after: 04_cert_seeds.sql
-- ============================================================

-- ============================================================
-- CERT 14: Automated Offer, Sales Funnel & Enrollment Operations
-- ============================================================
DO $$
DECLARE
  cert_id   uuid;
  mod1_id   uuid;
  mod2_id   uuid;
  mod3_id   uuid;
  mod4_id   uuid;
  quiz_id   uuid;
BEGIN

SELECT id INTO cert_id FROM certifications WHERE cert_number = 14;
IF cert_id IS NULL THEN
  RAISE EXCEPTION 'Cert 14 not found — run 04_cert_seeds.sql first';
END IF;

UPDATE certifications SET
  learning_outcomes = ARRAY[
    'Design a compelling certification offer with tiered pricing, bonuses, and a guarantee that converts skeptical buyers',
    'Map a complete sales funnel from lead magnet to checkout, identifying the job each page must accomplish',
    'Select and configure a payment processor and course platform suitable for a certification business',
    'Build automated post-purchase enrollment workflows that deliver credentials without manual intervention',
    'Write a 5-email onboarding sequence that activates new students and reduces early churn',
    'Create operational SOPs for enrollment, refunds, and exception handling that scale to hundreds of students',
    'Measure funnel conversion rates and identify the highest-leverage optimization opportunities'
  ],
  status = 'approved'
WHERE id = cert_id;

-- MODULE 1
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Offer Design & Pricing Strategy',
  'Build a certification offer that commands premium prices. Covers positioning, pricing tiers, bonuses, guarantees, and the psychology of high-ticket purchasing decisions.',
  1, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod1_id FROM modules WHERE certification_id = cert_id AND sort_order = 1;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod1_id,
  'Designing a Premium Certification Offer',
  'cert14-premium-offer-design',
  E'## Why Offer Design Comes Before Everything Else\n\nMost certification entrepreneurs build their course first and figure out pricing later. This is backwards. Your offer — the complete package of what someone receives, at what price, with what guarantees — determines everything downstream: your sales copy, your funnel, your fulfillment operations, and ultimately whether the business is viable.\n\nA well-designed offer makes selling feel like a service rather than a transaction. When your offer is precisely matched to what your buyer urgently needs and priced correctly relative to the outcome it delivers, buying becomes the obvious decision.\n\n## The Four Components of a Certification Offer\n\n### 1. The Core Transformation\nThe core of your offer is not the content — it is the transformation your student achieves. For Cap Fund Academy certifications, the transformation is concrete and quantifiable: a rural nonprofit that completes the RMAP certification can submit a compliant application for up to $500,000 in federal microlending capital.\n\nAlways name the transformation in dollar terms, time terms, or risk terms. "You will be able to submit your USDA RMAP application with confidence" is weak. "You will have a complete, auditor-ready USDA RMAP microlender application, documented to the scoring criteria that determine whether you get funded" is strong.\n\n### 2. The Proof Stack\nBuyers at the $497–$997 price point are making a meaningful financial commitment. They need proof that the transformation is achievable. Your proof stack should include:\n\n- **Regulatory citations** — showing your content is grounded in actual federal law (7 CFR 4280, 2 CFR 200)\n- **Outcome specificity** — detailed descriptions of exactly what a graduate can do\n- **Social proof** — testimonials, cohort results, or case studies from early students\n- **Authority signals** — your credentials, partnerships, or regulatory expertise\n\nFor a new certification business with no testimonials yet, lean heavily on regulatory specificity. A competitor who summarizes USDA programs loses to you if you quote chapter and verse from the actual regulation.\n\n### 3. Bonuses\nBonuses do two things: they increase perceived value and they address specific objections. Design each bonus to remove a specific fear or gap.\n\n**Effective bonus frameworks for certification offers:**\n- **Implementation tools** — templates, worksheets, checklists that accelerate applying the content (e.g., "RMAP Application Checklist — 47-Point Pre-Submission Review")\n- **Time-savers** — pre-built documents that students would otherwise spend weeks creating\n- **Access** — live Q&A calls, community membership, or direct access to the instructor\n- **Companion guides** — side-by-side summaries of the federal regulations\n\nEach bonus should have a stated value (e.g., "RMAP Application Checklist — $97 value"). The sum of bonus values should significantly exceed the course price to create a perception of extraordinary value.\n\n### 4. The Guarantee\nA strong guarantee is not a liability — it is a conversion tool. Buyers who are uncertain about a $497 purchase are reassured by a 30-day money-back guarantee. The conversion rate increase from adding a guarantee more than offsets refund rates, which for information products targeting professionals typically run 2–5%.\n\n**Guarantee frameworks:**\n- **Satisfaction guarantee** — 30-day no-questions-asked refund\n- **Completion guarantee** — "Complete all modules and implement the framework; if you don''t [achieve outcome], we''ll refund you"\n- **Results guarantee** — rare for certification businesses; requires tracking student outcomes\n\nFor a new certification business, start with a 30-day satisfaction guarantee. It removes the biggest barrier for fence-sitters without requiring outcome tracking infrastructure.\n\n## Pricing Architecture\n\n### Anchoring and Tiers\nSingle-price offers leave money on the table and make the buying decision binary (yes or no). A tiered pricing structure creates an anchoring effect where the highest tier makes the middle tier feel like the obvious choice.\n\n**Example three-tier structure for a USDA certification:**\n\n| Tier | Price | Includes |\n|------|-------|----------|\n| Self-Study | $497 | Course access, PDF downloads, community |\n| Practitioner | $797 | Self-Study + 4 live Q&A sessions + template library |\n| VIP | $1,497 | Practitioner + 1:1 application review session |\n\nThe VIP tier anchors the price conversation. When a buyer sees $1,497, $797 feels accessible. When they only see $497, there is no upward anchor.\n\n### Price-to-Outcome Ratio\nFor USDA rural capital programs, the ROI calculation is straightforward: an organization that successfully applies for RMAP funding can access up to $500,000 in microlending capital. Against that outcome, a $497–$997 certification is a rounding error. Always make this calculation explicit in your offer copy.\n\n"If this certification helps your organization secure a $250,000 USDA RMAP award, your return on this $497 investment is 50,200%."\n\n## Offer Positioning: Who Is This For?\n\nPrecise positioning beats broad appeal. A certification offer positioned for "anyone interested in microfinance" converts poorly. A certification positioned for "executive directors of rural CDFIs and nonprofits who are actively preparing a USDA RMAP or RBDG application in the next 6 months" converts at a premium.\n\nNarrow your target to the person who has the most urgency, the budget authority, and the clearest path to ROI from your content. That person will pay more, churn less, and generate more referrals.',
  'Offer design determines everything downstream in a certification business. Build a premium offer with clear transformation, proof stack, bonuses, guarantee, and tiered pricing.',
  18, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 2
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Sales Funnel Architecture',
  'Map the complete buyer journey from first touch to checkout. Covers lead magnet design, landing page structure, email sequences, sales pages, and order bumps.',
  2, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod2_id FROM modules WHERE certification_id = cert_id AND sort_order = 2;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod2_id,
  'Mapping Your Certification Sales Funnel',
  'cert14-sales-funnel-architecture',
  E'## What a Funnel Actually Does\n\nA sales funnel is a sequence of steps that moves a stranger from "I have never heard of you" to "I just paid you $797 and I am excited about it." Each step in the funnel has one job. When you understand the job each step must accomplish, you can build and optimize each piece independently.\n\n**The five-stage certification funnel:**\n\n1. **Traffic** — strangers discover you\n2. **Lead capture** — strangers become subscribers\n3. **Nurture** — subscribers become educated and trusting\n4. **Sales** — educated subscribers become buyers\n5. **Enrollment** — buyers become active students\n\n## Stage 1: Lead Magnet Design\n\nA lead magnet is a free resource that delivers immediate, specific value in exchange for an email address. For USDA certification offers, the lead magnet should solve a specific, urgent problem that your target buyer faces right now.\n\n**High-converting lead magnet formats for compliance niches:**\n- **Scorecard** — "USDA RMAP Readiness Assessment: Score Your Organization''s Eligibility in 10 Minutes"\n- **Checklist** — "23-Point RMAP Application Checklist: What USDA Reviewers Look for in Every Application"\n- **Mini-guide** — "The 5 Reasons Rural Nonprofits Get Rejected for USDA RMAP Funding (And How to Fix Them)"\n- **Template** — "Sample RLF Written Loan Policy Template — USDA-Compliant"\n\nThe lead magnet should be deliverable immediately (auto-delivered upon email confirmation) and consumable in under 20 minutes. A 200-page guide is not a lead magnet — it is a reason to unsubscribe.\n\n## Stage 2: Landing Page Structure\n\nThe landing page (opt-in page) has one job: convert a visitor into a subscriber. Every element that does not serve this job should be removed.\n\n**Essential elements of a high-converting opt-in page:**\n\n1. **Headline** — Name the specific outcome the lead magnet delivers. "Get the 23-Point USDA RMAP Application Checklist" not "Subscribe to our newsletter"\n2. **Sub-headline** — Clarify who it is for and the urgency. "For rural nonprofit leaders actively preparing a USDA RMAP or RBDG application"\n3. **Bullet list** — 3-5 specific things the subscriber will learn or get\n4. **Opt-in form** — First name + email only. Every additional field reduces conversion rate\n5. **Privacy note** — "We respect your privacy. Unsubscribe at any time."\n6. **No navigation** — Remove the site menu. The only action available should be submitting the form\n\n## Stage 3: Email Nurture Sequence\n\nAfter someone downloads your lead magnet, they need to be educated and trust-built before they are ready to buy. A 5-7 email nurture sequence accomplishes this over 7-10 days.\n\n**Nurture sequence structure for a certification offer:**\n\n- **Email 1 (Immediate):** Deliver the lead magnet. Set expectations for what they will receive over the next week.\n- **Email 2 (Day 2):** Teach one high-value concept from your curriculum. No selling. Build authority.\n- **Email 3 (Day 4):** Tell a story — a case study, your own origin story, or the story of a student''s transformation. Build connection.\n- **Email 4 (Day 6):** Address the biggest objection. "I know you might be thinking [objection]. Here''s what I want you to know."\n- **Email 5 (Day 8):** Introduce the offer. Frame it as the natural next step. Link to the sales page.\n- **Email 6 (Day 10):** Follow up with urgency or a new angle. Not everyone buys on the first exposure.\n- **Email 7 (Day 12):** Final email. "I don''t want to keep bothering you, but I did want to share one more thing before I stop."\n\n## Stage 4: Sales Page Anatomy\n\nThe sales page converts an educated, interested subscriber into a buyer. It must do the selling work that a human salesperson would do in a 1:1 conversation — addressing every question, objection, and fear the buyer has.\n\n**Sales page section order:**\n\n1. **Hero section** — Bold headline naming the transformation. Sub-headline narrowing who it is for.\n2. **Problem section** — Describe the pain your buyer is in right now, in their language.\n3. **Credibility** — Why are you the right person to solve this problem?\n4. **Solution introduction** — Introduce the certification as the solution.\n5. **What''s inside** — Module-by-module breakdown of the curriculum.\n6. **Proof** — Testimonials, case studies, or outcome statements.\n7. **Bonuses** — List each bonus with stated value.\n8. **Pricing and CTA** — Show the tiers, highlight the recommended option, include the guarantee.\n9. **FAQ** — Answer the 8-10 most common pre-purchase questions.\n10. **Final CTA** — One more enrollment button at the bottom.\n\n## Stage 5: Order Bump and Upsell\n\nAn order bump is an add-on offer presented on the checkout page — a single checkbox that adds a related product for an additional price. A well-designed order bump converts at 20-40% of buyers and can increase average order value by 30-50%.\n\n**Order bump ideas for USDA certification offers:**\n- "Add the RMAP Application Template Library ($97) — Save 12+ hours building your application from scratch"\n- "Add a 30-minute application review call ($197) — I will review your draft RMAP application and give specific feedback"\n\nAn upsell is an offer made after purchase, on the thank-you page or in the first post-purchase email. "Since you just enrolled in Cert 1, here is a discounted bundle for Certs 1-4 (the Rural Microfinance Associate credential) — save $400 when you add them now."',
  'A five-stage certification sales funnel moves strangers to buyers. Each stage has one job: lead magnet captures subscribers, nurture builds trust, sales page converts, order bump increases value.',
  20, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 3
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Payment Processing & Enrollment Automation',
  'Set up payment processing, course platform delivery, and automated enrollment workflows that run without manual intervention.',
  3, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod3_id FROM modules WHERE certification_id = cert_id AND sort_order = 3;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod3_id,
  'Payment Processing and Automated Course Delivery',
  'cert14-payment-enrollment-automation',
  E'## Choosing Your Technology Stack\n\nThe technology choices you make at launch will determine how much manual work you do at scale. A certification business processing 10 enrollments per month can survive on manual workflows. One processing 100+ cannot. Build automation from day one.\n\n**Core technology layers for a certification business:**\n\n1. **Course platform** — where students access content\n2. **Payment processor** — how you collect money\n3. **Email platform** — how you communicate with students\n4. **Automation layer** — how these systems talk to each other\n\n## Course Platform Options\n\n**Teachable / Thinkific / Kajabi:**\nAll-in-one platforms that bundle course hosting, payment processing, email, and basic automation. Easiest to start. Limited customization. Kajabi is the most complete but costs $150-$400/month. Suitable for businesses under $30K/month revenue.\n\n**Podia:**\nSimple, no-transaction-fee platform. Good for starting. Less powerful automation than Kajabi.\n\n**Custom (WordPress + MemberPress or Supabase-backed):**\nFull control over the student experience, branding, and data. Higher upfront setup cost, lower ongoing platform fees. Suitable for businesses wanting to own their platform and data long-term.\n\n**For Cap Fund Academy-style builds:**\nA Supabase-backed custom platform gives you complete control over certification records, credential issuance, and student data — critical when your certifications carry professional weight and need audit trails.\n\n## Payment Processor Configuration\n\n**Stripe** is the default choice for most certification businesses. Key configuration steps:\n\n1. **Create products in Stripe** — one product per certification tier\n2. **Configure pricing** — one-time payments for most certifications; recurring for membership access\n3. **Enable Stripe Tax** if selling to customers in sales-tax-applicable states\n4. **Set up webhooks** — Stripe sends events (payment succeeded, payment failed, refund created) to your application. Your enrollment automation triggers off these events.\n5. **Configure checkout** — Stripe Checkout or Payment Links for fast setup; Stripe Elements for custom checkout UI\n\n**Critical webhook events to handle:**\n- `checkout.session.completed` — trigger enrollment\n- `payment_intent.payment_failed` — trigger failed payment email sequence\n- `charge.refunded` — trigger revoke access workflow\n- `customer.subscription.deleted` — trigger cancellation workflow (if using subscriptions)\n\n## Enrollment Automation Architecture\n\nThe enrollment workflow is triggered by a successful payment and must accomplish several things automatically:\n\n**Step 1: Create the student account**\nWhen Stripe fires `checkout.session.completed`, your backend (Netlify function, Make.com scenario, or Zapier zap) receives the event and:\n- Creates a user record in your database (or course platform) with the email from the Stripe session\n- Assigns the purchased certification(s) to the student''s account\n- Sets enrollment date and expected completion timeline\n\n**Step 2: Send login credentials**\nImmediately after account creation, send a transactional email with:\n- Login URL\n- Temporary password or magic link\n- Clear next-step instructions ("Click here to set your password and access your first module")\n\n**Step 3: Trigger the onboarding sequence**\nAdd the new student to the onboarding email sequence in your email platform (Mailchimp, ConvertKit, ActiveCampaign). Do not send onboarding emails manually.\n\n**Step 4: Log the enrollment**\nWrite an enrollment record to your database or CRM with:\n- Student email, name\n- Certification purchased and tier\n- Payment amount and Stripe payment intent ID\n- Enrollment timestamp\n\n**Step 5: Issue receipt**\nStripe can be configured to automatically send a receipt. Verify this is enabled and that the receipt reflects your business name, not "Stripe."\n\n## Handling Failed Payments\n\nFailed payments are inevitable. A dunning sequence recovers a significant percentage:\n\n- **Immediately:** Email notifying the student their payment failed with a link to update their card\n- **Day 2:** Follow-up with urgency — "Your enrollment is on hold"\n- **Day 5:** Final notice — "We are releasing your spot in 48 hours"\n- **Day 7:** Access suspended if not resolved\n\nStripe has a built-in Smart Retries feature that automatically retries failed charges on optimized schedules. Enable this.\n\n## Refund Operations\n\nBuild a refund SOP before you launch, not after your first refund request. Decisions made under pressure of a complaint lead to inconsistent policies and unhappy students.\n\n**Refund SOP elements:**\n- Who is authorized to approve refunds\n- What documentation is required from the student\n- How to process the refund in Stripe\n- How to revoke course access after a refund (automate via Stripe webhook)\n- What to say to the student (template)\n- How to log the refund for accounting purposes',
  'Payment processing via Stripe, webhook-triggered enrollment automation, and a complete dunning sequence for failed payments form the operational backbone of a scalable certification business.',
  16, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 4
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Onboarding Sequences & Student Activation',
  'Write the post-purchase onboarding sequence and design the first-week student experience to maximize activation, engagement, and completion rates.',
  4, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod4_id FROM modules WHERE certification_id = cert_id AND sort_order = 4;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod4_id,
  'Student Onboarding and Activation',
  'cert14-student-onboarding-activation',
  E'## The Activation Problem\n\nThe biggest risk for a certification business is not churn after completion — it is students who never start. Industry data on online courses consistently shows that 30-60% of purchasers never log in after the first week. These non-starters do not complete, do not get results, and are far more likely to request refunds or leave negative reviews.\n\nActivation — getting a student to complete their first meaningful learning action — is the most important metric in the first 7 days. Everything in your onboarding sequence should drive toward first activation.\n\n## The Five-Email Onboarding Sequence\n\n**Email 1 — Sent immediately after enrollment: Welcome and Login**\n\nSubject: "Your [Certification Name] enrollment is confirmed — here is how to start"\n\nThis email must:\n- Confirm the purchase and set a positive emotional tone\n- Deliver the login link prominently (top of email, before any other content)\n- State exactly what the student should do in the next 5 minutes\n- Set the expectation for what the next 7 days will look like\n\nDo not put anything between the student and their login link. Excitement peaks in the first 10 minutes after purchase. Friction during that window permanently reduces activation rates.\n\n**Email 2 — Day 1: Orientation**\n\nSubject: "Start here: How to get the most from your certification"\n\nThis email:\n- Gives a brief overview of the curriculum structure\n- Recommends a learning schedule (e.g., "Complete one module per week for a total of 4 weeks")\n- Points to the first lesson with a direct link\n- Explains where to get help (community, email support, Q&A calls)\n\n**Email 3 — Day 3: First Milestone Check-in**\n\nSubject: "Have you completed Module 1 yet?"\n\nThis email:\n- Asks a direct question about progress\n- If they have not started, removes the friction: "If you haven''t logged in yet, here is the link. Module 1 takes about 22 minutes."\n- Teases what is in Module 2 to create forward momentum\n- Includes a testimonial or case study that reinforces the purchase decision\n\n**Email 4 — Day 5: Value Delivery**\n\nSubject: "One thing most [target audience] get wrong about [key topic]"\n\nThis email teaches something — a short insight from the curriculum that students can apply immediately. It has no CTA other than "reply and tell me what you think." This email builds the relationship and keeps students engaged even if they have not logged in yet.\n\n**Email 5 — Day 7: Momentum Email**\n\nSubject: "Week 1 check-in — where are you in the course?"\n\nThis email:\n- Acknowledges that life gets in the way\n- Offers a concrete schedule to get back on track\n- Reaffirms the outcome and why it matters\n- For students who have not activated: offers a quick-win — "If you only have 20 minutes this week, watch this one lesson: [link to highest-value lesson]"\n\n## Designing the First Login Experience\n\nThe first time a student logs in is the most important moment in their learning journey. The first-login experience should:\n\n1. **Welcome them by name** — personalizes the experience\n2. **Show their progress tracker** — even at 0%, the progress bar makes the path visible\n3. **Surface the first action clearly** — a prominent "Start Here" button linking to Lesson 1\n4. **Show the complete curriculum** — so they can see the full scope of what they are getting\n5. **Hide complexity** — lock future modules until prerequisites are complete (prevents overwhelm)\n\n## Completion Rate Benchmarks and Optimization\n\nFor professional certification programs targeting practitioners:\n- **30-day login rate:** Target 70%+ (percentage of purchasers who log in within 30 days)\n- **Module 1 completion:** Target 60%+ of activated students\n- **Full completion:** Target 25-40% (professional certifications have higher completion than general courses)\n\nIf your 30-day login rate is below 50%, the problem is in the immediate post-purchase experience (Email 1 or the first-login UX). Fix this before optimizing anything else.\n\nIf module completion falls off after Module 1, the problem is content pacing or perceived relevance. Survey students who stop at Module 1 — their answers will tell you exactly what to fix.\n\n## SOP: Enrollment Exception Handling\n\nBuild procedures for the edge cases before they happen:\n\n**Student did not receive login email:**\n- Check Stripe for confirmed payment\n- Manually create account and send password reset\n- Investigate and fix the webhook failure\n\n**Student enrolled in wrong certification:**\n- Verify in Stripe\n- Transfer enrollment to correct certification, issue partial refund if price difference\n- Document in CRM\n\n**Student requests extension:**\n- Have a default extension policy (e.g., 30-day extension, one time, no questions asked)\n- Automate extension via admin dashboard, not manual database edits\n\n**Bulk enrollment (organization purchases multiple seats):**\n- Require organization contact to provide list of student emails\n- Batch-create accounts\n- Send bulk enrollment email to each student',
  'Activation within the first 7 days determines long-term completion. A 5-email onboarding sequence, a clear first-login experience, and SOPs for edge cases create a scalable enrollment operation.',
  16, 1, 'approved')
ON CONFLICT DO NOTHING;

-- QUIZ for Cert 14
INSERT INTO quizzes (id, certification_id, title, passing_score, status)
VALUES (uuid_generate_v4(), cert_id,
  'Sales Funnel & Enrollment Operations Knowledge Check',
  80, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO quiz_id FROM quizzes WHERE certification_id = cert_id;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order)
VALUES
(quiz_id,
  'Which of the following best describes the "core transformation" in a certification offer?',
  '[{"id":"a","text":"The number of modules included in the course"},{"id":"b","text":"The specific, measurable outcome the student achieves as a result of completing the certification"},{"id":"c","text":"The instructor''s credentials and years of experience"},{"id":"d","text":"The technology platform used to deliver the content"}]',
  'b',
  'The core transformation is the specific outcome — not the content or credentials. For USDA certifications, this means the ability to submit a compliant application or operate a federally funded RLF, expressed in concrete dollar, time, or risk terms.',
  1),
(quiz_id,
  'Why is tiered pricing (e.g., Self-Study / Practitioner / VIP) more effective than a single price?',
  '[{"id":"a","text":"It allows you to charge different prices to different demographic groups"},{"id":"b","text":"The highest tier creates an anchoring effect that makes the middle tier feel accessible and obvious"},{"id":"c","text":"It is required by Stripe''s terms of service for digital products"},{"id":"d","text":"It eliminates the need for a money-back guarantee"}]',
  'b',
  'Tiered pricing uses anchoring psychology: when buyers see a $1,497 VIP option, the $797 Practitioner tier feels like a bargain. Single-price offers make the decision binary (buy or don''t), while tiers make the decision about which level.',
  2),
(quiz_id,
  'What is the primary job of a lead magnet landing page?',
  '[{"id":"a","text":"To explain the full curriculum of the certification program"},{"id":"b","text":"To convert visitors into subscribers by delivering immediate, specific value in exchange for an email address"},{"id":"c","text":"To process payment and enroll the student in the certification"},{"id":"d","text":"To build a social media following for the certification business"}]',
  'b',
  'A lead magnet landing page has exactly one job: convert a visitor into a subscriber. It should remove all navigation, deliver a compelling specific outcome in the headline, and present a simple opt-in form.',
  3),
(quiz_id,
  'In a 7-email nurture sequence, when should you first introduce the paid offer?',
  '[{"id":"a","text":"Email 1 (immediately after opt-in)"},{"id":"b","text":"Email 2 (Day 2)"},{"id":"c","text":"Email 5 (Day 8)"},{"id":"d","text":"Email 7 (Day 12)"}]',
  'c',
  'The paid offer should be introduced in Email 5 (around Day 8), after two value emails and one story/connection email have built trust and demonstrated expertise. Introducing the offer in the first 1-2 emails converts poorly because trust has not been established.',
  4),
(quiz_id,
  'Which Stripe webhook event should trigger automatic student enrollment?',
  '[{"id":"a","text":"payment_intent.created"},{"id":"b","text":"checkout.session.completed"},{"id":"c","text":"customer.created"},{"id":"d","text":"charge.succeeded"}]',
  'b',
  '`checkout.session.completed` fires when a Stripe Checkout session completes successfully — meaning the customer has paid and the payment is confirmed. This is the correct trigger for enrollment automation. `payment_intent.created` fires when a payment is initiated, not completed.',
  5),
(quiz_id,
  'An order bump on the checkout page typically converts at what rate?',
  '[{"id":"a","text":"1-5% of buyers"},{"id":"b","text":"5-10% of buyers"},{"id":"c","text":"20-40% of buyers"},{"id":"d","text":"60-80% of buyers"}]',
  'c',
  'A well-designed order bump — a relevant, low-friction add-on presented as a single checkbox on the checkout page — typically converts 20-40% of buyers. This makes it one of the highest-ROI elements in a certification funnel.',
  6),
(quiz_id,
  'What is "activation" in the context of online certification businesses?',
  '[{"id":"a","text":"The moment a student submits their final exam"},{"id":"b","text":"The moment a student completes their first meaningful learning action after enrolling"},{"id":"c","text":"The moment a student''s payment is processed by Stripe"},{"id":"d","text":"The moment a student receives their certificate"}]',
  'b',
  'Activation is when a student takes their first meaningful learning action — logging in and completing the first lesson or module. Students who activate in the first 7 days have dramatically higher completion rates and far lower refund rates.',
  7),
(quiz_id,
  'What industry data point makes activation in the first 7 days critical?',
  '[{"id":"a","text":"30-60% of online course purchasers never log in after the first week"},{"id":"b","text":"Most students complete online courses in the first 7 days"},{"id":"c","text":"Stripe processes refund requests automatically after 7 days"},{"id":"d","text":"Email open rates drop by 50% after the first week"}]',
  'a',
  'Industry data consistently shows 30-60% of online course purchasers never log in after the first week. These non-starters generate most refund requests and negative reviews. The entire onboarding sequence should drive toward activation in the first 7 days.',
  8),
(quiz_id,
  'What is the correct order for Stripe enrollment automation after a successful payment?',
  '[{"id":"a","text":"Send receipt → create account → trigger onboarding → log enrollment"},{"id":"b","text":"Log enrollment → send receipt → create account → trigger onboarding"},{"id":"c","text":"Create account → send login credentials → trigger onboarding sequence → log enrollment"},{"id":"d","text":"Trigger onboarding → create account → send login → send receipt"}]',
  'c',
  'The correct order is: create the student account → immediately send login credentials → trigger the onboarding email sequence → log the enrollment record. The student needs account access before the onboarding sequence begins.',
  9),
(quiz_id,
  'A student contacts support saying they never received their login email. What is the first step?',
  '[{"id":"a","text":"Immediately issue a refund to resolve the complaint"},{"id":"b","text":"Verify the payment was confirmed in Stripe before taking any account action"},{"id":"c","text":"Ask the student to re-purchase using a different email address"},{"id":"d","text":"Escalate to Stripe support"}]',
  'b',
  'Always verify the payment in Stripe first. If the payment is confirmed, manually create the account and send a password reset, then investigate the webhook failure. If payment is not confirmed, no enrollment obligation exists.',
  10),
(quiz_id,
  'Which element should be placed at the very top of the post-purchase welcome email?',
  '[{"id":"a","text":"A testimonial from a successful student"},{"id":"b","text":"A summary of everything included in the course"},{"id":"c","text":"The login link, prominently displayed before any other content"},{"id":"d","text":"The instructor''s biography and credentials"}]',
  'c',
  'The login link should be the first actionable element in the welcome email. Student excitement peaks in the first 10 minutes after purchase. Any friction or delay between purchase confirmation and course access permanently reduces activation rates.',
  11),
(quiz_id,
  'What is the target 30-day login rate for a professional certification program?',
  '[{"id":"a","text":"30%+"},{"id":"b","text":"50%+"},{"id":"c","text":"70%+"},{"id":"d","text":"90%+"}]',
  'c',
  'For professional certification programs targeting practitioners, a 30-day login rate of 70%+ is the target benchmark. If this rate falls below 50%, the problem is in the immediate post-purchase experience — the welcome email or the first-login UX.',
  12),
(quiz_id,
  'An "upsell" in a certification funnel is best described as:',
  '[{"id":"a","text":"A checkbox add-on presented on the checkout page before payment"},{"id":"b","text":"An offer for a related or higher-tier product made after the purchase is complete"},{"id":"c","text":"A discount offered to customers who request a refund"},{"id":"d","text":"A free bonus added to the offer to increase perceived value"}]',
  'b',
  'An upsell is an offer made after the purchase is complete — on the thank-you page or in the first post-purchase email. A pre-checkout add-on is an order bump. The distinction matters because upsells target the post-purchase emotional high, while order bumps target the purchase decision itself.',
  13),
(quiz_id,
  'Which of the following is the most effective format for a lead magnet in a compliance/regulatory niche?',
  '[{"id":"a","text":"A 200-page comprehensive guide to the entire regulatory framework"},{"id":"b","text":"A 5-day video challenge requiring daily commitment"},{"id":"c","text":"A specific checklist or scorecard deliverable in under 20 minutes that solves one urgent problem"},{"id":"d","text":"A free webinar requiring live attendance"}]',
  'c',
  'In compliance niches, a specific, fast-deliverable resource (checklist, scorecard, template) that solves one urgent problem outperforms comprehensive guides or live commitments. The lead magnet should be consumable in under 20 minutes and immediately applicable.',
  14),
(quiz_id,
  'Stripe''s Smart Retries feature is most valuable for:',
  '[{"id":"a","text":"Automatically issuing refunds for dissatisfied students"},{"id":"b","text":"Automatically retrying failed charges on optimized schedules to recover declined payments"},{"id":"c","text":"Automatically sending receipts for successful payments"},{"id":"d","text":"Automatically detecting fraud and blocking suspicious purchases"}]',
  'b',
  'Stripe Smart Retries uses machine learning to retry failed charges at optimized times (e.g., when the card issuer is most likely to approve). It recovers a meaningful percentage of failed payments that would otherwise require manual follow-up.',
  15)
ON CONFLICT DO NOTHING;

END $$;

-- ============================================================
-- CERT 15: Content Engine, Social Media Automation & Ads
-- ============================================================
DO $$
DECLARE
  cert_id   uuid;
  mod1_id   uuid;
  mod2_id   uuid;
  mod3_id   uuid;
  mod4_id   uuid;
  quiz_id   uuid;
BEGIN

SELECT id INTO cert_id FROM certifications WHERE cert_number = 15;
IF cert_id IS NULL THEN
  RAISE EXCEPTION 'Cert 15 not found — run 04_cert_seeds.sql first';
END IF;

UPDATE certifications SET
  learning_outcomes = ARRAY[
    'Build a content strategy for the rural finance niche that positions you as the authoritative expert',
    'Create a content production system that generates 20+ pieces of content per week from a single source',
    'Configure social media scheduling tools to publish content automatically across LinkedIn, Facebook, and email',
    'Design and launch a lead-generating paid ad campaign on Facebook or LinkedIn with a positive ROAS',
    'Write email nurture sequences that move subscribers from cold to ready-to-buy without manual intervention',
    'Measure content and ad performance using the metrics that actually predict revenue, not vanity metrics',
    'Build a repeatable audience growth system that compounds over time without requiring daily content creation'
  ],
  status = 'approved'
WHERE id = cert_id;

-- MODULE 1
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Content Strategy for the Rural Finance Niche',
  'Define your content positioning, choose your primary channel, and build a content calendar that establishes you as the go-to authority for USDA rural capital programs.',
  1, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod1_id FROM modules WHERE certification_id = cert_id AND sort_order = 1;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod1_id,
  'Content Strategy for Rural Finance Authority',
  'cert15-content-strategy-rural-finance',
  E'## Why Niche Authority Is a Business Asset\n\nIn a crowded information marketplace, generalists are invisible. Specialists are sought out. A certification business that publishes content specifically about USDA RMAP eligibility, RLF compliance, and rural microfinance occupies a niche so specific that there are almost no direct competitors. The rural finance compliance space is underserved by quality educational content — which means that a consistent, authoritative content presence builds market dominance quickly.\n\nContent authority compounds. Each piece of content you publish increases your search visibility, your social proof, and your audience''s trust. A library of 50 well-targeted articles or videos makes your certification program the obvious choice for anyone in your niche, even before they see a single ad.\n\n## Defining Your Content Positioning\n\nContent positioning answers: "Why should someone follow you specifically, rather than anyone else who covers this topic?"\n\nFor a USDA rural capital certification business, the positioning should be built on:\n\n1. **Regulatory specificity** — You cite the actual CFR provisions, not paraphrases. This is rare in the rural finance space and immediately differentiates you.\n2. **Practitioner perspective** — Your content is written for people who are actively doing this work, not academics studying it from a distance.\n3. **Actionability** — Every piece of content ends with something the reader can do today. Not "learn more about RMAP" but "here is the specific checklist item most applicants miss in Section E of the RMAP application."\n4. **Consistency of voice** — Use the same terminology your audience uses internally: "RMAP," "RLF," "microlender," "TA&T," "7 CFR 4280." This signals that you speak their language.\n\n## Choosing Your Primary Channel\n\nYou cannot build a strong content presence on every channel simultaneously. Choose one primary channel and one secondary channel. Dominate the primary before expanding.\n\n**LinkedIn — Best for B2B certification businesses targeting organizational decision-makers**\n- Rural nonprofit executive directors, CDFI officers, and rural development professionals are active on LinkedIn\n- Organic reach for text posts and articles is still strong in B2B niches\n- Professional credibility signals (certifications, titles, endorsements) carry weight\n- Long-form articles index in Google\n\n**Email newsletter — Best as a primary channel for direct monetization**\n- 100% deliverability to subscribers vs. algorithmic distribution on social\n- Email subscribers convert to buyers at 3-5x the rate of social followers\n- You own the list — no platform dependency risk\n- Works best combined with a social channel that drives subscribers\n\n**Facebook Groups — Best for community-driven content**\n- Many rural development professionals participate in Facebook groups focused on USDA programs\n- Posting valuable content in existing groups builds authority without building a following from scratch\n- Can seed your own group over time\n\n**YouTube — Best for search-driven long-form content**\n- "How to complete an RMAP application" is a search query. YouTube is the second-largest search engine.\n- Long-form video (10-20 minutes) allows deep dives into regulatory content\n- High production investment but long content lifespan\n\n**Recommendation for most certification businesses:** LinkedIn as primary, email as secondary.\n\n## The Content Pillar Framework\n\nA content pillar is a broad topic that your business owns. From each pillar, you derive dozens of specific content pieces. This prevents the blank-page problem and ensures your content always serves your audience.\n\n**Suggested content pillars for a USDA certification business:**\n\n1. **RMAP / RBDG application mechanics** — How-tos, checklists, scoring breakdowns, common mistakes\n2. **RLF compliance and operations** — Audit readiness, civil rights, 2 CFR 200, record retention\n3. **Underwriting and loan servicing** — Credit analysis, collections, workout strategies\n4. **Community impact and storytelling** — How rural borrowers use microloan capital, job creation stories\n5. **Certification business building** — For students who want to start their own certification business\n\n## Content Calendar Architecture\n\nA content calendar prevents the feast-or-famine content creation cycle. Set a publishing cadence you can maintain for 12+ months, not what you can do in your most motivated week.\n\n**Sustainable starting cadence:**\n- LinkedIn: 3 posts per week (Monday, Wednesday, Friday)\n- Email newsletter: 1 per week (Tuesday)\n- Long-form content (article or video): 1 per month\n\n**Monthly content planning process:**\n1. Choose one content pillar to focus on for the month\n2. Brainstorm 12 specific topics within that pillar (one per week of content)\n3. Write 4 email newsletters from those topics\n4. Repurpose each email newsletter into 3 LinkedIn posts\n5. Compile the month''s best content into one long-form article\n\nThis process generates 12 LinkedIn posts + 4 email newsletters + 1 article from approximately 4 hours of focused writing per month.',
  'Niche authority in rural finance is built through regulatory specificity, practitioner perspective, and consistent publishing on chosen channels. The content pillar framework generates months of content from a single planning session.',
  18, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 2
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Social Media Automation',
  'Set up scheduling tools and a content repurposing workflow that publishes across LinkedIn, Facebook, and email automatically from a single content creation session.',
  2, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod2_id FROM modules WHERE certification_id = cert_id AND sort_order = 2;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod2_id,
  'Automating Your Social Media Content Distribution',
  'cert15-social-media-automation',
  E'## The Content Distribution Trap\n\nMost content creators spend 80% of their time creating and 20% distributing. This ratio should be reversed. A single high-quality piece of content, distributed across multiple channels and repurposed into multiple formats, outperforms ten mediocre pieces published once and forgotten.\n\nAutomation is what makes this ratio achievable. Once your distribution infrastructure is set up, a 2-hour writing session on Monday becomes a week of content across three channels without additional effort.\n\n## The One-to-Many Content System\n\nThe core principle: create once, distribute everywhere.\n\n**Starting asset:** One 600-word email newsletter on a specific USDA compliance topic\n\n**Derived content:**\n- 3 LinkedIn text posts (each covering one section of the newsletter)\n- 1 LinkedIn article (the full newsletter, reformatted)\n- 3 Facebook Group posts (same LinkedIn posts, adapted for group context)\n- 1 Twitter/X thread (if your audience is there)\n- 1 short video script (the newsletter read aloud with key points highlighted)\n\nThis system turns one writing session into 8-9 pieces of content, all scheduled in advance.\n\n## Scheduling Tool Configuration\n\n**Buffer** — simplest setup, supports LinkedIn, Facebook, Instagram, Twitter. Free tier supports 3 channels + 10 scheduled posts. Paid plans start at $6/month. Best for: basic scheduling, small content volume.\n\n**Hootsuite** — more powerful, supports more channels, better analytics. More expensive ($99+/month for full features). Best for: teams managing multiple accounts.\n\n**Publer** — strong LinkedIn-specific features, supports LinkedIn articles and documents, good scheduling UI. Mid-range pricing. Best for: LinkedIn-heavy content strategies.\n\n**Zapier / Make.com + native APIs** — custom automation for sophisticated workflows (e.g., auto-post to LinkedIn when you publish an email in ConvertKit). Best for: technical users who want full control.\n\n**Setup steps for Buffer (representative process):**\n1. Connect LinkedIn company page and personal profile\n2. Connect Facebook page and relevant groups\n3. Set a posting schedule (e.g., LinkedIn posts at 8am Monday/Wednesday/Friday)\n4. Create a content queue: drag-and-drop scheduled posts fill the queue automatically\n5. Use the browser extension to queue content from any webpage in one click\n\n## Email Automation: ConvertKit / ActiveCampaign Setup\n\nEmail newsletters should also be pre-scheduled, not sent ad hoc. Most professional email platforms support advance scheduling:\n\n**ConvertKit setup for weekly newsletter:**\n1. Create a "Newsletter Subscribers" segment\n2. Write and schedule the newsletter 7 days in advance\n3. Set the send time to Tuesday at 9am (high open-rate window for B2B audiences)\n4. Tag subscribers who click specific links (used for behavioral segmentation later)\n5. Set up a broadcast report to review open rates and click rates the day after sending\n\n**Behavioral automation (advanced):**\nIf a subscriber clicks a link about RMAP applications three times, they are clearly interested in that topic. Tag them as "RMAP Intent" and trigger a targeted sequence that offers the RMAP certification. This behavioral segmentation converts at 2-3x the rate of untargeted broadcasts.\n\n## The Weekly Content Workflow\n\nDocument this as a repeatable SOP:\n\n**Monday (2 hours):**\n- Write the week''s email newsletter (600-800 words)\n- Extract 3 key points → write 3 LinkedIn posts (150-300 words each)\n- Schedule all 4 pieces in Buffer and ConvertKit\n\n**Tuesday:** Email newsletter sends automatically\n**Wednesday:** LinkedIn post 1 publishes automatically\n**Thursday:** Nothing required\n**Friday:** LinkedIn posts 2 and 3 publish automatically\n\n**Monthly (2 hours):**\n- Compile the month''s best newsletter into a long-form LinkedIn article\n- Review content performance: which posts got the most engagement and link clicks?\n- Plan next month''s content calendar based on what resonated\n\n## Measuring Content Performance\n\nVanity metrics (likes, followers) do not predict revenue. Track these metrics instead:\n\n**Email newsletter:**\n- **Open rate** — Target 30%+ for a B2B professional audience. Below 20% means your subject lines need work.\n- **Click rate** — Target 3-5%+. This measures how many subscribers are taking action from your content.\n- **Subscriber growth rate** — Net new subscribers per week. This is your top-of-funnel health metric.\n- **Unsubscribe rate** — Below 0.5% per email is healthy. Above 1% means your content is not matching subscriber expectations.\n\n**LinkedIn:**\n- **Profile views** — Are more people clicking to view your profile after engaging with your content?\n- **Connection requests from target audience** — Vanity followers (unrelated industries) do not matter.\n- **Direct messages about your services** — The ultimate leading indicator of content effectiveness.\n- **Link clicks** — How many people are clicking through to your lead magnet or sales page?',
  'A one-to-many content system turns one writing session into 8-9 scheduled pieces across multiple channels. Scheduling tools and behavioral email automation distribute content without daily manual effort.',
  16, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 3
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Paid Advertising Fundamentals',
  'Design and launch a lead-generating paid ad campaign on Facebook or LinkedIn. Covers audience targeting, ad creative, budget management, and ROAS optimization.',
  3, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod3_id FROM modules WHERE certification_id = cert_id AND sort_order = 3;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod3_id,
  'Paid Advertising for Certification Businesses',
  'cert15-paid-advertising-fundamentals',
  E'## Organic vs. Paid: When to Add Ads\n\nPaid advertising should not be your first growth channel. Ads amplify what is already working — they do not fix a broken offer or an unclear message. Before running ads:\n\n1. Your offer converts organically (you have made at least 5-10 sales without ads)\n2. You have a proven lead magnet with a 30%+ opt-in rate on organic traffic\n3. You have a nurture sequence that converts leads to buyers (even at a small scale)\n4. You know your cost per lead and cost per acquisition from organic efforts\n\nOnce these are confirmed, ads let you pour fuel on a fire that is already burning.\n\n## Facebook Ads for Rural Finance Audiences\n\nFacebook''s targeting is interest- and behavior-based. For USDA certification offers, the most effective targeting approaches:\n\n**Interest targeting:**\n- Community Development Financial Institutions (CDFIs)\n- Nonprofit management\n- Small Business Administration\n- Rural development\n- Microfinance\n- Grant writing / grant management\n\n**Behavioral targeting:**\n- Job title targeting (Executive Director, Program Officer, Loan Officer)\n- Organization type (nonprofit, government agency)\n\n**Lookalike audiences (most powerful):**\nUpload your existing buyer email list to Facebook. Facebook identifies the common characteristics of your buyers and finds similar users. A 1% lookalike of 100+ buyers typically outperforms interest targeting significantly.\n\n**Campaign structure for a lead magnet funnel:**\n- **Campaign objective:** Lead Generation or Traffic (to landing page)\n- **Ad Set 1:** Interest targeting — rural/CDFI/nonprofit audience\n- **Ad Set 2:** Lookalike audience (1%) if you have buyer data\n- **Ad Set 3:** Retargeting — people who visited your sales page but did not buy\n- **Budget:** $15-30/day per ad set during testing; scale ad sets that produce leads under target CPL\n\n## LinkedIn Ads for Professional Audiences\n\nLinkedIn ads are more expensive (typical CPCs of $5-15 vs. $0.50-3 on Facebook) but reach a more precisely defined professional audience. LinkedIn''s targeting by job title, seniority, industry, and organization size is unmatched.\n\n**Recommended LinkedIn ad formats for certification businesses:**\n\n- **Single image ads:** Promote your lead magnet. Target: Executive Directors, Program Directors, Loan Officers at nonprofits, CDFIs, community development organizations in rural states.\n- **Lead Gen Forms:** LinkedIn''s native lead capture (pre-fills name/email from LinkedIn profile). Lower friction than landing page opt-in. Works well for lead magnet delivery.\n- **Thought Leadership ads (Sponsored Content from personal profile):** Promote your best-performing organic posts as ads. These look native and build personal brand while generating leads.\n\n**LinkedIn campaign structure:**\n- **Campaign Group:** Lead Generation\n- **Campaign 1:** Job title targeting (Loan Officer, Program Officer, Executive Director) + Industry (Nonprofit, Government Administration)\n- **Campaign 2:** Organization follower retargeting (people who follow your company page)\n- **Daily budget:** $50+ minimum for LinkedIn (the platform''s algorithm needs volume to optimize)\n\n## Ad Creative Fundamentals\n\nFor lead magnet promotion ads, the creative formula:\n\n**Headline:** Name the specific outcome of the lead magnet\n- Strong: "Get the 23-Point RMAP Application Checklist"\n- Weak: "Free download for nonprofit professionals"\n\n**Body copy:** Address the audience directly, name their pain, promise the specific solution\n- "Preparing a USDA RMAP application? Most rural nonprofits miss these scoring criteria — download our checklist to see exactly what USDA reviewers look for."\n\n**Image/creative:** Simple, high-contrast images of the deliverable (a mockup of the checklist or template) outperform stock photos of happy people in most B2B niches.\n\n**CTA:** "Download Now" or "Get the Checklist" — specific beats generic ("Learn More")\n\n## Budget Management and Scaling\n\n**Testing phase (first 2-4 weeks):**\n- Run 3-4 ad sets at $15-20/day each\n- Minimum 1,000 impressions per ad set before drawing conclusions\n- Pause ad sets with CPL (cost per lead) above your target after 500+ impressions\n- Keep ad sets with CPL below target and test new creative against them\n\n**Scaling:**\n- Increase budget by 20-30% every 3-5 days on winning ad sets\n- Do not double or triple budgets overnight — this resets the learning phase\n- Once an ad set is proven, create a duplicate with a different audience to test expansion\n\n**Key metrics to track:**\n- **CPL (Cost Per Lead):** Total ad spend ÷ leads generated. Target varies by offer price; for a $497 certification, a CPL under $20-30 is typically viable.\n- **Lead-to-buyer conversion rate:** What percentage of ad leads eventually purchase? Multiply by average order value to calculate LTV per lead.\n- **ROAS (Return on Ad Spend):** Revenue generated ÷ ad spend. A ROAS of 3+ means you generate $3 for every $1 in ad spend.\n\n## Retargeting: The Highest-ROAS Campaigns\n\nRetargeting ads show to people who have already visited your website or sales page but did not buy. These audiences are small but highly qualified — they know you exist and showed intent.\n\n**Retargeting audiences to build:**\n- Sales page visitors who did not reach the thank-you page\n- Email subscribers who clicked a sales link but did not purchase\n- Video viewers who watched 75%+ of a content video\n\nRetargeting CPCs are lower and conversion rates are higher than cold audience campaigns. Always have a retargeting campaign running once you have sufficient website traffic (500+ unique visitors/month).',
  'Run paid ads only after your offer converts organically. Facebook interest and lookalike targeting, LinkedIn job title targeting, and retargeting campaigns form a three-layer paid acquisition system for certification businesses.',
  20, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 4
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Email Nurture Sequences & Audience Building',
  'Build automated email sequences that move subscribers from cold to ready-to-buy, and design a compound audience growth system that reduces dependence on paid traffic.',
  4, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod4_id FROM modules WHERE certification_id = cert_id AND sort_order = 4;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod4_id,
  'Email Sequences and Long-Term Audience Building',
  'cert15-email-sequences-audience-building',
  E'## Email as the Core Revenue Channel\n\nSocial media platforms change their algorithms, reduce organic reach, and can suspend your account without warning. Email is the only channel where you have a direct, owned relationship with your audience. A list of 2,000 highly targeted subscribers in the rural finance niche can generate $15,000-$50,000/year in certification revenue with consistent, strategic email marketing.\n\nThe goal of every other channel — social media, ads, content — is to grow your email list. Email is where the revenue actually happens.\n\n## The Four Email Sequence Types\n\n### 1. Welcome / Lead Magnet Delivery Sequence (5-7 emails, 12 days)\nTrigger: New subscriber opts in to receive a lead magnet.\nPurpose: Deliver the lead magnet, establish authority, introduce your paid offers.\nStructure: Covered in depth in Cert 14. Key addition for a content-heavy business: include links to your 3 best pieces of existing content in the nurture emails.\n\n### 2. Evergreen Sales Sequence (7-10 emails, 14-21 days)\nTrigger: Subscriber completes the welcome sequence without purchasing.\nPurpose: Convert subscribers to buyers through a focused sales campaign.\n\n**Evergreen sales sequence structure:**\n- **Day 1:** "I want to share something with you" — introduce the certification with a story\n- **Day 2:** Teach the most valuable single insight from the certification (value bomb)\n- **Day 3:** Present the offer with full curriculum overview and pricing\n- **Day 4:** Address the #1 objection ("Is this right for my organization?")\n- **Day 5:** Case study or detailed outcome description\n- **Day 6:** Urgency/scarcity if using an enrollment window; otherwise another objection addressed\n- **Day 7:** "Last chance" framing — "I don''t want to keep emailing about this"\n- **Day 8+:** Return to newsletter/broadcast email; re-enter a different evergreen sequence in 60-90 days\n\n### 3. Re-engagement Sequence (3 emails)\nTrigger: Subscriber has not opened an email in 90 days.\nPurpose: Re-engage or clean the list.\n\n- **Email 1:** "Are you still interested in [topic]?" — curiosity subject line, ask if they still want to receive emails\n- **Email 2 (3 days later):** "One last thing before I stop emailing" — share a genuinely valuable resource\n- **Email 3 (3 days later):** "I''m going to remove you from my list" — unsubscribers who do not click a "keep me subscribed" link are removed\n\nCleaning your list of unengaged subscribers improves deliverability and open rates for your active subscribers.\n\n### 4. Post-Purchase / Certification Completion Sequence\nTrigger: Student completes a certification.\nPurpose: Congratulate, deliver the credential, and introduce the next certification in the track.\n\n- **Email 1:** Congratulations + credential delivery instructions\n- **Email 2 (3 days):** "What comes next" — introduce the next certification and the master credential it contributes to\n- **Email 3 (7 days):** Testimonial request or referral invitation\n- **Email 4 (14 days):** Limited-time discount on the next certification\n\n## Audience Building: The Compound Growth System\n\nA compound audience growth system is one where each piece of content you publish builds on the last — growing your list, your authority, and your search visibility simultaneously.\n\n**The four-layer compound system:**\n\n**Layer 1: Evergreen content**\nPublish long-form content (articles, YouTube videos) targeting specific search queries your audience uses. "USDA RMAP eligibility requirements," "how to start a revolving loan fund," "2 CFR 200 compliance for nonprofits." These pieces generate organic traffic indefinitely.\n\n**Layer 2: Lead magnet conversion**\nEvery piece of evergreen content should include a prominent call-to-action to download a related lead magnet. A reader who found your RMAP article via Google and downloads your RMAP checklist is already highly qualified.\n\n**Layer 3: Social amplification**\nRepurpose evergreen content into social posts that drive additional traffic to the original article. Each social post extends the reach of content you already created.\n\n**Layer 4: Email monetization**\nEvery subscriber who enters from any layer above enters the same welcome and evergreen sales sequence. The system runs without ongoing manual work once built.\n\n## List Segmentation for Higher Revenue\n\nA list of 2,000 unsegmented subscribers is worth less than a list of 1,500 properly segmented subscribers. Segment on:\n\n- **Certification interest:** Which certifications has this subscriber engaged with? (Based on link clicks)\n- **Organization type:** Nonprofit, CDFI, government agency, consultant\n- **Funnel stage:** New subscriber, lead magnet downloaded, sales page visited, buyer\n- **Geographic region:** Rural state regions matter for USDA program relevance\n\nUse tags in ConvertKit or ActiveCampaign to segment based on behavior (link clicks, page visits, purchase history). Segment-specific emails convert at 2-3x the rate of unsegmented broadcasts.\n\n## Deliverability Basics\n\nNone of your email automation matters if your emails land in spam. Maintain deliverability:\n\n- **Authenticate your domain** (SPF, DKIM, DMARC records in DNS) — required for deliverability to Google/Yahoo inboxes\n- **Send consistently** — sporadic sending (weeks between emails) hurts deliverability\n- **Clean your list** — remove subscribers who have not opened in 6+ months\n- **Never buy lists** — purchased lists are full of spam traps and will get your account suspended\n- **Use a professional sending domain** — send from hello@yourdomain.com, not from a Gmail/Outlook personal address',
  'Email is the only owned channel in a certification business. Four sequence types (welcome, evergreen sales, re-engagement, post-purchase) combined with a compound audience growth system create sustainable, algorithm-proof revenue.',
  16, 1, 'approved')
ON CONFLICT DO NOTHING;

-- QUIZ for Cert 15
INSERT INTO quizzes (id, certification_id, title, passing_score, status)
VALUES (uuid_generate_v4(), cert_id,
  'Content Engine, Social Media & Ads Knowledge Check',
  80, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO quiz_id FROM quizzes WHERE certification_id = cert_id;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order)
VALUES
(quiz_id,
  'What is the primary reason niche authority compounds over time?',
  '[{"id":"a","text":"Social media algorithms favor niche accounts over general accounts"},{"id":"b","text":"Each piece of content increases search visibility, social proof, and audience trust, building on the last"},{"id":"c","text":"Niche content is cheaper to produce than general content"},{"id":"d","text":"Regulatory niches have less competition from large media companies"}]',
  'b',
  'Niche authority compounds because each published piece adds to a library of search-visible, trust-building content. The 50th article makes the 1st more credible. This is why consistent publishing in a narrow niche builds market dominance faster than sporadic publishing in a broad niche.',
  1),
(quiz_id,
  'In the one-to-many content system, what is the "starting asset"?',
  '[{"id":"a","text":"A LinkedIn article published organically"},{"id":"b","text":"A paid ad campaign driving traffic to a lead magnet"},{"id":"c","text":"A single email newsletter that is repurposed into multiple formats across channels"},{"id":"d","text":"A YouTube video that is transcribed into blog posts"}]',
  'c',
  'The one-to-many system starts with one email newsletter (600-800 words) and derives LinkedIn posts, articles, social posts, and video scripts from it. This maximizes content output from a single writing session.',
  2),
(quiz_id,
  'For a B2B certification business targeting rural nonprofit professionals, which primary channel is recommended?',
  '[{"id":"a","text":"TikTok"},{"id":"b","text":"Instagram"},{"id":"c","text":"LinkedIn"},{"id":"d","text":"Pinterest"}]',
  'c',
  'LinkedIn is recommended as the primary channel because rural nonprofit executive directors, CDFI officers, and rural development professionals are active there. Professional credibility signals carry weight, organic reach for text posts remains strong, and LinkedIn articles index in Google.',
  3),
(quiz_id,
  'What is a "content pillar" in content strategy?',
  '[{"id":"a","text":"The most important article on your website"},{"id":"b","text":"A broad topic your business owns, from which you derive dozens of specific content pieces"},{"id":"c","text":"The primary social media channel you publish on"},{"id":"d","text":"A long-form video series covering your certification curriculum"}]',
  'b',
  'A content pillar is a broad topic area your business owns — for example, "RMAP application mechanics." From that pillar, you can derive dozens of specific posts, articles, and videos without facing the blank-page problem.',
  4),
(quiz_id,
  'What is the key difference between an email open rate and a click rate?',
  '[{"id":"a","text":"Open rate measures mobile opens; click rate measures desktop clicks"},{"id":"b","text":"Open rate measures how many subscribers opened the email; click rate measures how many took action by clicking a link"},{"id":"c","text":"Open rate is tracked by the sender; click rate is self-reported by subscribers"},{"id":"d","text":"Open rate and click rate measure the same thing using different methodologies"}]',
  'b',
  'Open rate measures the percentage of subscribers who opened your email. Click rate measures the percentage who clicked a link inside it. Click rate is a stronger engagement signal because it requires active intent, not just an accidental preview-pane open.',
  5),
(quiz_id,
  'Before running paid ads, what must be true about your certification offer?',
  '[{"id":"a","text":"You must have a minimum advertising budget of $5,000"},{"id":"b","text":"Your offer must already convert organically, with a proven lead magnet and nurture sequence"},{"id":"c","text":"You must have at least 10,000 social media followers"},{"id":"d","text":"You must have a minimum of 100 email subscribers"}]',
  'b',
  'Ads amplify what is already working — they do not fix a broken offer. Before running ads, your offer must convert organically (5-10 sales without ads), your lead magnet must have a 30%+ opt-in rate, and your nurture sequence must convert leads to buyers.',
  6),
(quiz_id,
  'What is a "lookalike audience" in Facebook advertising?',
  '[{"id":"a","text":"An audience that sees ads that look like organic content"},{"id":"b","text":"An audience Facebook builds by identifying users who share characteristics with your existing buyers"},{"id":"c","text":"An audience targeting people who have visited your website"},{"id":"d","text":"A duplicate of an existing ad set used for A/B testing"}]',
  'b',
  'A lookalike audience is built by uploading your buyer email list to Facebook. Facebook identifies the common characteristics of those buyers and finds similar users in its database. A 1% lookalike of 100+ buyers typically outperforms interest targeting.',
  7),
(quiz_id,
  'What does ROAS stand for, and what does a ROAS of 3 mean?',
  '[{"id":"a","text":"Return on Ad Spend; you generate $3 in revenue for every $1 spent on ads"},{"id":"b","text":"Rate of Ad Success; 3 out of 10 ad clicks result in a purchase"},{"id":"c","text":"Reach of Ad Set; your ads reached 3x your target audience size"},{"id":"d","text":"Revenue over Ad Spend; your ad revenue exceeds your ad spend by $3"}]',
  'a',
  'ROAS (Return on Ad Spend) = Revenue ÷ Ad Spend. A ROAS of 3 means you generate $3 in revenue for every $1 spent on advertising. For certification businesses, a ROAS of 3+ is typically the minimum for a sustainable paid acquisition strategy.',
  8),
(quiz_id,
  'Why should you not increase an ad set budget by 100% overnight when scaling?',
  '[{"id":"a","text":"Facebook charges a penalty fee for rapid budget increases"},{"id":"b","text":"Doubling the budget resets the algorithm''s learning phase, causing performance to temporarily drop"},{"id":"c","text":"Rapid budget increases violate Facebook''s terms of service"},{"id":"d","text":"It depletes the retargeting audience too quickly"}]',
  'b',
  'Facebook''s algorithm requires a "learning phase" to optimize delivery. Doubling the budget resets this phase, causing CPL and ROAS to temporarily worsen as the algorithm re-learns. Scale by 20-30% every 3-5 days to maintain performance.',
  9),
(quiz_id,
  'What is the purpose of a re-engagement email sequence?',
  '[{"id":"a","text":"To welcome new subscribers and deliver their lead magnet"},{"id":"b","text":"To re-engage subscribers who have not opened emails in 90 days, or remove them from the list"},{"id":"c","text":"To upsell current students into higher-priced certifications"},{"id":"d","text":"To announce new course launches to the entire subscriber list"}]',
  'b',
  'A re-engagement sequence targets subscribers who have not opened emails in 90+ days. It attempts to re-engage them with high-value content. Those who still do not engage are removed from the list, which improves deliverability and open rates for active subscribers.',
  10),
(quiz_id,
  'Which DNS records are required to authenticate your email sending domain for inbox deliverability?',
  '[{"id":"a","text":"A record, CNAME, MX"},{"id":"b","text":"SPF, DKIM, DMARC"},{"id":"c","text":"TXT, NS, SOA"},{"id":"d","text":"PTR, SRV, CAA"}]',
  'b',
  'SPF (Sender Policy Framework), DKIM (DomainKeys Identified Mail), and DMARC (Domain-based Message Authentication) are the three DNS records required to authenticate your email domain. Without these, emails are likely to be flagged as spam by Gmail and Yahoo.',
  11),
(quiz_id,
  'In an evergreen sales email sequence, when should the offer first be presented?',
  '[{"id":"a","text":"Email 1 — immediately after the subscriber is added to the sequence"},{"id":"b","text":"Email 3 — after one teaching email and one story email"},{"id":"c","text":"Email 7 — after the full sequence has built maximum trust"},{"id":"d","text":"After the subscriber has been on the list for 30 days"}]',
  'b',
  'In a 7-10 email evergreen sales sequence, the offer is typically introduced in Email 3 — after Email 1 (story/introduction) and Email 2 (value/teaching email). This timing allows trust to build before the sales pitch without delaying so long that interest wanes.',
  12),
(quiz_id,
  'What is the primary purpose of behavioral email segmentation (tagging based on link clicks)?',
  '[{"id":"a","text":"To comply with GDPR email marketing regulations"},{"id":"b","text":"To identify subscribers showing intent signals and send targeted offers that convert at higher rates"},{"id":"c","text":"To reduce the number of emails sent to the entire list"},{"id":"d","text":"To track which subscribers have purchased a certification"}]',
  'b',
  'Behavioral segmentation identifies subscribers who have shown intent — clicking links about specific certifications, visiting sales pages, downloading related lead magnets. These subscribers receive targeted sequences that convert at 2-3x the rate of untargeted broadcasts.',
  13),
(quiz_id,
  'A sustainable starting content publishing cadence for a certification business is:',
  '[{"id":"a","text":"1 LinkedIn post per day, 3 emails per week, 1 YouTube video per week"},{"id":"b","text":"3 LinkedIn posts per week, 1 email newsletter per week, 1 long-form piece per month"},{"id":"c","text":"5 LinkedIn posts per day, 1 email per day, 4 videos per week"},{"id":"d","text":"1 post per week across all platforms combined"}]',
  'b',
  'A sustainable starting cadence is 3 LinkedIn posts per week + 1 email newsletter per week + 1 long-form content piece per month. This generates consistent audience growth without requiring a full-time content team, and can be maintained for 12+ months.',
  14),
(quiz_id,
  'What makes retargeting campaigns typically higher-ROAS than cold audience campaigns?',
  '[{"id":"a","text":"Retargeting ads are automatically discounted by Facebook"},{"id":"b","text":"Retargeting audiences are smaller, which reduces ad spend automatically"},{"id":"c","text":"Retargeting shows ads to people who already know you and showed intent, resulting in lower CPCs and higher conversion rates"},{"id":"d","text":"Retargeting campaigns use first-party data which has higher accuracy than interest targeting"}]',
  'c',
  'Retargeting audiences (sales page visitors, email link clickers, video viewers) already know your brand and have shown intent. Their familiarity and self-selection results in lower CPCs and significantly higher conversion rates than cold audiences seeing your ads for the first time.',
  15)
ON CONFLICT DO NOTHING;

END $$;

-- ============================================================
-- CERT 16: CRM, Applications, Customer Success & Business Operations
-- ============================================================
DO $$
DECLARE
  cert_id   uuid;
  mod1_id   uuid;
  mod2_id   uuid;
  mod3_id   uuid;
  mod4_id   uuid;
  quiz_id   uuid;
BEGIN

SELECT id INTO cert_id FROM certifications WHERE cert_number = 16;
IF cert_id IS NULL THEN
  RAISE EXCEPTION 'Cert 16 not found — run 04_cert_seeds.sql first';
END IF;

UPDATE certifications SET
  learning_outcomes = ARRAY[
    'Configure a CRM to manage leads, applications, and students through a defined pipeline with automated stage triggers',
    'Build an application review workflow that evaluates applicants consistently and communicates decisions professionally',
    'Design a customer success program that reduces churn, increases completion rates, and generates referrals',
    'Establish refund handling, dispute management, and complaint resolution SOPs that protect revenue and reputation',
    'Build financial reporting systems that give you weekly visibility into revenue, expenses, and business health',
    'Create an organizational chart and hiring roadmap for scaling from solo operator to a small team',
    'Document all core business processes in SOPs that allow delegation without quality loss'
  ],
  status = 'approved'
WHERE id = cert_id;

-- MODULE 1
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'CRM Setup and Pipeline Automation',
  'Choose and configure a CRM for your certification business. Build lead and student pipelines with automated stage transitions, task reminders, and communication templates.',
  1, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod1_id FROM modules WHERE certification_id = cert_id AND sort_order = 1;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod1_id,
  'CRM Configuration for a Certification Business',
  'cert16-crm-setup-automation',
  E'## What a CRM Does for a Certification Business\n\nA CRM (Customer Relationship Management) system is the operational backbone of a certification business. It tracks every lead, application, and student through a defined pipeline, automates routine communications, and ensures nothing falls through the cracks when you are managing dozens or hundreds of relationships simultaneously.\n\nWithout a CRM, a certification business at scale operates on memory, inbox search, and spreadsheets — systems that break the moment volume exceeds what one person can hold in their head.\n\n## Choosing a CRM\n\nFor a certification business generating under $500K/year, three CRMs cover most needs:\n\n**HubSpot CRM (Free tier)**\nExcellent free tier. Pipelines, contact management, email tracking, deal stages, basic automation. Integrates with Gmail/Outlook. Upgrade to Starter ($20/month) for more automation. Best for: solo operators or small teams just getting started.\n\n**ActiveCampaign**\nEmail automation + CRM combined. If you are already using ActiveCampaign for email, adding the CRM layer eliminates the need for a separate tool. Strong behavioral triggers (move a deal stage when a subscriber clicks a specific email link). $49-$149/month depending on contact count. Best for: businesses that want email + CRM in one platform.\n\n**GoHighLevel**\nAll-in-one: CRM + email + SMS + funnel builder + calendar + pipeline. Popular with certification businesses because it replaces 4-5 separate tools. Steep learning curve. $97-$297/month. Best for: businesses ready to consolidate tools and willing to invest setup time.\n\n## Building Your Lead Pipeline\n\nA pipeline is a series of stages that represent where a lead or student is in their relationship with your business. Each stage has specific actions required to move to the next stage.\n\n**Recommended lead pipeline stages:**\n\n1. **New Lead** — opted in, received lead magnet, in welcome sequence\n2. **Engaged** — opened 3+ emails or clicked a sales link\n3. **Application Submitted** — submitted an application for a certification program (if you use applications)\n4. **Proposal Sent** — received a custom proposal or enrollment link\n5. **Enrolled** — purchased and active\n6. **Completed** — finished certification, credential issued\n7. **Referral/Alumni** — active alumni, potential referral source\n\n**Automated stage triggers:**\n- Lead opens 3 emails within 7 days → automatically move to "Engaged," notify sales team\n- Lead clicks sales page link → tag as "Sales Intent," trigger targeted sales sequence\n- Payment confirmed in Stripe → webhook moves lead to "Enrolled" automatically\n- Student completes final quiz → move to "Completed," trigger credential email\n\n## Contact Records: What to Track\n\nEvery contact record in your CRM should capture:\n\n**Identification:**\n- Full name, email, phone\n- Organization name and type (nonprofit, CDFI, government)\n- State / rural designation\n- LinkedIn URL\n\n**Relationship data:**\n- Lead source (which ad, content piece, or referral brought them in)\n- Lead magnet downloaded\n- Certifications enrolled in\n- Certifications completed\n- Total revenue (lifetime)\n\n**Engagement data:**\n- Last email open date\n- Last login date (if using Supabase, sync this via webhook)\n- Support tickets or complaints\n- Referrals sent\n\n**Notes:**\nFree-text field for anything that does not fit a structured field. "Spoke on phone 2026-03-15 — interested in full RLF practitioner track, budget decision in Q2." Notes prevent the "who is this person again?" problem when you or a team member follows up months later.\n\n## Automation Rules to Build First\n\n**Rule 1: New lead welcome**\nTrigger: Contact created with source tag "Lead Magnet"\nAction: Assign to welcome sequence in email platform (via Zapier or native integration)\n\n**Rule 2: Sales intent alert**\nTrigger: Contact clicks sales page link 2+ times in 7 days\nAction: Create task for follow-up → send "Did you have any questions?" email\n\n**Rule 3: Enrollment confirmation**\nTrigger: Stripe webhook fires checkout.session.completed\nAction: Move contact to "Enrolled" stage → remove from sales sequences → add to student onboarding sequence → log enrollment date and certification purchased\n\n**Rule 4: Completion trigger**\nTrigger: Student passes final quiz (webhook from course platform)\nAction: Move to "Completed" → trigger credential delivery email → create task "Send congratulations note in 3 days"\n\n**Rule 5: 90-day re-engagement**\nTrigger: Contact last email open date > 90 days\nAction: Add to re-engagement sequence → if still no open after 14 days, tag as "Cold" and pause all sequences\n\n## Task Management Within the CRM\n\nA task in the CRM is a reminder attached to a specific contact that requires a human action. Use tasks for anything that automation cannot handle:\n\n- "Call to check in on application progress" (scheduled 7 days after application submitted)\n- "Send congratulations note" (scheduled 3 days after completion)\n- "Offer alumni discount on next certification" (scheduled 30 days after completion)\n- "Follow up on unpaid invoice" (for organizations being invoiced rather than self-serve checkout)\n\nA daily CRM task review (5-10 minutes each morning) ensures no relationship falls through the cracks.',
  'A CRM pipeline with automated stage triggers tracks every lead and student relationship. Build pipelines for lead → enrolled → completed, with automation rules that eliminate manual stage management.',
  18, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 2
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Application Management',
  'Design and operate an application review process for selective certification programs. Covers application form design, review rubrics, decision communication, and waitlist management.',
  2, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod2_id FROM modules WHERE certification_id = cert_id AND sort_order = 2;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod2_id,
  'Running a Selective Application Process',
  'cert16-application-management',
  E'## When to Use an Application Process\n\nNot every certification needs an application. A self-paced $497 course with open enrollment should not require an application — the friction will reduce conversion rates without adding value. Applications are appropriate when:\n\n1. **The program is selective** — you have limited cohort capacity and genuine selection criteria\n2. **The program is high-investment** — $1,500+ programs with significant student time commitment benefit from an application that screens for commitment\n3. **The transformation requires organizational readiness** — USDA certification programs where the student needs an existing or planned RLF to apply the content\n4. **You want premium positioning** — "application required" signals exclusivity and increases perceived value\n\nFor Cap Fund Academy certifications at the $497-$997 price point with open enrollment, an application is optional. For the $997 Master Capstone with limited cohort size and instructor feedback, an application is appropriate.\n\n## Application Form Design\n\nA certification program application should be long enough to screen for fit, short enough to complete in 15 minutes.\n\n**Core application fields:**\n\n**Organization context:**\n- Organization name and type\n- Organization''s primary mission\n- Years in operation\n- Annual budget range\n- Number of full-time staff\n- Primary service area (state, rural/urban designation)\n\n**USDA program context:**\n- Which USDA programs is your organization currently applying for or operating?\n- Do you currently operate or plan to operate a Revolving Loan Fund?\n- What is your organization''s current stage in the USDA application process?\n\n**Applicant context:**\n- Applicant name and title\n- Role in the USDA application or RLF operation\n- Decision-making authority for program participation\n- How did you hear about Cap Fund Academy?\n\n**Commitment questions:**\n- How many hours per week can you dedicate to this certification program?\n- What specific outcome do you want to achieve by completing this certification?\n- What is your timeline for submitting your USDA application or achieving operational compliance?\n\n**Open-ended:**\n- "Tell us in 2-3 sentences why your organization is a strong fit for this program."\n\n## Application Review Rubric\n\nA rubric makes application decisions consistent, defensible, and delegable. Score each application on the same criteria.\n\n**Sample rubric for USDA certification programs (100 points total):**\n\n| Criterion | Max Points | Scoring Guide |\n|-----------|-----------|---------------|\n| Organizational fit (existing or planned RLF/RMAP activity) | 25 | 25=active applicant or operator, 15=planning within 12 months, 5=exploring |\n| Decision-maker authority (can implement learnings) | 20 | 20=ED or program director, 10=staff with ED support, 5=staff without clear authority |\n| Timeline urgency (active USDA process) | 20 | 20=application in process, 10=planning within 6 months, 5=12+ month timeline |\n| Commitment capacity (hours available) | 20 | 20=8+ hours/week, 10=4-8 hours, 5=under 4 hours |\n| Quality of outcome statement | 15 | 15=specific measurable outcome, 8=general aspiration, 3=vague |\n\nApplicants scoring 75+ are accepted. 50-74 are waitlisted or offered a consultation call. Under 50 are declined with a referral to a more appropriate starting point.\n\n## Communicating Decisions\n\n**Acceptance email template elements:**\n- Congratulate specifically (reference their application answer)\n- Confirm the program, cohort dates, and investment amount\n- Provide a clear enrollment link with a deadline (48-72 hours) to hold their spot\n- Include next steps after enrollment\n\n**Waitlist email template elements:**\n- Acknowledge their application positively\n- Explain the waitlist without making them feel rejected\n- Set a specific timeline for when waitlist decisions will be made\n- Offer an alternative (a lower-investment starting certification, a free resource)\n\n**Decline email template elements:**\n- Thank them for applying\n- Be honest but kind about the reason\n- Offer a clear path forward (e.g., "We recommend starting with Cert 1 — Microfinance Foundations, which does not require an existing RLF program")\n- Leave the door open: "We would love to have you reapply when [specific condition is met]"\n\nNever ghost applicants. A declined applicant who receives a thoughtful email with a clear alternative path often becomes a future student.\n\n## Waitlist and Cohort Management\n\n**Waitlist best practices:**\n- Maintain a waitlist order in your CRM (date/time of application)\n- Set a defined notification timeline: "We will notify waitlisted applicants by [date]"\n- When a spot opens, offer it to the next person on the waitlist with a 24-hour acceptance window\n- After two unanswered offers, move to the next waitlisted applicant\n\n**Cohort management:**\n- Set cohort start dates in advance (quarterly cohorts create enrollment urgency)\n- Define cohort size limits before applications open\n- Send cohort-specific communications: "Your cohort begins [date]. Here is what to expect."\n- Create cohort-specific community spaces (Slack channel, Circle group, Zoom calls) to build peer relationships that increase retention',
  'Use application processes for selective, high-investment programs. A scoring rubric ensures consistent decisions. Acceptance, waitlist, and decline emails all serve future revenue — never ghost applicants.',
  16, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 3
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Customer Success Workflows',
  'Build proactive customer success systems that increase completion rates, reduce churn, handle complaints professionally, and turn graduates into referral sources.',
  3, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod3_id FROM modules WHERE certification_id = cert_id AND sort_order = 3;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod3_id,
  'Customer Success for Certification Businesses',
  'cert16-customer-success',
  E'## Customer Success vs. Customer Support\n\nCustomer support is reactive — it responds when something goes wrong. Customer success is proactive — it anticipates where students get stuck, removes obstacles before they cause churn, and guides students toward the outcomes they paid for.\n\nFor a certification business, customer success is not a cost center — it is a revenue multiplier. Students who complete certifications and achieve outcomes become testimonials, case studies, and referral sources. Students who quietly disengage generate refund requests and negative reviews.\n\n## The Customer Success Lifecycle\n\n**Week 1-2: Activation**\nGoal: Get the student to complete Module 1.\nActions:\n- Activation-focused onboarding sequence (covered in Cert 14)\n- If no login after 48 hours: personal email from the instructor (not automated) — "I noticed you haven''t logged in yet. Is there anything I can help with?"\n- If no Module 1 completion by Day 7: phone call for high-ticket students, personal email for self-paced\n\n**Week 3-6: Momentum**\nGoal: Maintain weekly progress.\nActions:\n- Weekly progress check-in email (automated, but personalized with merge fields showing their actual progress percentage)\n- For students who stop mid-module: a "stuck?" email surfacing the most common sticking points and offering a Q&A call\n- Mid-certification celebration: when a student hits 50% completion, send a congratulations email with a small win (e.g., a bonus resource or a shoutout in the community)\n\n**Week 7+: Completion Push**\nGoal: Get students across the finish line.\nActions:\n- "You are X% done — here is what''s left" email when student reaches 75%\n- Completion deadline reminder if cohort has a defined end date\n- For students who go 14 days without activity at 80%+ completion: personal outreach to remove specific obstacle\n\n**Post-Completion: Credential and Expansion**\nGoal: Deliver credential, request testimonial, introduce next certification.\nActions:\n- Credential delivery email with certificate download and LinkedIn badge instructions\n- Testimonial request 3-5 days after completion ("Would you be willing to share your experience in 2-3 sentences?")\n- Alumni introduction to next certification in track with alumni discount (7-14 days post-completion)\n\n## Handling Refund Requests\n\nRefund requests should be handled within 24 hours. Delayed responses escalate to chargebacks, which are more damaging (chargeback fees + potential Stripe account health impact).\n\n**Refund handling protocol:**\n\n1. **Acknowledge immediately:** "Thank you for reaching out. I want to make this right. I will review your request and respond within 24 hours."\n\n2. **Classify the reason:**\n   - Within guarantee period + policy terms met → process refund, no questions asked\n   - Within guarantee period + substantial completion (e.g., 80%+ of content accessed) → investigate per your policy\n   - Outside guarantee period → review on a case-by-case basis; often worth a partial refund or credit to preserve the relationship\n\n3. **Attempt a resolution first (optional for non-urgent cases):**\n   "Before I process the refund, can I ask what did not work for you? I want to understand so I can make the program better — and if there''s something specific I can fix, I would love the chance to do that first."\n\n4. **Process or deny:**\n   - If processing: confirm in writing, process in Stripe, revoke access (automated via webhook), send final confirmation email\n   - If denying (outside policy period): explain calmly, reference the refund policy, offer alternative resolution (credit, extension, one-on-one session)\n\n5. **Log in CRM:** Record refund reason, amount, and resolution. Review refund patterns monthly — if the same module or objection appears in multiple refunds, it is a product problem, not a customer problem.\n\n## Complaint Management\n\nA complaint is an opportunity to recover a relationship before it becomes a review. Most complainants are not trying to destroy your business — they are frustrated and want to feel heard.\n\n**The HEARD complaint response framework:**\n- **H — Hear:** Listen without interrupting or defending\n- **E — Empathize:** Acknowledge the frustration ("I completely understand why that was frustrating")\n- **A — Apologize:** Apologize for the experience, even if you did not cause it\n- **R — Resolve:** Offer a specific, concrete resolution\n- **D — Diagnose:** After resolution, identify the root cause and fix it\n\n**What to offer as resolution:**\n- Access extension\n- Bonus 1:1 session\n- Refund for one module or partial refund\n- Enrollment credit for a future certification\n- Full refund as a last resort\n\nThe goal is to end every complaint with the student feeling respected, even if they ultimately leave. A student who receives a graceful resolution is unlikely to leave a negative review. A student who feels dismissed will.\n\n## Building a Referral System\n\nThe most effective source of new certification students is graduates who refer colleagues. Build the referral system proactively — do not wait for organic word-of-mouth.\n\n**Referral system structure:**\n\n1. **Identify promoters:** Survey students 30 days post-completion using a single NPS question ("How likely are you to recommend Cap Fund Academy to a colleague? 0-10"). Scores of 9-10 are promoters — contact them for referrals.\n\n2. **Make the ask specific:** "Do you know one or two other executive directors who are working on a USDA RMAP application? I would love an introduction."\n\n3. **Provide the tools:** Give promoters a referral email template they can copy-paste. Remove all friction from the referral act.\n\n4. **Reward referrals:** A 10-15% commission on the first purchase from a referred student, paid after the 30-day refund window. Track referrals in the CRM with a referral attribution tag.',
  'Proactive customer success — activation in Week 1, momentum in Weeks 3-6, completion push, and a post-completion referral system — multiplies revenue from the same enrollment base.',
  18, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 4
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Business Operations: Finance, SOPs & Scaling',
  'Build the financial reporting, SOP documentation, and organizational systems that allow a certification business to scale beyond the solo operator stage.',
  4, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod4_id FROM modules WHERE certification_id = cert_id AND sort_order = 4;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod4_id,
  'Financial Systems, SOPs, and Scaling Operations',
  'cert16-financial-systems-sops-scaling',
  E'## The Operations Trap\n\nMost certification businesses fail not from bad content or weak marketing, but from operational chaos as they scale. The founder who handles every enrollment, every support email, every refund request, and every content update cannot also focus on growth. At some point, the business stops growing not because of a strategy failure, but because the operator runs out of capacity.\n\nThe solution is systems: documented processes, financial visibility, and clear organizational roles that allow other people (contractors, employees, AI tools) to handle routine work at the same quality level as the founder.\n\n## Financial Reporting Systems\n\n**What to track weekly:**\n- Gross revenue (total payments received in Stripe)\n- Refunds issued\n- Net revenue (gross minus refunds)\n- New enrollments by certification\n- Average order value\n- Ad spend (if running paid ads)\n- ROAS (if running paid ads)\n\n**What to track monthly:**\n- Operating expenses by category (platform fees, ad spend, contractor payments, software subscriptions)\n- Net profit (net revenue minus total expenses)\n- Profit margin (%)\n- Student count by status (active, completed, refunded)\n- Completion rate by certification\n- Lead-to-enrollment conversion rate\n\n**Tools:**\n- **Stripe Dashboard** — revenue, refunds, payout history, monthly summaries\n- **QuickBooks / Wave Accounting** — connect your business bank account, categorize expenses, generate P&L statements\n- **Google Sheets / Notion dashboard** — weekly KPI tracking, manually updated from Stripe and ad platform data\n\n**Monthly financial review (30 minutes):**\nReview the P&L, identify any expense categories that increased significantly, compare revenue to prior month, and set next month''s revenue target and key actions.\n\n## Standard Operating Procedures (SOPs)\n\nAn SOP (Standard Operating Procedure) is a written description of how a specific task should be done, step by step, that allows anyone to execute it consistently without asking you.\n\n**SOPs every certification business needs:**\n\n1. **Enrollment SOP:** What happens after a payment is confirmed. Step-by-step: webhook triggers, account creation, welcome email, CRM update.\n\n2. **Refund SOP:** Covered in Module 3. Include the decision tree, Stripe steps, access revocation process, CRM logging.\n\n3. **Content publishing SOP:** How a new lesson, module, or certification is created, reviewed, formatted, and published. Prevents quality inconsistency when content creation is delegated.\n\n4. **Support ticket SOP:** How support requests are triaged, which issues are handled by a VA vs. escalated to the founder, response time standards.\n\n5. **Cohort launch SOP:** The complete checklist for opening enrollment on a new cohort — email announcements, ad campaigns, landing page updates, application open/close dates.\n\n6. **Credential issuance SOP:** How a completion is verified, how the certificate is generated and delivered, how the CRM is updated.\n\n**SOP format (simple and effective):**\n```\nSOP: [Name]\nOwner: [Role responsible]\nTrigger: [What starts this process]\nSteps:\n  1. [Action] — [Tool/system] — [Expected outcome]\n  2. ...\nException handling: [What to do if X goes wrong]\nLast updated: [Date]\n```\n\n## Organizational Scaling Roadmap\n\nA certification business typically scales through these stages:\n\n**Stage 1: Solo operator (0 - $10K/month)**\nFounder does everything. Focus: build the first certification, make the first 20-30 sales, validate offer-market fit. No delegation yet — learn every part of the business before handing it off.\n\n**Stage 2: First hire — VA ($10K - $25K/month)**\nHire a virtual assistant for 10-15 hours/week to handle: support ticket first response, CRM data entry, social media scheduling, routine refund processing. Founder focuses on content creation, sales, and relationships.\n\n**Stage 3: Part-time contractor roles ($25K - $50K/month)**\nAdd a part-time content editor or curriculum assistant to help produce certification content. Add a part-time ad manager once paid ad spend exceeds $3,000/month. Founder focuses on product strategy, high-touch sales, and partnerships.\n\n**Stage 4: Full team ($50K+/month)**\nFull-time customer success manager, marketing manager, and content manager. Founder role shifts to thought leadership, product vision, and key partnerships.\n\n## Technology Stack Consolidation\n\nAt scale, technology sprawl creates inefficiency. Audit your tech stack quarterly:\n\n| Function | Early Stage | Scaled Stage |\n|----------|------------|-------------|\n| Course platform | Teachable/Thinkific | Custom Supabase-backed platform |\n| Email | ConvertKit | ActiveCampaign or GoHighLevel |\n| CRM | HubSpot Free | ActiveCampaign or GoHighLevel |\n| Payment | Stripe | Stripe (no change needed) |\n| Analytics | Google Analytics | Stripe + custom dashboard |\n| Project management | Notion/Trello | ClickUp or Asana |\n\nThe goal is not the most features — it is the fewest tools that do the job reliably. Every integration point is a potential failure point.\n\n## Pricing Reviews\n\nPricing should be reviewed annually. Ask:\n1. Has the content been significantly expanded since last pricing?\n2. Have comparable programs in adjacent niches increased their prices?\n3. Are refund rates low (suggesting pricing is not a barrier)?\n4. Is conversion rate healthy at current price?\n\nA 10-20% price increase on existing certifications typically has minimal impact on conversion rate for a program with strong positioning and social proof, while significantly improving margins.',
  'Financial reporting (weekly Stripe review + monthly P&L), SOPs for every core process, and a four-stage organizational scaling roadmap are the operational systems that allow a certification business to grow beyond the founder.',
  16, 1, 'approved')
ON CONFLICT DO NOTHING;

-- QUIZ for Cert 16
INSERT INTO quizzes (id, certification_id, title, passing_score, status)
VALUES (uuid_generate_v4(), cert_id,
  'CRM, Customer Success & Business Operations Knowledge Check',
  80, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO quiz_id FROM quizzes WHERE certification_id = cert_id;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order)
VALUES
(quiz_id,
  'What is the primary difference between customer support and customer success?',
  '[{"id":"a","text":"Customer support costs money; customer success generates revenue"},{"id":"b","text":"Customer support is reactive (responds to problems); customer success is proactive (anticipates obstacles and guides students to outcomes)"},{"id":"c","text":"Customer support handles refunds; customer success handles enrollments"},{"id":"d","text":"Customer support is for enterprise clients; customer success is for individual students"}]',
  'b',
  'Customer support is reactive — it responds when something breaks or a student complains. Customer success is proactive — it monitors student progress, identifies students at risk of disengagement, and removes obstacles before they cause churn or refunds.',
  1),
(quiz_id,
  'Which Stripe webhook event should trigger moving a contact from "Lead" to "Enrolled" in your CRM?',
  '[{"id":"a","text":"payment_intent.created"},{"id":"b","text":"customer.subscription.created"},{"id":"c","text":"checkout.session.completed"},{"id":"d","text":"invoice.paid"}]',
  'c',
  '`checkout.session.completed` fires when a Stripe Checkout session completes successfully — payment confirmed. This event should trigger: CRM stage update to Enrolled, student account creation, welcome email, and onboarding sequence enrollment.',
  2),
(quiz_id,
  'In a certification application rubric scoring 75+ points for acceptance, which factor should carry the highest weight?',
  '[{"id":"a","text":"The quality of the applicant''s writing in the open-ended response"},{"id":"b","text":"Organizational fit — whether the applicant has an existing or actively planned USDA RLF/RMAP program"},{"id":"c","text":"The applicant''s years of experience in rural development"},{"id":"d","text":"The organization''s annual budget size"}]',
  'b',
  'Organizational fit — whether the applicant has an active or planned RLF/RMAP program — should carry the highest weight (25 points in the sample rubric) because it determines whether the student can actually apply the certification content. A highly committed applicant without an appropriate organizational context cannot achieve the intended outcome.',
  3),
(quiz_id,
  'What is the most damaging outcome of a delayed response to a refund request?',
  '[{"id":"a","text":"The student leaves a negative social media post"},{"id":"b","text":"The refund amount increases due to interest"},{"id":"c","text":"The student initiates a credit card chargeback, which carries fees and can damage your Stripe account health"},{"id":"d","text":"The student contacts the BBB"}]',
  'c',
  'Chargebacks are more damaging than refunds — they include fees ($15-25 per dispute), can damage your Stripe account health if the chargeback rate exceeds thresholds, and almost always result in the money being returned anyway. Responding to refund requests within 24 hours prevents most chargebacks.',
  4),
(quiz_id,
  'The HEARD complaint response framework stands for:',
  '[{"id":"a","text":"Handle, Escalate, Apologize, Resolve, Document"},{"id":"b","text":"Hear, Empathize, Apologize, Resolve, Diagnose"},{"id":"c","text":"Hear, Evaluate, Act, Respond, Document"},{"id":"d","text":"Help, Explain, Acknowledge, Refund, Dismiss"}]',
  'b',
  'HEARD: Hear (listen without defending), Empathize (acknowledge the frustration), Apologize (for the experience), Resolve (offer specific concrete resolution), Diagnose (identify root cause after resolution and fix it). The goal is to end every complaint with the student feeling respected.',
  5),
(quiz_id,
  'An NPS score of 9 or 10 on the post-completion survey indicates:',
  '[{"id":"a","text":"The student completed the certification in 9-10 weeks"},{"id":"b","text":"The student is a promoter — highly likely to recommend the program and a prime referral source"},{"id":"c","text":"The student scored 9 or 10 on the final certification exam"},{"id":"d","text":"The student has enrolled in 9 or 10 certifications"}]',
  'b',
  'Net Promoter Score (NPS) measures likelihood to recommend on a 0-10 scale. Scores of 9-10 are "promoters" — highly satisfied students who are likely to refer colleagues. These are the students to contact for testimonials, case studies, and active referral program participation.',
  6),
(quiz_id,
  'What financial metric should be reviewed weekly for a certification business?',
  '[{"id":"a","text":"Accounts payable aging and depreciation schedules"},{"id":"b","text":"Gross revenue, refunds, net revenue, new enrollments, and ad ROAS"},{"id":"c","text":"Quarterly P&L and annual tax liability"},{"id":"d","text":"Employee benefits expenses and payroll tax liabilities"}]',
  'b',
  'Weekly financial review should cover the revenue metrics that directly reflect business health: gross revenue (Stripe), refunds, net revenue, new enrollments by certification, and ROAS on paid ads. Monthly review adds operating expenses and profit margin.',
  7),
(quiz_id,
  'At what monthly revenue stage does hiring a virtual assistant (VA) typically make sense?',
  '[{"id":"a","text":"$1,000-$5,000/month"},{"id":"b","text":"$5,000-$10,000/month"},{"id":"c","text":"$10,000-$25,000/month"},{"id":"d","text":"$50,000+/month"}]',
  'c',
  'At $10K-$25K/month, the founder''s time is most productively spent on content, sales, and relationships. A VA at 10-15 hours/week ($400-800/month) handles support, CRM data entry, scheduling, and routine operations — a high-ROI hire at this stage.',
  8),
(quiz_id,
  'What is the purpose of an SOP (Standard Operating Procedure) in a scaling certification business?',
  '[{"id":"a","text":"To document the legal terms and conditions of the certification program"},{"id":"b","text":"To provide written step-by-step instructions that allow anyone to execute a task consistently without asking the founder"},{"id":"c","text":"To satisfy ISO certification requirements for educational institutions"},{"id":"d","text":"To track student progress through the certification curriculum"}]',
  'b',
  'An SOP documents exactly how a task is done so that a VA, contractor, or new hire can execute it at the same quality level as the founder. Without SOPs, every delegation requires training and supervision, which eliminates the time savings of hiring.',
  9),
(quiz_id,
  'Which customer success action has the highest impact on reducing early churn (students who disengage in the first 2 weeks)?',
  '[{"id":"a","text":"Sending a course completion survey"},{"id":"b","text":"A personal email or phone call to students who have not logged in within 48 hours of enrollment"},{"id":"c","text":"Publishing more content modules"},{"id":"d","text":"Adding a community forum to the platform"}]',
  'b',
  'Personal outreach — a direct email or call — to students who have not logged in within 48 hours of enrollment is the highest-impact early churn intervention. Excitement peaks in the first 10 minutes after purchase and decays rapidly. Personal outreach restores momentum.',
  10),
(quiz_id,
  'In the certification business scaling roadmap, what is the founder''s primary focus at Stage 4 ($50K+/month)?',
  '[{"id":"a","text":"Handling all student support tickets to maintain quality control"},{"id":"b","text":"Writing all certification content personally to ensure accuracy"},{"id":"c","text":"Thought leadership, product vision, and key partnerships"},{"id":"d","text":"Managing paid advertising campaigns directly"}]',
  'c',
  'At Stage 4, the team handles operations. The founder''s highest-value activities shift to thought leadership (building authority and audience), product vision (deciding what certifications to build next), and key partnerships (USDA relationships, CDFI networks, professional associations).',
  11),
(quiz_id,
  'What is "technology sprawl" and why is it a problem at scale?',
  '[{"id":"a","text":"Using too many course platforms, which confuses students about where to access content"},{"id":"b","text":"Having too many integration points between tools, each of which is a potential failure point that creates operational complexity"},{"id":"c","text":"Publishing content on too many social media platforms simultaneously"},{"id":"d","text":"Offering too many certification tracks, which dilutes the brand"}]',
  'b',
  'Technology sprawl is the accumulation of too many tools, each integrated with others. Every integration point is a potential failure point — a broken Zapier connection, an API change, a platform outage. The goal is the fewest tools that do the job reliably.',
  12),
(quiz_id,
  'A referral commission of 10-15% paid after the 30-day refund window is best described as:',
  '[{"id":"a","text":"An affiliate program that creates perverse incentives to oversell the certification"},{"id":"b","text":"A performance-based referral reward that aligns incentives — commission is earned only on retained students"},{"id":"c","text":"A discount offered to students who purchase multiple certifications"},{"id":"d","text":"A revenue-sharing arrangement with platform partners"}]',
  'b',
  'A referral commission paid after the refund window aligns incentives: the referrer earns only when the referred student is a genuine, retained customer. Paying commission before the refund window creates an incentive to refer anyone regardless of fit.',
  13),
(quiz_id,
  'When should application processes be used for a certification program?',
  '[{"id":"a","text":"For all certifications above $200 in price"},{"id":"b","text":"Only when required by accreditation bodies"},{"id":"c","text":"When the program is selective, high-investment, requires organizational readiness, or benefits from premium positioning"},{"id":"d","text":"Only for group or organizational enrollment, not individual enrollment"}]',
  'c',
  'Applications are appropriate for selective programs with limited cohort capacity, high-investment programs ($1,500+) where commitment screening is valuable, programs where organizational readiness is required, and programs using exclusivity for premium positioning. Open-enrollment self-paced programs under $1,000 rarely benefit from application friction.',
  14),
(quiz_id,
  'What does a monthly P&L (Profit & Loss) statement tell a certification business owner?',
  '[{"id":"a","text":"The total number of students enrolled and their completion status"},{"id":"b","text":"Revenue minus expenses for the period, showing whether the business is profitable and where money is being spent"},{"id":"c","text":"The lifetime value of each customer segment"},{"id":"d","text":"The projected revenue for the next 12 months"}]',
  'b',
  'A P&L statement shows total revenue, categorized expenses, and net profit for a given period. For a certification business, it reveals whether the business is profitable, which expense categories are growing, and what the profit margin is — essential for pricing and investment decisions.',
  15)
ON CONFLICT DO NOTHING;

END $$;

-- ============================================================
-- CERT 17: Master Capstone — USDA-Ready Microlending/RLF Program
--          and Automated Certification Business
-- ============================================================
DO $$
DECLARE
  cert_id   uuid;
  mod1_id   uuid;
  mod2_id   uuid;
  mod3_id   uuid;
  mod4_id   uuid;
  quiz_id   uuid;
BEGIN

SELECT id INTO cert_id FROM certifications WHERE cert_number = 17;
IF cert_id IS NULL THEN
  RAISE EXCEPTION 'Cert 17 not found — run 04_cert_seeds.sql first';
END IF;

UPDATE certifications SET
  learning_outcomes = ARRAY[
    'Produce a complete, submission-ready USDA RMAP or RBDG application package documented to the scoring rubric',
    'Design a written RLF loan policy, underwriting framework, and compliance infrastructure ready for a USDA site visit',
    'Build the full operational architecture of an automated certification business: offer, funnel, payment, enrollment, CRM, and content engine',
    'Integrate USDA program mastery with business-building systems to create a self-sustaining dual-revenue model',
    'Present a live case for instructor review and incorporate specific, actionable feedback',
    'Identify and resolve gaps in your application or business architecture before submission or launch',
    'Articulate your unique value proposition as a certified USDA rural capital specialist and certification business operator'
  ],
  status = 'approved'
WHERE id = cert_id;

-- MODULE 1
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'USDA Application Capstone',
  'Assemble a complete, submission-ready USDA RMAP or RBDG application package. Apply every scoring criterion, evidence documentation standard, and compliance element from Certs 1-13.',
  1, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod1_id FROM modules WHERE certification_id = cert_id AND sort_order = 1;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod1_id,
  'Assembling Your USDA Application Capstone',
  'cert17-usda-application-capstone',
  E'## The Capstone Standard\n\nThe Master Capstone is not a knowledge check — it is a production deliverable. By the end of this module, you will have produced a complete USDA application package that could be submitted to a Rural Development State Office without modification. Every section will be documented to the scoring criteria. Every exhibit will be present. Every compliance certification will be in place.\n\nThis is the highest standard in the Cap Fund Academy system. Students who complete the Capstone have demonstrated not just knowledge, but execution capability.\n\n## What "Submission-Ready" Means\n\nA submission-ready USDA RMAP or RBDG application package includes:\n\n**Core application documents:**\n- Completed application form (USDA RD form for the specific program)\n- Project narrative aligned to every scored criterion in 7 CFR 4280.316 (RMAP) or 7 CFR 4280.411 (RBDG)\n- Budget and budget narrative\n- Pro forma financial projections (3-5 years for RMAP; as required for RBDG)\n\n**Organizational documents:**\n- Articles of incorporation and bylaws\n- IRS determination letter (501(c)(3) or other applicable exemption)\n- Current board of directors list with bios demonstrating relevant expertise\n- Current organizational chart\n- Audited or reviewed financial statements (most recent 2-3 years)\n- Management capability narrative\n\n**Program-specific documents:**\n- Written loan fund policy (RMAP) covering all required elements in 7 CFR 4280.315\n- Microloan program description and delivery plan\n- Technical assistance and training (TA&T) plan\n- Target market description with rural area documentation\n- Evidence of community need (market analysis, demand documentation)\n\n**Compliance certifications:**\n- SAM.gov active registration with current UEI\n- Debarment certification (Form AD-1047)\n- Lobbying certification (Form SF-LLL if applicable)\n- Drug-free workplace certification\n- Civil rights compliance certifications\n- Environmental review documentation\n\n**Evidence exhibits:**\n- Letters of support (minimum 3; target 5-7 from relevant community partners, lenders, economic development agencies)\n- Partnership agreements or MOUs\n- Demographic data on service area (Census data, rural designation documentation)\n- Prior RLF performance data (if existing program)\n- Borrower testimonials or case studies (if existing program)\n\n## The Evidence Documentation Framework\n\nUSDA reviewers are skeptical readers. Every claim in your narrative must be supported by an exhibit. The Evidence Documentation Framework from Cert 12 applies here with full rigor:\n\n**For every major assertion in your narrative:**\n1. Make the claim ("Our service area contains X rural census tracts with Y% poverty rate")\n2. Cite the exhibit ("See Exhibit 7: USDA ERS Rural-Urban Commuting Area codes and Census 2020 poverty data")\n3. Make the exhibit self-explanatory (label, source, date, and a one-sentence explanation of what it shows)\n\nA narrative without exhibits is a wish list. A narrative with precisely labeled, logically organized exhibits is a professional application.\n\n## Scoring Self-Assessment\n\nBefore finalizing your application, score it against the applicable rubric:\n\n**For RMAP (7 CFR 4280.316), the scoring categories are:**\n- Microlending experience and capacity (up to 30 points)\n- Technical assistance capability (up to 25 points)\n- Financial soundness and sustainability (up to 20 points)\n- Community impact and need (up to 15 points)\n- Partnerships and coordination (up to 10 points)\n\n**Self-scoring process:**\nFor each category, read the regulatory scoring criteria. Assign yourself a score and write one paragraph justifying that score with references to specific sections of your narrative and exhibits. If you cannot justify a score above the midpoint on any criterion, identify what evidence or narrative is missing and add it before submitting.\n\n## Application Assembly Checklist\n\nBefore declaring your application submission-ready, verify:\n\n☐ All required forms completed with no blank fields\n☐ Project narrative addresses every scored criterion with evidence references\n☐ Budget is mathematically correct and consistent with narrative\n☐ Financial projections include all required assumptions and footnotes\n☐ Organizational documents are current (board list, financials, bylaws)\n☐ Written loan policy covers all required elements\n☐ TA&T plan specifies eligible activities, documentation methods, and outcome tracking\n☐ SAM.gov registration is active with correct UEI\n☐ All required certifications signed by authorized organizational representative\n☐ Environmental screening worksheet completed and filed\n☐ Civil rights compliance documentation in place\n☐ Evidence exhibits labeled, tabbed, and referenced from narrative\n☐ Letters of support signed, dated, and from organizations with relevant standing\n☐ Application reviewed by at least one person who did not write it\n☐ Physical or electronic package organized per State Office instructions\n\n## Common Pre-Submission Errors\n\nEvery USDA Rural Development State Office staff member has seen these errors repeatedly:\n\n1. **Unsigned forms** — Verify every signature line. An unsigned form creates a delay or rejection at intake.\n2. **Expired SAM registration** — Check SAM.gov the day before submission. Expirations happen quietly.\n3. **Financial projections inconsistent with loan fund policy** — If your loan policy allows loans up to $50,000 but your financial projections assume average loan size of $100,000, reviewers notice.\n4. **Letters of support from inappropriate signatories** — A letter from a city mayor or county commissioner carries weight. A letter from the executive director''s personal friend does not.\n5. **Missing rural area documentation** — Every claim that your service area is "rural" must be supported by USDA''s own rural designation data, not a general statement.\n6. **Narrative written for a general audience** — Write for the reviewer, not for a layperson. Use USDA program terminology precisely. Vague language on scored criteria loses points.',
  'A submission-ready USDA application contains core application documents, organizational exhibits, compliance certifications, and a scored narrative with evidence references for every claim. Complete the 16-point checklist before submission.',
  22, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 2
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Certification Business Architecture Capstone',
  'Design the complete operational architecture of your automated certification business. Integrate offer, funnel, payment, enrollment, CRM, content engine, and financial systems into a coherent, scalable model.',
  2, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod2_id FROM modules WHERE certification_id = cert_id AND sort_order = 2;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod2_id,
  'Designing Your Certification Business Architecture',
  'cert17-certification-business-capstone',
  E'## The Architecture Deliverable\n\nThe business architecture capstone is not a business plan — it is an operational blueprint. A business plan describes what you intend to do. An operational blueprint documents exactly how the business will run: which tools, which automations, which SOPs, who does what, and how money flows.\n\nStudents who complete this module will have a documented operational blueprint that a new team member could use to understand and operate the business. That is the test of a real system.\n\n## The Seven-Layer Business Architecture\n\nA complete certification business operates across seven interdependent layers. Your capstone must address all seven:\n\n### Layer 1: Offer Architecture\n**What you are selling and why it is worth the price**\n- Certification catalog: which certifications, in what order, at what price\n- Pricing tiers for each certification\n- Bundle offers and credential tracks\n- Guarantee structure\n- Offer positioning statement (who it is for, what transformation it delivers, why you specifically)\n\n### Layer 2: Funnel Architecture\n**How strangers become buyers**\n- Primary traffic sources (organic content, paid ads, partnerships, referrals)\n- Lead magnets by certification (one per major certification track)\n- Opt-in page and email platform configuration\n- Nurture sequence structure and duration\n- Sales page structure and CTA flow\n- Order bump and upsell strategy\n- Checkout configuration in Stripe\n\n### Layer 3: Enrollment & Delivery Architecture\n**How buyers become students**\n- Course platform and technical setup\n- Stripe webhook → enrollment automation workflow\n- Student account creation and login delivery\n- Content delivery format (modules, lessons, quizzes, resources)\n- Credential issuance process\n\n### Layer 4: CRM & Pipeline Architecture\n**How relationships are managed**\n- CRM platform selected and configured\n- Pipeline stages: lead → engaged → enrolled → active → completed → alumni\n- Automation rules for stage transitions\n- Contact record fields and tagging taxonomy\n- Task management workflow\n\n### Layer 5: Customer Success Architecture\n**How students achieve outcomes**\n- Activation sequence (Days 1-7)\n- Progress monitoring and intervention triggers\n- Completion push sequence\n- Post-completion: credential, testimonial, referral request, next certification offer\n- Refund and complaint handling SOPs\n\n### Layer 6: Content & Marketing Architecture\n**How the audience grows**\n- Primary content channel and publishing cadence\n- Content pillar structure (5 pillars, 12 topics per pillar per year)\n- Repurposing workflow (1 email → 3 LinkedIn posts + 1 article)\n- Email list growth targets and lead magnet conversion rate benchmarks\n- Paid ad strategy (channels, audience types, budget allocation, ROAS targets)\n\n### Layer 7: Financial & Operations Architecture\n**How the business is managed**\n- Revenue model: price × volume projections for each certification\n- Cost structure: platform fees, ad spend, contractor costs, software subscriptions\n- Break-even analysis\n- Financial reporting cadence (weekly Stripe review, monthly P&L)\n- SOP documentation coverage\n- Organizational scaling roadmap\n\n## Integration: The Dual-Revenue Model\n\nThe Master Capstone specifically integrates two revenue streams:\n\n**Stream 1: USDA Consulting / Application Services**\nStudents who have completed Certs 1-13 have the expertise to advise rural nonprofits and CDFIs on USDA applications, RLF design, and compliance. This expertise can be monetized directly through consulting engagements, application review services, or grant writing contracts.\n\n**Stream 2: Certification Business Revenue**\nStudents who have completed Certs 14-16 have the systems to teach others what they know through their own certification programs. The Cap Fund Academy graduate who becomes a USDA specialist can build their own certification program teaching rural practitioners in their regional niche.\n\nThe dual-revenue model is powerful: consulting revenue funds the business during content creation; certification revenue scales to multiples of consulting income without proportional time investment.\n\n**Integration architecture:**\n- Consulting engagements generate case studies and testimonials that power certification sales\n- Certification students who need hands-on help become consulting clients\n- Your content marketing builds authority that attracts both consulting clients and certification students\n- Your certification credential portfolio signals expertise to consulting prospects\n\n## The Capstone Deliverable Format\n\nYour business architecture capstone is a structured document with seven sections (one per layer above), each containing:\n\n1. **Current state:** What is in place today\n2. **Target state:** What the layer should look like at 6 months and 12 months\n3. **Gap analysis:** What is missing between current and target\n4. **Priority actions:** The 3 most important actions to close the gap, in priority order\n5. **Tool selections:** Which specific tools will be used at each stage\n6. **Success metrics:** How you will know each layer is working (specific, measurable KPIs)\n\nA complete capstone document for all seven layers should run 15-25 pages. It is the operating manual for your business.',
  'A complete certification business architecture covers seven layers: offer, funnel, enrollment, CRM, customer success, content/marketing, and financial operations. The Master Capstone integrates consulting and certification revenue into a self-sustaining dual-revenue model.',
  22, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 3
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Live Case Review & Instructor Feedback',
  'Present your USDA application package and business architecture to the instructor for live review. Receive specific, actionable feedback and implement revisions before final submission.',
  3, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod3_id FROM modules WHERE certification_id = cert_id AND sort_order = 3;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod3_id,
  'Preparing for and Maximizing Your Case Review Session',
  'cert17-case-review-preparation',
  E'## The Purpose of the Live Review\n\nThe live case review is the element that separates the Master Capstone from all prior certifications. Everything before this point has been learning and preparation. The case review is accountability — a trained reviewer who has read real USDA applications will evaluate your work against the same standard USDA reviewers apply.\n\nThe goal of the review is not to pass a test. It is to identify and fix the specific gaps that would cost you points on a real USDA application or prevent your certification business from launching cleanly. You should walk into the review expecting to receive hard feedback and walk out with a clear list of specific improvements.\n\n## Pre-Review Submission Requirements\n\nSubmit the following to the instructor at least 72 hours before your review session:\n\n**For the USDA Application Capstone:**\n- Complete application package (all sections, all exhibits) in a single PDF or organized folder\n- Your completed self-scoring rubric with narrative justifications\n- A 1-page cover memo identifying: (1) which program you are applying for, (2) the three sections you are most uncertain about, and (3) the one critical gap you know needs attention\n\n**For the Business Architecture Capstone:**\n- Your seven-layer architecture document\n- A one-page "state of the business" summary: what is live, what is in progress, what is not yet started\n- Your top three questions for the instructor\n\nThe cover memo and summary are not formalities — they direct the reviewer''s attention and ensure the session focuses on your highest-priority issues rather than surface-level observations.\n\n## What the Reviewer Will Evaluate\n\n**USDA Application:**\n- Does the narrative address every scored criterion, or are there gaps?\n- Is every major claim supported by a properly labeled exhibit?\n- Is the written loan policy complete and compliant with 7 CFR 4280?\n- Are the financial projections internally consistent and realistic?\n- Is the TA&T plan sufficiently detailed to survive USDA review?\n- Are all required certifications and compliance documents present?\n- What would a USDA reviewer flag as a weakness?\n\n**Business Architecture:**\n- Is the offer positioned precisely enough for the target audience?\n- Is the funnel architecture complete, or are there missing stages?\n- Are the automation workflows documented with enough detail to implement?\n- Is the financial model viable (will it break even at realistic enrollment volumes)?\n- Are the SOPs complete enough to delegate key processes?\n- What is the single biggest risk to the business in the first 90 days?\n\n## During the Review Session\n\nThe review session is typically 60-90 minutes. Structure:\n\n**First 10 minutes:** You present your USDA application and business architecture in a 5-minute overview each. Practice this overview before the session — you should be able to summarize both documents in 5 minutes without reading from notes.\n\n**Next 40-60 minutes:** The instructor reviews findings section by section. Your job during this phase:\n- Listen and take detailed notes\n- Ask clarifying questions when the feedback is unclear\n- Do NOT defend your choices. If the instructor identifies a gap, acknowledge it and ask how to fix it.\n- For each piece of feedback, confirm your understanding: "So what you''re saying is I need to add [X] to the [Y] section — is that right?"\n\n**Final 10-15 minutes:** Priority ranking. Ask: "Of everything we discussed, what are the three most important fixes before submission/launch?" Get a ranked priority list from the instructor, not a comprehensive list of everything to eventually improve.\n\n## Post-Review Implementation\n\nWithin 7 days of the review session:\n\n1. **Implement the top three priority fixes** identified by the instructor\n2. **Resubmit** the revised sections to the instructor for confirmation (not a full second review — just the revised sections)\n3. **Update your action plan** for items beyond the top three — these go into your 30-day and 90-day implementation calendar\n4. **Document the feedback** in your CRM or project management tool so it does not get lost\n\nStudents who implement feedback within 7 days retain 80%+ of the reviewer''s insights. Students who wait 30+ days retain less than 40%. Act immediately while the feedback is fresh and specific.\n\n## Building a Review-Ready Mindset\n\nThe most common barrier to getting value from the live review is defensiveness. You spent weeks building your application or business architecture. Having a reviewer identify gaps can feel like criticism of your work or your capability.\n\nReframe: every gap identified in the review session is a gap you can fix before it costs you money. A weak section in your USDA application found by the reviewer does not cost you anything. The same weak section found by a USDA reviewer costs you the funding. A broken funnel stage found by the reviewer costs you an afternoon to fix. The same broken stage left unfixed costs you every enrollment that falls out at that point.\n\nThe reviewer is on your side. Treat the review session as one of the highest-ROI hours in your entire Cap Fund Academy experience.',
  'The live case review evaluates your USDA application and business architecture against real standards. Submit 72 hours early with a cover memo identifying your top uncertainties. Listen without defending. Implement the top three fixes within 7 days.',
  18, 1, 'approved')
ON CONFLICT DO NOTHING;

-- MODULE 4
INSERT INTO modules (id, certification_id, title, description, sort_order, status)
VALUES (uuid_generate_v4(), cert_id,
  'Integration & Launch Planning',
  'Synthesize all 17 certifications into a coherent personal and organizational action plan. Define your unique value proposition, set your 90-day launch targets, and commit to your first submission or launch date.',
  4, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO mod4_id FROM modules WHERE certification_id = cert_id AND sort_order = 4;

INSERT INTO lessons (module_id, title, slug, content, summary, read_time_minutes, sort_order, status)
VALUES (mod4_id,
  'Integration, Value Proposition, and 90-Day Launch Plan',
  'cert17-integration-launch-plan',
  E'## What Integration Means\n\nYou have completed 17 certifications. You have knowledge in microfinance principles, RLF design, USDA program mechanics, underwriting, compliance, accounting, application assembly, community impact, automated business systems, content marketing, CRM, and operations. These are not seventeen separate boxes — they are one integrated capability.\n\nIntegration means you can hold all of it simultaneously and make decisions that account for the interaction between parts. A loan you originate today creates a compliance record you will need in two years. A content piece you publish this week brings in a student who becomes a consulting client next quarter. An SOP you document now allows you to hire a VA six months from now without quality loss.\n\nThe final module is about synthesizing everything into a forward-looking action plan — not reviewing what you learned, but committing to what you will do with it.\n\n## Defining Your Unique Value Proposition\n\nA Unique Value Proposition (UVP) answers: "Why should a specific person choose you over every other option?"\n\nAs a Master Rural Microfinance & RLF Administrator, your UVP combines three rare elements:\n\n1. **Technical depth in USDA rural capital programs** — Most rural consultants and trainers have surface-level familiarity with RMAP and RBDG. You have studied the actual regulations, the scoring criteria, and the compliance requirements at the level of a practitioner, not an observer.\n\n2. **Operational certification business expertise** — You have built the systems to teach, deliver, and scale certification programs. This is a rare combination with deep subject matter expertise.\n\n3. **Integration** — You can help an organization get USDA funding AND help a trainer build a certification business around that knowledge. Very few people in this space can do both.\n\n**Drafting your UVP:**\nFormat: "I help [specific audience] achieve [specific outcome] through [unique mechanism], unlike [alternative] which [limitation of alternative]."\n\nExample: "I help rural nonprofit executive directors design USDA RMAP-compliant microlending programs and submit competitive federal applications, through a regulatory-specific certification curriculum built on 7 CFR 4280, unlike general grant writing consultants who lack the RLF compliance expertise USDA requires."\n\n## The 90-Day Launch Plan\n\nChoose ONE primary goal for the first 90 days. Not two or three — one. Attempting to submit a USDA application AND launch a certification business simultaneously in 90 days produces two mediocre outcomes. Pick the highest-priority path.\n\n**Path A: USDA Application Submission**\nIf your organization has an active need for USDA RMAP or RBDG funding:\n- Days 1-30: Implement all post-review revisions, gather outstanding exhibits, finalize compliance certifications\n- Days 31-60: Internal review by board or legal counsel, final proofreading, SAM.gov verification\n- Days 61-90: Submit to USDA Rural Development State Office; follow up to confirm receipt and completeness\n\n**Path B: Certification Business Launch**\nIf your primary goal is to monetize your expertise:\n- Days 1-30: Finalize your first certification offer (pick one certification to launch first), set up Stripe, choose a course platform, build the lead magnet and opt-in page\n- Days 31-60: Build the first certification''s content (or record the first module), set up email sequences, build the sales page\n- Days 61-90: Soft launch to your existing network, make your first 5 sales, gather testimonials\n\n**Path C: Consulting Practice Launch**\nIf your primary goal is direct client work:\n- Days 1-30: Define your service offerings (application review, RLF compliance audit, TA program design), set your rates, build a one-page service menu\n- Days 31-60: Identify 20 target organizations in your region who are actively working on USDA applications; outreach to request discovery calls\n- Days 61-90: Sign your first 2-3 consulting clients; deliver excellent work; document case studies\n\n## Commitment and Accountability\n\nThe gap between people who complete Cap Fund Academy and people who change their organizations or build businesses is not knowledge — it is commitment and accountability.\n\nBy completing this capstone, you are committing to:\n\n1. **A specific primary goal** from Path A, B, or C above\n2. **A specific deadline** for your 90-day milestone (write the date)\n3. **A specific accountability structure** — who will you tell about this commitment? An accountability partner, a board member, a cohort peer?\n4. **A review date** — 30 days from now, you will review progress against your 90-day plan and adjust as needed\n\n## The Alumni Community\n\nAs a Master Rural Microfinance & RLF Administrator, you are part of a growing network of certified practitioners and business builders in the rural finance space. This network is one of the most valuable assets of the Cap Fund Academy credential.\n\n**What to do in the alumni community:**\n- Share your 90-day goal publicly in the alumni forum (accountability and encouragement)\n- When you achieve a milestone — submitted your application, signed your first client, made your first sale — post it\n- When you encounter a USDA compliance question you cannot resolve from the curriculum, ask the community before spending hours searching\n- Refer other rural nonprofit leaders you know to Cap Fund Academy programs that fit their stage\n\nThe rural microfinance and RLF space is small enough that relationships matter enormously. A referral from a fellow Cap Fund Academy graduate carries more weight than a cold inquiry. Invest in the community — it compounds over time.\n\n## Final Reflection\n\nYou began Cap Fund Academy with a problem to solve: how to access federal capital for rural communities, or how to build a business teaching others to do the same. You have now built a knowledge base and a set of systems that few practitioners in this space possess.\n\nThe USDA rural capital programs — RMAP, RBDG, IRP — exist because Congress recognized that rural communities need capital that private markets will not provide at the required scale and terms. Every organization that successfully navigates the federal application process and deploys that capital creates jobs, supports entrepreneurs, and builds rural economies that would otherwise be left behind.\n\nYour expertise serves that mission. Use it well.',
  'Integration synthesizes all 17 certifications into a UVP and a specific 90-day launch plan. Choose one path: USDA application submission, certification business launch, or consulting practice. Commit to a date and an accountability structure.',
  20, 1, 'approved')
ON CONFLICT DO NOTHING;

-- QUIZ for Cert 17
INSERT INTO quizzes (id, certification_id, title, passing_score, status)
VALUES (uuid_generate_v4(), cert_id,
  'Master Capstone: Integration & Application Knowledge Check',
  80, 'approved')
ON CONFLICT DO NOTHING;

SELECT id INTO quiz_id FROM quizzes WHERE certification_id = cert_id;

INSERT INTO quiz_questions (quiz_id, question_text, options, correct_option_id, explanation, sort_order)
VALUES
(quiz_id,
  'A "submission-ready" USDA RMAP application must include which of the following evidence documents?',
  '[{"id":"a","text":"A letter of support from the applicant''s state senator"},{"id":"b","text":"An active SAM.gov registration with a current Unique Entity Identifier (UEI)"},{"id":"c","text":"A completed IRS Form 990 for the current fiscal year"},{"id":"d","text":"A third-party environmental impact statement"}]',
  'b',
  'An active SAM.gov registration with a current UEI is a required compliance document for all USDA grant and loan recipients. Without it, the application cannot be processed. Letters from elected officials are helpful but not required; Form 990 must be current but is an organizational exhibit, not an evidence document in the same category.',
  1),
(quiz_id,
  'The Evidence Documentation Framework requires that every major narrative claim be:',
  '[{"id":"a","text":"Verified by an independent third party before submission"},{"id":"b","text":"Supported by a cited, labeled exhibit that a reviewer can cross-reference"},{"id":"c","text":"Summarized in an executive summary at the beginning of the application"},{"id":"d","text":"Reviewed by USDA Rural Development before final submission"}]',
  'b',
  'Every major claim in the narrative must be supported by a precisely labeled exhibit, cited by number or letter in the narrative text. A narrative without exhibits is unverified assertion. USDA reviewers are skeptical readers who look for evidence, not just claims.',
  2),
(quiz_id,
  'In the RMAP scoring rubric (7 CFR 4280.316), which category carries the highest maximum point value?',
  '[{"id":"a","text":"Community impact and need (15 points)"},{"id":"b","text":"Partnerships and coordination (10 points)"},{"id":"c","text":"Microlending experience and capacity (30 points)"},{"id":"d","text":"Technical assistance capability (25 points)"}]',
  'c',
  'Microlending experience and capacity carries the highest weight (up to 30 points) in the RMAP scoring rubric. This reflects USDA''s priority on ensuring that RMAP funds go to organizations with demonstrated or well-documented capacity to operate a microlending program.',
  3),
(quiz_id,
  'The pre-review submission cover memo should identify:',
  '[{"id":"a","text":"The organization''s full legal history and prior federal funding"},{"id":"b","text":"The program you are applying for, the three sections you are most uncertain about, and the one critical gap you know needs attention"},{"id":"c","text":"A list of all exhibits in alphabetical order"},{"id":"d","text":"The reviewer''s qualifications and methodology"}]',
  'b',
  'The cover memo directs the reviewer''s attention to your highest-priority issues rather than surface observations. It should identify: which USDA program, which three sections need the most scrutiny, and the one critical gap the applicant already knows needs work.',
  4),
(quiz_id,
  'During the live case review session, when the instructor identifies a gap in your application, you should:',
  '[{"id":"a","text":"Defend your reasoning and explain why the section meets the scoring criteria"},{"id":"b","text":"Acknowledge the gap, ask how to fix it, and confirm your understanding of the required change"},{"id":"c","text":"Request a different reviewer with more favorable scoring criteria"},{"id":"d","text":"Immediately revise the section during the review session"}]',
  'b',
  'The case review is not a debate — it is a diagnostic. When a gap is identified, acknowledge it, ask clarifying questions until you understand exactly what is needed, and confirm the specific fix. Defending your choices prevents you from getting the benefit of the review.',
  5),
(quiz_id,
  'How long after the review session should the top three priority fixes be implemented?',
  '[{"id":"a","text":"Within 24 hours"},{"id":"b","text":"Within 7 days"},{"id":"c","text":"Within 30 days"},{"id":"d","text":"Before the next cohort begins"}]',
  'b',
  'Implement the top three priority fixes within 7 days of the review session. Students who act within 7 days retain 80%+ of the reviewer''s insights. Waiting 30+ days reduces retention to under 40% and allows the specific, actionable details of the feedback to fade.',
  6),
(quiz_id,
  'The "dual-revenue model" in the Master Capstone integrates:',
  '[{"id":"a","text":"USDA grant revenue and private foundation grant revenue"},{"id":"b","text":"USDA consulting/application services revenue and certification business revenue"},{"id":"c","text":"Microloan interest income and TA grant reimbursement"},{"id":"d","text":"Course platform subscription revenue and advertising revenue"}]',
  'b',
  'The dual-revenue model integrates: (1) USDA consulting and application services — monetizing deep expertise through direct client work, and (2) certification business revenue — teaching others through scalable certification programs. Each revenue stream reinforces the other.',
  7),
(quiz_id,
  'A Unique Value Proposition (UVP) for a Master Capstone graduate should include:',
  '[{"id":"a","text":"A list of all 17 certifications completed"},{"id":"b","text":"A specific audience, specific outcome, unique mechanism, and differentiation from alternatives"},{"id":"c","text":"Hourly rates and availability for consulting engagements"},{"id":"d","text":"A summary of the Cap Fund Academy curriculum"}]',
  'b',
  'An effective UVP names: the specific audience (rural nonprofit executive directors), the specific outcome (USDA-compliant microlending program), the unique mechanism (regulatory-specific curriculum based on 7 CFR 4280), and the differentiator (unlike general grant consultants who lack RLF compliance depth).',
  8),
(quiz_id,
  'The 90-Day Launch Plan framework requires choosing:',
  '[{"id":"a","text":"All three paths simultaneously to maximize momentum"},{"id":"b","text":"ONE primary goal — USDA application, certification business launch, or consulting practice"},{"id":"c","text":"A different goal for each month of the 90-day period"},{"id":"d","text":"The goal that requires the least amount of work to complete"}]',
  'b',
  'Attempting to pursue multiple primary goals simultaneously in 90 days produces multiple mediocre outcomes. Choosing ONE primary goal and executing it with full focus produces a meaningful first milestone that creates momentum for subsequent goals.',
  9),
(quiz_id,
  'Which of the following is a common pre-submission error that causes USDA application processing delays?',
  '[{"id":"a","text":"Including too many letters of support (more than 10)"},{"id":"b","text":"Unsigned forms — a signature line left blank creates a delay or rejection at intake"},{"id":"c","text":"Using colored exhibits instead of black and white photocopies"},{"id":"d","text":"Submitting the application before the open window"}]',
  'b',
  'Unsigned forms are the most common intake-stage error. Every required signature line must be signed by the authorized organizational representative. USDA State Offices cannot process incomplete applications and will return them or request corrections, delaying the review.',
  10),
(quiz_id,
  'Financial projections in a USDA RMAP application must be:',
  '[{"id":"a","text":"Reviewed and certified by a licensed CPA"},{"id":"b","text":"Internally consistent with the written loan policy, including average loan size and loan volume assumptions"},{"id":"c","text":"Based on the applicant''s highest revenue year in the past five years"},{"id":"d","text":"Expressed in constant dollars without inflation adjustments"}]',
  'b',
  'Financial projections must be internally consistent with the written loan fund policy. If the policy allows loans up to $50,000 but the projections assume $100,000 average loan size, USDA reviewers notice the inconsistency and it raises questions about organizational capacity and planning rigor.',
  11),
(quiz_id,
  'The seven-layer business architecture capstone includes which of the following layers?',
  '[{"id":"a","text":"Offer, Funnel, Enrollment, CRM, Customer Success, Content/Marketing, Financial & Operations"},{"id":"b","text":"Vision, Mission, Values, Goals, Strategies, Tactics, Metrics"},{"id":"c","text":"Leadership, Culture, Technology, Process, People, Capital, Brand"},{"id":"d","text":"Awareness, Interest, Decision, Action, Retention, Referral, Expansion"}]',
  'a',
  'The seven-layer business architecture addresses: (1) Offer, (2) Funnel, (3) Enrollment & Delivery, (4) CRM & Pipeline, (5) Customer Success, (6) Content & Marketing, and (7) Financial & Operations. Together these layers constitute the complete operational blueprint of a certification business.',
  12),
(quiz_id,
  'What distinguishes a "business architecture" from a "business plan"?',
  '[{"id":"a","text":"A business plan is required for bank loans; a business architecture is required for USDA grants"},{"id":"b","text":"A business architecture documents exactly how the business operates (tools, automations, SOPs, roles), not just what it intends to do"},{"id":"c","text":"A business plan is shorter and easier to write than a business architecture"},{"id":"d","text":"A business architecture includes financial projections; a business plan does not"}]',
  'b',
  'A business plan describes intentions — what the business will do and why. A business architecture documents operations — exactly which tools, automations, and SOPs make the business run, with enough specificity that a new team member could use it to understand and operate the business.',
  13),
(quiz_id,
  'An accountability structure for the 90-Day Launch Plan should include:',
  '[{"id":"a","text":"A daily journal of activities completed"},{"id":"b","text":"A specific person who knows your commitment and a review date 30 days from now"},{"id":"c","text":"A signed contract with Cap Fund Academy committing to launch"},{"id":"d","text":"A public social media post announcing your goals"}]',
  'b',
  'Effective accountability requires: a specific person (accountability partner, board member, cohort peer) who knows your commitment, and a specific review date 30 days out. Shared goals with a real person and a calendar date are more binding than private intentions or social media posts.',
  14),
(quiz_id,
  'What is the highest-credential in the Cap Fund Academy system, and what certifications are required to earn it?',
  '[{"id":"a","text":"Certified RLF Executive — requires Certs 1-14"},{"id":"b","text":"USDA Rural Capital Program Specialist — requires Certs 1-13"},{"id":"c","text":"Master Rural Microfinance & RLF Administrator — requires all 17 certifications including the Master Capstone"},{"id":"d","text":"Revolving Loan Fund Practitioner — requires Certs 1-9"}]',
  'c',
  'The Master Rural Microfinance & RLF Administrator is the highest credential in the Cap Fund Academy system. It is awarded upon completion of all 17 certifications, including the Master Capstone (Cert 17). It recognizes mastery of both USDA rural capital programs and the business systems to build a self-sustaining certification operation.',
  15)
ON CONFLICT DO NOTHING;

END $$;
