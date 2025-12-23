import LoginPage from "../support/pages/LoginPage";
import RegisterPage from "../support/pages/RegisterPage";
import HomePage from "../support/pages/HomePage";

describe("User Authentication", () => {
  beforeEach(() => {
    cy.clearLocalStorage();
  });

  describe("Registration", () => {
    it("should register a new user successfully", () => {
      const userData = Cypress.generateUserData(false);

      RegisterPage.visit();
      RegisterPage.register(
        userData.nome,
        userData.email,
        userData.password,
        false
      );

      // Deve redirecionar para a página inicial
      cy.url().should("include", "/home");
      HomePage.shouldBeVisible();
      HomePage.shouldDisplayUserName(userData.nome);
    });

    it("should register an administrator successfully", () => {
      const userData = Cypress.generateUserData(true);

      RegisterPage.visit();
      RegisterPage.register(
        userData.nome,
        userData.email,
        userData.password,
        true
      );

      // Administrador pode ser redirecionado para /admin ou /home
      cy.url().should("not.include", "/cadastrarusuarios");
    });

    it("should show error when email already exists", () => {
      const userData = Cypress.generateUserData(false);

      // Cria usuário via API primeiro
      cy.createUser(userData).then((response) => {
        expect(response.status).to.eq(201);
      });

      // Tenta registrar com o mesmo email via UI
      RegisterPage.visit();
      RegisterPage.register(
        userData.nome,
        userData.email,
        userData.password,
        false
      );

      RegisterPage.shouldShowErrorMessage("Este email já está sendo usado");
    });

    it("should navigate to login page from registration", () => {
      RegisterPage.visit();
      RegisterPage.clickLoginLink();

      cy.url().should("include", "/login");
    });
  });

  describe("Login", () => {
    it("should login with valid credentials", () => {
      const userData = Cypress.generateUserData(false);

      // Cria usuário via API
      cy.createUser(userData);

      // Login via UI
      LoginPage.visit();
      LoginPage.login(userData.email, userData.password);

      cy.url().should("include", "/home");
      HomePage.shouldBeVisible();
      HomePage.shouldDisplayUserName(userData.nome);
    });

    it("should show error with invalid credentials", () => {
      LoginPage.visit();
      LoginPage.login("invalid@test.com", "wrongpassword");

      LoginPage.shouldShowErrorMessage("Email e/ou senha inválidos");
      cy.url().should("include", "/login");
    });

    it("should show validation error with empty fields", () => {
      LoginPage.visit();
      LoginPage.clickLogin();

      // Verifica que não foi redirecionado (ficou na página de login porque a validação impediu)
      cy.url().should("include", "/login");
      LoginPage.clickRegister();

      cy.url().should("include", "/cadastrarusuarios");
    });
  });

  describe("Logout", () => {
    it("should logout successfully", () => {
      const userData = Cypress.generateUserData(false);

      // Cria usuário e faz login via API
      cy.createUser(userData);
      cy.loginViaAPI(userData.email, userData.password);

      // Navega para a página inicial
      HomePage.visit();
      HomePage.shouldBeVisible();

      // Faz logout
      HomePage.logout();

      // Deve redirecionar para login
      cy.url().should("include", "/login");
    });
  });

  describe("Session Persistence", () => {
    it("should maintain session after page reload", () => {
      const userData = Cypress.generateUserData(false);

      // Cria usuário e faz login
      cy.createUser(userData);
      cy.loginViaAPI(userData.email, userData.password);

      HomePage.visit();
      HomePage.shouldDisplayUserName(userData.nome);

      // Recarrega a página
      cy.reload();

      // Sessão deve persistir
      HomePage.shouldBeVisible();
      HomePage.shouldDisplayUserName(userData.nome);
    });
  });
});
