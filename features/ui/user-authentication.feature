Feature: Registro e Login de Usuário
  Como um novo usuário
  Eu quero me registrar e fazer login no sistema
  Para que eu possa acessar os recursos da loja

  Background:
    Given estou na página inicial do ServeRest

  Scenario: Registrar uma nova conta de usuário
    When eu clico no link de registro
    And eu preencho o formulário de registro com:
      | Nome     | João da Silva         |
      | Email    | joao@test.com         |
      | Senha    | senha123              |
    And eu não marco a caixa de seleção de administrador
    And eu envio o formulário de registro
    Then eu devo ver uma mensagem de sucesso
    And eu devo ser redirecionado para a página de produtos
    And eu devo ver meu nome no cabeçalho

  Scenario: Registrar como administrador
    When eu clico no link de registro
    And eu preencho o formulário de registro com dados válidos
    And eu marco a caixa de seleção de administrador
    And eu envio o formulário de registro
    Then eu devo ser registrado como administrador
    And eu devo ter acesso aos recursos administrativos

  Scenario: Tentar registrar com email já existente
    Given já existe um usuário com o email "existing@test.com"
    When eu tento me registrar com o email "existing@test.com"
    Then eu devo ver uma mensagem de erro "Este email já está sendo usado"
    And eu devo permanecer na página de registro

  Scenario: Registrar com formato de email inválido
    When eu clico no link de registro
    And eu digito "invalidemail" no campo de email
    And eu preencho os outros campos obrigatórios
    And eu envio o formulário de registro
    Then eu devo ver um erro de validação de formato de email

  Scenario: Registrar com campos obrigatórios faltando
    When eu clico no link de registro
    And eu deixo o campo de nome vazio
    And eu envio o formulário de registro
    Then eu devo ver erros de validação para campos obrigatórios
    And o formulário não deve ser enviado

  Scenario: Login com credenciais válidas
    Given eu tenho uma conta registrada com email "user@test.com" e senha "senha123"
    When eu navego para a página de login
    And eu digito meu email e senha
    And eu clico no botão de login
    Then eu devo fazer login com sucesso
    And eu devo ser redirecionado para a página de produtos
    And eu devo ver meu nome exibido no cabeçalho

  Scenario: Login com senha inválida
    Given eu tenho uma conta registrada com email "user@test.com"
    When eu navego para a página de login
    And eu digito email "user@test.com" e senha "wrongpassword"
    And eu clico no botão de login
    Then eu devo ver uma mensagem de erro "Email e/ou senha inválidos"
    And eu devo permanecer na página de login

  Scenario: Login com email não registrado
    When eu navego para a página de login
    And eu digito email "notregistered@test.com" e qualquer senha
    And eu clico no botão de login
    Then eu devo ver uma mensagem de erro "Email e/ou senha inválidos"

  Scenario: Login com credenciais vazias
    When eu navego para a página de login
    And eu deixo os campos de email e senha vazios
    And eu clico no botão de login
    Then eu devo ver erros de validação
    And o formulário não deve ser enviado

  Scenario: Logout do sistema
    Given estou logado como "user@test.com"
    When eu clico no botão de logout
    Then eu devo fazer logout com sucesso
    And eu devo ser redirecionado para a página de login
    And minha sessão deve ser encerrada

  Scenario: Navegar para registro a partir da página de login
    When estou na página de login
    And eu clico no link "Registrar"
    Then eu devo ser redirecionado para a página de registro

  Scenario: Navegar para login a partir da página de registro
    When estou na página de registro
    And eu clico no link "Já tem uma conta"
    Then eu devo ser redirecionado para a página de login

  Scenario: Persistência de sessão após recarregar a página
    Given estou logado
    When eu recarrego a página
    Then eu devo permanecer logado
    And minha sessão deve ser preservada

  Scenario: Acessar página protegida sem autenticação
    When eu tento acessar a página de produtos sem fazer login
    Then eu devo ser redirecionado para a página de login
