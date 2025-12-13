# 🏗️ Infraestrutura - Anka MFO

## Visão Geral

A infraestrutura está organizada em três camadas principais, totalmente containerizada com Docker e Docker Compose:

```
┌─────────────────────────────────────────────────────────┐
│                    Frontend (Next.js)                   │
│                    Port: 3000                           │
└─────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────┐
│                 Backend (Fastify)                       │
│                 Port: 3333                              │
│         ├─ Controllers                                  │
│         ├─ Services                                     │
│         └─ Repositories                                 │
└─────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────┐
│                Database (PostgreSQL)                    │
│                Port: 5432                               │
│         ├─ Clients                                      │
│         ├─ Simulations                                  │
│         ├─ Allocations                                  │
│         ├─ Transactions                                 │
│         ├─ Insurances                                   │
│         └─ Simulation Versions                          │
└─────────────────────────────────────────────────────────┘
```

## Estrutura de Diretórios

```
Anka - Test/
├── docker-compose.yml          # Orquestração de serviços
├── .env.example                # Variáveis de ambiente (exemplo)
├── Makefile                    # Scripts de desenvolvimento
├── backend/
│   ├── Dockerfile              # Imagem Docker (multi-stage)
│   ├── .dockerignore           # Arquivos ignorados no build
│   ├── package.json            # Dependências Node.js
│   └── src/
│       ├── domain/             # Camada de domínio (entidades)
│       ├── application/        # Camada de aplicação (serviços)
│       └── infra/              # Camada de infraestrutura (repos, db)
├── frontend/
│   ├── Dockerfile              # Imagem Docker (multi-stage)
│   ├── .dockerignore           # Arquivos ignorados no build
│   ├── package.json            # Dependências Node.js
│   └── src/
│       ├── app/                # Next.js App Router
│       ├── components/         # Componentes React
│       ├── hooks/              # React Query hooks
│       ├── types/              # TypeScript types
│       └── styles/             # Tailwind CSS styles
└── database/
    ├── 01-schema.sql           # Schema das tabelas
    └── 02-seed.sql             # Dados de teste
```

## Tabelas do Banco de Dados

### 1. **clients** (Clientes)
- `id` (UUID, PK)
- `name` (VARCHAR) - Nome do cliente
- `email` (VARCHAR, UNIQUE) - Email
- `cpf` (VARCHAR, UNIQUE) - CPF
- `phone` (VARCHAR) - Telefone
- `birthdate` (DATE) - Data de nascimento
- `status` (ENUM: vivo, falecido, incapacidade) - Status de vida
- `created_at` / `updated_at` - Timestamps

### 2. **simulations** (Simulações)
- `id` (UUID, PK)
- `client_id` (FK) - Referência ao cliente
- `name` (VARCHAR) - Nome da simulação
- `description` (TEXT) - Descrição
- `status` (ENUM: rascunho, ativa, arquivada)
- `initial_capital` (DECIMAL) - Capital inicial
- `monthly_contribution` (DECIMAL) - Aporte mensal
- `inflation_rate` (DECIMAL) - Taxa de inflação
- `years_projection` (INT) - Anos de projeção
- `created_at` / `updated_at` - Timestamps

### 3. **allocations** (Alocações)
- `id` (UUID, PK)
- `simulation_id` (FK) - Referência à simulação
- `type` (ENUM: financeira, imovel) - Tipo de alocação
- `description` (VARCHAR) - Descrição
- `percentage` (DECIMAL) - Percentual
- `initial_value` (DECIMAL) - Valor inicial
- `annual_return` (DECIMAL) - Retorno anual esperado
- `created_at` / `updated_at` - Timestamps

### 4. **transactions** (Movimentações)
- `id` (UUID, PK)
- `allocation_id` (FK) - Referência à alocação
- `type` (ENUM: aporte, resgate, rendimento, taxa)
- `amount` (DECIMAL) - Valor
- `description` (TEXT) - Descrição
- `transaction_date` (DATE) - Data
- `created_at` / `updated_at` - Timestamps

### 5. **insurances** (Seguros)
- `id` (UUID, PK)
- `simulation_id` (FK) - Referência à simulação
- `type` (VARCHAR) - Tipo de seguro
- `description` (TEXT) - Descrição
- `coverage_amount` (DECIMAL) - Valor coberto
- `monthly_cost` (DECIMAL) - Custo mensal
- `start_date` (DATE) - Data inicial
- `end_date` (DATE, NULLABLE) - Data final
- `created_at` / `updated_at` - Timestamps

