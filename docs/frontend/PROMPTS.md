# 📋 Prompts de Implementação - Frontend Anka MFO

> Prompts prontos para uso sequencial na implementação do frontend.

---

## Fase 1: Setup Base

### Prompt 1.1 - Configuração de Estilos Globais

```
Configure os estilos globais do frontend Anka MFO.

Referências:
- docs/frontend/DESIGN_SYSTEM.md (cores, tipografia, espaçamentos)

Tarefas:
1. Atualizar frontend/src/styles/globals.css com CSS variables
2. Criar frontend/src/styles/fonts.css com @font-face
3. Atualizar frontend/tailwind.config.js estendendo tema
4. Atualizar frontend/src/pages/_document.tsx para incluir Google Fonts

CSS Variables necessárias:
- Todas as cores do Design System
- Font families
- Border radius padrões
- Espaçamentos

Fontes:
- Work Sans (400, 500, 600, 700)
- Inter (400, 500, 600, 700)
- Neuton (400)
- ABeeZee (400)

Tailwind extend:
- colors: mapear todas as cores como 'brand-*', 'surface-*', 'text-*'
- fontFamily: work-sans, inter, neuton, abeezee
- borderRadius: btn, card, card-lg, input
- boxShadow: glow-blue, glow-green, glow-yellow

Build deve passar sem erros.
```

---

## Fase 2: Componentes Atômicos

### Prompt 2.1 - Button

```
Implemente o componente Button em frontend/src/components/atoms/Button.tsx

Referências:
- docs/frontend/DESIGN_SYSTEM.md (seção Botões)

Variantes:
1. primary: bg #EBEBEB, text #444444, rounded-full
2. secondary: border 2px #1F1F1F, text #FFFFFF, bg transparent
3. ghost: sem borda, text #707070
4. filter-active: bg #EBEBEB, text #444444
5. filter-inactive: bg #1F1F1F, text #707070

Tamanhos:
- sm: h-10 px-4 text-base
- md: h-[54px] px-6 text-lg
- lg: h-16 px-8 text-xl

Props:
- variant: 'primary' | 'secondary' | 'ghost' | 'filter-active' | 'filter-inactive'
- size: 'sm' | 'md' | 'lg'
- icon?: ReactNode
- iconPosition?: 'left' | 'right'
- fullWidth?: boolean
- disabled?: boolean
- onClick?: () => void
- children: ReactNode

Font: Work Sans, weight 500
Estados hover: opacity-80 ou scale sutil
Transições suaves

Tipagem TypeScript completa.
Exportar como default e named.
```

### Prompt 2.2 - Badge

```
Implemente o componente Badge em frontend/src/components/atoms/Badge.tsx

Referências:
- docs/frontend/DESIGN_SYSTEM.md (seção Badge)

Variantes:
1. suggestion:
   - bg: rgba(72, 247, 161, 0.24)
   - text: #48F7A1
   - border-radius: 4px
   - padding: 10px
   - font: Work Sans 14px 500

2. today:
   - bg: rgba(83, 132, 235, 0.24)
   - text: #5880EF
   - border-radius: 4px
   - padding: 10px
   - font: Work Sans 17px 500

3. percentage:
   - bg: transparent
   - text: #68AAF1
   - font: Work Sans 19px 500

Props:
- variant: 'suggestion' | 'today' | 'percentage'
- children: ReactNode

Tipagem TypeScript completa.
```

### Prompt 2.3 - Radio e Checkbox

```
Implemente os componentes Radio e Checkbox:
- frontend/src/components/atoms/Radio.tsx
- frontend/src/components/atoms/Checkbox.tsx

Referências:
- docs/frontend/DESIGN_SYSTEM.md (seção Radio/Checkbox)

Radio (para simulações):
- Container: 32x32px, border 2px, rounded-full
- Inner circle: 24x24px quando checked
- Cores por estado:
  - blue: border #67AEFA, inner #67AEFA
  - green: border #48F7A1, inner #48F7A1
  - yellow: border #F7B748, inner #F7B748
  - default: border #2F2F2F, inner #2F2F2F

Props Radio:
- color: 'blue' | 'green' | 'yellow' | 'default'
- checked: boolean
- onChange: () => void
- name?: string
- value?: string

Checkbox (Morto/Inválido):
- Container: 32x32px, border 2px #8E8E8E, rounded-full
- Sem preenchimento interno (só borda)
- Quando checked: adicionar checkmark ou fill

Props Checkbox:
- checked: boolean
- onChange: () => void
- label?: string
- labelClassName?: string

Label do checkbox:
- Font: Neuton 31px 400
- Color: #8E8E8E

Transições suaves.
Acessibilidade: aria-checked, role.
```

### Prompt 2.4 - Input

