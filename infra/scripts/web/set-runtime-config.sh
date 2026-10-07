#!/usr/bin/env bash
# =====================================================================
#  Configura el artefacto YA COMPILADO para un ambiente (no recompila).
#  Escribe config.json con la URL de la API del ambiente destino.
#  config.json no está en ngsw.json, así que no rompe la integridad del service worker.
#  Uso:   infra/scripts/web/set-runtime-config.sh <carpeta-dist> <api-base-url>
# =====================================================================
set -euo pipefail
DIST="${1:?Uso: set-runtime-config.sh <carpeta-dist> <api-base-url>}"
API="${2:?Falta la URL de la API}"
printf '{\n  "apiBaseUrl": "%s"\n}\n' "$API" > "$DIST/config.json"
echo "✔ config.json → $API"
