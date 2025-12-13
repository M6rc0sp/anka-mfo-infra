# 🎨 Fase 5 - Frontend Setup

## 📋 Objetivo
Configurar o projeto frontend com Next.js, shadcn/ui, React Query e toda a estrutura base seguindo o design dark-mode do Figma.

---

## 🎯 Entregáveis desta Fase

- [ ] Next.js 14 configurado com App Router
- [ ] shadcn/ui instalado e configurado
- [ ] Tema dark-mode baseado no Figma
- [ ] React Query configurado
- [ ] Estrutura de pastas definida
- [ ] Layout base criado
- [ ] Componentes de navegação

---

## 📝 Prompt 5.1 - Setup Next.js

```markdown
Configure o projeto Next.js com as seguintes especificações:

### Comando inicial:
```bash
npx create-next-app@latest frontend --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"
```

### Dependências adicionais:
```bash
npm install @tanstack/react-query @tanstack/react-query-devtools
npm install react-hook-form @hookform/resolvers zod
npm install recharts date-fns
npm install axios
npm install lucide-react
npm install clsx tailwind-merge class-variance-authority
```

### Estrutura de pastas:
```
frontend/src/
├── app/
│   ├── layout.tsx           # Layout raiz
│   ├── page.tsx             # Redirect para /projecao
│   ├── globals.css          # Estilos globais + tema
│   ├── (dashboard)/         # Grupo de rotas do dashboard
│   │   ├── layout.tsx       # Layout com sidebar
│   │   ├── projecao/
│   │   │   └── page.tsx
│   │   ├── alocacoes/
│   │   │   └── page.tsx
│   │   └── historico/
│   │       └── page.tsx
│   └── providers.tsx        # React Query Provider
├── components/
│   ├── ui/                  # shadcn/ui components
│   ├── layout/              # Header, Sidebar, etc
│   ├── charts/              # Gráficos reutilizáveis
│   └── forms/               # Formulários reutilizáveis
├── hooks/
│   ├── use-clients.ts
│   ├── use-simulations.ts
│   ├── use-allocations.ts
│   └── use-projections.ts
├── services/
│   └── api.ts               # Cliente HTTP
├── types/
│   └── index.ts             # Tipos compartilhados
└── lib/
    ├── utils.ts             # Utilitários
    └── query-client.ts      # Configuração React Query
```

### Arquivo: src/lib/utils.ts
```typescript
import { type ClassValue, clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export function formatCurrency(value: number): string {
  return new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency: 'BRL',
  }).format(value);
}

export function formatPercent(value: number): string {
  return new Intl.NumberFormat('pt-BR', {
    style: 'percent',
    minimumFractionDigits: 2,
  }).format(value);
}

export function formatDate(date: Date | string): string {
  return new Intl.DateTimeFormat('pt-BR').format(new Date(date));
}
```

### Princípios:
- KISS: Estrutura simples e direta
- DRY: Utilitários centralizados
```

---

## 📝 Prompt 5.2 - Configuração shadcn/ui

