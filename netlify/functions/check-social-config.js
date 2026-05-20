// check-social-config.js — instant env var diagnostic for social automation
// Returns which keys are set vs missing, no API calls made
const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
};

exports.handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') return { statusCode: 204, headers: CORS, body: '' };

  const checks = {
    SUPABASE_URL:            !!process.env.SUPABASE_URL,
    SUPABASE_SERVICE_ROLE_KEY: !!process.env.SUPABASE_SERVICE_ROLE_KEY,
    OPENAI_API_KEY:          !!process.env.OPENAI_API_KEY,
    BUFFER_ACCESS_TOKEN:     !!process.env.BUFFER_ACCESS_TOKEN,
    BUFFER_PROFILE_LINKEDIN: !!process.env.BUFFER_PROFILE_LINKEDIN,
    BUFFER_PROFILE_INSTAGRAM:!!process.env.BUFFER_PROFILE_INSTAGRAM,
    BUFFER_PROFILE_TIKTOK:   !!process.env.BUFFER_PROFILE_TIKTOK,
  };

  const missing  = Object.entries(checks).filter(([,v]) => !v).map(([k]) => k);
  const present  = Object.entries(checks).filter(([,v]) =>  v).map(([k]) => k);
  const allGood  = missing.length === 0;

  // Mask a few chars of sensitive values so you can confirm they look right
  const hints = {};
  if (process.env.OPENAI_API_KEY)
    hints.OPENAI_API_KEY = process.env.OPENAI_API_KEY.slice(0, 7) + '…';
  if (process.env.BUFFER_ACCESS_TOKEN)
    hints.BUFFER_ACCESS_TOKEN = process.env.BUFFER_ACCESS_TOKEN.slice(0, 8) + '…';
  if (process.env.BUFFER_PROFILE_LINKEDIN)
    hints.BUFFER_PROFILE_LINKEDIN = process.env.BUFFER_PROFILE_LINKEDIN;
  if (process.env.BUFFER_PROFILE_INSTAGRAM)
    hints.BUFFER_PROFILE_INSTAGRAM = process.env.BUFFER_PROFILE_INSTAGRAM;
  if (process.env.BUFFER_PROFILE_TIKTOK)
    hints.BUFFER_PROFILE_TIKTOK = process.env.BUFFER_PROFILE_TIKTOK;

  return {
    statusCode: allGood ? 200 : 500,
    headers: { ...CORS, 'Content-Type': 'application/json' },
    body: JSON.stringify({ allGood, missing, present, hints }),
  };
};
