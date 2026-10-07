#!/usr/bin/env bash
# =====================================================================
#  Paso 3 de la práctica: crea los ambientes staging y production en GitHub.
#   - staging:    solo puede desplegar la rama dev
#   - production: solo puede desplegar desde tags v*
#  Los ambientes separan los secretos (cada uno tiene su DB_URL, API_URL...).
#  Requisito: repositorio PÚBLICO, o privado con GitHub Pro/Team
#  (Pro es gratis con GitHub Student Developer Pack).
#  La aprobación a producción NO se configura aquí: la hace el job
#  "approval" de cd-production.yml (issue con comentario "aprobar").
#  Uso:   infra/scripts/setup/create-environments.sh <owner>/<repo>
# =====================================================================
set -euo pipefail
REPO="${1:?Uso: create-environments.sh <owner>/<repo>}"

create() {
  local env="$1" pattern="$2" type="$3"
  echo "▶ Ambiente $env (solo $type $pattern)"
  gh api -X PUT "repos/$REPO/environments/$env" --input - >/dev/null <<JSON
{ "deployment_branch_policy": { "protected_branches": false, "custom_branch_policies": true } }
JSON
  gh api -X POST "repos/$REPO/environments/$env/deployment-branch-policies" \
    -f name="$pattern" -f type="$type" >/dev/null || true
}

create staging dev branch
create production 'v*' tag
echo "✔ Ambientes creados"
