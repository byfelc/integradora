import { afterEach, describe, expect, it, vi } from 'vitest'
import { fetchLatestMatches, fetchPlayerStats } from './matchApi'

function mockFetch(body: unknown, status = 200) {
  const fn = vi.fn().mockResolvedValue(new Response(JSON.stringify(body), { status }))
  vi.stubGlobal('fetch', fn)
  return fn
}

afterEach(() => vi.unstubAllGlobals())

describe('matchApi', () => {
  it('consulta GET /api/v1/matches con el límite indicado', async () => {
    const fetchFn = mockFetch([])
    await expect(fetchLatestMatches(10)).resolves.toEqual([])
    const url = new URL(fetchFn.mock.calls[0][0] as string)
    expect(url.pathname).toBe('/api/v1/matches')
    expect(url.searchParams.get('limit')).toBe('10')
  })

  it('filtra por jugador cuando se indica', async () => {
    const fetchFn = mockFetch([])
    await fetchLatestMatches(5, 'tsuki')
    const url = new URL(fetchFn.mock.calls[0][0] as string)
    expect(url.searchParams.get('playerId')).toBe('tsuki')
  })

  it('consulta las estadísticas del jugador', async () => {
    const fetchFn = mockFetch({ playerId: 'hikari', matchesPlayed: 2, bestScore: 900, totalPlaySeconds: 840, highestLevel: 2, completionRate: 50 })
    const stats = await fetchPlayerStats('hikari')
    expect(stats.bestScore).toBe(900)
    expect(fetchFn.mock.calls[0][0]).toMatch(/\/api\/v1\/players\/hikari\/stats$/)
  })

  it('lanza un error si el servidor responde con falla', async () => {
    mockFetch({ message: 'error' }, 503)
    await expect(fetchLatestMatches()).rejects.toThrow('503')
  })
})
