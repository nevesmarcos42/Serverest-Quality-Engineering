# Mapeamento da API ServeRest

Mapeamento completo dos endpoints, contratos e regras de negócio da API ServeRest.

**URL Base:** `https://serverest.dev`  
**Documentação:** https://serverest.dev/

## Autenticação

ServeRest usa autenticação por token Bearer para endpoints protegidos.

**Fluxo:**

1. POST `/login` com credenciais válidas
2. Receber token na resposta: `{ "authorization": "Bearer <token>" }`
3. Incluir token no header: `Authorization: Bearer <token>`
4. Token permanece válido durante a sessão

## Visão Geral dos Endpoints

| Método | Endpoint                   | Requer Auth | Descrição              |
| ------ | -------------------------- | ----------- | ---------------------- |
| POST   | /login                     | Não         | Autenticar usuário     |
| GET    | /usuarios                  | Não         | Listar todos usuários  |
| GET    | /usuarios/{id}             | Não         | Buscar usuário por ID  |
| POST   | /usuarios                  | Não         | Criar novo usuário     |
| PUT    | /usuarios/{id}             | Sim         | Atualizar usuário      |
| DELETE | /usuarios/{id}             | Sim         | Deletar usuário        |
| GET    | /produtos                  | Não         | Listar todos produtos  |
| GET    | /produtos/{id}             | Não         | Buscar produto por ID  |
| POST   | /produtos                  | Sim (Admin) | Criar produto          |
| PUT    | /produtos/{id}             | Sim (Admin) | Atualizar produto      |
| DELETE | /produtos/{id}             | Sim (Admin) | Deletar produto        |
| GET    | /carrinhos                 | Não         | Listar todos carrinhos |
| GET    | /carrinhos/{id}            | Não         | Buscar carrinho por ID |
| POST   | /carrinhos                 | Sim         | Criar carrinho         |
| DELETE | /carrinhos/concluir-compra | Sim         | Concluir compra        |
| DELETE | /carrinhos/cancelar-compra | Sim         | Cancelar compra        |

---

## 1. Login

### POST /login

Autenticar usuário e receber token de autorização.

**Requisição:**

```json
{
  "email": "fulano@qa.com",
  "password": "teste"
}
```

**Resposta 200 - Sucesso:**