```
Implemente o componente Input em frontend/src/components/atoms/Input.tsx

Referências:
- docs/frontend/DESIGN_SYSTEM.md

Estilo base:
- Background: transparent
- Border: 2px solid #444444
- Border-radius: 12px
- Padding: 12px 16px
- Font: Inter 16px
- Color: #FFFFFF
- Placeholder: #707070

Estados:
- Focus: border #67AEFA
- Error: border #C65353
- Disabled: opacity-50

Props:
- label?: string
- error?: string
- helperText?: string
- leftIcon?: ReactNode
- rightIcon?: ReactNode
- type: 'text' | 'number' | 'email' | 'password' | 'date'
- ...rest InputHTMLAttributes

Label:
- Font: Inter 14px 500
- Color: #919191
- Margin-bottom: 8px

Error message:
- Font: Inter 12px
- Color: #C65353
- Margin-top: 4px

Integração com React Hook Form (forwardRef).
```

### Prompt 2.5 - Select

```
Implemente o componente Select em frontend/src/components/atoms/Select.tsx

Referências:
- docs/frontend/DESIGN_SYSTEM.md (ClientSelector como base)

Estilo base:
- Background: #101010
- Border: 2px solid #C9C9C9
- Border-radius: 32px
- Padding: 12px 24px
- Min-height: 66px
- Font: Work Sans 35px 500 (para ClientSelector)
- Color: #FFFFFF

Chevron:
- Border: 4px solid #C9C9C9
- Tamanho: 16px
- Posição: right 24px

Dropdown:
- Background: #1B1B1B
- Border: 1px solid #444444
- Border-radius: 16px
- Shadow: standard dropdown shadow
- Max-height: 300px
- Overflow-y: auto

Item do dropdown:
- Padding: 12px 24px
- Hover: background #303030
- Font: Work Sans

Props:
- options: { value: string; label: string }[]
- value: string
- onChange: (value: string) => void
- placeholder?: string
- size?: 'sm' | 'md' | 'lg'
- label?: string
- error?: string

Animação de abertura/fechamento.
Click outside para fechar.
Keyboard navigation (arrow keys, enter, escape).
```

### Prompt 2.6 - Icon

```
Implemente o componente Icon em frontend/src/components/atoms/Icon.tsx

Crie também: frontend/src/components/atoms/icons/ com SVGs

Ícones necessários (baseado no Figma):
1. ChevronDown - para selects
2. ChevronRight - para navigation
3. Plus - para botões adicionar
4. Person - para clientes
5. PersonAdd - para prospects
6. Chart - para projeção
7. History - para histórico
8. Dashboard - para dashboard
9. ArrowUp - para crédito
10. ArrowDown - para débito
11. MoreVertical - três pontos verticais (menu)
12. Close - X para modais
13. Check - checkmark
14. Settings - configurações

Props:
- name: string (nome do ícone)
- size?: 'xs' | 'sm' | 'md' | 'lg' | number
- color?: string
- className?: string

Tamanhos:
- xs: 16px
- sm: 20px
- md: 24px
- lg: 32px

Os SVGs devem usar currentColor para herdar cor.
Exportar também ícones individuais para tree-shaking.
```

---

## Fase 3: Componentes Moleculares

### Prompt 3.1 - ClientSelector

```
Implemente ClientSelector em frontend/src/components/molecules/ClientSelector.tsx

Referências:
- docs/frontend/DESIGN_SYSTEM.md (seção Seletor de Cliente)
- Componente Select como base

Especificações exatas:
- Width: 445px (ou 100% em mobile)
- Height: 66px
- Background: #101010
- Border: 2px solid #C9C9C9
- Border-radius: 32px
- Font: Work Sans 35px 500
- Color: #FFFFFF

Chevron:
- Border: 4px solid #C9C9C9
- Position: absolute right

Props:
- clients: Client[] (do types/index.ts)
- selectedId: string | null
- onSelect: (clientId: string) => void
- loading?: boolean

Features:
- Dropdown com lista de clientes
- Nome completo visível
- Busca/filtro opcional
- Loading state
- Empty state

Dropdown items:
- Avatar com iniciais
- Nome completo
- Email

Hook: usar useClients() para dados.
```

### Prompt 3.2 - SimulationCard

```
Implemente SimulationCard em frontend/src/components/molecules/SimulationCard.tsx

Referências:
- docs/frontend/DESIGN_SYSTEM.md (seção Card de Simulação)

Variantes por tipo:
1. original (Plano Original):
   - Border: 2px solid #67AEFA
   - Radio: blue

2. current (Situação atual):
   - Border: 2px solid #48F7A1
   - Radio: green

3. realized (Realizado):
   - Border: 2px solid #F7B748
   - Radio: yellow

Estrutura:
- Width: 288px (original), 312px (current), 115px (realized)
- Height: 64px
- Background: #1B1B1B
- Border-radius: 16px
- Padding: 16px

Layout interno:
- Radio button (32x32)
- Label (Work Sans 19px 500 #C9C9C9)
- Menu dots (3 círculos verticais, 4x4, #D9D9D9)

Props:
- type: 'original' | 'current' | 'realized'
- label: string
- selected: boolean
- onSelect: () => void
- onMenuClick?: () => void
- showMenu?: boolean

Estados:
- Default: borda da cor do tipo
- Selected: radio preenchido
- Hover: sutil highlight
```

