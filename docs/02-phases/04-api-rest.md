# 🌐 Fase 4 - API REST

## 📋 Objetivo
Implementar todos os endpoints REST necessários para a aplicação, com validação Zod, documentação Swagger e tratamento de erros.

---

## 🎯 Entregáveis desta Fase

- [ ] Endpoints CRUD para todas entidades
- [ ] Endpoints específicos de projeção
- [ ] Validação Zod em todos endpoints
- [ ] Documentação Swagger completa
- [ ] Tratamento de erros padronizado
- [ ] Testes de integração para API

---

## 📊 Mapa de Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| **Clients** |||
| GET | /clients | Listar clientes |
| GET | /clients/:id | Buscar cliente |
| POST | /clients | Criar cliente |
| PUT | /clients/:id | Atualizar cliente |
| DELETE | /clients/:id | Remover cliente |
| **Simulations** |||
| GET | /clients/:clientId/simulations | Listar simulações |
| GET | /simulations/:id | Buscar simulação |
| POST | /clients/:clientId/simulations | Criar simulação |
| PUT | /simulations/:id | Atualizar simulação |
| DELETE | /simulations/:id | Remover simulação |
| POST | /simulations/:id/versions | Criar nova versão |
| GET | /simulations/:id/versions | Listar versões |
| GET | /simulations/:id/projection | Executar projeção |
| **Allocations** |||
| GET | /clients/:clientId/allocations | Listar por cliente |
| GET | /clients/:clientId/allocations/dates | Listar datas disponíveis |
| GET | /clients/:clientId/allocations/:date | Buscar por data |
| POST | /clients/:clientId/allocations | Criar alocação |
| PUT | /allocations/:id | Atualizar alocação |
| DELETE | /allocations/:id | Remover alocação |
| POST | /clients/:clientId/allocations/copy | Copiar para nova data |
| **Transactions** |||
| GET | /clients/:clientId/transactions | Listar transações |
| POST | /clients/:clientId/transactions | Criar transação |
| PUT | /transactions/:id | Atualizar transação |
| DELETE | /transactions/:id | Remover transação |
| **Insurances** |||
| GET | /clients/:clientId/insurances | Listar seguros |
| POST | /clients/:clientId/insurances | Criar seguro |
| PUT | /insurances/:id | Atualizar seguro |
| DELETE | /insurances/:id | Remover seguro |
| **Projections** |||
| GET | /clients/:clientId/realized | Patrimônio realizado |
| POST | /clients/:clientId/compare | Comparar simulações |

---

## 📝 Prompt 4.1 - Schemas Zod

```markdown
Crie os schemas de validação Zod para todos os endpoints:

### Arquivo: src/infra/http/schemas/index.ts

```typescript
import { z } from 'zod';

// ============ PARAMS ============
export const idParamSchema = z.object({
  id: z.string().uuid(),
});

export const clientIdParamSchema = z.object({
  clientId: z.string().uuid(),
});

export const dateParamSchema = z.object({
  date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
});

// ============ CLIENT ============
export const createClientSchema = z.object({
  name: z.string().min(2).max(100),
  email: z.string().email(),
});

export const updateClientSchema = createClientSchema.partial();

export const clientResponseSchema = z.object({
  id: z.string().uuid(),
  name: z.string(),
  email: z.string(),
  createdAt: z.string().datetime(),
  updatedAt: z.string().datetime(),
});

// ============ SIMULATION ============
export const lifeStatusSchema = z.enum(['normal', 'dead', 'invalid']);

export const createSimulationSchema = z.object({
  name: z.string().min(1).max(100),
  startDate: z.string().datetime(),
  interestRate: z.number().min(0).max(1), // 0 a 100%
  inflationRate: z.number().min(0).max(1),
  lifeStatus: lifeStatusSchema.default('normal'),
  lifeStatusChangeDate: z.string().datetime().optional(),
  isCurrent: z.boolean().default(false),
});

export const updateSimulationSchema = createSimulationSchema.partial();

