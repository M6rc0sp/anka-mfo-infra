# ⚙️ Fase 3 - Motor de Projeção

## 📋 Objetivo
Implementar o motor de cálculo de projeção patrimonial, considerando alocações, movimentações, seguros e status de vida.

---

### 🎯 Entregáveis desta Fase

- [x] Motor de projeção implementado
- [x] Cálculos de juros compostos funcionando
- [x] Timeline de movimentações processada
- [x] Seguros integrados no cálculo
- [x] Status de vida impactando projeção
- [x] Testes automatizados cobrindo cenários principais

---

## 📐 Conceitos do Motor de Projeção

### Granularidade
- **Mensal**: Mais preciso, mais dados
- **Recomendado**: Mensal para cálculo, agregado anual para exibição

### Fórmulas Base

```
Patrimônio(t+1) = Patrimônio(t) * (1 + taxa_real) + Entradas(t) - Saídas(t)

Onde:
- taxa_real = (1 + juros) / (1 + inflação) - 1 (aproximação)
- Entradas = salários + aportes + rendas + seguros (se aplicável)
- Saídas = despesas + resgates + prêmios de seguro
```

### Impacto do Status de Vida

| Status | Entradas | Despesas | Seguros |
|--------|----------|----------|---------|
| Normal | 100% | 100% | Paga prêmio |
| Morto | 0% | 50% | Recebe vida |
| Inválido | 0% | 100% | Recebe invalidez |

---

## 📝 Prompt 3.1 - Interface do Motor

```markdown
Crie a interface e tipos do motor de projeção:

### Arquivo: src/domain/services/projection-engine.ts

```typescript
// Tipos de entrada
interface ProjectionInput {
  startDate: Date;
  endDate: Date;          // Horizonte da projeção (ex: 30 anos)
  
  // Parâmetros econômicos
  interestRate: number;   // Taxa de juros real anual (decimal)
  inflationRate: number;  // Taxa de inflação anual (decimal)
  
  // Status de vida
  lifeStatus: 'normal' | 'dead' | 'invalid';
  lifeStatusChangeDate?: Date;  // Quando mudou o status
  
  // Dados do cliente
  allocations: AllocationSnapshot[];    // Alocações na data inicial
  transactions: TransactionTimeline[];  // Timeline de movimentações
  insurances: Insurance[];              // Seguros ativos
}

interface AllocationSnapshot {
  type: 'financial' | 'property';
  name: string;
  value: number;
  isFinanced: boolean;
  monthlyPayment?: number;  // Se financiado
  remainingPayments?: number;
}

interface TransactionTimeline {
  type: 'income' | 'expense' | 'deposit' | 'withdrawal';
  name: string;
  value: number;
  startDate: Date;
  endDate: Date;
  interval: 'monthly' | 'yearly';
}

// Tipos de saída
interface ProjectionOutput {
  monthly: MonthlyProjection[];
  yearly: YearlyProjection[];
  summary: ProjectionSummary;
}

interface MonthlyProjection {
  date: Date;
  financialAssets: number;
  propertyAssets: number;
  totalAssets: number;
  totalWithoutInsurance: number;
  entries: number;        // Total de entradas no mês
  exits: number;          // Total de saídas no mês
  insurancePremiums: number;
  insurancePayouts: number;
}

interface YearlyProjection {
  year: number;
  financialAssets: number;
  propertyAssets: number;
  totalAssets: number;
  totalWithoutInsurance: number;
}

interface ProjectionSummary {
  initialAssets: number;
  finalAssets: number;
  totalGrowth: number;
  totalGrowthPercent: number;
  totalEntries: number;
  totalExits: number;
  insuranceImpact: number;  // Diferença com vs sem seguro
}

// Interface do serviço
interface ProjectionEngine {
  calculate(input: ProjectionInput): ProjectionOutput;
}
```

### Princípios:
- SOLID (S): Engine focado apenas em cálculo
- SOLID (O): Extensível para novos tipos de ativos
- KISS: Interface clara e direta
```

