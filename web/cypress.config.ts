import { defineConfig } from 'cypress';

/**
 * Pruebas end to end contra un ambiente desplegado.
 * En el pipeline: CYPRESS_BASE_URL = URL de la PWA en staging.
 * Local: npm run build && npm run preview, y luego npm run e2e (usa http://localhost:4173).
 */
export default defineConfig({
  e2e: {
    baseUrl: process.env['CYPRESS_BASE_URL'] ?? 'http://localhost:4173',
    supportFile: false,
    video: false,
    defaultCommandTimeout: 10000,
  },
});
