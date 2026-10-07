import { TestBed } from '@angular/core/testing';
import { of, throwError } from 'rxjs';
import { MatchApi } from './match-api';
import { MatchList } from './match-list';
import { MatchResponse } from './match.model';

const sample: MatchResponse = {
  id: 1, sessionId: 'a', playerId: 'tsuki', score: 1500, durationSeconds: 420, levelReached: 2,
  progressPercent: 35, outcome: 'COMPLETED', materialsCollected: 6, itemsCrafted: 2,
  finishedAt: '2026-10-06T20:15:00Z', gameVersion: '0.3.0', receivedAt: '2026-10-06T20:15:01Z',
};

function render(api: Partial<MatchApi>) {
  TestBed.configureTestingModule({
    imports: [MatchList],
    providers: [{ provide: MatchApi, useValue: api }],
  });
  const fixture = TestBed.createComponent(MatchList);
  fixture.detectChanges();
  return fixture.nativeElement as HTMLElement;
}

describe('MatchList', () => {
  it('muestra las partidas con puntaje', () => {
    const el = render({ latest: () => of([sample]) });
    expect(el.querySelectorAll('[data-test="list"] li').length).toBe(1);
    expect(el.textContent).toContain('1500 pts');
  });

  it('muestra el estado vacío', () => {
    const el = render({ latest: () => of([]) });
    expect(el.querySelector('[data-test="empty"]')).toBeTruthy();
  });

  it('muestra el estado de error de red', () => {
    const el = render({ latest: () => throwError(() => new Error('offline')) });
    expect(el.querySelector('[data-test="error"]')).toBeTruthy();
  });
});
