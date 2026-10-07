#!/usr/bin/env bash
# =====================================================================
#  Paso 4 de la práctica: carga secretos y variables desde archivos locales
#  que NUNCA se versionan (están en .gitignore como .env).
#  Uso:   infra/scripts/setup/load-secrets.sh <owner>/<repo>
#  Espera:  secrets.repo.env  secrets.staging.env  secrets.production.env  (formato CLAVE=valor)
#  Las líneas que empiezan con VAR_ se guardan como variables (no secretas) sin el prefijo.
# =====================================================================
set -euo pipefail
REPO="${1:?Uso: load-secrets.sh <owner>/<repo>}"
cd "$(dirname "$0")/../../.."

load() {
  local file="$1" env="${2:-}"
  [[ -f "$file" ]] || { echo "↷ $file no existe, se omite"; return; }
  while IFS='=' read -r key value; do
    [[ -z "$key" || "$key" == \#* ]] && continue
    local scope=()
    [[ -n "$env" ]] && scope=(--env "$env")
    if [[ "$key" == VAR_* ]]; then
      gh variable set "${key#VAR_}" --repo "$REPO" "${scope[@]}" --body "$value"
    else
      gh secret set "$key" --repo "$REPO" "${scope[@]}" --body "$value"
    fi
    echo "  ✔ ${env:-repo}: $key"
  done < "$file"
}

load secrets.repo.env
load secrets.staging.env staging
load secrets.production.env production
echo "✔ Secretos cargados. Borra los archivos .env locales si ya no los necesitas."
