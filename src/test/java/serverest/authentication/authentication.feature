Feature: Testes da API de Autenticação
  
  Background:
    * url baseUrl
    * def loginPath = '/login'
    * def testEmail = 'fulano@qa.com'
    * def testPassword = 'teste'

  Scenario: Login bem-sucedido retorna token
    Given path loginPath
    And request { email: '#(testEmail)', password: '#(testPassword)' }
    When method POST
    Then status 200
    And match response.message == 'Login realizado com sucesso'
    And match response.authorization == '#present'
    And match response.authorization == '#string'
    And match response.authorization contains 'Bearer'

  Scenario: Login com credenciais inválidas retorna 401
    Given path loginPath
    And request { email: 'invalid@test.com', password: 'wrongpass' }
    When method POST
    Then status 401
    And match response.message == 'Email e/ou senha inválidos'
    And match response.authorization == '#notpresent'

  Scenario: Login sem email retorna erro de validação
    Given path loginPath
    And request { password: 'teste' }
    When method POST
    Then status 400
    And match response.email == 'email deve ser um email válido'

  Scenario: Login sem senha retorna erro de validação
    Given path loginPath
    And request { email: '#(testEmail)' }
    When method POST
    Then status 400
    And match response.password == 'password não pode ficar em branco'

  Scenario: Login com formato de email inválido retorna erro de validação
    Given path loginPath
    And request { email: 'invalidemail', password: 'teste' }
    When method POST
    Then status 400
    And match response.email == 'email deve ser um email válido'

  Scenario: Usar token válido para acessar recurso protegido
    # Primeiro, faz login para obter o token
    Given path loginPath
    And request { email: '#(testEmail)', password: '#(testPassword)' }
    When method POST
    Then status 200
    And def authToken = response.authorization
    
    # Usa o token para criar um produto (rota apenas para admin)
    Given path '/produtos'
    And header Authorization = authToken
    And def uniqueName = 'Produto Test ' + new Date().getTime()
    And request { nome: '#(uniqueName)', preco: 100, descricao: 'Test', quantidade: 10 }
    When method POST
    Then status 201

  Scenario: Acesso a recurso protegido sem token retorna 401
    Given path '/produtos'
    And def uniqueName = 'Produto Test ' + new Date().getTime()
    And request { nome: '#(uniqueName)', preco: 100, descricao: 'Test', quantidade: 10 }
    When method POST
    Then status 401
    And match response.message == 'Token de acesso ausente, inválido, expirado ou usuário do token não existe mais'

  Scenario: Acesso a recurso protegido com token inválido retorna 401
    Given path '/produtos'
    And header Authorization = 'Bearer invalidtoken123'
    And def uniqueName = 'Produto Test ' + new Date().getTime()
    And request { nome: '#(uniqueName)', preco: 100, descricao: 'Test', quantidade: 10 }
    When method POST
    Then status 401
    And match response.message == 'Token de acesso ausente, inválido, expirado ou usuário do token não existe mais'

  Scenario: Token contém prefixo Bearer
    Given path loginPath
    And request { email: '#(testEmail)', password: '#(testPassword)' }
    When method POST
    Then status 200
    And match response.authorization == '#string'
    And assert response.authorization.startsWith('Bearer ')

  Scenario: Credenciais vazias retornam erros de validação
    Given path loginPath
    And request { email: '', password: '' }
    When method POST
    Then status 400
    And match response.email == '#present'
    And match response.password == '#present'
