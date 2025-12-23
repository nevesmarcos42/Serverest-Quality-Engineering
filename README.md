# ServeRest Quality Engineering

![Cypress](https://img.shields.io/badge/Cypress-13.17.0-00D09C?style=for-the-badge&logo=cypress)
![Karate](https://img.shields.io/badge/Karate-DSL-orange?style=for-the-badge&logo=java)
![Gherkin](https://img.shields.io/badge/Gherkin-BDD-00D09C?style=for-the-badge&logo=cucumber)
![Status](https://img.shields.io/badge/Status-Ativo-success?style=for-the-badge)
![Tests](https://img.shields.io/badge/Testes-83%20Cenários-blue?style=for-the-badge)
![Portuguese](https://img.shields.io/badge/Idioma-Português%20BR-green?style=for-the-badge)

> Projeto completo de Quality Engineering demonstrando automação de testes de API e UI para a aplicação ServeRest, com especificações BDD em português do Brasil.

**[Sobre](#sobre-o-projeto)** • **[Funcionalidades](#funcionalidades)** • **[Stack](#stack-tecnológico)** • **[Estrutura](#estrutura-do-projeto)** • **[Como Usar](#como-usar)** • **[Documentação](#documentação)** • **[Contribuir](#contribuindo)**

---

## Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Funcionalidades](#funcionalidades)
- [Stack Tecnológico](#stack-tecnológico)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Cobertura de Testes](#cobertura-de-testes)
- [Como Usar](#como-usar)
- [Execução de Testes](#execução-de-testes)
- [Documentação](#documentação)
- [Padrões e Boas Práticas](#padrões-e-boas-práticas)
- [Contribuindo](#contribuindo)
- [Licença](#licença)

---

## Sobre o Projeto

Este repositório é um **projeto profissional de Quality Engineering** que implementa cobertura de testes completa (API + UI) para a aplicação [ServeRest](https://serverest.dev/), demonstrando boas práticas e ferramentas padrão da indústria.

> **Importante**: Este é um projeto educacional focado em demonstrar conhecimento técnico em automação de testes, BDD e quality engineering. Todos os cenários e documentação estão em **português brasileiro**.

### Propósito

- **Demonstrar expertise em QE** - Automação completa de API e UI com ferramentas modernas
- **BDD em Português** - 83 cenários de teste escritos em Gherkin traduzidos para o Brasil
- **Portfólio Profissional** - Evidenciar capacidade técnica em automação e estratégia de testes
- **Documentação Viva** - Especificações executáveis que servem como documentação do sistema
- **Referência Técnica** - Estrutura e padrões para projetos de teste profissionais

### Principais Características

- **83 Cenários de Teste** - 60 testes de API (Karate) + 23 testes de UI (Cypress)
- **BDD com Gherkin** - Especificações em português do Brasil
- **100% de Taxa de Sucesso** - Todos os testes validados e funcionando
- **Page Object Model** - Padrão de design para testes UI escaláveis
- **Pirâmide de Testes** - Distribuição adequada entre testes de API e UI
- **ADRs Documentados** - Decisões arquiteturais registradas
- **Cobertura Completa** - Casos de sucesso, falha e validações de segurança

**Aplicação em Teste:** https://serverest.dev/

---

## Funcionalidades

### Autenticação e Usuários

- Cadastro de usuário com validações
- Login e gerenciamento de sessão
- Autenticação de administrador
- Validação de dados de usuário
- Gerenciamento de perfis

### Produtos e Catálogo

- Listagem de produtos com filtros
- Busca por nome e preço
- Visualização de detalhes
- Validação de estoque
- Gerenciamento de produtos (admin)

### Carrinho de Compras

- Adicionar produtos à lista de compras
- Remover itens da lista
- Validação de quantidades
- Persistência de seleção
- Limpar lista de compras

### Operações de API

- Operações CRUD completas
- Validações de autenticação
- Testes de contrato
- Validações de erro
- Testes de integração

---

## Stack Tecnológico

### Testes de API

- **Karate DSL** - Framework completo para testes de API REST

  - Assertions nativas e validações JSON
  - Relatórios integrados com métricas
  - Suporte a autenticação e tokens
  - 60 cenários implementados

- **Postman** - Testes exploratórios e validação rápida
  - Collections organizadas por feature
  - Validação manual de endpoints

### Testes de UI

- **Cypress 13.17.0** - Framework moderno para testes E2E
  - Page Object Model implementado
  - Custom commands reutilizáveis
  - Screenshots e vídeos de falhas
  - 23 testes end-to-end

### Especificação

- **Gherkin/BDD** - Cenários legíveis em português
  - 83 cenários totais
  - Features organizadas por domínio
  - Documentação como código

### Ambiente

- **Node.js 18+** - Runtime JavaScript
- **Java 11+** - Para execução do Karate
- **npm** - Gerenciador de pacotes
- **Git** - Controle de versão

---

## Estrutura do Projeto

```
ServeRest-Quality-Engineering/
├── docs/
│   ├── architecture/          # ADRs e decisões técnicas
│   │   └── ADR-001-escolha-ferramentas.md
│   ├── test-strategy/         # Estratégia e planejamento
│   │   └── test-strategy.md
│   └── reports/               # Relatórios de execução
│
├── features/
│   ├── api/                   # Especificações BDD da API
│   │   ├── usuarios.feature
│   │   ├── produtos.feature
│   │   └── carrinho.feature
│   └── ui/                    # Especificações BDD da UI
│       ├── autenticacao.feature
│       ├── navegacao-produtos.feature
│       └── carrinho-compras.feature
│
├── tests/
│   ├── api/
│   │   ├── karate/           # Testes automatizados Karate
│   │   │   ├── config/
│   │   │   ├── data/
│   │   │   └── features/
│   │   └── postman/          # Collections Postman
│   │       └── ServeRest.postman_collection.json
│   │
│   └── ui/
│       └── cypress/          # Testes E2E Cypress
│           ├── e2e/          # Arquivos de teste
│           ├── support/      # Page Objects e Commands
│           └── fixtures/     # Dados de teste
│
├── cypress.config.js         # Configuração Cypress
├── package.json              # Dependências Node
├── pom.xml                   # Configuração Maven/Karate
└── README.md                 # Este arquivo
```

### Organização dos Arquivos

| Diretório             | Descrição                                       |
| --------------------- | ----------------------------------------------- |
| `features/api/`       | Especificações Gherkin para endpoints da API    |
| `features/ui/`        | Especificações Gherkin para fluxos da interface |
| `tests/api/karate/`   | Implementação dos testes de API                 |
| `tests/ui/cypress/`   | Implementação dos testes de UI                  |
| `docs/architecture/`  | ADRs e documentação técnica                     |
| `docs/test-strategy/` | Estratégia e abordagem de testes                |

---

## Cobertura de Testes

### Testes de API (60 cenários)

#### Gerenciamento de Usuários

- Criação de usuário com validações
- Listagem e busca de usuários
- Atualização de dados
- Exclusão de usuário
- Validação de duplicados

#### Autenticação

- Login com credenciais válidas
- Geração de token JWT
- Validação de credenciais inválidas
- Expiração de token

#### Produtos

- Listagem de produtos
- Busca por filtros
- Cadastro de produto (admin)
- Atualização de produto
- Exclusão de produto

#### Carrinho

- Adicionar produtos ao carrinho
- Visualizar carrinho
- Excluir carrinho
- Validações de estoque

### Testes de UI (23 cenários)

#### Autenticação de Usuário (9 testes)

- Cadastro de novo usuário
- Cadastro de administrador
- Login com usuário válido
- Login com credenciais inválidas
- Validação de email duplicado
- Logout e limpeza de sessão

#### Navegação de Produtos (5 testes)

- Visualização de catálogo
- Exibição de cards de produtos
- Validação de informações
- Navegação entre páginas

#### Carrinho de Compras (7 testes)

- Adicionar produto à lista
- Visualizar lista de compras
- Remover itens da lista
- Validar quantidade de itens
- Limpar lista completamente

#### Funcionalidades Auxiliares

- Validação de elementos da interface
- Mensagens de erro específicas
- Redirecionamentos corretos

---

## Como Usar

### Pré-requisitos

Para executar este projeto, você precisará de:

- **Node.js 18+** e npm
- **Java 11+** (para testes Karate)
- **Git**
- Navegador moderno (Chrome, Firefox ou Edge)

### Instalação

#### 1. Clone o repositório

```bash
git clone https://github.com/nevesmarcos42/Serverest-Quality-Engineering.git
cd Serverest-Quality-Engineering
```

#### 2. Instale as dependências

```bash
# Instalar dependências Node.js
npm install

# Verificar instalação do Java
java -version
```

#### 3. Verifique a configuração

```bash
# Verificar instalação do Cypress
npx cypress verify
```

---

## Execução de Testes

### Testes de API (Karate)

```bash
# Executar todos os testes de API
npm run test:api

# Executar feature específica
mvn test -Dkarate.options="classpath:features/usuarios.feature"
```

### Testes de UI (Cypress)

```bash
# Executar todos os testes UI (headless)
npm run test:ui

# Abrir interface do Cypress
npx cypress open

# Executar teste específico
npx cypress run --spec "tests/ui/cypress/e2e/authentication.cy.js"
```

### Executar Todos os Testes

```bash
# Executar suite completa
npm test

# Verificar cobertura
npm run test:coverage
```

### Relatórios

Após a execução, os relatórios estarão disponíveis em:

- **Karate**: `target/karate-reports/karate-summary.html`
- **Cypress**: `tests/ui/cypress/reports/`

---

## Documentação

### Documentos Principais

- **[Estratégia de Testes](docs/test-strategy/test-strategy.md)** - Abordagem e planejamento completo
- **[ADR-001: Escolha de Ferramentas](docs/architecture/ADR-001-escolha-ferramentas.md)** - Decisão de stack tecnológico
- **[Mapeamento da API](docs/architecture/api-mapping.md)** - Documentação de endpoints
- **[Guia de Execução](docs/EXECUTION_GUIDE.md)** - Como executar os testes
- **[Resumo do Projeto](docs/PROJECT_SUMMARY.md)** - Visão geral técnica

### Features Documentadas

**API:**

- [Usuários](features/api/usuarios.feature) - Gerenciamento de usuários
- [Login](features/api/login.feature) - Autenticação
- [Produtos](features/api/produtos.feature) - Catálogo de produtos
- [Carrinho](features/api/carrinho.feature) - Operações de carrinho

**UI:**

- [Autenticação](features/ui/autenticacao.feature) - Cadastro e login
- [Navegação de Produtos](features/ui/navegacao-produtos.feature) - Catálogo
- [Carrinho de Compras](features/ui/carrinho-compras.feature) - Lista de compras

---

## Padrões e Boas Práticas

### Arquitetura de Testes

Este projeto segue a **Pirâmide de Testes**:

```
        /\
       /UI\      (23 testes - Fluxos críticos)
      /____\
     /      \
    /  API  \    (60 testes - Lógica de negócio)
   /__________\
```

### Padrões de Código

- **Page Object Model** - Separação de locators e lógica de teste
- **Custom Commands** - Comandos Cypress reutilizáveis
- **Data Fixtures** - Dados de teste centralizados
- **Assertions Claras** - Mensagens descritivas de falha
- **Independência de Testes** - Cada teste é independente

### Convenções de Nomenclatura

- **Features**: Substantivos descrevendo funcionalidades (`usuarios.feature`)
- **Scenarios**: Descrições claras e objetivas (`Cadastro de usuário com sucesso`)
- **Arquivos de Teste**: Padrão kebab-case (`authentication.cy.js`)
- **Page Objects**: PascalCase (`LoginPage.js`)

### Boas Práticas Implementadas

- Dados de teste separados da lógica
- Esperas explícitas ao invés de sleeps
- Seletores estáveis (data-testid)
- Limpeza de estado entre testes
- Mensagens de erro específicas
- Cobertura de casos positivos e negativos

---

## Contribuindo

Contribuições são bem-vindas! Siga os passos:

1. **Fork** o projeto
2. Crie uma **branch** para sua feature (`git checkout -b feature/NovosCenarios`)
3. **Commit** suas mudanças (`git commit -m 'feat: adiciona testes de checkout'`)
4. **Push** para a branch (`git push origin feature/NovosCenarios`)
5. Abra um **Pull Request**

### Padrões de Contribuição

#### Novos Testes

- Siga o padrão Page Object Model para testes UI
- Use Gherkin para especificações BDD
- Inclua casos de sucesso e falha
- Adicione comentários explicativos
- Atualize a documentação relevante

#### Mensagens de Commit

Use **Conventional Commits**:

- `feat:` - Nova funcionalidade ou cenário de teste
- `fix:` - Correção de teste ou bug
- `docs:` - Mudanças na documentação
- `refactor:` - Reestruturação de código de teste
- `test:` - Adição ou modificação de testes
- `chore:` - Tarefas de manutenção

**Exemplos:**

```bash
feat: adiciona testes de checkout completo
fix: corrige seletor do botão de login
docs: atualiza estratégia de testes
```

---

## Licença

Este é um **projeto educacional** desenvolvido para demonstração de práticas de quality engineering.

---

## Recursos Adicionais

### Links Úteis

- [Documentação Cypress](https://docs.cypress.io/)
- [Documentação Karate DSL](https://github.com/karatelabs/karate)
- [Gherkin Reference](https://cucumber.io/docs/gherkin/reference/)
- [ServeRest API](https://serverest.dev/)
- [BDD Best Practices](https://cucumber.io/docs/bdd/)

### Artigos Recomendados

- [Testing Pyramid](https://martinfowler.com/articles/practical-test-pyramid.html)
- [Page Object Model](https://www.selenium.dev/documentation/test_practices/encouraged/page_object_models/)
- [API Testing Best Practices](https://testautomationresources.com/api-testing/)

---

<div align="center">

**Desenvolvido como projeto de portfólio em Quality Engineering e Automação de Testes**

**Versão:** 1.0.0 | **Última Atualização:** Dezembro 2025

[![GitHub](https://img.shields.io/badge/GitHub-nevesmarcos42-181717?style=flat&logo=github)](https://github.com/nevesmarcos42)

</div>
