# 📱 Fase 6 - Frontend Telas

## 📋 Objetivo
Implementar as três telas principais da aplicação: Projeção, Alocações e Histórico, seguindo o design do Figma.

---

## 🎯 Entregáveis desta Fase

- [ ] Tela de Projeção completa
- [ ] Tela de Alocações completa
- [ ] Tela de Histórico completa
- [ ] Componentes de gráficos reutilizáveis
- [ ] Modais de criação/edição
- [ ] Hooks de dados funcionais

---

## 📝 Prompt 6.1 - Hooks de Dados (React Query)

```markdown
Crie os hooks para consumir a API usando React Query:

### Arquivo: src/hooks/use-clients.ts

```typescript
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from '@/services/api';
import { Client, CreateClientPayload } from '@/types';

const QUERY_KEY = 'clients';

export function useClients() {
  return useQuery<Client[]>({
    queryKey: [QUERY_KEY],
    queryFn: async () => {
      const { data } = await api.get('/clients');
      return data;
    },
  });
}

export function useClient(id: string) {
  return useQuery<Client>({
    queryKey: [QUERY_KEY, id],
    queryFn: async () => {
      const { data } = await api.get(`/clients/${id}`);
      return data;
    },
    enabled: !!id,
  });
}

export function useCreateClient() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: async (payload: CreateClientPayload) => {
      const { data } = await api.post('/clients', payload);
      return data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
    },
  });
}
```

### Arquivo: src/hooks/use-simulations.ts

```typescript
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from '@/services/api';
import { 
  Simulation, 
  SimulationVersion, 
  CreateSimulationPayload,
  ProjectionResult,
} from '@/types';

const QUERY_KEY = 'simulations';

export function useSimulations(clientId: string) {
  return useQuery<Simulation[]>({
    queryKey: [QUERY_KEY, clientId],
    queryFn: async () => {
      const { data } = await api.get(`/clients/${clientId}/simulations`);
      return data;
    },
    enabled: !!clientId,
  });
}

export function useSimulation(id: string) {
  return useQuery<Simulation>({
    queryKey: [QUERY_KEY, 'detail', id],
    queryFn: async () => {
      const { data } = await api.get(`/simulations/${id}`);
      return data;
    },
    enabled: !!id,
  });
}

export function useSimulationVersions(simulationId: string) {
  return useQuery<SimulationVersion[]>({
    queryKey: [QUERY_KEY, simulationId, 'versions'],
    queryFn: async () => {
      const { data } = await api.get(`/simulations/${simulationId}/versions`);
      return data;
    },
    enabled: !!simulationId,
  });
}

export function useProjection(simulationId: string, years = 30) {
  return useQuery<ProjectionResult>({
    queryKey: [QUERY_KEY, simulationId, 'projection', years],
    queryFn: async () => {
      const { data } = await api.get(`/simulations/${simulationId}/projection`, {
        params: { years },
      });
      return data;
    },
    enabled: !!simulationId,
  });
}

export function useCreateSimulation(clientId: string) {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: async (payload: CreateSimulationPayload) => {
      const { data } = await api.post(`/clients/${clientId}/simulations`, payload);
      return data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY, clientId] });
    },
  });
}

export function useUpdateSimulation() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: async ({ id, ...payload }: Partial<Simulation> & { id: string }) => {
      const { data } = await api.put(`/simulations/${id}`, payload);
      return data;
    },
    onSuccess: (data) => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY, 'detail', data.id] });
    },
  });
}

export function useDeleteSimulation() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: async (id: string) => {
      await api.delete(`/simulations/${id}`);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
    },
  });
}

export function useCreateSimulationVersion(simulationId: string) {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: async () => {
      const { data } = await api.post(`/simulations/${simulationId}/versions`);
      return data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY, simulationId, 'versions'] });
    },
  });
}

export function useCompareSimulations(clientId: string) {
  return useMutation({
    mutationFn: async (simulationIds: string[]) => {
      const { data } = await api.post(`/clients/${clientId}/compare`, { simulationIds });
      return data;
    },
  });
}
```

### Arquivo: src/hooks/use-allocations.ts

```typescript
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from '@/services/api';
import { Allocation, CreateAllocationPayload, CopyAllocationsPayload } from '@/types';

const QUERY_KEY = 'allocations';

export function useAllocationDates(clientId: string) {
  return useQuery<string[]>({
    queryKey: [QUERY_KEY, clientId, 'dates'],
    queryFn: async () => {
      const { data } = await api.get(`/clients/${clientId}/allocations/dates`);
      return data;
    },
    enabled: !!clientId,
  });
}

export function useAllocationsByDate(clientId: string, date: string) {
  return useQuery<Allocation[]>({
    queryKey: [QUERY_KEY, clientId, date],
    queryFn: async () => {
      const { data } = await api.get(`/clients/${clientId}/allocations/${date}`);
      return data;
    },
    enabled: !!clientId && !!date,
  });
}

