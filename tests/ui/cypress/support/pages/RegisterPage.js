/**
 * Page Object for Registration page
 */
class RegisterPage {
  // Seletores
  get nameInput() {
    return cy.get('[data-testid="nome"]');
  }

  get emailInput() {
    return cy.get('[data-testid="email"]');
  }

  get passwordInput() {
    return cy.get('[data-testid="password"]');
  }

  get adminCheckbox() {
    return cy.get('[data-testid="checkbox"]');
  }

  get registerButton() {
    return cy.get('[data-testid="cadastrar"]');
  }

  get loginLink() {
    return cy.contains("a", "Entrar");
  }

  get errorMessage() {
    return cy.get(".alert");
  }

  // Ações
  visit() {
    cy.visit("/cadastrarusuarios");
  }

  fillName(name) {
    this.nameInput.clear().type(name);
  }

  fillEmail(email) {
    this.emailInput.clear().type(email);
  }

  fillPassword(password) {
    this.passwordInput.clear().type(password);
  }

  checkAdmin() {
    this.adminCheckbox.check();
  }

  uncheckAdmin() {
    this.adminCheckbox.uncheck();
  }

  clickRegister() {
    this.registerButton.click();
  }

  clickLoginLink() {
    this.loginLink.click();
  }

  register(name, email, password, isAdmin = false) {
    this.fillName(name);
    this.fillEmail(email);
    this.fillPassword(password);
    if (isAdmin) {
      this.checkAdmin();
    }
    this.clickRegister();
  }

  // Assertions
  shouldShowErrorMessage(message) {
    this.errorMessage.should("be.visible").and("contain", message);
  }
}

export default new RegisterPage();
