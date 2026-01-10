Feature: API de Login do ServeRest

  Background:
    * url baseUrl
    * def timestamp = function(){ return java.lang.System.currentTimeMillis() }
    * def gerarEmail = function(){ return 'usuario' + timestamp() + '@qa.com' }
    * def gerarNome = function(){ return 'Usuario Teste ' + timestamp() }

  Scenario: Realizar login com credenciais validas
    * def novoUsuario = { nome: '#(gerarNome())', email: '#(gerarEmail())', password: 'teste123', administrador: 'true' }
    Given path '/usuarios'
    And request novoUsuario
    When method POST
    Then status 201

    * def credenciais = { email: '#(novoUsuario.email)', password: '#(novoUsuario.password)' }
    Given path '/login'
    And request credenciais
    When method POST
    Then status 200
    And match response.message == 'Login realizado com sucesso'
    And match response.authorization == '#notnull'

  Scenario: Tentar login com email invalido
    * def credenciais = { email: 'invalido@teste.com', password: 'teste123' }
    Given path '/login'
    And request credenciais
    When method POST
    Then status 401
    And match response.message == 'Email e/ou senha inválidos'

  Scenario: Tentar login com senha incorreta
    * def novoUsuario = { nome: '#(gerarNome())', email: '#(gerarEmail())', password: 'teste123', administrador: 'false' }
    Given path '/usuarios'
    And request novoUsuario
    When method POST
    Then status 201

    * def credenciais = { email: '#(novoUsuario.email)', password: 'senhaErrada' }
    Given path '/login'
    And request credenciais
    When method POST
    Then status 401
    And match response.message == 'Email e/ou senha inválidos'

  Scenario: Tentar login sem email
    * def credenciais = { password: 'teste123' }
    Given path '/login'
    And request credenciais
    When method POST
    Then status 400
    And match response.email == 'email é obrigatório'
