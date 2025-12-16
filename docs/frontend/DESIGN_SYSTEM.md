# 🎨 Design System - Anka MFO

> Especificações extraídas do Figma para garantir 90%+ de fidelidade visual.

## 📋 Índice

1. [Cores](#cores)
2. [Tipografia](#tipografia)
3. [Espaçamentos](#espaçamentos)
4. [Componentes Base](#componentes-base)
5. [Gradientes](#gradientes)
6. [Sombras e Efeitos](#sombras-e-efeitos)

---

## 🎨 Cores

### Background
```css
--bg-primary: #101010;      /* Fundo principal */
--bg-secondary: #1B1B1B;    /* Cards, containers */
--bg-tertiary: #1D1F1E;     /* Cards de movimentação/seguros */
--bg-card: #1F1F1F;         /* Botões inativos */
--bg-sidebar-item: #303030; /* Item ativo sidebar */
```

### Texto
```css
--text-primary: #FFFFFF;    /* Títulos principais */
--text-secondary: #C9C9C9;  /* Texto padrão */
--text-tertiary: #919191;   /* Labels secundários */
--text-muted: #757575;      /* Valores grandes (patrimônio) */
--text-disabled: #707070;   /* Texto desabilitado */
--text-dark: #444444;       /* Texto em botões claros */
--text-link: #C1C1C1;       /* Links inativos */
--text-link-active: #2D2D2D; /* Links ativos (com underline) */
```

### Cores de Estado
```css
--color-primary: #67AEFA;   /* Azul principal (projeção) */
--color-secondary: #6777FA; /* Roxo/Azul gradiente */
--color-accent: #03B6AD;    /* Teal/Verde-água gradiente */
--color-success: #408E37;   /* Verde (crédito) */
--color-success-bright: #00C900; /* Verde timeline salário */
--color-warning: #F7B748;   /* Amarelo/Laranja (realizado) */
--color-danger: #C65353;    /* Vermelho (débito) */
--color-danger-bright: #FF5151; /* Vermelho timeline custo */
--color-suggestion: #48F7A1; /* Verde sugestão */
--color-purple: #A034FF;    /* Roxo (seguros) */
```

### Bordas e Linhas
```css
--border-default: #444444;  /* Linhas divisórias */
--border-light: #2F2F2F;    /* Bordas sutis */
--border-input: #C9C9C9;    /* Bordas de input */
--border-inactive: #292D52; /* Barras de progresso inativas */
```

---

## 🔤 Tipografia

### Fontes
```css
/* Fontes principais do Figma */
font-family: 'Work Sans', sans-serif;  /* Principal para textos */
font-family: 'Inter', sans-serif;       /* Textos secundários, labels */
font-family: 'Neuton', serif;           /* Títulos de seção */
font-family: 'ABeeZee', sans-serif;     /* Navegação/Tabs */
font-family: 'Satoshi', sans-serif;     /* Labels especiais */
```

### Tamanhos e Pesos

#### Títulos de Seção (Neuton)
```css
/* Projeção Patrimonial, Timeline, Movimentações, Seguros */
font-size: 31px;
font-weight: 400;
line-height: 30px;
color: #67AEFA; /* ou #DADADA para título do gráfico */
```

#### Patrimônio Grande (Work Sans)
```css
/* R$ 2.679.930,00 principal */
font-size: 39px;
font-weight: 500;
line-height: 30px;
color: #757575;
```

#### Valores em Cards (Work Sans)
```css
/* R$ 2.679.930,00 nos cards de timeline */
font-size: 23px;
font-weight: 500;
line-height: 30px;
color: #FFFFFF;
```

#### Percentuais (Work Sans)
```css
/* +52,37%, +18,37% */
font-size: 19px;
font-weight: 500;
line-height: 30px;
color: #68AAF1;
```

#### Navegação/Tabs (ABeeZee)
```css
font-size: 24px;
font-weight: 400;
line-height: 30px;
/* Ativo: color: #2D2D2D; text-decoration: underline; */
/* Inativo: color: #C1C1C1; */
```

#### Labels (Inter/Work Sans)
```css
/* Patrimônio Líquido Total */
font-family: 'Satoshi';
font-size: 19px;
font-weight: 500;
color: #7B7B7B;

/* Labels gerais */
font-family: 'Work Sans';
font-size: 19px;
font-weight: 500;
color: #919191;
```

#### Nome do Cliente (Work Sans)
```css
font-size: 35px;
font-weight: 500;
line-height: 30px;
color: #FFFFFF;
```

#### Texto Pequeno (Inter)
```css
/* Labels do eixo Y do gráfico */
font-size: 14px;
font-weight: 500;
line-height: 30px;
color: #4C4C4C;
```

---

## 📐 Espaçamentos

### Container Principal
```css
padding: 0 101px; /* padding lateral */
max-width: 1598px;
```

### Cards
```css
/* Card de gráfico */
border-radius: 32px;
padding: 20px 32px;

/* Cards de movimentação/seguros */
border-radius: 15px;
width: 697.82px;
height: 172px;
gap: 15px; /* entre cards */

/* Cards de simulação */
border-radius: 16px;
height: 64px;
```

### Botões
```css
/* Botões pill */
border-radius: 47px;
padding: 12px 24px;
height: 54px;

/* Botões pequenos */
border-radius: 4px;
padding: 10px;
```

---

## 🧩 Componentes Base

### Seletor de Cliente
```css
/* Container */
width: 445px;
height: 66px;
background: #101010;
border: 2px solid #C9C9C9;
border-radius: 32px;

/* Texto */
font-family: 'Work Sans';
font-size: 35px;
font-weight: 500;
color: #FFFFFF;

/* Ícone chevron */
border: 4px solid #C9C9C9;
```

### Cards de Timeline (Anos)
```css
/* Container com valor */
background: rgba(103, 119, 250, 0.28); /* Fundo */
border-radius: 6px;
height: 70px;

/* Barra de progresso sólida */
background: linear-gradient(228.08deg, #6777FA 26.34%, #01B8AB 84.37%);

/* Barras verticais (stripes) */
width: 7px;
height: 70px;
border-radius: 8px;
background: linear-gradient(267.81deg, #6777FA 27.96%, #03B6AD 86.51%);
gap: 12px; /* entre barras */

/* Barras inativas */
background: #292D52;
```

### Card de Simulação
```css
/* Plano Original (selecionado) */
background: #1B1B1B;
border: 2px solid #67AEFA;
border-radius: 16px;

/* Radio button */
width: 32px;
height: 32px;
border: 2px solid #67AEFA;
/* Inner circle */
width: 24px;
height: 24px;
background: #67AEFA;

/* Situação atual (verde) */
border: 2px solid #48F7A1;

/* Realizado (amarelo) */
border: 2px solid #F7B748;

/* Menu dots */
width: 4px;
height: 4px;
background: #D9D9D9;
gap: 3px;
```

### Checkbox Morto/Inválido
```css
width: 32px;
height: 32px;
border: 2px solid #8E8E8E;
border-radius: 50%;

/* Label */
font-family: 'Neuton';
font-size: 31px;
font-weight: 400;
color: #8E8E8E;
```

### Badge Sugestão
```css
background: rgba(72, 247, 161, 0.24);
border-radius: 4px;
padding: 10px;

/* Texto */
font-family: 'Work Sans';
font-size: 14px;
font-weight: 500;
color: #48F7A1;
```

### Badge "Hoje"
```css
background: rgba(83, 132, 235, 0.24);
border-radius: 4px;
padding: 10px;

/* Texto */
font-family: 'Work Sans';
font-size: 17px;
font-weight: 500;
color: #5880EF;
```

### Cards de Movimentação
```css
/* Container */
background: #1D1F1E;
border: 2px solid #67AEFA;
border-radius: 15px;
width: 697.82px;
height: 172px;

/* Título (Herança, Comissão) */
font-family: 'Work Sans';
font-size: 27px;
font-weight: 500;
color: #C9C9C9;

/* Datas */
font-size: 19px;
font-weight: 700;
color: #919191;

/* Valor crédito */
font-size: 23px;
font-weight: 700;
color: #408E37; /* verde */

/* Valor débito */
color: #C65353; /* vermelho */
```

### Botões de Filtro (Financeiras/Imobilizadas)
```css
/* Ativo */
background: #EBEBEB;
border-radius: 47px;
font-family: 'Work Sans';
font-size: 19px;
color: #444444;

/* Inativo */
background: #1F1F1F;
color: #707070;
```

### Botão Adicionar
```css
border: 2px solid #1F1F1F;
border-radius: 47px;
background: transparent;
font-family: 'Work Sans';
font-size: 19px;
font-weight: 500;
color: #FFFFFF;
```

---

## 🌈 Gradientes

### Gradiente Principal (Barras de Progresso)
```css
/* Sólido */
background: linear-gradient(228.08deg, #6777FA 26.34%, #01B8AB 84.37%);

/* Stripes */
background: linear-gradient(267.81deg, #6777FA 27.96%, #03B6AD 86.51%);

/* Union shape */
background: linear-gradient(300.81deg, #6777FA 33.57%, #03B6AD 67.34%);
```

### Fade para Borda
```css
/* Fade direita */
background: linear-gradient(271.01deg, #101010 0.81%, rgba(16, 16, 16, 0) 99.09%);
```

---

## ✨ Sombras e Efeitos

### Glow do Gráfico - Linha Azul (Plano Original)
```css
border: 3px dashed #67AEFA;
box-shadow: 
  163px 47px 48px rgba(103, 174, 250, 0.02),
  105px 30px 44px rgba(103, 174, 250, 0.15),
  59px 17px 37px rgba(103, 174, 250, 0.5),
  26px 8px 27px rgba(103, 174, 250, 0.85),
  7px 2px 15px rgba(103, 174, 250, 0.98);
```

### Glow do Gráfico - Linha Verde (Sugestão)
```css
border: 3px dashed #48F7A1;
box-shadow: 
  87px 39px 27px rgba(14, 216, 121, 0.02),
  56px 25px 24px rgba(14, 216, 121, 0.15),
  31px 14px 21px rgba(14, 216, 121, 0.5),
  14px 6px 15px rgba(14, 216, 121, 0.85),
  3px 2px 8px rgba(14, 216, 121, 0.98);
```

### Glow do Gráfico - Linha Amarela (Realizado)
```css
border: 3px solid #F7B748;
box-shadow: 
  135px 31px 39px rgba(239, 183, 81, 0.02),
  87px 20px 36px rgba(239, 183, 81, 0.15),
  49px 11px 30px rgba(239, 183, 81, 0.5),
  22px 5px 22px rgba(239, 183, 81, 0.85),
  5px 1px 12px rgba(239, 183, 81, 0.98);
```

### Pontos do Gráfico (Realizado)
```css
width: 17.28px;
height: 12px;
background: #F7B748;
border-radius: 50%;
```

---

## 📊 Gráfico - Estrutura

### Container
```css
background: #1B1B1B;
border-radius: 32px;
width: 1413px;
height: 402px;
```

### Linhas de Grade
```css
border: 1px dashed #565656;
```

### Eixo Y Labels
```css
font-family: 'Inter';
font-size: 14px;
font-weight: 500;
color: #4C4C4C;
/* Valores: R$ 3,5 M, R$ 3 M, R$ 2,5 M, R$ 2 M, R$ 1,5 M, R$ 1 M, R$ 500K, R$ 0 */
```

### Links "Ver com detalhes" / "Ver como Tabela"
```css
font-family: 'Work Sans';
font-size: 17px;
font-weight: 500;
color: #DADADA;
```

---

## 📅 Timeline - Estrutura

### Container
```css
width: 100%;
padding: 0 100px;
```

### Linha Principal
```css
border: 4px solid #919191;
```

### Marcadores de Ano
```css
width: 24px;
border: 1px solid #919191;
```

### Pontos de Evento
```css
width: 14.96px;
height: 16px;
border-radius: 50%;
/* Verde: #00C900 */
/* Vermelho: #FF5151 */
```

### Labels de Ano
```css
font-family: 'Work Sans';
font-size: 23px;
font-weight: 500;
color: #FFFFFF;
```

### Labels de Idade
```css
font-family: 'Work Sans';
font-size: 19px;
font-weight: 400;
color: #FFFFFF;
```

### Labels de Valor Salário
```css
font-size: 19px;
font-weight: 500;
color: #00C900;
```

### Labels de Custo de Vida
```css
font-size: 19px;
font-weight: 500;
color: #FF5151;
```
