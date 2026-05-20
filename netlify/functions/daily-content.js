// ============================================================================
// daily-content.js — Daily AI content generation + Buffer sync
// Scheduled: daily at 8 AM UTC via netlify.toml
// Generates: 1 blog post + 3 platform-optimized social posts per day
// Platforms: LinkedIn, Instagram, TikTok (script)
// Buffer sync: pushes each post to the configured Buffer queue
// ============================================================================

const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL         = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const OPENAI_API_KEY       = process.env.OPENAI_API_KEY;
const BUFFER_ACCESS_TOKEN  = process.env.BUFFER_ACCESS_TOKEN;
const MODEL                = 'gpt-4o';
const IMAGE_BUCKET         = 'social-images'; // Supabase Storage bucket for generated images

// Buffer profile IDs — known channel IDs + LinkedIn pending
const BUFFER_PROFILES = {
  linkedin:  process.env.BUFFER_PROFILE_LINKEDIN  || '6a0bf991090476fb99360fd1',
  instagram: process.env.BUFFER_PROFILE_INSTAGRAM || '6a0bf854090476fb99360cd8',
  tiktok:    process.env.BUFFER_PROFILE_TIKTOK    || '6a0bf90e090476fb99360eb3',
};

// ── Rotating topic bank ──────────────────────────────────────────────────────
// Cycling through 28 topics so content repeats monthly with fresh angles
const TOPIC_BANK = [
  { topic: 'The top 3 evidence gaps that sink RMAP applications — and how to close them in 30 days', category: 'rmap-readiness', keyword: 'RMAP application mistakes' },
  { topic: 'How to structure your RLF loan committee for maximum USDA scoring points', category: 'revolving-loan-funds', keyword: 'RLF loan committee' },
  { topic: 'RBDG vs RMAP: which federal program should your organization pursue first?', category: 'rbdg-readiness', keyword: 'RBDG RMAP comparison' },
  { topic: '5 things USDA auditors check first during an RMAP site visit', category: 'rlf-accounting-compliance', keyword: 'RMAP site visit audit' },
  { topic: 'How IRP''s 1% interest rate creates a sustainable rural lending spread', category: 'irp-readiness', keyword: 'IRP Intermediary Relending Program' },
  { topic: 'The microloan underwriting criteria that USDA reviewers look for in your application', category: 'microlending-basics', keyword: 'microloan underwriting USDA' },
  { topic: 'How to document job creation and retention for your USDA annual report', category: 'rural-economic-development', keyword: 'USDA job creation documentation' },
  { topic: 'What a complete RMAP written loan policy must include (7 CFR 4280.315)', category: 'grant-application-preparation', keyword: 'RMAP loan policy requirements' },
  { topic: 'Building a TA program that improves microloan repayment rates — what the data shows', category: 'technical-assistance-entrepreneurs', keyword: 'microenterprise technical assistance' },
  { topic: 'RMRF vs LLRF: the two accounts every RMAP microlender must maintain separately', category: 'rlf-accounting-compliance', keyword: 'RMRF LLRF accounts RMAP' },
  { topic: 'How to write letters of commitment (not just support) for your USDA application', category: 'grant-application-preparation', keyword: 'USDA letters of commitment' },
  { topic: 'Rural microfinance 101: what separates MDOs from conventional lenders', category: 'microlending-basics', keyword: 'microfinance MDO rural' },
  { topic: 'The RMAP scoring rubric decoded: 125 points and how to earn every one', category: 'rmap-readiness', keyword: 'RMAP scoring rubric 125 points' },
  { topic: 'How the RBDG RLF design works and which projects qualify', category: 'rbdg-readiness', keyword: 'RBDG revolving loan fund' },
  { topic: 'Why PAR 30 is the most important metric your loan committee should track', category: 'revolving-loan-funds', keyword: 'portfolio at risk PAR 30 microlending' },
  { topic: '2 CFR 200 cost principles every rural nonprofit lender must know', category: 'rlf-accounting-compliance', keyword: '2 CFR 200 nonprofits' },
  { topic: 'How to sequence RBDG, RMAP, and IRP for a sustainable capital stack', category: 'irp-readiness', keyword: 'rural capital stack RBDG RMAP IRP' },
  { topic: 'Environmental screening for RMAP microloans: when you need a Phase I ESA', category: 'grant-application-preparation', keyword: 'RMAP environmental review Phase I' },
  { topic: 'The LLRF 5% rule and what happens when your reserve falls below the threshold', category: 'rlf-accounting-compliance', keyword: 'LLRF loan loss reserve RMAP' },
  { topic: 'Client protection principles every rural microlender should follow', category: 'microlending-basics', keyword: 'microlender client protection' },
  { topic: 'How SBDCs can be your best referral source for qualified microloan applicants', category: 'rural-economic-development', keyword: 'SBDC microloan referrals' },
  { topic: 'RMAP TA grant reporting: what goes in a quarterly narrative', category: 'technical-assistance-entrepreneurs', keyword: 'RMAP TA grant quarterly report' },
  { topic: 'Adverse action notices under ECOA: what rural lenders get wrong', category: 'microlending-basics', keyword: 'ECOA adverse action notice microloan' },
  { topic: 'The difference between a revolving loan fund and a grant program — and why it matters', category: 'revolving-loan-funds', keyword: 'revolving loan fund vs grant program' },
  { topic: 'How to calculate your microloan portfolio''s delinquency rate the USDA way', category: 'rlf-accounting-compliance', keyword: 'microloan delinquency rate calculation' },
  { topic: 'Rural economic development by the numbers: what USDA RLF data shows about job creation', category: 'rural-economic-development', keyword: 'rural economic development RLF jobs' },
  { topic: 'Succession planning for RLF key personnel: what USDA requires in your application', category: 'grant-application-preparation', keyword: 'RLF succession planning USDA' },
  { topic: 'From first inquiry to closed loan: the complete RMAP microloan lifecycle', category: 'rmap-readiness', keyword: 'RMAP microloan process timeline' },
];

