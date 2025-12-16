# 📚 Documentação Frontend - Anka MFO

> Guias completos para implementação do frontend com 90%+ de fidelidade ao Figma.

## 📁 Arquivos

| Arquivo | Descrição |
|---------|-----------|
| [DESIGN_SYSTEM.md](./DESIGN_SYSTEM.md) | Especificações de cores, tipografia, espaçamentos e componentes |
| [IMPLEMENTATION_PLAN.md](./IMPLEMENTATION_PLAN.md) | Plano de implementação com estrutura de arquivos e fases |
| [PROMPTS.md](./PROMPTS.md) | Prompts prontos para uso sequencial |
| [FIDELITY_CHECKLIST.md](./FIDELITY_CHECKLIST.md) | Checklist para validação visual |

---

## 🚀 Quick Start

### 1. Preparação
```bash
# Ler Design System primeiro
cat docs/frontend/DESIGN_SYSTEM.md
```

### 2. Implementação Sequencial
```bash
# Seguir prompts na ordem
# Fase 1: Setup → Fase 2: Atoms → Fase 3: Molecules → ...
```

### 3. Validação
```bash
# Após cada componente, verificar no checklist
cat docs/frontend/FIDELITY_CHECKLIST.md
```

---

## 🎯 Workflow de Implementação

```
┌─────────────────────────────────────────────────────────────┐
│                    FLUXO DE IMPLEMENTAÇÃO                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Copiar prompt do PROMPTS.md                            │
│              ↓                                              │
│  2. Executar com contexto do projeto                       │
│              ↓                                              │
│  3. Verificar resultado no browser                         │
│              ↓                                              │
│  4. Comparar com Figma (screenshot lado a lado)            │
│              ↓                                              │
│  5. Ajustar até 90%+ fidelidade                            │
│              ↓                                              │
│  6. Marcar checkbox no FIDELITY_CHECKLIST.md               │
│              ↓                                              │
│  7. Próximo prompt                                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 📊 Progresso Atual

### Fase 1: Setup Base
- [ ] 1.1 - Estilos Globais (CSS variables, Tailwind, fontes)

### Fase 2: Componentes Atômicos (6 componentes)
- [ ] Button, Badge, Radio, Checkbox, Input, Select, Icons

### Fase 3: Componentes Moleculares (7 componentes)
- [ ] ClientSelector, SimulationCard, YearCard, MovementCard, InsuranceCard, TimelineMarker, ProgressBarStripes

### Fase 4: Componentes Orgânicos (7 componentes)
- [ ] Header, Sidebar, ProjectionChart, SimulationSelector, Timeline, MovementsList, InsurancesList

### Fase 5: Telas Completas (3 telas)
- [ ] ProjectionScreen, AllocationsScreen, HistoryScreen

### Fase 6: Interatividade (4 etapas)
- [ ] Navegação, Modais, Formulários, Integração Final

---

## 🔗 Links Úteis

- **Figma**: [Case Dev - Projeção](https://www.figma.com/design/i2Ml8dgRQvDsLemtRJ5Jqw/Case-Dev---Projeção)
- **Google Fonts**: [Work Sans](https://fonts.google.com/specimen/Work+Sans), [Inter](https://fonts.google.com/specimen/Inter), [Neuton](https://fonts.google.com/specimen/Neuton), [ABeeZee](https://fonts.google.com/specimen/ABeeZee)

---

## 📝 Notas Importantes

### Fontes
- **Work Sans**: Fonte principal para textos, botões, valores
- **Inter**: Labels, textos secundários
- **Neuton**: Títulos de seção (Projeção Patrimonial, Timeline, etc.)
- **ABeeZee**: Navegação/tabs
- **Satoshi**: Label especial (Patrimônio Líquido Total) - pode usar Inter como fallback

### Cores Críticas
- Background: `#101010` (deve ser exato)
- Cards: `#1B1B1B`
- Azul primário: `#67AEFA`
- Verde sugestão: `#48F7A1`
- Gradiente: `#6777FA` → `#03B6AD`

### Glow Effects
Os gráficos possuem efeitos de glow que são críticos para o visual. Use box-shadow com múltiplas camadas ou filter SVG.

---

## 🤝 Contribuindo

1. Siga os prompts na ordem especificada
2. Valide cada componente contra o checklist
3. Documente problemas conhecidos
4. Mantenha o progresso atualizado
