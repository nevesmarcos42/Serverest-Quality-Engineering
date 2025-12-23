Feature: Testes da API de Gerenciamento de Produtos
  
  Background:
    * url baseUrl
    * def productsPath = '/produtos'
    * def utils = call read('classpath:serverest/helpers/utils.js')
    * def admin = utils.createAdminAndGetToken()
    * def adminToken = admin.token

  Scenario: Criar produto como administrador
    * def uniqueName = utils.generateProductName()
    * def productData = 
    """
    {
      nome: '#(uniqueName)',
      preco: 150,
      descricao: 'Mouse ergonômico',
      quantidade: 50
    }
    """
    Given path productsPath
    And header Authorization = adminToken
    And request productData
    When method POST
    Then status 201
    And match response.message == 'Cadastro realizado com sucesso'
    And match response._id == '#present'

  Scenario: Não pode criar produto com nome duplicado
    * def uniqueName = utils.generateProductName()
    * def productData = { nome: '#(uniqueName)', preco: 100, descricao: 'Test', quantidade: 10 }
    
    # Cria o primeiro produto
    Given path productsPath
    And header Authorization = adminToken
    And request productData
    When method POST
    Then status 201
    
    # Tenta criar segundo produto com o mesmo nome
    Given path productsPath
    And header Authorization = adminToken
    And request productData
    When method POST
    Then status 400
    And match response.message == 'Já existe produto com esse nome'

  Scenario: Criar produto sem nome
    Given path productsPath
    And header Authorization = adminToken
    And request { preco: 100, descricao: 'Test', quantidade: 10 }
    When method POST
    Then status 400
    And match response.nome == 'nome não pode ficar em branco'

  Scenario: Criar produto sem preço
    * def uniqueName = utils.generateProductName()
    Given path productsPath
    And header Authorization = adminToken
    And request { nome: '#(uniqueName)', descricao: 'Test', quantidade: 10 }
    When method POST
    Then status 400
    And match response.preco == 'preco deve ser um número'

  Scenario: Criar produto com preço inválido
    * def uniqueName = utils.generateProductName()
    Given path productsPath
    And header Authorization = adminToken
    And request { nome: '#(uniqueName)', preco: 'invalid', descricao: 'Test', quantidade: 10 }
    When method POST
    Then status 400
    And match response.preco == 'preco deve ser um número'

  Scenario: Criar produto com quantidade zero
    * def uniqueName = utils.generateProductName()
    * def productData = { nome: '#(uniqueName)', preco: 100, descricao: 'Test', quantidade: 0 }
    Given path productsPath
    And header Authorization = adminToken
    And request productData
    When method POST
    Then status 201

  Scenario: Usuário não-admin não pode criar produto
    * def regularUser = utils.createTestUser(false)
    * def userToken = utils.loginAndGetToken(regularUser.email, regularUser.password)
    * def uniqueName = utils.generateProductName()
    
    Given path productsPath
    And header Authorization = userToken
    And request { nome: '#(uniqueName)', preco: 100, descricao: 'Test', quantidade: 10 }
    When method POST
    Then status 401
    And match response.message == 'Rota exclusiva para administradores'

  Scenario: Não pode criar produto sem autenticação
    * def uniqueName = utils.generateProductName()
    Given path productsPath
    And request { nome: '#(uniqueName)', preco: 100, descricao: 'Test', quantidade: 10 }
    When method POST
    Then status 401

  Scenario: Listar todos os produtos
    Given path productsPath
    When method GET
    Then status 200
    And match response.quantidade == '#number'
    And match response.produtos == '#array'

  Scenario: Buscar produto por ID
    # Primeiro cria um produto
    * def uniqueName = utils.generateProductName()
    * def productData = { nome: '#(uniqueName)', preco: 100, descricao: 'Test', quantidade: 10 }
    Given path productsPath
    And header Authorization = adminToken
    And request productData
    When method POST
    Then status 201
    And def productId = response._id
    
    # Busca produto por ID
    Given path productsPath + '/' + productId
    When method GET
    Then status 200
    And match response._id == productId
    And match response.nome == uniqueName

  Scenario: Buscar produto com ID inexistente
    Given path productsPath + '/invalidproductid'
    When method GET
    Then status 400
    And match response.message == 'Produto não encontrado'

  Scenario: Filtrar produtos por nome
    * def uniqueName = utils.generateProductName()
    * def productData = { nome: '#(uniqueName)', preco: 100, descricao: 'Test', quantidade: 10 }
    Given path productsPath
    And header Authorization = adminToken
    And request productData
    When method POST
    Then status 201
    
    # Filtra por nome
    Given path productsPath
    And param nome = uniqueName
    When method GET
    Then status 200
    And match response.produtos[0].nome == uniqueName

  Scenario: Filtrar produtos por preço
    Given path productsPath
    And param preco = 100
    When method GET
    Then status 200
    And match each response.produtos[*].preco == 100

  Scenario: Filtrar produtos por descrição
    * def uniqueDesc = 'Unique Description ' + new Date().getTime()
    * def uniqueName = utils.generateProductName()
    * def productData = { nome: '#(uniqueName)', preco: 100, descricao: '#(uniqueDesc)', quantidade: 10 }
    Given path productsPath
    And header Authorization = adminToken
    And request productData
    When method POST
    Then status 201
    
    # Filtra por descrição
    Given path productsPath
    And param descricao = uniqueDesc
    When method GET
    Then status 200
    And match response.produtos[0].descricao == uniqueDesc

  Scenario: Atualizar informações do produto
    # Cria produto
    * def uniqueName = utils.generateProductName()
    * def productData = { nome: '#(uniqueName)', preco: 100, descricao: 'Original', quantidade: 10 }
    Given path productsPath
    And header Authorization = adminToken
    And request productData
    When method POST
    Then status 201
    And def productId = response._id
    
    # Atualiza produto
    * def updatedData = { nome: '#(uniqueName)', preco: 200, descricao: 'Updated', quantidade: 20 }
    Given path productsPath + '/' + productId
    And header Authorization = adminToken
    And request updatedData
    When method PUT
    Then status 200
    And match response.message == 'Registro alterado com sucesso'

  Scenario: Atualizar produto inexistente cria novo produto
    * def uniqueName = utils.generateProductName()
    * def productData = { nome: '#(uniqueName)', preco: 100, descricao: 'New', quantidade: 10 }
    
    Given path productsPath + '/newproductid'
    And header Authorization = adminToken
    And request productData
    When method PUT
    Then status 201
    And match response.message == 'Cadastro realizado com sucesso'

  Scenario: Não pode atualizar produto para usar nome existente
    # Cria dois produtos
    * def name1 = utils.generateProductName()
    * def name2 = utils.generateProductName()
    
    Given path productsPath
    And header Authorization = adminToken
    And request { nome: '#(name1)', preco: 100, descricao: 'Prod1', quantidade: 10 }
    When method POST
    Then status 201
    And def prod1Id = response._id
    
    Given path productsPath
    And header Authorization = adminToken
    And request { nome: '#(name2)', preco: 200, descricao: 'Prod2', quantidade: 20 }
    When method POST
    Then status 201
    
    # Tenta atualizar produto 1 para usar nome do produto 2
    Given path productsPath + '/' + prod1Id
    And header Authorization = adminToken
    And request { nome: '#(name2)', preco: 100, descricao: 'Updated', quantidade: 10 }
    When method PUT
    Then status 400
    And match response.message == 'Já existe produto com esse nome'

  Scenario: Usuário não-admin não pode atualizar produto
    * def regularUser = utils.createTestUser(false)
    * def userToken = utils.loginAndGetToken(regularUser.email, regularUser.password)
    
    # Cria produto como admin
    * def uniqueName = utils.generateProductName()
    Given path productsPath
    And header Authorization = adminToken
    And request { nome: '#(uniqueName)', preco: 100, descricao: 'Test', quantidade: 10 }
    When method POST
    Then status 201
    And def productId = response._id
    
    # Tenta atualizar como usuário comum
    Given path productsPath + '/' + productId
    And header Authorization = userToken
    And request { nome: '#(uniqueName)', preco: 200, descricao: 'Updated', quantidade: 20 }
    When method PUT
    Then status 401

  Scenario: Deletar produto com sucesso
    # Cria produto
    * def uniqueName = utils.generateProductName()
    Given path productsPath
    And header Authorization = adminToken
    And request { nome: '#(uniqueName)', preco: 100, descricao: 'Test', quantidade: 10 }
    When method POST
    Then status 201
    And def productId = response._id
    
    # Deleta produto
    Given path productsPath + '/' + productId
    And header Authorization = adminToken
    When method DELETE
    Then status 200
    And match response.message == 'Registro excluído com sucesso'

  Scenario: Deletar produto inexistente
    Given path productsPath + '/nonexistentproduct'
    And header Authorization = adminToken
    When method DELETE
    Then status 200
    And match response.message == 'Nenhum registro excluído'

  Scenario: Usuário não-admin não pode deletar produto
    * def regularUser = utils.createTestUser(false)
    * def userToken = utils.loginAndGetToken(regularUser.email, regularUser.password)
    
    # Cria produto como admin
    * def uniqueName = utils.generateProductName()
    Given path productsPath
    And header Authorization = adminToken
    And request { nome: '#(uniqueName)', preco: 100, descricao: 'Test', quantidade: 10 }
    When method POST
    Then status 201
    And def productId = response._id
    
    # Tenta deletar como usuário comum
    Given path productsPath + '/' + productId
    And header Authorization = userToken
    When method DELETE
    Then status 401
    And match response.message == 'Rota exclusiva para administradores'
