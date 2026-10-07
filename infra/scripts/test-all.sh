#!/usr/bin/env bash
# =====================================================================
#  Corre las pruebas de todos los módulos disponibles en esta máquina.
#  Omite el módulo cuyo SDK no esté instalado (no todos tienen Flutter o Unity).
#  Uso:   infra/scripts/test-all.sh
# =====================================================================
set -uo pipefail
cd "$(dirname "$0")" || exit 1
status=0
run() { echo; echo "================ $1 ================"; shift; "$@" || status=1; }

command -v mvn     >/dev/null && run "BACKEND"  ./backend/test.sh  || echo "↷ Backend omitido (sin Maven)"
command -v npm     >/dev/null && run "WEB" ./web/test.sh || echo "↷ Web omitido (sin Node)"
command -v flutter >/dev/null && run "MÓVIL"    ./mobile/test.sh   || echo "↷ Móvil omitido (sin Flutter)"
[[ -n "${UNITY:-}" ]]         && run "JUEGO"    ./game/run-tests-local.sh || echo "↷ Unity omitido (define UNITY)"
run "CONTRATO" ./contract/check.sh

echo
[[ $status -eq 0 ]] && echo "✔ Todo en verde" || echo "✘ Hay módulos con fallas"
exit $status
