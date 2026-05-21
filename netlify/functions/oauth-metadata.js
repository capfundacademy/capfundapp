// oauth-metadata.js — serves both OAuth and OIDC discovery documents
// /.well-known/oauth-authorization-server  → OAuth 2.0 metadata (RFC 8414)
// /.well-known/openid-configuration        → OIDC metadata (via separate redirect)
// All values proxied from https://auth.buffer.com/.well-known/openid-configuration
exports.handler = async (event) => {
  const isOIDC = event.path?.includes('openid-configuration');

  const metadata = {
    issuer:                                    'https://auth.buffer.com',
    authorization_endpoint:                    'https://auth.buffer.com/auth',
    token_endpoint:                            'https://auth.buffer.com/token',
    userinfo_endpoint:                         'https://auth.buffer.com/me',
    jwks_uri:                                  'https://auth.buffer.com/jwks',
    registration_endpoint:                     'https://auth.buffer.com/reg',
    revocation_endpoint:                       'https://auth.buffer.com/token/revocation',
    introspection_endpoint:                    'https://auth.buffer.com/token/introspection',
    end_session_endpoint:                      'https://auth.buffer.com/session/end',
    pushed_authorization_request_endpoint:     'https://auth.buffer.com/request',

    response_types_supported:                  ['code', 'code id_token', 'id_token', 'none'],
    response_modes_supported:                  ['form_post', 'fragment', 'query'],
    grant_types_supported:                     ['authorization_code', 'refresh_token', 'implicit', 'client_credentials'],
    token_endpoint_auth_methods_supported:     ['none', 'client_secret_post'],
    code_challenge_methods_supported:          ['S256'],
    subject_types_supported:                   ['public'],
    id_token_signing_alg_values_supported:     ['PS256', 'RS256'],
    dpop_signing_alg_values_supported:         ['ES256', 'Ed25519', 'EdDSA'],
    scopes_supported:                          ['openid', 'offline_access', 'posts:read', 'posts:write', 'ideas:read', 'ideas:write', 'account:read', 'account:write'],
    claims_supported:                          ['sub', 'sid', 'auth_time', 'iss'],
    claim_types_supported:                     ['normal'],
    claims_parameter_supported:                false,
    request_uri_parameter_supported:           false,
    authorization_response_iss_parameter_supported: true,
    resource_parameter_supported:              true,

    // OpenAI-specific discovery hints
    openid_configuration:                      'https://auth.buffer.com/.well-known/openid-configuration',
  };

  return {
    statusCode: 200,
    headers: {
      'Content-Type':                'application/json',
      'Access-Control-Allow-Origin': '*',
    },
    body: JSON.stringify(metadata),
  };
};
