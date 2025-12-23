Feature: Gerenciamento de Produtos
  Como administrador
  Eu quero gerenciar o catálogo de produtos
  Para que os clientes possam navegar e comprar itens disponíveis

  Background:
    Given a API ServeRest está disponível
    And estou autenticado como administrador

  Scenario: Criar um novo produto
    When eu crio um novo produto com os seguintes detalhes:
      | nome       | Mouse Gamer RGB            |
      | preco      | 150                        |
      | descricao  | Mouse ergonômico com LED   |
      | quantidade | 50                         |
    Then eu devo receber um código de status 201
    And a mensagem de resposta deve ser "Cadastro realizado com sucesso"
    And a resposta deve conter um ID de produto

  Scenario: Criar produto com nome duplicado
    Given existe um produto com nome "Teclado Mecânico"
    When eu tento criar outro produto com nome "Teclado Mecânico"
    Then eu devo receber um código de status 400
    And a mensagem de resposta deve ser "Já existe produto com esse nome"

  Scenario: Criar produto com campo obrigatório faltando - nome
    When eu tento criar um produto sem fornecer um nome
    Then eu devo receber um código de status 400
    And a resposta deve indicar que o nome é obrigatório

  Scenario: Criar produto com campo obrigatório faltando - preço
    When eu tento criar um produto sem fornecer um preço
    Then eu devo receber um código de status 400
    And a resposta deve indicar que o preço é obrigatório

  Scenario: Criar produto com preço inválido - valor negativo
    When eu tento criar um produto com preço -10
    Then eu devo receber um código de status 400
    And a resposta deve indicar valor de preço inválido

  Scenario: Criar produto com quantidade zero
    When eu crio um produto com quantidade 0
    Then eu devo receber um código de status 201
    And o produto deve ser criado com quantidade 0

  Scenario: Usuário não-admin tenta criar produto
    Given estou autenticado como usuário regular
    When eu tento criar um novo produto
    Then eu devo receber um código de status 401
    And a mensagem de resposta deve ser "Rota exclusiva para administradores"

  Scenario: Usuário não autenticado tenta criar produto
    Given eu não estou autenticado
    When eu tento criar um novo produto
    Then eu devo receber um código de status 401
    And o acesso deve ser negado

  Scenario: Recuperar todos os produtos
    Given existem múltiplos produtos no catálogo
    When eu solicito a lista de todos os produtos
    Then eu devo receber um código de status 200
    And a resposta deve conter uma lista de produtos
    And a resposta deve incluir a contagem total de produtos

  Scenario: Recuperar produto específico por ID
    Given existe um produto com ID "BeeJh5lz3k6kSIzA"
    When eu solicito os detalhes do produto para este ID
    Then eu devo receber um código de status 200
    And a resposta deve conter as informações completas do produto

  Scenario: Recuperar produto com ID inexistente
    When eu solicito os detalhes do produto para ID "invalidproduct999"
    Then eu devo receber um código de status 400
    And a mensagem de resposta deve ser "Produto não encontrado"

  Scenario: Filtrar produtos por nome
    Given existem múltiplos produtos com nomes diferentes
    When eu busco por produtos com nome contendo "Mouse"
    Then eu devo receber um código de status 200
    And todos os produtos retornados devem ter "Mouse" em seus nomes

  Scenario: Filtrar produtos por preço
    Given existem múltiplos produtos com preços diferentes
    When eu filtro produtos por preço exato 150
    Then eu devo receber um código de status 200
    And todos os produtos retornados devem ter preço 150

  Scenario: Filtrar produtos por descrição
    Given existem múltiplos produtos com descrições diferentes
    When eu busco por produtos com descrição contendo "Gamer"
    Then eu devo receber um código de status 200
    And todos os produtos retornados devem ter "Gamer" em suas descrições

  Scenario: Atualizar informações de produto existente
    Given existe um produto com ID "abc123"
    When eu atualizo o nome deste produto para "Mouse Óptico Premium"
    Then eu devo receber um código de status 200
    And a mensagem de resposta deve ser "Registro alterado com sucesso"

  Scenario: Atualizar produto com nome já em uso
    Given existem dois produtos com nomes "Product A" e "Product B"
    When eu tento atualizar o nome de "Product A" para "Product B"
    Then eu devo receber um código de status 400
    And a mensagem de resposta deve ser "Já existe produto com esse nome"

  Scenario: Atualizar quantidade em estoque do produto
    Given existe um produto com quantidade 100
    When eu atualizo a quantidade deste produto para 150
    Then eu devo receber um código de status 200
    And a quantidade do produto deve ser atualizada para 150

  Scenario: Atualizar produto inexistente cria novo produto
    When eu tento atualizar um produto com ID inexistente "newprod789"
    Then eu devo receber um código de status 201
    And a mensagem de resposta deve ser "Cadastro realizado com sucesso"

  Scenario: Usuário não-admin tenta atualizar produto
    Given estou autenticado como usuário regular
    When eu tento atualizar um produto
    Then eu devo receber um código de status 401
    And a mensagem de resposta deve ser "Rota exclusiva para administradores"

  Scenario: Excluir produto existente
    Given existe um produto que não está em nenhum carrinho
    When eu excluo este produto
    Then eu devo receber um código de status 200
    And a mensagem de resposta deve ser "Registro excluído com sucesso"

  Scenario: Tentar excluir produto que está em um carrinho
    Given existe um produto em um carrinho de compras ativo
    When eu tento excluir este produto
    Then eu devo receber um código de status 400
    And a mensagem de resposta deve indicar que o produto está em um carrinho
    And a resposta deve incluir o ID do carrinho

  Scenario: Excluir produto inexistente
    When eu tento excluir um produto com ID "nonexistent789"
    Then eu devo receber um código de status 400
    And a mensagem de resposta deve ser "Nenhum registro excluído"

  Scenario: Usuário não-admin tenta excluir produto
    Given estou autenticado como usuário regular
    When eu tento excluir um produto
    Then eu devo receber um código de status 401
    And a mensagem de resposta deve ser "Rota exclusiva para administradores"

  Scenario: Criar produto com descrição muito longa
    When eu crio um produto com descrição maior que 1000 caracteres
    Then o sistema deve lidar com isso adequadamente
    And o produto deve ser criado ou erro de validação retornado

  Scenario: Buscar produtos sem resultados
    When eu busco por produtos com nome "NonexistentProduct123"
    Then eu devo receber um código de status 200
    And a resposta deve conter uma lista vazia de produtos
    And a quantidade deve ser 0
