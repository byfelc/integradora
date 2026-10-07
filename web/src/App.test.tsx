import { render, screen } from '@testing-library/react'
import { describe, expect, it, vi } from 'vitest'
import App from './App'
import * as api from './matches/matchApi'

describe('App', () => {
  it('muestra el título del juego', async () => {
    vi.spyOn(api, 'fetchLatestMatches').mockResolvedValue([])
    render(<App />)
    expect(screen.getByRole('heading', { level: 1 })).toHaveTextContent('The Day I Made That Promise')
    await screen.findByText('Aún no hay partidas registradas.')
  })
})
