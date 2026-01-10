class RegisterPage {
  // Elementos da página
  elements = {
    nameInput: () => cy.get('[data-testid="nome"]'),
    emailInput: () => cy.get('[data-testid="email"]'),
    passwordInput: () => cy.get('[data-testid="password"]'),
    adminCheckbox: () => cy.get('[data-testid="checkbox"]'),
    registerButton: () => cy.get('[data-testid="cadastrar"]'),
    loginLink: () => cy.contains("Entrar"),
    errorMessage: () => cy.get(".alert"),
    pageTitle: () => cy.get("h1"),
  };

  // Ações da página
  visit() {
    cy.visit("/cadastrarusuarios");
  }

  fillName(name) {
    this.elements.nameInput().clear().type(name);
  }

  fillEmail(email) {
    this.elements.emailInput().clear().type(email);
  }

  fillPassword(password) {
    this.elements.passwordInput().clear().type(password);
  }

  checkAdminCheckbox() {
    this.elements.adminCheckbox().check();
  }

  uncheckAdminCheckbox() {
    this.elements.adminCheckbox().uncheck();
  }

  clickRegister() {
    this.elements.registerButton().click();
  }

  clickLoginLink() {
    this.elements.loginLink().click();
  }

  register(name, email, password, isAdmin = false) {
    this.fillName(name);
    this.fillEmail(email);
    this.fillPassword(password);
    if (isAdmin) {
      this.checkAdminCheckbox();
    } else {
      this.uncheckAdminCheckbox();
    }
    this.clickRegister();
  }

  // Verificações
  verifyErrorMessage(message) {
    this.elements.errorMessage().should("contain", message);
  }

  verifyOnRegisterPage() {
    this.elements.pageTitle().should("contain", "Cadastro");
  }
}

export default RegisterPage;