export const simulationResponseSchema = z.object({
  id: z.string().uuid(),
  clientId: z.string().uuid(),
  name: z.string(),
  startDate: z.string().datetime(),
  interestRate: z.number(),
  inflationRate: z.number(),
  lifeStatus: lifeStatusSchema,
  isCurrent: z.boolean(),
  createdAt: z.string().datetime(),
  updatedAt: z.string().datetime(),
  latestVersion: z.number().optional(),
});

// ============ ALLOCATION ============
export const allocationTypeSchema = z.enum(['financial', 'property']);

export const financingDataSchema = z.object({
  downPayment: z.number().min(0),
  installments: z.number().int().min(1),
  interestRate: z.number().min(0).max(1),
  amortizationType: z.enum(['sac', 'price']),
  paidInstallments: z.number().int().min(0),
});

export const createAllocationSchema = z.object({
  referenceDate: z.string().datetime(),
  type: allocationTypeSchema,
  name: z.string().min(1).max(100),
  value: z.number().min(0),
  isFinanced: z.boolean().default(false),
  financingData: financingDataSchema.optional(),
});

export const updateAllocationSchema = createAllocationSchema.partial();

export const allocationResponseSchema = z.object({
  id: z.string().uuid(),
  clientId: z.string().uuid(),
  referenceDate: z.string().datetime(),
  type: allocationTypeSchema,
  name: z.string(),
  value: z.number(),
  isFinanced: z.boolean(),
  financingData: financingDataSchema.nullable(),
  createdAt: z.string().datetime(),
  updatedAt: z.string().datetime(),
});

export const copyAllocationsSchema = z.object({
  fromDate: z.string().datetime(),
  toDate: z.string().datetime(),
});

// ============ TRANSACTION ============
export const transactionTypeSchema = z.enum(['income', 'expense', 'deposit', 'withdrawal']);
export const recurrenceIntervalSchema = z.enum(['monthly', 'yearly', 'one_time']);

export const createTransactionSchema = z.object({
  type: transactionTypeSchema,
  category: z.string().max(50).optional(),
  name: z.string().min(1).max(100),
  value: z.number().min(0),
  isRecurring: z.boolean().default(false),
  recurrenceStart: z.string().datetime().optional(),
  recurrenceEnd: z.string().datetime().optional(),
  recurrenceInterval: recurrenceIntervalSchema.optional(),
}).refine(
  (data) => {
    if (data.isRecurring) {
      return data.recurrenceStart && data.recurrenceEnd && data.recurrenceInterval;
    }
    return true;
  },
  { message: 'Transações recorrentes precisam de start, end e interval' }
);

export const updateTransactionSchema = createTransactionSchema.partial();

export const transactionResponseSchema = z.object({
  id: z.string().uuid(),
  clientId: z.string().uuid(),
  type: transactionTypeSchema,
  category: z.string().nullable(),
  name: z.string(),
  value: z.number(),
  isRecurring: z.boolean(),
  recurrenceStart: z.string().datetime().nullable(),
  recurrenceEnd: z.string().datetime().nullable(),
  recurrenceInterval: recurrenceIntervalSchema.nullable(),
  createdAt: z.string().datetime(),
  updatedAt: z.string().datetime(),
});

// ============ INSURANCE ============
export const insuranceTypeSchema = z.enum(['life', 'disability']);

export const createInsuranceSchema = z.object({
  type: insuranceTypeSchema,
  name: z.string().min(1).max(100),
  startDate: z.string().datetime(),
  durationMonths: z.number().int().min(1),
  monthlyPremium: z.number().min(0),
  coverageValue: z.number().min(0),
});

export const updateInsuranceSchema = createInsuranceSchema.partial();

export const insuranceResponseSchema = z.object({
  id: z.string().uuid(),
  clientId: z.string().uuid(),
  type: insuranceTypeSchema,
  name: z.string(),
  startDate: z.string().datetime(),
  durationMonths: z.number(),
  monthlyPremium: z.number(),
  coverageValue: z.number(),
  createdAt: z.string().datetime(),
  updatedAt: z.string().datetime(),
});

// ============ PROJECTION ============
export const projectionPointSchema = z.object({
  date: z.string().datetime(),
  financialAssets: z.number(),
  propertyAssets: z.number(),
  totalAssets: z.number(),
  totalWithoutInsurance: z.number(),
});

