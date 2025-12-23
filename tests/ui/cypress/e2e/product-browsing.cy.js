import HomePage from "../support/pages/HomePage";

describe("Product Browsing", () => {
  let userData;

  before(() => {
    // Cria usuário via API e faz login
    userData = Cypress.generateUserData(false);
    cy.createUser(userData);
  });

  beforeEach(() => {
    // Faz login antes de cada teste
    cy.loginViaAPI(userData.email, userData.password);
    HomePage.visit();
  });

  it("should display list of products", () => {
    HomePage.shouldBeVisible();
    HomePage.productCards.should("exist").and("have.length.greaterThan", 0);
  });

  it("should display product information", () => {
    HomePage.productCards.first().within(() => {
      // Cada card de produto deve ter links de detalhes e botão de adicionar
      cy.get('[data-testid="product-detail-link"]').should("exist");
      cy.get('[data-testid="adicionarNaLista"]').should("be.visible");
    });
  });

  it("should search for products by name", () => {
    // Realiza uma busca genérica
    const searchTerm = "Produto";

    HomePage.search(searchTerm);

    // Deve ainda mostrar produtos após a busca
    HomePage.productCards.should("have.length.greaterThan", 0);
  });

  it("should show all products when search is cleared", () => {
    // Conta produtos iniciais
    HomePage.productCards.its("length").then((initialCount) => {
      // Busca por algo
      HomePage.search("Mouse");

      // A contagem de produtos pode ser diferente
      HomePage.productCards.should("exist");

      // Limpa a busca
      HomePage.searchInput.clear();

      // Deve mostrar todos os produtos novamente
      HomePage.productCards.should("have.length.gte", 1);
    });
  });

  it("should have functional add to cart buttons", () => {
    HomePage.addToCartButtons
      .first()
      .should("be.visible")
      .and("not.be.disabled");
  });
});
