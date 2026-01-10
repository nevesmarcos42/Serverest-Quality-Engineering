// Custom commands para facilitar os testes

Cypress.Commands.add("login", (email, password) => {
  cy.visit("/login");
  cy.get('[data-testid="email"]').type(email);
  cy.get('[data-testid="senha"]').type(password);
  cy.get('[data-testid="entrar"]').click();
});

Cypress.Commands.add("criarUsuarioAPI", (usuario) => {
  return cy.request({
    method: "POST",
    url: `${Cypress.env("apiUrl")}/usuarios`,
    body: usuario,
    failOnStatusCode: false,
  });
});

Cypress.Commands.add("loginAPI", (email, password) => {
  return cy
    .request({
      method: "POST",
      url: `${Cypress.env("apiUrl")}/login`,
      body: { email, password },
    })
    .then((response) => {
      return response.body.authorization;
    });
});

// Helper para criar usuario e logar
Cypress.Commands.add("criarEFazerLogin", () => {
  const timestamp = new Date().getTime();
  const usuario = {
    nome: "Usuario Teste",
    email: `usuario_${timestamp}@qa.com.br`,
    password: "teste123",
    administrador: "false",
  };

  cy.criarUsuarioAPI(usuario);
  cy.login(usuario.email, usuario.password);
});

Cypress.Commands.add("gerarDadosUnicos", () => {
  const timestamp = new Date().getTime();
  return {
    nome: `Usuario ${timestamp}`,
    email: `user_${timestamp}@qa.com.br`,
    password: "senha123",
  };
});
