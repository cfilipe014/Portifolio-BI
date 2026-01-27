
# Plano: Corrigir Tela Preta no Preview

## Problema Identificado

A tela está preta porque a lógica anti-flash tem uma falha:

1. O `index.html` adiciona a classe `theme-pending` quando não há tema no localStorage
2. Esta classe aplica `visibility: hidden` ao body, escondendo todo conteúdo
3. O hook `useTheme` deveria remover essa classe, mas o `useEffect` só dispara quando `settings` muda
4. Se a query do backend demorar ou falhar, o conteúdo fica escondido indefinidamente

## Solucao

Modificar a logica para ser mais robusta e garantir que o conteudo sempre apareca:

### 1. Modificar `src/hooks/useTheme.tsx`

Adicionar logica para:
- Remover `theme-pending` imediatamente na primeira renderizacao
- Usar `localStorage` como fallback enquanto espera o backend
- Adicionar tratamento de erro para garantir que o site sempre carrega

```text
Mudancas:
- Adicionar estado para controlar se ja removeu theme-pending
- Usar useEffect que roda imediatamente para revelar conteudo
- Manter a logica de sincronizacao com backend separada
```

### 2. Modificar `index.html`

Simplificar a logica para:
- Aplicar o tema imediatamente se disponivel no localStorage
- Nao esconder o conteudo se ja temos um tema cached
- Fallback para tema dark (que ja e o padrao do CSS)

```text
Mudancas:
- Remover a logica de theme-pending que causa o problema
- Apenas aplicar classe light se localStorage tiver light
- Deixar o site carregar normalmente com tema dark como fallback
```

## Detalhes Tecnicos

O fluxo corrigido sera:

```text
1. HTML carrega
2. Script inline verifica localStorage
3. Se tem 'light' -> aplica classe .light
4. Se nao tem -> usa dark (padrao do CSS, sem esconder nada)
5. React monta e hook useTheme busca tema do backend
6. Se backend retornar diferente -> atualiza e salva no localStorage
7. Proxima visita usa localStorage instantaneamente
```

Isso elimina completamente o risco de tela preta porque:
- Nunca escondemos o conteudo
- Sempre temos um fallback visual funcionando (dark)
- Backend apenas sincroniza, nao bloqueia

## Arquivos a Modificar

| Arquivo | Mudanca |
|---------|---------|
| `index.html` | Remover logica de theme-pending, simplificar para apenas aplicar light se cached |
| `src/hooks/useTheme.tsx` | Remover dependencia de theme-pending, aplicar tema imediatamente |
