# 🏥 API UBS - Padrão RESTful

Documentação das rotas e padrões da API do **Sistema UBS**, desenvolvida com arquitetura **RESTful**, autenticação via **JWT** e boas práticas de versionamento e segurança.

---

## 🔐 Autenticação

| Método | Rota | Descrição |
|:--|:--|:--|
| `POST` | `/api/auth/login` | Login (retorna token JWT) |
| `POST` | `/api/auth/reset-password` | Redefinir senha (CPF + nova senha) |

---

## 👤 Usuários

| Método | Rota | Descrição |
|:--|:--|:--|
| `POST` | `/api/usuarios` | Criar novo usuário |
| `GET` | `/api/usuarios/:id` | Buscar usuário por ID |
| `PUT` | `/api/usuarios/:id` | Atualizar usuário |
| `DELETE` | `/api/usuarios/:id` | Desativar usuário (soft delete) |
| `GET` | `/api/usuarios/cpf/:cpf` | Buscar usuário por CPF |
| `GET` | `/api/usuarios/me` | Retorna dados do usuário logado |

---

## 🧍‍♀️ Pacientes

| Método | Rota | Descrição |
|:--|:--|:--|
| `POST` | `/api/pacientes` | Cadastrar paciente (cria usuário + paciente + prontuário) |
| `GET` | `/api/pacientes` | Listar pacientes (com paginação) |
| `GET` | `/api/pacientes/:id` | Buscar paciente por ID |
| `PUT` | `/api/pacientes/:id` | Atualizar dados |
| `DELETE` | `/api/pacientes/:id` | Desativar paciente |
| `GET` | `/api/pacientes/sus/:cartao` | Buscar por cartão SUS |
| `GET` | `/api/pacientes/:id/prontuario` | Ver prontuário completo |

---

## 🩺 Profissionais

| Método | Rota | Descrição |
|:--|:--|:--|
| `POST` | `/api/profissionais` | Cadastrar profissional |
| `GET` | `/api/profissionais` | Listar profissionais (filtro por especialidade) |
| `GET` | `/api/profissionais/:id` | Buscar profissional por ID |
| `PUT` | `/api/profissionais/:id` | Atualizar profissional |
| `DELETE` | `/api/profissionais/:id` | Desativar profissional |
| `GET` | `/api/profissionais/:id/agenda` | Ver agenda do profissional |

---

## 🧠 Especialidades

| Método | Rota | Descrição |
|:--|:--|:--|
| `GET` | `/api/especialidades` | Listar todas as especialidades |
| `POST` | `/api/especialidades` | Criar especialidade (admin) |
| `PUT` | `/api/especialidades/:id` | Atualizar especialidade (admin) |
| `DELETE` | `/api/especialidades/:id` | Desativar especialidade (admin) |

---

## 📅 Consultas

| Método | Rota | Descrição |
|:--|:--|:--|
| `POST` | `/api/consultas` | Agendar consulta |
| `GET` | `/api/consultas` | Listar consultas (filtros: data, status, profissional) |
| `GET` | `/api/consultas/:id` | Buscar consulta por ID |
| `PUT` | `/api/consultas/:id` | Atualizar (remarcar) |
| `PUT` | `/api/consultas/:id/status` | Atualizar status (confirmar, cancelar, realizar) |
| `DELETE` | `/api/consultas/:id` | Cancelar consulta |
| `GET` | `/api/consultas/paciente/:id` | Consultas de um paciente |
| `GET` | `/api/consultas/profissional/:id` | Consultas de um profissional |
| `GET` | `/api/consultas/disponiveis` | Ver horários disponíveis (`?profissional_id=1&data=2025-11-25`) |

---

## 🩻 Prontuários

| Método | Rota | Descrição |
|:--|:--|:--|
| `GET` | `/api/prontuarios/:id` | Ver prontuário completo |
| `PUT` | `/api/prontuarios/:id` | Atualizar informações gerais |
| `PUT` | `/api/prontuarios/:id/obito` | Registrar óbito |

---

## 🕒 Histórico de Atendimentos

| Método | Rota | Descrição |
|:--|:--|:--|
| `POST` | `/api/historico` | Criar registro de atendimento |
| `GET` | `/api/historico/:id` | Buscar registro específico |
| `PUT` | `/api/historico/:id` | Atualizar registro |
| `GET` | `/api/historico/prontuario/:id` | Histórico completo de um prontuário |
| `GET` | `/api/historico/paciente/:id` | Histórico por paciente |

---

## 💊 Receitas

| Método | Rota | Descrição |
|:--|:--|:--|
| `POST` | `/api/receitas` | Criar receita |
| `GET` | `/api/receitas/:id` | Buscar receita por ID |
| `GET` | `/api/receitas/historico/:id` | Receitas de um atendimento |
| `GET` | `/api/receitas/paciente/:id` | Todas as receitas de um paciente |
| `PUT` | `/api/receitas/:id` | Atualizar receita |
| `DELETE` | `/api/receitas/:id` | Remover receita |

**Medicamentos da receita:**

| Método | Rota | Descrição |
|:--|:--|:--|
| `POST` | `/api/receitas/:id/medicamentos` | Adicionar medicamento |
| `PUT` | `/api/receitas/:id/medicamentos/:med_id` | Atualizar medicamento |
| `DELETE` | `/api/receitas/:id/medicamentos/:med_id` | Remover medicamento |

