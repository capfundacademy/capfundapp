// oauth-token.js — OAuth 2.0 token endpoint
// Served at /oauth/token
// Accepts any auth code and returns the Buffer personal access token.
// Our MCP proxy at /mcp then forwards this token to mcp.buffer.com.
const CORS = {
  'Access-Control-Allow-Origin':  '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
};

exports.handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') return { statusCode: 204, headers: CORS, body: '' };
  if (event.httpMethod !== 'POST') return { statusCode: 405, headers: CORS, body: 'Method not allowed' };

  // Parse body (may be form-encoded or JSON)
  let params = {};
  const ct = event.headers['content-type'] || '';
  if (ct.includes('application/x-www-form-urlencoded')) {
    params = Object.fromEntries(new URLSearchParams(event.body || ''));
  } else {
    try { params = JSON.parse(event.body || '{}'); } catch {}
  }

  const { grant_type, code, refresh_token } = params;

  if (grant_type !== 'authorization_code' && grant_type !== 'refresh_token') {
    return {
      statusCode: 400,
      headers: { ...CORS, 'Content-Type': 'application/json' },
      body: JSON.stringify({ error: 'unsupported_grant_type' }),
    };
  }

  // Return the real Buffer personal access token as the access token.
  // Our MCP proxy at /mcp forwards it directly to mcp.buffer.com — no translation needed.
  const token = process.env.BUFFER_ACCESS_TOKEN;
  if (!token) {
    return {
      statusCode: 500,
      headers: { ...CORS, 'Content-Type': 'application/json' },
      body: JSON.stringify({ error: 'server_error', error_description: 'BUFFER_ACCESS_TOKEN not configured' }),
    };
  }

  return {
    statusCode: 200,
    headers: { ...CORS, 'Content-Type': 'application/json' },
    body: JSON.stringify({
      access_token:  token,
      token_type:    'Bearer',
      expires_in:    86400,
      refresh_token: `refresh_${Date.now()}`,
      scope:         'posts:read posts:write ideas:read ideas:write account:read account:write offline_access',
    }),
  };
};
