Feature: Navegação e Busca de Produtos
  Como um cliente
  Eu quero navegar e buscar produtos
  Para que eu possa encontrar itens que desejo comprar

  Background:
    Given estou logado como usuário comum
    And estou na página de produtos

  Scenario: Visualizar todos os produtos disponíveis
    When a página de produtos carregar
    Then eu devo ver uma lista de produtos disponíveis
    And cada produto deve exibir nome, preço e descrição
    And cada produto deve ter um botão "Adicionar ao Carrinho"

  Scenario: Visualizar lista de produtos vazia
    Given não há produtos no sistema
    When estou na página de produtos
    Then eu devo ver uma mensagem indicando que não há produtos disponíveis

  Scenario: Buscar produtos por nome
    Given múltiplos produtos existem no catálogo
    When eu digito "Mouse" no campo de busca
    And eu realizo a busca
    Then eu devo ver apenas produtos com "Mouse" no nome
    And outros produtos devem ser filtrados

  Scenario: Busca sem resultados
    When eu busco por "NonexistentProduct123"
    Then eu devo ver uma mensagem "Nenhum produto encontrado"
    And a lista de produtos deve estar vazia

  Scenario: Limpar filtro de busca
    Given eu realizei uma busca com resultados
    When eu limpo o campo de busca
    Then todos os produtos devem ser exibidos novamente

  Scenario: Visualizar detalhes do produto
    Given um produto "Mouse Gamer" está exibido
    When eu clico no produto
    Then eu devo ver informações detalhadas sobre o produto
    And eu devo ver a descrição completa
    And eu devo ver a quantidade disponível

  Scenario: Ordenar produtos por preço - crescente
    Given múltiplos produtos com preços diferentes estão exibidos
    When eu seleciono ordenação "Preço: Menor para Maior"
    Then os produtos devem ser exibidos do menor para o maior preço

  Scenario: Ordenar produtos por preço - decrescente
    Given múltiplos produtos com preços diferentes estão exibidos
    When eu seleciono ordenação "Preço: Maior para Menor"
    Then os produtos devem ser exibidos do maior para o menor preço

  Scenario: Ordenar produtos por nome
    Given múltiplos produtos estão exibidos
    When eu seleciono ordenação "Nome: A-Z"
    Then os produtos devem ser exibidos em ordem alfabética

  Scenario: Filtrar produtos por faixa de preço
    Given produtos existem com vários preços
    When eu defino um filtro de preço de 100 a 500
    Then eu devo ver apenas produtos dentro dessa faixa de preço

  Scenario: Indicação de disponibilidade do produto
    Given um produto tem 0 unidades em estoque
    When eu visualizo este produto
    Then ele deve ser marcado como "Fora de Estoque"
    And o botão "Adicionar ao Carrinho" deve estar desabilitado

  Scenario: Indicação de disponibilidade para estoque baixo
    Given um produto tem menos de 10 unidades em estoque
    When eu visualizo este produto
    Then ele deve exibir um aviso de "Estoque Limitado"

  Scenario: Paginação quando há muitos produtos
    Given mais de 20 produtos existem no catálogo
    When estou na página de produtos
    Then os produtos devem estar paginados
    And eu devo ver controles de navegação de páginas
    And eu devo conseguir navegar para a próxima página

  Scenario: Seleção de produtos por página
    When eu altero a configuração "Produtos por página" para 50
    Then até 50 produtos devem ser exibidos na página

  Scenario: Atualizar lista de produtos
    When eu atualizo a página
    Then a lista de produtos deve recarregar
    And as informações mais atuais dos produtos devem ser exibidas

  Scenario: Visualizar produtos adicionados recentemente
    Given novos produtos foram adicionados recentemente ao catálogo
    When eu seleciono o filtro "Adicionados Recentemente"
    Then os produtos mais novos devem ser exibidos primeiro
