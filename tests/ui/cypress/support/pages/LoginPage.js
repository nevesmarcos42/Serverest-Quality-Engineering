/**
 * Page Object para a página de Login
 * Encapsula todos os seletores e ações para a funcionalidade de login
 */
class LoginPage {
  // Seletores
  get emailInput() {
    return cy.get('[data-testid="email"]');
  }

  get passwordInput() {
    return cy.get('[data-testid="senha"]');
  }

  get loginButton() {
    return cy.get('[data-testid="entrar"]');
  }

  get registerLink() {
    return cy.get('[data-testid="cadastrar"]');
  }

  get errorMessage() {
    return cy.get(".alert");
  }

  // Ações
  visit() {
    cy.visit("/login");
  }

  fillEmail(email) {
    this.emailInput.clear().type(email);
  }

  fillPassword(password) {
    this.passwordInput.clear().type(password);
  }

  clickLogin() {
    this.loginButton.click();
  }

  clickRegister() {
    this.registerLink.click();
  }

  login(email, password) {
    this.fillEmail(email);
    this.fillPassword(password);
    this.clickLogin();
  }

  // Assertions
  shouldShowErrorMessage(message) {
    this.errorMessage.should("be.visible").and("contain", message);
  }
}

export default new LoginPage();
