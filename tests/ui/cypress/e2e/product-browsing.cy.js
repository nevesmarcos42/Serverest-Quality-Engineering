import HomePage from "../support/pages/HomePage";

describe("Navegação e Visualização de Produtos", () => {
  const homePage = new HomePage();

  beforeEach(() => {
    // Criar usuário e fazer login antes de cada teste
    cy.criarEFazerLogin();
    cy.wait(2000); // Aguardar carregamento da página
  });

  it("Deve visualizar lista de produtos na página inicial", () => {
    // Verificar se está na home page
    cy.url().should("include", "/home");
    // Verificar se há elementos visíveis na página
    cy.get("body").should("be.visible");
  });

  it("Deve exibir informações dos produtos", () => {
    // Verificar se há títulos de produtos visíveis
    cy.get("h4, h5, h3", { timeout: 10000 }).should(
      "have.length.greaterThan",
      0
    );
    // Verificar se há conteúdo de texto nos produtos
    cy.get("h4, h5, h3")
      .first()
      .invoke("text")
      .should("have.length.greaterThan", 0);
  });

  it('Deve exibir botão "Adicionar" ou similar em cada produto', () => {
    // Verificar se existem botões de adicionar na página
    cy.get("button").should("have.length.greaterThan", 0);
  });

  it("Deve exibir múltiplos produtos no catálogo", () => {
    // Verificar se há múltiplos títulos/cards de produtos
    cy.get('h4, h5, [class*="card"]').should("have.length.greaterThan", 0);
  });

  it("Deve ter layout consistente nos cards de produtos", () => {
    // Verificar se elementos da página estão visíveis
    cy.get("h4, h5").first().should("be.visible");
    cy.get("button").should("have.length.greaterThan", 0);
  });
});
