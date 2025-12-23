Feature: Autenticação de Usuário
  Como um usuário cadastrado
  Eu quero me autenticar no sistema
  Para que eu possa acessar funcionalidades protegidas

  Background:
    Given a API ServeRest está disponível

  Scenario: Login bem-sucedido com credenciais válidas
    Given eu tenho um usuário cadastrado com email "fulano@qa.com" e senha "teste"
    When eu envio uma requisição de login com essas credenciais
    Then eu devo receber um código de status 200
    And a resposta deve conter um token de autorização válido
    And a mensagem de resposta deve ser "Login realizado com sucesso"

  Scenario: Login falho com email inválido
    When eu envio uma requisição de login com email "invalid@test.com" e senha "teste"
    Then eu devo receber um código de status 401
    And a mensagem de resposta deve ser "Email e/ou senha inválidos"
    And a resposta não deve conter um token de autorização

  Scenario: Login falho com senha inválida
    Given eu tenho um usuário cadastrado com email "fulano@qa.com"
    When eu envio uma requisição de login com email "fulano@qa.com" e senha "wrongpassword"
    Then eu devo receber um código de status 401
    And a mensagem de resposta deve ser "Email e/ou senha inválidos"

  Scenario: Login falho com email não cadastrado
    When eu envio uma requisição de login com email "notregistered@test.com" e senha "anypassword"
    Then eu devo receber um código de status 401
    And a mensagem de resposta deve ser "Email e/ou senha inválidos"

  Scenario: Tentativa de login sem email
    When eu envio uma requisição de login apenas com a senha "teste"
    Then eu devo receber um código de status 400
    And a resposta deve indicar que o email é obrigatório

  Scenario: Tentativa de login sem senha
    When eu envio uma requisição de login apenas com email "fulano@qa.com"
    Then eu devo receber um código de status 400
    And a resposta deve indicar que a senha é obrigatória

  Scenario: Tentativa de login com credenciais vazias
    When eu envio uma requisição de login com email e senha vazios
    Then eu devo receber um código de status 400
    And a resposta deve indicar erros de validação

  Scenario: Usar token de autenticação para acessar recurso protegido
    Given eu fiz login com sucesso e recebi um token
    When eu uso este token para acessar um recurso protegido
    Then eu devo conseguir acessar o recurso com sucesso

  Scenario: Acessar recurso protegido sem token de autenticação
    When eu tento acessar um recurso protegido sem autenticação
    Then eu devo receber um código de status 401
    And a resposta deve indicar que autenticação é necessária

  Scenario: Usar token de autenticação inválido
    When eu tento acessar um recurso protegido com um token inválido
    Then eu devo receber um código de status 401
    And a resposta deve indicar que o token é inválido
