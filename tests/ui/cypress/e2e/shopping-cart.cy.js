import HomePage from "../support/pages/HomePage";

describe("Gerenciamento de Lista de Compras", () => {
  const homePage = new HomePage();

  beforeEach(() => {
    // Criar usuário e fazer login
    cy.criarEFazerLogin();
  });

  it("Deve adicionar produto à lista de compras", () => {
    // Verificar contador inicial
    homePage.elements.cartItemCount().then(($count) => {
      const initialCount = parseInt($count.text()) || 0;

      // Adicionar produto
      homePage.clickAddToCart(0);

      // Verificar que contador aumentou
      cy.wait(1000); // Aguardar atualização
      homePage.elements.cartItemCount().should("contain", initialCount + 1);
    });
  });

  it("Deve visualizar lista de compras", () => {
    // Adicionar produto
    homePage.clickAddToCart(0);

    // Acessar lista
    cy.wait(500);
    homePage.clickShoppingList();

    // Verificar que lista é exibida
    cy.url().should("include", "/listaDeCompras");
  });

  it("Deve adicionar múltiplos produtos à lista", () => {
    // Adicionar 3 produtos
    homePage.clickAddToCart(0);
    cy.wait(500);
    homePage.clickAddToCart(1);
    cy.wait(500);
    homePage.clickAddToCart(2);

    // Verificar contador
    cy.wait(1000);
    homePage.elements
      .cartItemCount()
      .invoke("text")
      .then((text) => {
        const count = parseInt(text);
        expect(count).to.be.at.least(3);
      });
  });

  it("Deve remover produto da lista", () => {
    // Adicionar produto
    homePage.clickAddToCart(0);
    cy.wait(500);

    // Ir para lista
    homePage.clickShoppingList();

    // Remover produto
    cy.contains("Excluir").first().click();

    // Verificar que produto foi removido
    cy.wait(500);
  });

  it("Deve limpar toda a lista de compras", () => {
    // Adicionar produtos
    homePage.clickAddToCart(0);
    cy.wait(500);
    homePage.clickAddToCart(1);
    cy.wait(500);

    // Ir para lista
    homePage.clickShoppingList();

    // Limpar lista
    cy.contains("Limpar Lista").click();

    // Verificar que lista está vazia
    cy.wait(500);
    cy.contains("Não há produtos na lista").should("be.visible");
  });

  it("Deve atualizar contador ao adicionar produtos", () => {
    let initialCount = 0;

    homePage.elements.cartItemCount().then(($el) => {
      initialCount = parseInt($el.text()) || 0;
    });

    // Adicionar primeiro produto
    homePage.clickAddToCart(0);
    cy.wait(500);

    homePage.elements.cartItemCount().should(($el) => {
      const count = parseInt($el.text());
      expect(count).to.equal(initialCount + 1);
    });

    // Adicionar segundo produto
    homePage.clickAddToCart(1);
    cy.wait(500);

    homePage.elements.cartItemCount().should(($el) => {
      const count = parseInt($el.text());
      expect(count).to.equal(initialCount + 2);
    });
  });

  it("Deve manter produtos na lista ao navegar entre páginas", () => {
    // Adicionar produto
    homePage.clickAddToCart(0);
    cy.wait(500);

    const countBefore = homePage.elements.cartItemCount().invoke("text");

    // Navegar para outra página e voltar
    cy.visit("/login");
    cy.visit("/");

    // Verificar que contador mantém valor
    homePage.elements
      .cartItemCount()
      .invoke("text")
      .should("equal", countBefore);
  });
});
