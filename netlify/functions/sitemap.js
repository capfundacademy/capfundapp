// ============================================================================
// sitemap.js — Dynamic XML sitemap including published blog posts
// Accessible at: https://capfundacademy.com/sitemap.xml
// ============================================================================

const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL         = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const SITE                 = 'https://capfundacademy.com';

const STATIC_PAGES = [
  { url: '/',           changefreq: 'weekly',  priority: '1.0' },
  { url: '/#blog',      changefreq: 'daily',   priority: '0.9' },
  { url: '/#pricing',   changefreq: 'monthly', priority: '0.8' },
  { url: '/#directory', changefreq: 'weekly',  priority: '0.7' },
  { url: '/#trust',     changefreq: 'monthly', priority: '0.5' },
  { url: '/#privacy-policy', changefreq: 'yearly', priority: '0.4' },
];

exports.handler = async () => {
  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY, {
    auth: { autoRefreshToken: false, persistSession: false },
  });

  const { data: posts } = await admin
    .from('blog_posts')
    .select('slug, published_at, updated_at')
    .eq('status', 'published')
    .order('published_at', { ascending: false });

  const now = new Date().toISOString().slice(0, 10);

  const staticEntries = STATIC_PAGES.map(p => `
  <url>
    <loc>${SITE}${p.url}</loc>
    <lastmod>${now}</lastmod>
    <changefreq>${p.changefreq}</changefreq>
    <priority>${p.priority}</priority>
  </url>`).join('');

  const blogEntries = (posts || []).map(p => {
    const lastmod = (p.updated_at || p.published_at || now).slice(0, 10);
    return `
  <url>
    <loc>${SITE}/blog/${p.slug}</loc>
    <lastmod>${lastmod}</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.7</priority>
  </url>`;
  }).join('');

  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9
        http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">
${staticEntries}${blogEntries}
</urlset>`;

  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/xml',
      'Cache-Control': 'public, max-age=3600',
    },
    body: xml,
  };
};