### Prompt 3.3 - YearCard

```
Implemente YearCard em frontend/src/components/molecules/YearCard.tsx

Referências:
- docs/frontend/DESIGN_SYSTEM.md (seção Cards de Timeline)

Estrutura:
1. Container com progresso
2. Valor em reais
3. Ano + badge "Hoje" (se atual)
4. Idade + percentual

Barra de progresso (stripes):
- Container: height 70px, border-radius 6px
- Background base: rgba(103, 119, 250, 0.28)
- Barra sólida: linear-gradient(228.08deg, #6777FA 26.34%, #01B8AB 84.37%)
- Stripes: barras de 7px com gap 12px
  - Ativas: linear-gradient(267.81deg, #6777FA 27.96%, #03B6AD 86.51%)
  - Inativas: #292D52

Props:
- year: number
- age: number
- value: number
- percentChange: number
- isToday?: boolean
- progress: number (0-1, para calcular stripes ativas)

Valor:
- Font: Work Sans 23px 500
- Color: #FFFFFF

Ano:
- Font: Work Sans 19px 500
- Color: #797979

Badge "Hoje":
- Componente Badge variant="today"

Idade:
- Font: Work Sans 23px 500
- Color: #68AAF1

Percentual:
- Font: Work Sans 19px 500
- Color: #68AAF1
```

### Prompt 3.4 - MovementCard

```
Implemente MovementCard em frontend/src/components/molecules/MovementCard.tsx

Referências:
- docs/frontend/DESIGN_SYSTEM.md (seção Cards de Movimentação)

Especificações:
- Width: 697.82px (ou 100% com max-width)
- Height: 172px
- Background: #1D1F1E
- Border: 2px solid #67AEFA
- Border-radius: 15px
- Padding: 28px 47px

Layout:
┌─────────────────────────────────────────────┐
│ Herança                          ↑ R$ 220.000│
│ 09/07/23 - 22/07/23                         │
│ Frequência: Única                           │
│ Crédito                                     │
└─────────────────────────────────────────────┘

Título:
- Font: Work Sans 27px 500
- Color: #C9C9C9

Datas:
- Font: Work Sans 19px 700
- Color: #919191

Frequência/Tipo:
- Font: Work Sans 19px 500/700
- Color: #919191

Valor:
- Font: Work Sans 23px 700
- Crédito (positivo): #408E37, ícone ↑
- Débito (negativo): #C65353, ícone ↓

Props:
- title: string
- startDate: string
- endDate?: string
- frequency: 'única' | 'mensal' | 'anual'
- type: 'crédito' | 'débito' | 'dependente'
- value: number
- onClick?: () => void
```

### Prompt 3.5 - InsuranceCard

```
Implemente InsuranceCard em frontend/src/components/molecules/InsuranceCard.tsx

Referências:
- docs/frontend/DESIGN_SYSTEM.md (seção Cards de Seguro)

Especificações:
- Width: 697.82px (ou 100% com max-width)
- Height: 172px
- Background: #1D1F1E
- Border: 2px solid #67AEFA
- Border-radius: 15px
- Padding: 28px 47px

Layout:
┌─────────────────────────────────────────────┐
│ Seguro de Vida Familiar          R$ 500.000 │
│ Seguro de Vida                              │
│ Duração: 15 anos                            │
│ Prêmio: R$ 120/mês                          │
└─────────────────────────────────────────────┘

Título:
- Font: Work Sans 27px 500
- Color: #C9C9C9

Tipo de seguro:
- Font: Work Sans 19px 700
- Color: #919191

Duração:
- Font: Work Sans 19px 700
- Color: #919191

Prêmio:
- Font: Work Sans 19px 700
- Color: #919191

Valor cobertura:
- Font: Work Sans 23px 700
- Color: #A034FF (roxo)

Props:
- name: string
- type: string
- duration: string
- premium: number
- coverage: number
- onClick?: () => void
```

### Prompt 3.6 - TimelineMarker

