// oauth-metadata.js — OAuth 2.0 metadata pointing to our own auth server
// Our auth server wraps the Buffer personal access token so OpenAI's
// OAuth flow completes successfully without depending on Buffer's auth.buffer.com
exports.handler = async () => ({
  statusCode: 200,
  headers: {
    'Content-Type':                'application/json',
    'Access-Control-Allow-Origin': '*',
  },
  body: JSON.stringify({
    issuer:                                'https://capfundacademy.com',
    authorization_endpoint:               'https://capfundacademy.com/oauth/authorize',
    token_endpoint:                       'https://capfundacademy.com/oauth/token',

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

    resource_parameter_supported: false,
  }),
});