export function useCreateAllocation(clientId: string) {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: async (payload: CreateAllocationPayload) => {
      const { data } = await api.post(`/clients/${clientId}/allocations`, payload);
      return data;
    },
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY, clientId, variables.referenceDate] });
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY, clientId, 'dates'] });
    },
  });
}

export function useUpdateAllocation() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: async ({ id, ...payload }: Partial<Allocation> & { id: string }) => {
      const { data } = await api.put(`/allocations/${id}`, payload);
      return data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
    },
  });
}

export function useDeleteAllocation() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: async (id: string) => {
      await api.delete(`/allocations/${id}`);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY] });
    },
  });
}

export function useCopyAllocations(clientId: string) {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: async (payload: CopyAllocationsPayload) => {
      const { data } = await api.post(`/clients/${clientId}/allocations/copy`, payload);
      return data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEY, clientId] });
    },
  });
}
```

### Arquivo: src/hooks/use-realized.ts

```typescript
import { useQuery } from '@tanstack/react-query';
import { api } from '@/services/api';
import { ProjectionResult } from '@/types';

export function useRealized(clientId: string) {
  return useQuery<ProjectionResult>({
    queryKey: ['realized', clientId],
    queryFn: async () => {
      const { data } = await api.get(`/clients/${clientId}/realized`);
      return data;
    },
    enabled: !!clientId,
  });
}
```

### Princípios:
- KISS: Hooks simples e focados
- DRY: Reutilizar queryClient
- Invalidação correta de cache
```

---

## 📝 Prompt 6.2 - Componentes de Gráficos

```markdown
Crie os componentes de gráficos usando Recharts:

### Arquivo: src/components/charts/projection-chart.tsx

```typescript
'use client';

import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
  TooltipProps,
} from 'recharts';
import { YearlyProjection } from '@/types';
import { formatCurrency } from '@/lib/utils';

interface ProjectionChartProps {
  data: YearlyProjection[];
  realizedData?: YearlyProjection[];
  showFinancial?: boolean;
  showProperty?: boolean;
  showTotal?: boolean;
  showWithoutInsurance?: boolean;
  showRealized?: boolean;
  height?: number;
}

const COLORS = {
  financial: 'hsl(210, 100%, 52%)',
  property: 'hsl(160, 84%, 39%)',
  total: 'hsl(280, 87%, 66%)',
  realized: 'hsl(45, 93%, 47%)',
  noInsurance: 'hsl(0, 0%, 60%)',
};

function CustomTooltip({ active, payload, label }: TooltipProps<number, string>) {
  if (!active || !payload?.length) return null;

  return (
    <div className="bg-card border border-border rounded-lg p-3 shadow-lg">
      <p className="font-medium mb-2">{label}</p>
      {payload.map((entry, index) => (
        <div key={index} className="flex items-center gap-2 text-sm">
          <span
            className="w-3 h-3 rounded-full"
            style={{ backgroundColor: entry.color }}
          />
          <span className="text-muted-foreground">{entry.name}:</span>
          <span className="font-medium">{formatCurrency(entry.value as number)}</span>
        </div>
      ))}
    </div>
  );
}

export function ProjectionChart({
  data,
  realizedData = [],
  showFinancial = true,
  showProperty = true,
  showTotal = true,
  showWithoutInsurance = false,
  showRealized = true,
  height = 400,
}: ProjectionChartProps) {
  // Mesclar dados de projeção com realizado
  const mergedData = data.map((item) => {
    const realized = realizedData.find((r) => r.year === item.year);
    return {
      ...item,
      realized: realized?.totalAssets,
    };
  });

  return (
    <ResponsiveContainer width="100%" height={height}>
      <LineChart
        data={mergedData}
        margin={{ top: 5, right: 30, left: 20, bottom: 5 }}
      >
        <CartesianGrid
          strokeDasharray="3 3"
          stroke="hsl(var(--border))"
          opacity={0.3}
        />
        <XAxis
          dataKey="year"
          stroke="hsl(var(--muted-foreground))"
          fontSize={12}
        />
        <YAxis
          stroke="hsl(var(--muted-foreground))"
          fontSize={12}
          tickFormatter={(value) => `${(value / 1000000).toFixed(1)}M`}
        />
        <Tooltip content={<CustomTooltip />} />
        <Legend />

        {showFinancial && (
          <Line
            type="monotone"
            dataKey="financialAssets"
            name="Financeiro"
            stroke={COLORS.financial}
            strokeWidth={2}
            dot={false}
          />
        )}

        {showProperty && (
          <Line
            type="monotone"
            dataKey="propertyAssets"
            name="Imobilizado"
            stroke={COLORS.property}
            strokeWidth={2}
            dot={false}
          />
        )}

        {showTotal && (
          <Line
            type="monotone"
            dataKey="totalAssets"
            name="Total"
            stroke={COLORS.total}
            strokeWidth={3}
            dot={false}
          />
        )}

        {showWithoutInsurance && (
          <Line
            type="monotone"
            dataKey="totalWithoutInsurance"
            name="Sem Seguro"
            stroke={COLORS.noInsurance}
            strokeWidth={2}
            strokeDasharray="5 5"
            dot={false}
          />
        )}

        {showRealized && (
          <Line
            type="monotone"
            dataKey="realized"
            name="Realizado"
            stroke={COLORS.realized}
            strokeWidth={3}
            dot={{ fill: COLORS.realized, strokeWidth: 2 }}
            connectNulls={false}
          />
        )}
      </LineChart>
    </ResponsiveContainer>
  );
}
```

### Arquivo: src/components/charts/stacked-area-chart.tsx

```typescript
'use client';

