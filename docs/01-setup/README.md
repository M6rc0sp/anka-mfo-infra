# 🏢 Anka MFO - Multi Family Office Platform

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Node.js](https://img.shields.io/badge/node-20%2B-green)](https://nodejs.org/)
[![Docker](https://img.shields.io/badge/docker-✓-blue)](https://www.docker.com/)
[![TypeScript](https://img.shields.io/badge/typescript-5-blue)](https://www.typescriptlang.org/)

Plataforma completa para gestão de Family Office com projeções financeiras avançadas, alocação inteligente e análise de cenários.

## 📋 Visão Geral

Anka é uma solução integral para Multi Family Office que permite:

- 📊 **Projeções Financeiras** com motor de cálculo sofisticado
- 💰 **Alocação de Ativos** com tipos financeiros e imóveis
- 📈 **Análise de Cenários** comparativos
- 🛡️ **Gestão de Seguros** (vida, invalidez, cobertura)
- 📱 **Dashboard Intuitivo** em tempo real
- 🔐 **Autenticação e RBAC** para múltiplos usuários

## 🚀 Começar Rápido

### Pré-requisitos

- **Docker** 20.10+
- **Docker Compose** (ou Docker Desktop)
- **Make** (opcional, para scripts)
- **Node.js 20+** (se rodar sem Docker)

### Setup Rápido (Docker)

```bash
# 1. Clonar/Acessar o projeto
cd Anka\ -\ Test

# 2. Copiar variáveis de ambiente
cp .env.example .env

# 3. Iniciar todos os serviços
docker compose up -d

# 4. Aguardar ~30 segundos para inicialização
sleep 30

# 5. Acessar
echo "Frontend: http://localhost:3000"
echo "Backend API: http://localhost:3333"
echo "Database: localhost:5432"
```

### Setup com Make

```bash
# Ver todos os comandos disponíveis
make help

# Iniciar em desenvolvimento
make dev

# Parar serviços
make down

# Limpar tudo
make clean
```

## 📂 Estrutura do Projeto

```
Anka - Test/
├── backend/                    # API Fastify + Node.js
│   ├── src/
│   │   ├── domain/            # Entidades e lógica de negócio
│   │   ├── application/       # Serviços e casos de uso
│   │   └── infra/             # Repositórios e banco de dados
│   ├── Dockerfile
│   └── package.json
│
├── frontend/                   # Interface Next.js + React
│   ├── src/
│   │   ├── app/               # Rotas e layouts
│   │   ├── components/        # Componentes React
│   │   ├── hooks/             # React Query hooks
│   │   └── types/             # TypeScript types
│   ├── Dockerfile
│   └── package.json
│
├── database/                   # Scripts SQL
│   ├── 01-schema.sql          # Criação de tabelas
│   └── 02-seed.sql            # Dados de teste
│
├── docker-compose.yml         # Orquestração
├── Makefile                   # Scripts de automação
├── .env.example               # Variáveis de exemplo
└── README.md                  # Este arquivo
```

## 🏗️ Infraestrutura

### Serviços Docker

| Serviço | Porta | Status |
|---------|-------|--------|
| **Frontend** (Next.js) | 3000 | http://localhost:3000 |
| **Backend** (Fastify) | 3333 | http://localhost:3333 |
| **Database** (PostgreSQL 15) | 5432 | localhost:5432 |

Todos os serviços incluem:
- ✅ Health checks automáticos
- ✅ Restart policy
- ✅ Volume persistence
- ✅ Hot reload em desenvolvimento

### Banco de Dados

**Tabelas principais:**
- `clients` - Clientes do family office
- `simulations` - Simulações financeiras
- `allocations` - Alocações de ativos
- `transactions` - Movimentações (aportes, resgates, etc)
- `insurances` - Coberturas e seguros
- `simulation_versions` - Histórico de versões
- `users` - Usuários e autenticação (Fase 8)

Para detalhes completos: ver [INFRAESTRUTURA.md](./INFRAESTRUTURA.md)

## 🛠️ Desenvolvimento

### Variáveis de Ambiente

Copiar `.env.example` para `.env` e ajustar conforme necessário:

```env
# Database
DB_HOST=postgres           # Host do banco (localhost se local)
DB_PORT=5432             # Porta PostgreSQL
DB_USER=postgres         # Usuário BD
DB_PASSWORD=postgres     # Senha BD (ALTERAR EM PRODUÇÃO!)
DB_NAME=anka            # Nome do banco

# Node
NODE_ENV=development     # development, production

# API
API_PORT=3333           # Porta do backend
JWT_SECRET=your-key     # Chave JWT (ALTERAR EM PRODUÇÃO!)

# Frontend
NEXT_PUBLIC_API_URL=http://localhost:3333
```

### Comandos Principales

```bash
# Iniciar desenvolvimento
make dev                 # Inicia tudo + mostra logs

# Gerenciar containers
make up                  # Inicia containers
make down                # Para containers
docker compose ps        # Ver status

# Logs
make logs                # Todos os serviços
make logs-backend        # Apenas backend
make logs-frontend       # Apenas frontend
make logs-db            # Apenas banco

# Banco de dados
make db-reset           # Reinicia e recarrega schema
make db-seed            # Insere dados de teste
make db-shell           # Abre psql interativo

# Testes
make test               # Executa testes
make validate           # Valida infraestrutura

# Limpeza
make clean              # Remove containers e volumes
make clean-all          # Remove tudo (incluindo imagens)
```

## 📊 API REST

### Endpoints Principais

```
GET    /health                    # Verificar saúde da API
POST   /clients                   # Criar cliente
GET    /clients/:id               # Obter cliente
GET    /clients                   # Listar clientes
PUT    /clients/:id               # Atualizar cliente
DELETE /clients/:id               # Deletar cliente

POST   /simulations               # Criar simulação
GET    /simulations/:id           # Obter simulação
GET    /simulations              # Listar simulações
PUT    /simulations/:id          # Atualizar simulação
DELETE /simulations/:id          # Deletar simulação

GET    /simulations/:id/projection    # Projetar resultado
POST   /allocations              # Criar alocação
GET    /allocations/:id          # Obter alocação
PUT    /allocations/:id          # Atualizar alocação

POST   /transactions             # Registrar movimentação
GET    /transactions/:id         # Obter movimentação
POST   /insurances               # Criar seguro
GET    /insurances/:id           # Obter seguro
```

Documentação completa em: `http://localhost:3333/docs` (Swagger)

## 🎨 Frontend

### Tecnologias
- **Next.js 14** - React framework
- **shadcn/ui** - Componentes headless
- **Tailwind CSS** - Styling
- **React Query** - State management
- **Recharts** - Gráficos
- **React Hook Form** - Formulários
- **TypeScript** - Type safety

### Telas Principais
- 📊 **Dashboard** - Visão geral de simulações
- 📈 **Projeção** - Detalhes e gráficos de simulação
- 💼 **Alocações** - Gestão de ativos
- 📋 **Histórico** - Versões e comparativos
- 🔐 **Autenticação** - Login/registro (Fase 8)

## ⚙️ Backend

### Tecnologias
- **Fastify 4** - Web framework
- **TypeScript 5** - Type safety
- **PostgreSQL 15** - Database
- **Drizzle ORM** - Query builder
- **Zod** - Validação
- **JWT** - Autenticação

### Arquitetura
- **Layered Architecture** - Domain → Application → Infra
- **Repository Pattern** - Abstração de dados
- **Services** - Lógica de negócio
- **Controllers** - Handlers HTTP
- **Middleware** - Segurança e validation

## 📈 Fases de Desenvolvimento

| Fase | Status | Descrição |
|------|--------|-----------|
| 1 | ✅ Completa | Infraestrutura Docker + PostgreSQL |
| 2 | ⏳ Em fila | Backend estrutura e entidades |
| 3 | ⏳ Em fila | Motor de projeção financeira |
| 4 | ⏳ Em fila | API REST completa |
| 5 | ⏳ Em fila | Frontend setup e theming |
| 6 | ⏳ Em fila | Telas e componentes |
| 7 | ⏳ Em fila | Integração full-stack |
| 8 | ⏳ Em fila | Auth, RBAC e diferenciais |

Roadmap detalhado: ver [ROADMAP.md](./ROADMAP.md)

## 🔍 Validação

Validar infraestrutura:

```bash
# Script de validação
./validate.sh

# Ou manualmente
docker compose config      # Validar docker-compose.yml
docker compose ps          # Ver containers
curl http://localhost:3333/health    # Testar API
```

## 🐛 Troubleshooting

### Porta 3000/3333/5432 já em uso
```bash
# Listar processo na porta
lsof -i :3000
lsof -i :3333
lsof -i :5432

# Matar processo (Linux/Mac)
kill -9 <PID>
```

### Banco de dados não conecta
```bash
# Verificar status do postgres
make logs-db

# Resetar banco
make db-reset

# Verificar conexão manual
PGPASSWORD=postgres psql -h localhost -U postgres -d anka -c "SELECT version();"
```

### Frontend não conecta ao backend
```bash
# Verificar se backend está rodando
curl http://localhost:3333/health

# Verificar logs backend
make logs-backend

# Verificar configuração NEXT_PUBLIC_API_URL no .env
```

### Erro ao fazer build Docker
```bash
# Limpar e reconstruir
make clean-all
docker compose build --no-cache
docker compose up -d
```

## 📚 Documentação

- [INFRAESTRUTURA.md](./INFRAESTRUTURA.md) - Detalhes de setup e banco de dados
- [ROADMAP.md](./ROADMAP.md) - Visão geral do projeto e fases
- [AGENT_GUIDE.md](./AGENT_GUIDE.md) - Guia para usar agentes IA
- [prompts/](./prompts/) - Prompts para cada fase de desenvolvimento

## 🔐 Segurança

⚠️ **IMPORTANTE - Produção:**

1. Alterar `JWT_SECRET` em `.env`
2. Alterar `DB_PASSWORD` em `.env`
3. Ativar HTTPS
4. Configurar CORS adequadamente
5. Implementar rate limiting
6. Usar secrets manager
7. Auditar logs de acesso

Fases 7-8 incluem implementações de segurança.

## 📝 Licença

MIT License - veja [LICENSE](./LICENSE)

## 👥 Contribuindo

Este é um projeto de desenvolvimento estruturado em fases. Para contribuir:

1. Consulte [ROADMAP.md](./ROADMAP.md) para entender as fases
2. Leia [AGENT_GUIDE.md](./AGENT_GUIDE.md) para guidelines
3. Siga a arquitetura camadas (Domain → Application → Infra)
4. Mantenha os princípios KISS, SOLID e DRY

## 📞 Suporte

Para dúvidas sobre a estrutura:
- Verificar [INFRAESTRUTURA.md](./INFRAESTRUTURA.md)
- Consultar [AGENT_GUIDE.md](./AGENT_GUIDE.md)
- Examinar prompts em [prompts/](./prompts/)

---

**Última atualização:** Dezembro 2024
**Versão:** 1.0.0-alpha
**Status:** Fase 1 Completa ✅
