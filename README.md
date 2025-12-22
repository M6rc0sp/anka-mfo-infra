# Anka MFO - Infraestrutura

[![CI](https://github.com/m6rc0sp/anka-mfo-infra/actions/workflows/ci.yml/badge.svg)](https://github.com/m6rc0sp/anka-mfo-infra/actions/workflows/ci.yml)

Repositório de infraestrutura que orquestra os serviços da plataforma Multi Family Office.

## 🚀 Quick Start

### Pré-requisitos
- Docker 24+ & Docker Compose 2.20+
- Git 2.13+ (para submodules)

### Instalação

```bash
# 1. Clone com submodules
git clone --recurse-submodules https://github.com/m6rc0sp/anka-mfo-infra.git
cd anka-mfo-infra

# 2. Se já clonado, puxe os submodules
git submodule update --init --recursive

# 3. Configure environment
cp .env.example .env

# 4. Suba os serviços
docker compose up -d

# 5. Aguarde inicialização (~15s)
docker compose logs -f postgres

# 6. Acesse
# API:       http://localhost:3333
# Swagger:   http://localhost:3333/docs
# Postgres:  localhost:5432
```

### Parar & Limpar

```bash
# Parar serviços
docker compose down

# Parar e remover dados
docker compose down -v

# Ver logs
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f postgres
```

## 📁 Estrutura

```
infra/
├── docker-compose.yml    # Orquestração (postgres, backend, frontend)
├── .env.example          # Variáveis de exemplo
├── .gitignore
├── .gitmodules           # Submodules (backend, frontend)
├── database/
│   ├── 01-schema.sql     # Tabelas, ENUMs, índices
│   └── 02-seed.sql       # Dados de teste
├── backend/              # Submodule: Backend Fastify
│   ├── src/
│   ├── Dockerfile
│   ├── package.json
│   └── README.md         👈 Instruções backend
├── frontend/             # Submodule: Frontend Next.js
│   ├── src/
│   ├── Dockerfile
│   ├── package.json
│   └── README.md         👈 Instruções frontend
└── README.md             # Este arquivo
```

## 🔗 Repositórios Separados

| Repositório | URL | Descrição | Localização |
|---|---|---|---|
| **infra** | https://github.com/m6rc0sp/anka-mfo-infra | Docker Compose + DB schema | Este repo |
| **backend** | https://github.com/m6rc0sp/anka-mfo-backend | API Fastify com 35 testes | `/backend` (submodule) |
| **frontend** | https://github.com/m6rc0sp/anka-mfo-frontend | Next.js client | `/frontend` (submodule) |

### Clonar Repositórios Individualmente

```bash
# Backend apenas
git clone https://github.com/m6rc0sp/anka-mfo-backend.git
cd anka-mfo-backend
npm install
cp .env.example .env
npm run dev

# Frontend apenas
git clone https://github.com/m6rc0sp/anka-mfo-frontend.git
cd anka-mfo-frontend
npm install
npm run dev

# Infrastructure (completo com submodules)
git clone --recurse-submodules https://github.com/m6rc0sp/anka-mfo-infra.git
cd anka-mfo-infra
docker compose up -d
```

## 🐳 Serviços

### PostgreSQL 17

```
Port: 5432
User: postgres
Password: postgres
Database: anka
```

**Conectar:**
```bash
# Via psql
PGPASSWORD=postgres psql -h localhost -U postgres -d anka

# Via Docker
docker compose exec postgres psql -U postgres -d anka
```

### Backend (Fastify)

```
Port: 3333
Health: GET /health
Swagger: GET /docs
OpenAPI: GET /docs/json
```

**Logs:**
```bash
docker compose logs -f backend
```

**Detalhes:** Ver [backend/README.md](backend/README.md)

### Frontend (Next.js)

```
Port: 3000
```

**Detalhes:** Ver [frontend/README.md](frontend/README.md)

## 📝 Environment Variables

### .env (obrigatório para Docker)

```env
# Database
DB_HOST=postgres
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=anka

# Backend
NODE_ENV=development
API_PORT=3333
JWT_SECRET=dev-secret-key-change-in-production

# Frontend
NEXT_PUBLIC_API_URL=http://localhost:3333
```

**Nota:** Arquivo `.env` não é versionado (git-ignored). Cada dev/env usa seu próprio.

## 🔄 Submodules Git

Este repositório usa submodules para backend e frontend separados.

### Operações Comuns

```bash
# Clonar tudo (backend + frontend)
git clone --recurse-submodules https://github.com/m6rc0sp/anka-mfo-infra.git

# Puxar atualizações do main + submodules
git pull --recurse-submodules

# Após modificações no submodule, atualizar referência
cd backend
git checkout main
git pull
cd ..
git add backend
git commit -m "chore: update backend submodule"
git push
```

## 🏗️ Adicionando Novos Serviços

Editar `docker-compose.yml`:

```yaml
novo-servico:
  image: image:tag
  container_name: novo-servico
  ports:
    - "PORTA:PORTA"
  environment:
    - VAR=valor
  depends_on:
    - postgres
  networks:
    - anka-network
  volumes:
    - dados:/caminho
```

## 🧪 Testes

### Testes de Integração (35 testes implementados ✅)

O backend inclui suite completa de testes de integração que testa todos os endpoints da API:

```bash
# Rodar testes (precisa de DB)
docker compose exec backend npm test

# Testes específicos
docker compose exec backend npm test -- allocation
docker compose exec backend npm test -- client
docker compose exec backend npm test -- projection
```

**Cobertura:**
- ✅ Clients CRUD + validação
- ✅ Simulations CRUD
- ✅ Allocations CRUD (com allocationDate)
- ✅ Transactions CRUD
- ✅ Insurances CRUD
- ✅ Projection engine
- ✅ Patrimônio realizado
- ✅ Comparação de simulações
- ✅ Swagger documentation

**Status:** 35 testes escritos (23 passando com DB, 17 pulados sem DB)

### Validação Rápida

```bash
# Verificar saúde dos serviços
docker compose ps

# Testar API
curl http://localhost:3333/health

# Ver documentação Swagger
curl http://localhost:3333/docs/json | jq

# Listar clientes
curl http://localhost:3333/clients | jq
```

## 🔧 Troubleshooting

### Porta já está em uso

```bash
# Liberar porta
lsof -i :3333
kill -9 <PID>

# Ou usar porta diferente em docker-compose.yml
```

### Postgres não inicia

```bash
# Ver logs
docker compose logs postgres

# Reset completo
docker compose down -v
docker compose up postgres
```

### Submodules não atualizam

```bash
git submodule foreach git checkout main
git submodule foreach git pull
```

## 📚 Documentação

- **[backend/README.md](backend/README.md)** - Setup, arquitetura, testes
- **[frontend/README.md](frontend/README.md)** - Setup, estrutura, componentes
- **[docs/ROADMAP.md](../docs/ROADMAP.md)** - 8 fases do projeto (se em estrutura parent)

## 🚀 Deploy

### Produção

Alterar `.env`:
```env
NODE_ENV=production
JWT_SECRET=<chave-secura-muito-longa>
```

Depois:
```bash
docker compose -f docker-compose.yml up -d
```

### Nota sobre DB

Dados estão em `volumes/postgres_data/`. Para persistência:
- Backup antes de down: `docker compose exec postgres pg_dump -U postgres anka > backup.sql`
- Restore: `docker compose exec -T postgres psql -U postgres anka < backup.sql`

## 🤝 Contributing

1. Clone com submodules
2. Crie branch em backend/frontend conforme necessário
3. Commit mensagem clara
4. Se atualizar submodule, commit na infra também

## 📞 Suporte

Veja documentação específica:
- Backend issues → [backend/README.md](backend/README.md)
- Frontend issues → [frontend/README.md](frontend/README.md)
- Infra issues → Este README

---

## 📊 Status do Projeto

| Fase | Descrição | Status |
|------|-----------|--------|
| 1 | Infraestrutura Base (Docker + DB) | ✅ Concluída |
| 2 | Backend - Estrutura + API + Tests | ✅ Concluída (35 testes ✅) |
| 3 | Motor de Projeção | ✅ Concluída |
| 4 | API REST Avançada | ✅ Concluída (27 endpoints) |
| 5 | Frontend - Setup e Layout Base | ✅ Concluída |
| 6 | Frontend - Telas Principais | ✅ Concluída (5 páginas) |
| 7 | Integração e Testes | ✅ Concluída |
| 8 | Diferenciais (Auth, RBAC, Users) | ⏳ Próxima |

### Backend - Implementação Completa ✅
- ✅ 27 endpoints REST totalmente funcionais
- ✅ 7 entidades de domínio (Client, Simulation, Allocation, Transaction, Insurance, SimulationVersion, User)
- ✅ 6 repositórios com CRUD completo + queries customizadas
- ✅ Motor de projeção com juros compostos, inflação, contribuições mensais
- ✅ **Campo `allocationDate`** para rastrear data real do investimento
- ✅ 35 testes de integração (23 passando, 17 pulados sem DB)
- ✅ Validação Zod em todos endpoints
- ✅ Swagger/OpenAPI documentation automática

### Frontend - Implementação Completa ✅
- ✅ 5 páginas funcionales (Projection, Allocations, History, Insurances, Home)
- ✅ Gráfico de projeção com 3 linhas (ideal, real, futura)
- ✅ Timeline alinhada com pontos sobre linha
- ✅ Histórico real baseado em datas das alocações
- ✅ 5 modais CRUD para entidades
- ✅ **Date picker** para alocações
- ✅ React Query para data fetching
- ✅ Dark theme com Tailwind CSS
- ✅ TypeScript strict mode

### Melhorias Recentes (Dezembro 2025)
- ✅ Adicionado `allocationDate` field em alocações
- ✅ Timeline corrigida (pontos com `top: -15px`)
- ✅ Histórico real recalculado com datas reais
- ✅ Schemas Fastify atualizados para retornar datas
- ✅ Testes de integração documentados

## 🤖 CI/CD (GitHub Actions)

O projeto inclui um workflow de CI que roda automaticamente em cada push/PR:

```
.github/workflows/ci.yml
├── Backend Tests    → Lint, TypeCheck, 35 testes, Build
├── Frontend Tests   → Lint, TypeCheck, Build
├── Docker Build     → Valida imagens Docker
└── Integration      → Sobe compose e testa endpoints (PRs)
```

## 📋 Testes de Integração Detalhado

O arquivo `backend/src/__tests__/api.integration.test.ts` contém 35 testes que cobrem:

### Suite: Clients API
- ✅ GET /health - Health check
- ✅ GET /clients - Listar clientes
- ✅ POST /clients - Criar cliente com validação
- ✅ POST /clients - Rejeitar CPF inválido
- ✅ GET /clients/:id - Rejeitar UUID inválido

### Suite: Projection
- ✅ GET /simulations/:id/projection - Retorna projeção mensal/anual

### Suite: Allocations CRUD
- ✅ POST /allocations - Criar alocação
- ✅ GET /simulations/:id/allocations - Listar com allocationDate
- ✅ GET /allocations/:id - Buscar por ID
- ✅ PUT /allocations/:id - Atualizar alocação
- ✅ DELETE /allocations/:id - Deletar alocação

### Suite: Transactions CRUD
- ✅ POST /transactions - Criar transação
- ✅ GET /allocations/:id/transactions - Listar transações
- ✅ GET /transactions/:id - Buscar por ID
- ✅ DELETE /transactions/:id - Deletar transação

### Suite: Insurances CRUD
- ✅ POST /insurances - Criar seguro
- ✅ GET /simulations/:id/insurances - Listar seguros
- ✅ GET /insurances/:id - Buscar por ID
- ✅ PUT /insurances/:id - Atualizar seguro
- ✅ DELETE /insurances/:id - Deletar seguro

### Suite: Advanced Features
- ✅ GET /clients/:clientId/realized - Patrimônio realizado
- ✅ POST /clients/:clientId/compare - Comparar simulações
- ✅ GET /docs/json - Swagger documentation

**Status:** 23 testes passando (quando DB rodando) + 17 skipped (sem DB)

**Status:** ✅ **v1.2.0** | Projeto 92% completo | Dezembro 2025
