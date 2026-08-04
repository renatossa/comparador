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
