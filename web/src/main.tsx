import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import App from './App.tsx'
import { loadRuntimeConfig } from './core/runtimeConfig'

// Lee config.json (URL de la API del ambiente) antes de montar la app.
await loadRuntimeConfig()

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
  </StrictMode>,
)
