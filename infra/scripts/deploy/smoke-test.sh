#!/usr/bin/env bash
# =====================================================================
#  Prueba de humo posterior al despliegue.
#  Espera a que el backend responda /actuator/health = UP y que la API conteste.
#  Uso:   infra/scripts/deploy/smoke-test.sh <api-base-url> [segundos-max]
# =====================================================================
set -euo pipefail
API="${1:?Uso: smoke-test.sh <api-base-url> [segundos-max]}"
MAX="${2:-300}"
API="${API%/}"

echo "▶ Esperando a que $API esté arriba (máx. ${MAX}s)"
for ((t = 0; t < MAX; t += 10)); do
  if curl -fsS "$API/actuator/health" | grep -q '"status":"UP"'; then
    echo "✔ Health UP tras ${t}s"
    curl -fsS -o /dev/null -w "✔ GET /api/v1/matches → %{http_code}\n" "$API/api/v1/matches?limit=1"
    exit 0
  fi
  sleep 10
done
echo "✘ El servicio no respondió UP en ${MAX}s"
exit 1