export const projectionResponseSchema = z.object({
  yearly: z.array(z.object({
    year: z.number(),
    financialAssets: z.number(),
    propertyAssets: z.number(),
    totalAssets: z.number(),
    totalWithoutInsurance: z.number(),
  })),
  summary: z.object({
    initialAssets: z.number(),
    finalAssets: z.number(),
    totalGrowth: z.number(),
    totalGrowthPercent: z.number(),
  }),
});

export const compareSimulationsSchema = z.object({
  simulationIds: z.array(z.string().uuid()).min(1).max(5),
});
```

### Princípios:
- DRY: Reutilizar schemas base
- KISS: Validações simples e diretas
- Usar refine para validações complexas
```

---

## 📝 Prompt 4.2 - Controllers

```markdown
Crie os controllers para cada grupo de rotas:

### Estrutura:
```
src/infra/http/controllers/
├── client-controller.ts
├── simulation-controller.ts
├── allocation-controller.ts
├── transaction-controller.ts
├── insurance-controller.ts
└── projection-controller.ts
```

### Exemplo: src/infra/http/controllers/simulation-controller.ts

```typescript
import { FastifyInstance } from 'fastify';
import { ZodTypeProvider } from '@fastify/type-provider-zod';
import { z } from 'zod';
import {
  clientIdParamSchema,
  idParamSchema,
  createSimulationSchema,
  updateSimulationSchema,
  simulationResponseSchema,
} from '../schemas';

export async function simulationController(app: FastifyInstance) {
  const server = app.withTypeProvider<ZodTypeProvider>();
  
  // Listar simulações do cliente (apenas versão mais recente)
  server.get(
    '/clients/:clientId/simulations',
    {
      schema: {
        tags: ['Simulations'],
        summary: 'Listar simulações do cliente',
        params: clientIdParamSchema,
        response: {
          200: z.array(simulationResponseSchema),
        },
      },
    },
    async (request, reply) => {
      const { clientId } = request.params;
      
      const simulations = await request.server.simulationService
        .findByClientId(clientId);
      
      return reply.send(simulations);
    }
  );
  
  // Buscar simulação
  server.get(
    '/simulations/:id',
    {
      schema: {
        tags: ['Simulations'],
        summary: 'Buscar simulação por ID',
        params: idParamSchema,
        response: {
          200: simulationResponseSchema,
          404: z.object({ message: z.string() }),
        },
      },
    },
    async (request, reply) => {
      const { id } = request.params;
      
      const simulation = await request.server.simulationService.findById(id);
      
      if (!simulation) {
        return reply.status(404).send({ message: 'Simulação não encontrada' });
      }
      
      return reply.send(simulation);
    }
  );
  
  // Criar simulação
  server.post(
    '/clients/:clientId/simulations',
    {
      schema: {
        tags: ['Simulations'],
        summary: 'Criar nova simulação',
        params: clientIdParamSchema,
        body: createSimulationSchema,
        response: {
          201: simulationResponseSchema,
          400: z.object({ message: z.string() }),
          409: z.object({ message: z.string() }),
        },
      },
    },
    async (request, reply) => {
      const { clientId } = request.params;
      const data = request.body;
      
      try {
        const simulation = await request.server.simulationService.create({
          ...data,
          clientId,
        });
        
        return reply.status(201).send(simulation);
      } catch (error) {
        if (error instanceof Error && error.message.includes('nome')) {
          return reply.status(409).send({ message: error.message });
        }
        throw error;
      }
    }
  );
  
  // Atualizar simulação
  server.put(
    '/simulations/:id',
    {
      schema: {
        tags: ['Simulations'],
        summary: 'Atualizar simulação',
        params: idParamSchema,
        body: updateSimulationSchema,
        response: {
          200: simulationResponseSchema,
          404: z.object({ message: z.string() }),
        },
      },
    },
    async (request, reply) => {
      const { id } = request.params;
      const data = request.body;
      
      const simulation = await request.server.simulationService.update(id, data);
      
      if (!simulation) {
        return reply.status(404).send({ message: 'Simulação não encontrada' });
      }
      
      return reply.send(simulation);
    }
  );
  
  // Deletar simulação
  server.delete(
    '/simulations/:id',
    {
      schema: {
        tags: ['Simulations'],
        summary: 'Remover simulação',
        params: idParamSchema,
        response: {
          204: z.null(),
          404: z.object({ message: z.string() }),
        },
      },
    },
    async (request, reply) => {
      const { id } = request.params;
      
      await request.server.simulationService.delete(id);
      
      return reply.status(204).send();
    }
  );
  
  // Criar nova versão
  server.post(
    '/simulations/:id/versions',
    {
      schema: {
        tags: ['Simulations'],
        summary: 'Criar nova versão da simulação',
        params: idParamSchema,
        response: {
          201: z.object({
            id: z.string().uuid(),
            simulationId: z.string().uuid(),
            versionNumber: z.number(),
            createdAt: z.string().datetime(),
          }),
          404: z.object({ message: z.string() }),
        },
      },
    },
    async (request, reply) => {
      const { id } = request.params;
      
      const version = await request.server.simulationService.createVersion(id);
      
      return reply.status(201).send(version);
    }
  );
  
  // Listar versões
  server.get(
    '/simulations/:id/versions',
    {
      schema: {
        tags: ['Simulations'],
        summary: 'Listar versões da simulação',
        params: idParamSchema,
        response: {
          200: z.array(z.object({
            id: z.string().uuid(),
            versionNumber: z.number(),
            parameters: z.any(),
            createdAt: z.string().datetime(),
          })),
        },
      },
    },
    async (request, reply) => {
      const { id } = request.params;
      
      const versions = await request.server.simulationService.getVersions(id);
      
      return reply.send(versions);
    }
  );
  
  // Executar projeção
  server.get(
    '/simulations/:id/projection',
    {
      schema: {
        tags: ['Simulations'],
        summary: 'Executar projeção da simulação',
        params: idParamSchema,
        querystring: z.object({
          years: z.coerce.number().int().min(1).max(50).default(30),
        }),
        response: {
          200: projectionResponseSchema,
          404: z.object({ message: z.string() }),
        },
      },
    },
    async (request, reply) => {
      const { id } = request.params;
      const { years } = request.query;
      
      const projection = await request.server.simulationService
        .runProjection(id, years);
      
      return reply.send(projection);
    }
  );
}
```

### Crie controllers similares para:
1. client-controller.ts
2. allocation-controller.ts
3. transaction-controller.ts
4. insurance-controller.ts
5. projection-controller.ts

### Princípios:
- SOLID (S): Um controller por domínio
- KISS: Handlers simples, lógica nos services
- Documentação Swagger inline
```

