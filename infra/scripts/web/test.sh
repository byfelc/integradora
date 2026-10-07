#!/usr/bin/env bash
# =====================================================================
#  Script de pruebas — Frontend PWA (Angular)
#  Etapas: instalar dependencias (npm ci) → ESLint → pruebas unitarias (Vitest, sin navegador)
#  Uso:   infra/scripts/web/test.sh
# =====================================================================
set -euo pipefail
cd "$(dirname "$0")/../../../web"

# Cypress solo se necesita en el job e2e; aquí evitamos descargar su binario (~500 MB)
export CYPRESS_INSTALL_BINARY=0

echo "▶ Frontend: instalando dependencias exactas del package-lock.json"
npm ci --no-audit --no-fund

echo "▶ Frontend: análisis estático (ESLint)"
npm run lint

echo "▶ Frontend: pruebas unitarias de servicios y componentes"
npm run test:ci

echo "✔ Frontend: lint y pruebas aprobados"
