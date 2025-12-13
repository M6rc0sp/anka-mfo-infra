# 🤖 Guia de Agentes IA para o Projeto MFO

Este documento contém dicas e estratégias para utilizar agentes de IA de forma eficiente durante o desenvolvimento do projeto.

---

## 📋 Índice

1. [Configuração de Agentes](#configuração-de-agentes)
2. [Boas Práticas de Prompts](#boas-práticas-de-prompts)
3. [Fluxo de Trabalho Recomendado](#fluxo-de-trabalho-recomendado)
4. [Templates de Prompts](#templates-de-prompts)
5. [Troubleshooting](#troubleshooting)

---

## 🔧 Configuração de Agentes

### Agente Especializado por Domínio

Para projetos complexos, recomendo dividir o trabalho entre agentes especializados:

```
┌─────────────────────────────────────────────────────────────────┐
│                    AGENTES DO PROJETO MFO                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  🗄️ Database Agent          🔧 Backend Agent                    │
│  ├─ Schema design           ├─ API endpoints                   │
│  ├─ Migrations              ├─ Business logic                  │
│  ├─ Queries                 ├─ Tests                           │
│  └─ Performance             └─ Integrations                    │
│                                                                 │
│  🎨 Frontend Agent          🐳 DevOps Agent                     │
│  ├─ Components              ├─ Docker                          │
│  ├─ Styling                 ├─ CI/CD                           │
│  ├─ State management        ├─ Monitoring                      │
│  └─ UX decisions            └─ Deploy                          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Configuração de Contexto por Agente

#### 🗄️ Database Agent
```markdown
## Contexto
Você é um especialista em PostgreSQL e modelagem de dados.
O projeto é um sistema de gestão patrimonial (MFO).

## Conhecimento Base
- Schema atual: [cole aqui o schema.sql]
- Entidades: clients, simulations, allocations, transactions, insurances

## Regras
- Use UUIDs para PKs
- Use JSONB para dados flexíveis
- Sempre crie índices para FKs
- Documente constraints complexas
```

#### 🔧 Backend Agent
```markdown
## Contexto
Você é um desenvolvedor backend Node.js/TypeScript.
Stack: Fastify, Drizzle ORM, Zod, Vitest.

## Conhecimento Base
- Estrutura de pastas: domain/, application/, infra/
- Interfaces de repositórios: [cole aqui]
- Tipos base: [cole aqui]

## Regras
- Siga SOLID e DRY
- Valide inputs com Zod
- Documente endpoints com Swagger
- Escreva testes para lógica crítica
```

#### 🎨 Frontend Agent
```markdown
## Contexto
Você é um desenvolvedor frontend React/Next.js.
Stack: shadcn/ui, React Query, Recharts.

## Conhecimento Base
- Link do Figma: [url]
- Tema: Dark mode
- Tipos TypeScript: [cole aqui]

## Regras
- Siga o design do Figma fielmente
- Use React Query para dados
- Componentes pequenos e reutilizáveis
- Hooks customizados para lógica
```

---

## 📝 Boas Práticas de Prompts

### 1. Seja Específico e Contextual

❌ **Ruim:**
```
Crie um componente de gráfico
```

✅ **Bom:**
```
Crie um componente ProjectionChart usando Recharts que:
- Receba dados do tipo YearlyProjection[]
- Exiba linhas para: financialAssets, propertyAssets, totalAssets
- Use as cores do tema: azul, verde, roxo
- Tenha tooltip customizado com formatação de moeda BRL
- Seja responsivo (ResponsiveContainer)
```

### 2. Forneça Exemplos

❌ **Ruim:**
```
Crie a validação com Zod
```

✅ **Bom:**
```
Crie schema Zod para CreateSimulationPayload:
- name: string, 1-100 chars
- startDate: datetime string ISO
- interestRate: number 0-1 (decimal)
- inflationRate: number 0-1
- lifeStatus: enum 'normal' | 'dead' | 'invalid'

Exemplo de input válido:
{
  "name": "Plano Conservador",
  "startDate": "2024-01-01T00:00:00.000Z",
  "interestRate": 0.05,
  "inflationRate": 0.04,
  "lifeStatus": "normal"
}
```

### 3. Divida Tarefas Complexas

❌ **Ruim:**
```
Implemente toda a tela de projeção com gráficos, comparação, 
modais, tabela e todas as funcionalidades
```

✅ **Bom:**
```
Vamos implementar a tela de Projeção em partes:

Parte 1: Layout base e cards de resumo
- Header com título
- 4 cards: Patrimônio Atual, Projeção Final, Crescimento, Impacto Seguros
- Grid layout responsivo

[Após completar, peça a próxima parte]
```

### 4. Peça Explicações

```
Implemente o cálculo de taxa real no motor de projeção.
Explique a fórmula usada e por que ela é apropriada 
para esse contexto financeiro.
```

### 5. Revise Iterativamente

```
[Após receber código]

Revise o código acima considerando:
1. O tratamento de edge cases está completo?
2. Os tipos TypeScript estão corretos?
3. Há testes suficientes?
4. Segue os princípios SOLID?
```

---

## 🔄 Fluxo de Trabalho Recomendado

### Ciclo de Desenvolvimento com IA

```
┌─────────────────────────────────────────────────────────────────┐
│                   CICLO DE DESENVOLVIMENTO                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   1. PLANEJAR                                                   │
│   ├─ Ler o prompt da fase atual                                 │
│   ├─ Identificar dependências                                   │
│   └─ Definir escopo específico                                  │
│                                                                 │
│   2. IMPLEMENTAR                                                │
│   ├─ Pedir código ao agente                                     │
│   ├─ Revisar output                                             │
│   └─ Solicitar ajustes se necessário                            │
│                                                                 │
│   3. TESTAR                                                     │
│   ├─ Rodar localmente                                           │
│   ├─ Verificar funcionalidade                                   │
│   └─ Identificar bugs                                           │
│                                                                 │
│   4. REFINAR                                                    │
│   ├─ Reportar bugs ao agente                                    │
│   ├─ Pedir correções específicas                                │
│   └─ Validar novamente                                          │
│                                                                 │
│   5. DOCUMENTAR                                                 │
│   ├─ Pedir comentários no código                                │
│   ├─ Atualizar README se necessário                             │
│   └─ Marcar checkpoint como completo                            │
│                                                                 │
│   [Repetir para próxima tarefa]                                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Estratégia para Debug

```
1. Descreva o erro de forma clara:
   "Ao clicar no botão 'Nova Simulação', aparece erro:
   TypeError: Cannot read property 'id' of undefined
   na linha 45 do simulation-service.ts"

2. Forneça contexto:
   - Stack trace completo
   - Dados de entrada
   - Comportamento esperado vs atual

3. Peça diagnóstico antes de correção:
   "Antes de corrigir, explique por que esse erro 
   está ocorrendo e quais são as possíveis causas."
```

---

## 📋 Templates de Prompts

### Template: Criar Novo Componente

```markdown
## Tarefa
Criar componente [NOME_COMPONENTE]

## Contexto
- Localização: src/components/[pasta]/[arquivo].tsx
- Parte da tela: [TELA]
- Propósito: [DESCRIÇÃO]

## Props
- prop1: tipo - descrição
- prop2: tipo - descrição

## Comportamento
- Estado inicial: [descrição]
- Interações: [lista de interações]
- Casos especiais: [edge cases]

## Design
- Seguir Figma seção [X]
- Cores: [lista]
- Responsividade: [requisitos]

## Exemplo de Uso
\`\`\`tsx
<NomeComponente prop1={valor} prop2={valor} />
\`\`\`
```

### Template: Criar Endpoint API

```markdown
## Tarefa
Criar endpoint [MÉTODO] [ROTA]

## Contexto
- Controller: [nome]-controller.ts
- Service: [nome]-service.ts
- Repository: [nome]-repository.ts

## Especificação
- Método: GET/POST/PUT/DELETE
- Rota: /path/:param
- Body (se aplicável): { campo: tipo }
- Query (se aplicável): { campo: tipo }
- Response: { campo: tipo }

## Regras de Negócio
1. [Regra 1]
2. [Regra 2]

## Erros Possíveis
- 400: Validação falhou
- 404: Recurso não encontrado
- 409: Conflito (ex: nome duplicado)

## Testes
- Cenário sucesso
- Cenário erro validação
- Cenário não encontrado
```

### Template: Corrigir Bug

```markdown
## Problema
[Descrição clara do bug]

## Reprodução
1. Passo 1
2. Passo 2
3. Erro aparece

## Erro
\`\`\`
[Stack trace ou mensagem de erro]
\`\`\`

## Código Atual
\`\`\`typescript
[Código relevante]
\`\`\`

## Comportamento Esperado
[O que deveria acontecer]

## Comportamento Atual
[O que está acontecendo]

## Tentativas de Solução
- [O que já tentei]
```

### Template: Refatoração

```markdown
## Tarefa
Refatorar [ARQUIVO/MÓDULO]

## Problema Atual
- [Issue 1: código duplicado em X e Y]
- [Issue 2: função muito longa]
- [Issue 3: acoplamento alto]

## Objetivo
- [Objetivo 1: extrair lógica comum]
- [Objetivo 2: dividir em funções menores]
- [Objetivo 3: aplicar dependency injection]

## Código Atual
\`\`\`typescript
[Código a refatorar]
\`\`\`

## Princípios a Aplicar
- SOLID: [quais]
- DRY: [onde]
- KISS: [onde]

## Constraints
- Manter API pública igual
- Não quebrar testes existentes
- Manter compatibilidade com X
```

---

## 🔧 Troubleshooting

### Problema: Agente gera código incompatível

**Solução:** Forneça mais contexto
```
O código gerado usa biblioteca X, mas o projeto usa Y.
Por favor, reescreva usando [biblioteca Y] versão [versão].
Aqui está a documentação relevante: [link]
```

### Problema: Código gerado muito longo/complexo

**Solução:** Peça simplificação
```
O código ficou muito complexo. Por favor:
1. Divida em funções menores
2. Extraia lógica para helpers
3. Use nomes mais descritivos
4. Adicione comentários explicativos
```

### Problema: Agente "esquece" contexto

**Solução:** Resuma o contexto novamente
```
Recapitulando nosso progresso:
- Criamos: [lista de arquivos]
- Estrutura atual: [descreva]
- Próxima tarefa: [tarefa]

Aqui está o código atual relevante:
\`\`\`
[código]
\`\`\`
```

### Problema: Erro de tipagem TypeScript

**Solução:** Forneça os tipos esperados
```
Há erro de tipagem no código:
\`\`\`
[erro do TypeScript]
\`\`\`

Aqui estão os tipos corretos que devem ser usados:
\`\`\`typescript
[definições de tipo]
\`\`\`

Por favor, corrija o código para usar esses tipos.
```

### Problema: Teste falhando

**Solução:** Forneça detalhes completos
```
O teste "[nome do teste]" está falhando.

Saída do teste:
\`\`\`
[output do vitest/jest]
\`\`\`

Código do teste:
\`\`\`typescript
[código do teste]
\`\`\`

Código sendo testado:
\`\`\`typescript
[código da implementação]
\`\`\`

O teste está correto? Ou a implementação?
```

---

## 🎯 Dicas Finais

### 1. Mantenha um Log de Decisões

Crie um arquivo `DECISIONS.md` documentando:
- Decisões arquiteturais
- Trade-offs feitos
- Simplificações escolhidas
- Links úteis consultados

### 2. Valide Incrementalmente

Não espere completar uma fase inteira para testar. A cada arquivo gerado:
1. Verifique se compila
2. Rode os testes existentes
3. Teste manualmente se aplicável

### 3. Use Checkpoints

Após completar cada sub-tarefa:
- Faça commit no git
- Anote o que foi feito
- Identifique próximos passos

### 4. Peça Revisão de Código

```
Revise o código a seguir considerando:
- Segurança
- Performance
- Manutenibilidade
- Aderência aos padrões do projeto

[código]
```

### 5. Documente Enquanto Desenvolve

Peça ao agente para gerar comentários:
```
Adicione JSDoc comments às funções públicas
explicando parâmetros, retorno e exemplos de uso.
```

---

## 📚 Recursos Adicionais

- [Prompt Engineering Guide](https://www.promptingguide.ai/)
- [Fastify Documentation](https://www.fastify.io/docs/latest/)
- [Next.js Documentation](https://nextjs.org/docs)
- [shadcn/ui](https://ui.shadcn.com/)
- [React Query](https://tanstack.com/query/latest)
- [Drizzle ORM](https://orm.drizzle.team/)
- [Zod](https://zod.dev/)
