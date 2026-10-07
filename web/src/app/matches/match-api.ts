import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { RuntimeConfig } from '../core/runtime-config';
import { MatchResponse, PlayerStats } from './match.model';

@Injectable({ providedIn: 'root' })
export class MatchApi {
  private readonly http = inject(HttpClient);
  private readonly config = inject(RuntimeConfig);

  latest(limit = 10, playerId?: string): Observable<MatchResponse[]> {
    let params = new HttpParams().set('limit', limit);
    if (playerId) {
      params = params.set('playerId', playerId);
    }
    return this.http.get<MatchResponse[]>(`${this.config.apiBaseUrl}/api/v1/matches`, { params });
  }

  stats(playerId: string): Observable<PlayerStats> {
    return this.http.get<PlayerStats>(
      `${this.config.apiBaseUrl}/api/v1/players/${encodeURIComponent(playerId)}/stats`,
    );
  }
}
