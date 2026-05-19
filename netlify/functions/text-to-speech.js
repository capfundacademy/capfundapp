// ============================================================================
// text-to-speech.js — Generate and cache lesson audio via OpenAI TTS HD
//
// Flow:
//   1. Check Supabase Storage for cached audio (audio/lesson-{id}.mp3)
//   2. If cached → return signed URL (avoids re-generating)
//   3. If not cached → strip Markdown → call OpenAI TTS HD → upload → return URL
//
// Voice: onyx (deep, authoritative, professional — ideal for USDA content)
// Model: tts-1-hd (highest quality, most human-sounding)
// Auth:  requires valid Supabase JWT (any authenticated user)
// ============================================================================

const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL         = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const OPENAI_API_KEY       = process.env.OPENAI_API_KEY;
const AUDIO_BUCKET         = 'lesson-audio';

const CORS = {
  'Access-Control-Allow-Origin':  '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
};
const ok  = (b) => ({ statusCode: 200, headers: { ...CORS, 'Content-Type': 'application/json' }, body: JSON.stringify(b) });
const err = (s, m) => ({ statusCode: s, headers: { ...CORS, 'Content-Type': 'application/json' }, body: JSON.stringify({ error: m }) });

// ── Strip Markdown for clean TTS narration ──────────────────────────────────
function stripMarkdown(text) {
  return text
    // Remove heading markers and add natural pause phrasing
    .replace(/^#{1,3}\s+(.+)$/gm, '$1. ')
    // Bold/italic — keep text, remove markers
    .replace(/\*\*(.+?)\*\*/g, '$1')
    .replace(/\*(.+?)\*/g, '$1')
    // Code inline
    .replace(/`(.+?)`/g, '$1')
    // Horizontal rules — become paragraph breaks
    .replace(/^---+$/gm, '\n')
    // Table rows — convert to readable sentences
    .replace(/^\|(.+)\|$/gm, (row) => {
      const cells = row.split('|').map(c => c.trim()).filter(Boolean);
      return cells.join('. ') + '. ';
    })
    // Checkboxes
    .replace(/☐/g, '')
    // Bullet points — convert to natural sentences
    .replace(/^[-•*]\s+(.+)$/gm, '$1. ')
    // Numbered lists
    .replace(/^\d+\.\s+(.+)$/gm, '$1. ')
    // Multiple blank lines → single pause
    .replace(/\n{3,}/g, '\n\n')
    // Clean up extra spaces
    .replace(/  +/g, ' ')
    .trim();
}

// ── Main handler ─────────────────────────────────────────────────────────────
exports.handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') return { statusCode: 204, headers: CORS, body: '' };
  if (event.httpMethod !== 'POST')    return err(405, 'Method not allowed');
  if (!OPENAI_API_KEY)                return err(503, 'TTS not configured');

  // Auth check
  const authHeader = event.headers.authorization || event.headers.Authorization;
  if (!authHeader?.startsWith('Bearer ')) return err(401, 'Missing bearer token');

  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false },
  });

  const { data: userData, error: userErr } = await admin.auth.getUser(authHeader.slice(7));
  if (userErr || !userData?.user) return err(401, 'Invalid session');

  let body;
  try { body = JSON.parse(event.body || '{}'); } catch { return err(400, 'Invalid JSON'); }

  const { lesson_id, content, voice = 'onyx' } = body;
  if (!lesson_id || !content) return err(400, 'lesson_id and content required');

  const validVoices = ['alloy', 'echo', 'fable', 'onyx', 'nova', 'shimmer'];
  const selectedVoice = validVoices.includes(voice) ? voice : 'onyx';

  const storagePath = `lesson-${lesson_id}-${selectedVoice}.mp3`;

  // ── 1. Check cache in Supabase Storage ────────────────────────────────────
  try {
    const { data: signedUrl } = await admin.storage
      .from(AUDIO_BUCKET)
      .createSignedUrl(storagePath, 3600); // 1-hour signed URL
    if (signedUrl?.signedUrl) {
      return ok({ url: signedUrl.signedUrl, cached: true, voice: selectedVoice });
    }
  } catch {
    // File doesn't exist yet — generate below
  }

  // ── 2. Strip Markdown and generate audio ──────────────────────────────────
  const cleanText = stripMarkdown(content);

  // OpenAI TTS has a 4096 character limit per request
  // For longer lessons, split into chunks and concatenate
  const chunks = [];
  const CHUNK_SIZE = 4000;
  for (let i = 0; i < cleanText.length; i += CHUNK_SIZE) {
    chunks.push(cleanText.slice(i, i + CHUNK_SIZE));
  }

  const audioBuffers = [];
  for (const chunk of chunks) {
    const ttsRes = await fetch('https://api.openai.com/v1/audio/speech', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${OPENAI_API_KEY}`,
      },
      body: JSON.stringify({
        model: 'tts-1-hd',         // Highest quality — most human-sounding
        input: chunk,
        voice: selectedVoice,       // onyx: deep, authoritative, professional
        response_format: 'mp3',
        speed: 0.95,               // Slightly slower than default for clarity on dense content
      }),
    });

    if (!ttsRes.ok) {
      const errText = await ttsRes.text();
      return err(502, `TTS generation failed: ${errText.slice(0, 200)}`);
    }

    const buffer = await ttsRes.arrayBuffer();
    audioBuffers.push(Buffer.from(buffer));
  }

  // Combine all chunks
  const fullAudio = Buffer.concat(audioBuffers);

  // ── 3. Upload to Supabase Storage ─────────────────────────────────────────
  const { error: uploadErr } = await admin.storage
    .from(AUDIO_BUCKET)
    .upload(storagePath, fullAudio, {
      contentType: 'audio/mpeg',
      upsert: true,
    });

  if (uploadErr) {
    console.error('Storage upload failed:', uploadErr.message);
    return err(500, `Audio upload failed: ${uploadErr.message}`);
  }

  // ── 4. Return signed URL ──────────────────────────────────────────────────
  const { data: signedUrl } = await admin.storage
    .from(AUDIO_BUCKET)
    .createSignedUrl(storagePath, 3600);

  return ok({ url: signedUrl?.signedUrl, cached: false, voice: selectedVoice, chunks: chunks.length });
};
