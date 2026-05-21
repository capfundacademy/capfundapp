// mcp.js — MCP reverse proxy for Buffer's MCP server
// Routes: /mcp -> https://mcp.buffer.com/mcp
//
// For unauthenticated OpenAI scan requests (no Bearer token):
//   - initialize   -> returns minimal valid MCP server info
//   - tools/list   -> returns the known Buffer MCP tool list
//   - anything else -> 401 JSON-RPC error
//
// For authenticated requests: forwards to Buffer with the OAuth token.

const TARGET = 'https://mcp.buffer.com/mcp';

const CORS = {
  'Access-Control-Allow-Origin':  '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS, DELETE',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization, Accept, Mcp-Session-Id',
};

const JSON_CT = { ...CORS, 'Content-Type': 'application/json' };

// Known Buffer MCP tools (from live scan of mcp.buffer.com)
const BUFFER_TOOLS = [
  { name: 'get_account',       description: 'Retrieve the authenticated Buffer account profile information.',                  inputSchema: { type: 'object', properties: {} } },
  { name: 'list_channels',     description: 'List all social media channels connected to the Buffer account.',                inputSchema: { type: 'object', properties: {} } },
  { name: 'get_channel',       description: 'Retrieve detailed metadata for a specific Buffer channel by its ID.',            inputSchema: { type: 'object', properties: { channelId: { type: 'string' } }, required: ['channelId'] } },
  { name: 'list_posts',        description: 'List queued, scheduled, sent, or draft posts for a given Buffer channel.',       inputSchema: { type: 'object', properties: { channelId: { type: 'string' }, status: { type: 'string' } } } },
  { name: 'get_post',          description: 'Retrieve full details of a single Buffer post by its ID.',                       inputSchema: { type: 'object', properties: { postId: { type: 'string' } }, required: ['postId'] } },
  { name: 'create_idea',       description: 'Create a new content idea or draft in Buffer idea storage.',                     inputSchema: { type: 'object', properties: { content: { type: 'object' } } } },
  { name: 'create_post',       description: 'Create and queue a new social media post in Buffer for a specified channel.',    inputSchema: { type: 'object', properties: { channelId: { type: 'string' }, text: { type: 'string' } }, required: ['channelId', 'text'] } },
  { name: 'edit_post',         description: 'Edit the content or scheduled time of an existing Buffer post.',                 inputSchema: { type: 'object', properties: { postId: { type: 'string' } }, required: ['postId'] } },
  { name: 'delete_post',       description: 'Permanently delete a queued or draft Buffer post.',                             inputSchema: { type: 'object', properties: { postId: { type: 'string' } }, required: ['postId'] } },
  { name: 'introspect_schema', description: 'Retrieve the GraphQL schema of Buffer\'s API.',                                  inputSchema: { type: 'object', properties: {} } },
  { name: 'execute_query',     description: 'Execute a read-only GraphQL query against Buffer\'s API.',                       inputSchema: { type: 'object', properties: { query: { type: 'string' } }, required: ['query'] } },
  { name: 'execute_mutation',  description: 'Execute a GraphQL mutation against Buffer\'s API.',                              inputSchema: { type: 'object', properties: { mutation: { type: 'string' } }, required: ['mutation'] } },
];

function rpcResult(id, result) {
  return { statusCode: 200, headers: JSON_CT, body: JSON.stringify({ jsonrpc: '2.0', id, result }) };
}

exports.handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') {
    return { statusCode: 204, headers: CORS, body: '' };
  }

  const hasAuth = !!(event.headers['authorization'] || event.headers['Authorization']);

  // ── Unauthenticated discovery (OpenAI MCP scan) ───────────────────────────
  if (!hasAuth && event.httpMethod === 'POST') {
    let body = {};
    try { body = JSON.parse(event.body || '{}'); } catch {}

    if (body.method === 'initialize') {
      return rpcResult(body.id ?? 1, {
        protocolVersion: '2024-11-05',
        capabilities:    { tools: {} },
        serverInfo:      { name: 'cap-fund-academy-buffer-proxy', version: '1.0.0' },
      });
    }

    if (body.method === 'tools/list') {
      return rpcResult(body.id ?? 1, { tools: BUFFER_TOOLS });
    }

    // Any other unauthenticated call → auth required
    return {
      statusCode: 401,
      headers: JSON_CT,
      body: JSON.stringify({
        jsonrpc: '2.0', id: body.id ?? null,
        error: { code: -32001, message: 'Authentication required' },
      }),
    };
  }

  // ── Authenticated: proxy to Buffer ────────────────────────────────────────
  const forwardHeaders = { 'Content-Type': 'application/json' };
  if (event.headers['authorization'])  forwardHeaders['Authorization']  = event.headers['authorization'];
  if (event.headers['Authorization'])  forwardHeaders['Authorization']  = event.headers['Authorization'];
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
      headers: JSON_CT,
      body: JSON.stringify({ error: 'Upstream MCP error', detail: e.message }),
    };
  }

  const responseBody = await res.text();
  const ct = res.headers.get('content-type') || 'application/json';

  return {
    statusCode: res.status,
    headers: { ...CORS, 'Content-Type': ct },
    body: responseBody,
  };
};
