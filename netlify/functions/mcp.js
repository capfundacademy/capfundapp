// mcp.js — MCP reverse proxy for Buffer's MCP server
// Routes: /mcp -> https://mcp.buffer.com/mcp
// Forwards the OAuth token ChatGPT sends after authenticating with Buffer.
// Owning this endpoint on capfundacademy.com means we pass OpenAI domain
// verification without needing Buffer to configure anything on their end.

const TARGET = 'https://mcp.buffer.com/mcp';

const CORS = {
  'Access-Control-Allow-Origin':  '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS, DELETE',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization, Accept, Mcp-Session-Id',
};

exports.handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') {
    return { statusCode: 204, headers: CORS, body: '' };
  }

  // Forward headers — pass Authorization (OAuth token) through unchanged
  const forwardHeaders = { 'Content-Type': 'application/json' };
  if (event.headers['authorization'])  forwardHeaders['Authorization']  = event.headers['authorization'];
  if (event.headers['accept'])         forwardHeaders['Accept']          = event.headers['accept'];
  if (event.headers['mcp-session-id']) forwardHeaders['Mcp-Session-Id']  = event.headers['mcp-session-id'];

  let res;
  try {
    res = await fetch(TARGET, {
      method:  event.httpMethod,
      headers: forwardHeaders,
      body:    event.body || undefined,
      signal:  AbortSignal.timeout(25000),
    });
  } catch (e) {
    return {
      statusCode: 502,
      headers: { ...CORS, 'Content-Type': 'application/json' },
      body: JSON.stringify({ error: 'Upstream MCP error', detail: e.message }),
    };
  }

  const body = await res.text();

  // Forward content-type from upstream (may be application/json or text/event-stream)
  const ct = res.headers.get('content-type') || 'application/json';

  return {
    statusCode: res.status,
    headers: { ...CORS, 'Content-Type': ct },
    body,
  };
};