---

## 📝 Prompt 4.3 - Registro de Rotas e Plugins

```markdown
Configure o registro de rotas e plugins no Fastify:

### Arquivo: src/infra/http/routes.ts

```typescript
import { FastifyInstance } from 'fastify';
import { clientController } from './controllers/client-controller';
import { simulationController } from './controllers/simulation-controller';
import { allocationController } from './controllers/allocation-controller';
import { transactionController } from './controllers/transaction-controller';
import { insuranceController } from './controllers/insurance-controller';
import { projectionController } from './controllers/projection-controller';

export async function routes(app: FastifyInstance) {
  // Health check
  app.get('/health', async () => ({ status: 'ok', timestamp: new Date().toISOString() }));
  
  // Registrar controllers
  await app.register(clientController);
  await app.register(simulationController);
  await app.register(allocationController);
  await app.register(transactionController);
  await app.register(insuranceController);
  await app.register(projectionController);
}
```

### Arquivo: src/app.ts (atualizado)

```typescript
import Fastify from 'fastify';
import cors from '@fastify/cors';
import swagger from '@fastify/swagger';
import swaggerUi from '@fastify/swagger-ui';
import { serializerCompiler, validatorCompiler, ZodTypeProvider } from '@fastify/type-provider-zod';
import { routes } from './infra/http/routes';
import { errorHandler } from './infra/http/error-handler';
import { env } from './env';

