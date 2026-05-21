// oauth-authorize.js — minimal OAuth 2.0 authorization endpoint
// Served at /oauth/authorize
// Shows a simple consent page. On approval, redirects to OpenAI's callback
// with an authorization code. The code is exchanged at /oauth/token.
exports.handler = async (event) => {
  const q = event.queryStringParameters || {};
  const { redirect_uri, state, scope, client_id } = q;

  if (!redirect_uri) {
    return { statusCode: 400, body: 'Missing redirect_uri' };
  }

  // POST = user clicked Authorize
  if (event.httpMethod === 'POST') {
    const code = `cfa_${Date.now()}_${Math.random().toString(36).slice(2)}`;
    const params = new URLSearchParams({ code, state: state || '' });
    return {
      statusCode: 302,
      headers: { Location: `${redirect_uri}?${params}` },
      body: '',
    };
  }

  // GET = show consent page
  const html = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1"/>
  <title>Authorize — Cap Fund Academy</title>
  <style>
    *{box-sizing:border-box;margin:0;padding:0}
    body{font-family:Inter,system-ui,sans-serif;background:#F8FAFC;display:flex;align-items:center;justify-content:center;min-height:100vh;padding:24px}
    .card{background:#fff;border:1px solid #e5e7eb;border-radius:16px;padding:40px;max-width:420px;width:100%;text-align:center;box-shadow:0 4px 24px rgba(0,0,0,.07)}
    img{height:56px;width:auto;margin-bottom:24px}
    h1{font-size:20px;font-weight:700;color:#0F1631;margin-bottom:8px}
    p{font-size:14px;color:#6b7280;margin-bottom:28px;line-height:1.5}
    .scopes{background:#f0f4ff;border:1px solid #c7d2fe;border-radius:10px;padding:16px;margin-bottom:28px;text-align:left}
    .scopes p{color:#374151;font-weight:600;font-size:13px;margin-bottom:8px}
    .scopes ul{list-style:none;padding:0}
    .scopes li{font-size:13px;color:#4b5563;padding:3px 0}
    .scopes li::before{content:"✓ ";color:#2D1FB1;font-weight:700}
    form{display:flex;flex-direction:column;gap:10px}
    button[type=submit]{background:linear-gradient(135deg,#2D1FB1,#4f46e5);color:#fff;border:none;border-radius:10px;padding:14px;font-size:15px;font-weight:700;cursor:pointer}
    button[type=submit]:hover{opacity:.92}
  </style>
</head>
<body>
  <div class="card">
    <img src="https://capfundacademy.com/assets/logo-header.png" alt="Cap Fund Academy"/>
    <h1>Authorize Buffer Access</h1>
    <p>ChatGPT is requesting access to post social media content on behalf of Cap Fund Academy.</p>
    <div class="scopes">
      <p>Permissions requested:</p>
      <ul>
        <li>Read and write posts &amp; queue</li>
        <li>Read and write ideas</li>
        <li>Read account information</li>
        <li>Offline access (refresh token)</li>
      </ul>
    </div>
    <form method="POST" action="/oauth/authorize?${new URLSearchParams(q)}">
      <button type="submit">Authorize Access</button>
    </form>
  </div>
</body>
</html>`;

  return {
    statusCode: 200,
    headers: { 'Content-Type': 'text/html' },
    body: html,
  };
};
