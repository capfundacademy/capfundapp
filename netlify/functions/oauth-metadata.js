// oauth-metadata.js — OAuth 2.0 metadata only (NO OIDC)
// Buffer's MCP client does not allow the openid scope.
// Advertising OIDC causes OpenAI to auto-inject openid into every auth request,
// which Buffer rejects with invalid_scope. Keep this OAuth-only.
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
    registration_endpoint:                'https://auth.buffer.com/reg',
    revocation_endpoint:                  'https://auth.buffer.com/token/revocation',

    response_types_supported:             ['code'],
    grant_types_supported:                ['authorization_code', 'refresh_token'],
    token_endpoint_auth_methods_supported:['none', 'client_secret_post'],
    code_challenge_methods_supported:     ['S256'],

    scopes_supported: [
      'posts:read', 'posts:write',
      'ideas:read', 'ideas:write',
      'account:read', 'account:write',
      'offline_access',
    ],

    resource_parameter_supported: true,
  }),
});