---

## 📝 Prompt 3.2 - Implementação do Motor

```markdown
Implemente o motor de projeção:

### Arquivo: src/domain/services/projection-engine-impl.ts

```typescript
export class ProjectionEngineImpl implements ProjectionEngine {
  calculate(input: ProjectionInput): ProjectionOutput {
    const monthly = this.calculateMonthly(input);
    const yearly = this.aggregateYearly(monthly);
    const summary = this.generateSummary(monthly, input);
    
    return { monthly, yearly, summary };
  }
  
  private calculateMonthly(input: ProjectionInput): MonthlyProjection[] {
    const projections: MonthlyProjection[] = [];
    
    // Estado inicial
    let financialAssets = this.sumAllocations(input.allocations, 'financial');
    let propertyAssets = this.sumAllocations(input.allocations, 'property');
    let financialWithoutInsurance = financialAssets;
    
    // Taxa mensal
    const monthlyRate = this.getMonthlyRate(input.interestRate, input.inflationRate);
    
    // Iterar mês a mês
    let currentDate = new Date(input.startDate);
    while (currentDate <= input.endDate) {
      const lifeStatus = this.getLifeStatus(currentDate, input);
      
      // Calcular movimentações do mês
      const entries = this.calculateEntries(currentDate, input.transactions, lifeStatus);
      const exits = this.calculateExits(currentDate, input.transactions, lifeStatus);
      
      // Calcular seguros
      const { premiums, payouts } = this.calculateInsurance(
        currentDate, 
        input.insurances, 
        lifeStatus
      );
      
      // Calcular financiamentos (saídas)
      const financingPayments = this.calculateFinancingPayments(
        currentDate, 
        input.allocations
      );
      
      // Atualizar patrimônio financeiro
      financialAssets = financialAssets * (1 + monthlyRate) 
                       + entries 
                       - exits 
                       - premiums 
                       + payouts 
                       - financingPayments;
      
      // Sem seguro (para comparação)
      financialWithoutInsurance = financialWithoutInsurance * (1 + monthlyRate) 
                                 + entries 
                                 - exits 
                                 - financingPayments;
      
      // Atualizar patrimônio imobilizado (valorização)
      propertyAssets = this.updatePropertyAssets(
        propertyAssets, 
        currentDate, 
        input
      );
      
      projections.push({
        date: new Date(currentDate),
        financialAssets: Math.max(0, financialAssets),
        propertyAssets,
        totalAssets: Math.max(0, financialAssets) + propertyAssets,
        totalWithoutInsurance: Math.max(0, financialWithoutInsurance) + propertyAssets,
        entries,
        exits,
        insurancePremiums: premiums,
        insurancePayouts: payouts,
      });
      
      // Próximo mês
      currentDate.setMonth(currentDate.getMonth() + 1);
    }
    
    return projections;
  }
  
  // ... implementar métodos auxiliares
}
```

### Métodos auxiliares a implementar:

1. **getMonthlyRate(annual, inflation)**: Converte taxa anual em mensal
2. **getLifeStatus(date, input)**: Retorna status de vida na data
3. **calculateEntries(date, transactions, status)**: Soma entradas do mês
4. **calculateExits(date, transactions, status)**: Soma saídas do mês
5. **calculateInsurance(date, insurances, status)**: Calcula prêmios e payouts
6. **calculateFinancingPayments(date, allocations)**: Calcula parcelas
7. **updatePropertyAssets(current, date, input)**: Atualiza valor dos imóveis
8. **aggregateYearly(monthly)**: Agrupa dados por ano
9. **generateSummary(monthly, input)**: Gera resumo

### Regras de Negócio:

1. **Status Normal**:
   - Todas entradas e saídas normais
   - Paga prêmios de seguro

2. **Status Morto**:
   - Entradas (salários) = 0
   - Despesas = 50% do valor
   - Recebe seguro de VIDA (se tiver)
   - NÃO recebe seguro de invalidez

3. **Status Inválido**:
   - Entradas (salários) = 0
   - Despesas = 100% do valor
   - Recebe seguro de INVALIDEZ (se tiver)
   - NÃO recebe seguro de vida

4. **Financiamentos**:
   - Deduzir parcelas mensais do patrimônio
   - Quando quitado, para de deduzir

5. **Imóveis**:
   - Valorização = inflação (simplificação)
   - Ou taxa customizada

### Princípios:
- KISS: Fórmulas simples e documentadas
- DRY: Reutilizar cálculos comuns
- SOLID (S): Métodos com responsabilidade única
```

