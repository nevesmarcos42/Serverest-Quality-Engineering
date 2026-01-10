// ***********************************************************
// This example support/e2e.js is processed and
// loaded automatically before your test files.
// ***********************************************************

// Import commands.js using ES2015 syntax:
import "./commands";

// Alternatively you can use CommonJS syntax:
// require('./commands')

// Configure baseUrl
Cypress.on("uncaught:exception", (err, runnable) => {
  // Returning false here prevents Cypress from failing the test
  // Pode ser útil para ignorar erros da aplicação que não afetam os testes
  return false;
});

// Limpar cookies e localStorage antes de cada teste
beforeEach(() => {
  cy.clearCookies();
  cy.clearLocalStorage();
});
