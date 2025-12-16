# 🐳 Fase 1 - Infraestrutura (Docker + Database)

## 📋 Objetivo
Configurar toda a infraestrutura base do projeto com Docker, incluindo PostgreSQL, estrutura de diretórios e configurações iniciais.

---

## 🎯 Entregáveis desta Fase
 
 - [x] Estrutura de diretórios criada
 - [x] docker-compose.yml configurado
 - [x] PostgreSQL rodando e acessível
 - [x] Scripts de inicialização do banco
 - [x] Dockerfiles base para backend e frontend

---

## 📝 Prompt 1.1 - Estrutura Base

```markdown
Crie a estrutura de diretórios base para o projeto MFO (Multi Family Office) seguindo esta organização:

/anka-mfo
├── docker-compose.yml
├── .env.example
├── backend/
│   ├── Dockerfile
│   ├── package.json
│   ├── tsconfig.json
│   ├── .env.example
│   └── src/
│       ├── server.ts
│       └── app.ts
├── frontend/
│   ├── Dockerfile
│   └── (será configurado na fase 5)
└── database/
    ├── init.sql
    └── seed.sql

Requisitos:
- Use Node 20 LTS como base
- PostgreSQL 15
- Configure volumes para persistência do banco
- Exponha as portas: 3000 (frontend), 3333 (backend), 5432 (postgres)
```

---

## 📝 Prompt 1.2 - Docker Compose

```markdown
Crie o arquivo docker-compose.yml com os seguintes serviços:

1. **postgres**
   - Imagem: postgres:15-alpine
   - Variáveis: POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB
   - Volume para persistência
   - Script de inicialização em /docker-entrypoint-initdb.d/
   - Healthcheck configurado

2. **backend**
   - Build do Dockerfile local
   - Depende do postgres (com healthcheck)
   - Hot-reload para desenvolvimento
   - Variáveis de ambiente para conexão com banco

3. **frontend**
   - Build do Dockerfile local
   - Depende do backend
   - Hot-reload para desenvolvimento

Crie também o .env.example com todas as variáveis necessárias.

Princípios:
- KISS: Configuração mínima necessária
- Use networks para isolar serviços
```

---

## 📝 Prompt 1.3 - Schema do Banco de Dados

```markdown
Crie o script SQL de inicialização (init.sql) com o seguinte schema:

### Tabelas Principais:

1. **clients** (Clientes)
   - id (UUID, PK)
   - name
   - email
   - created_at, updated_at

2. **simulations** (Simulações/Planos)
   - id (UUID, PK)
   - client_id (FK)
   - name (único por cliente)
   - start_date
   - interest_rate (taxa de juros reais)
   - inflation_rate (inflação)
   - life_status (ENUM: normal, dead, invalid)
   - is_current (boolean - indica se é a situação atual/realizado)
   - created_at, updated_at

3. **simulation_versions** (Versões das Simulações)
   - id (UUID, PK)
   - simulation_id (FK)
   - version_number
   - parameters (JSONB - snapshot dos parâmetros)
   - projection_data (JSONB - dados calculados)
   - created_at

4. **allocations** (Alocações)
   - id (UUID, PK)
   - client_id (FK)
   - reference_date (data da fotografia)
   - type (ENUM: financial, property)
   - name
   - value
   - is_financed (boolean)
   - financing_data (JSONB - dados do financiamento se aplicável)
   - created_at, updated_at

5. **transactions** (Movimentações)
   - id (UUID, PK)
   - client_id (FK)
   - type (ENUM: income, expense, deposit, withdrawal)
   - category
   - name
   - value
   - is_recurring
   - recurrence_start
   - recurrence_end
   - recurrence_interval (monthly, yearly, etc)
   - created_at, updated_at

6. **insurances** (Seguros)
   - id (UUID, PK)
   - client_id (FK)
   - type (ENUM: life, disability)
   - name
   - start_date
   - duration_months
   - monthly_premium
   - coverage_value
   - created_at, updated_at

### Índices e Constraints:
- Índices em todas as FKs
- Constraint unique em (simulation.client_id, simulation.name)
- Trigger para atualizar updated_at

### Princípios:
- KISS: Apenas campos essenciais
- Usar JSONB para dados flexíveis (evita over-engineering)
- UUIDs para IDs (mais seguro para APIs públicas)
```

---

## 📝 Prompt 1.4 - Seed de Dados

```markdown
Crie o script seed.sql com dados iniciais para teste:

1. **1 Cliente de exemplo**
   - Nome: "João da Silva"
   - Email: "joao@exemplo.com"

2. **1 Situação Atual (Realizado)**
   - Simulação marcada como is_current = true
   - Representa o estado real do cliente

3. **2 Simulações de exemplo**
   - "Plano Conservador" (juros 3%, inflação 4%)
   - "Plano Agressivo" (juros 6%, inflação 4%)

4. **Alocações de exemplo (em 2 datas diferentes)**
   - Data 1: 01/01/2024
     - R$ 100.000 em CDB
     - R$ 50.000 em Fundos
     - Apartamento de R$ 500.000
   - Data 2: 01/06/2024
     - R$ 120.000 em CDB
     - R$ 60.000 em Fundos
     - Apartamento de R$ 520.000

5. **Movimentações recorrentes**
   - Salário: R$ 15.000/mês (2024-2045)
   - Despesas: R$ 8.000/mês (2024-2070)
   - Aporte: R$ 3.000/mês (2024-2045)

6. **1 Seguro de vida**
   - Prêmio: R$ 500/mês
   - Cobertura: R$ 1.000.000
   - Duração: 240 meses
```

---

## ✅ Validação da Fase 1

Execute os seguintes comandos para validar:

```bash
# Subir infraestrutura
docker compose up -d postgres

# Verificar se PostgreSQL está rodando
docker compose exec postgres psql -U mfo -d mfo_db -c "\dt"

# Verificar dados do seed
docker compose exec postgres psql -U mfo -d mfo_db -c "SELECT * FROM clients;"

# Verificar logs
docker compose logs -f postgres
```

### Critérios de Sucesso:
- [ ] Containers sobem sem erros
- [ ] Tabelas criadas corretamente
- [ ] Dados do seed inseridos
- [ ] Conexão externa funcionando (porta 5432)

---

## 📚 Arquivos Criados nesta Fase

```
anka-mfo/
├── docker-compose.yml
├── .env.example
├── .gitignore
├── database/
│   ├── init.sql
│   └── seed.sql
├── backend/
│   ├── Dockerfile
│   ├── package.json (mínimo)
│   └── .env.example
└── frontend/
    └── Dockerfile (placeholder)
```

---

## 🔄 Próxima Fase

Após validar todos os checkpoints, siga para:
**[Fase 2 - Backend Estrutura](./02-backend-estrutura.md)**
