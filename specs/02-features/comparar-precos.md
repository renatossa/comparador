# Feature: Comparar preço por unidade

## Contexto
O usuário está no mercado, com dois ou mais produtos parecidos em embalagens diferentes, e
quer saber qual compensa mais pelo preço.

## Comportamento esperado
1. Tela abre com 3 campos de comparação vazios (quantidade + preço)
2. Ao preencher quantidade e preço de um item, o app calcula e exibe o valor por unidade
3. Conforme mais itens são preenchidos, o app destaca visualmente:
   - a melhor opção (menor valor por unidade)
   - a(s) pior(es) opção(ões)
4. Usuário pode adicionar mais itens à comparação
5. Usuário pode limpar tudo e recomeçar
6. Ao reabrir o app, os itens da última sessão continuam preenchidos

## Critérios de aceite

```
Cenário: Comparar dois itens simples
  Dado que a tela de comparação está aberta
  Quando eu preencho o item 1 com quantidade=500 e preço=10
  E preencho o item 2 com quantidade=1000 e preço=18
  Então o valor por unidade do item 1 deve ser 0.02
  E o valor por unidade do item 2 deve ser 0.018
  E o item 2 deve estar destacado como "melhor opção"
  E o item 1 deve estar destacado como "pior opção"

Cenário: Item com dados incompletos não é comparado
  Dado que a tela de comparação está aberta
  Quando eu preencho apenas a quantidade do item 1, sem preço
  Então o item 1 não deve exibir nenhum destaque de cor
  E o item 1 não deve exibir valor por unidade

Cenário: Adicionar item à comparação
  Dado que existem 3 itens na tela
  Quando eu toco em "adicionar"
  Então um 4º item vazio deve aparecer na lista

Cenário: Limpar comparação
  Dado que existem itens preenchidos
  Quando eu toco em "limpar"
  Então a lista deve voltar a ter 3 itens vazios
  E o storage local deve refletir o estado limpo

Cenário: Persistência entre sessões
  Dado que preenchi itens e fechei o app
  Quando eu reabro o app
  Então os itens preenchidos anteriormente devem estar carregados

Cenário: Empate entre dois itens
  Dado que dois itens têm exatamente o mesmo valor por unidade
  E são os menores valores da lista
  Então ambos devem ser destacados como "melhor opção"
  [DECISÃO PENDENTE: confirmar se este é o comportamento desejado — o app legado
  tecnicamente permite múltiplos "melhores" simultâneos por como itera a lista]
```

## Edge cases a cobrir em testes
- Quantidade ou preço negativo (app legado não trata — decidir se a reescrita deve validar)
- Apenas 1 item preenchido (não há "pior" nem "melhor" a exibir, ou exibe neutro)
- Todos os itens com o mesmo valor por unidade
- Valores decimais com muitas casas (o legado usava máscara de 4 casas)