```markdown
Configure o shadcn/ui com tema dark personalizado:

### Inicialização:
```bash
npx shadcn-ui@latest init
```

### Opções:
- Style: Default
- Base color: Slate
- CSS variables: Yes

### Componentes necessários:
```bash
npx shadcn-ui@latest add button
npx shadcn-ui@latest add card
npx shadcn-ui@latest add input
npx shadcn-ui@latest add label
npx shadcn-ui@latest add select
npx shadcn-ui@latest add dialog
npx shadcn-ui@latest add dropdown-menu
npx shadcn-ui@latest add table
npx shadcn-ui@latest add tabs
npx shadcn-ui@latest add toast
npx shadcn-ui@latest add form
npx shadcn-ui@latest add calendar
npx shadcn-ui@latest add popover
npx shadcn-ui@latest add checkbox
npx shadcn-ui@latest add badge
npx shadcn-ui@latest add separator
npx shadcn-ui@latest add scroll-area
npx shadcn-ui@latest add skeleton
```

### Arquivo: src/app/globals.css (tema dark baseado no Figma)

```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --background: 222 47% 11%;
    --foreground: 213 31% 91%;

    --card: 222 47% 13%;
    --card-foreground: 213 31% 91%;

    --popover: 222 47% 13%;
    --popover-foreground: 213 31% 91%;

    --primary: 210 100% 52%;
    --primary-foreground: 222 47% 11%;

    --secondary: 222 47% 18%;
    --secondary-foreground: 213 31% 91%;

    --muted: 223 47% 20%;
    --muted-foreground: 215 20% 65%;

    --accent: 222 47% 20%;
    --accent-foreground: 213 31% 91%;

    --destructive: 0 62% 50%;
    --destructive-foreground: 213 31% 91%;

    --border: 222 47% 20%;
    --input: 222 47% 20%;
    --ring: 210 100% 52%;

    --radius: 0.5rem;

    /* Cores específicas do projeto */
    --chart-financial: 210 100% 52%;
    --chart-property: 160 84% 39%;
    --chart-total: 280 87% 66%;
    --chart-realized: 45 93% 47%;
    --chart-no-insurance: 0 0% 60%;
  }
}

@layer base {
  * {
    @apply border-border;
  }
  body {
    @apply bg-background text-foreground;
    font-feature-settings: "rlig" 1, "calt" 1;
  }
}

/* Scrollbar customizada */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  @apply bg-muted/20;
}

::-webkit-scrollbar-thumb {
  @apply bg-muted rounded-full;
}

::-webkit-scrollbar-thumb:hover {
  @apply bg-muted-foreground/50;
}
```

### Arquivo: tailwind.config.ts (extensões)

```typescript
import type { Config } from 'tailwindcss';

const config: Config = {
  darkMode: ['class'],
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        border: 'hsl(var(--border))',
        input: 'hsl(var(--input))',
        ring: 'hsl(var(--ring))',
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
        primary: {
          DEFAULT: 'hsl(var(--primary))',
          foreground: 'hsl(var(--primary-foreground))',
        },
        secondary: {
          DEFAULT: 'hsl(var(--secondary))',
          foreground: 'hsl(var(--secondary-foreground))',
        },
        destructive: {
          DEFAULT: 'hsl(var(--destructive))',
          foreground: 'hsl(var(--destructive-foreground))',
        },
        muted: {
          DEFAULT: 'hsl(var(--muted))',
          foreground: 'hsl(var(--muted-foreground))',
        },
        accent: {
          DEFAULT: 'hsl(var(--accent))',
          foreground: 'hsl(var(--accent-foreground))',
        },
        popover: {
          DEFAULT: 'hsl(var(--popover))',
          foreground: 'hsl(var(--popover-foreground))',
        },
        card: {
          DEFAULT: 'hsl(var(--card))',
          foreground: 'hsl(var(--card-foreground))',
        },
        chart: {
          financial: 'hsl(var(--chart-financial))',
          property: 'hsl(var(--chart-property))',
          total: 'hsl(var(--chart-total))',
          realized: 'hsl(var(--chart-realized))',
          'no-insurance': 'hsl(var(--chart-no-insurance))',
        },
      },
      borderRadius: {
        lg: 'var(--radius)',
        md: 'calc(var(--radius) - 2px)',
        sm: 'calc(var(--radius) - 4px)',
      },
    },
  },
  plugins: [require('tailwindcss-animate')],
};

export default config;
```

### Princípios:
- Seguir fielmente o Figma
- CSS variables para flexibilidade
- Cores semânticas para gráficos
```

---

## 📝 Prompt 5.3 - React Query Setup

```markdown
Configure o React Query e o cliente HTTP:

### Arquivo: src/lib/query-client.ts

```typescript
import { QueryClient } from '@tanstack/react-query';

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 5, // 5 minutos
      gcTime: 1000 * 60 * 10, // 10 minutos (antigo cacheTime)
      retry: 1,
      refetchOnWindowFocus: false,
    },
    mutations: {
      retry: 0,
    },
  },
});
```

### Arquivo: src/services/api.ts

```typescript
import axios from 'axios';

export const api = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3333',
  headers: {
    'Content-Type': 'application/json',
  },
});

