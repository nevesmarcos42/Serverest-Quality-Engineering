// Função helper para gerar email único para testes
Cypress.generateUniqueEmail = () => {
  const timestamp = Date.now();
  const random = Math.floor(Math.random() * 10000);
  return `qa.user.${timestamp}.${random}@test.com`;
};

// Função helper para gerar dados de usuário únicos
Cypress.generateUserData = (isAdmin = false) => {
  const timestamp = Date.now();
  const random = Math.floor(Math.random() * 10000);

  return {
    nome: `Test User ${timestamp}`,
    email: `qa.user.${timestamp}.${random}@test.com`,
    password: "teste123",
    administrador: isAdmin ? "true" : "false",
  };
};

// Comando customizado para criar usuário via API
Cypress.Commands.add("createUser", (userData) => {
  return cy.request({
    method: "POST",
    url: `${Cypress.env("apiUrl")}/usuarios`,
    body: userData,
    failOnStatusCode: false,
  });
});

// Comando customizado para fazer login via API e definir token
Cypress.Commands.add("loginViaAPI", (email, password) => {
  return cy
    .request({
      method: "POST",
      url: `${Cypress.env("apiUrl")}/login`,
      body: {
        email: email,
        password: password,
      },
    })
    .then((response) => {
      expect(response.status).to.eq(200);
      const token = response.body.authorization;
      window.localStorage.setItem("serverest/userToken", token);
      return token;
    });
});

// Comando customizado para fazer login via UI
Cypress.Commands.add("loginViaUI", (email, password) => {
  cy.visit("/login");
  cy.get('[data-testid="email"]').type(email);
  cy.get('[data-testid="senha"]').type(password);
  cy.get('[data-testid="entrar"]').click();
});

// Comando customizado para fazer logout
Cypress.Commands.add("logout", () => {
  cy.get('[data-testid="logout"]').click();
});
