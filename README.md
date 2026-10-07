# The Day I Made That Promise — Proyecto integrador

Monorepo del videojuego (Unity 6.6), la PWA (API en Spring Boot + PostgreSQL y front end en React) y la app móvil (Flutter), con integración y entrega continua en GitHub Actions.

| Carpeta | Módulo |
|---|---|
| `game/` | Videojuego Unity 6000.6.2f1 (URP 2D) |
| `backend/` | API REST Spring Boot (Java 21) + migraciones Flyway |
| `web/` | PWA React 19 + Vite (vite-plugin-pwa) |
| `mobile/` | App Flutter |
| `shared/contracts/openapi.yaml` | Contrato único de la API |
| `infra/` | Scripts de compilación, pruebas, despliegue y configuración; `docker-compose.yml` |
| `.github/workflows/` | 7 pipelines |
| `docs/` | Documentación (guía de implementación de CI/CD) |

## Comandos rápidos

```bash
cd infra && cp .env.example .env && docker compose up --build   # backend + PostgreSQL locales
infra/scripts/test-all.sh                                        # pruebas de los módulos instalados
infra/scripts/backend/test.sh  | infra/scripts/backend/build.sh
infra/scripts/web/test.sh      | infra/scripts/web/build.sh
infra/scripts/mobile/test.sh   | infra/scripts/mobile/build.sh
infra/scripts/contract/check.sh origin/dev
```

## Pipelines

| Workflow | Se dispara | Produce |
|---|---|---|
| `ci-backend.yml` | PR y push a dev/main (backend o contrato) | `reporte-backend`, imagen `ghcr.io/byfelc/tdimp-backend:<sha>` |
| `ci-web.yml` | PR y push (web) | `web-dist` |
| `ci-mobile.yml` | PR y push (mobile) | `mobile-apk` |
| `ci-game.yml` | PR (pruebas), push y cada noche (build) | `game-test-results`, `game-win64` |
| `cd-staging.yml` | CI verde en dev, y cada noche (e2e) | despliegue a pruebas |
| `release.yml` | tag `vX.Y.Z` en main | GitHub Release con artefactos |
| `cd-production.yml` | lo lanza release.yml; aprobación por issue | despliegue a producción |

## Flujo de trabajo

`feature/<modulo>-<descripcion>` desde `dev` → PR con plantilla → 1 aprobación + checks verdes → squash merge → despliegue automático a staging → PO valida → PR `dev → main` → tag → aprobación → producción.

Guía completa: [`docs/GUIA-IMPLEMENTACION.md`](docs/GUIA-IMPLEMENTACION.md)
