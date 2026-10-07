/**
 * Configuración en tiempo de ejecución.
 * El pipeline compila la PWA UNA sola vez y, al desplegar a cada ambiente,
 * solo reescribe dist/config.json con la URL de la API de ese ambiente.
 * Así el mismo artefacto se promueve de staging a producción sin recompilar.
 */
export interface AppConfig {
  apiBaseUrl: string
}

let config: AppConfig = { apiBaseUrl: 'http://localhost:8080' }

export function apiBaseUrl(): string {
  return config.apiBaseUrl.replace(/\/$/, '')
}

export async function loadRuntimeConfig(url = '/config.json'): Promise<void> {
  try {
    const res = await fetch(url, { cache: 'no-store' })
    if (res.ok) {
      config = { ...config, ...((await res.json()) as Partial<AppConfig>) }
    }
  } catch {
    // sin config.json se usa el valor local por defecto
  }
}