---

## 📝 Prompt 3.3 - Testes do Motor de Projeção

```markdown
Crie testes automatizados para o motor de projeção:

### Arquivo: src/domain/services/__tests__/projection-engine.test.ts

```typescript
import { describe, it, expect, beforeEach } from 'vitest';
import { ProjectionEngineImpl } from '../projection-engine-impl';

describe('ProjectionEngine', () => {
  let engine: ProjectionEngineImpl;
  
  beforeEach(() => {
    engine = new ProjectionEngineImpl();
  });
  
  describe('Cenário básico sem movimentações', () => {
    it('deve calcular crescimento apenas com juros compostos', () => {
      const input = {
        startDate: new Date('2024-01-01'),
        endDate: new Date('2025-01-01'),
        interestRate: 0.10,  // 10% ao ano
        inflationRate: 0.04, // 4% ao ano
        lifeStatus: 'normal' as const,
        allocations: [
          { type: 'financial' as const, name: 'CDB', value: 100000, isFinanced: false }
        ],
        transactions: [],
        insurances: [],
      };
      
      const result = engine.calculate(input);
      
      // Taxa real ≈ 5.77% ao ano
      // 100.000 * 1.0577 ≈ 105.770
      expect(result.summary.finalAssets).toBeCloseTo(105770, -2);
    });
  });
  
  describe('Cenário com movimentações recorrentes', () => {
    it('deve considerar salário e despesas mensais', () => {
      const input = {
        startDate: new Date('2024-01-01'),
        endDate: new Date('2025-01-01'),
        interestRate: 0.10,
        inflationRate: 0.04,
        lifeStatus: 'normal' as const,
        allocations: [
          { type: 'financial' as const, name: 'Poupança', value: 50000, isFinanced: false }
        ],
        transactions: [
          {
            type: 'income' as const,
            name: 'Salário',
            value: 10000,
            startDate: new Date('2024-01-01'),
            endDate: new Date('2025-01-01'),
            interval: 'monthly' as const,
          },
          {
            type: 'expense' as const,
            name: 'Despesas',
            value: 7000,
            startDate: new Date('2024-01-01'),
            endDate: new Date('2025-01-01'),
            interval: 'monthly' as const,
          },
        ],
        insurances: [],
      };
      
      const result = engine.calculate(input);
      
      // Sobra 3.000/mês * 12 = 36.000 + crescimento do patrimônio
      expect(result.summary.finalAssets).toBeGreaterThan(50000 + 36000);
    });
  });
  
  describe('Cenário com seguro de vida - status normal', () => {
    it('deve deduzir prêmio mensal sem pagar cobertura', () => {
      const input = {
        startDate: new Date('2024-01-01'),
        endDate: new Date('2024-07-01'),
        interestRate: 0.10,
        inflationRate: 0.04,
        lifeStatus: 'normal' as const,
        allocations: [
          { type: 'financial' as const, name: 'Investimentos', value: 100000, isFinanced: false }
        ],
        transactions: [],
        insurances: [
          {
            id: '1',
            clientId: '1',
            type: 'life' as const,
            name: 'Seguro Vida',
            startDate: new Date('2024-01-01'),
            durationMonths: 240,
            monthlyPremium: 500,
            coverageValue: 1000000,
            createdAt: new Date(),
            updatedAt: new Date(),
          },
        ],
      };
      
      const result = engine.calculate(input);
      
      // Deve ter pago 6 meses de prêmio = 3.000
      const totalPremiums = result.monthly.reduce((sum, m) => sum + m.insurancePremiums, 0);
      expect(totalPremiums).toBe(3000);
      
      // Sem payouts
      const totalPayouts = result.monthly.reduce((sum, m) => sum + m.insurancePayouts, 0);
      expect(totalPayouts).toBe(0);
    });
  });
  
  describe('Cenário com seguro de vida - status morto', () => {
    it('deve pagar cobertura de vida e reduzir despesas', () => {
      const input = {
        startDate: new Date('2024-01-01'),
        endDate: new Date('2024-07-01'),
        interestRate: 0.10,
        inflationRate: 0.04,
        lifeStatus: 'dead' as const,
        lifeStatusChangeDate: new Date('2024-03-01'),
        allocations: [
          { type: 'financial' as const, name: 'Investimentos', value: 100000, isFinanced: false }
        ],
        transactions: [
          {
            type: 'expense' as const,
            name: 'Despesas',
            value: 5000,
            startDate: new Date('2024-01-01'),
            endDate: new Date('2024-12-01'),
            interval: 'monthly' as const,
          },
        ],
        insurances: [
          {
            id: '1',
            clientId: '1',
            type: 'life' as const,
            name: 'Seguro Vida',
            startDate: new Date('2024-01-01'),
            durationMonths: 240,
            monthlyPremium: 500,
            coverageValue: 1000000,
            createdAt: new Date(),
            updatedAt: new Date(),
          },
        ],
      };
      
      const result = engine.calculate(input);
      
      // Deve ter recebido cobertura em março
      const marchData = result.monthly.find(
        m => m.date.getMonth() === 2 && m.date.getFullYear() === 2024
      );
      expect(marchData?.insurancePayouts).toBe(1000000);
      
      // Despesas após morte devem ser 50%
      const juneData = result.monthly.find(
        m => m.date.getMonth() === 5 && m.date.getFullYear() === 2024
      );
      expect(juneData?.exits).toBe(2500); // 5000 * 0.5
    });
  });
  
  describe('Cenário com seguro invalidez - status inválido', () => {
    it('deve pagar cobertura de invalidez e manter despesas', () => {
      const input = {
        startDate: new Date('2024-01-01'),
        endDate: new Date('2024-07-01'),
        interestRate: 0.10,
        inflationRate: 0.04,
        lifeStatus: 'invalid' as const,
        lifeStatusChangeDate: new Date('2024-03-01'),
        allocations: [
          { type: 'financial' as const, name: 'Investimentos', value: 100000, isFinanced: false }
        ],
        transactions: [
          {
            type: 'expense' as const,
            name: 'Despesas',
            value: 5000,
            startDate: new Date('2024-01-01'),
            endDate: new Date('2024-12-01'),
            interval: 'monthly' as const,
          },
        ],
        insurances: [
          {
            id: '1',
            clientId: '1',
            type: 'disability' as const,
            name: 'Seguro Invalidez',
            startDate: new Date('2024-01-01'),
            durationMonths: 240,
            monthlyPremium: 300,
            coverageValue: 800000,
            createdAt: new Date(),
            updatedAt: new Date(),
          },
        ],
      };
      
      const result = engine.calculate(input);
      
      // Deve ter recebido cobertura de invalidez em março
      const marchData = result.monthly.find(
        m => m.date.getMonth() === 2 && m.date.getFullYear() === 2024
      );
      expect(marchData?.insurancePayouts).toBe(800000);
      
      // Despesas após invalidez devem ser 100%
      const juneData = result.monthly.find(
        m => m.date.getMonth() === 5 && m.date.getFullYear() === 2024
      );
      expect(juneData?.exits).toBe(5000); // Mantém 100%
    });
  });
  
  describe('Cenário com financiamento', () => {
    it('deve deduzir parcelas do patrimônio', () => {
      const input = {
        startDate: new Date('2024-01-01'),
        endDate: new Date('2024-07-01'),
        interestRate: 0.10,
        inflationRate: 0.04,
        lifeStatus: 'normal' as const,
        allocations: [
          { type: 'financial' as const, name: 'Investimentos', value: 100000, isFinanced: false },
          { 
            type: 'property' as const, 
            name: 'Apartamento', 
            value: 500000, 
            isFinanced: true,
            monthlyPayment: 3000,
            remainingPayments: 120,
          },
        ],
        transactions: [],
        insurances: [],
      };
      
      const result = engine.calculate(input);
      
      // Deve ter pago 6 parcelas = 18.000
      // O patrimônio líquido deve refletir isso
      expect(result.summary.finalAssets).toBeLessThan(100000 + 500000 - 18000 + 5000); // +5000 de juros aprox
    });
  });
  
  describe('Comparação com e sem seguro', () => {
    it('deve mostrar diferença entre totalAssets e totalWithoutInsurance', () => {
      const input = {
        startDate: new Date('2024-01-01'),
        endDate: new Date('2024-12-01'),
        interestRate: 0.10,
        inflationRate: 0.04,
        lifeStatus: 'normal' as const,
        allocations: [
          { type: 'financial' as const, name: 'Investimentos', value: 100000, isFinanced: false },
        ],
        transactions: [],
        insurances: [
          {
            id: '1',
            clientId: '1',
            type: 'life' as const,
            name: 'Seguro Vida',
            startDate: new Date('2024-01-01'),
            durationMonths: 240,
            monthlyPremium: 500,
            coverageValue: 1000000,
            createdAt: new Date(),
            updatedAt: new Date(),
          },
        ],
      };
      
      const result = engine.calculate(input);
      
      // Último mês
      const lastMonth = result.monthly[result.monthly.length - 1];
      
      // Com seguro deve ser menor (paga prêmio)
      expect(lastMonth.totalAssets).toBeLessThan(lastMonth.totalWithoutInsurance);
      
      // Diferença deve ser aproximadamente o total de prêmios pagos + juros perdidos
      const premiumsPaid = 11 * 500; // 11 meses
      expect(lastMonth.totalWithoutInsurance - lastMonth.totalAssets).toBeGreaterThan(premiumsPaid);
    });
  });
});
```

### Princípios:
- Testes devem ser claros e documentar comportamento esperado
- Cada cenário isolado
- Verificar edge cases
```

