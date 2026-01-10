Feature: API de Carrinhos do ServeRest

  Background:
    * url baseUrl
    * def timestamp = function(){ return java.lang.System.currentTimeMillis() }
    * def gerarEmail = function(){ return 'usuario' + timestamp() + '@qa.com' }
    * def gerarNome = function(){ return 'Usuario Teste ' + timestamp() }
    * def gerarProduto = function(){ return 'Produto ' + timestamp() }

  Scenario: Listar todos os carrinhos
    Given path '/carrinhos'
    When method GET
    Then status 200
    And match response.carrinhos == '#array'
    And match response.quantidade == '#number'

  Scenario: Criar carrinho com produto
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
    And def adminToken = response.authorization

    * def novoProduto = { nome: '#(gerarProduto())', preco: 100, descricao: 'Descrição teste', quantidade: 10 }
    Given path '/produtos'
    And header Authorization = adminToken
    And request novoProduto
    When method POST
    Then status 201
    And def produtoId = response._id

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
    And def userToken = response.authorization

    * def carrinho = { produtos: [{ idProduto: '#(produtoId)', quantidade: 2 }] }
    Given path '/carrinhos'
    And header Authorization = userToken
    And request carrinho
    When method POST
    Then status 201
    And match response.message == 'Cadastro realizado com sucesso'

  Scenario: Concluir compra e limpar carrinho
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
    And def adminToken = response.authorization

    * def novoProduto = { nome: '#(gerarProduto())', preco: 100, descricao: 'Descrição teste', quantidade: 10 }
    Given path '/produtos'
    And header Authorization = adminToken
    And request novoProduto
    When method POST
    Then status 201
    And def produtoId = response._id

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
    And def userToken = response.authorization

    * def carrinho = { produtos: [{ idProduto: '#(produtoId)', quantidade: 2 }] }
    Given path '/carrinhos'
    And header Authorization = userToken
    And request carrinho
    When method POST
    Then status 201

    Given path '/carrinhos/concluir-compra'
    And header Authorization = userToken
    When method DELETE
    Then status 200
    And match response.message == 'Registro excluído com sucesso'