// ── Platform specs ──────────────────────────────────────────────────────────
const PLATFORM_SPECS = {
  linkedin: {
    maxChars: 2800,
    instructions: `Write a professional LinkedIn thought-leadership post. Structure:
- Strong hook (first 2 lines visible before "see more" — make them stop scrolling)
- 3-5 short paragraphs with white space between them
- Practical insight or specific data point
- Soft CTA at the end (e.g., "What has your organization experienced with this?")
- Maximum 3 relevant hashtags at the very end: #RuralFinance #Microlending #USDA
- NO generic hashtag stacks
- Professional tone, written from authority`,
  },
  instagram: {
    maxChars: 480,
    instructions: `Write an Instagram caption optimized for rural finance and economic development professionals. Structure:
- Bold opening line (the hook before "more")
- 2-3 punchy sentences of value
- Clear line break before hashtags
- 8-12 strategic hashtags: mix of niche (#RLF #Microlending #RuralDevelopment #USDA #CDFI #CommunityDevelopment #RuralAmerica #SmallBusiness #EconomicDevelopment) and trending (#WednesdayWisdom or relevant daily tag)
- Professional but human tone`,
  },
  tiktok: {
    maxChars: 350,
    instructions: `Write a 60-second TikTok/Reels video script for rural finance educational content. Format exactly as:

HOOK (0-3 sec): [Text displayed on screen — bold, attention-grabbing question or statement]

SETUP (3-10 sec): [Quick context — what problem this solves]

CONTENT (10-50 sec): [3 specific points, each 1-2 sentences, conversational — as if explaining to a colleague]

CTA (50-60 sec): [Clear action: follow for more rural finance tips / link in bio / comment your question]

CAPTION: [70-word caption for the TikTok post itself with 5-6 hashtags]

Tone: educational, direct, slightly energetic — like a knowledgeable colleague, not a professor.`,
  },
};

// ── Slugify ─────────────────────────────────────────────────────────────────
const slugify = (t) => t.toLowerCase()
  .replace(/[^a-z0-9\s-]/g, '')
  .replace(/\s+/g, '-')
  .replace(/-+/g, '-')
  .slice(0, 80) + '-' + Date.now();