---

## 📝 Prompt 3.4 - Serviço de Simulação

```markdown
Crie o serviço que orquestra a criação e execução de simulações:

### Arquivo: src/application/services/simulation-service.ts

```typescript
export class SimulationService {
  constructor(
    private simulationRepo: SimulationRepository,
    private allocationRepo: AllocationRepository,
    private transactionRepo: TransactionRepository,
    private insuranceRepo: InsuranceRepository,
    private projectionEngine: ProjectionEngine,
  ) {}
  
  // Criar nova simulação
  async create(data: CreateSimulationDTO): Promise<Simulation> {
    // Validar nome único por cliente
    const existing = await this.simulationRepo.findByName(data.clientId, data.name);
    if (existing) {
      throw new Error('Já existe uma simulação com este nome');
    }
    
    return this.simulationRepo.create(data);
  }
  
  // Criar nova versão de simulação existente
  async createVersion(simulationId: string): Promise<SimulationVersion> {
    const simulation = await this.simulationRepo.findById(simulationId);
    if (!simulation) throw new Error('Simulação não encontrada');
    
    // Executar projeção
    const projection = await this.runProjection(simulation);
    
    // Salvar versão
    const latestVersion = await this.simulationRepo.getLatestVersion(simulationId);
    const newVersionNumber = (latestVersion?.versionNumber ?? 0) + 1;
    
    return this.simulationRepo.createVersion({
      simulationId,
      versionNumber: newVersionNumber,
      parameters: {
        startDate: simulation.startDate,
        interestRate: simulation.interestRate,
        inflationRate: simulation.inflationRate,
        lifeStatus: simulation.lifeStatus,
      },
      projectionData: projection.yearly,
    });
  }
  