```
Implemente TimelineMarker em frontend/src/components/molecules/TimelineMarker.tsx

Referências:
- docs/frontend/DESIGN_SYSTEM.md (seção Timeline)

Estrutura:
- Ponto na timeline
- Label de valor abaixo/acima
- Tooltip com detalhes (opcional)

Ponto:
- Width: 14.96px
- Height: 16px
- Border-radius: 50%
- Cores:
  - salary (verde): #00C900
  - expense (vermelho): #FF5151

Label de valor:
- Font: Work Sans 19px 500
- Cor: mesma do ponto

Props:
- type: 'salary' | 'expense'
- value: number
- year: number
- label?: string (ex: "CLT: R$ 15.000")
- position: number (percentual na timeline)
- showLabel?: boolean

Tooltip (hover):
- Descrição completa
- Período
- Valor formatado
```

### Prompt 3.7 - ProgressBarStripes

```
Implemente ProgressBarStripes em frontend/src/components/molecules/ProgressBarStripes.tsx

Referências:
- docs/frontend/DESIGN_SYSTEM.md (seção Barras de Progresso)

Componente que gera barras verticais (stripes) para indicar progresso.

Especificações:
- Container height: 70px
- Cada stripe: width 7px, height 70px, border-radius 8px
- Gap entre stripes: 12px
- Total de stripes: calcular baseado em width disponível

Cores:
- Ativa: linear-gradient(267.81deg, #6777FA 27.96%, #03B6AD 86.51%)
- Inativa: #292D52

Props:
- progress: number (0-100)
- totalStripes?: number (ou calculado)
- width?: number | string
- height?: number

Lógica:
- Calcular quantas stripes cabem no width
- Multiplicar por progress para saber quantas são ativas
- Renderizar stripes com gradiente (ativas) ou cor sólida (inativas)

Animação opcional: stripes preenchendo progressivamente.
```

---

## Fase 4: Componentes Orgânicos

### Prompt 4.1 - Header

```
Implemente Header em frontend/src/components/organisms/Header.tsx

Referências:
- docs/frontend/DESIGN_SYSTEM.md (seção Navegação)

Layout:
┌─────────────────────────────────────────────────────────┐
│ [Logo]              Alocações   Projeção   Histórico    │
└─────────────────────────────────────────────────────────┘

Logo:
- Anka logo (placeholder ou SVG)
- Width: ~95px
- Glow effect sutil (orange/red)

Navegação:
- Font: ABeeZee 24px 400
- Gap: 50px entre items
- Tab ativa: color #C1C1C1, text-decoration underline
- Tab inativa: color #2D2D2D

Props:
- activeTab: 'alocacoes' | 'projecao' | 'historico'
- onTabChange: (tab: string) => void

Usar Next.js Link para navegação.
Sticky header (position: sticky, top: 0).
Z-index alto.
```

### Prompt 4.2 - Sidebar

```
Implemente Sidebar em frontend/src/components/organisms/Sidebar.tsx

Referências:
- Imagem: Sidebar Anka escura com logo laranja
- docs/frontend/DESIGN_SYSTEM.md (seção Sidebar)

OBSERVAÇÃO CRÍTICA:
Esta Sidebar é o MENU GLOBAL de módulos do sistema, NÃO as abas internas do cliente.
As abas (Alocações, Projeção, Histórico) ficam no Header (Prompt 4.1).
Ver diferença em image_f84ea0.png (menu sidebar) vs image_f84e7e.jpg (abas header).

Layout:
┌────────────────────────────┐
│    [Logo Anka]             │
│   (Glow laranja)           │
│                            │
│ 👤 Clientes                │
│ 👥 Prospects ▼             │
│ 📊 Consolidação ▼          │
│ 💼 CRM ▼                   │
│ 💰 Captação ▼              │
│ 📄 Financeiro ▼            │
│                            │
│ ─────────────────────────  │
│ [Avatar] Nome              │
│        email               │
│ ⋯                          │
└────────────────────────────┘

Estilo:
- Position: fixed left
- Width: 290px
- Height: 100vh
- Background: #000000 (muito escuro) ou #101010
- Border-right: 1px solid #2F2F2F
- Padding: 24px 0

Seção Logo (Topo):
- Texto: "Anka" centralizado
- Font: Work Sans 24px 700
- Cor: Gradiente Laranja/Vermelho (de DESIGN_SYSTEM)
- Glow effect: laranja sutil (usar .glow-* classes)
- Padding-bottom: 32px
- Border-bottom: 1px solid #2F2F2F

Itens do Menu:
- Font: Work Sans 18px 500
- Padding: 16px 24px
- Cursor: pointer
- Gap entre ícone e label: 12px
- Cor inativo: #9F9F9F
- Cor ativo: #FFFFFF
- Hover: bg #1B1B1B, transition 200ms
- Layout: flex row (ícone + label + spacer + chevron)

Chevron behavior:
- Ícone de dropdown (▼)
- Rotaciona quando item tem submenu
- Não implementar submenus neste prompt (será futuro)

Itens (conforme imagem image_f84ea0.png):
1. Clientes (ícone: user) - sem submenu por enquanto
2. Prospects (ícone: person-add) + chevron
3. Consolidação (ícone: share) + chevron
4. CRM (ícone: layout) + chevron
5. Captação (ícone: money-bag) + chevron
6. Financeiro (ícone: document) + chevron

Seção User (Fundo):
- Avatar: 40x40px, rounded, iniciais, cor aleatória
- Nome: Inter 14px 500 #FFFFFF
- Email: Inter 13px 400 #9F9F9F
- Menu dots: 3 pontos #444444, hover #FFFFFF
- Padding: 24px
- Border-top: 1px solid #2F2F2F
- Margin-top: auto (flex layout)

Props:
- activeItem?: string
- onItemClick?: (itemId: string) => void
- user?: { name: string; email: string; avatar?: string }
- collapsed?: boolean (para mobile)

Hooks:
- useState para controlar que item está ativo
- Usar Next.js Router para navegação

Responsivo:
- Desktop: 290px fixo
- Mobile: pode desaparecer ou usar hamburger (collapsar)
```

