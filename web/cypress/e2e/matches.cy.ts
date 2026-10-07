/// <reference types="cypress" />

describe('Historial de partidas (PWA)', () => {
  it('carga la página principal con el título del juego', () => {
    cy.visit('/');
    cy.contains('h1', 'The Day I Made That Promise');
  });

  it('muestra la lista, el estado vacío o el error, nunca una pantalla en blanco', () => {
    cy.visit('/');
    cy.get('[data-test="list"], [data-test="empty"], [data-test="error"]').should('exist');
  });

  it('publica el manifiesto de PWA', () => {
    cy.request('/manifest.webmanifest').its('status').should('eq', 200);
  });
});