  // Executar projeção para uma simulação
  async runProjection(simulation: Simulation): Promise<ProjectionOutput> {
    const [allocations, transactions, insurances] = await Promise.all([
      this.allocationRepo.findByClientAndDate(simulation.clientId, simulation.startDate),
      this.transactionRepo.findByClientId(simulation.clientId),
      this.insuranceRepo.findByClientId(simulation.clientId),
    ]);
    
    // Definir horizonte (30 anos por padrão)
    const endDate = new Date(simulation.startDate);
    endDate.setFullYear(endDate.getFullYear() + 30);
    
    const input: ProjectionInput = {
      startDate: simulation.startDate,
      endDate,
      interestRate: simulation.interestRate,
      inflationRate: simulation.inflationRate,
      lifeStatus: simulation.lifeStatus,
      allocations: this.mapAllocations(allocations),
      transactions: this.mapTransactions(transactions),
      insurances,
    };
    
    return this.projectionEngine.calculate(input);
  }
  
  // Calcular "Realizado" a partir das alocações históricas
  async calculateRealized(clientId: string): Promise<ProjectionOutput> {
    const allocationDates = await this.allocationRepo.findAllDatesByClient(clientId);
    
    // Para cada data, somar alocações
    const dataPoints = await Promise.all(
      allocationDates.map(async (date) => {
        const allocations = await this.allocationRepo.findByClientAndDate(clientId, date);
        const financial = allocations
          .filter(a => a.type === 'financial')
          .reduce((sum, a) => sum + a.value, 0);
        const property = allocations
          .filter(a => a.type === 'property')
          .reduce((sum, a) => sum + a.value, 0);
        
        return {
          date,
          financialAssets: financial,
          propertyAssets: property,
          totalAssets: financial + property,
          totalWithoutInsurance: financial + property,
        };
      })
    );
    
    return {
      monthly: [],
      yearly: dataPoints.map(d => ({
        year: d.date.getFullYear(),
        ...d,
      })),
      summary: this.calculateSummary(dataPoints),
    };
  }
  