```json
{
  "message": "Login realizado com sucesso",
  "authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Resposta 401 - Credenciais Inválidas:**

```json
{
  "message": "Email e/ou senha inválidos"
}
```

**Regras de Negócio:**

- Email deve estar cadastrado
- Senha deve corresponder
- Retorna token JWT válido para a sessão
- Token necessário para endpoints protegidos

---

## 2. Usuários (Usuarios)

### GET /usuarios

Listar todos os usuários cadastrados com filtragem opcional.

**Parâmetros de Query:**

- `nome` - Filtrar por nome (correspondência parcial)
- `email` - Filtrar por email (correspondência exata)
- `password` - Filtrar por senha
- `administrador` - Filtrar por status admin ("true" ou "false")

**Resposta 200:**

```json
{
  "quantidade": 2,
  "usuarios": [
    {
      "_id": "0uxuPY0cbmQhpEz1",
      "nome": "Fulano da Silva",
      "email": "fulano@qa.com",
      "password": "teste",
      "administrador": "true"
    }
  ]
}
```

### GET /usuarios/{id}

Obter detalhes do usuário por ID.

**Resposta 200 - Encontrado:**

```json
{
  "_id": "0uxuPY0cbmQhpEz1",
  "nome": "Fulano da Silva",
  "email": "fulano@qa.com",
  "password": "teste",
  "administrador": "true"
}
```

**Resposta 400 - Não Encontrado:**

```json
{
  "message": "Usuário não encontrado"
}
```

### POST /usuarios

Criar novo usuário.

**Requisição:**

```json
{
  "nome": "João Silva",
  "email": "joao@qa.com",
  "password": "senha123",
  "administrador": "true"
}
```

**Resposta 201 - Criado:**

```json
{
  "message": "Cadastro realizado com sucesso",
  "_id": "xG8fHPHLfy17C3qD"
}
```

**Resposta 400 - Email Já Existe:**

```json
{
  "message": "Este email já está sendo usado"
}
```

**Regras de Validação:**

- `nome`: Obrigatório, string
- `email`: Obrigatório, formato de email válido, único
- `password`: Obrigatório, string
- `administrador`: Obrigatório, "true" ou "false"

### PUT /usuarios/{id}

Atualizar usuário existente (requer autenticação).

**Requisição:** Mesma do POST

**Resposta 200 - Atualizado:**

```json
{
  "message": "Registro alterado com sucesso"
}
```

**Resposta 201 - Criado (se ID não existe):**

```json
{
  "message": "Cadastro realizado com sucesso",
  "_id": "xG8fHPHLfy17C3qD"
}
```

**Regras de Negócio:**

- Se ID do usuário existe: atualiza usuário existente
- Se ID do usuário não existe: cria novo usuário com esse ID
- Unicidade de email ainda é garantida

### DELETE /usuarios/{id}

Deletar usuário (requer autenticação).

**Resposta 200 - Sucesso:**

```json
{
  "message": "Registro excluído com sucesso"
}
```

**Resposta 400 - Não Encontrado:**

```json
{
  "message": "Nenhum registro excluído"
}
```

**Resposta 400 - Possui Carrinho:**

```json
{
  "message": "Não é permitido excluir usuário com carrinho cadastrado",
  "idCarrinho": "qbMqntef4iTOwWfg"
}
```

**Regras de Negócio:**

- Não pode deletar usuário com carrinho ativo
- Deve concluir ou cancelar compra primeiro

---

## 3. Produtos (Products)

### GET /produtos

Listar todos os produtos com filtragem opcional.

**Parâmetros de Query:**

- `nome` - Filtrar por nome (correspondência parcial)
- `preco` - Filtrar por preço (correspondência exata)
- `descricao` - Filtrar por descrição (correspondência parcial)
- `quantidade` - Filtrar por quantidade (correspondência exata)

**Resposta 200:**

```json
{
  "quantidade": 1,
  "produtos": [
    {
      "_id": "BeeJh5lz3k6kSIzA",
      "nome": "Logitech MX Vertical",
      "preco": 470,
      "descricao": "Mouse",
      "quantidade": 382
    }
  ]
}
```

### GET /produtos/{id}

Obter detalhes do produto por ID.

**Resposta 200/400:** Similar a usuários

### POST /produtos

Criar produto (requer autenticação de admin).

**Requisição:**

```json
{
  "nome": "Mouse Gamer",
  "preco": 150,
  "descricao": "Mouse ergonômico com RGB",
  "quantidade": 50
}
```

**Resposta 201 - Criado:**

```json
{
  "message": "Cadastro realizado com sucesso",
  "_id": "BeeJh5lz3k6kSIzA"
}
```

**Resposta 400 - Nome Já Existe:**

```json
{
  "message": "Já existe produto com esse nome"
}
```

**Resposta 401 - Não é Admin:**

```json
{
  "message": "Rota exclusiva para administradores"
}
```

**Regras de Validação:**

- `nome`: Obrigatório, string, único
- `preco`: Obrigatório, inteiro
- `descricao`: Obrigatório, string
- `quantidade`: Obrigatório, inteiro >= 0

### PUT /produtos/{id}

Atualizar produto (requer autenticação de admin).

**Regras de Negócio:** Mesmas da atualização de usuário (cria se não existe)

### DELETE /produtos/{id}

Deletar produto (requer autenticação de admin).

**Resposta 400 - No Carrinho:**

```json
{
  "message": "Não é permitido excluir produto que faz parte de carrinho",
  "idCarrinho": "qbMqntef4iTOwWfg"
}
```

---

## 4. Carrinho de Compras (Shopping Cart)

### GET /carrinhos

Listar todos os carrinhos ativos.

**Response 200:**

```json
{
  "quantidade": 1,
  "carrinhos": [
    {
      "_id": "qbMqntef4iTOwWfg",
      "produtos": [
        {
          "idProduto": "BeeJh5lz3k6kSIzA",
          "quantidade": 2,
          "precoUnitario": 470
        }
      ],
      "precoTotal": 940,
      "quantidadeTotal": 2,
      "idUsuario": "0uxuPY0cbmQhpEz1"
    }
  ]
}
```

### POST /carrinhos

Criar carrinho de compras (requer autenticação).

**Requisição:**

```json
{
  "produtos": [
    {
      "idProduto": "BeeJh5lz3k6kSIzA",
      "quantidade": 2
    }
  ]
}
```

**Resposta 201 - Criado:**

```json
{
  "message": "Cadastro realizado com sucesso",
  "_id": "qbMqntef4iTOwWfg"
}
```

**Resposta 400 - Usuário Já Possui Carrinho:**

```json
{
  "message": "Não é permitido ter mais de 1 carrinho",
  "idCarrinho": "qbMqntef4iTOwWfg"
}
```

**Resposta 400 - Produto Não Encontrado:**

```json
{
  "message": "Produto não encontrado",
  "idProduto": "invalid_id"
}
```

**Resposta 400 - Estoque Insuficiente:**

```json
{
  "message": "Produto não possui quantidade suficiente",
  "idProduto": "BeeJh5lz3k6kSIzA"
}
```

**Regras de Negócio:**

- Usuário pode ter apenas um carrinho ativo
- Produto deve existir e ter estoque suficiente
- Sistema calcula preço total e quantidade
- Estoque do produto é reservado quando carrinho é criado

### DELETE /carrinhos/concluir-compra

Concluir compra (requer autenticação).

**Resposta 200 - Sucesso:**

```json
{
  "message": "Registro excluído com sucesso"
}
```

**Resposta 200 - Sem Carrinho:**

```json
{
  "message": "Não foi encontrado carrinho para esse usuário"
}
```

**Regras de Negócio:**

- Reduz permanentemente o estoque do produto
- Remove carrinho do sistema
- Não pode ser desfeito

### DELETE /carrinhos/cancelar-compra

Cancelar compra (requer autenticação).

**Resposta 200 - Sucesso:**

```json
{
  "message": "Registro excluído com sucesso. Estoque dos produtos reabastecido"
}
```

**Regras de Negócio:**

- Retorna produtos ao estoque
- Remove carrinho do sistema
- Usuário pode criar novo carrinho depois

---

## Considerações de Teste

### Validações Críticas

1. **Autenticação:** Expiração de token, tokens inválidos, tokens faltando
2. **Autorização:** Rotas exclusivas de admin, validação de propriedade do usuário
3. **Validação de Dados:** Campos obrigatórios, validação de formato, valores limite
4. **Regras de Negócio:** Limitações de carrinho, gerenciamento de estoque, relacionamentos de dados
5. **Tratamento de Erros:** Códigos de status apropriados, mensagens de erro claras

### Casos Extremos

- Criar usuário/produto com email/nome existente
- Deletar recursos com dependências (usuário com carrinho, produto no carrinho)
- Operações concorrentes de carrinho
- Cenários de esgotamento de estoque
- Formatos de ID inválidos

### Notas de Performance

- API possui rate-limit (limites específicos não documentados)
- Ambiente compartilhado - dados podem ser modificados por outros usuários
- Use identificadores únicos nos dados de teste para evitar conflitos
