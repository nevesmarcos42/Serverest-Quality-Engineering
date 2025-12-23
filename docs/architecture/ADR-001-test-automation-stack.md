# ADR-001: Seleção do Stack de Automação de Testes

**Status:** Aceito  
**Data:** 2024-01-15  
**Tomadores de Decisão:** Equipe de QE

## Contexto

O projeto ServeRest requer um framework abrangente de automação de testes cobrindo camadas de API e UI. A solução deve suportar:

- Especificações de teste legíveis para o negócio
- Testes de API rápidos e confiáveis
- Validação end-to-end da UI
- Fácil integração com pipelines CI/CD
- Sobrecarga mínima de manutenção
- Relatórios claros para stakeholders

## Drivers de Decisão

1. **Habilidades da Equipe** - Proficiência em JavaScript/Node.js
2. **Velocidade de Execução** - Testes de API devem rodar em minutos
3. **Manutenibilidade** - Minimizar duplicação de código de teste
4. **Relatórios** - Preferência por relatórios HTML integrados
5. **Suporte da Comunidade** - Manutenção ativa e documentação
6. **Curva de Aprendizado** - Tempo de onboarding razoável

## Opções Consideradas

### Testes de API

**Opção A: Karate DSL**

- Prós: Suporte nativo para testes de API, sintaxe BDD, assertions integradas, relatórios excelentes
- Contras: Requer JVM, curva de aprendizado para equipes não-Java

**Opção B: REST Assured (Java)**

- Prós: Maduro, abrangente, ecossistema Java
- Contras: Sintaxe verbosa, requer conhecimento Java, mais boilerplate

**Opção C: SuperTest (JavaScript)**

- Prós: Nativo em JavaScript, sintaxe simples
- Contras: Relatórios básicos, biblioteca de assertion manual, menos recursos

### Testes de UI

**Opção A: Cypress**

- Prós: Arquitetura moderna, rápido, ótima DX, esperas automáticas, time-travel debugging
- Contras: Sem multi-browser (aceitável para este escopo)

**Opção B: Selenium WebDriver**

- Prós: Multi-browser, padrão da indústria
- Contras: Mais lento, mais boilerplate, testes mais instáveis

**Opção C: Playwright**

- Prós: Moderno, multi-browser, rápido
- Contras: Mais novo (menos recursos da comunidade), excessivo para necessidades single-browser

### Linguagem de Especificação

**Opção A: Gherkin/BDD**

- Prós: Legível para o negócio, formato padrão, independente de ferramenta
- Contras: Pode ficar desconectado da implementação

**Opção B: Comentários de Código Simples**

- Prós: Simples, sem sintaxe extra
- Contras: Não acessível para stakeholders não-técnicos

## Decisão

**Testes de API:** Karate DSL  
**Testes de UI:** Cypress  
**Especificações:** Gherkin/BDD  
**Testes Exploratórios:** Postman

## Justificativa

### Karate DSL para API

Apesar de requerer JVM, Karate fornece o melhor equilíbrio de:

- **Recursos nativos de API:** Validação integrada de JSON/XML, correspondência de schema, funções reutilizáveis
- **Legibilidade:** Sintaxe BDD torna testes autodocumentáveis
- **Relatórios:** Relatórios HTML profissionais com detalhes de request/response
- **Performance:** Execução paralela, feedback rápido
- **Manutenção:** Testes orientados a dados reduzem duplicação

O requisito da JVM é aceitável pois é uma configuração única e fornece acesso ao robusto ecossistema Java.

### Cypress para UI

Cypress vence na experiência do desenvolvedor:

- **Espera automática:** Sem necessidade de esperas explícitas, testes mais estáveis
- **Time travel:** Depurar testes vendo o estado da aplicação em cada passo
- **Reload em tempo real:** Feedback instantâneo durante desenvolvimento de teste
- **Screenshots/vídeos:** Evidência automática de falhas
- **Nativo em JavaScript:** Alinha com stack de frontend moderno

Limitação de single-browser é aceitável pois bugs cross-browser são raros no nosso contexto.

### Especificações Gherkin

BDD fornece:

- **Documentação viva:** Specs permanecem sincronizadas com implementação
- **Entendimento compartilhado:** Ponte entre equipes de negócio e técnicas
- **Design de teste:** Força pensamento sobre comportamento do usuário antes da implementação
- **Rastreabilidade:** Link claro de requisito para teste

## Consequências

### Positivas

- Separação clara de preocupações de teste (API vs UI)
- Loop de feedback rápido (testes de API rodam em 2-3 minutos)
- Relatórios amigáveis para stakeholders
- Instabilidade reduzida com esperas automáticas do Cypress
- Forte suporte da comunidade para ambas ferramentas

### Negativas

- Dois paradigmas de programação diferentes (similar a Java para Karate, JavaScript para Cypress)
- Dependência de JVM adiciona complexidade de configuração
- Necessidade de manter dois frameworks de teste
- Gherkin pode se tornar verboso se não houver disciplina

### Mitigação

- Fornecer documentação clara de configuração
- Criar componentes reutilizáveis em ambos frameworks
- Estabelecer diretrizes de escrita Gherkin
- Refatoração regular para manter código de teste limpo

## Alternativas Rejeitadas

- **REST Assured:** Muito verboso, desenvolvimento de teste mais lento
- **Selenium:** Testes mais instáveis, execução mais lenta, mais manutenção
- **Código puro (sem BDD):** Perda de legibilidade para o negócio

## Decisões Relacionadas

- ADR-002: Estratégia de gerenciamento de dados de teste (pendente)
- ADR-003: Abordagem de integração CI/CD (pendente)

## Revisão

Esta decisão deve ser revisada se:

- Composição da equipe mudar significativamente
- Novos requisitos exigirem testes multi-browser
- Manutenção do Karate se tornar um fardo
- Melhores alternativas surgirem no ecossistema
