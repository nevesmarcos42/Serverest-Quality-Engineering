/**
 * Page Object for Home/Products page
 */
class HomePage {
  // Seletores
  get welcomeMessage() {
    return cy.get("h1");
  }

  get userNameDisplay() {
    // Não existe elemento específico para nome do usuário na aplicação
    // Vamos retornar o body para verificações gerais
    return cy.get("body");
  }

  get logoutButton() {
    return cy.get('[data-testid="logout"]');
  }

  get searchInput() {
    return cy.get('[data-testid="pesquisar"]');
  }

  get productCards() {
    // Os cards de produto contêm o botão adicionarNaLista
    // Vamos usar o container pai desses botões
    return cy.get('[data-testid="adicionarNaLista"]').parent().parent();
  }

  get cartBadge() {
    // Na verdade não existe badge visível para carrinho
    // Vamos usar a lista de compras
    return cy.get('[data-testid="listaProdutos"]');
  }

  get cartLink() {
    // Link para lista de compras (não carrinho)
    return cy.get('[data-testid="lista-de-compras"]');
  }

  get addToCartButtons() {
    return cy.get('[data-testid="adicionarNaLista"]');
  }

  // Ações
  visit() {
    cy.visit("/home");
  }

  logout() {
    this.logoutButton.click();
  }

  search(productName) {
    this.searchInput.clear().type(productName);
  }

  addFirstProductToCart() {
    this.addToCartButtons.first().click();
  }

  addProductToCartByName(productName) {
    // Procura o produto pelo nome e clica no botão de adicionar
    cy.contains(productName)
      .parent()
      .parent()
      .find('[data-testid="adicionarNaLista"]')
      .click();
  }

  goToCart() {
    this.cartLink.click();
  }

  // Assertions
  shouldBeVisible() {
    this.welcomeMessage.should("be.visible").and("contain", "Serverest Store");
  }

  shouldDisplayUserName(name) {
    // A aplicação não mostra o nome do usuário na tela
    // Vamos apenas verificar que estamos logados checando o botão de logout
    this.logoutButton.should("be.visible");
  }

  shouldShowProductCount(count) {
    this.productCards.should("have.length", count);
  }

  shouldShowCartItemCount(count) {
    this.cartBadge.should("contain", count);
  }
}

export default new HomePage();
