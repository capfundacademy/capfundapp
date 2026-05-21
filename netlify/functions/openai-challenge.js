// openai-challenge.js — OpenAI Apps SDK domain verification
// OpenAI checks a challenge URL on your domain to confirm ownership.
// Set OPENAI_DOMAIN_CHALLENGE in Netlify env vars to the token shown
// in the OpenAI submission form under Domain Verification.
exports.handler = async () => {
  const token = process.env.OPENAI_DOMAIN_CHALLENGE || '';
  return {
    statusCode: 200,
    headers: { 'Content-Type': 'text/plain' },
    body: token,
  };
};