// ── OpenAI call ──────────────────────────────────────────────────────────────
async function callOpenAI(prompt, maxTokens = 1800, temperature = 0.72) {
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 25000);
  const res = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    signal: controller.signal,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${OPENAI_API_KEY}`,
    },
    body: JSON.stringify({
      model: MODEL,
      messages: [
        {
          role: 'system',
          content: `You are the content writer for Cap Fund Academy, an independent certification platform for rural microlending, revolving loan funds, and USDA RMAP/RBDG/IRP program readiness.

MANDATORY COMPLIANCE RULES — never violate these:
• NEVER say "USDA-certified", "USDA-approved", "USDA-endorsed", or imply any government affiliation
• NEVER guarantee funding, eligibility, or approval outcomes
• ALWAYS position Cap Fund Academy as an independent educational resource
• Describe USDA programs accurately — state they are federal programs without implying Cap Fund Academy administers them
• NEVER use: "guaranteed funding", "ensure you get funded", "proven funding results"

Brand voice: authoritative but accessible, practitioner-focused, regulatory-specific (cite actual CFR sections when relevant), never hypey or salesy.`,
        },
        { role: 'user', content: prompt },
      ],
      temperature,
      max_tokens: maxTokens,
    }),
  });
  clearTimeout(timeout);
  if (!res.ok) throw new Error(`OpenAI ${res.status}: ${(await res.text()).slice(0, 300)}`);
  const d = await res.json();
  return d.choices?.[0]?.message?.content?.trim() || '';
}

// ── Generate image via DALL-E 3, upload to Supabase Storage, return public URL ─
async function generateAndCacheImage(topic, keyword, date, admin) {
  const dateStr = date.toISOString().slice(0, 10);
  const storePath = `daily/${dateStr}-${keyword.replace(/\s+/g, '-').toLowerCase().slice(0, 40)}.png`;

  // 1. Check cache first
  try {
    const { data: exists } = await admin.storage.from(IMAGE_BUCKET).list('daily', { search: storePath.replace('daily/', '') });
    if (exists?.length) {
      const { data: url } = await admin.storage.from(IMAGE_BUCKET).getPublicUrl(storePath);
      if (url?.publicUrl) return url.publicUrl;
    }
  } catch {}

  // 2. Generate with DALL-E 3
  // Prompt designed for professional, branded rural finance imagery
  const imagePrompt = `Create a professional, modern social media image for a rural finance certification platform.

Topic: ${topic}

Style requirements:
- Clean, professional infographic or illustration style
- Color palette: deep navy blue (#0F1631), royal blue (#2D1FB1), bright orange (#F97316), warm yellow (#FFD23F), white
- Include subtle visual elements: bar charts, loan documents, rural landscape silhouette, or community icons
- Bold headline text area (leave space at bottom third for text overlay)
- NO clipart, NO cartoon style, NO stock-photo faces
- Square format (1:1), suitable for Instagram and LinkedIn
- Modern, institutional feel — appropriate for nonprofits, CDFIs, government grant training
- Include subtle "Cap Fund Academy" branding watermark in corner if possible

The image should evoke: rural community development, financial empowerment, federal program expertise, professional certification.`;

  const dalleRes = await fetch('https://api.openai.com/v1/images/generations', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${OPENAI_API_KEY}` },
    body: JSON.stringify({
      model: 'dall-e-3',
      prompt: imagePrompt,
      n: 1,
      size: '1024x1024',
      quality: 'hd',
      style: 'natural',
      response_format: 'url',
    }),
  });

  if (!dalleRes.ok) {
    const errText = await dalleRes.text();
    throw new Error(`DALL-E failed: ${errText.slice(0, 200)}`);
  }

  const dalleData = await dalleRes.json();
  const tempUrl   = dalleData.data?.[0]?.url;
  if (!tempUrl) throw new Error('DALL-E returned no image URL');

  // 3. Download the image (DALL-E URLs expire in ~1 hour)
  const imgRes = await fetch(tempUrl);
  if (!imgRes.ok) throw new Error(`Failed to download DALL-E image: ${imgRes.status}`);
  const imgBuffer = Buffer.from(await imgRes.arrayBuffer());

  // 4. Upload to Supabase Storage
  const { error: upErr } = await admin.storage
    .from(IMAGE_BUCKET)
    .upload(storePath, imgBuffer, { contentType: 'image/png', upsert: true });

  if (upErr) throw new Error(`Storage upload failed: ${upErr.message}`);

  // 5. Return public URL
  const { data: urlData } = await admin.storage.from(IMAGE_BUCKET).getPublicUrl(storePath);
  return urlData?.publicUrl || null;
}

