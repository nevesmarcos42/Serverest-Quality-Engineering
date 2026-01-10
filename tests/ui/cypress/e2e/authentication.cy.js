import LoginPage from "../support/pages/LoginPage";
import RegisterPage from "../support/pages/RegisterPage";
import HomePage from "../support/pages/HomePage";

describe("Autenticação de Usuário", () => {
  const loginPage = new LoginPage();
  const registerPage = new RegisterPage();
  const homePage = new HomePage();

  beforeEach(() => {
    cy.clearCookies();
    cy.clearLocalStorage();
  });

  describe("Cadastro de Usuário", () => {
    it("Deve cadastrar novo usuário com sucesso", () => {
      const timestamp = new Date().getTime();
      const usuario = {
        nome: `Usuario Teste ${timestamp}`,
        email: `usuario_${timestamp}@qa.com.br`,
        password: "senha123",
      };

      registerPage.visit();
      registerPage.register(
        usuario.nome,
        usuario.email,
        usuario.password,
        false
      );

      homePage.verifyOnHomePage();
      homePage.verifyWelcomeMessage(usuario.nome);
    });

    it("Deve cadastrar administrador com sucesso", () => {
      const timestamp = new Date().getTime();
      const admin = {
        nome: `Admin Teste ${timestamp}`,
        email: `admin_${timestamp}@qa.com.br`,
        password: "admin123",
      };

      registerPage.visit();
      registerPage.register(admin.nome, admin.email, admin.password, true);

      homePage.verifyOnHomePage();
      homePage.verifyRegisterProductButton();
    });

    it("Deve exibir erro ao cadastrar email duplicado", () => {
      const timestamp = new Date().getTime();
      const usuario = {
        nome: "Usuario Duplicado",
        email: `duplicado_${timestamp}@qa.com.br`,
        password: "senha123",
      };

      // Criar primeiro usuário
      cy.criarUsuarioAPI({
        nome: usuario.nome,
        email: usuario.email,
        password: usuario.password,
        administrador: "false",
      });

      // Tentar cadastrar novamente
      registerPage.visit();
      registerPage.register(
        usuario.nome,
        usuario.email,
        usuario.password,
        false
      );

      registerPage.verifyErrorMessage("Este email já está sendo usado");
    });
  });

  describe("Login de Usuário", () => {
    it("Deve fazer login com credenciais válidas", () => {
      const timestamp = new Date().getTime();
      const usuario = {
        nome: "Usuario Login",
        email: `login_${timestamp}@qa.com.br`,
        password: "senha123",
        administrador: "false",
      };

      // Criar usuário via API
      cy.criarUsuarioAPI(usuario);

      // Fazer login
      loginPage.visit();
      loginPage.login(usuario.email, usuario.password);

      // Verificar sucesso
      homePage.verifyOnHomePage();
    });

    it("Deve exibir erro ao fazer login com email inválido", () => {
      loginPage.visit();
      loginPage.login("emailinexistente@qa.com.br", "senha123");

      loginPage.verifyErrorMessage("Email e/ou senha inválidos");
    });

    it("Deve exibir erro ao fazer login com senha incorreta", () => {
      const timestamp = new Date().getTime();
      const usuario = {
        nome: "Usuario Senha",
        email: `senha_${timestamp}@qa.com.br`,
        password: "senhaCorreta",
        administrador: "false",
      };

      cy.criarUsuarioAPI(usuario);

      loginPage.visit();
      loginPage.login(usuario.email, "senhaErrada");

      loginPage.verifyErrorMessage("Email e/ou senha inválidos");
    });
  });

  describe("Logout de Usuário", () => {
    it("Deve fazer logout com sucesso", () => {
      // Criar usuário e fazer login
      cy.criarEFazerLogin();

      // Fazer logout
      homePage.clickLogout();

      // Verificar redirecionamento para login
      loginPage.verifyOnLoginPage();
    });
  });

  describe("Navegação", () => {
    it("Deve navegar de login para cadastro", () => {
      loginPage.visit();
      loginPage.clickRegisterLink();

      registerPage.verifyOnRegisterPage();
    });

    it("Deve navegar de cadastro para login", () => {
      registerPage.visit();
      registerPage.clickLoginLink();

      loginPage.verifyOnLoginPage();
    });
  });
});
