// oauth-metadata.js — OAuth 2.0 Authorization Server Metadata (RFC 8414)
// Served at /.well-known/oauth-authorization-server
// Allows OpenAI's MCP scanner to auto-discover Buffer's OAuth configuration
// when the MCP server URL is https://capfundacademy.com/mcp
exports.handler = async () => ({
  statusCode: 200,
  headers: {
    'Content-Type':                'application/json',
    'Access-Control-Allow-Origin': '*',
  },
  body: JSON.stringify({
    issuer:                                'https://api.bufferapp.com',
    authorization_endpoint:               'https://app.buffer.com/oauth2/authorize',
    token_endpoint:                       'https://api.bufferapp.com/1/oauth2/token.json',
    scopes_supported:                     ['publish', 'read_access'],
    response_types_supported:             ['code'],
    grant_types_supported:                ['authorization_code', 'refresh_token'],
    token_endpoint_auth_methods_supported:['client_secret_post'],
    code_challenge_methods_supported:     ['S256'],
  }),
});
