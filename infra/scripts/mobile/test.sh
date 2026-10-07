#!/usr/bin/env bash
# =====================================================================
#  Script de pruebas — App móvil (Flutter)
#  Etapas: dependencias → formato → dart analyze → pruebas unitarias y de widgets (con cobertura)
#  Uso:   infra/scripts/mobile/test.sh
# =====================================================================
set -euo pipefail
cd "$(dirname "$0")/../../../mobile"

echo "▶ Móvil: versión del SDK"
flutter --version

echo "▶ Móvil: dependencias"
flutter pub get

echo "▶ Móvil: formato (falla si algún archivo no está formateado)"
dart format --output=none --set-exit-if-changed lib test

echo "▶ Móvil: análisis estático"
flutter analyze --fatal-infos

echo "▶ Móvil: pruebas unitarias y de widgets"
flutter test --coverage

echo "✔ Móvil: formato, análisis y pruebas aprobados (cobertura en mobile/coverage/lcov.info)"
