// openai-challenge.js — serves OpenAI Apps SDK domain verification token
// OpenAI checks /.well-known/openai-challenge to confirm domain ownership.
// The OPENAI_DOMAIN_CHALLENGE env var must be set to the token OpenAI provides
// in the submission form (Settings > Domain verification > Challenge token).
exports.handler = async () => {
  const token = process.env.OPENAI_DOMAIN_CHALLENGE || '';
  if (!token) {
    return {
      statusCode: 404,
      body: 'OPENAI_DOMAIN_CHALLENGE env var not set',
    };
  }
  return {
    statusCode: 200,
    headers: { 'Content-Type': 'text/plain' },
    body: token,
  };
};
