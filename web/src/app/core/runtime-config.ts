import { Injectable } from '@angular/core';

export interface AppConfig {
  apiBaseUrl: string;
}

/**
 * Configuración en tiempo de ejecución.
 * El pipeline compila la PWA UNA sola vez y, al desplegar a cada ambiente,
 * solo reescribe dist/.../config.json con la URL de la API de ese ambiente.
 * Así el mismo artefacto se promueve de staging a producción sin recompilar.
 */
@Injectable({ providedIn: 'root' })
export class RuntimeConfig {
  private config: AppConfig = { apiBaseUrl: 'http://localhost:8080' };

  get apiBaseUrl(): string {
    return this.config.apiBaseUrl.replace(/\/$/, '');
  }

  async load(url = 'config.json'): Promise<void> {
    try {
      const res = await fetch(url, { cache: 'no-store' });
      if (res.ok) {
        this.config = { ...this.config, ...((await res.json()) as Partial<AppConfig>) };
      }
    } catch {
      // sin config.json se usa el valor local por defecto
    }
  }
}