// Interceptor para tratamento de erros
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response) {
      // Erro do servidor
      const message = error.response.data?.message || 'Erro ao processar requisição';
      console.error('API Error:', message);
    } else if (error.request) {
      // Erro de rede
      console.error('Network Error:', error.message);
    }
    return Promise.reject(error);
  }
);
```

### Arquivo: src/app/providers.tsx

```typescript
'use client';

import { QueryClientProvider } from '@tanstack/react-query';
import { ReactQueryDevtools } from '@tanstack/react-query-devtools';
import { queryClient } from '@/lib/query-client';
import { Toaster } from '@/components/ui/toaster';

interface ProvidersProps {
  children: React.ReactNode;
}

export function Providers({ children }: ProvidersProps) {
  return (
    <QueryClientProvider client={queryClient}>
      {children}
      <Toaster />
      <ReactQueryDevtools initialIsOpen={false} />
    </QueryClientProvider>
  );
}
```

### Arquivo: src/app/layout.tsx

```typescript
import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';
import { Providers } from './providers';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'MFO - Multi Family Office',
  description: 'Plataforma de gestão patrimonial',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="pt-BR" className="dark">
      <body className={inter.className}>
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
```

### Princípios:
- KISS: Configuração mínima e eficaz
- Centralizar tratamento de erros
- DevTools apenas em desenvolvimento
```

---

## 📝 Prompt 5.4 - Layout Base e Navegação

```markdown
Crie o layout base com sidebar seguindo o Figma:

### Arquivo: src/components/layout/sidebar.tsx

```typescript
'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { cn } from '@/lib/utils';
import {
  BarChart3,
  PieChart,
  History,
  Settings,
  Users,
  ChevronLeft,
  ChevronRight,
} from 'lucide-react';
import { useState } from 'react';
import { Button } from '@/components/ui/button';

const menuItems = [
  {
    title: 'Projeção',
    href: '/projecao',
    icon: BarChart3,
  },
  {
    title: 'Alocações',
    href: '/alocacoes',
    icon: PieChart,
  },
  {
    title: 'Histórico',
    href: '/historico',
    icon: History,
  },
];

const bottomMenuItems = [
  {
    title: 'Clientes',
    href: '/clientes',
    icon: Users,
  },
  {
    title: 'Configurações',
    href: '/configuracoes',
    icon: Settings,
  },
];

export function Sidebar() {
  const pathname = usePathname();
  const [collapsed, setCollapsed] = useState(false);

  return (
    <aside
      className={cn(
        'flex flex-col h-screen bg-card border-r border-border transition-all duration-300',
        collapsed ? 'w-16' : 'w-64'
      )}
    >
      {/* Logo */}
      <div className="flex items-center h-16 px-4 border-b border-border">
        {!collapsed && (
          <span className="text-xl font-bold text-primary">MFO</span>
        )}
        <Button
          variant="ghost"
          size="icon"
          className={cn('ml-auto', collapsed && 'mx-auto')}
          onClick={() => setCollapsed(!collapsed)}
        >
          {collapsed ? <ChevronRight size={18} /> : <ChevronLeft size={18} />}
        </Button>
      </div>

      {/* Menu Principal */}
      <nav className="flex-1 py-4">
        <ul className="space-y-1 px-2">
          {menuItems.map((item) => (
            <li key={item.href}>
              <Link
                href={item.href}
                className={cn(
                  'flex items-center gap-3 px-3 py-2 rounded-md transition-colors',
                  'hover:bg-accent hover:text-accent-foreground',
                  pathname === item.href
                    ? 'bg-primary text-primary-foreground'
                    : 'text-muted-foreground'
                )}
              >
                <item.icon size={20} />
                {!collapsed && <span>{item.title}</span>}
              </Link>
            </li>
          ))}
        </ul>
      </nav>

      {/* Menu Inferior */}
      <div className="py-4 border-t border-border">
        <ul className="space-y-1 px-2">
          {bottomMenuItems.map((item) => (
            <li key={item.href}>
              <Link
                href={item.href}
                className={cn(
                  'flex items-center gap-3 px-3 py-2 rounded-md transition-colors',
                  'hover:bg-accent hover:text-accent-foreground',
                  pathname === item.href
                    ? 'bg-accent text-accent-foreground'
                    : 'text-muted-foreground'
                )}
              >
                <item.icon size={20} />
                {!collapsed && <span>{item.title}</span>}
              </Link>
            </li>
          ))}
        </ul>
      </div>
    </aside>
  );
}
```

### Arquivo: src/components/layout/header.tsx

```typescript
'use client';

