Feature: API de Produtos do ServeRest

  Background:
    * url baseUrl
    * def timestamp = function(){ return java.lang.System.currentTimeMillis() }
    * def gerarEmail = function(){ return 'admin' + timestamp() + '@qa.com' }
    * def gerarNome = function(){ return 'Usuario Teste ' + timestamp() }
    * def gerarProduto = function(){ return 'Produto ' + timestamp() }

  Scenario: Listar todos os produtos
    Given path '/produtos'
    When method GET
    Then status 200
    And match response.produtos == '#array'
    And match response.quantidade == '#number'

  Scenario: Cadastrar novo produto como administrador
    * def adminUser = { nome: '#(gerarNome())', email: '#(gerarEmail())', password: 'teste123', administrador: 'true' }
    Given path '/usuarios'
    And request adminUser
    When method POST
    Then status 201

    * def credenciais = { email: '#(adminUser.email)', password: '#(adminUser.password)' }
    Given path '/login'
    And request credenciais
    When method POST
    Then status 200
    And def token = response.authorization

    * def novoProduto = { nome: '#(gerarProduto())', preco: 100, descricao: 'Descrição teste', quantidade: 10 }
    Given path '/produtos'
    And header Authorization = token
    And request novoProduto
    When method POST
    Then status 201
    And match response.message == 'Cadastro realizado com sucesso'
    And match response._id == '#notnull'

  Scenario: Tentar cadastrar produto sem ser administrador
    * def normalUser = { nome: '#(gerarNome())', email: '#(gerarEmail())', password: 'teste123', administrador: 'false' }
    Given path '/usuarios'
    And request normalUser
    When method POST
    Then status 201

    * def credenciais = { email: '#(normalUser.email)', password: '#(normalUser.password)' }
    Given path '/login'
    And request credenciais
    When method POST
    Then status 200
    And def token = response.authorization

    * def novoProduto = { nome: '#(gerarProduto())', preco: 100, descricao: 'Descrição teste', quantidade: 10 }
    Given path '/produtos'
    And header Authorization = token
    And request novoProduto
    When method POST
    Then status 403
    And match response.message == 'Rota exclusiva para administradores'

  Scenario: Excluir produto existente
    * def adminUser = { nome: '#(gerarNome())', email: '#(gerarEmail())', password: 'teste123', administrador: 'true' }
    Given path '/usuarios'
    And request adminUser
    When method POST
    Then status 201

    * def credenciais = { email: '#(adminUser.email)', password: '#(adminUser.password)' }
    Given path '/login'
    And request credenciais
    When method POST
    Then status 200
    And def token = response.authorization

    * def novoProduto = { nome: '#(gerarProduto())', preco: 100, descricao: 'Descrição teste', quantidade: 10 }
    Given path '/produtos'
    And header Authorization = token
    And request novoProduto
    When method POST
    Then status 201
    And def produtoId = response._id

    Given path '/produtos', produtoId
    And header Authorization = token
    When method DELETE
    Then status 200
    And match response.message contains 'excluído'
