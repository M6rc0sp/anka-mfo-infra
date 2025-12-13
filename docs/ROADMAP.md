# 🗺️ Roadmap - Multi Family Office (MFO) Platform

## 📋 Visão Geral do Projeto

Este documento serve como guia completo para desenvolvimento do sistema MFO, dividido em fases claras e prompts específicos para cada etapa.

---

## 🏗️ Arquitetura Geral

```
┌─────────────────────────────────────────────────────────────────┐
│                         DOCKER COMPOSE                          │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐   │
│  │   Frontend   │  │   Backend    │  │     PostgreSQL       │   │
│  │   (Next.js)  │  │  (Fastify)   │  │     (Database)       │   │
│  │   Port 3000  │  │  Port 3333   │  │     Port 5432        │   │
│  └──────────────┘  └──────────────┘  └──────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📊 Fases do Projeto

| Fase | Descrição | Tempo Estimado | Status |
|------|-----------|----------------|--------|
| 1 | Infraestrutura Base (Docker + DB) | 2-3 horas | ✅ CONCLUÍDA |
| 2 | Backend - Estrutura + API + Tests | 4-6 horas | ✅ CONCLUÍDA |
| 3 | Backend - Motor de Projeção | 4-6 horas | ⏳ Próxima |
| 4 | Backend - API REST Avançada | 3-4 horas | ⏳ |
| 5 | Frontend - Setup e Layout Base | 3-4 horas | ⏳ |
| 6 | Frontend - Telas Principais | 8-12 horas | ⏳ |
| 7 | Integração e Testes | 4-6 horas | ⏳ |
| 8 | Diferenciais (Auth, RBAC) | 4-6 horas | ⏳ |

---

## 🚀 Como Usar Este Guia

1. Siga as fases na ordem apresentada
2. Cada fase tem um prompt específico em `/prompts/`
3. Use os checkpoints para validar o progresso
4. Mantenha os princípios KISS, SOLID e DRY

---

## 📁 Estrutura de Diretórios Final

```
anka-mfo/
├── docker-compose.yml
├── backend/
│   ├── Dockerfile
│   ├── src/
│   │   ├── domain/          # Entidades e regras de negócio
│   │   ├── application/     # Casos de uso
│   │   ├── infra/           # Banco, HTTP, etc
│   │   └── tests/           # Testes automatizados
│   └── README.md
├── frontend/
│   ├── Dockerfile
│   ├── src/
│   │   ├── components/      # Componentes reutilizáveis
│   │   ├── pages/           # Páginas da aplicação
│   │   ├── hooks/           # Custom hooks
│   │   ├── services/        # API calls
│   │   └── utils/           # Utilitários
│   └── README.md
└── database/
    └── init.sql             # Scripts de inicialização
```

---

## ✅ Checkpoints de Validação

### Fase 1 - Infraestrutura
- ✅ Docker Compose sobe sem erros
- ✅ PostgreSQL acessível na porta 5432
- ✅ Volumes persistentes configurados

### Fase 2 - Backend Estrutura
- ✅ Servidor Fastify 5.1.0 rodando
- ✅ Conexão com banco OK
- ✅ Swagger documentação acessível em /docs
- ✅ Entidades base criadas (7 entidades)
- ✅ 6 Repositories com CRUD
- ✅ 5 endpoints REST para Clients
- ✅ 6 testes de integração (100% passing)
- ✅ Validação Zod funcionando
- ✅ Error handling centralizado

### Fase 3 - Motor de Projeção
- [ ] Cálculo de projeção funcionando
- [ ] Testes do motor passando
- [ ] Cenários de vida (normal/morto/inválido) OK

### Fase 4 - API REST
- [ ] Endpoints avançados documentados
- [ ] Filtros e paginação funcionando
- [ ] CRUD completo para todas entidades

### Fase 5 - Frontend Setup
- [ ] Next.js rodando
- [ ] shadcn/ui configurado
- [ ] Layout dark-mode base

### Fase 6 - Telas
- [ ] Tela Projeção funcional
- [ ] Tela Alocações funcional
- [ ] Tela Histórico funcional

### Fase 7 - Integração
- [ ] Frontend consumindo API
- [ ] Docker Compose completo
- [ ] Testes E2E básicos

---

## 🎯 Princípios a Seguir

### KISS (Keep It Simple, Stupid)
- Evite over-engineering
- Prefira soluções diretas
- Código legível > código "esperto"

### SOLID
- **S**: Uma responsabilidade por classe/função
- **O**: Aberto para extensão, fechado para modificação
- **L**: Subtipos substituíveis
- **I**: Interfaces específicas
- **D**: Dependa de abstrações

### DRY (Don't Repeat Yourself)
- Extraia lógica comum
- Use componentes reutilizáveis
- Centralize configurações

---

## 📚 Índice de Prompts

1. [Fase 1 - Infraestrutura](./prompts/01-infraestrutura.md)
2. [Fase 2 - Backend Estrutura](./prompts/02-backend-estrutura.md)
3. [Fase 3 - Motor de Projeção](./prompts/03-motor-projecao.md)
4. [Fase 4 - API REST](./prompts/04-api-rest.md)
5. [Fase 5 - Frontend Setup](./prompts/05-frontend-setup.md)
6. [Fase 6 - Telas](./prompts/06-frontend-telas.md)
7. [Fase 7 - Integração](./prompts/07-integracao.md)
8. [Fase 8 - Diferenciais](./prompts/08-diferenciais.md)

---

## 💡 Dicas para Usar com Agentes IA

### Configuração Recomendada de Agentes

```markdown
## Agent 1: Database Architect
- Foco: Schema do banco, migrations, queries
- Contexto: Sempre inclua o diagrama ER atual

## Agent 2: Backend Developer
- Foco: API, regras de negócio, testes
- Contexto: Sempre inclua as interfaces/types

## Agent 3: Frontend Developer
- Foco: UI/UX, componentes, integração
- Contexto: Sempre inclua o Figma e API docs

## Agent 4: DevOps
- Foco: Docker, CI/CD, deploy
- Contexto: Sempre inclua docker compose atual
```

### Boas Práticas com Agentes

1. **Contexto Claro**: Sempre forneça o estado atual do projeto
2. **Escopo Limitado**: Um prompt = uma feature/correção
3. **Validação**: Teste após cada implementação
4. **Histórico**: Mantenha log das alterações

---

## 🔗 Links Úteis

- [Figma do Projeto](https://www.figma.com/design/i2Ml8dgRQvDsLemtRJ5Jqw/TH---Gr%C3%A1ficos-RN?node-id=168-54)
- [Fastify Docs](https://www.fastify.io/docs/latest/)
- [shadcn/ui](https://ui.shadcn.com/)
- [Zod](https://zod.dev/)
- [React Query](https://tanstack.com/query/latest)
