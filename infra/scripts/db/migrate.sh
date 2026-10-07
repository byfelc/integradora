#!/usr/bin/env bash
# =====================================================================
#  Migraciones de base de datos (Flyway) contra un ambiente desplegado.
#  Las migraciones viven en backend/src/main/resources/db/migration.
#  Uso:   DB_URL=jdbc:postgresql://host:5432/db DB_USER=... DB_PASSWORD=... infra/scripts/db/migrate.sh
#  En el pipeline las variables vienen de los Secrets del ambiente (staging / production).
# =====================================================================
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
: "${DB_URL:?Falta DB_URL}" "${DB_USER:?Falta DB_USER}" "${DB_PASSWORD:?Falta DB_PASSWORD}"

echo "▶ Flyway: validando y aplicando migraciones pendientes"
docker run --rm \
  -v "$ROOT/backend/src/main/resources/db/migration:/flyway/sql:ro" \
  -e FLYWAY_URL="$DB_URL" -e FLYWAY_USER="$DB_USER" -e FLYWAY_PASSWORD="$DB_PASSWORD" \
  flyway/flyway:11 -connectRetries=5 -validateMigrationNaming=true migrate

docker run --rm \
  -v "$ROOT/backend/src/main/resources/db/migration:/flyway/sql:ro" \
  -e FLYWAY_URL="$DB_URL" -e FLYWAY_USER="$DB_USER" -e FLYWAY_PASSWORD="$DB_PASSWORD" \
  flyway/flyway:11 info
echo "✔ Flyway: esquema al día"
