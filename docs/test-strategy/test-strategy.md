# Estratégia de Testes - ServeRest

## Propósito

Este documento delineia a estratégia de testes para a aplicação ServeRest, definindo escopo, abordagem e justificativa para decisões de automação de testes.

## Contexto da Aplicação

**ServeRest** é uma API REST com frontend web projetada para educação em testes. Fornece:

- Registro e autenticação de usuários
- Gerenciamento de catálogo de produtos
- Funcionalidade de carrinho de compras
- Operações administrativas

**Base URL:** https://serverest.dev/

## Objetivos dos Testes

1. Validar regras de negócio e integridade de dados
2. Garantir conformidade com contrato da API
3. Verificar jornadas críticas do usuário
4. Detectar regressão no início do ciclo de desenvolvimento
5. Fornecer feedback rápido sobre mudanças no código

## Test Pyramid Strategy

```
              /\
             /  \
            / UI \
           /------\
          /  API   \
         /----------\
        /    Unit    \
       /--------------\
```

### Distribution Rationale

- **Unit Tests:** 70% (not in scope - application responsibility)
- **API Tests:** 25% (primary focus of this project)
- **UI Tests:** 5% (critical paths only)

### Why API-First Approach?

1. **Faster execution** - API tests run 10-50x faster than UI
2. **Better isolation** - Direct business logic validation
3. **Easier maintenance** - Less brittle than UI selectors
4. **Earlier detection** - Catch issues before UI layer
5. **Comprehensive coverage** - Test edge cases difficult via UI

## Níveis de Teste

### Testes de API (Primário)

**Escopo:**

- Todas as operações CRUD para usuários, produtos, carrinhos
- Fluxos de autenticação e autorização
- Validação de entrada e tratamento de erros
- Validação de contrato de resposta
- Códigos de status HTTP e cabeçalhos

**Não Testado:**

- Internos do banco de dados (abordagem caixa preta)
- Infraestrutura do servidor
- Integrações com terceiros (não existem)

**Ferramentas:**

- **Karate DSL** - Suíte de regressão automatizada
- **Postman** - Testes exploratórios e validação inicial

### Testes de UI (Caminhos Críticos)

**Escopo:**

- Registro e login de usuário
- Listagem e busca de produtos
- Adicionar ao carrinho e comprar
- Gerenciamento de usuários admin

**Não Testado:**

- Regressão visual (não crítico para este app)
- Acessibilidade (importante mas fora do escopo)
- Cross-browser (testando apenas no Chrome)
- Detalhes de design responsivo

**Ferramenta:**

- **Cypress** - Framework E2E baseado em JavaScript

## Abordagem de Design de Testes

### Especificações BDD

Todos os cenários de teste começam como features Gherkin usando linguagem de negócio:

- Escritos da perspectiva do usuário
- Foco em comportamento, não implementação
- Servem como documentação viva
- Revisados por stakeholders técnicos e de negócio

### Testes Orientados a Dados

Testes de API usam fontes de dados externas para:

- Múltiplas personas de usuário (admin, usuário regular)
- Combinações de entrada válidas e inválidas
- Testes de valor limite

### Independência de Testes

Cada teste deve:

- Criar seus próprios dados de teste
- Limpar após execução
- Executar em qualquer ordem
- Não depender de outros testes

## Testes Baseados em Risco

### High Risk Areas (Priority 1)

1. **Authentication** - Security critical
2. **Cart calculations** - Business logic
3. **User permissions** - Authorization rules

### Medium Risk (Priority 2)

4. **Product search** - User experience
5. **Data validation** - Input handling

### Low Risk (Priority 3)

6. **UI layout** - Visual aspects
7. **Error messages** - UX polish

## Ambiente de Testes

**Ambiente:** Servidor de teste similar à produção (https://serverest.dev/)

**Restrições:**

- Ambiente compartilhado com outros testadores
- Persistência de dados é temporária
- Limitação de taxa pode ser aplicada

**Abordagem:**

- Usar identificadores únicos nos dados de teste
- Implementar lógica de retry para operações instáveis
- Limpar dados de teste quando possível

## Critérios de Sucesso

1. **Cobertura:** Todos os endpoints críticos da API automatizados
2. **Estabilidade:** <2% de taxa de testes instáveis
3. **Performance:** Suíte completa executa em menos de 5 minutos
4. **Manutenibilidade:** Novos testes adicionados sem mudanças no framework

## Fora do Escopo

- Performance/load testing
- Security penetration testing
- Mobile app testing (no mobile version)
- Localization testing (single language)

## Test Execution Strategy

### Local Development

- Developers run affected tests before commit
- Quick smoke suite (<1 min) on demand

### CI Pipeline

- Full API suite on every PR
- UI tests on merge to main
- Nightly full regression

## Relatórios

Resultados dos testes incluem:

- Status pass/fail com timestamps
- Logs detalhados de falhas
- Amostras de resposta da API
- Screenshots para falhas de UI
- Análise de tendência ao longo do tempo

## Plano de Manutenção

**Semanal:**

- Revisar testes que falharam
- Atualizar dados de teste conforme necessário
- Refatorar código duplicado

**Mensal:**

- Analisar lacunas de cobertura
- Atualizar documentação
- Revisar e remover testes obsoletos

## Aprovação

Esta estratégia está alinhada com as melhores práticas da indústria para testes API-first e equilibra cobertura com esforço de manutenção.
