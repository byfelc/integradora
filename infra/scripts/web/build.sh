#!/usr/bin/env bash
# =====================================================================
#  Script de compilación — Frontend PWA (Angular)
#  Compila en modo producción y verifica que la salida siga siendo una PWA.
#  Uso:   infra/scripts/web/build.sh
#  Salida: web/dist/web/browser  (artefacto "web-dist")
# =====================================================================
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT/web"

if [[ ! -d node_modules ]]; then
  CYPRESS_INSTALL_BINARY=0 npm ci --no-audit --no-fund
fi

echo "▶ Frontend: build de producción"
npm run build:prod

"$ROOT/infra/scripts/web/verify-pwa.sh" "$ROOT/web/dist/web/browser"
echo "✔ Frontend: paquete listo en web/dist/web/browser"
