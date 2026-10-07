#!/usr/bin/env bash
# =====================================================================
#  Verificación de PWA sobre el build compilado.
#  Falla si falta el service worker, su manifiesto de caché o el web manifest,
#  o si el manifest no trae lo mínimo para ser instalable.
#  Uso:   infra/scripts/web/verify-pwa.sh <carpeta-dist>
# =====================================================================
set -euo pipefail
DIST="${1:?Uso: verify-pwa.sh <carpeta-dist>}"
fail() { echo "✘ PWA: $1"; exit 1; }

echo "▶ Verificando características de PWA en $DIST"
[[ -f "$DIST/index.html" ]]            || fail "no existe index.html"
[[ -f "$DIST/ngsw-worker.js" ]]        || fail "no se generó el service worker (ngsw-worker.js)"
[[ -f "$DIST/ngsw.json" ]]             || fail "no se generó ngsw.json (configuración de caché)"
[[ -f "$DIST/manifest.webmanifest" ]]  || fail "no existe manifest.webmanifest"
grep -q 'rel="manifest"' "$DIST/index.html" || fail "index.html no enlaza el manifest"

node -e '
  const m = JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"));
  const missing = ["name", "short_name", "start_url", "display"].filter(k => !m[k]);
  const big = (m.icons || []).some(i => /(192|512)x(192|512)/.test(i.sizes || ""));
  if (missing.length) { console.error("✘ PWA: manifest sin " + missing.join(", ")); process.exit(1); }
  if (!big) { console.error("✘ PWA: faltan íconos de 192x192 o 512x512"); process.exit(1); }
' "$DIST/manifest.webmanifest"

echo "✔ PWA: service worker, ngsw.json y manifest instalable presentes"