---

## 🧬 Tratamentos

| Método | Rota | Descrição |
|:--|:--|:--|
| `POST` | `/api/tratamentos` | Criar tratamento |
| `GET` | `/api/tratamentos/:id` | Buscar tratamento por ID |
| `PUT` | `/api/tratamentos/:id` | Atualizar tratamento |
| `PUT` | `/api/tratamentos/:id/status` | Atualizar status (concluir/interromper) |
| `DELETE` | `/api/tratamentos/:id` | Remover tratamento |
| `GET` | `/api/tratamentos/historico/:id` | Tratamentos de um atendimento |
| `GET` | `/api/tratamentos/paciente/:id` | Todos tratamentos de um paciente |
| `GET` | `/api/tratamentos/ativos/:paciente_id` | Tratamentos em andamento |

---

## 📊 Relatórios e Dashboards

| Método | Rota | Descrição |
|:--|:--|:--|
| `GET` | `/api/relatorios/consultas` | Relatório de consultas |
| `GET` | `/api/relatorios/profissional/:id` | Estatísticas do profissional |
| `GET` | `/api/relatorios/pacientes` | Estatísticas gerais de pacientes |
| `GET` | `/api/relatorios/especialidades` | Consultas por especialidade |

---

## 🔍 Busca e Filtros

| Método | Rota | Descrição |
|:--|:--|:--|
| `GET` | `/api/busca/pacientes` | Buscar pacientes (`?nome=maria&cpf=123`) |
| `GET` | `/api/busca/profissionais` | Buscar profissionais |
| `GET` | `/api/busca/consultas` | Buscar consultas |

---

## ⚙️ Padrões e Boas Práticas

- Pode usar `/:id` nas rotas de update (ex: `PUT /api/usuarios/:id`)
- **Métodos HTTP:**
  - `GET` → Buscar/Listar
  - `POST` → Criar
  - `PUT` → Atualizar completo
  - `PATCH` → Atualizar parcial
  - `DELETE` → Remover/Desativar
- **Query params (filtros):**
  ```
  GET /api/consultas?data=2025-11-25&status=AGENDADA&profissional_id=1
  GET /api/pacientes?page=1&limit=20&ordem=nome
  ```
- **Versionamento (futuro):**
  ```
  /api/v1/consultas
  /api/v2/consultas
  ```

---

## 📦 Exemplos de Payload (JSON)

```json
POST /api/auth/login
{
  "cpf": "12345678901",
  "senha": "senha123"
}
```

```json
POST /api/pacientes
{
  "nome_completo": "João Silva",
  "cpf": "12345678901",
  "email": "joao@email.com",
  "telefone": "81987654321",
  "data_nascimento": "1990-05-15",
  "endereco": "Rua A, 123",
  "cartao_sus": "123456789012345",
  "tipo_sanguineo": "O+",
  "alergias": "Nenhuma"
}
```

```json
POST /api/consultas
{
  "id_paciente": 2,
  "id_profissional": 1,
  "data_consulta": "2025-11-25",
  "hora_consulta": "09:00",
  "motivo_consulta": "Dor de cabeça"
}
```

```json
POST /api/historico
{
  "id_consulta": 1,
  "queixa_principal": "Cefaleia intensa há 3 dias",
  "exame_fisico": "PA: 120/80, Tax: 36.5°C",
  "hipotese_diagnostica": "Enxaqueca",
  "diagnostico_final": "Migrânea sem aura",
  "conduta": "Prescrição de analgésico, repouso"
}
```

```json
PUT /api/consultas/:id/status
{
  "status": "REALIZADA"
}
```

```json
GET /api/consultas/disponiveis?profissional_id=1&data=2025-11-25
{
  "profissional": "Dr. Carlos",
  "data": "2025-11-25",
  "horarios_disponiveis": ["08:00", "08:30", "09:00", "10:00", "14:00"],
  "horarios_ocupados": ["09:30", "11:00", "15:00"]
}
```

---

## 📡 Códigos de Resposta HTTP

| Código | Significado |
|:--|:--|
| `200 OK` | Sucesso (GET, PUT) |
| `201 Created` | Criado com sucesso (POST) |
| `204 No Content` | Sucesso sem retorno (DELETE) |
| `400 Bad Request` | Dados inválidos |
| `401 Unauthorized` | Não autenticado |
| `403 Forbidden` | Sem permissão |
| `404 Not Found` | Recurso não encontrado |
| `409 Conflict` | Conflito (ex: horário já ocupado) |
| `422 Unprocessable Entity` | Falha de validação |
| `500 Internal Server Error` | Erro no servidor |

---

## 🔒 Autenticação e Autorização

Todas as rotas (exceto `/login` e `/register`) exigem:
```
Header: Authorization: Bearer <token_jwt>
```

**Permissões por perfil:**

| Perfil | Acesso |
|:--|:--|
| PACIENTE | Pode ver/editar seus dados e agendar consultas |
| PROFISSIONAL | Pode ver agenda, registrar atendimentos e prescrever |
| ADMIN | Acesso total ao sistema |

---

## 📑 Paginação (Exemplo)

```
GET /api/pacientes?page=1&limit=20
```

```json
{
  "data": [...],
  "pagination": {
    "total": 150,
    "page": 1,
    "limit": 20,
    "pages": 8
  }
}
```