import { Button } from '@/components/ui/button';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { User, Bell } from 'lucide-react';

interface HeaderProps {
  title: string;
  subtitle?: string;
}

export function Header({ title, subtitle }: HeaderProps) {
  return (
    <header className="flex items-center justify-between h-16 px-6 border-b border-border bg-card">
      <div>
        <h1 className="text-xl font-semibold">{title}</h1>
        {subtitle && (
          <p className="text-sm text-muted-foreground">{subtitle}</p>
        )}
      </div>

      <div className="flex items-center gap-2">
        {/* Notificações */}
        <Button variant="ghost" size="icon">
          <Bell size={20} />
        </Button>

        {/* Menu do usuário */}
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" size="icon">
              <User size={20} />
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            <DropdownMenuLabel>Minha Conta</DropdownMenuLabel>
            <DropdownMenuSeparator />
            <DropdownMenuItem>Perfil</DropdownMenuItem>
            <DropdownMenuItem>Configurações</DropdownMenuItem>
            <DropdownMenuSeparator />
            <DropdownMenuItem className="text-destructive">
              Sair
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
    </header>
  );
}
```

### Arquivo: src/app/(dashboard)/layout.tsx

```typescript
import { Sidebar } from '@/components/layout/sidebar';

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex h-screen overflow-hidden">
      <Sidebar />
      <main className="flex-1 overflow-auto">
        {children}
      </main>
    </div>
  );
}
```

### Arquivo: src/app/page.tsx

```typescript
import { redirect } from 'next/navigation';

export default function Home() {
  redirect('/projecao');
}
```

### Princípios:
- Sidebar responsiva (colapsável)
- Rotas claramente definidas
- Layout reutilizável
```

---

## 📝 Prompt 5.5 - Tipos TypeScript

```markdown
Defina os tipos TypeScript compartilhados:

### Arquivo: src/types/index.ts

```typescript
// ============ ENUMS ============
export type LifeStatus = 'normal' | 'dead' | 'invalid';
export type AllocationType = 'financial' | 'property';
export type TransactionType = 'income' | 'expense' | 'deposit' | 'withdrawal';
export type InsuranceType = 'life' | 'disability';
export type RecurrenceInterval = 'monthly' | 'yearly' | 'one_time';
export type AmortizationType = 'sac' | 'price';

// ============ ENTITIES ============
export interface Client {
  id: string;
  name: string;
  email: string;
  createdAt: string;
  updatedAt: string;
}

export interface Simulation {
  id: string;
  clientId: string;
  name: string;
  startDate: string;
  interestRate: number;
  inflationRate: number;
  lifeStatus: LifeStatus;
  lifeStatusChangeDate?: string;
  isCurrent: boolean;
  createdAt: string;
  updatedAt: string;
  latestVersion?: number;
}

export interface SimulationVersion {
  id: string;
  simulationId: string;
  versionNumber: number;
  parameters: SimulationParameters;
  projectionData: YearlyProjection[];
  createdAt: string;
}

export interface SimulationParameters {
  startDate: string;
  interestRate: number;
  inflationRate: number;
  lifeStatus: LifeStatus;
}

export interface FinancingData {
  downPayment: number;
  installments: number;
  interestRate: number;
  amortizationType: AmortizationType;
  paidInstallments: number;
}

export interface Allocation {
  id: string;
  clientId: string;
  referenceDate: string;
  type: AllocationType;
  name: string;
  value: number;
  isFinanced: boolean;
  financingData?: FinancingData | null;
  createdAt: string;
  updatedAt: string;
}

