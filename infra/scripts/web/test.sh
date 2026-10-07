#!/usr/bin/env bash
# =====================================================================
#  Script de pruebas — Web PWA (React + Vite)
#  Etapas: instalar dependencias (npm ci) → oxlint → pruebas unitarias (Vitest + Testing Library, sin navegador)
#  Uso:   infra/scripts/web/test.sh
# =====================================================================
set -euo pipefail
cd "$(dirname "$0")/../../../web"

# Cypress solo se necesita en el job e2e; aquí evitamos descargar su binario (~500 MB)
export CYPRESS_INSTALL_BINARY=0

echo "▶ Web: instalando dependencias exactas del package-lock.json"
npm ci --no-audit --no-fund

echo "▶ Web: análisis estático (oxlint)"
npm run lint

echo "▶ Web: pruebas unitarias del cliente de la API y de los componentes"
npm run test:ci

echo "✔ Web: lint y pruebas aprobados"
