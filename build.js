#!/usr/bin/env node
// ============================================================================
// build.js — Production build for Cap Fund Academy
//
// What it does:
//   1. Extracts JSX from index.html <script type="text/babel"> block
//   2. Compiles JSX → bundle.js via esbuild (minified, no browser Babel needed)
//   3. Compiles Tailwind CSS → styles.css (only used classes, not full CDN)
//   4. Rewrites index.html to reference compiled assets + React production UMD
//   5. Copies assets/ and templates/ directories to dist/
//
// Output: dist/  (set as Netlify publish directory)
// ============================================================================

const fs   = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const ROOT = __dirname;
const DIST = path.join(ROOT, 'dist');

// ── Helpers ──────────────────────────────────────────────────────────────────
function log(msg)  { console.log(`\x1b[36m[build]\x1b[0m ${msg}`); }
function ok(msg)   { console.log(`\x1b[32m[build]\x1b[0m ${msg}`); }
function err(msg)  { console.error(`\x1b[31m[build]\x1b[0m ${msg}`); }

function copyDir(src, dest) {
  if (!fs.existsSync(src)) return;
  fs.mkdirSync(dest, { recursive: true });
  for (const entry of fs.readdirSync(src, { withFileTypes: true })) {
    const s = path.join(src, entry.name);
    const d = path.join(dest, entry.name);
    if (entry.isDirectory()) copyDir(s, d);
    else fs.copyFileSync(s, d);
  }
}

// ── 1. Clean and create dist/ ────────────────────────────────────────────────
log('Cleaning dist/…');
fs.rmSync(DIST, { recursive: true, force: true });
fs.mkdirSync(DIST, { recursive: true });

// ── 2. Read source index.html ────────────────────────────────────────────────
log('Reading index.html…');
const src = fs.readFileSync(path.join(ROOT, 'index.html'), 'utf8');

// ── 3. Extract JSX script block ──────────────────────────────────────────────
log('Extracting JSX…');
const babelStart = src.indexOf('<script type="text/babel"');
const babelEnd   = src.indexOf('</script>', babelStart) + '</script>'.length;
if (babelStart === -1) { err('No <script type="text/babel"> found in index.html'); process.exit(1); }

// Get just the script content (between the opening > and closing </script>)
const scriptTagEnd = src.indexOf('>', babelStart) + 1;
const jsxContent   = src.slice(scriptTagEnd, src.indexOf('</script>', babelStart));

// Write to temp file
const tmpJsx = path.join(ROOT, '_tmp_app.jsx');
fs.writeFileSync(tmpJsx, jsxContent);

// ── 4. Compile JSX with esbuild ──────────────────────────────────────────────
log('Compiling JSX with esbuild…');
const bundleOut = path.join(DIST, 'bundle.js');
try {
  execSync(
    [
      'npx esbuild', tmpJsx,
      '--bundle=false',                    // no bundling — React loaded as UMD global
      '--platform=browser',
      '--format=iife',
      '--jsx-factory=React.createElement',
      '--jsx-fragment=React.Fragment',
      '--target=es2020',
      '--minify',
      `--outfile=${bundleOut}`,
    ].join(' '),
    { stdio: 'inherit', cwd: ROOT }
  );
  ok(`bundle.js — ${(fs.statSync(bundleOut).size / 1024).toFixed(1)} KB`);
} catch (e) {
  err('esbuild failed'); fs.unlinkSync(tmpJsx); process.exit(1);
} finally {
  fs.unlinkSync(tmpJsx);
}

// ── 5. Compile Tailwind CSS ──────────────────────────────────────────────────
log('Compiling Tailwind CSS…');
const cssOut = path.join(DIST, 'styles.css');

// Write a minimal CSS entry point for Tailwind to process
const tmpCss = path.join(ROOT, '_tmp_input.css');
fs.writeFileSync(tmpCss, '@tailwind base;\n@tailwind components;\n@tailwind utilities;\n');
try {
  execSync(
    `npx tailwindcss -i ${tmpCss} -o ${cssOut} --minify`,
    { stdio: 'inherit', cwd: ROOT }
  );
  ok(`styles.css — ${(fs.statSync(cssOut).size / 1024).toFixed(1)} KB`);
} catch (e) {
  err('Tailwind build failed'); fs.unlinkSync(tmpCss); process.exit(1);
} finally {
  fs.unlinkSync(tmpCss);
}

// ── 6. Rewrite index.html for production ─────────────────────────────────────
log('Rewriting index.html for production…');

let html = src;

// Remove Tailwind CDN script + inline tailwind.config block
html = html.replace(
  /\s*<!-- Tailwind CDN -->\s*<script src="https:\/\/cdn\.tailwindcss\.com"><\/script>\s*<script>[\s\S]*?tailwind\.config[\s\S]*?<\/script>/,
  '\n  <!-- Compiled Tailwind CSS -->\n  <link rel="stylesheet" href="/styles.css" />'
);

// Replace React dev builds with production builds
html = html.replace(
  /https:\/\/unpkg\.com\/react@18\/umd\/react\.development\.js/g,
  'https://unpkg.com/react@18/umd/react.production.min.js'
);
html = html.replace(
  /https:\/\/unpkg\.com\/react-dom@18\/umd\/react-dom\.development\.js/g,
  'https://unpkg.com/react-dom@18/umd/react-dom.production.min.js'
);

// Remove the "React 18 + Babel Standalone" comment and Babel script tag
html = html.replace(
  /\s*<!-- React 18 \+ Babel Standalone -->/,
  '\n  <!-- React 18 production builds -->'
);
html = html.replace(
  /\s*<script src="https:\/\/unpkg\.com\/@babel\/standalone\/babel\.min\.js"><\/script>/,
  ''
);

// Remove old modulepreload hint for esm.sh if any
html = html.replace(/<link rel="modulepreload"[^>]+esm\.sh[^>]+>\s*/g, '');

// Add modulepreload for Supabase so it fetches in parallel with React
const supabasePreload = '  <link rel="modulepreload" href="https://esm.sh/@supabase/supabase-js@2.58.0" />\n';
html = html.replace('<link rel="preconnect" href="https://fonts.googleapis.com"', supabasePreload + '  <link rel="preconnect" href="https://fonts.googleapis.com"');

// Replace the entire <script type="text/babel"> block with the compiled bundle
html = html.replace(
  src.slice(babelStart, babelEnd),
  '<script src="/bundle.js"></script>'
);

// Write production index.html
fs.writeFileSync(path.join(DIST, 'index.html'), html);
ok('index.html written');

// ── 7. Copy static assets ─────────────────────────────────────────────────────
log('Copying assets and templates…');
copyDir(path.join(ROOT, 'assets'),    path.join(DIST, 'assets'));
copyDir(path.join(ROOT, 'templates'), path.join(DIST, 'templates'));
ok(`assets/ and templates/ copied`);

// ── 8. Copy root static files ─────────────────────────────────────────────────
const staticFiles = ['robots.txt', 'llms.txt', 'sitemap.xml', 'credentials-manifest.json'];
for (const f of staticFiles) {
  const src = path.join(ROOT, f);
  if (fs.existsSync(src)) {
    fs.copyFileSync(src, path.join(DIST, f));
    ok(`${f} copied`);
  }
}

// ── Done ─────────────────────────────────────────────────────────────────────
const distFiles = fs.readdirSync(DIST);
ok(`\nBuild complete → dist/  (${distFiles.length} top-level entries)`);
ok('  index.html  bundle.js  styles.css  assets/  templates/');
