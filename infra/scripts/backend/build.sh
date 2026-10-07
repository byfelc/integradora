#!/usr/bin/env bash
# =====================================================================
#  Script de compilación — Backend (Spring Boot)
#  Uso:   infra/scripts/backend/build.sh                 → JAR en artifacts/backend/tdimp-backend.jar
#         infra/scripts/backend/build.sh --image <tag>   → además construye la imagen Docker
#  El pipeline construye la imagen con docker/build-push-action (misma Dockerfile).
# =====================================================================
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT/backend"

MVN="mvn"
[[ -x ./mvnw ]] && MVN="./mvnw"

echo "▶ Backend: empaquetando JAR (sin pruebas; las pruebas son de test.sh)"
"$MVN" -B -ntp -DskipTests package

mkdir -p "$ROOT/artifacts/backend"
cp target/tdimp-backend.jar "$ROOT/artifacts/backend/"
echo "✔ JAR: artifacts/backend/tdimp-backend.jar"

if [[ "${1:-}" == "--image" ]]; then
  TAG="${2:-tdimp-backend:local}"
  echo "▶ Construyendo imagen $TAG"
  docker build -t "$TAG" .
  echo "✔ Imagen: $TAG"
fi