  // Comparar simulações
  async compare(simulationIds: string[]): Promise<ComparisonResult> {
    const results = await Promise.all(
      simulationIds.map(async (id) => {
        const simulation = await this.simulationRepo.findById(id);
        if (!simulation) throw new Error(`Simulação ${id} não encontrada`);
        
        const projection = await this.runProjection(simulation);
        return { simulation, projection };
      })
    );
    
    return {
      simulations: results.map(r => r.simulation),
      projections: results.map(r => r.projection),
    };
  }
}
```

### Princípios:
- SOLID (S): Serviço focado em orquestração de simulações
- SOLID (D): Depende de interfaces (repositórios, engine)
- DRY: Reutiliza métodos de mapeamento
```

---

## ✅ Validação da Fase 3

```bash
# Rodar testes do motor
npm run test -- --filter projection-engine

# Verificar cobertura
npm run test:coverage

# Testes devem passar:
# ✓ Cenário básico sem movimentações
# ✓ Cenário com movimentações recorrentes  
# ✓ Cenário com seguro de vida - status normal
# ✓ Cenário com seguro de vida - status morto
# ✓ Cenário com seguro invalidez - status inválido
# ✓ Cenário com financiamento
# ✓ Comparação com e sem seguro
```

### Critérios de Sucesso:
- [ ] Todos os testes passando
- [ ] Cobertura > 80% no motor
- [ ] Cálculos condizentes com fórmulas
- [ ] Status de vida impactando corretamente

---

## 📚 Arquivos Criados nesta Fase

```
backend/src/
├── domain/
│   └── services/
│       ├── projection-engine.ts           # Interface
│       ├── projection-engine-impl.ts      # Implementação
│       └── __tests__/
│           └── projection-engine.test.ts  # Testes
└── application/
    └── services/
        └── simulation-service.ts          # Orquestração
```

---

## 🔄 Próxima Fase

Após validar todos os checkpoints, siga para:
**[Fase 4 - API REST](./04-api-rest.md)**
