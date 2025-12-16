# 📱 Plano de Implementação - Frontend Anka MFO

> Guia completo para implementação do frontend com 90%+ de fidelidade ao Figma.

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Estrutura de Arquivos](#estrutura-de-arquivos)
3. [Fases de Implementação](#fases-de-implementação)
4. [Componentes Atômicos](#componentes-atômicos)
5. [Telas](#telas)
6. [Checklist de Fidelidade](#checklist-de-fidelidade)

---

## 🎯 Visão Geral

### Objetivo
Implementar o frontend do Anka MFO com **90%+ de fidelidade visual** ao Figma, garantindo:
- Cores exatas conforme Design System
- Tipografia correta (fontes, tamanhos, pesos)
- Espaçamentos precisos
- Componentes interativos funcionais
- Responsividade adequada

### Stack
- **Framework**: Next.js 16 (Turbopack)
- **Estilização**: Tailwind CSS 3.4.19 + CSS Custom Properties
- **Estado**: React Query (TanStack Query)
- **Gráficos**: Recharts
- **Ícones**: Heroicons + SVG customizados
- **Formulários**: React Hook Form + Zod

### Fontes Necessárias
```html
<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Work+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=Neuton:wght@400&family=ABeeZee&display=swap" rel="stylesheet">

<!-- Satoshi (font local ou CDN alternativo) -->
```

---

## 📁 Estrutura de Arquivos

```
frontend/src/
├── app/                          # Next.js App Router (futuro)
├── components/
│   ├── atoms/                    # Componentes básicos
│   │   ├── Button.tsx
│   │   ├── Badge.tsx
│   │   ├── Radio.tsx
│   │   ├── Checkbox.tsx
│   │   ├── Input.tsx
│   │   ├── Select.tsx
│   │   └── Icon.tsx
│   ├── molecules/                # Combinações de atoms
│   │   ├── ClientSelector.tsx
│   │   ├── SimulationCard.tsx
│   │   ├── MovementCard.tsx
│   │   ├── InsuranceCard.tsx
│   │   ├── TimelineMarker.tsx
│   │   ├── ProgressBar.tsx
│   │   └── YearCard.tsx
│   ├── organisms/                # Seções completas
│   │   ├── Header.tsx
│   │   ├── Sidebar.tsx
│   │   ├── ProjectionChart.tsx
│   │   ├── Timeline.tsx
│   │   ├── MovementsList.tsx
│   │   ├── InsurancesList.tsx
│   │   └── SimulationSelector.tsx
│   ├── templates/                # Layouts de página
│   │   ├── MainLayout.tsx
│   │   └── DashboardLayout.tsx
│   └── screens/                  # Telas completas
│       ├── ProjectionScreen.tsx
│       ├── AllocationsScreen.tsx
│       └── HistoryScreen.tsx
├── hooks/                        # Custom hooks
├── services/                     # API client
├── types/                        # TypeScript types
├── styles/
│   ├── globals.css               # CSS global + custom properties
│   └── fonts.css                 # Font faces
└── utils/
    └── formatters.ts             # Formatação de valores
```

---

## 🚀 Fases de Implementação

### Fase 1: Setup Base (Prompt 1.1)
**Objetivo**: Configurar estilos globais e fontes

**Arquivos**:
- `styles/globals.css` - CSS variables do Design System
- `styles/fonts.css` - @font-face declarations
- `tailwind.config.js` - Extensão do tema

**Entregáveis**:
- [ ] Variáveis CSS configuradas
- [ ] Fontes carregando corretamente
- [ ] Cores do Tailwind mapeadas

---

### Fase 2: Componentes Atômicos (Prompts 2.1-2.6)

#### Prompt 2.1 - Button
```tsx
// Variantes: primary, secondary, ghost, danger
// Tamanhos: sm, md, lg
// Estados: default, hover, active, disabled
```

#### Prompt 2.2 - Badge
```tsx
// Variantes: suggestion (verde), today (azul), percentage (azul claro)
```

#### Prompt 2.3 - Radio/Checkbox
```tsx
// Radio: círculo com borda e preenchimento
// Checkbox: círculo vazado (Morto/Inválido)
```

#### Prompt 2.4 - Input
```tsx
// Com borda, label flutuante
```

#### Prompt 2.5 - Select (ClientSelector)
```tsx
// Dropdown customizado com chevron
```

#### Prompt 2.6 - Icons
```tsx
// SVGs customizados + Heroicons mapping
```

---

### Fase 3: Componentes Moleculares (Prompts 3.1-3.7)

#### Prompt 3.1 - ClientSelector
```tsx
// Seletor de cliente com dropdown
// Border: 2px solid #C9C9C9
// Border-radius: 32px
// Font: Work Sans 35px
```

#### Prompt 3.2 - SimulationCard
```tsx
// Card de simulação (Plano Original, Situação atual, Realizado)
// Radio button integrado
// Menu dots
// Cores de borda por tipo
```

#### Prompt 3.3 - YearCard
```tsx
// Card com ano, idade, valor, percentual
// Barra de progresso com stripes
// Badge "Hoje" opcional
```

#### Prompt 3.4 - MovementCard
```tsx
// Card de movimentação financeira
// Título, datas, frequência, tipo, valor
// Cores: verde (crédito), vermelho (débito)
```

#### Prompt 3.5 - InsuranceCard
```tsx
// Card de seguro
// Tipo, duração, prêmio, valor cobertura
// Cor roxa para valor
```

#### Prompt 3.6 - TimelineMarker
```tsx
// Marcador na timeline
// Ponto colorido + valor
// Tooltip com detalhes
```

#### Prompt 3.7 - ProgressBar (Stripes)
```tsx
// Barra de progresso com stripes gradiente
// Barras ativas vs inativas
```

---

### Fase 4: Componentes Orgânicos (Prompts 4.1-4.7)

#### Prompt 4.1 - Header
```tsx
// Logo, navegação (Alocações, Projeção, Histórico)
// Tab ativa com underline
// Font: ABeeZee 24px
```

#### Prompt 4.2 - Sidebar
```tsx
// Logo Anka
// Menu items (Clientes, Projeção, Histórico, Prospects)
// User info no rodapé
// Item ativo com background #303030
```

#### Prompt 4.3 - ProjectionChart
```tsx
// Gráfico Recharts com múltiplas linhas
// Linha azul dashed (Plano Original) com glow
// Linha verde dashed (Sugestão) com glow
// Linha amarela solid (Realizado) com pontos
// Grid dashed #565656
// Labels Y: R$ 3,5 M, R$ 3 M, etc.
```

#### Prompt 4.4 - SimulationSelector
```tsx
// Grupo de SimulationCards
// "Plano Original", "Situação atual", "Realizado"
// "+ Adicionar Simulação"
```

#### Prompt 4.5 - Timeline
```tsx
// Linha do tempo horizontal
// Duas linhas: Salário (verde), Custo de vida (vermelho)
// Anos e idades
// Marcadores de eventos
// Labels de valores
```

#### Prompt 4.6 - MovementsList
```tsx
// Lista de MovementCards
// Grid 2 colunas
// Filtros: Financeiras, Imobilizadas
// Botão "+ Adicionar"
```

#### Prompt 4.7 - InsurancesList
```tsx
// Lista de InsuranceCards
// Grid 2 colunas
// Botão "+ Adicionar"
```

---

### Fase 5: Telas Completas (Prompts 5.1-5.3)

#### Prompt 5.1 - ProjectionScreen
```tsx
// Tela principal de projeção
// Composição de todos os organismos
// Layout com seções:
//   1. Header info (cliente, patrimônio)
//   2. YearCards horizontais
//   3. Checkboxes Morto/Inválido
//   4. Dropdown Sugestão
//   5. Gráfico de projeção
//   6. Seletor de simulações
//   7. Timeline
//   8. Movimentações
//   9. Seguros
```

#### Prompt 5.2 - AllocationsScreen
```tsx
// Tela de alocações
// Tabela de ativos
// Gráfico de pizza/donut
```

#### Prompt 5.3 - HistoryScreen
```tsx
// Tela de histórico
// Lista de versões de simulação
// Comparativo visual
```

---

### Fase 6: Interatividade (Prompts 6.1-6.4)

#### Prompt 6.1 - Navegação
```tsx
// Routing entre telas
// Estados de tab ativa
```

#### Prompt 6.2 - Modais
```tsx
// Modal de adicionar movimentação
// Modal de adicionar seguro
// Modal de nova simulação
```

#### Prompt 6.3 - Formulários
```tsx
// Forms com React Hook Form
// Validação Zod
// Estados de erro
```

#### Prompt 6.4 - Integração API
```tsx
// Conexão com hooks existentes
// Loading states
// Error handling
```

---

## 🧱 Componentes Atômicos - Especificações

### Button
| Prop | Tipo | Valores |
|------|------|---------|
| variant | string | `primary`, `secondary`, `ghost`, `danger`, `filter-active`, `filter-inactive` |
| size | string | `sm`, `md`, `lg` |
| icon | ReactNode | Opcional |
| fullWidth | boolean | false |

### Badge
| Prop | Tipo | Valores |
|------|------|---------|
| variant | string | `suggestion`, `today`, `percentage` |
| children | ReactNode | Texto |

### Radio
| Prop | Tipo | Valores |
|------|------|---------|
| color | string | `blue`, `green`, `yellow` |
| checked | boolean | Estado |
| size | string | `sm`, `md` |

---

## 📱 Telas - Wireframe Estrutural

### ProjectionScreen Layout
```
┌─────────────────────────────────────────────────────────┐
│ [Logo]           Alocações   Projeção   Histórico       │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────────┐                                    │
│  │ Matheus Silveira│  ┌──────┐  ┌──────┐  ┌──────┐     │
│  └─────────────────┘  │ 2025 │  │ 2035 │  │ 2045 │     │
│  Patrimônio Líquido   │R$2.6M│  │R$3.1M│  │R$2.1M│     │
│  R$ 2.679.930,00      │45anos│  │55anos│  │65anos│     │
│  +52,37%              └──────┘  └──────┘  └──────┘     │
│                                                         │
│  ○ Morto   ○ Inválido            [Sugestão ▼]          │
│                                                         │
│  ┌───────────────────────────────────────────────────┐ │
│  │ Projeção Patrimonial    Ver detalhes  Ver Tabela  │ │
│  │                                                    │ │
│  │  R$ 3,5M ─┐                    ╱╲                 │ │
│  │  R$ 3 M   │              ╱‾‾‾‾╱  ╲‾‾‾‾          │ │
│  │  R$ 2,5M  │         ╱‾‾‾╱                        │ │
│  │  R$ 2 M   │    ╱‾‾‾╱                             │ │
│  │  R$ 1,5M  │╱‾‾╱                                  │ │
│  │  R$ 1 M   ●                                       │ │
│  │  R$ 500K  │                                       │ │
│  │  R$ 0     └───────────────────────────────────── │ │
│  └───────────────────────────────────────────────────┘ │
│                                                         │
│  ◉ Plano Original  ○ Situação atual  ○ Realizado       │
│                    05/2025                + Adicionar   │
│                                                         │
│  Timeline ─────────────────────────────────────────── │
│  Salário ●━━━━●━━━━━━━━●━━━━━━━━●━━━━━━━━━━━━━━━━━━ │
│         2025 2030    2035     2040     2050     2060  │
│         45   50      55       60       70       80    │
│  Custo  ●━━━━━━●━━━━━━━━●━━━━━━━●━━━━━━●━━━━━━━━━━━ │
│         R$8k  R$12k   R$20k   R$10k   R$15k          │
│                                                         │
│  Movimentações                    [Financeiras] [Imob] │
│  ┌─────────────────┐ ┌─────────────────┐    + Adicionar│
│  │ Herança         │ │ Custo do filho  │               │
│  │ 09/07/23-22/07  │ │ 09/07/23-22/07  │               │
│  │ Única/Crédito   │ │ Mensal/Depend.  │               │
│  │ ↑ R$ 220.000    │ │ ↓ R$ 1.500      │               │
│  └─────────────────┘ └─────────────────┘               │
│                                                         │
│  Seguros                                    + Adicionar │
│  ┌─────────────────┐ ┌─────────────────┐               │
│  │ Seguro de Vida  │ │ Seg. Invalidez  │               │
│  │ Familiar        │ │                 │               │
│  │ 15 anos         │ │ 5 anos          │               │
│  │ R$120/mês       │ │ R$300/mês       │               │
│  │ R$ 500.000      │ │ R$ 100.000      │               │
│  └─────────────────┘ └─────────────────┘               │
└─────────────────────────────────────────────────────────┘
```

---

## ✅ Checklist de Fidelidade

### Cores (verificar com color picker)
- [ ] Background principal #101010
- [ ] Cards #1B1B1B
- [ ] Texto primário #FFFFFF
- [ ] Azul primário #67AEFA
- [ ] Verde sugestão #48F7A1
- [ ] Amarelo realizado #F7B748
- [ ] Gradiente #6777FA → #03B6AD

### Tipografia
- [ ] Work Sans carregando
- [ ] Inter carregando
- [ ] Neuton carregando
- [ ] ABeeZee carregando
- [ ] Tamanhos corretos
- [ ] Pesos corretos

### Componentes
- [ ] Border-radius exatos
- [ ] Espaçamentos corretos
- [ ] Sombras/glows funcionando
- [ ] Gradientes corretos
- [ ] Estados de hover
- [ ] Estados ativos

### Gráfico
- [ ] Linhas dashed/solid corretas
- [ ] Cores das linhas
- [ ] Glow effects
- [ ] Grid lines dashed
- [ ] Labels eixo Y
- [ ] Pontos do realizado

### Timeline
- [ ] Duas linhas (salário/custo)
- [ ] Marcadores coloridos
- [ ] Valores posicionados
- [ ] Anos/idades alinhados

---

## 🔄 Processo de Implementação por Prompt

Para cada prompt, siga:

1. **Ler especificação** no Design System
2. **Criar componente** com props tipadas
3. **Aplicar estilos** exatos do Figma
4. **Testar estados** (hover, active, disabled)
5. **Verificar responsividade**
6. **Comparar com Figma** (screenshot lado a lado)
7. **Ajustar até 90%+ fidelidade**

---

## 📝 Template de Prompt

```
Implemente o componente [NOME] seguindo:

1. Especificações do Design System: docs/frontend/DESIGN_SYSTEM.md
2. Estrutura: docs/frontend/IMPLEMENTATION_PLAN.md

Requisitos:
- Fidelidade visual: 90%+
- TypeScript tipado
- Props documentadas
- Estados: default, hover, active, disabled
- Responsivo (mobile-first)

Arquivos para criar/editar:
- frontend/src/components/[caminho]/[Nome].tsx
```
