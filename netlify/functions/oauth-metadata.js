// oauth-metadata.js — OAuth 2.0 Authorization Server Metadata (RFC 8414)
// Served at /.well-known/oauth-authorization-server
// Points to Buffer's actual auth server at auth.buffer.com
// Discovered from https://mcp.buffer.com/.well-known/oauth-authorization-server
exports.handler = async () => ({
  statusCode: 200,
  headers: {
    'Content-Type':                'application/json',
    'Access-Control-Allow-Origin': '*',
  },
  body: JSON.stringify({
    issuer:                                'https://auth.buffer.com',
    authorization_endpoint:               'https://auth.buffer.com/auth',
    token_endpoint:                       'https://auth.buffer.com/token',
    response_types_supported:             ['code'],
    grant_types_supported:                ['authorization_code', 'refresh_token'],
    token_endpoint_auth_methods_supported:['none'],
    code_challenge_methods_supported:     ['S256'],
    registration_endpoint:                'https://auth.buffer.com/reg',
    scopes_supported:                     ['posts:read', 'posts:write', 'ideas:read', 'ideas:write', 'account:read', 'account:write', 'offline_access'],
    resource_parameter_supported:         true,
  }),
});
