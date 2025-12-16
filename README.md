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
git clone --recurse-submodules <repo-url>
cd infra

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

| Repositório | Descrição | Localização |
|---|---|---|
| **backend** | API Fastify com tests | `/backend` (submodule) |
| **frontend** | Next.js client | `/frontend` (submodule) |
| **infra** | Docker Compose + DB | Este repo |

### Clonar Repositórios Individualmente

```bash
# Backend apenas
git clone <backend-repo-url>
cd backend
npm install
cp .env.example .env
npm run dev

# Frontend apenas
git clone <frontend-repo-url>
cd frontend
npm install
npm run dev
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
git clone --recurse-submodules <repo-url>

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

## 🧪 Validação

```bash
# Verificar saúde dos serviços
docker compose ps

# Testar API
curl http://localhost:3333/health

# Rodar testes (backend)
docker compose exec backend npm test
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
| 2 | Backend - Estrutura + API + Tests | ✅ Concluída |
| 3 | Motor de Projeção | ✅ Concluída |
| 4 | API REST Avançada | ✅ Concluída |
| 5 | Frontend - Setup e Layout Base | 🔄 Em progresso |
| 6 | Frontend - Telas Principais | 🔄 Em progresso |
| 7 | Integração e Testes E2E | ⏳ Pendente |
| 8 | Diferenciais (Auth, RBAC) | ⏳ Pendente |

### Backend (35 testes passando ✅)
- ✅ 7 Entidades de domínio (Client, Simulation, Allocation, Transaction, Insurance, SimulationVersion, User)
- ✅ 6 Repositories com CRUD completo
- ✅ Motor de projeção com juros compostos, seguros e status de vida
- ✅ API REST documentada com Swagger
- ✅ Validação Zod em todos endpoints

### Frontend
- ✅ Next.js 16 configurado
- ✅ Tailwind CSS 3.4 (LTS)
- ✅ React Query para gerenciamento de estado
- 🔄 Tela de Projeção (layout base implementado)

## 🤖 CI/CD (GitHub Actions)

O projeto inclui um workflow de CI que roda automaticamente em cada push/PR:

```
.github/workflows/ci.yml
├── Backend Tests    → Lint, TypeCheck, 35 testes, Build
├── Frontend Tests   → Lint, TypeCheck, Build
├── Docker Build     → Valida imagens Docker
└── Integration      → Sobe compose e testa endpoints (PRs)
```

**Status:** ✅ Fase 5 Em Progresso | **v1.1.0** | Dezembro 2025