import {
  AreaChart,
  Area,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
  TooltipProps,
} from 'recharts';
import { formatCurrency } from '@/lib/utils';

interface DataPoint {
  year: number;
  [key: string]: number;
}

interface StackedAreaChartProps {
  data: DataPoint[];
  areas: {
    dataKey: string;
    name: string;
    color: string;
  }[];
  height?: number;
}

function CustomTooltip({ active, payload, label }: TooltipProps<number, string>) {
  if (!active || !payload?.length) return null;

  const total = payload.reduce((sum, entry) => sum + (entry.value as number), 0);

  return (
    <div className="bg-card border border-border rounded-lg p-3 shadow-lg">
      <p className="font-medium mb-2">{label}</p>
      {payload.map((entry, index) => (
        <div key={index} className="flex items-center gap-2 text-sm">
          <span
            className="w-3 h-3 rounded-full"
            style={{ backgroundColor: entry.color }}
          />
          <span className="text-muted-foreground">{entry.name}:</span>
          <span className="font-medium">{formatCurrency(entry.value as number)}</span>
        </div>
      ))}
      <div className="border-t border-border mt-2 pt-2">
        <span className="text-muted-foreground">Total:</span>
        <span className="font-medium ml-2">{formatCurrency(total)}</span>
      </div>
    </div>
  );
}

export function StackedAreaChart({
  data,
  areas,
  height = 300,
}: StackedAreaChartProps) {
  return (
    <ResponsiveContainer width="100%" height={height}>
      <AreaChart
        data={data}
        margin={{ top: 10, right: 30, left: 0, bottom: 0 }}
      >
        <CartesianGrid
          strokeDasharray="3 3"
          stroke="hsl(var(--border))"
          opacity={0.3}
        />
        <XAxis
          dataKey="year"
          stroke="hsl(var(--muted-foreground))"
          fontSize={12}
        />
        <YAxis
          stroke="hsl(var(--muted-foreground))"
          fontSize={12}
          tickFormatter={(value) => `${(value / 1000000).toFixed(1)}M`}
        />
        <Tooltip content={<CustomTooltip />} />
        <Legend />

        {areas.map((area) => (
          <Area
            key={area.dataKey}
            type="monotone"
            dataKey={area.dataKey}
            name={area.name}
            stackId="1"
            stroke={area.color}
            fill={area.color}
            fillOpacity={0.6}
          />
        ))}
      </AreaChart>
    </ResponsiveContainer>
  );
}
```

### Arquivo: src/components/charts/comparison-chart.tsx

```typescript
'use client';

import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
} from 'recharts';
import { Simulation, YearlyProjection } from '@/types';
import { formatCurrency } from '@/lib/utils';

interface ComparisonChartProps {
  simulations: {
    simulation: Simulation;
    projection: YearlyProjection[];
  }[];
  realizedData?: YearlyProjection[];
  height?: number;
}

const COMPARISON_COLORS = [
  'hsl(210, 100%, 52%)',
  'hsl(160, 84%, 39%)',
  'hsl(280, 87%, 66%)',
  'hsl(340, 82%, 52%)',
  'hsl(30, 100%, 50%)',
];

