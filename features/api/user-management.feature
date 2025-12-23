Feature: Gerenciamento de Usuários
  Como administrador
  Eu quero gerenciar contas de usuário
  Para que eu possa controlar o acesso ao sistema e manter os dados dos usuários

  Background:
    Given a API ServeRest está disponível

  Scenario: Criar um novo usuário regular
    When eu crio um novo usuário com os seguintes dados:
      | nome          | João da Silva           |
      | email         | joao.silva@test.com     |
      | password      | senha123                |
      | administrador | false                   |
    Then eu devo receber um código de status 201
    And a mensagem de resposta deve ser "Cadastro realizado com sucesso"
    And a resposta deve conter um ID de usuário

  Scenario: Criar um novo usuário administrador
    When eu crio um novo usuário com privilégios de administrador
    Then eu devo receber um código de status 201
    And o usuário deve ser criado com a flag de administrador definida como true

  Scenario: Tentar criar usuário com email duplicado
    Given existe um usuário com email "existing@test.com"
    When eu tento criar outro usuário com email "existing@test.com"
    Then eu devo receber um código de status 400
    And a mensagem de resposta deve ser "Este email já está sendo usado"

  Scenario: Criar usuário com campo obrigatório faltando - nome
    When eu tento criar um usuário sem fornecer um nome
    Then eu devo receber um código de status 400
    And a resposta deve indicar que o nome é obrigatório

  Scenario: Criar usuário com campo obrigatório faltando - email
    When eu tento criar um usuário sem fornecer um email
    Then eu devo receber um código de status 400
    And a resposta deve indicar que o email é obrigatório

  Scenario: Criar usuário com formato de email inválido
    When eu tento criar um usuário com email "invalidemail"
    Then eu devo receber um código de status 400
    And a resposta deve indicar formato de email inválido

  Scenario: Recuperar todos os usuários
    Given existem múltiplos usuários no sistema
    When eu solicito a lista de todos os usuários
    Then eu devo receber um código de status 200
    And a resposta deve conter uma lista de usuários
    And a resposta deve incluir a contagem total de usuários

  Scenario: Recuperar usuário específico por ID
    Given existe um usuário com ID "BXzJTQAoAn2zFVXh"
    When eu solicito os detalhes do usuário para este ID
    Then eu devo receber um código de status 200
    And a resposta deve conter as informações completas do usuário

  Scenario: Recuperar usuário com ID inexistente
    When eu solicito os detalhes do usuário para ID "nonexistent123"
    Then eu devo receber um código de status 400
    And a mensagem de resposta deve ser "Usuário não encontrado"

  Scenario: Filtrar usuários por nome
    Given existem múltiplos usuários com nomes diferentes
    When eu busco por usuários com nome contendo "Silva"
    Then eu devo receber um código de status 200
    And todos os usuários retornados devem ter "Silva" em seus nomes

  Scenario: Filtrar usuários por status de administrador
    Given existem tanto usuários regulares quanto administradores
    When eu filtro usuários por status de administrador "true"
    Then eu devo receber um código de status 200
    And todos os usuários retornados devem ser administradores

  Scenario: Atualizar informações de usuário existente
    Given estou autenticado como administrador
    And existe um usuário com ID "abc123"
    When eu atualizo o nome deste usuário para "Maria Santos"
    Then eu devo receber um código de status 200
    And a mensagem de resposta deve ser "Registro alterado com sucesso"

  Scenario: Atualizar usuário com novo email já em uso
    Given estou autenticado como administrador
    And existem dois usuários com emails "user1@test.com" e "user2@test.com"
    When eu tento atualizar o email do user1 para "user2@test.com"
    Then eu devo receber um código de status 400
    And a mensagem de resposta deve ser "Este email já está sendo usado"

  Scenario: Atualizar usuário inexistente cria novo usuário
    Given estou autenticado como administrador
    When eu tento atualizar um usuário com ID inexistente "newuser123"
    Then eu devo receber um código de status 201
    And a mensagem de resposta deve ser "Cadastro realizado com sucesso"

  Scenario: Excluir usuário existente
    Given estou autenticado como administrador
    And existe um usuário sem nenhum carrinho ativo
    When eu excluo este usuário
    Then eu devo receber um código de status 200
    And a mensagem de resposta deve ser "Registro excluído com sucesso"

  Scenario: Tentar excluir usuário com carrinho ativo
    Given estou autenticado como administrador
    And existe um usuário com um carrinho de compras ativo
    When eu tento excluir este usuário
    Then eu devo receber um código de status 400
    And a mensagem de resposta deve indicar que o usuário tem um carrinho ativo
    And a resposta deve incluir o ID do carrinho

  Scenario: Excluir usuário inexistente
    Given estou autenticado como administrador
    When eu tento excluir um usuário com ID "nonexistent456"
    Then eu devo receber um código de status 400
    And a mensagem de resposta deve ser "Nenhum registro excluído"

  Scenario: Usuário não autorizado tenta atualizar outro usuário
    Given estou autenticado como usuário regular
    When eu tento atualizar as informações de outro usuário
    Then eu devo receber um código de status 401
    And o acesso deve ser negado

  Scenario: Usuário não autorizado tenta excluir um usuário
    Given estou autenticado como usuário regular
    When eu tento excluir outro usuário
    Then eu devo receber um código de status 401
    And o acesso deve ser negado