### Prompt 4.3 - ProjectionChart

```
Implemente ProjectionChart em frontend/src/components/organisms/ProjectionChart.tsx

Referências:
- docs/frontend/DESIGN_SYSTEM.md (seção Gráfico)

IMPORTANTE: Este é o componente mais complexo. Use Recharts.

Container:
- Background: #1B1B1B
- Border-radius: 32px
- Padding: 20px 32px
- Width: 100% (max 1413px)
- Height: 402px

Header do gráfico:
- Título: "Projeção Patrimonial" - Neuton 31px 400 #DADADA
- Links: "Ver com detalhes", "Ver como Tabela" - Work Sans 17px 500 #DADADA

Eixo Y:
- Labels: R$ 3,5 M, R$ 3 M, R$ 2,5 M, R$ 2 M, R$ 1,5 M, R$ 1 M, R$ 500K, R$ 0
- Font: Inter 14px 500 #4C4C4C

Grid lines:
- Horizontal: border 1px dashed #565656

Linhas do gráfico:
1. Plano Original (azul):
   - Stroke: #67AEFA
   - StrokeDasharray: "8 4"
   - StrokeWidth: 3
   - Filter: glow effect (ver Design System)

2. Sugestão (verde):
   - Stroke: #48F7A1
   - StrokeDasharray: "8 4"
   - StrokeWidth: 3
   - Filter: glow effect

3. Realizado (amarelo):
   - Stroke: #F7B748
   - StrokeDasharray: none (sólida)
   - StrokeWidth: 3
   - Filter: glow effect
   - Dots: 17x12px #F7B748

Props:
- data: ProjectionDataPoint[]
- showOriginal: boolean
- showSuggestion: boolean
- showRealized: boolean
- onPointClick?: (point: ProjectionDataPoint) => void

Types:
interface ProjectionDataPoint {
  year: number;
  original?: number;
  suggestion?: number;
  realized?: number;
}

Usar ReferenceLine para grid.
Usar Line com customização de stroke.
Custom dot component para pontos do realizado.
Filter SVG para glow effects.
```

### Prompt 4.4 - SimulationSelector

```
Implemente SimulationSelector em frontend/src/components/organisms/SimulationSelector.tsx

Referências:
- docs/frontend/DESIGN_SYSTEM.md
- Componente SimulationCard

Layout horizontal:
┌───────────────┐ ┌──────────────────┐ ┌──────────┐
│◉ Plano Origin.│ │○ Situação atual  │ │○ Realizado│ + Adicionar Simulação
│             ⋮│ │  05/2025       ⋮│ │          │
└───────────────┘ └──────────────────┘ └──────────┘

Container:
- Display: flex
- Gap: 23px
- Align: center

Botão adicionar:
- Texto: "+ Adicionar Simulação"
- Font: Work Sans 19px 500 #C9C9C9
- Sem background/borda

Props:
- simulations: SimulationVersion[]
- selectedId: string
- onSelect: (id: string) => void
- onAdd: () => void
- onMenuClick: (id: string) => void

Features:
- Scroll horizontal se muitas simulações
- Ordenar: original primeiro, depois por data
```

### Prompt 4.5 - Timeline

