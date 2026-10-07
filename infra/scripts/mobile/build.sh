#!/usr/bin/env bash
# =====================================================================
#  Script de compilación — App móvil (Flutter)
#  Compila el APK en modo release. La URL de la API se inyecta en tiempo
#  de compilación con --dart-define (Flutter no tiene config en runtime simple).
#  Uso:   API_BASE_URL=https://api-staging... infra/scripts/mobile/build.sh [version]
#  Salida: artifacts/mobile/tdimp-<version>.apk   (artefacto "mobile-apk")
# =====================================================================
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT/mobile"

API="${API_BASE_URL:-http://10.0.2.2:8080}"   # 10.0.2.2 = localhost visto desde el emulador Android
VERSION="${1:-0.0.0-local}"

echo "▶ Móvil: build APK release (API=$API, versión=$VERSION)"
flutter build apk --release --dart-define=API_BASE_URL="$API"

mkdir -p "$ROOT/artifacts/mobile"
cp build/app/outputs/flutter-apk/app-release.apk "$ROOT/artifacts/mobile/tdimp-$VERSION.apk"
echo "✔ APK: artifacts/mobile/tdimp-$VERSION.apk"
