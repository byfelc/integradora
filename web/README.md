# Web — PWA en React

Front end de The Day I Made That Promise: React 19 + Vite + `vite-plugin-pwa` (service worker con Workbox). Consume la API de Spring Boot descrita en `shared/contracts/openapi.yaml`.

```bash
npm ci
npm run dev        # http://localhost:5173
npm run lint       # oxlint
npm run test:ci    # Vitest + Testing Library
npm run build      # web/dist con sw.js y manifest.webmanifest
npm run e2e        # Cypress contra `npm run preview` (puerto 4173)
```

La URL de la API se lee en tiempo de ejecución de `public/config.json` (no entra en el precache), así el mismo build sirve para staging y producción.

Los íconos `public/icons/icon-192x192.png` e `icon-512x512.png` se versionan con Git LFS.
