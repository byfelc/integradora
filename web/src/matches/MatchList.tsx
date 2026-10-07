import { useEffect, useState } from 'react'
import { fetchLatestMatches } from './matchApi'
import type { MatchResponse } from './match.model'

type State =
  | { status: 'loading' }
  | { status: 'error' }
  | { status: 'ready'; matches: MatchResponse[] }

const dateFormat = new Intl.DateTimeFormat('es-MX', { dateStyle: 'short', timeStyle: 'short' })

/**
 * Historia de usuario del backlog: "Como jugador, quiero consultar mis últimas
 * partidas desde la PWA". Muestra 10 partidas con fecha y puntaje, y maneja
 * los estados vacío y de error de red.
 */
export function MatchList() {
  const [state, setState] = useState<State>({ status: 'loading' })

  useEffect(() => {
    let active = true
    fetchLatestMatches(10)
      .then((matches) => active && setState({ status: 'ready', matches }))
      .catch(() => active && setState({ status: 'error' }))
    return () => {
      active = false
    }
  }, [])

  return (
    <section>
      <h2>Últimas partidas</h2>
      {state.status === 'loading' && <p data-test="loading">Cargando…</p>}
      {state.status === 'error' && (
        <p data-test="error">No se pudo conectar con el servidor. Intenta más tarde.</p>
      )}
      {state.status === 'ready' && state.matches.length === 0 && (
        <p data-test="empty">Aún no hay partidas registradas.</p>
      )}
      {state.status === 'ready' && state.matches.length > 0 && (
        <ul data-test="list">
          {state.matches.map((m) => (
            <li key={m.id}>
              <span>{dateFormat.format(new Date(m.finishedAt))}</span> <span>{m.playerId}</span>{' '}
              <span>{m.score} pts</span>
            </li>
          ))}
        </ul>
      )}
    </section>
  )
}
