#!/usr/bin/env bash
# =====================================================================
#  Script de pruebas — Backend (Spring Boot)
#  Uso:   infra/scripts/backend/test.sh           → checkstyle + unitarias + integración + cobertura
#         infra/scripts/backend/test.sh --unit    → solo checkstyle + unitarias (rápido, sin Docker)
#  Requiere: JDK 21, Maven 3.9+, y Docker para las pruebas de integración (Testcontainers).
#  Lo usan: el desarrollador antes de abrir un PR y el job "backend-verify" de ci-backend.yml.
# =====================================================================
set -euo pipefail
cd "$(dirname "$0")/../../../backend"

MVN="mvn"
[[ -x ./mvnw ]] && MVN="./mvnw"
OPTS=(-B -ntp)

if [[ "${1:-}" == "--unit" ]]; then
  echo "▶ Backend: análisis estático + pruebas unitarias"
  "$MVN" "${OPTS[@]}" test
else
  echo "▶ Backend: análisis estático + unitarias + integración (Testcontainers) + cobertura ≥ 60 %"
  "$MVN" "${OPTS[@]}" verify
fi

echo "✔ Backend: pruebas aprobadas"
echo "  Reportes: backend/target/surefire-reports, failsafe-reports, site/jacoco/index.html"
