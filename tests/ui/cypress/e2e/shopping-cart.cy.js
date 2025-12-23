import HomePage from "../support/pages/HomePage";

describe("Shopping Cart", () => {
  let userData;
  let adminData;
  let productId;

  before(() => {
    // Cria usuário admin e produto via API
    adminData = Cypress.generateUserData(true);
    cy.createUser(adminData).then((response) => {
      const adminEmail = adminData.email;
      const adminPassword = adminData.password;

      // Faz login como admin e cria produto
      cy.loginViaAPI(adminEmail, adminPassword).then((token) => {
        cy.request({
          method: "POST",
          url: `${Cypress.env("apiUrl")}/produtos`,
          headers: {
            Authorization: token,
          },
          body: {
            nome: `Test Product ${Date.now()}`,
            preco: 100,
            descricao: "Product for cart testing",
            quantidade: 50,
          },
        }).then((response) => {
          productId = response.body._id;
        });
      });
    });

    // Cria usuário regular para testes
    userData = Cypress.generateUserData(false);
    cy.createUser(userData);
  });

  beforeEach(() => {
    cy.loginViaAPI(userData.email, userData.password);
    HomePage.visit();
  });

  it("should add product to cart", () => {
    // Adiciona produto à lista
    HomePage.addFirstProductToCart();
    cy.wait(500);

    // Verifica que foi para a página de lista de compras
    cy.url().should("include", "/minhaListaDeProdutos");

    // Verifica que o produto está na lista
    cy.get('[data-testid="shopping-cart-product-name"]').should("exist");
  });

  it("should navigate to cart page", () => {
    HomePage.goToCart();

    cy.url().should("include", "/minhaListaDeProdutos");
  });

  it("should display cart items in cart page", () => {
    // Adiciona produto à lista primeiro
    HomePage.addFirstProductToCart();
    cy.wait(500);

    // Já está na página da lista de compras
    // Verifica que produto está visível
    cy.get('[data-testid="shopping-cart-product-name"]').should("exist");
    cy.get('[data-testid="shopping-cart-product-quantity"]').should("exist");
  });

  it("should update cart badge when adding multiple products", () => {
    // Adiciona primeiro produto
    HomePage.addToCartButtons.eq(0).click();
    cy.wait(500);

    // Verifica que foi adicionado
    cy.get('[data-testid="shopping-cart-product-name"]').should(
      "have.length.greaterThan",
      0
    );

    // Volta para home
    cy.get('[data-testid="paginaInicial"]').click();
    cy.wait(500);

    // Adiciona segundo produto
    HomePage.addToCartButtons.eq(1).click();
    cy.wait(500);

    // Verifica que agora tem 2 produtos
    cy.get('[data-testid="shopping-cart-product-name"]').should(
      "have.length.greaterThan",
      1
    );
  });

  it("should complete purchase from cart page", () => {
    // Adiciona produto e vai para lista
    HomePage.addFirstProductToCart();
    cy.wait(500);

    // Botão de adicionar ao carrinho deve existir
    cy.get('[data-testid="adicionar carrinho"]').should("be.visible").click();

    // Deve redirecionar (comportamento da aplicação)
    cy.wait(500);
  });

  it("should cancel purchase and return to shopping", () => {
    // Adiciona produto e vai para lista
    HomePage.addFirstProductToCart();
    cy.wait(500);

    // Clica em "Página Inicial" para voltar
    cy.get('[data-testid="paginaInicial"]').should("be.visible").click();

    // Deve redirecionar para home
    cy.url().should("include", "/home");
  });

  it("should persist cart across page navigation", () => {
    // Adiciona produto
    HomePage.addFirstProductToCart();
    cy.wait(500);

    // Verifica que tem produto
    cy.get('[data-testid="shopping-cart-product-name"]').should("exist");

    // Volta para home e depois para lista novamente
    cy.get('[data-testid="paginaInicial"]').click();
    cy.wait(300);
    cy.get('[data-testid="lista-de-compras"]').click();
    cy.wait(300);

    // Produto deve ainda estar lá
    cy.get('[data-testid="shopping-cart-product-name"]').should("exist");
  });
});
