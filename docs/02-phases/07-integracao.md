# 🔗 Fase 7 - Integração

## 📋 Objetivo
Integrar frontend e backend, configurar Docker Compose completo, realizar testes end-to-end e preparar para deploy.

---

## 🎯 Entregáveis desta Fase

- [ ] Docker Compose com todos os serviços
- [ ] Frontend consumindo API corretamente
- [ ] Testes E2E básicos
- [ ] Variáveis de ambiente configuradas
- [ ] Scripts de desenvolvimento prontos
- [ ] READMEs completos

---

## 📝 Prompt 7.1 - Docker Compose Completo

```markdown
Atualize o docker-compose.yml com todos os serviços:

### Arquivo: docker-compose.yml

```yaml
version: '3.8'

services:
  # ==================== DATABASE ====================
  postgres:
    image: postgres:15-alpine
    container_name: mfo-postgres
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${POSTGRES_USER:-mfo}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-mfo123}
      POSTGRES_DB: ${POSTGRES_DB:-mfo_db}
    ports:
      - "${POSTGRES_PORT:-5432}:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database/init.sql:/docker-entrypoint-initdb.d/01-init.sql
      - ./database/seed.sql:/docker-entrypoint-initdb.d/02-seed.sql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-mfo} -d ${POSTGRES_DB:-mfo_db}"]
      interval: 5s
      timeout: 5s
      retries: 5
    networks:
      - mfo-network

  # ==================== BACKEND ====================
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
      target: ${NODE_ENV:-development}
    container_name: mfo-backend
    restart: unless-stopped
    environment:
      NODE_ENV: ${NODE_ENV:-development}
      PORT: 3333
      DATABASE_URL: postgresql://${POSTGRES_USER:-mfo}:${POSTGRES_PASSWORD:-mfo123}@postgres:5432/${POSTGRES_DB:-mfo_db}
      CORS_ORIGIN: ${CORS_ORIGIN:-http://localhost:3000}
      LOG_LEVEL: ${LOG_LEVEL:-info}
    ports:
      - "${BACKEND_PORT:-3333}:3333"
    volumes:
      - ./backend/src:/app/src:ro
      - ./backend/package.json:/app/package.json:ro
    depends_on:
      postgres:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://localhost:3333/health"]
      interval: 10s
      timeout: 5s
      retries: 3
    networks:
      - mfo-network

  # ==================== FRONTEND ====================
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
      target: ${NODE_ENV:-development}
    container_name: mfo-frontend
    restart: unless-stopped
    environment:
      NODE_ENV: ${NODE_ENV:-development}
      NEXT_PUBLIC_API_URL: ${NEXT_PUBLIC_API_URL:-http://localhost:3333}
    ports:
      - "${FRONTEND_PORT:-3000}:3000"
    volumes:
      - ./frontend/src:/app/src:ro
      - ./frontend/public:/app/public:ro
    depends_on:
      backend:
        condition: service_healthy
    networks:
      - mfo-network

networks:
  mfo-network:
    driver: bridge

volumes:
  postgres_data:
```

### Arquivo: .env.example

```env
# ==================== DATABASE ====================
POSTGRES_USER=mfo
POSTGRES_PASSWORD=mfo123
POSTGRES_DB=mfo_db
POSTGRES_PORT=5432

# ==================== BACKEND ====================
NODE_ENV=development
BACKEND_PORT=3333
LOG_LEVEL=info
CORS_ORIGIN=http://localhost:3000

# ==================== FRONTEND ====================
FRONTEND_PORT=3000
NEXT_PUBLIC_API_URL=http://localhost:3333
```

### Arquivo: .env (copiar do .env.example e ajustar)

### Princípios:
- Multi-stage builds para dev e prod
- Health checks para orquestração
- Volumes para hot-reload em dev
```

---

## 📝 Prompt 7.2 - Dockerfiles Otimizados

```markdown
Atualize os Dockerfiles para multi-stage builds:

### Arquivo: backend/Dockerfile

```dockerfile
# ==================== BASE ====================
FROM node:20-alpine AS base
WORKDIR /app
RUN apk add --no-cache libc6-compat

# ==================== DEPENDENCIES ====================
FROM base AS deps
COPY package.json package-lock.json* ./
RUN npm ci

# ==================== DEVELOPMENT ====================
FROM base AS development
COPY --from=deps /app/node_modules ./node_modules
COPY . .
EXPOSE 3333
CMD ["npm", "run", "dev"]

# ==================== BUILD ====================
FROM base AS builder
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# ==================== PRODUCTION ====================
FROM base AS production
ENV NODE_ENV=production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 fastify

COPY --from=builder --chown=fastify:nodejs /app/dist ./dist
COPY --from=builder --chown=fastify:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=fastify:nodejs /app/package.json ./package.json

USER fastify

EXPOSE 3333
CMD ["node", "dist/server.js"]
```

### Arquivo: frontend/Dockerfile

```dockerfile
# ==================== BASE ====================
FROM node:20-alpine AS base
WORKDIR /app
RUN apk add --no-cache libc6-compat

# ==================== DEPENDENCIES ====================
FROM base AS deps
COPY package.json package-lock.json* ./
RUN npm ci

# ==================== DEVELOPMENT ====================
FROM base AS development
COPY --from=deps /app/node_modules ./node_modules
COPY . .
EXPOSE 3000
ENV PORT 3000
CMD ["npm", "run", "dev"]

# ==================== BUILD ====================
FROM base AS builder
COPY --from=deps /app/node_modules ./node_modules
COPY . .

ENV NEXT_TELEMETRY_DISABLED 1

RUN npm run build

# ==================== PRODUCTION ====================
FROM base AS production
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED 1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000
ENV PORT 3000
CMD ["node", "server.js"]
```

### Atualizar frontend/next.config.js para standalone:

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
  reactStrictMode: true,
}

module.exports = nextConfig
```

### Princípios:
- Multi-stage para tamanho menor
- Usuário não-root para segurança
- Separação dev/prod clara
```

---

## 📝 Prompt 7.3 - Scripts de Desenvolvimento

```markdown
Crie scripts para facilitar o desenvolvimento:

### Arquivo: Makefile

```makefile
.PHONY: help dev prod up down logs clean test db-reset

# Cores
GREEN  := \033[0;32m
YELLOW := \033[0;33m
RESET  := \033[0m

help: ## Mostra esta ajuda
	@echo "$(GREEN)Comandos disponíveis:$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(RESET) %s\n", $$1, $$2}'

# ==================== DESENVOLVIMENTO ====================

dev: ## Inicia ambiente de desenvolvimento
	docker compose up -d postgres
	@echo "$(GREEN)Aguardando PostgreSQL...$(RESET)"
	@sleep 3
	docker compose up -d backend frontend
	@echo "$(GREEN)Ambiente iniciado!$(RESET)"
	@echo "  Frontend: http://localhost:3000"
	@echo "  Backend:  http://localhost:3333"
	@echo "  Swagger:  http://localhost:3333/docs"

up: ## Sobe todos os containers
	docker compose up -d

down: ## Para todos os containers
	docker compose down

logs: ## Mostra logs de todos os containers
	docker compose logs -f

logs-backend: ## Mostra logs do backend
	docker compose logs -f backend

logs-frontend: ## Mostra logs do frontend
	docker compose logs -f frontend

# ==================== PRODUÇÃO ====================

prod: ## Builda e inicia em modo produção
	NODE_ENV=production docker compose up -d --build

prod-build: ## Apenas builda as imagens de produção
	NODE_ENV=production docker compose build

# ==================== BANCO DE DADOS ====================

db-reset: ## Reseta o banco de dados (apaga tudo)
	docker compose down -v
	docker compose up -d postgres
	@echo "$(GREEN)Banco resetado!$(RESET)"

db-shell: ## Abre shell do PostgreSQL
	docker compose exec postgres psql -U mfo -d mfo_db

db-backup: ## Faz backup do banco
	docker compose exec postgres pg_dump -U mfo mfo_db > backup_$$(date +%Y%m%d_%H%M%S).sql

# ==================== TESTES ====================

test: ## Roda todos os testes
	cd backend && npm test
	cd frontend && npm test

test-backend: ## Roda testes do backend
	cd backend && npm test

test-frontend: ## Roda testes do frontend
	cd frontend && npm test

test-e2e: ## Roda testes E2E
	cd frontend && npm run test:e2e

# ==================== LIMPEZA ====================

clean: ## Limpa containers, volumes e imagens não utilizadas
	docker compose down -v --rmi local
	docker system prune -f

clean-all: ## Limpa TUDO (cuidado!)
	docker compose down -v --rmi all
	docker system prune -af --volumes
```

### Arquivo: scripts/dev-setup.sh

```bash
#!/bin/bash

set -e

echo "🚀 Configurando ambiente de desenvolvimento..."

# Verificar dependências
command -v docker >/dev/null 2>&1 || { echo "❌ Docker não encontrado"; exit 1; }
command -v docker compose >/dev/null 2>&1 || { echo "❌ Docker Compose não encontrado"; exit 1; }
command -v node >/dev/null 2>&1 || { echo "❌ Node.js não encontrado"; exit 1; }

# Copiar .env se não existir
if [ ! -f .env ]; then
    cp .env.example .env
    echo "✅ Arquivo .env criado"
fi

# Instalar dependências do backend
echo "📦 Instalando dependências do backend..."
cd backend && npm install && cd ..

# Instalar dependências do frontend
echo "📦 Instalando dependências do frontend..."
cd frontend && npm install && cd ..

# Subir banco de dados
echo "🐘 Iniciando PostgreSQL..."
docker compose up -d postgres

# Aguardar banco estar pronto
echo "⏳ Aguardando banco de dados..."
sleep 5

echo ""
echo "✅ Setup completo!"
echo ""
echo "Para iniciar o ambiente:"
echo "  make dev"
echo ""
echo "Ou manualmente:"
echo "  Terminal 1: cd backend && npm run dev"
echo "  Terminal 2: cd frontend && npm run dev"
```

### Princípios:
- Makefile para comandos padronizados
- Scripts idempotentes
- Feedback visual claro
```

---

## 📝 Prompt 7.4 - Configuração de Contexto do Cliente

```markdown
Crie um contexto para gerenciar o cliente selecionado:

### Arquivo: src/contexts/client-context.tsx

```typescript
'use client';

import { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { Client } from '@/types';
import { useClients } from '@/hooks/use-clients';

interface ClientContextType {
  currentClient: Client | null;
  setCurrentClient: (client: Client) => void;
  isLoading: boolean;
}

const ClientContext = createContext<ClientContextType | undefined>(undefined);

export function ClientProvider({ children }: { children: ReactNode }) {
  const [currentClient, setCurrentClient] = useState<Client | null>(null);
  const { data: clients = [], isLoading } = useClients();

  // Selecionar primeiro cliente automaticamente
  useEffect(() => {
    if (!currentClient && clients.length > 0) {
      setCurrentClient(clients[0]);
    }
  }, [clients, currentClient]);

  // Persistir cliente selecionado
  useEffect(() => {
    if (currentClient) {
      localStorage.setItem('selectedClientId', currentClient.id);
    }
  }, [currentClient]);

  // Recuperar cliente do localStorage
  useEffect(() => {
    const savedClientId = localStorage.getItem('selectedClientId');
    if (savedClientId && clients.length > 0) {
      const client = clients.find((c) => c.id === savedClientId);
      if (client) {
        setCurrentClient(client);
      }
    }
  }, [clients]);

  return (
    <ClientContext.Provider value={{ currentClient, setCurrentClient, isLoading }}>
      {children}
    </ClientContext.Provider>
  );
}

export function useCurrentClient() {
  const context = useContext(ClientContext);
  if (context === undefined) {
    throw new Error('useCurrentClient must be used within a ClientProvider');
  }
  return context;
}
```

### Atualizar src/app/providers.tsx:

```typescript
'use client';

import { QueryClientProvider } from '@tanstack/react-query';
import { ReactQueryDevtools } from '@tanstack/react-query-devtools';
import { queryClient } from '@/lib/query-client';
import { ClientProvider } from '@/contexts/client-context';
import { Toaster } from '@/components/ui/toaster';

interface ProvidersProps {
  children: React.ReactNode;
}

export function Providers({ children }: ProvidersProps) {
  return (
    <QueryClientProvider client={queryClient}>
      <ClientProvider>
        {children}
        <Toaster />
        <ReactQueryDevtools initialIsOpen={false} />
      </ClientProvider>
    </QueryClientProvider>
  );
}
```

### Atualizar hooks para usar o contexto:

```typescript
// Exemplo em src/hooks/use-simulations.ts
import { useCurrentClient } from '@/contexts/client-context';

export function useSimulations() {
  const { currentClient } = useCurrentClient();
  
  return useQuery<Simulation[]>({
    queryKey: ['simulations', currentClient?.id],
    queryFn: async () => {
      if (!currentClient) return [];
      const { data } = await api.get(`/clients/${currentClient.id}/simulations`);
      return data;
    },
    enabled: !!currentClient,
  });
}
```

### Princípios:
- Contexto centralizado para cliente
- Persistência em localStorage
- Hooks reutilizam o contexto
```

---

## 📝 Prompt 7.5 - READMEs Completos

```markdown
Crie os READMEs para cada repositório:

### Arquivo: backend/README.md

```markdown
# MFO Backend

API REST para o sistema Multi Family Office.

## 🚀 Tecnologias

- **Runtime**: Node.js 20
- **Framework**: Fastify 4
- **Linguagem**: TypeScript 5
- **Banco de Dados**: PostgreSQL 15
- **ORM**: Drizzle ORM
- **Validação**: Zod
- **Documentação**: Swagger/OpenAPI
- **Testes**: Vitest

## 📁 Estrutura do Projeto

\`\`\`
src/
├── domain/               # Entidades e regras de negócio
│   ├── entities/         # Definições de entidades
│   ├── services/         # Serviços de domínio (motor de projeção)
│   └── repositories/     # Interfaces de repositórios
├── application/          # Casos de uso
│   └── services/         # Orquestração de operações
├── infra/                # Infraestrutura
│   ├── http/             # Controllers, routes, schemas
│   └── repositories/     # Implementações dos repositórios
├── db/                   # Schema do banco (Drizzle)
└── lib/                  # Utilitários e configurações
\`\`\`

## 🏃 Executando

### Com Docker (recomendado)

\`\`\`bash
# Na raiz do projeto
docker compose up -d
\`\`\`

### Localmente

\`\`\`bash
# Instalar dependências
npm install

# Configurar variáveis de ambiente
cp .env.example .env

# Rodar em desenvolvimento
npm run dev
\`\`\`

## 📚 API Documentation

Acesse a documentação Swagger em: `http://localhost:3333/docs`

## 🧪 Testes

\`\`\`bash
# Rodar todos os testes
npm test

# Rodar com coverage
npm run test:coverage

# Rodar em watch mode
npm run test:watch
\`\`\`

## ⚙️ Motor de Projeção

### Decisões de Design

1. **Granularidade Mensal**: Cálculos são feitos mês a mês para maior precisão, agregados anualmente para visualização.

2. **Taxa Real**: Usamos a fórmula `(1 + juros) / (1 + inflação) - 1` para calcular a taxa real.

3. **Status de Vida**:
   - Normal: Todas entradas e saídas normais
   - Morto: Entradas = 0, Despesas = 50%, recebe seguro vida
   - Inválido: Entradas = 0, Despesas = 100%, recebe seguro invalidez

4. **Seguros**: Pagamento único no mês da mudança de status.

5. **Financiamentos**: Deduzidos mensalmente até quitação.

### Simplificações

- Imóveis valorizam pela taxa de inflação
- Não há impostos no cálculo
- Todos os ativos financeiros têm a mesma rentabilidade

## 🔒 Segurança

- Validação de entrada com Zod em todos endpoints
- Tratamento de erros centralizado
- Logs estruturados com Pino

## 📝 Variáveis de Ambiente

| Variável | Descrição | Default |
|----------|-----------|---------|
| PORT | Porta do servidor | 3333 |
| DATABASE_URL | URL de conexão PostgreSQL | - |
| CORS_ORIGIN | Origem permitida para CORS | * |
| LOG_LEVEL | Nível de log | info |
\`\`\`

### Arquivo: frontend/README.md

\`\`\`markdown
# MFO Frontend

Interface web para o sistema Multi Family Office.

## 🚀 Tecnologias

- **Framework**: Next.js 14 (App Router)
- **Linguagem**: TypeScript 5
- **Estilização**: Tailwind CSS
- **Componentes**: shadcn/ui
- **State Management**: React Query (TanStack Query)
- **Formulários**: React Hook Form + Zod
- **Gráficos**: Recharts

## 📁 Estrutura do Projeto

\`\`\`
src/
├── app/                  # Rotas e layouts (App Router)
│   ├── (dashboard)/      # Grupo de rotas do dashboard
│   │   ├── projecao/     # Tela de projeção
│   │   ├── alocacoes/    # Tela de alocações
│   │   └── historico/    # Tela de histórico
│   └── providers.tsx     # Providers globais
├── components/
│   ├── ui/               # Componentes shadcn/ui
│   ├── layout/           # Sidebar, Header
│   ├── charts/           # Gráficos reutilizáveis
│   ├── projection/       # Componentes de projeção
│   └── allocations/      # Componentes de alocações
├── hooks/                # Custom hooks (React Query)
├── contexts/             # Contextos React
├── services/             # Cliente HTTP (Axios)
├── types/                # Tipos TypeScript
└── lib/                  # Utilitários
\`\`\`

## 🏃 Executando

### Com Docker (recomendado)

\`\`\`bash
# Na raiz do projeto
docker compose up -d
\`\`\`

### Localmente

\`\`\`bash
# Instalar dependências
npm install

# Configurar variáveis de ambiente
cp .env.example .env.local

# Rodar em desenvolvimento
npm run dev
\`\`\`

## 🎨 Design System

O projeto segue o design do Figma com tema dark-mode. Cores principais:

- **Primary**: Azul (#3B82F6)
- **Financial**: Azul
- **Property**: Verde
- **Total**: Roxo
- **Realized**: Amarelo

## 🖥️ Telas

### Projeção
- Gráfico de evolução patrimonial
- Comparação entre simulações
- Visualização em gráfico ou tabela
- Modo "Ver em detalhes" com áreas empilhadas

### Alocações
- Seleção de data
- Lista de alocações financeiras e imobilizadas
- Criação/edição de alocações
- Função "Atualizar" para copiar snapshot

### Histórico
- Lista de todas as versões de simulações
- Visualização de gráficos antigos
- Opção de reabrir versão

## 📱 Responsividade

O design é otimizado para desktop, com sidebar colapsável para telas menores.

## 🧪 Testes

\`\`\`bash
# Rodar testes unitários
npm test

# Rodar testes E2E
npm run test:e2e
\`\`\`

## 📝 Variáveis de Ambiente

| Variável | Descrição | Default |
|----------|-----------|---------|
| NEXT_PUBLIC_API_URL | URL da API | http://localhost:3333 |
\`\`\`

### Arquivo: README.md (raiz)

\`\`\`markdown
# MFO - Multi Family Office

Sistema de gestão patrimonial para Multi Family Offices.

## 🏗️ Arquitetura

\`\`\`
┌─────────────────────────────────────────────────────────────────┐
│                         DOCKER COMPOSE                          │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐   │
│  │   Frontend   │  │   Backend    │  │     PostgreSQL       │   │
│  │   (Next.js)  │  │  (Fastify)   │  │     (Database)       │   │
│  │   Port 3000  │  │  Port 3333   │  │     Port 5432        │   │
│  └──────────────┘  └──────────────┘  └──────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
\`\`\`

## 🚀 Quick Start

\`\`\`bash
# 1. Clonar o repositório
git clone https://github.com/m6rc0sp/anka-mfo-infra.git
cd anka-mfo-infra

# 2. Configurar variáveis de ambiente
cp .env.example .env

# 3. Iniciar com Docker
make dev

# Ou diretamente:
docker compose up -d
\`\`\`

## 📦 Serviços

| Serviço | URL | Descrição |
|---------|-----|-----------|
| Frontend | http://localhost:3000 | Interface web |
| Backend | http://localhost:3333 | API REST |
| Swagger | http://localhost:3333/docs | Documentação API |
| PostgreSQL | localhost:5432 | Banco de dados |

## 🛠️ Comandos Úteis

\`\`\`bash
make dev          # Inicia ambiente de desenvolvimento
make logs         # Mostra logs de todos os containers
make test         # Roda todos os testes
make db-reset     # Reseta o banco de dados
make clean        # Limpa containers e volumes
\`\`\`

## 📚 Documentação

- [Backend README](./backend/README.md)
- [Frontend README](./frontend/README.md)

## 🧪 Testes

\`\`\`bash
# Todos os testes
make test

# Apenas backend
make test-backend

# Apenas frontend
make test-frontend
\`\`\`

## 📝 Licença

Projeto desenvolvido como case técnico.
\`\`\`
```

---

## ✅ Validação da Fase 7

```bash
# Testar setup completo
make clean
make dev

# Verificar todos os serviços
curl http://localhost:3333/health
curl http://localhost:3000

# Verificar logs
make logs

# Rodar testes
make test
```

### Critérios de Sucesso:
- [ ] `make dev` sobe todo o ambiente
- [ ] Frontend conecta com backend
- [ ] Dados do seed aparecem na aplicação
- [ ] Testes passando
- [ ] READMEs completos

---

## 📚 Arquivos Criados/Atualizados nesta Fase

```
/
├── docker-compose.yml (atualizado)
├── .env.example (atualizado)
├── Makefile
├── README.md
├── scripts/
│   └── dev-setup.sh
├── backend/
│   ├── Dockerfile (atualizado)
│   └── README.md
└── frontend/
    ├── Dockerfile (atualizado)
    ├── next.config.js (atualizado)
    ├── README.md
    └── src/
        └── contexts/
            └── client-context.tsx
```

---

## 🔄 Próxima Fase

Após validar todos os checkpoints, siga para:
**[Fase 8 - Diferenciais](./08-diferenciais.md)**
