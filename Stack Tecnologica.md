# Documentação Técnica da API - CSTrader MVP

## Índice

1. [Arquitetura e Estrutura](#1-arquitetura-e-estrutura)
2. [Endpoints de Autenticação e Utilizadores](#2-endpoints-de-autenticação-e-utilizadores-public--auth)
3. [Endpoints de Inventário e Carteira](#3-endpoints-de-gestão-de-inventário-e-carteira-auth)
4. [Endpoints de Marketplace](#4-endpoints-de-marketplace-auth)
5. [Endpoints de Administração](#5-endpoints-de-administração-admin-only)
6. [Exemplos de Requests e Responses](#6-exemplos-de-requests-e-responses)

---

Esta API serve como o backend para uma plataforma de marketplace de skins, gerindo utilizadores, inventários, carteiras e funcionalidades administrativas. É construída com **FastAPI** e usa **SQLAlchemy/ORM** para interação com a base de dados.

---

## 1. Arquitetura e Estrutura

O sistema segue o modelo cliente-servidor, onde o FastAPI atua como o ponto central para todas as operações.

### **Dependencies Key**

* `Depends(get_db)`: Requer uma sessão de base de dados.
* `Depends(get_current_user)`: Requer um token JWT válido (utilizador).
* `Depends(get_current_admin_user)`: Requer um token JWT válido e a função de utilizador deve ser **admin**.

---

## 2. Endpoints de Autenticação e Utilizadores (Public & Auth)

| Método | Endpoint            | Descrição                                                               | Autenticação         | Status Code     | Resposta de Sucesso                                                                               |
| ------ | ------------------- | ----------------------------------------------------------------------- | -------------------- | --------------- | ------------------------------------------------------------------------------------------------- |
| POST   | `/register_user`    | Cria um novo utilizador no sistema.                                     | Pública              | **201 Created** | `{ "message": "User registered successfully", "user_id": "..." }`                                 |
| POST   | `/login`            | Autentica o utilizador e devolve um token JWT de acesso. Usa form-data. | Pública              | **200 OK**      | `{ "message": "Login successful", "access_token": "...", "token_type": "bearer", "role": "..." }` |
| GET    | `/logout`           | Indica logout (token invalidado no cliente).                            | User                 | **200 OK**      | `{ "message": "Logout successful" }`                                                              |
| GET    | `/users/me`         | Retorna saudação com email do utilizador autenticado.                   | User                 | **200 OK**      | `{ "message": "Olá user@example.com!" }`                                                          |
| GET    | `/get_users`        | Lista todos os utilizadores.                                            | Pública (atualmente) | **200 OK**      | `{ "message": "...", "users": [...] }`                                                            |
| GET    | `/get_user/{email}` | Obtém dados de um utilizador pelo email.                                | Pública (atualmente) | **200 OK**      | `{ "message": "...", "user": {...} }`                                                             |

---

## 3. Endpoints de Gestão de Inventário e Carteira (Auth)

Requerem autenticação através de `get_current_user`.

| Método | Endpoint                | Descrição                                   | Status Code | Body (Exemplo)       | Resposta de Sucesso                                                      |
| ------ | ----------------------- | ------------------------------------------- | ----------- | -------------------- | ------------------------------------------------------------------------ |
| GET    | `/inventory`            | Lista as skins do utilizador autenticado.   | **200 OK**  | N/A                  | `{ "message": "...", "skins": [...] }`                                   |
| GET    | `/user/skins/{user_id}` | Lista as skins de um utilizador específico. | **200 OK**  | N/A                  | `{ "message": "...", "skins": [...] }`                                   |
| POST   | `/wallet/deposit`       | Adiciona fundos à carteira.                 | **200 OK**  | `{ "amount": 50.0 }` | `{ "message": "Depósito realizado com sucesso.", "new_balance": 150.0 }` |
| GET    | `/transactions/history` | Histórico de transações do utilizador.      | **200 OK**  | N/A                  | `[...]`                                                                  |

---

## 4. Endpoints de Marketplace (Auth)

Gerem listagem, compra e remoção de skins.

| Método | Endpoint                                         | Descrição                                              | Status Code     | Body (Exemplo)                       | Resposta de Sucesso                             |
| ------ | ------------------------------------------------ | ------------------------------------------------------ | --------------- | ------------------------------------ | ----------------------------------------------- |
| GET    | `/marketplace/skins`                             | Lista todas as skins à venda.                          | **200 OK**      | N/A                                  | `[...]`                                         |
| GET    | `/marketplace/user/skins`                        | Lista skins do utilizador autenticadas no marketplace. | **200 OK**      | N/A                                  | `[...]`                                         |
| POST   | `/marketplace/add/skin`                          | Lista skin do inventário no marketplace.               | **201 Created** | `{ "skin_id": 123, "value": 50.50 }` | `{ "message": "...", "skin_id": 123 }`          |
| DELETE | `/marketplace/remove/skin/{marketplace_skin_id}` | Remove skin listada.                                   | **200 OK**      | N/A                                  | `{ "message": "Skin removed successfully..." }` |
| POST   | `/marketplace/buy/skin/{marketplace_skin_id}`    | Compra uma skin.                                       | **200 OK**      | N/A                                  | `{ "message": "Skin purchased successfully" }`  |

---

## 5. Endpoints de Administração (Admin Only)

Requer autenticação **admin** (`get_current_admin_user`).

| Método | Endpoint                       | Descrição                     | Status Code     | Body (Exemplo)                                                   | Resposta de Sucesso                          |
| ------ | ------------------------------ | ----------------------------- | --------------- | ---------------------------------------------------------------- | -------------------------------------------- |
| GET    | `/skins/all`                   | Lista todas as skins base.    | **200 OK**      | N/A                                                              | `[...]`                                      |
| POST   | `/admin/skins`                 | Cria nova skin base.          | **201 Created** | `{ "name": "AK-47 Redline", "float": 0.5, "base_price": 100.0 }` | *(Resposta padrão do sistema)*               |
| PUT    | `/admin/skin/edit/{skin_id}`   | Atualiza campos da skin base. | **200 OK**      | `{ "float": 0.99 }`                                              | `{ "message": "Skin updated successfully" }` |
| DELETE | `/admin/skin/delete/{skin_id}` | Remove uma skin base.         | **200 OK**      | N/A                                                              | `Skin with id: 10 deleted successfully`      |

---

---

## 6. Exemplos de Requests e Responses

### **Exemplo de Login**

**Request (POST /login)**

```json
{
  "username": "user@example.com",
  "password": "mypassword"
}
```

**Response**

```json
{
  "message": "Login successful",
  "access_token": "...",
  "token_type": "bearer",
  "role": "user"
}
```

### **Exemplo de Depósito na Carteira**

**Request (POST /wallet/deposit)**

```json
{
  "amount": 100.0
}
```

**Response**

```json
{
  "message": "Depósito realizado com sucesso.",
  "new_balance": 250.0
}
```

### **Exemplo de Listagem no Marketplace**

**Request (POST /marketplace/add/skin)**

```json
{
  "skin_id": 52,
  "value": 79.90
}
```

**Response**

```json
{
  "message": "Skin listed successfully.",
  "skin_id": 52
}
```

### **Exemplo de Criação de Skin Base (Admin)**

**Request (POST /admin/skins)**

```json
{
  "name": "Bayonet Lore",
  "float": "Battle scared"
}
```

**Response**

```json
{
  "message": "Base skin created successfully",
  "skin_id": 87
}
```

---

Se desejares, posso também gerar um arquivo **README.md** separado, documentação da base de dados ou diagramas de arquitetura.
