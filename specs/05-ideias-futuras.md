# Ideias Futuras (backlog, não planejado)

Este arquivo guarda ideias discutidas para versões futuras do app, **fora do MVP** e sem
compromisso de quando (ou se) serão implementadas. Diferente das outras specs, nada aqui é
fonte da verdade pra implementação — antes de qualquer uma virar trabalho real, precisa virar
uma spec de verdade (`02-features/*.md`) com critérios de aceite, RNxx no domain model, etc.

## Conversão de unidade

**Problema**: hoje o app assume que todos os itens de uma comparação estão na mesma unidade
(g com g, ml com ml). Se o usuário digitar um item em gramas e outro em quilos sem perceber,
o app calcula e destaca a "melhor opção" normalmente — mas o resultado está errado, sem nenhum
aviso. É um risco de dar a resposta errada exatamente na função central do app.

**Direção proposta**: em vez de um campo de texto livre com dica ("em g, ml, kg, litros..."),
ter um seletor de unidade por item (g/kg, ml/L, unidade) com conversão automática pra uma base
comum antes de calcular `valorPorUnidade`. Levantaria perguntas a decidir quando for
especificado: o que fazer se o usuário tentar comparar categorias incompatíveis entre si
(ex: peso vs volume)? bloquear, avisar, ou permitir mesmo assim?

## Compartilhar resultado da comparação

Já listado como fora de escopo em `00-overview.md`, detalhando aqui a ideia: permitir exportar
o resultado da comparação (como imagem ou texto) pra compartilhar via apps de mensagem etc.
Baixo esforço de implementação relativo ao valor (potencial de aquisição orgânica de usuários),
mas ainda sem desenho de UX definido (o que exatamente aparece no compartilhamento? só o item
"melhor", ou a lista inteira?).

## Preencher quantidade via leitura de código de barras

Já listado como fora de escopo em `00-overview.md` ("leitura de preço via código de
barras/OCR"), detalhando aqui a ideia depois de avaliar a viabilidade (discutido em
2026-08-10): usar a câmera pra ler o código de barras do produto e preencher o campo
"Quantidade" automaticamente, usando a API gratuita e aberta do
[Open Food Facts](https://world.openfoodfacts.org/) (sem chave de autenticação pra leitura).

**Importante — o que essa integração resolve e o que não resolve**:
- ✅ Resolve: preencher a quantidade/tamanho da embalagem (g/ml/kg/L) automaticamente, evitando
  o usuário ter que procurar e digitar essa informação do rótulo
- ❌ Não resolve: o **preço** continua sendo digitado manualmente — nenhuma API global sabe o
  preço praticado numa loja específica num dia específico

**Cobertura por região** (relevante pro público-alvo do app, Brasil e Portugal): a base é
colaborativa/crowdsourced, então a cobertura varia — boa pra marcas grandes/multinacionais nos
dois países, mas fraca pra produtos regionais/locais (Brasil por ser mercado grande e
fragmentado; Portugal por ser mercado pequeno, ainda que se beneficie de produtos
pan-europeus já cadastrados por outros países da UE). Consequência de design: a busca por
código de barras precisa ser tratada como um *assist* opcional com fallback gracioso pro
preenchimento manual quando o código não for encontrado — nunca uma dependência obrigatória.

**Direção técnica proposta**: pacote `mobile_scanner` (ou similar) pra leitura de código de
barras via câmera no Flutter, chamando a API REST do Open Food Facts (retorna JSON) pra
resolver o código pro tamanho da embalagem.
