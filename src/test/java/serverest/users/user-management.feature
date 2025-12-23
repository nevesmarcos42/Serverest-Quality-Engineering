Feature: Testes da API de Gerenciamento de Usuários
  
  Background:
    * url baseUrl
    * def usersPath = '/usuarios'
    * def utils = call read('classpath:serverest/helpers/utils.js')

  Scenario: Criar usuário comum com sucesso
    * def uniqueEmail = utils.generateEmail()
    * def userData = 
    """
    {
      nome: 'João Silva',
      email: '#(uniqueEmail)',
      password: 'senha123',
      administrador: 'false'
    }
    """
    Given path usersPath
    And request userData
    When method POST
    Then status 201
    And match response.message == 'Cadastro realizado com sucesso'
    And match response._id == '#present'
    And match response._id == '#string'

  Scenario: Criar usuário administrador com sucesso
    * def uniqueEmail = utils.generateEmail()
    * def userData = 
    """
    {
      nome: 'Admin User',
      email: '#(uniqueEmail)',
      password: 'admin123',
      administrador: 'true'
    }
    """
    Given path usersPath
    And request userData
    When method POST
    Then status 201
    And match response.message == 'Cadastro realizado com sucesso'

  Scenario: Não pode criar usuário com email duplicado
    * def uniqueEmail = utils.generateEmail()
    * def userData = { nome: 'Test User', email: '#(uniqueEmail)', password: 'test', administrador: 'false' }
    
    # Cria o primeiro usuário
    Given path usersPath
    And request userData
    When method POST
    Then status 201
    
    # Tenta criar segundo usuário com o mesmo email
    Given path usersPath
    And request userData
    When method POST
    Then status 400
    And match response.message == 'Este email já está sendo usado'

  Scenario: Criar usuário sem nome retorna erro de validação
    * def uniqueEmail = utils.generateEmail()
    Given path usersPath
    And request { email: '#(uniqueEmail)', password: 'test', administrador: 'false' }
    When method POST
    Then status 400
    And match response.nome == 'nome não pode ficar em branco'

  Scenario: Criar usuário sem email retorna erro de validação
    Given path usersPath
    And request { nome: 'Test User', password: 'test', administrador: 'false' }
    When method POST
    Then status 400
    And match response.email == 'email não pode ficar em branco'

  Scenario: Criar usuário com formato de email inválido
    Given path usersPath
    And request { nome: 'Test', email: 'invalidemail', password: 'test', administrador: 'false' }
    When method POST
    Then status 400
    And match response.email == 'email deve ser um email válido'

  Scenario: Criar usuário sem senha retorna erro de validação
    * def uniqueEmail = utils.generateEmail()
    Given path usersPath
    And request { nome: 'Test', email: '#(uniqueEmail)', administrador: 'false' }
    When method POST
    Then status 400
    And match response.password == 'password não pode ficar em branco'

  Scenario: Listar todos os usuários
    Given path usersPath
    When method GET
    Then status 200
    And match response.quantidade == '#number'
    And match response.usuarios == '#array'

  Scenario: Buscar usuário por ID
    # Primeiro cria um usuário
    * def testUser = utils.createTestUser(false)
    
    # Busca usuário por ID
    Given path usersPath + '/' + testUser._id
    When method GET
    Then status 200
    And match response._id == testUser._id
    And match response.nome == testUser.nome
    And match response.email == testUser.email

  Scenario: Buscar usuário com ID inexistente
    Given path usersPath + '/nonexistentid123'
    When method GET
    Then status 400
    And match response.message == 'Usuário não encontrado'

  Scenario: Filtrar usuários por nome
    * def testUser = utils.createTestUser(false)
    * def searchName = testUser.nome.split(' ')[0]
    
    Given path usersPath
    And param nome = searchName
    When method GET
    Then status 200
    And match response.quantidade == '#number'
    And match response.usuarios == '#array'

  Scenario: Filtrar usuários por status de administrador
    Given path usersPath
    And param administrador = 'true'
    When method GET
    Then status 200
    And match response.quantidade == '#number'
    And match each response.usuarios[*].administrador == 'true'

  Scenario: Atualizar informações do usuário
    # Cria usuário e obtém token
    * def admin = utils.createAdminAndGetToken()
    * def testUser = utils.createTestUser(false)
    
    # Atualiza usuário
    * def updatedData = { nome: 'Updated Name', email: testUser.email, password: 'newpass', administrador: 'false' }
    Given path usersPath + '/' + testUser._id
    And header Authorization = admin.token
    And request updatedData
    When method PUT
    Then status 200
    And match response.message == 'Registro alterado com sucesso'

  Scenario: Atualizar usuário inexistente cria novo usuário
    * def admin = utils.createAdminAndGetToken()
    * def uniqueEmail = utils.generateEmail()
    * def userData = { nome: 'New User', email: '#(uniqueEmail)', password: 'test', administrador: 'false' }
    
    Given path usersPath + '/newuserid123'
    And header Authorization = admin.token
    And request userData
    When method PUT
    Then status 201
    And match response.message == 'Cadastro realizado com sucesso'

  Scenario: Não pode atualizar usuário para usar email existente
    * def admin = utils.createAdminAndGetToken()
    * def user1 = utils.createTestUser(false)
    * def user2 = utils.createTestUser(false)
    
    * def updateData = { nome: user1.nome, email: user2.email, password: 'test', administrador: 'false' }
    Given path usersPath + '/' + user1._id
    And header Authorization = admin.token
    And request updateData
    When method PUT
    Then status 400
    And match response.message == 'Este email já está sendo usado'

  Scenario: Deletar usuário com sucesso
    * def admin = utils.createAdminAndGetToken()
    * def testUser = utils.createTestUser(false)
    
    Given path usersPath + '/' + testUser._id
    And header Authorization = admin.token
    When method DELETE
    Then status 200
    And match response.message == 'Registro excluído com sucesso'

  Scenario: Deletar usuário inexistente
    * def admin = utils.createAdminAndGetToken()
    
    Given path usersPath + '/nonexistentuser'
    And header Authorization = admin.token
    When method DELETE
    Then status 200
    And match response.message == 'Nenhum registro excluído'

  Scenario: Não pode deletar usuário com carrinho ativo
    # Este cenário requer criação de carrinho que será testada nos testes de carrinho
    # Documentando comportamento esperado: deve retornar 400 com ID do carrinho
    * print 'Deleção de usuário com carrinho testada em cenários de integração'
