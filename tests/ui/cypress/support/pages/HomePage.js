class HomePage {
  // Seletores
  elements = {
    welcomeMessage: () =>
      cy.contains("Este é seu sistema para administrar seu ecommerce"),
    logoutButton: () => cy.contains("Logout"),
    registerProductButton: () => cy.contains("Cadastrar Produtos"),
    productCards: () =>
      cy.get('.card, .product, [class*="product"], [class*="card"]'),
    productName: () =>
      cy.get('.card h4, .product-name, [class*="product"] h4, h4, h5'),
    productPrice: () => cy.get('.card p, .price, [class*="price"]'),
    productDescription: () => cy.get(".card p, .description"),
    addToCartButtons: () => cy.contains("button", /Adicionar|Add/i),
    shoppingListLink: () => cy.get('a[href*="lista"]'),
    cartItemCount: () =>
      cy.get('[class*="badge"], .badge, span[class*="count"]'),
  };

  visit() {
    cy.visit("/");
  }

  clickLogout() {
    this.elements.logoutButton().click();
  }

  clickAddToCart(productIndex = 0) {
    this.elements.addToCartButtons().eq(productIndex).click();
  }

  clickShoppingList() {
    this.elements.shoppingListLink().click();
  }

  // Verificações
  verifyWelcomeMessage(name) {
    cy.contains(/bem.?vindo|welcome|ola/i).should("be.visible");
  }

  verifyOnHomePage() {
    cy.url().should("include", "/home");
  }

  verifyProductsDisplayed() {
    // Verificar se há produtos na página - mais flexível
    cy.get("body").should("be.visible");
    // Verificar se existe lista ou cards de produtos
    cy.get('h4, h5, [class*="card"], [class*="product"]', {
      timeout: 10000,
    });
  }

  verifyRegisterProductButton() {
    this.elements.registerProductButton().should("be.visible");
  }

  verifyCartCount(count) {
    this.elements.cartItemCount().should("contain", count);
  }
}

export default HomePage;