export interface Transaction {
  id: string;
  clientId: string;
  type: TransactionType;
  category: string | null;
  name: string;
  value: number;
  isRecurring: boolean;
  recurrenceStart: string | null;
  recurrenceEnd: string | null;
  recurrenceInterval: RecurrenceInterval | null;
  createdAt: string;
  updatedAt: string;
}

export interface Insurance {
  id: string;
  clientId: string;
  type: InsuranceType;
  name: string;
  startDate: string;
  durationMonths: number;
  monthlyPremium: number;
  coverageValue: number;
  createdAt: string;
  updatedAt: string;
}

// ============ PROJECTIONS ============
export interface MonthlyProjection {
  date: string;
  financialAssets: number;
  propertyAssets: number;
  totalAssets: number;
  totalWithoutInsurance: number;
  entries: number;
  exits: number;
  insurancePremiums: number;
  insurancePayouts: number;
}

export interface YearlyProjection {
  year: number;
  financialAssets: number;
  propertyAssets: number;
  totalAssets: number;
  totalWithoutInsurance: number;
}

export interface ProjectionSummary {
  initialAssets: number;
  finalAssets: number;
  totalGrowth: number;
  totalGrowthPercent: number;
  totalEntries?: number;
  totalExits?: number;
  insuranceImpact?: number;
}

export interface ProjectionResult {
  yearly: YearlyProjection[];
  summary: ProjectionSummary;
}

// ============ API PAYLOADS ============
export interface CreateClientPayload {
  name: string;
  email: string;
}

export interface CreateSimulationPayload {
  name: string;
  startDate: string;
  interestRate: number;
  inflationRate: number;
  lifeStatus?: LifeStatus;
  lifeStatusChangeDate?: string;
  isCurrent?: boolean;
}

export interface CreateAllocationPayload {
  referenceDate: string;
  type: AllocationType;
  name: string;
  value: number;
  isFinanced?: boolean;
  financingData?: FinancingData;
}

export interface CreateTransactionPayload {
  type: TransactionType;
  category?: string;
  name: string;
  value: number;
  isRecurring?: boolean;
  recurrenceStart?: string;
  recurrenceEnd?: string;
  recurrenceInterval?: RecurrenceInterval;
}

export interface CreateInsurancePayload {
  type: InsuranceType;
  name: string;
  startDate: string;
  durationMonths: number;
  monthlyPremium: number;
  coverageValue: number;
}

export interface CopyAllocationsPayload {
  fromDate: string;
  toDate: string;
}

export interface CompareSimulationsPayload {
  simulationIds: string[];
}
```

### Princípios:
- Tipos espelhando a API
- Reutilizáveis em toda aplicação
- Separação clara entre entidades e payloads
```

---

## ✅ Validação da Fase 5

```bash
# Iniciar frontend
cd frontend && npm run dev

# Verificar no navegador
open http://localhost:3000

# Verificar:
# - Tema dark aplicado
# - Sidebar funcionando
# - Navegação entre rotas
# - Console sem erros
```

### Critérios de Sucesso:
- [ ] Next.js rodando sem erros
- [ ] Tema dark-mode aplicado
- [ ] Sidebar colapsável funcionando
- [ ] Rotas navegáveis
- [ ] React Query DevTools visível

---

## 📚 Arquivos Criados nesta Fase

```
frontend/src/
├── app/
│   ├── layout.tsx
│   ├── page.tsx
│   ├── globals.css
│   ├── providers.tsx
│   └── (dashboard)/
│       ├── layout.tsx
│       ├── projecao/page.tsx
│       ├── alocacoes/page.tsx
│       └── historico/page.tsx
├── components/
│   ├── ui/               # shadcn/ui (auto-gerado)
│   └── layout/
│       ├── sidebar.tsx
│       └── header.tsx
├── lib/
│   ├── utils.ts
│   └── query-client.ts
├── services/
│   └── api.ts
└── types/
    └── index.ts
```

---

## 🔄 Próxima Fase

Após validar todos os checkpoints, siga para:
**[Fase 6 - Frontend Telas](./06-frontend-telas.md)**