export async function buildApp() {
  const app = Fastify({
    logger: {
      level: env.LOG_LEVEL,
      transport: env.NODE_ENV === 'development' 
        ? { target: 'pino-pretty' } 
        : undefined,
    },
  }).withTypeProvider<ZodTypeProvider>();
  
  // Zod Type Provider
  app.setValidatorCompiler(validatorCompiler);
  app.setSerializerCompiler(serializerCompiler);
  
  // CORS
  await app.register(cors, {
    origin: env.CORS_ORIGIN,
  });
  
  // Swagger
  await app.register(swagger, {
    openapi: {
      info: {
        title: 'MFO API',
        description: 'API do Multi Family Office',
        version: '1.0.0',
      },
      tags: [
        { name: 'Clients', description: 'Gestão de clientes' },
        { name: 'Simulations', description: 'Simulações de projeção' },
        { name: 'Allocations', description: 'Alocações de patrimônio' },
        { name: 'Transactions', description: 'Movimentações financeiras' },
        { name: 'Insurances', description: 'Seguros' },
        { name: 'Projections', description: 'Projeções e comparações' },
      ],
    },
  });
  
  await app.register(swaggerUi, {
    routePrefix: '/docs',
  });
  
  // Error handler
  app.setErrorHandler(errorHandler);
  
  // Injeção de dependências (decorators)
  // Ver Prompt 4.4
  
  // Rotas
  await app.register(routes);
  
  return app;
}
```

### Arquivo: src/infra/http/error-handler.ts

```typescript
import { FastifyError, FastifyReply, FastifyRequest } from 'fastify';
import { ZodError } from 'zod';

export function errorHandler(
  error: FastifyError,
  request: FastifyRequest,
  reply: FastifyReply
) {
  request.log.error(error);
  
  // Erro de validação Zod
  if (error instanceof ZodError) {
    return reply.status(400).send({
      message: 'Erro de validação',
      errors: error.errors.map(e => ({
        path: e.path.join('.'),
        message: e.message,
      })),
    });
  }
  
  // Erro de validação Fastify/Zod Type Provider
  if (error.validation) {
    return reply.status(400).send({
      message: 'Erro de validação',
      errors: error.validation,
    });
  }
  
  // Erros conhecidos
  if (error.statusCode) {
    return reply.status(error.statusCode).send({
      message: error.message,
    });
  }
  
  // Erro interno
  return reply.status(500).send({
    message: 'Erro interno do servidor',
  });
}
```

### Princípios:
- SOLID (O): Fácil adicionar novos controllers
- KISS: Configuração centralizada
- DRY: Error handler reutilizável
```

---

## 📝 Prompt 4.4 - Injeção de Dependências

```markdown
Configure a injeção de dependências usando decorators do Fastify:

### Arquivo: src/infra/container.ts

```typescript
import { FastifyInstance } from 'fastify';
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import { env } from '../env';

// Repositories
import { DrizzleClientRepository } from './repositories/drizzle-client-repository';
import { DrizzleSimulationRepository } from './repositories/drizzle-simulation-repository';
import { DrizzleAllocationRepository } from './repositories/drizzle-allocation-repository';
import { DrizzleTransactionRepository } from './repositories/drizzle-transaction-repository';
import { DrizzleInsuranceRepository } from './repositories/drizzle-insurance-repository';

// Services
import { SimulationService } from '../application/services/simulation-service';
import { ProjectionEngineImpl } from '../domain/services/projection-engine-impl';

declare module 'fastify' {
  interface FastifyInstance {
    // Repositories
    clientRepository: DrizzleClientRepository;
    simulationRepository: DrizzleSimulationRepository;
    allocationRepository: DrizzleAllocationRepository;
    transactionRepository: DrizzleTransactionRepository;
    insuranceRepository: DrizzleInsuranceRepository;
    
    // Services
    simulationService: SimulationService;
    projectionEngine: ProjectionEngineImpl;
  }
}

