# Feature: Remover item individual (NOVA — não existia no app legado)

## Contexto
No app original, a única forma de "limpar" era resetar a comparação inteira para 3 itens
vazios. Na reescrita, o usuário poderá remover um item específico sem perder os demais.

## Comportamento esperado
1. Cada item da lista exibe uma ação de remover (ex: ícone de lixeira / swipe-to-delete —
   decisão de UI a definir na Fase 3)
2. Ao remover um item, a lista de comparação é recalculada (destaques de melhor/pior
   recomputados conforme RN03/RN04, já que a remoção pode mudar qual item é o melhor)
3. Não há mínimo de itens obrigatório após remoção (pode chegar a 0 ou 1 item — nesse caso
   não há destaque de melhor/pior, ver edge cases)

## Critérios de aceite

```
Cenário: Remover item do meio da lista
  Dado que existem 4 itens preenchidos na comparação
  Quando eu removo o item 2
  Então a lista deve ficar com 3 itens
  E os destaques de melhor/pior devem ser recalculados sobre os itens restantes

Cenário: Remover o item que era a melhor opção
  Dado que o item 1 está destacado como "melhor opção"
  Quando eu removo o item 1
  Então o novo menor valor por unidade entre os itens restantes deve ser destacado como melhor

Cenário: Remover até restar 1 item
  Dado que existem 2 itens na comparação
  Quando eu removo 1 deles
  Então deve restar 1 item sem nenhum destaque de cor (não há o que comparar)

Cenário: Remoção persiste
  Dado que removi um item
  Quando eu fecho e reabro o app
  Então o item removido não deve reaparecer
```

## Edge cases
- Remover o único item restante → lista fica vazia, exibir estado apropriado (não deve quebrar)
- Remoção rápida de vários itens em sequência → recálculo deve ser consistente, sem estado
  intermediário incorreto sendo exibido

## Regra de negócio relacionada
RN09 (`01-domain-model.md`)
