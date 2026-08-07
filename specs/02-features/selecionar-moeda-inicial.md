# Feature: Seleção de moeda no primeiro uso

## Contexto
Hoje a moeda de referência (R$/€/US$) usada para exibir os valores começa sempre como "Real"
por padrão (ver `03-non-functional.md`), e o usuário só descobre que dá pra trocar se notar o
seletor na AppBar. Isso pode confundir quem abre o app pela primeira vez fora do Brasil — não
vê o símbolo que espera, e pode nem perceber que dá pra mudar.

## Comportamento esperado
1. Na primeiríssima abertura do app (quando não há moeda salva localmente), antes de mostrar a
   tela de comparação, o app pergunta explicitamente qual moeda o usuário quer usar como
   referência (mesmas opções já existentes: R$, €, US$, nessa ordem)
2. Assim que o usuário escolhe, a escolha é salva localmente (reaproveita o mecanismo já
   existente de persistência de moeda — RN08/`StorageService`) e a tela de comparação é exibida
   normalmente, usando essa moeda
3. Em qualquer abertura seguinte, se já existe uma moeda salva, o app **não pergunta de novo** —
   vai direto pra tela de comparação com a moeda salva
4. O seletor de moeda que já existe na AppBar continua funcionando normalmente pra trocar de
   moeda a qualquer momento depois — essa pergunta inicial não o substitui, só cobre o primeiro
   uso

## Critérios de aceite

```
Cenário: Primeira abertura do app
  Dado que o app nunca foi aberto antes neste dispositivo (nenhuma moeda salva)
  Quando o usuário abre o app
  Então o app pergunta qual moeda de referência usar, antes de mostrar a tela de comparação

Cenário: Escolher moeda na primeira abertura
  Dado que o app está exibindo a pergunta de moeda inicial
  Quando o usuário escolhe "Euro"
  Então a moeda escolhida é salva localmente
  E a tela de comparação é exibida usando "Euro" como moeda

Cenário: Abrir o app depois de já ter escolhido uma moeda
  Dado que o usuário já escolheu uma moeda numa sessão anterior
  Quando o usuário abre o app novamente
  Então o app não pergunta a moeda de novo
  E vai direto para a tela de comparação, usando a moeda salva

Cenário: Trocar de moeda depois, via seletor existente
  Dado que o usuário já passou pela pergunta inicial
  Quando o usuário usa o seletor de moeda na AppBar
  Então a moeda muda normalmente, como já acontece hoje (sem afetar a lógica de "já escolheu
  na primeira abertura")
```

## Edge cases
- Usuário fecha/mata o app no meio da pergunta inicial, sem escolher nada → nenhuma moeda foi
  salva, então a pergunta aparece de novo na próxima abertura (comportamento correto por
  consequência do mecanismo de persistência, não precisa de tratamento especial)
- ✅ Decidido (2026-08-04): não existe forma de pular/fechar a pergunta sem escolher. O usuário
  é obrigado a tocar numa das 3 opções (R$/€/US$) pra prosseguir — sem botão de "agora não",
  sem fechar tocando fora do diálogo

## Regra de negócio relacionada
RN11 (`01-domain-model.md`)