export function ComparisonChart({
  simulations,
  realizedData = [],
  height = 400,
}: ComparisonChartProps) {
  // Preparar dados para o gráfico
  const years = new Set<number>();
  simulations.forEach((s) => s.projection.forEach((p) => years.add(p.year)));
  realizedData.forEach((r) => years.add(r.year));

  const data = Array.from(years)
    .sort((a, b) => a - b)
    .map((year) => {
      const point: Record<string, number> = { year };

      simulations.forEach((s, index) => {
        const yearData = s.projection.find((p) => p.year === year);
        point[`sim_${index}`] = yearData?.totalAssets ?? 0;
      });

      const realized = realizedData.find((r) => r.year === year);
      if (realized) {
        point.realized = realized.totalAssets;
      }

      return point;
    });

  return (
    <ResponsiveContainer width="100%" height={height}>
      <LineChart data={data} margin={{ top: 5, right: 30, left: 20, bottom: 5 }}>
        <CartesianGrid
          strokeDasharray="3 3"
          stroke="hsl(var(--border))"
          opacity={0.3}
        />
        <XAxis
          dataKey="year"
          stroke="hsl(var(--muted-foreground))"
          fontSize={12}
        />
        <YAxis
          stroke="hsl(var(--muted-foreground))"
          fontSize={12}
          tickFormatter={(value) => `${(value / 1000000).toFixed(1)}M`}
        />
        <Tooltip
          formatter={(value: number) => formatCurrency(value)}
          contentStyle={{
            backgroundColor: 'hsl(var(--card))',
            border: '1px solid hsl(var(--border))',
            borderRadius: '8px',
          }}
        />
        <Legend />

        {simulations.map((s, index) => (
          <Line
            key={s.simulation.id}
            type="monotone"
            dataKey={`sim_${index}`}
            name={s.simulation.name}
            stroke={COMPARISON_COLORS[index % COMPARISON_COLORS.length]}
            strokeWidth={2}
            dot={false}
          />
        ))}

        <Line
          type="monotone"
          dataKey="realized"
          name="Realizado"
          stroke="hsl(45, 93%, 47%)"
          strokeWidth={3}
          dot={{ fill: 'hsl(45, 93%, 47%)', strokeWidth: 2 }}
        />
      </LineChart>
    </ResponsiveContainer>
  );
}
```

### Princípios:
- Componentes reutilizáveis
- Cores consistentes com tema
- Tooltip customizado
```

---

## 📝 Prompt 6.3 - Tela de Projeção

```markdown
Implemente a tela de Projeção completa:

### Arquivo: src/app/(dashboard)/projecao/page.tsx

```typescript
'use client';

import { useState } from 'react';
import { Header } from '@/components/layout/header';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Badge } from '@/components/ui/badge';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { Plus, BarChart3, Table as TableIcon, Eye, Settings } from 'lucide-react';
import { ProjectionChart } from '@/components/charts/projection-chart';
import { ComparisonChart } from '@/components/charts/comparison-chart';
import { ProjectionTable } from '@/components/projection/projection-table';
import { SimulationCard } from '@/components/projection/simulation-card';
import { CreateSimulationDialog } from '@/components/projection/create-simulation-dialog';
import { DetailViewDialog } from '@/components/projection/detail-view-dialog';
import { useSimulations, useProjection } from '@/hooks/use-simulations';
import { useRealized } from '@/hooks/use-realized';
import { formatCurrency, formatPercent } from '@/lib/utils';

// Cliente fixo para o case (em produção viria de contexto/auth)
const CLIENT_ID = 'client-uuid-here';

