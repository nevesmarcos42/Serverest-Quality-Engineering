Feature: API de Usuarios do ServeRest

  Background:
    * url baseUrl
    * def timestamp = function(){ return java.lang.System.currentTimeMillis() }
    * def gerarEmail = function(){ return 'usuario' + timestamp() + '@qa.com' }
    * def gerarNome = function(){ return 'Usuario Teste ' + timestamp() }

  Scenario: Listar todos os usuarios
    Given path '/usuarios'
    When method GET
    Then status 200
    And match response.usuarios == '#array'
    And match response.quantidade == '#number'

  Scenario: Buscar usuario por ID existente
    * def novoUsuario = { nome: '#(gerarNome())', email: '#(gerarEmail())', password: 'teste123', administrador: 'true' }
    Given path '/usuarios'
    And request novoUsuario
    When method POST
    Then status 201
    And def userId = response._id

    Given path '/usuarios', userId
    When method GET
    Then status 200
    And match response.nome == novoUsuario.nome
    And match response.email == novoUsuario.email

  Scenario: Cadastrar novo usuario com sucesso
    * def novoUsuario = { nome: '#(gerarNome())', email: '#(gerarEmail())', password: 'teste123', administrador: 'true' }
    Given path '/usuarios'
    And request novoUsuario
    When method POST
    Then status 201
    And match response.message == 'Cadastro realizado com sucesso'
    And match response._id == '#notnull'

  Scenario: Tentar cadastrar usuario com email duplicado
    * def emailDuplicado = gerarEmail()
    * def usuario1 = { nome: '#(gerarNome())', email: '#(emailDuplicado)', password: 'teste123', administrador: 'false' }
    
    Given path '/usuarios'
    And request usuario1
    When method POST
    Then status 201

    Given path '/usuarios'
    And request usuario1
    When method POST
    Then status 400
    And match response.message == 'Este email já está sendo usado'

  Scenario: Excluir usuario existente
    * def novoUsuario = { nome: '#(gerarNome())', email: '#(gerarEmail())', password: 'teste123', administrador: 'false' }
    Given path '/usuarios'
    And request novoUsuario
    When method POST
    Then status 201
    And def userId = response._id

    Given path '/usuarios', userId
    When method DELETE
    Then status 200
    And match response.message contains 'excluído'

  Scenario: Atualizar usuario existente
    * def novoUsuario = { nome: '#(gerarNome())', email: '#(gerarEmail())', password: 'teste123', administrador: 'false' }
    Given path '/usuarios'
    And request novoUsuario
    When method POST
    Then status 201
    And def userId = response._id

    * def usuarioAtualizado = { nome: 'Nome Atualizado', email: '#(gerarEmail())', password: 'senha456', administrador: 'true' }
    Given path '/usuarios', userId
    And request usuarioAtualizado
    When method PUT
    Then status 200
    And match response.message == 'Registro alterado com sucesso'