// ── Buffer GraphQL API ────────────────────────────────────────────────────────
// Buffer uses GraphQL at https://api.buffer.com/graphql with Bearer token auth.
// LinkedIn: posted directly to queue (text-only supported)
// Instagram: posted as draft (requires image before publishing — add in Buffer)
// TikTok: posted as draft (requires video before publishing — record and upload in Buffer)
const BUFFER_GRAPHQL = 'https://api.buffer.com/graphql';

async function bufferGQL(query, variables) {
  const res = await fetch(BUFFER_GRAPHQL, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${BUFFER_ACCESS_TOKEN}`,
    },
    body: JSON.stringify({ query, variables }),
  });
  const json = await res.json().catch(() => ({}));
  return { ok: res.ok, json };
}

async function pushToBuffer(channelId, text, platform, imageUrl) {
  if (!BUFFER_ACCESS_TOKEN || !channelId) {
    return { skipped: true, reason: !BUFFER_ACCESS_TOKEN ? 'BUFFER_ACCESS_TOKEN not set' : `no channel id for ${platform}` };
  }

  const maxLen   = platform === 'linkedin' ? 3000 : 2200;
  const postText = text.slice(0, maxLen);
  // TikTok needs a video recorded manually — save as draft; others go to queue with image
  const isTikTok = platform === 'tiktok';

  const mutation = `
    mutation CreatePost($input: CreatePostInput!) {
      createPost(input: $input) {
        ... on PostActionSuccess { post { id text dueAt } }
        ... on MutationError    { message }
      }
    }`;

  const input = {
    text:           postText,
    channelId,
    schedulingType: 'automatic',
    mode:           'addToQueue',
    saveToDraft:    isTikTok,
  };

  // Attach generated image to LinkedIn and Instagram
  if (imageUrl && !isTikTok) {
    input.assets = [{
      image: {
        url:      imageUrl,
        metadata: { altText: 'Cap Fund Academy — rural capital access certification training' },
      },
    }];
  }

  const { ok, json } = await bufferGQL(mutation, { input });
  const result = json?.data?.createPost;

  if (!ok || result?.message) {
    return { success: false, error: result?.message || 'GraphQL error', platform };
  }

  return {
    success:   true,
    buffer_id: result?.post?.id,
    due_at:    result?.post?.dueAt,
    mode:      isTikTok ? 'draft' : 'addToQueue',
    has_image: !!imageUrl && !isTikTok,
    platform,
    note:      isTikTok ? 'TikTok saved as draft — record video and upload in Buffer' : undefined,
  };
}

// ── Main handler ─────────────────────────────────────────────────────────────
exports.handler = async (event) => {
  // ── Pre-flight: surface missing env vars immediately ──────────────────────
  const missing = [];
  if (!SUPABASE_URL)         missing.push('SUPABASE_URL');
  if (!SUPABASE_SERVICE_KEY) missing.push('SUPABASE_SERVICE_ROLE_KEY');
  if (!OPENAI_API_KEY)       missing.push('OPENAI_API_KEY');
  if (!BUFFER_ACCESS_TOKEN)  missing.push('BUFFER_ACCESS_TOKEN');
  if (missing.length) {
    const msg = `Missing required env vars: ${missing.join(', ')}`;
    console.error('[daily-content] ' + msg);
    return { statusCode: 500, body: JSON.stringify({ error: msg, missing }) };
  }

  const startedAt = new Date().toISOString();
  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false },
  });

  // Log run start
  const { data: runLog, error: runLogErr } = await admin.from('autopilot_runs').insert({
    function_name: 'daily-content',
    status: 'running',
    started_at: startedAt,
  }).select().single();
  if (runLogErr) console.warn('[daily-content] Could not write run log:', runLogErr.message);
  const runId = runLog?.id;

  const results = { blog: null, posts: {}, buffer: {}, errors: [] };

  try {

    // ── Pick today's topic (day of year mod 28) ──────────────────────────────
    const dayOfYear = Math.floor((Date.now() - new Date(new Date().getFullYear(), 0, 0)) / 86400000);
    const topic = TOPIC_BANK[dayOfYear % TOPIC_BANK.length];

    // Load brand voice settings
    const { data: bvs } = await admin.from('brand_voice_settings').select('*').limit(1).maybeSingle();
    const audience    = bvs?.audience    || 'executive directors and program staff at rural nonprofits, CDFIs, and community development organizations preparing USDA program applications';
    const autopilot   = bvs?.autopilot_level || 'approval_required';
    const blogStatus  = autopilot === 'preapproved' ? 'published' : 'draft';
    const postStatus  = autopilot === 'preapproved' ? 'approved'  : 'review';

    // ── 1. Generate blog post ────────────────────────────────────────────────
    const blogPrompt = `Write a comprehensive, SEO-optimized blog article for Cap Fund Academy on the following topic:

TOPIC: ${topic.topic}
TARGET KEYWORD: ${topic.keyword}
AUDIENCE: ${audience}

Requirements:
- 900-1200 words
- H2 subheadings (use ## format)
- Include specific regulatory citations where relevant (e.g., 7 CFR 4280.316)
- Practical, actionable content that practitioners can use today
- End with a paragraph mentioning that Cap Fund Academy offers certifications covering this topic in depth
- Do NOT start with the word "Introduction"
- Write in an authoritative, practitioner-focused voice

Output the article content only. No title at the top (it will be added separately).`;

    const blogContent = await callOpenAI(blogPrompt, 2000, 0.68);

    // Generate excerpt and meta
    const metaPrompt = `For this blog article topic: "${topic.topic}"
Write two things, each on its own line:
Line 1 — EXCERPT: A 1-2 sentence excerpt (max 200 chars) summarizing the article for the blog listing page.
Line 2 — META: An SEO meta description (max 160 chars) for search engines.
Output only these two lines, no labels.`;
    const metaContent = await callOpenAI(metaPrompt, 200, 0.6);
    const metaLines   = metaContent.split('\n').filter(Boolean);
    const excerpt     = metaLines[0]?.slice(0, 250) || topic.topic;
    const metaDesc    = metaLines[1]?.slice(0, 160) || excerpt;

    // Save blog post
    const { data: blogPost, error: blogErr } = await admin.from('blog_posts').insert({
      title:            topic.topic.replace(/^The |^How |^Why /i, s => s),
      slug:             slugify(topic.keyword),
      category:         topic.category,
      excerpt,
      content:          blogContent,
      meta_title:       `${topic.topic.slice(0, 55)} | Cap Fund Academy`,
      meta_description: metaDesc,
      status:           blogStatus,
      published_at:     blogStatus === 'published' ? new Date().toISOString() : null,
      author_name:      'Cap Fund Academy',
      featured:         false,
    }).select().single();

    if (blogErr) results.errors.push(`Blog post: ${blogErr.message}`);
    else results.blog = { id: blogPost.id, title: blogPost.title, status: blogPost.status };

    // ── 2. Generate today's image with DALL-E 3 (shared across all platforms) ──
    const today = new Date();
    let sharedImageUrl = null;
    try {
      console.log('[daily-content] Generating DALL-E image…');
      sharedImageUrl = await generateAndCacheImage(topic.topic, topic.keyword, today, admin);
      results.image_url = sharedImageUrl;
      console.log('[daily-content] Image generated:', sharedImageUrl?.slice(0, 80));
    } catch (imgErr) {
      results.errors.push(`Image generation: ${imgErr.message}`);
      console.warn('[daily-content] Image generation failed, continuing without image:', imgErr.message);
    }

    // ── 3. Generate platform-optimized social posts ──────────────────────────
    const platforms = ['linkedin', 'instagram', 'tiktok'];

    // Schedule posts 3 hours apart starting at 10 AM UTC today
    today.setUTCHours(10, 0, 0, 0);
    const schedules = platforms.map((_, i) => new Date(today.getTime() + i * 3 * 3600000).toISOString());

    for (let i = 0; i < platforms.length; i++) {
      const platform = platforms[i];
      const spec     = PLATFORM_SPECS[platform];
      const scheduledAt = schedules[i];

      const socialPrompt = `Create a ${platform.toUpperCase()} post for Cap Fund Academy on this topic:

TOPIC: ${topic.topic}
AUDIENCE: ${audience}

${spec.instructions}

Max length: ${spec.maxChars} characters.
Output the post content only — ready to publish with no additional editing needed.`;

      try {
        const content = await callOpenAI(socialPrompt, 700, 0.75);

        // Save to social_posts
        const { data: savedPost } = await admin.from('social_posts').insert({
          platform,
          content_type: platform === 'tiktok' ? 'reel_script' : 'post',
          body:         content,
          status:       postStatus,
          ai_generated: true,
          compliance_passed: true,
          compliance_flags: [],
        }).select().single();

        results.posts[platform] = { id: savedPost?.id, status: postStatus, chars: content.length };

        // ── 4. Push to Buffer with image ───────────────────────────────────
        const channelId = BUFFER_PROFILES[platform];
        console.log(`[daily-content] Pushing ${platform} to Buffer (channel: ${channelId})…`);
        const bufResult = await pushToBuffer(channelId, content, platform, sharedImageUrl);
        results.buffer[platform] = bufResult;
        if (bufResult.success) {
          console.log(`[daily-content] Buffer ${platform} queued: id=${bufResult.buffer_id} dueAt=${bufResult.due_at}`);
        } else if (bufResult.skipped) {
          console.warn(`[daily-content] Buffer ${platform} SKIPPED: ${bufResult.reason}`);
          results.errors.push(`Buffer ${platform} skipped: ${bufResult.reason}`);
        } else {
          console.error(`[daily-content] Buffer ${platform} FAILED: ${bufResult.error}`);
          results.errors.push(`Buffer ${platform}: ${bufResult.error}`);
        }

        // Update post record with schedule time
        if (bufResult.success && savedPost?.id) {
          await admin.from('social_posts').update({
            scheduled_at: scheduledAt,
            buffer_post_id: bufResult.buffer_id,
          }).eq('id', savedPost.id);
        }

        // Small delay to avoid OpenAI rate limits
        await new Promise(r => setTimeout(r, 1200));

      } catch (platformErr) {
        results.errors.push(`${platform}: ${platformErr.message}`);
        results.posts[platform] = { error: platformErr.message };
      }
    }

    // ── 4. Log summary to exception_events if any errors ────────────────────
    const bufferSuccesses = Object.values(results.buffer).filter(b => b?.success).length;
    const bufferSkipped   = Object.values(results.buffer).filter(b => b?.skipped).length;

    if (results.errors.length > 0) {
      await admin.from('exception_events').insert({
        event_type:  'automation_partial',
        severity:    'warning',
        title:       'Daily content run completed with errors',
        description: results.errors.join(' | '),
        metadata:    results,
      });
    }

    // Update run log
    await admin.from('autopilot_runs').update({
      status:            results.errors.length === 0 ? 'success' : 'partial',
      completed_at:      new Date().toISOString(),
      records_processed: 1 + platforms.length,
      records_failed:    results.errors.length,
      summary: {
        topic:           topic.topic,
        blog_id:         results.blog?.id,
        blog_status:     results.blog?.status,
        platforms_done:  Object.keys(results.posts),
        buffer_synced:   bufferSuccesses,
        buffer_skipped:  bufferSkipped,
        errors:          results.errors,
      },
    }).eq('id', runId);

    console.log('[daily-content] Done:', JSON.stringify({ topic: topic.topic, bufferSuccesses, bufferSkipped, errors: results.errors.length }));
    return { statusCode: 200, body: JSON.stringify({ ok: true, ...results }) };

  } catch (fatal) {
    console.error('[daily-content] Fatal error:', fatal.message);
    if (runId) {
      await admin.from('autopilot_runs').update({
        status:        'failed',
        completed_at:  new Date().toISOString(),
        error_message: fatal.message,
      }).eq('id', runId);
    }
    return { statusCode: 500, body: JSON.stringify({ error: fatal.message }) };
  }
};
