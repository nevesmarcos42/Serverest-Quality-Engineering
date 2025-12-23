Feature: Carrinho de Compras
  Como cliente
  Eu quero gerenciar meu carrinho de compras
  Para que eu possa comprar produtos da loja

  Background:
    Given a API ServeRest está disponível
    And estou autenticado como usuário regular

  Scenario: Criar um carrinho de compras com um produto
    Given existe um produto com estoque suficiente
    When eu adiciono este produto ao meu carrinho com quantidade 2
    Then eu devo receber um código de status 201
    And a mensagem de resposta deve ser "Cadastro realizado com sucesso"
    And a resposta deve conter um ID de carrinho
    And o estoque do produto deve ser reduzido adequadamente

  Scenario: Criar um carrinho de compras com múltiplos produtos
    Given existem múltiplos produtos com estoque suficiente
    When eu adiciono os seguintes produtos ao meu carrinho:
      | productId  | quantity |
      | prod001    | 2        |
      | prod002    | 1        |
      | prod003    | 3        |
    Then eu devo receber um código de status 201
    And o carrinho deve conter todos os três produtos
    And o preço total deve ser calculado corretamente
    And a quantidade total deve ser 6

  Scenario: Tentar criar segundo carrinho para o mesmo usuário
    Given eu já tenho um carrinho de compras ativo
    When eu tento criar outro carrinho
    Then eu devo receber um código de status 400
    And a mensagem de resposta deve ser "Não é permitido ter mais de 1 carrinho"
    And a resposta deve incluir o ID do meu carrinho existente

  Scenario: Adicionar produto com estoque insuficiente ao carrinho
    Given existe um produto com apenas 5 unidades em estoque
    When eu tento adicionar este produto ao carrinho com quantidade 10
    Then eu devo receber um código de status 400
    And a mensagem de resposta deve ser "Produto não possui quantidade suficiente"
    And a resposta deve incluir o ID do produto

  Scenario: Adicionar produto inexistente ao carrinho
    When eu tento adicionar um produto com ID inválido "invalid123" ao carrinho
    Then eu devo receber um código de status 400
    And a mensagem de resposta deve ser "Produto não encontrado"
    And a resposta deve incluir o ID inválido do produto

  Scenario: Criar carrinho com produto no limite exato do estoque
    Given existe um produto com exatamente 10 unidades em estoque
    When eu adiciono este produto ao carrinho com quantidade 10
    Then eu devo receber um código de status 201
    And o estoque do produto deve se tornar 0

  Scenario: Criar carrinho sem autenticação
    Given eu não estou autenticado
    When eu tento criar um carrinho de compras
    Then eu devo receber um código de status 401
    And o acesso deve ser negado

  Scenario: Recuperar todos os carrinhos no sistema
    Given múltiplos usuários têm carrinhos de compras ativos
    When eu solicito a lista de todos os carrinhos
    Then eu devo receber um código de status 200
    And a resposta deve conter uma lista de carrinhos
    And cada carrinho deve incluir detalhes dos produtos e totais

  Scenario: Recuperar carrinho específico por ID
    Given existe um carrinho com ID "cart123"
    When eu solicito os detalhes do carrinho para este ID
    Then eu devo receber um código de status 200
    And a resposta deve conter informações completas do carrinho
    And a resposta deve incluir produtos, preços e quantidades

  Scenario: Recuperar carrinho com ID inexistente
    When eu solicito os detalhes do carrinho para ID "nonexistentcart"
    Then eu devo receber um código de status 400
    And a mensagem de resposta deve ser "Carrinho não encontrado"

  Scenario: Concluir compra com carrinho válido
    Given eu tenho um carrinho de compras ativo com produtos
    When eu concluo a compra
    Then eu devo receber um código de status 200
    And a mensagem de resposta deve ser "Registro excluído com sucesso"
    And o carrinho deve ser removido do sistema
    And os produtos devem ser permanentemente removidos do estoque

  Scenario: Concluir compra sem carrinho
    Given eu não tenho um carrinho de compras ativo
    When eu tento concluir uma compra
    Then eu devo receber um código de status 200
    And a mensagem de resposta deve ser "Não foi encontrado carrinho para esse usuário"

  Scenario: Cancelar compra e devolver produtos ao estoque
    Given eu tenho um carrinho de compras ativo com produtos
    And o carrinho contém Produto A com quantidade 3
    When eu cancelo a compra
    Then eu devo receber um código de status 200
    And a mensagem de resposta deve ser "Registro excluído com sucesso. Estoque dos produtos reabastecido"
    And o carrinho deve ser removido do sistema
    And o estoque do Produto A deve ser aumentado em 3

  Scenario: Cancelar compra sem carrinho
    Given eu não tenho um carrinho de compras ativo
    When eu tento cancelar uma compra
    Then eu devo receber um código de status 200
    And a mensagem de resposta deve ser "Não foi encontrado carrinho para esse usuário"

  Scenario: Verificar cálculo do preço total do carrinho
    Given eu tenho um carrinho com os seguintes produtos:
      | productName    | unitPrice | quantity |
      | Mouse Gamer    | 150       | 2        |
      | Teclado        | 300       | 1        |
    When eu recupero os detalhes do meu carrinho
    Then o preço total deve ser 600
    And a quantidade total deve ser 3

  Scenario: Criar novo carrinho após concluir compra
    Given eu tinha um carrinho e concluí a compra
    When eu crio um novo carrinho de compras
    Then eu devo receber um código de status 201
    And um novo carrinho deve ser criado com sucesso

  Scenario: Criar novo carrinho após cancelar compra
    Given eu tinha um carrinho e cancelei a compra
    When eu crio um novo carrinho de compras
    Then eu devo receber um código de status 201
    And um novo carrinho deve ser criado com sucesso

  Scenario: Carrinho persiste entre sessões do usuário
    Given eu criei um carrinho de compras em uma sessão anterior
    When eu faço login novamente e recupero meu carrinho
    Then meu carrinho ainda deve conter os mesmos produtos
    And todas as quantidades e preços devem ser preservados

  Scenario: Concluir compra sem autenticação
    Given eu não estou autenticado
    When eu tento concluir uma compra
    Then eu devo receber um código de status 401
    And o acesso deve ser negado

  Scenario: Cancelar compra sem autenticação
    Given eu não estou autenticado
    When eu tento cancelar uma compra
    Then eu devo receber um código de status 401
    And o acesso deve ser negado

  Scenario: Validação de estoque quando múltiplos usuários adicionam o mesmo produto
    Given um produto tem 10 unidades em estoque
    And o Usuário A adiciona 8 unidades ao carrinho
    When o Usuário B tenta adicionar 5 unidades ao carrinho
    Then o Usuário B deve receber um erro de estoque insuficiente
    And apenas 2 unidades devem estar disponíveis

  Scenario: Restrição de exclusão de produto quando está no carrinho
    Given eu tenho um produto no meu carrinho de compras
    When um administrador tenta excluir este produto
    Then a exclusão deve ser impedida
    And um erro deve indicar que o produto está em um carrinho