### 6. **simulation_versions** (Histórico de Simulações)
- `id` (UUID, PK)
- `simulation_id` (FK) - Referência à simulação
- `version_number` (INT) - Número da versão
- `snapshot` (JSONB) - Snapshot dos dados
- `created_at` - Data de criação

### 7. **users** (Usuários - Fase 8)
- `id` (UUID, PK)
- `email` (VARCHAR, UNIQUE)
- `password_hash` (VARCHAR)
- `role` (VARCHAR: admin, assessor)
- `active` (BOOLEAN)
- `created_at` / `updated_at` - Timestamps

## Serviços Docker

### PostgreSQL (postgres)
- **Imagem**: `postgres:15-alpine`
- **Porta**: 5432
- **Variáveis**:
  - `POSTGRES_DB`: Nome do banco (padrão: anka)
  - `POSTGRES_USER`: Usuário (padrão: postgres)
  - `POSTGRES_PASSWORD`: Senha (padrão: postgres)
- **Volume**: `postgres_data` - Persistência de dados
- **Health Check**: Verifica a disponibilidade via `pg_isready`

### Backend (backend)
- **Imagem**: Build local (Dockerfile multi-stage)
- **Porta**: 3333
- **Dependências**: Aguarda o PostgreSQL estar saudável
- **Volume**: `./backend/src` - Hot reload em desenvolvimento
- **Environment**: Configurações de banco, JWT, etc.

### Frontend (frontend)
- **Imagem**: Build local (Dockerfile multi-stage)
- **Porta**: 3000
- **Dependências**: Aguarda o backend
- **Volume**: `./frontend/src` - Hot reload em desenvolvimento
- **Environment**: URL da API

## Variáveis de Ambiente

Copiar `.env.example` para `.env`:

```bash
# Database
DB_HOST=postgres
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=anka

# Node
NODE_ENV=development

# API
API_PORT=3333
JWT_SECRET=your-secret-key-change-in-production

# Frontend
NEXT_PUBLIC_API_URL=http://localhost:3333
```

**⚠️ Importante**: Em produção, alterar `JWT_SECRET`, `DB_PASSWORD` e outras credenciais.

## Comandos Disponíveis

```bash
# Iniciar desenvolvimento
make dev              # Inicia todos os serviços e mostra logs

# Gerenciar containers
make up               # Inicia containers
make down             # Para containers
make logs             # Mostra logs (todos os serviços)
make logs-backend     # Logs do backend
make logs-frontend    # Logs do frontend
make logs-db          # Logs do database

# Banco de dados
make db-reset         # Reinicia o banco
make db-seed          # Insere dados de teste
make db-shell         # Abre shell do PostgreSQL

# Testes e validação
make validate         # Valida infraestrutura
make test             # Executa testes
make test-backend     # Testes do backend

# Limpeza
make clean            # Remove containers e volumes
make clean-all        # Remove tudo (incluindo imagens)
```

## Fluxo de Inicialização

1. **Docker Compose inicia o PostgreSQL**
   - Aguarda o container estar pronto
   - Health check monitora disponibilidade

2. **Scripts de inicialização do banco**
   - `01-schema.sql` cria tabelas, tipos e índices
   - `02-seed.sql` insere dados de teste

3. **Backend inicia (dependente do PostgreSQL)**
   - Conecta ao banco
   - Inicia servidor na porta 3333
   - Health check exposto em `/health`

4. **Frontend inicia (dependente do backend)**
   - Conecta à API backend
   - Inicia servidor Next.js na porta 3000
   - Configuração de dark mode

## Validação

Para validar se tudo está funcionando:

```bash
# Verificar status dos containers
docker compose ps

# Testar conexão ao banco
curl postgres:5432 && echo "✅ DB OK"

# Testar API
curl http://localhost:3333/health

# Testar Frontend
curl http://localhost:3000
```

## Princípios Aplicados

✅ **KISS** - Estrutura simples e direta
✅ **SOLID** - Separação em camadas (domain, application, infra)
✅ **DRY** - Reutilização de componentes e configurações
✅ **Docker First** - Reproducibilidade e portabilidade
✅ **Health Checks** - Monitoramento de status
✅ **Multi-stage Builds** - Otimização de imagens

## Próximos Passos

1. ✅ Infraestrutura criada (Fase 1)
2. ⏭️ Backend - Estrutura inicial (Fase 2)
3. ⏭️ Motor de Projeção (Fase 3)
4. ⏭️ API REST (Fase 4)
5. ⏭️ Frontend Setup (Fase 5)
6. ⏭️ Frontend Screens (Fase 6)
7. ⏭️ Integração (Fase 7)
8. ⏭️ Diferenciais (Fase 8)

Consulte [ROADMAP.md](../ROADMAP.md) para visão geral do projeto.
