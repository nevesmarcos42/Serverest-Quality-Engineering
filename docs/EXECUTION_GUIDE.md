# Guia de Execução

Guia completo para configurar e executar o projeto ServeRest Quality Engineering.

## Pré-requisitos

Certifique-se de ter os seguintes itens instalados:

- **Node.js** 18 ou superior
- **Java JDK** 11 ou superior
- **Maven** 3.6 ou superior
- **Git**

Verificar instalações:

```bash
node --version
java --version
mvn --version
git --version
```

## Configuração Inicial

### 1. Clonar Repositório

```bash
git clone <repository-url>
cd Serverest-Quality-Engineering
```

### 2. Instalar Dependências Node

```bash
npm install
```

Isso instala o Cypress e pacotes relacionados.

### 3. Instalar Dependências Maven

```bash
mvn clean install
```

Isso baixa o Karate DSL e dependências de teste.

## Executando Testes

### Testes de API (Karate DSL)

Executar todos os testes de API:

```bash
mvn test
```

Executar feature específica:

```bash
mvn test -Dkarate.options="classpath:serverest/authentication/authentication.feature"
```

Executar com tags:

```bash
mvn test -Dkarate.options="--tags @smoke"
```

### Testes de UI (Cypress)

Executar todos os testes de UI em modo headless:

```bash
npm run test:ui
```

Abrir Cypress Test Runner para modo interativo:

```bash
npm run test:ui:open
```

Executar arquivo de teste específico:

```bash
npx cypress run --spec "tests/ui/cypress/e2e/authentication.cy.js"
```

### Executar Todos os Testes

Executar suíte completa de testes:

```bash
npm test
```

Isso executa os testes de API primeiro, depois os testes de UI.

## Relatórios de Testes

### Relatórios Karate

Após executar testes de API, relatórios são gerados em:

```
target/karate-reports/karate-summary.html
```

Abrir no navegador:

```bash
# Windows
start target/karate-reports/karate-summary.html

# Mac/Linux
open target/karate-reports/karate-summary.html
```

### Relatórios Cypress

Resultados dos testes aparecem no terminal após execução.

Vídeos das execuções:

```
tests/ui/cypress/videos/
```

Screenshots de falhas:

```
tests/ui/cypress/screenshots/
```

## Configuração de Ambiente

### URL Base da API

Padrão: `https://serverest.dev`

Para alterar, edite:

- **Karate:** `tests/api/karate/karate-config.js`
- **Cypress:** `cypress.config.js` → `env.apiUrl`

### Timeouts

Ajustar timeouts em:

- **Karate:** `karate-config.js` → `defaultTimeout`
- **Cypress:** `cypress.config.js` → `defaultCommandTimeout`

## Gerenciamento de Dados de Teste

### Geração Dinâmica de Dados

Testes usam timestamps e números aleatórios para criar dados únicos:

- Emails: `qa.user.<timestamp>.<random>@test.com`
- Nomes de produtos: `Produto Test <timestamp>`
- Nomes de usuários: `User Test <timestamp>`

Isso previne conflitos no ambiente de teste compartilhado.

### Fixtures de Teste

Dados de teste estáticos disponíveis em:

```
tests/ui/cypress/fixtures/testData.json
```

## Resolução de Problemas

### Problema: Testes Maven falham com timeout de conexão

**Solução:** Aumentar timeout em `karate-config.js`:

```javascript
config.defaultTimeout = 30000;
```

### Problema: Testes Cypress falham com "element not found"

**Solução:** Seletores podem ter mudado. Verificar atributos `data-testid` no frontend ServeRest.

### Problema: Testes falham com "email already in use"

**Solução:** Testes geram emails únicos automaticamente. Se vendo este erro, garantir que geração de timestamp está funcionando em:

- Karate: `utils.js` → `generateEmail()`
- Cypress: `commands.js` → `generateUniqueEmail()`

### Problema: Erros de limitação de taxa

**Solução:** Adicionar delays entre testes ou reduzir execução paralela:

```bash
mvn test -Dkarate.options="--threads 1"
```

### Problema: Incompatibilidade de versão do Java

**Solução:** Verificar se Java 11+ está ativo:

```bash
java -version
```

Definir JAVA_HOME se necessário.

## Melhores Práticas

### Antes de Commitar

1. Executar suíte completa de testes localmente
2. Corrigir quaisquer testes que falharam
3. Revisar logs de teste para avisos
4. Garantir que não há credenciais no código

### Adicionando Novos Testes

1. Seguir padrões existentes (Page Objects para UI, helpers para API)
2. Usar nomes de cenário descritivos
3. Adicionar assertions para todos os comportamentos esperados
4. Limpar dados de teste quando possível
5. Tornar testes independentes e idempotentes

### Manutenção de Testes

Semanal:

- Revisar testes que falharam
- Atualizar seletores se UI mudou
- Refatorar código duplicado

Mensal:

- Revisar lacunas de cobertura
- Remover testes obsoletos
- Atualizar documentação

## Integração CI/CD

### Exemplo GitHub Actions

```yaml
name: Tests
on: [push, pull_request]

jobs:
  api-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with:
          java-version: "11"
      - run: mvn test

  ui-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: "18"
      - run: npm install
      - run: npm run test:ui
```

## Comandos Úteis

### Limpar Artefatos de Build

```bash
mvn clean
rm -rf node_modules
npm install
```

### Atualizar Dependências

```bash
npm update
mvn versions:use-latest-versions
```

### Depurar Teste Específico

**Karate:**

```bash
mvn test -Dtest=TestRunner -Dkarate.options="--tags @debug" -Dkarate.env=dev
```

**Cypress:**

```bash
npx cypress open --config watchForFileChanges=true
```

## Suporte

Para problemas ou questões:

1. Verificar logs de teste existentes
2. Revisar documentação da API: https://serverest.dev/
3. Consultar documentação do projeto em `docs/`
4. Verificar docs do Cypress: https://docs.cypress.io/
5. Verificar docs do Karate: https://github.com/karatelabs/karate

## Resumo de Início Rápido

Configuração completa e primeira execução de teste:

```bash
# Clonar e configurar
git clone <repo-url>
cd Serverest-Quality-Engineering
npm install
mvn clean install

# Executar testes
mvn test                    # Testes de API
npm run test:ui:open        # Testes de UI interativo
npm test                    # Todos os testes

# Ver relatórios
# Abrir target/karate-reports/karate-summary.html no navegador
```

Você deverá ver:

- Testes de API: 60 cenários executados
- Testes de UI: 23 testes executados
- Todos os testes passando (verde)