```
Implemente Timeline em frontend/src/components/organisms/Timeline.tsx

Referências:
- docs/frontend/DESIGN_SYSTEM.md (seção Timeline)

COMPONENTE COMPLEXO - Duas linhas paralelas.

Layout:
┌─────────────────────────────────────────────────────────────────┐
│ Timeline                                           + Adicionar  │
│                                                                  │
│ CLT: R$15.000    CLT+Autônomo    Autônomo    Aposentadoria     │
│ Salário ●━━━━━━━━━━●━━━━━━━━━━━━━━●━━━━━━━━━━●━━━━━━━━━━━━━━━━│
│        2025     2030           2035        2045              2060│
│        45       50             55          65                 80 │
│ Custo  ●━━━━━━━━━━●━━━━━━━━━━━━━━●━━━━━━━━━━●━━━━━━━━━●━━━━━━━│
│ de vida R$8k    R$12k         R$20k      R$10k     R$15k      │
└─────────────────────────────────────────────────────────────────┘

Título:
- "Timeline" - Neuton 31px 400 #67AEFA

Linha de salário (verde):
- Linha: 4px solid #919191
- Marcadores verticais: 24px height, 1px #919191
- Pontos de evento: 15x16px circular #00C900
- Labels acima: descrição da fonte de renda

Linha de custo (vermelho):
- Mesma estrutura
- Cor: #FF5151
- Labels abaixo: valor do custo

Anos:
- Font: Work Sans 23px 500 #FFFFFF
- Posição: entre as duas linhas

Idades:
- Font: Work Sans 19px 400 #FFFFFF
- Abaixo do ano

Props:
- events: TimelineEvent[]
- startYear: number
- endYear: number
- clientAge: number
- onAddEvent: () => void

Types:
interface TimelineEvent {
  id: string;
  year: number;
  type: 'salary' | 'expense';
  label: string;
  value: number;
  description?: string;
}

Scroll horizontal para timeline longa.
```

### Prompt 4.6 - MovementsList

```
Implemente MovementsList em frontend/src/components/organisms/MovementsList.tsx

Referências:
- docs/frontend/DESIGN_SYSTEM.md

Layout:
┌─────────────────────────────────────────────────────────────────┐
│ Movimentações                 [Financeiras] [Imobilizadas]      │
│                                                    + Adicionar  │
│ ┌─────────────────────────┐ ┌─────────────────────────┐        │
│ │ Herança                 │ │ Custo do filho          │        │
│ │ ...                     │ │ ...                     │        │
│ └─────────────────────────┘ └─────────────────────────┘        │
│ ┌─────────────────────────┐                                    │
│ │ Comissão                │                                    │
│ │ ...                     │                                    │
│ └─────────────────────────┘                                    │
└─────────────────────────────────────────────────────────────────┘

Título:
- "Movimentações" - Neuton 31px 400 #67AEFA

Filtros:
- "Financeiras" (ativo): bg #EBEBEB, color #444444
- "Imobilizadas" (inativo): bg #1F1F1F, color #707070
- Border-radius: 47px
- Padding: 12px 24px

Botão adicionar:
- "+ Adicionar"
- Border: 2px solid #1F1F1F
- Border-radius: 47px
- Font: Work Sans 19px 500 #FFFFFF

Grid de cards:
- 2 colunas
- Gap: 15px
- Responsive: 1 coluna em mobile

Props:
- transactions: Transaction[]
- filter: 'financeiras' | 'imobilizadas'
- onFilterChange: (filter: string) => void
- onAdd: () => void
- onEdit: (id: string) => void

Hook: usar useTransactions()
```

### Prompt 4.7 - InsurancesList

```
Implemente InsurancesList em frontend/src/components/organisms/InsurancesList.tsx

Referências:
- docs/frontend/DESIGN_SYSTEM.md

Layout:
┌─────────────────────────────────────────────────────────────────┐
│ Seguros                                            + Adicionar  │
│ ┌─────────────────────────┐ ┌─────────────────────────┐        │
│ │ Seguro de Vida Familiar │ │ Seguro de Invalidez     │        │
│ │ ...                     │ │ ...                     │        │
│ └─────────────────────────┘ └─────────────────────────┘        │
└─────────────────────────────────────────────────────────────────┘

Título:
- "Seguros" - Neuton 31px 400 #67AEFA

Subtítulo (opcional):
- Descrição - Inter 18px 500 #919191

Botão adicionar:
- Mesmo estilo de MovementsList

Grid de cards:
- 2 colunas
- Gap: 15px

Props:
- insurances: Insurance[]
- onAdd: () => void
- onEdit: (id: string) => void

Hook: usar useInsurances()
```

### Prompt 4.8 - DashboardLayout (Template)

```
Implemente o layout base em frontend/src/components/templates/DashboardLayout.tsx

Referências:
- docs/frontend/DESIGN_SYSTEM.md
- Componentes: Sidebar (4.2)

OBJETIVO:
Criar o esqueleto que separa a Sidebar (fixa, esquerda) do Conteúdo principal (scrollável).

Estrutura DOM:
```tsx
<div className="flex h-screen w-full bg-[#101010] overflow-hidden">
  {/* Área da Sidebar - Fixa no canto esquerdo */}
  <aside className="w-[290px] flex-shrink-0 border-r border-[#2F2F2F] bg-[#000000]">
    <Sidebar />
  </aside>

  {/* Área de Conteúdo - Scrollável independentemente */}
  <main className="flex-1 flex flex-col overflow-y-auto overflow-x-hidden relative">
    <div className="min-h-full w-full">
      {children}
    </div>
  </main>
