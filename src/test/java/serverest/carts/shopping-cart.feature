Feature: Testes da API de Carrinho de Compras
  
  Background:
    * url baseUrl
    * def cartsPath = '/carrinhos'
    * def productsPath = '/produtos'
    * def utils = call read('classpath:serverest/helpers/utils.js')

  Scenario: Criar carrinho de compras com produto
    # Preparação: Cria admin, produto e usuário comum
    * def admin = utils.createAdminAndGetToken()
    * def uniqueName = utils.generateProductName()
    Given path productsPath
    And header Authorization = admin.token
    And request { nome: '#(uniqueName)', preco: 150, descricao: 'Test Product', quantidade: 100 }
    When method POST
    Then status 201
    And def productId = response._id
    
    * def user = utils.createTestUser(false)
    * def userToken = utils.loginAndGetToken(user.email, user.password)
    
    # Cria carrinho
    * def cartData = { produtos: [{ idProduto: '#(productId)', quantidade: 2 }] }
    Given path cartsPath
    And header Authorization = userToken
    And request cartData
    When method POST
    Then status 201
    And match response.message == 'Cadastro realizado com sucesso'
    And match response._id == '#present'

  Scenario: Não pode criar segundo carrinho para o mesmo usuário
    # Preparação
    * def admin = utils.createAdminAndGetToken()
    * def uniqueName = utils.generateProductName()
    Given path productsPath
    And header Authorization = admin.token
    And request { nome: '#(uniqueName)', preco: 100, descricao: 'Product', quantidade: 50 }
    When method POST
    And def productId = response._id
    
    * def user = utils.createTestUser(false)
    * def userToken = utils.loginAndGetToken(user.email, user.password)
    
    # Cria primeiro carrinho
    Given path cartsPath
    And header Authorization = userToken
    And request { produtos: [{ idProduto: '#(productId)', quantidade: 1 }] }
    When method POST
    Then status 201
    And def cartId = response._id
    
    # Tenta criar segundo carrinho
    Given path cartsPath
    And header Authorization = userToken
    And request { produtos: [{ idProduto: '#(productId)', quantidade: 1 }] }
    When method POST
    Then status 400
    And match response.message == 'Não é permitido ter mais de 1 carrinho'
    And match response.idCarrinho == cartId

  Scenario: Não pode adicionar produto com estoque insuficiente
    * def admin = utils.createAdminAndGetToken()
    * def uniqueName = utils.generateProductName()
    Given path productsPath
    And header Authorization = admin.token
    And request { nome: '#(uniqueName)', preco: 100, descricao: 'Low Stock', quantidade: 5 }
    When method POST
    And def productId = response._id
    
    * def user = utils.createTestUser(false)
    * def userToken = utils.loginAndGetToken(user.email, user.password)
    
    # Tenta adicionar mais que o disponível
    Given path cartsPath
    And header Authorization = userToken
    And request { produtos: [{ idProduto: '#(productId)', quantidade: 10 }] }
    When method POST
    Then status 400
    And match response.message == 'Produto não possui quantidade suficiente'

  Scenario: Não pode adicionar produto inexistente ao carrinho
    * def user = utils.createTestUser(false)
    * def userToken = utils.loginAndGetToken(user.email, user.password)
    
    Given path cartsPath
    And header Authorization = userToken
    And request { produtos: [{ idProduto: 'invalidproductid', quantidade: 1 }] }
    When method POST
    Then status 400
    And match response.message == 'Produto não encontrado'

  Scenario: Listar todos os carrinhos
    Given path cartsPath
    When method GET
    Then status 200
    And match response.quantidade == '#number'
    And match response.carrinhos == '#array'

  Scenario: Concluir compra com sucesso
    # Preparação
    * def admin = utils.createAdminAndGetToken()
    * def uniqueName = utils.generateProductName()
    Given path productsPath
    And header Authorization = admin.token
    And request { nome: '#(uniqueName)', preco: 100, descricao: 'Product', quantidade: 50 }
    When method POST
    And def productId = response._id
    
    * def user = utils.createTestUser(false)
    * def userToken = utils.loginAndGetToken(user.email, user.password)
    
    # Cria carrinho
    Given path cartsPath
    And header Authorization = userToken
    And request { produtos: [{ idProduto: '#(productId)', quantidade: 2 }] }
    When method POST
    Then status 201
    
    # Conclui compra
    Given path cartsPath + '/concluir-compra'
    And header Authorization = userToken
    When method DELETE
    Then status 200
    And match response.message == 'Registro excluído com sucesso'

  Scenario: Cancelar compra e restaurar estoque
    # Preparação
    * def admin = utils.createAdminAndGetToken()
    * def uniqueName = utils.generateProductName()
    Given path productsPath
    And header Authorization = admin.token
    And request { nome: '#(uniqueName)', preco: 100, descricao: 'Product', quantidade: 50 }
    When method POST
    And def productId = response._id
    
    * def user = utils.createTestUser(false)
    * def userToken = utils.loginAndGetToken(user.email, user.password)
    
    # Cria carrinho
    Given path cartsPath
    And header Authorization = userToken
    And request { produtos: [{ idProduto: '#(productId)', quantidade: 3 }] }
    When method POST
    Then status 201
    
    # Cancela compra
    Given path cartsPath + '/cancelar-compra'
    And header Authorization = userToken
    When method DELETE
    Then status 200
    And match response.message == 'Registro excluído com sucesso. Estoque dos produtos reabastecido'

  Scenario: Concluir compra sem carrinho
    * def user = utils.createTestUser(false)
    * def userToken = utils.loginAndGetToken(user.email, user.password)
    
    Given path cartsPath + '/concluir-compra'
    And header Authorization = userToken
    When method DELETE
    Then status 200
    And match response.message == 'Não foi encontrado carrinho para esse usuário'

  Scenario: Criar carrinho sem autenticação
    * def admin = utils.createAdminAndGetToken()
    * def uniqueName = utils.generateProductName()
    Given path productsPath
    And header Authorization = admin.token
    And request { nome: '#(uniqueName)', preco: 100, descricao: 'Product', quantidade: 50 }
    When method POST
    And def productId = response._id
    
    # Tenta criar carrinho sem token
    Given path cartsPath
    And request { produtos: [{ idProduto: '#(productId)', quantidade: 1 }] }
    When method POST
    Then status 401

  Scenario: Carrinho calcula preço total corretamente
    # Preparação
    * def admin = utils.createAdminAndGetToken()
    * def name1 = utils.generateProductName()
    * def name2 = utils.generateProductName()
    
    Given path productsPath
    And header Authorization = admin.token
    And request { nome: '#(name1)', preco: 150, descricao: 'Product 1', quantidade: 50 }
    When method POST
    And def prod1Id = response._id
    
    Given path productsPath
    And header Authorization = admin.token
    And request { nome: '#(name2)', preco: 300, descricao: 'Product 2', quantidade: 50 }
    When method POST
    And def prod2Id = response._id
    
    * def user = utils.createTestUser(false)
    * def userToken = utils.loginAndGetToken(user.email, user.password)
    
    # Cria carrinho com múltiplos produtos
    * def cartData = 
    """
    {
      produtos: [
        { idProduto: '#(prod1Id)', quantidade: 2 },
        { idProduto: '#(prod2Id)', quantidade: 1 }
      ]
    }
    """
    Given path cartsPath
    And header Authorization = userToken
    And request cartData
    When method POST
    Then status 201
    And def cartId = response._id
    
    # Verifica cálculo do preço total (2*150 + 1*300 = 600)
    Given path cartsPath
    When method GET
    Then status 200
    * def cart = karate.filter(response.carrinhos, function(x){ return x._id == cartId })[0]
    * match cart.precoTotal == 600
    * match cart.quantidadeTotal == 3
