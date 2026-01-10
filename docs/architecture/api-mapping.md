# API Mapping - ServeRest

This document provides a complete mapping of the ServeRest API endpoints, including request/response formats and test coverage.

## Base URL

```
https://serverest.dev
```

## Endpoints

### 1. Users (/usuarios)

#### GET /usuarios

List all users with optional filters

**Query Parameters:**

- `_id` (optional) - Filter by user ID
- `nome` (optional) - Filter by name
- `email` (optional) - Filter by email
- `password` (optional) - Filter by password
- `administrador` (optional) - Filter by admin status

**Response:**

```json
{
  "quantidade": 1,
  "usuarios": [
    {
      "_id": "string",
      "nome": "string",
      "email": "string",
      "password": "string",
      "administrador": "true|false"
    }
  ]
}
```

#### GET /usuarios/{\_id}

Get user by ID

**Path Parameters:**

- `_id` (required) - User ID

**Response:**

```json
{
  "_id": "string",
  "nome": "string",
  "email": "string",
  "password": "string",
  "administrador": "true|false"
}
```

#### POST /usuarios

Create new user

**Request Body:**

```json
{
  "nome": "string",
  "email": "string",
  "password": "string",
  "administrador": "true|false"
}
```

**Response (Success):**

```json
{
  "message": "Cadastro realizado com sucesso",
  "_id": "string"
}
```

#### PUT /usuarios/{\_id}

Update existing user

**Path Parameters:**

- `_id` (required) - User ID

**Request Body:**

```json
{
  "nome": "string",
  "email": "string",
  "password": "string",
  "administrador": "true|false"
}
```

**Response:**

```json
{
  "message": "Registro alterado com sucesso"
}
```

#### DELETE /usuarios/{\_id}

Delete user

**Path Parameters:**

- `_id` (required) - User ID

**Response:**

```json
{
  "message": "Registro excluído com sucesso"
}
```

### 2. Login (/login)

#### POST /login

Authenticate user and get JWT token

**Request Body:**

```json
{
  "email": "string",
  "password": "string"
}
```

**Response (Success):**

```json
{
  "message": "Login realizado com sucesso",
  "authorization": "Bearer <token>"
}
```

**Response (Error):**

```json
{
  "message": "Email e/ou senha inválidos"
}
```

### 3. Products (/produtos)

#### GET /produtos

List all products with optional filters

**Query Parameters:**

- `_id` (optional) - Filter by product ID
- `nome` (optional) - Filter by name
- `preco` (optional) - Filter by price
- `descricao` (optional) - Filter by description
- `quantidade` (optional) - Filter by quantity

**Response:**

```json
{
  "quantidade": 1,
  "produtos": [
    {
      "_id": "string",
      "nome": "string",
      "preco": 0,
      "descricao": "string",
      "quantidade": 0
    }
  ]
}
```

#### GET /produtos/{\_id}

Get product by ID

**Path Parameters:**

- `_id` (required) - Product ID

**Response:**

```json
{
  "_id": "string",
  "nome": "string",
  "preco": 0,
  "descricao": "string",
  "quantidade": 0
}
```

#### POST /produtos

Create new product (Admin only)

**Headers:**

- `Authorization: Bearer <token>` (required)

**Request Body:**

```json
{
  "nome": "string",
  "preco": 0,
  "descricao": "string",
  "quantidade": 0
}
```

**Response:**

```json
{
  "message": "Cadastro realizado com sucesso",
  "_id": "string"
}
```

#### PUT /produtos/{\_id}

Update existing product (Admin only)

**Headers:**

- `Authorization: Bearer <token>` (required)

**Path Parameters:**

- `_id` (required) - Product ID

**Request Body:**

```json
{
  "nome": "string",
  "preco": 0,
  "descricao": "string",
  "quantidade": 0
}
```

**Response:**

```json
{
  "message": "Registro alterado com sucesso"
}
```

#### DELETE /produtos/{\_id}

Delete product (Admin only)

**Headers:**

- `Authorization: Bearer <token>` (required)

**Path Parameters:**

- `_id` (required) - Product ID

**Response:**

```json
{
  "message": "Registro excluído com sucesso"
}
```

### 4. Shopping Carts (/carrinhos)

#### GET /carrinhos

List all shopping carts

**Response:**

```json
{
  "quantidade": 1,
  "carrinhos": [
    {
      "_id": "string",
      "produtos": [
        {
          "idProduto": "string",
          "quantidade": 0,
          "precoUnitario": 0
        }
      ],
      "precoTotal": 0,
      "quantidadeTotal": 0,
      "idUsuario": "string"
    }
  ]
}
```

#### GET /carrinhos/{\_id}

Get cart by ID

**Path Parameters:**

- `_id` (required) - Cart ID

**Response:**

```json
{
  "_id": "string",
  "produtos": [
    {
      "idProduto": "string",
      "quantidade": 0,
      "precoUnitario": 0
    }
  ],
  "precoTotal": 0,
  "quantidadeTotal": 0,
  "idUsuario": "string"
}
```

#### POST /carrinhos

Create new cart

**Headers:**

- `Authorization: Bearer <token>` (required)

**Request Body:**

```json
{
  "produtos": [
    {
      "idProduto": "string",
      "quantidade": 0
    }
  ]
}
```

**Response:**

```json
{
  "message": "Cadastro realizado com sucesso",
  "_id": "string"
}
```

#### DELETE /carrinhos/concluir-compra

Complete purchase

**Headers:**

- `Authorization: Bearer <token>` (required)

**Response:**

```json
{
  "message": "Registro excluído com sucesso"
}
```

#### DELETE /carrinhos/cancelar-compra

Cancel purchase

**Headers:**

- `Authorization: Bearer <token>` (required)

**Response:**

```json
{
  "message": "Registro excluído com sucesso. Estoque dos produtos reabastecido"
}
```

## Status Codes

| Code | Description           | Usage                       |
| ---- | --------------------- | --------------------------- |
| 200  | OK                    | Successful GET, PUT, DELETE |
| 201  | Created               | Successful POST             |
| 400  | Bad Request           | Invalid request body/params |
| 401  | Unauthorized          | Missing or invalid token    |
| 403  | Forbidden             | Insufficient permissions    |
| 404  | Not Found             | Resource not found          |
| 422  | Unprocessable Entity  | Validation errors           |
| 500  | Internal Server Error | Server error                |

## Authentication

Most endpoints require JWT token authentication.

### Obtaining Token

1. Create user via POST /usuarios
2. Login via POST /login
3. Use returned token in Authorization header: `Bearer <token>`

### Protected Endpoints

- POST /produtos (Admin only)
- PUT /produtos/{\_id} (Admin only)
- DELETE /produtos/{\_id} (Admin only)
- POST /carrinhos (Authenticated user)
- DELETE /carrinhos/concluir-compra (Authenticated user)
- DELETE /carrinhos/cancelar-compra (Authenticated user)

## Business Rules

### Users

- Email must be unique
- All fields are required
- Password is stored in plain text (educational API)

### Products

- Only administrators can create/update/delete products
- Product name must be unique
- Quantity cannot be negative

### Shopping Carts

- User can have only one active cart
- Product quantity in cart cannot exceed available stock
- Completing purchase removes cart and updates product stock
- Canceling purchase removes cart and restores product stock

## Test Coverage

All endpoints are covered by automated tests in:

- `tests/api/karate/features/usuarios.feature`
- `tests/api/karate/features/login.feature`
- `tests/api/karate/features/produtos.feature`
- `tests/api/karate/features/carrinhos.feature`
