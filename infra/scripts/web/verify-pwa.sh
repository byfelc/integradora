#!/usr/bin/env bash
# =====================================================================
#  Verificación de PWA sobre el build compilado (Vite + vite-plugin-pwa).
#  Falla si falta el service worker, el web manifest o su enlace, si el
#  manifest no es instalable, o si config.json quedó dentro del precache
#  (debe poder reescribirse por ambiente sin invalidar el service worker).
#  Uso:   infra/scripts/web/verify-pwa.sh <carpeta-dist>
# =====================================================================
set -euo pipefail
DIST="${1:?Uso: verify-pwa.sh <carpeta-dist>}"
fail() { echo "✘ PWA: $1"; exit 1; }

echo "▶ Verificando características de PWA en $DIST"
[[ -f "$DIST/index.html" ]]           || fail "no existe index.html"
[[ -f "$DIST/sw.js" ]]                || fail "no se generó el service worker (sw.js)"
[[ -f "$DIST/manifest.webmanifest" ]] || fail "no existe manifest.webmanifest"
grep -q 'rel="manifest"' "$DIST/index.html" || fail "index.html no enlaza el manifest"
if grep -q 'config\.json' "$DIST/sw.js"; then
  fail "config.json está en el precache; agrégalo a workbox.globIgnores"
fi

node -e '
  const m = JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"));
  const missing = ["name", "short_name", "start_url", "display"].filter(k => !m[k]);
  const big = (m.icons || []).some(i => /(192|512)x(192|512)/.test(i.sizes || ""));
  if (missing.length) { console.error("✘ PWA: manifest sin " + missing.join(", ")); process.exit(1); }
  if (!big) { console.error("✘ PWA: faltan íconos de 192x192 o 512x512"); process.exit(1); }
' "$DIST/manifest.webmanifest"

echo "✔ PWA: service worker, manifest instalable y config.json fuera del precache"