</div>
```

Requisitos:
1. Sidebar FIXA à esquerda (flex-shrink-0, não diminui)
2. Main tem scroll independente (overflow-y-auto)
3. Background global #101010 aplica ao wrapper
4. Nenhum vazamento horizontal (overflow-x-hidden no main)
5. Altura: 100vh (fullscreen)

Props:
- children: ReactNode (conteúdo principal a renderizar)
- user?: { name: string; email: string; avatar?: string } (passar para Sidebar)
- activeMenuItem?: string (passar para Sidebar)
- onMenuItemClick?: (item: string) => void (passar para Sidebar)

Mobile Responsivo:
- Desktop: Sidebar 290px + Main flex-1
- Tablet/Mobile: Sidebar colapsa ou usa hamburger menu (futuro)

Nota Importante:
- Este layout DEVE envolver toda a aplicação (ver Prompt 5.1 ProjectionScreen)
- O Header (4.1) vai DENTRO do main, não fora
- Não colocar Header aqui - cada tela define seu próprio header

Exemplo de uso:
```tsx
// pages/projection.tsx
import DashboardLayout from '@/components/templates/DashboardLayout';

export default function ProjectionPage() {
  return (
    <DashboardLayout activeMenuItem="clientes">
      <Header activeTab="projecao" />
      {/* Resto do conteúdo */}
    </DashboardLayout>
  );
}
```
```

---

## Fase 5: Telas Completas

### Prompt 5.1 - ProjectionScreen

```
Implemente ProjectionScreen em frontend/src/components/screens/ProjectionScreen.tsx

Esta é a TELA PRINCIPAL. Compose todos os organismos criados anteriormente.

Referências:
- docs/frontend/IMPLEMENTATION_PLAN.md (wireframe estrutural)
- docs/frontend/DESIGN_SYSTEM.md

Seções (de cima para baixo):
1. Header info
   - ClientSelector (esquerda)
   - YearCards em row (direita): 2025, 2035, 2045

2. Patrimônio total (abaixo do selector)
   - Label: "Patrimônio Líquido Total" - Satoshi 19px 500 #7B7B7B
   - Valor: Work Sans 39px 500 #757575
   - Percentual: Work Sans 19px 500 #68AAF1

3. Opções
   - Checkboxes: Morto, Inválido
   - Dropdown: Sugestão

4. Gráfico
   - ProjectionChart

5. Seletor de simulações
   - SimulationSelector

6. Timeline
   - Timeline component

7. Movimentações
   - MovementsList

8. Seguros
   - InsurancesList

Layout:
- Padding: 0 101px (desktop)
- Max-width: 1598px
- Background: #101010
- Scroll vertical

Props:
- clientId: string (da URL ou contexto)

Hooks:
- useClient(clientId)
- useSimulations(clientId)
- useTransactions(simulationId)
- useInsurances(simulationId)
- useAllocations(simulationId)

Estados:
- Loading: skeleton loaders
- Error: mensagens de erro
- Empty: estados vazios

Responsive:
- Mobile: stack vertical, cards full-width
- Tablet: 2 colunas
- Desktop: layout completo
```

### Prompt 5.2 - AllocationsScreen

```
Implemente AllocationsScreen em frontend/src/components/screens/AllocationsScreen.tsx

Tela de alocações de ativos.

Referências:
- Figma (tab Alocações)
- docs/frontend/DESIGN_SYSTEM.md

Seções:
1. Header com ClientSelector
2. Tabela de alocações
3. Gráfico de pizza/donut (opcional)

Tabela:
- Colunas: Classe, Ativo, Porcentagem, Valor
- Estilo dark theme
- Ordenação por coluna
- Edição inline ou modal

Gráfico donut:
- Cores por classe de ativo
- Legenda interativa

Props:
- clientId: string

Hook: useAllocations()
```

### Prompt 5.3 - HistoryScreen

```
Implemente HistoryScreen em frontend/src/components/screens/HistoryScreen.tsx

Tela de histórico de simulações.

Referências:
- Figma (tab Histórico)
- docs/frontend/DESIGN_SYSTEM.md

Seções:
1. Header com ClientSelector
2. Lista de versões de simulação
3. Preview/comparativo

Lista de versões:
- Cards com data, nome, status
- Ação para visualizar/restaurar

Comparativo:
- Dois gráficos lado a lado
- Diferenças destacadas

Props:
- clientId: string

Hooks:
- useSimulations()
- useSimulationVersions()
```

---

## Fase 6: Interatividade

### Prompt 6.1 - Navegação e Routing

