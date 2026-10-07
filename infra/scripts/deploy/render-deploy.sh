#!/usr/bin/env bash
# =====================================================================
#  Despliega en Render una imagen YA CONSTRUIDA (no recompila).
#  Render ofrece un "Deploy Hook" por servicio; con ?imgURL= indica qué imagen usar.
#  Uso:   RENDER_DEPLOY_HOOK=https://api.render.com/deploy/srv-xxx?key=yyy \
#         infra/scripts/deploy/render-deploy.sh ghcr.io/org/tdimp-backend:<tag>
# =====================================================================
set -euo pipefail
IMAGE="${1:?Uso: render-deploy.sh <imagen:tag>}"
: "${RENDER_DEPLOY_HOOK:?Falta RENDER_DEPLOY_HOOK}"

ENCODED="$(python3 -c 'import sys, urllib.parse; print(urllib.parse.quote(sys.argv[1], safe=""))' "$IMAGE")"
echo "▶ Render: desplegando $IMAGE"
curl -fsS -X POST "${RENDER_DEPLOY_HOOK}&imgURL=${ENCODED}" -o /dev/null
echo "✔ Render aceptó el despliegue"