export default function ProjecaoPage() {
  const [selectedSimulationId, setSelectedSimulationId] = useState<string | null>(null);
  const [compareIds, setCompareIds] = useState<string[]>([]);
  const [viewMode, setViewMode] = useState<'chart' | 'table'>('chart');
  const [showDetailView, setShowDetailView] = useState(false);
  const [showCreateDialog, setShowCreateDialog] = useState(false);

  const { data: simulations = [], isLoading: loadingSimulations } = useSimulations(CLIENT_ID);
  const { data: realized } = useRealized(CLIENT_ID);
  const { data: projection } = useProjection(selectedSimulationId || '', 30);

  // Simulação atual/realizado
  const currentSimulation = simulations.find((s) => s.isCurrent);
  
  // Simulação selecionada
  const selectedSimulation = simulations.find((s) => s.id === selectedSimulationId);

  // Toggle comparação
  const toggleCompare = (id: string) => {
    setCompareIds((prev) =>
      prev.includes(id) ? prev.filter((i) => i !== id) : [...prev, id]
    );
  };

  return (
    <div className="flex flex-col h-full">
      <Header
        title="Projeção Patrimonial"
        subtitle={selectedSimulation?.name || 'Selecione uma simulação'}
      />

      <div className="flex-1 p-6 space-y-6 overflow-auto">
        {/* Cards de resumo */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                Patrimônio Atual
              </CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-2xl font-bold">
                {formatCurrency(realized?.summary?.initialAssets || 0)}
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                Projeção Final
              </CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-2xl font-bold text-primary">
                {formatCurrency(projection?.summary?.finalAssets || 0)}
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                Crescimento Total
              </CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-2xl font-bold text-green-500">
                {formatPercent(projection?.summary?.totalGrowthPercent || 0)}
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                Impacto Seguros
              </CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-2xl font-bold text-orange-500">
                {formatCurrency(projection?.summary?.insuranceImpact || 0)}
              </p>
            </CardContent>
          </Card>
        </div>

        {/* Área principal */}
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
          {/* Painel de simulações */}
          <Card className="lg:col-span-1">
            <CardHeader className="flex flex-row items-center justify-between">
              <CardTitle className="text-lg">Simulações</CardTitle>
              <Button size="sm" onClick={() => setShowCreateDialog(true)}>
                <Plus size={16} className="mr-1" />
                Nova
              </Button>
            </CardHeader>
            <CardContent className="space-y-2">
              {/* Situação Atual */}
              {currentSimulation && (
                <SimulationCard
                  simulation={currentSimulation}
                  isSelected={selectedSimulationId === currentSimulation.id}
                  isComparing={compareIds.includes(currentSimulation.id)}
                  onSelect={() => setSelectedSimulationId(currentSimulation.id)}
                  onCompare={() => toggleCompare(currentSimulation.id)}
                  isCurrent
                />
              )}

              {/* Outras simulações */}
              {simulations
                .filter((s) => !s.isCurrent)
                .map((simulation) => (
                  <SimulationCard
                    key={simulation.id}
                    simulation={simulation}
                    isSelected={selectedSimulationId === simulation.id}
                    isComparing={compareIds.includes(simulation.id)}
                    onSelect={() => setSelectedSimulationId(simulation.id)}
                    onCompare={() => toggleCompare(simulation.id)}
                  />
                ))}
            </CardContent>
          </Card>

          {/* Gráfico/Tabela */}
          <Card className="lg:col-span-3">
            <CardHeader className="flex flex-row items-center justify-between">
              <div className="flex items-center gap-4">
                <CardTitle className="text-lg">
                  {compareIds.length > 0 ? 'Comparação' : 'Projeção'}
                </CardTitle>
                {selectedSimulation && (
                  <Badge variant="outline">{selectedSimulation.name}</Badge>
                )}
              </div>

              <div className="flex items-center gap-2">
                {/* Toggle visualização */}
                <Tabs value={viewMode} onValueChange={(v) => setViewMode(v as any)}>
                  <TabsList>
                    <TabsTrigger value="chart">
                      <BarChart3 size={16} />
                    </TabsTrigger>
                    <TabsTrigger value="table">
                      <TableIcon size={16} />
                    </TabsTrigger>
                  </TabsList>
                </Tabs>

                {/* Ver detalhes */}
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => setShowDetailView(true)}
                  disabled={!selectedSimulationId}
                >
                  <Eye size={16} className="mr-1" />
                  Ver Detalhes
                </Button>
              </div>
            </CardHeader>

            <CardContent>
              {viewMode === 'chart' ? (
                compareIds.length > 0 ? (
                  <ComparisonChart
                    simulations={[]} // TODO: Carregar projeções das simulações comparadas
                    realizedData={realized?.yearly}
                  />
                ) : (
                  <ProjectionChart
                    data={projection?.yearly || []}
                    realizedData={realized?.yearly}
                    showFinancial
                    showProperty
                    showTotal
                    showRealized
                  />
                )
              ) : (
                <ProjectionTable data={projection?.yearly || []} />
              )}
            </CardContent>
          </Card>
        </div>
      </div>

      {/* Dialogs */}
      <CreateSimulationDialog
        open={showCreateDialog}
        onOpenChange={setShowCreateDialog}
        clientId={CLIENT_ID}
        baseSimulation={selectedSimulation}
      />

      <DetailViewDialog
        open={showDetailView}
        onOpenChange={setShowDetailView}
        simulation={selectedSimulation}
        projection={projection}
      />
    </div>
  );
}
```

### Arquivo: src/components/projection/simulation-card.tsx

```typescript
'use client';

import { Simulation } from '@/types';
import { Card } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { MoreVertical, Copy, Edit, Trash, GitBranch } from 'lucide-react';
import { cn } from '@/lib/utils';

interface SimulationCardProps {
  simulation: Simulation;
  isSelected: boolean;
  isComparing: boolean;
  isCurrent?: boolean;
  onSelect: () => void;
  onCompare: () => void;
  onEdit?: () => void;
  onDelete?: () => void;
  onCreateVersion?: () => void;
}

export function SimulationCard({
  simulation,
  isSelected,
  isComparing,
  isCurrent = false,
  onSelect,
  onCompare,
  onEdit,
  onDelete,
  onCreateVersion,
}: SimulationCardProps) {
  return (
    <Card
      className={cn(
        'p-3 cursor-pointer transition-all hover:border-primary/50',
        isSelected && 'border-primary bg-primary/5',
        isComparing && 'ring-2 ring-primary/30'
      )}
      onClick={onSelect}
    >
      <div className="flex items-start justify-between">
        <div className="flex-1">
          <div className="flex items-center gap-2">
            <span className="font-medium truncate">{simulation.name}</span>
            {isCurrent && (
              <Badge variant="secondary" className="text-xs">
                Atual
              </Badge>
            )}
          </div>
          <div className="flex items-center gap-2 mt-1 text-xs text-muted-foreground">
            <span>Juros: {(simulation.interestRate * 100).toFixed(1)}%</span>
            <span>•</span>
            <span>IPCA: {(simulation.inflationRate * 100).toFixed(1)}%</span>
          </div>
          {simulation.latestVersion && (
            <div className="text-xs text-muted-foreground mt-1">
              v{simulation.latestVersion}
            </div>
          )}
        </div>

        <div className="flex items-center gap-1">
          <Button
            variant={isComparing ? 'default' : 'ghost'}
            size="sm"
            className="h-7 w-7 p-0"
            onClick={(e) => {
              e.stopPropagation();
              onCompare();
            }}
          >
            <Copy size={14} />
          </Button>

          <DropdownMenu>
            <DropdownMenuTrigger asChild onClick={(e) => e.stopPropagation()}>
              <Button variant="ghost" size="sm" className="h-7 w-7 p-0">
                <MoreVertical size={14} />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              <DropdownMenuItem onClick={onEdit}>
                <Edit size={14} className="mr-2" />
                Editar
              </DropdownMenuItem>
              <DropdownMenuItem onClick={onCreateVersion}>
                <GitBranch size={14} className="mr-2" />
                Nova Versão
              </DropdownMenuItem>
              {!isCurrent && (
                <DropdownMenuItem
                  className="text-destructive"
                  onClick={onDelete}
                >
                  <Trash size={14} className="mr-2" />
                  Excluir
                </DropdownMenuItem>
              )}
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </div>
    </Card>
  );
}
```

### Crie também:
- `src/components/projection/projection-table.tsx` - Tabela com dados anuais
- `src/components/projection/create-simulation-dialog.tsx` - Modal de criação
- `src/components/projection/detail-view-dialog.tsx` - Modal de detalhes com gráficos empilhados

### Princípios:
- Componentes pequenos e focados
- Estado local para UI, React Query para dados
- Seguir layout do Figma
```

