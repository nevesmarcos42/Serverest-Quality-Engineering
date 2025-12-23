Feature: Carrinho de Compras e Finalização de Compra
  Como um cliente
  Eu quero adicionar produtos ao meu carrinho e finalizar compras
  Para que eu possa comprar itens da loja

  Background:
    Given estou logado como usuário comum
    And estou na página de produtos

  Scenario: Adicionar um único produto ao carrinho
    Given um produto "Mouse Gamer" está disponível
    When eu clico em "Adicionar ao Carrinho" para este produto
    Then eu devo ver uma mensagem de confirmação
    And o ícone do carrinho deve mostrar 1 item
    And o produto deve aparecer no meu carrinho

  Scenario: Adicionar múltiplos produtos diferentes ao carrinho
    When eu adiciono "Mouse Gamer" ao carrinho
    And eu adiciono "Teclado Mecânico" ao carrinho
    And eu adiciono "Headset" ao carrinho
    Then o carrinho deve conter 3 produtos diferentes
    And o ícone do carrinho deve refletir a contagem total

  Scenario: Adicionar o mesmo produto múltiplas vezes
    Given "Mouse Gamer" está no meu carrinho com quantidade 1
    When eu adiciono "Mouse Gamer" ao carrinho novamente
    Then o carrinho deve mostrar quantidade 2 para "Mouse Gamer"
    And o preço total deve ser atualizado adequadamente

  Scenario: Visualizar conteúdo do carrinho
    Given eu tenho produtos no meu carrinho
    When eu clico no ícone do carrinho
    Then eu devo ver a página do carrinho
    And eu devo ver todos os produtos que adicionei
    And cada produto deve mostrar nome, quantidade, preço unitário e subtotal
    And eu devo ver o preço total de todos os itens

  Scenario: Visualizar carrinho vazio
    Given meu carrinho está vazio
    When eu navego para a página do carrinho
    Then eu devo ver uma mensagem "Carrinho vazio"
    And eu não devo ver um botão de finalizar compra

  Scenario: Atualizar quantidade do produto no carrinho
    Given "Mouse Gamer" está no meu carrinho com quantidade 2
    When eu altero a quantidade para 5
    Then a quantidade deve ser atualizada para 5
    And o subtotal deve ser recalculado
    And o preço total deve ser atualizado

  Scenario: Remover produto do carrinho
    Given "Mouse Gamer" está no meu carrinho
    When eu clico no botão remover para este produto
    Then "Mouse Gamer" deve ser removido do carrinho
    And o preço total deve ser recalculado
    And se o carrinho estiver vazio, eu devo ver mensagem de carrinho vazio

  Scenario: Tentar adicionar produto com estoque insuficiente
    Given um produto tem apenas 3 unidades em estoque
    And eu já tenho 3 unidades no meu carrinho
    When eu tento adicionar mais unidades
    Then eu devo ver um erro de "Estoque insuficiente"
    And a quantidade no carrinho deve permanecer 3

  Scenario: Carrinho atualiza quando estoque do produto muda
    Given eu tenho um produto no meu carrinho
    And o estoque do produto se torna 0 enquanto estou comprando
    When eu tento finalizar a compra
    Then eu devo ser notificado sobre o problema de estoque
    And eu não devo conseguir completar a compra

  Scenario: Calcular total do carrinho com múltiplos produtos
    Given eu tenho os seguintes produtos no carrinho:
      | Produto         | Quantidade | Preço Unitário |
      | Mouse Gamer     | 2          | 150             |
      | Teclado         | 1          | 300             |
      | Headset         | 3          | 200             |
    Then o total do carrinho deve ser 1200

  Scenario: Finalizar compra com carrinho válido
    Given eu tenho produtos no meu carrinho
    When eu clico no botão "Concluir Compra"
    Then eu devo ver uma mensagem de confirmação de compra
    And meu carrinho deve ser esvaziado
    And eu devo poder criar um novo carrinho

  Scenario: Cancelar compra e voltar às compras
    Given estou na página do carrinho com produtos
    When eu clico no botão "Cancelar Compra"
    Then eu devo ver uma confirmação de cancelamento
    And meu carrinho deve ser esvaziado
    And o estoque dos produtos deve ser restaurado

  Scenario: Continuar comprando da página do carrinho
    Given estou visualizando meu carrinho
    When eu clico em "Continuar Comprando"
    Then eu devo ser redirecionado para a página de produtos
    And o conteúdo do meu carrinho deve ser preservado

  Scenario: Badge do carrinho atualiza em tempo real
    Given the cart is empty and shows 0
    When I add a product to cart
    Then the cart badge should immediately update
    And it should show the correct item count

  Scenario: Cart persists across page navigation
    Given I add "Mouse Gamer" to my cart
    When eu navego para diferentes páginas
    And eu retorno para o carrinho
    Then "Mouse Gamer" ainda deve estar no meu carrinho

  Scenario: Múltiplos usuários não podem compartilhar carrinhos
    Given estou logado como Usuário A
    And eu tenho produtos no meu carrinho
    When eu faço logout e login como Usuário B
    Then eu não devo ver o carrinho do Usuário A
    And eu devo ter um carrinho vazio

  Scenario: Limite do carrinho - máximo de produtos
    Given eu adicionei 10 produtos diferentes ao carrinho
    When o carrinho atingir a capacidade máxima
    Then eu devo ser notificado sobre o limite
    And eu não devo conseguir adicionar mais produtos diferentes

  Scenario: Precisão na exibição de preços
    Given os produtos têm preços com decimais
    When eu os adiciono ao carrinho
    Then todos os preços devem ser exibidos com 2 casas decimais
    And o total deve ser calculado com precisão

  Scenario: Esvaziar carrinho após compra bem-sucedida
    Given eu completei uma compra
    When eu navego para a página do carrinho
    Then o carrinho deve estar vazio
    And eu devo ver uma experiência de compra renovada

  Scenario: Botão de finalizar compra visível apenas com itens no carrinho
    Given meu carrinho está vazio
    Then o botão de finalizar compra não deve estar visível
    When eu adiciono um produto ao carrinho
    Then o botão de finalizar compra deve ficar visível