export async function setupContainer(app: FastifyInstance) {
  // Database
  const pool = new Pool({
    connectionString: env.DATABASE_URL,
  });
  
  const db = drizzle(pool);
  
  // Repositories
  const clientRepository = new DrizzleClientRepository(db);
  const simulationRepository = new DrizzleSimulationRepository(db);
  const allocationRepository = new DrizzleAllocationRepository(db);
  const transactionRepository = new DrizzleTransactionRepository(db);
  const insuranceRepository = new DrizzleInsuranceRepository(db);
  
  // Engine
  const projectionEngine = new ProjectionEngineImpl();
  
  // Services
  const simulationService = new SimulationService(
    simulationRepository,
    allocationRepository,
    transactionRepository,
    insuranceRepository,
    projectionEngine,
  );
  
  // Decorators
  app.decorate('clientRepository', clientRepository);
  app.decorate('simulationRepository', simulationRepository);
  app.decorate('allocationRepository', allocationRepository);
  app.decorate('transactionRepository', transactionRepository);
  app.decorate('insuranceRepository', insuranceRepository);
  app.decorate('simulationService', simulationService);
  app.decorate('projectionEngine', projectionEngine);
  
  // Graceful shutdown
  app.addHook('onClose', async () => {
    await pool.end();
  });
}
```

### Atualizar src/app.ts:

```typescript
// Após registrar plugins, antes das rotas
await setupContainer(app);
```

### Princípios:
- SOLID (D): Controllers dependem de abstrações via decorators
- SOLID (S): Container responsável apenas por injeção
- Facilita testes com mocks
```

---

## 📝 Prompt 4.5 - Testes de Integração

```markdown
Crie testes de integração para a API:

### Arquivo: src/infra/http/__tests__/api.test.ts

```typescript
import { describe, it, expect, beforeAll, afterAll, beforeEach } from 'vitest';
import { FastifyInstance } from 'fastify';
import { buildApp } from '../../../app';

