import { Component } from '@angular/core';
import { MatchList } from './matches/match-list';

@Component({
  selector: 'app-root',
  imports: [MatchList],
  template: `
    <header><h1>The Day I Made That Promise</h1></header>
    <main><app-match-list /></main>
  `,
})
export class App {}
