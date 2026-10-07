/// <reference types="vitest/config" />
import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'
import { VitePWA } from 'vite-plugin-pwa'

// Build de producción: genera dist/ con sw.js (Workbox) y manifest.webmanifest.
export default defineConfig({
  plugins: [
    react(),
    VitePWA({
      registerType: 'autoUpdate',
      manifest: {
        name: 'The Day I Made That Promise',
        short_name: 'TDIMP',
        description: 'Historial de partidas del videojuego',
        start_url: '/',
        display: 'standalone',
        theme_color: '#1b1b2f',
        background_color: '#1b1b2f',
        icons: [
          { src: 'icons/icon-192x192.png', sizes: '192x192', type: 'image/png' },
          { src: 'icons/icon-512x512.png', sizes: '512x512', type: 'image/png' },
        ],
      },
      workbox: {
        // config.json se reescribe por ambiente al desplegar: nunca se precachea
        globIgnores: ['**/config.json'],
      },
    }),
  ],
  test: {
    environment: 'jsdom',
    setupFiles: ['./src/setupTests.ts'],
    include: ['src/**/*.test.{ts,tsx}'],
  },
})
