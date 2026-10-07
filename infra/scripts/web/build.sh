#!/usr/bin/env bash
# =====================================================================
#  Script de compilación — Web PWA (React + Vite)
#  Compila en modo producción y verifica que la salida siga siendo una PWA.
#  Uso:   infra/scripts/web/build.sh
#  Salida: web/dist  (artefacto "web-dist")
# =====================================================================
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT/web"

if [[ ! -d node_modules ]]; then
  CYPRESS_INSTALL_BINARY=0 npm ci --no-audit --no-fund
fi

echo "▶ Web: build de producción (tsc + vite build + vite-plugin-pwa)"
npm run build

"$ROOT/infra/scripts/web/verify-pwa.sh" "$ROOT/web/dist"
echo "✔ Web: paquete listo en web/dist"