```
Configure navegação completa do frontend.

Arquivos:
- frontend/src/pages/index.tsx (redirect para /projecao)
- frontend/src/pages/projecao/[clientId].tsx
- frontend/src/pages/alocacoes/[clientId].tsx
- frontend/src/pages/historico/[clientId].tsx

Features:
- Seleção de cliente persiste entre telas
- URL reflete cliente selecionado
- Tabs highlight baseado na rota atual
- Navegação com Next.js Link

Query params:
- simulationId para pré-selecionar simulação
- date para alocações

Loading:
- Suspense boundaries
- Skeleton loaders

Error:
- Error boundaries
- Páginas 404, 500 customizadas
```

### Prompt 6.2 - Modais

```
Implemente modais para CRUD.

Arquivos:
- frontend/src/components/modals/AddMovementModal.tsx
- frontend/src/components/modals/AddInsuranceModal.tsx
- frontend/src/components/modals/AddSimulationModal.tsx
- frontend/src/components/modals/BaseModal.tsx

BaseModal:
- Overlay escuro
- Container centralizado
- Close button
- Keyboard: ESC para fechar
- Click outside para fechar
- Animation: fade + scale

AddMovementModal:
- Form para nova movimentação
- Campos: título, datas, frequência, tipo, valor
- Validação Zod
- Submit com React Query mutation

AddInsuranceModal:
- Form para novo seguro
- Campos: nome, tipo, duração, prêmio, cobertura
- Validação Zod

AddSimulationModal:
- Form para nova simulação
- Campos: nome, baseada em (opcional)
- Validação Zod
```

### Prompt 6.3 - Formulários com Validação

```
Configure formulários com React Hook Form + Zod.

Arquivos:
- frontend/src/lib/schemas/movement.schema.ts
- frontend/src/lib/schemas/insurance.schema.ts
- frontend/src/lib/schemas/simulation.schema.ts
- frontend/src/components/forms/MovementForm.tsx
- frontend/src/components/forms/InsuranceForm.tsx
- frontend/src/components/forms/SimulationForm.tsx

Schemas Zod:
- Validar tipos, formatos, ranges
- Mensagens de erro em português
- Transform para formatar valores

Forms:
- Usar useForm com zodResolver
- Campos com componentes atoms (Input, Select)
- Estados de erro inline
- Submit handling

Features:
- Máscara de valores monetários
- Datepicker integrado
- Select com busca
```

### Prompt 6.4 - Integração Final

```
Conecte tudo com a API.

Verificar:
1. Todos os hooks conectados
2. Loading states em todos componentes
3. Error handling em todas requisições
4. Optimistic updates onde aplicável
5. Cache invalidation correto

Testar fluxos:
1. Login → Selecionar cliente → Ver projeção
2. Adicionar movimentação → Ver atualização
3. Adicionar seguro → Ver atualização
4. Criar simulação → Comparar
5. Navegar entre tabs → Estado mantido

Performance:
- React Query caching
- Prefetch em hover
- Debounce em buscas
- Virtualização se listas grandes
```

---

## 📝 Como Usar Este Guia

1. **Copie o prompt** da fase/etapa atual
2. **Execute** com o contexto do projeto
3. **Verifique** o resultado contra o Figma
4. **Ajuste** até atingir 90%+ fidelidade
5. **Marque como concluído** no checklist
6. **Prossiga** para o próximo prompt

---

## ✅ Checklist de Progresso

### Fase 1: Setup
- [ ] 1.1 - Estilos Globais

### Fase 2: Atoms
- [ ] 2.1 - Button
- [ ] 2.2 - Badge
- [ ] 2.3 - Radio/Checkbox
- [ ] 2.4 - Input
- [ ] 2.5 - Select
- [ ] 2.6 - Icons

### Fase 3: Molecules
- [ ] 3.1 - ClientSelector
- [ ] 3.2 - SimulationCard
- [ ] 3.3 - YearCard
- [ ] 3.4 - MovementCard
- [ ] 3.5 - InsuranceCard
- [ ] 3.6 - TimelineMarker
- [ ] 3.7 - ProgressBarStripes

### Fase 4: Organisms
- [ ] 4.1 - Header
- [ ] 4.2 - Sidebar
- [ ] 4.3 - ProjectionChart
- [ ] 4.4 - SimulationSelector
- [ ] 4.5 - Timeline
- [ ] 4.6 - MovementsList
- [ ] 4.7 - InsurancesList

### Fase 5: Screens
- [ ] 5.1 - ProjectionScreen
- [ ] 5.2 - AllocationsScreen
- [ ] 5.3 - HistoryScreen

### Fase 6: Interatividade
- [ ] 6.1 - Navegação
- [ ] 6.2 - Modais
- [ ] 6.3 - Formulários
- [ ] 6.4 - Integração Final
