import { DatePipe } from '@angular/common';
import { Component, OnInit, inject, signal } from '@angular/core';
import { MatchApi } from './match-api';
import { MatchResponse } from './match.model';

/**
 * Historia de usuario del backlog: "Como jugador, quiero consultar mis últimas
 * partidas desde la PWA". Muestra 10 partidas con fecha y puntaje, y maneja
 * los estados vacío y de error de red.
 */
@Component({
  selector: 'app-match-list',
  imports: [DatePipe],
  template: `
    <h2>Últimas partidas</h2>
    @if (error()) {
      <p class="state error" data-test="error">No se pudo conectar con el servidor. Intenta más tarde.</p>
    } @else if (loading()) {
      <p class="state" data-test="loading">Cargando…</p>
    } @else if (matches().length === 0) {
      <p class="state" data-test="empty">Aún no hay partidas registradas.</p>
    } @else {
      <ul data-test="list">
        @for (m of matches(); track m.id) {
          <li>
            <span class="date">{{ m.finishedAt | date: 'dd/MM/yyyy HH:mm' }}</span>
            <span class="player">{{ m.playerId }}</span>
            <span class="score">{{ m.score }} pts</span>
          </li>
        }
      </ul>
    }
  `,
})
export class MatchList implements OnInit {
  private readonly api = inject(MatchApi);
  readonly matches = signal<MatchResponse[]>([]);
  readonly loading = signal(true);
  readonly error = signal(false);

  ngOnInit(): void {
    this.api.latest(10).subscribe({
      next: (m) => {
        this.matches.set(m);
        this.loading.set(false);
      },
      error: () => {
        this.error.set(true);
        this.loading.set(false);
      },
    });
  }
}
