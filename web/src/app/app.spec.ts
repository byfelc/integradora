import { TestBed } from '@angular/core/testing';
import { of } from 'rxjs';
import { App } from './app';
import { MatchApi } from './matches/match-api';

describe('App', () => {
  it('muestra el título del juego', async () => {
    await TestBed.configureTestingModule({
      imports: [App],
      providers: [{ provide: MatchApi, useValue: { latest: () => of([]) } }],
    }).compileComponents();
    const fixture = TestBed.createComponent(App);
    fixture.detectChanges();
    expect((fixture.nativeElement as HTMLElement).querySelector('h1')?.textContent).toContain(
      'The Day I Made That Promise',
    );
  });
});
