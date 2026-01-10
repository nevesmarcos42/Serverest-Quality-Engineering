class LoginPage {
  // Elementos da página
  elements = {
    emailInput: () => cy.get('[data-testid="email"]'),
    passwordInput: () => cy.get('[data-testid="senha"]'),
    loginButton: () => cy.get('[data-testid="entrar"]'),
    registerLink: () => cy.contains("Cadastre-se"),
    errorMessage: () => cy.get(".alert"),
    pageTitle: () => cy.get("h1"),
  };

  // Ações da página
  visit() {
    cy.visit("/login");
  }

  fillEmail(email) {
    this.elements.emailInput().clear().type(email);
  }

  fillPassword(password) {
    this.elements.passwordInput().clear().type(password);
  }

  clickLogin() {
    this.elements.loginButton().click();
  }

  clickRegisterLink() {
    this.elements.registerLink().click();
  }

  login(email, password) {
    this.fillEmail(email);
    this.fillPassword(password);
    this.clickLogin();
  }

  // Verificações
  verifyErrorMessage(message) {
    this.elements.errorMessage().should("contain", message);
  }

  verifyOnLoginPage() {
    this.elements.pageTitle().should("contain", "Login");
  }
}

export default LoginPage;