---

## 📝 Prompt 6.4 - Tela de Alocações

```markdown
Implemente a tela de Alocações:

### Arquivo: src/app/(dashboard)/alocacoes/page.tsx

```typescript
'use client';

import { useState } from 'react';
import { format } from 'date-fns';
import { ptBR } from 'date-fns/locale';
import { Header } from '@/components/layout/header';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Calendar } from '@/components/ui/calendar';
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from '@/components/ui/popover';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Plus, Calendar as CalendarIcon, RefreshCw } from 'lucide-react';
import { AllocationList } from '@/components/allocations/allocation-list';
import { CreateAllocationDialog } from '@/components/allocations/create-allocation-dialog';
import { CopyAllocationsDialog } from '@/components/allocations/copy-allocations-dialog';
import { useAllocationDates, useAllocationsByDate } from '@/hooks/use-allocations';
import { formatCurrency, cn } from '@/lib/utils';

const CLIENT_ID = 'client-uuid-here';

export default function AlocacoesPage() {
  const [selectedDate, setSelectedDate] = useState<Date>(new Date());
  const [showCreateDialog, setShowCreateDialog] = useState(false);
  const [showCopyDialog, setShowCopyDialog] = useState(false);
  const [allocationType, setAllocationType] = useState<'financial' | 'property'>('financial');

  const dateStr = format(selectedDate, 'yyyy-MM-dd');
  
  const { data: availableDates = [] } = useAllocationDates(CLIENT_ID);
  const { data: allocations = [], isLoading } = useAllocationsByDate(CLIENT_ID, dateStr);

  // Separar por tipo
  const financialAllocations = allocations.filter((a) => a.type === 'financial');
  const propertyAllocations = allocations.filter((a) => a.type === 'property');

  // Totais
  const totalFinancial = financialAllocations.reduce((sum, a) => sum + a.value, 0);
  const totalProperty = propertyAllocations.reduce((sum, a) => sum + a.value, 0);
  const totalGeneral = totalFinancial + totalProperty;

  // Datas com alocações (para destacar no calendário)
  const datesWithAllocations = availableDates.map((d) => new Date(d));

  return (
    <div className="flex flex-col h-full">
      <Header
        title="Alocações"
        subtitle={format(selectedDate, "dd 'de' MMMM 'de' yyyy", { locale: ptBR })}
      />

      <div className="flex-1 p-6 space-y-6 overflow-auto">
        {/* Seletor de data e ações */}
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-4">
            <Popover>
              <PopoverTrigger asChild>
                <Button variant="outline" className="gap-2">
                  <CalendarIcon size={16} />
                  {format(selectedDate, 'dd/MM/yyyy')}
                </Button>
              </PopoverTrigger>
              <PopoverContent className="w-auto p-0" align="start">
                <Calendar
                  mode="single"
                  selected={selectedDate}
                  onSelect={(date) => date && setSelectedDate(date)}
                  locale={ptBR}
                  modifiers={{
                    hasData: datesWithAllocations,
                  }}
                  modifiersStyles={{
                    hasData: {
                      fontWeight: 'bold',
                      textDecoration: 'underline',
                    },
                  }}
                />
              </PopoverContent>
            </Popover>

            <Button variant="outline" onClick={() => setShowCopyDialog(true)}>
              <RefreshCw size={16} className="mr-2" />
              Atualizar
            </Button>
          </div>

          <Button onClick={() => setShowCreateDialog(true)}>
            <Plus size={16} className="mr-2" />
            Nova Alocação
          </Button>
        </div>

        {/* Cards de resumo */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                Patrimônio Financeiro
              </CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-2xl font-bold text-blue-500">
                {formatCurrency(totalFinancial)}
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                Patrimônio Imobilizado
              </CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-2xl font-bold text-green-500">
                {formatCurrency(totalProperty)}
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                Patrimônio Total
              </CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-2xl font-bold text-purple-500">
                {formatCurrency(totalGeneral)}
              </p>
            </CardContent>
          </Card>
        </div>

        {/* Listas de alocações */}
        <Tabs value={allocationType} onValueChange={(v) => setAllocationType(v as any)}>
          <TabsList>
            <TabsTrigger value="financial">
              Financeiro ({financialAllocations.length})
            </TabsTrigger>
            <TabsTrigger value="property">
              Imobilizado ({propertyAllocations.length})
            </TabsTrigger>
          </TabsList>

          <TabsContent value="financial" className="mt-4">
            <AllocationList
              allocations={financialAllocations}
              isLoading={isLoading}
              emptyMessage="Nenhuma alocação financeira nesta data"
            />
          </TabsContent>

          <TabsContent value="property" className="mt-4">
            <AllocationList
              allocations={propertyAllocations}
              isLoading={isLoading}
              emptyMessage="Nenhuma alocação imobilizada nesta data"
              showFinancingInfo
            />
          </TabsContent>
        </Tabs>
      </div>

      {/* Dialogs */}
      <CreateAllocationDialog
        open={showCreateDialog}
        onOpenChange={setShowCreateDialog}
        clientId={CLIENT_ID}
        defaultDate={selectedDate}
        defaultType={allocationType}
      />

      <CopyAllocationsDialog
        open={showCopyDialog}
        onOpenChange={setShowCopyDialog}
        clientId={CLIENT_ID}
        fromDate={selectedDate}
      />
    </div>
  );
}
```

### Crie também:
- `src/components/allocations/allocation-list.tsx` - Lista com cards de alocações
- `src/components/allocations/allocation-card.tsx` - Card individual
- `src/components/allocations/create-allocation-dialog.tsx` - Modal de criação
- `src/components/allocations/edit-allocation-dialog.tsx` - Modal de edição
- `src/components/allocations/copy-allocations-dialog.tsx` - Modal de atualizar/copiar

### Princípios:
- Calendário destaca datas com alocações
- Separação clara entre financeiro e imobilizado
- Informações de financiamento visíveis quando aplicável
```

---

## 📝 Prompt 6.5 - Tela de Histórico

```markdown
Implemente a tela de Histórico:

### Arquivo: src/app/(dashboard)/historico/page.tsx

```typescript
'use client';

import { useState } from 'react';
import { format } from 'date-fns';
import { ptBR } from 'date-fns/locale';
import { Header } from '@/components/layout/header';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import { Badge } from '@/components/ui/badge';
import { Search, Eye, RotateCcw, BarChart3 } from 'lucide-react';
import { ProjectionChart } from '@/components/charts/projection-chart';
import { useSimulations, useSimulationVersions, useProjection } from '@/hooks/use-simulations';
import { formatCurrency } from '@/lib/utils';
import { SimulationVersion } from '@/types';

const CLIENT_ID = 'client-uuid-here';

export default function HistoricoPage() {
  const [search, setSearch] = useState('');
  const [selectedVersionId, setSelectedVersionId] = useState<string | null>(null);
  const [showChartDialog, setShowChartDialog] = useState(false);

  const { data: simulations = [] } = useSimulations(CLIENT_ID);
  
  // Carregar todas as versões de todas as simulações
  // Em produção, isso seria paginado
  const allVersions: (SimulationVersion & { simulationName: string })[] = [];
  
  simulations.forEach((sim) => {
    const { data: versions = [] } = useSimulationVersions(sim.id);
    versions.forEach((v) => {
      allVersions.push({ ...v, simulationName: sim.name });
    });
  });

  // Filtrar por busca
  const filteredVersions = allVersions.filter((v) =>
    v.simulationName.toLowerCase().includes(search.toLowerCase())
  );

  // Ordenar por data (mais recentes primeiro)
  const sortedVersions = filteredVersions.sort(
    (a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
  );

  const selectedVersion = allVersions.find((v) => v.id === selectedVersionId);

  return (
    <div className="flex flex-col h-full">
      <Header
        title="Histórico de Simulações"
        subtitle={`${allVersions.length} versões registradas`}
      />

      <div className="flex-1 p-6 space-y-6 overflow-auto">
        {/* Busca */}
        <div className="flex items-center gap-4">
          <div className="relative flex-1 max-w-md">
            <Search
              size={18}
              className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground"
            />
            <Input
              placeholder="Buscar simulação..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="pl-10"
            />
          </div>
        </div>

        {/* Tabela de versões */}
        <Card>
          <CardContent className="p-0">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Simulação</TableHead>
                  <TableHead>Versão</TableHead>
                  <TableHead>Data</TableHead>
                  <TableHead>Juros</TableHead>
                  <TableHead>Inflação</TableHead>
                  <TableHead>Patrimônio Final</TableHead>
                  <TableHead className="text-right">Ações</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {sortedVersions.map((version) => (
                  <TableRow key={version.id}>
                    <TableCell className="font-medium">
                      {version.simulationName}
                    </TableCell>
                    <TableCell>
                      <Badge variant="outline">v{version.versionNumber}</Badge>
                    </TableCell>
                    <TableCell className="text-muted-foreground">
                      {format(new Date(version.createdAt), "dd/MM/yyyy 'às' HH:mm", {
                        locale: ptBR,
                      })}
                    </TableCell>
                    <TableCell>
                      {(version.parameters.interestRate * 100).toFixed(1)}%
                    </TableCell>
                    <TableCell>
                      {(version.parameters.inflationRate * 100).toFixed(1)}%
                    </TableCell>
                    <TableCell className="font-medium">
                      {formatCurrency(
                        version.projectionData[version.projectionData.length - 1]
                          ?.totalAssets || 0
                      )}
                    </TableCell>
                    <TableCell className="text-right">
                      <div className="flex items-center justify-end gap-2">
                        <Button
                          variant="ghost"
                          size="sm"
                          onClick={() => {
                            setSelectedVersionId(version.id);
                            setShowChartDialog(true);
                          }}
                        >
                          <BarChart3 size={16} />
                        </Button>
                        <Button
                          variant="ghost"
                          size="sm"
                          onClick={() => {
                            // TODO: Reabrir como simulação ativa
                          }}
                        >
                          <RotateCcw size={16} />
                        </Button>
                      </div>
                    </TableCell>
                  </TableRow>
                ))}

                {sortedVersions.length === 0 && (
                  <TableRow>
                    <TableCell
                      colSpan={7}
                      className="text-center text-muted-foreground py-8"
                    >
                      Nenhuma versão encontrada
                    </TableCell>
                  </TableRow>
                )}
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </div>

      {/* Dialog do gráfico */}
      <Dialog open={showChartDialog} onOpenChange={setShowChartDialog}>
        <DialogContent className="max-w-4xl">
          <DialogHeader>
            <DialogTitle>
              {selectedVersion?.simulationName} - v{selectedVersion?.versionNumber}
            </DialogTitle>
          </DialogHeader>
          <div className="py-4">
            {selectedVersion && (
              <ProjectionChart
                data={selectedVersion.projectionData}
                showFinancial
                showProperty
                showTotal
                height={350}
              />
            )}
          </div>
          <div className="flex justify-between text-sm text-muted-foreground">
            <span>
              Criado em:{' '}
              {selectedVersion &&
                format(new Date(selectedVersion.createdAt), "dd/MM/yyyy 'às' HH:mm")}
            </span>
            <span>
              Juros: {((selectedVersion?.parameters.interestRate || 0) * 100).toFixed(1)}% |
              Inflação: {((selectedVersion?.parameters.inflationRate || 0) * 100).toFixed(1)}%
            </span>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}
```

### Princípios:
- Lista todas as versões de todas as simulações
- Busca por nome de simulação
- Visualização rápida do gráfico
- Opção de reabrir versão antiga
```

---

## ✅ Validação da Fase 6

```bash
# Iniciar frontend
npm run dev

# Verificar todas as telas:
open http://localhost:3000/projecao
open http://localhost:3000/alocacoes
open http://localhost:3000/historico

# Testar:
# - Navegação entre telas
# - Gráficos renderizando
# - Modais abrindo/fechando
# - Dados sendo carregados
```

### Critérios de Sucesso:
- [ ] Tela Projeção funcional
- [ ] Tela Alocações funcional
- [ ] Tela Histórico funcional
- [ ] Gráficos renderizando corretamente
- [ ] Modais de criação funcionando
- [ ] Design seguindo Figma

---

## 📚 Arquivos Criados nesta Fase

```
frontend/src/
├── hooks/
│   ├── use-clients.ts
│   ├── use-simulations.ts
│   ├── use-allocations.ts
│   └── use-realized.ts
├── components/
│   ├── charts/
│   │   ├── projection-chart.tsx
│   │   ├── stacked-area-chart.tsx
│   │   └── comparison-chart.tsx
│   ├── projection/
│   │   ├── simulation-card.tsx
│   │   ├── projection-table.tsx
│   │   ├── create-simulation-dialog.tsx
│   │   └── detail-view-dialog.tsx
│   └── allocations/
│       ├── allocation-list.tsx
│       ├── allocation-card.tsx
│       ├── create-allocation-dialog.tsx
│       ├── edit-allocation-dialog.tsx
│       └── copy-allocations-dialog.tsx
└── app/(dashboard)/
    ├── projecao/page.tsx
    ├── alocacoes/page.tsx
    └── historico/page.tsx
```

---

## 🔄 Próxima Fase

Após validar todos os checkpoints, siga para:
**[Fase 7 - Integração](./07-integracao.md)**
