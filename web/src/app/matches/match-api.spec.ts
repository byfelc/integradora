import { TestBed } from '@angular/core/testing';
import { provideHttpClient } from '@angular/common/http';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { MatchApi } from './match-api';

describe('MatchApi', () => {
  let api: MatchApi;
  let http: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [provideHttpClient(), provideHttpClientTesting()],
    });
    api = TestBed.inject(MatchApi);
    http = TestBed.inject(HttpTestingController);
  });

  afterEach(() => http.verify());

  it('consulta GET /api/v1/matches con el límite indicado', () => {
    api.latest(10).subscribe((matches) => expect(matches.length).toBe(0));
    const req = http.expectOne((r) => r.url.endsWith('/api/v1/matches'));
    expect(req.request.method).toBe('GET');
    expect(req.request.params.get('limit')).toBe('10');
    req.flush([]);
  });

  it('filtra por jugador cuando se indica', () => {
    api.latest(5, 'tsuki').subscribe();
    const req = http.expectOne((r) => r.url.endsWith('/api/v1/matches'));
    expect(req.request.params.get('playerId')).toBe('tsuki');
    req.flush([]);
  });

  it('consulta las estadísticas del jugador', () => {
    api.stats('hikari').subscribe((s) => expect(s.bestScore).toBe(900));
    const req = http.expectOne((r) => r.url.endsWith('/api/v1/players/hikari/stats'));
    req.flush({ playerId: 'hikari', matchesPlayed: 2, bestScore: 900, totalPlaySeconds: 840, highestLevel: 2, completionRate: 50 });
  });
});
