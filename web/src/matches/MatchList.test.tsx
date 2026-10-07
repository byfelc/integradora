import { render, screen } from '@testing-library/react'
import { afterEach, describe, expect, it, vi } from 'vitest'
import { MatchList } from './MatchList'
import * as api from './matchApi'
import type { MatchResponse } from './match.model'

const sample: MatchResponse = {
  id: 1, sessionId: 'a', playerId: 'tsuki', score: 1500, durationSeconds: 420, levelReached: 2,
  progressPercent: 35, outcome: 'COMPLETED', materialsCollected: 6, itemsCrafted: 2,
  finishedAt: '2026-10-06T20:15:00Z', gameVersion: '0.3.0', receivedAt: '2026-10-06T20:15:01Z',
}

afterEach(() => vi.restoreAllMocks())

describe('MatchList', () => {
  it('muestra las partidas con puntaje', async () => {
    vi.spyOn(api, 'fetchLatestMatches').mockResolvedValue([sample])
    render(<MatchList />)
    expect(await screen.findByText('1500 pts')).toBeInTheDocument()
  })

  it('muestra el estado vacío', async () => {
    vi.spyOn(api, 'fetchLatestMatches').mockResolvedValue([])
    render(<MatchList />)
    expect(await screen.findByText('Aún no hay partidas registradas.')).toBeInTheDocument()
  })

  it('muestra el estado de error de red', async () => {
    vi.spyOn(api, 'fetchLatestMatches').mockRejectedValue(new Error('offline'))
    render(<MatchList />)
    expect(await screen.findByText(/No se pudo conectar/)).toBeInTheDocument()
  })
})