describe('API Integration Tests', () => {
  let app: FastifyInstance;
  
  beforeAll(async () => {
    app = await buildApp();
    await app.ready();
  });
  
  afterAll(async () => {
    await app.close();
  });
  
  describe('Health Check', () => {
    it('GET /health should return 200', async () => {
      const response = await app.inject({
        method: 'GET',
        url: '/health',
      });
      
      expect(response.statusCode).toBe(200);
      expect(response.json()).toHaveProperty('status', 'ok');
    });
  });
  
  describe('Clients', () => {
    let clientId: string;
    
    it('POST /clients should create a client', async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/clients',
        payload: {
          name: 'Test Client',
          email: 'test@example.com',
        },
      });
      
      expect(response.statusCode).toBe(201);
      const body = response.json();
      expect(body).toHaveProperty('id');
      expect(body.name).toBe('Test Client');
      clientId = body.id;
    });
    
    it('GET /clients should list clients', async () => {
      const response = await app.inject({
        method: 'GET',
        url: '/clients',
      });
      
      expect(response.statusCode).toBe(200);
      expect(Array.isArray(response.json())).toBe(true);
    });
    
    it('GET /clients/:id should return client', async () => {
      const response = await app.inject({
        method: 'GET',
        url: `/clients/${clientId}`,
      });
      
      expect(response.statusCode).toBe(200);
      expect(response.json().id).toBe(clientId);
    });
    
    it('POST /clients with invalid data should return 400', async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/clients',
        payload: {
          name: '', // inválido
          email: 'not-an-email', // inválido
        },
      });
      
      expect(response.statusCode).toBe(400);
    });
  });
  
  describe('Simulations', () => {
    let clientId: string;
    let simulationId: string;
    
    beforeAll(async () => {
      // Criar cliente para testes
      const response = await app.inject({
        method: 'POST',
        url: '/clients',
        payload: {
          name: 'Simulation Test Client',
          email: 'sim-test@example.com',
        },
      });
      clientId = response.json().id;
    });
    
    it('POST /clients/:clientId/simulations should create simulation', async () => {
      const response = await app.inject({
        method: 'POST',
        url: `/clients/${clientId}/simulations`,
        payload: {
          name: 'Plano Teste',
          startDate: '2024-01-01T00:00:00.000Z',
          interestRate: 0.1,
          inflationRate: 0.04,
          lifeStatus: 'normal',
        },
      });
      
      expect(response.statusCode).toBe(201);
      const body = response.json();
      expect(body.name).toBe('Plano Teste');
      simulationId = body.id;
    });
    
    it('POST with duplicate name should return 409', async () => {
      const response = await app.inject({
        method: 'POST',
        url: `/clients/${clientId}/simulations`,
        payload: {
          name: 'Plano Teste', // mesmo nome
          startDate: '2024-01-01T00:00:00.000Z',
          interestRate: 0.1,
          inflationRate: 0.04,
        },
      });
      
      expect(response.statusCode).toBe(409);
    });
    
    it('GET /simulations/:id/projection should return projection', async () => {
      const response = await app.inject({
        method: 'GET',
        url: `/simulations/${simulationId}/projection`,
      });
      
      expect(response.statusCode).toBe(200);
      const body = response.json();
      expect(body).toHaveProperty('yearly');
      expect(body).toHaveProperty('summary');
    });
    
    it('POST /simulations/:id/versions should create version', async () => {
      const response = await app.inject({
        method: 'POST',
        url: `/simulations/${simulationId}/versions`,
      });
      
      expect(response.statusCode).toBe(201);
      expect(response.json()).toHaveProperty('versionNumber', 1);
    });
  });
  
  describe('Allocations', () => {
    let clientId: string;
    
    beforeAll(async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/clients',
        payload: {
          name: 'Allocation Test Client',
          email: 'alloc-test@example.com',
        },
      });
      clientId = response.json().id;
    });
    
    it('POST /clients/:clientId/allocations should create allocation', async () => {
      const response = await app.inject({
        method: 'POST',
        url: `/clients/${clientId}/allocations`,
        payload: {
          referenceDate: '2024-01-01T00:00:00.000Z',
          type: 'financial',
          name: 'CDB',
          value: 100000,
          isFinanced: false,
        },
      });
      
      expect(response.statusCode).toBe(201);
      expect(response.json().name).toBe('CDB');
    });
    
    it('POST with financing should include financing data', async () => {
      const response = await app.inject({
        method: 'POST',
        url: `/clients/${clientId}/allocations`,
        payload: {
          referenceDate: '2024-01-01T00:00:00.000Z',
          type: 'property',
          name: 'Apartamento',
          value: 500000,
          isFinanced: true,
          financingData: {
            downPayment: 100000,
            installments: 360,
            interestRate: 0.0075,
            amortizationType: 'sac',
            paidInstallments: 0,
          },
        },
      });
      
      expect(response.statusCode).toBe(201);
      expect(response.json().financingData).not.toBeNull();
    });
    
    it('POST /clients/:clientId/allocations/copy should copy allocations', async () => {
      const response = await app.inject({
        method: 'POST',
        url: `/clients/${clientId}/allocations/copy`,
        payload: {
          fromDate: '2024-01-01T00:00:00.000Z',
          toDate: '2024-06-01T00:00:00.000Z',
        },
      });
      
      expect(response.statusCode).toBe(201);
    });
  });
});
```

### Princípios:
- Testes isolados por domínio
- Setup e teardown adequados
- Testar casos de sucesso e erro
```

---

## ✅ Validação da Fase 4

```bash
# Rodar servidor
npm run dev

# Acessar Swagger
open http://localhost:3333/docs

# Rodar testes de integração
npm run test -- --filter api

# Testar endpoints manualmente
curl http://localhost:3333/health
curl http://localhost:3333/clients
```

### Critérios de Sucesso:
- [ ] Swagger UI funcional em /docs
- [ ] Todos endpoints documentados
- [ ] Validação Zod funcionando
- [ ] Testes de integração passando
- [ ] Error handler tratando erros

---

## 📚 Arquivos Criados nesta Fase

```
backend/src/
├── app.ts (atualizado)
└── infra/
    ├── container.ts
    └── http/
        ├── routes.ts
        ├── error-handler.ts
        ├── schemas/
        │   └── index.ts
        ├── controllers/
        │   ├── client-controller.ts
        │   ├── simulation-controller.ts
        │   ├── allocation-controller.ts
        │   ├── transaction-controller.ts
        │   ├── insurance-controller.ts
        │   └── projection-controller.ts
        └── __tests__/
            └── api.test.ts
```

---

## 🔄 Próxima Fase

Após validar todos os checkpoints, siga para:
**[Fase 5 - Frontend Setup](./05-frontend-setup.md)**
