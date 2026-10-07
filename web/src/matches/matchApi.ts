import { apiBaseUrl } from '../core/runtimeConfig'
import type { MatchResponse, PlayerStats } from './match.model'

/** Cliente de la API de partidas (contrato: shared/contracts/openapi.yaml). */
export async function fetchLatestMatches(limit = 10, playerId?: string): Promise<MatchResponse[]> {
  const params = new URLSearchParams({ limit: String(limit) })
  if (playerId) {
    params.set('playerId', playerId)
  }
  const res = await fetch(`${apiBaseUrl()}/api/v1/matches?${params}`)
  if (!res.ok) {
    throw new Error(`GET /api/v1/matches respondió ${res.status}`)
  }
  return (await res.json()) as MatchResponse[]
}

export async function fetchPlayerStats(playerId: string): Promise<PlayerStats> {
  const res = await fetch(`${apiBaseUrl()}/api/v1/players/${encodeURIComponent(playerId)}/stats`)
  if (!res.ok) {
    throw new Error(`GET /api/v1/players/{id}/stats respondió ${res.status}`)
  }
  return (await res.json()) as PlayerStats
}
