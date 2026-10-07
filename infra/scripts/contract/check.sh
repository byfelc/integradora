#!/usr/bin/env bash
# =====================================================================
#  Verificación del contrato de API (shared/contracts/openapi.yaml)
#  1. Lint: la especificación es válida OpenAPI 3 (Redocly CLI).
#  2. Compatibilidad: compara contra la versión base y FALLA si hay cambios
#     incompatibles (endpoint o campo eliminado, cambio de tipo...) — oasdiff (Docker).
#  Uso:   infra/scripts/contract/check.sh [ref-base]      ej. origin/dev
#  Sin ref-base solo hace el lint.
# =====================================================================
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT"
SPEC="shared/contracts/openapi.yaml"
BASE_REF="${1:-}"

echo "▶ Contrato: validando sintaxis y estructura"
npx -y @redocly/cli@1 lint "$SPEC" --skip-rule=no-server-example.com --format=stylish

if [[ -z "$BASE_REF" ]] || ! git cat-file -e "$BASE_REF:$SPEC" 2>/dev/null; then
  echo "ℹ Sin versión base del contrato; se omite la verificación de compatibilidad"
  exit 0
fi

TMP="$(mktemp -d)"
git show "$BASE_REF:$SPEC" > "$TMP/base.yaml"
cp "$SPEC" "$TMP/head.yaml"

echo "▶ Contrato: buscando cambios incompatibles contra $BASE_REF"
# oasdiff marca como ERR los cambios que rompen a un cliente existente (endpoint o
# campo de respuesta eliminado, campo obligatorio nuevo en la petición, cambio de tipo)
# y deja pasar los compatibles (campo opcional nuevo, endpoint nuevo).
# Se evaluó openapi-diff (npm) y se descartó: trata CUALQUIER campo nuevo como incompatible.
docker run --rm -v "$TMP:/specs:ro" tufin/oasdiff:latest \
  breaking /specs/base.yaml /specs/head.yaml --fail-on ERR --format text

echo "▶ Contrato: resumen de cambios (informativo)"
docker run --rm -v "$TMP:/specs:ro" tufin/oasdiff:latest \
  changelog /specs/base.yaml /specs/head.yaml --format text || true

echo "✔ Contrato válido y compatible con $BASE_REF"
