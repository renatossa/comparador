# Comparador de Preços

App mobile (Flutter) que ajuda a decidir qual produto compensa mais, comparando o preço por
unidade entre vários itens. Reescrita moderna do app original (Cordova/AngularJS).

## Desenvolvimento guiado por especificação (SDD)

Este projeto segue **Spec-Driven Development**: toda funcionalidade nasce de uma spec em
[`specs/`](./specs), e decisões de arquitetura ficam registradas em [`adr/`](./adr) como
Architecture Decision Records.

- [`specs/00-overview.md`](./specs/00-overview.md) — visão geral e escopo
- [`specs/01-domain-model.md`](./specs/01-domain-model.md) — entidades e regras de negócio
- [`specs/02-features/`](./specs/02-features) — specs de cada funcionalidade com critérios de aceite
- [`specs/03-non-functional.md`](./specs/03-non-functional.md) — requisitos não-funcionais
- [`specs/04-migration-plan.md`](./specs/04-migration-plan.md) — fases do projeto
- [`specs/05-ideias-futuras.md`](./specs/05-ideias-futuras.md) — backlog de ideias futuras
- [`adr/`](./adr) — decisões de arquitetura

## Stack
Flutter (ver [`adr/0001-escolha-stack.md`](./adr/0001-escolha-stack.md) para a justificativa)

## Status
🚧 Fase 4 (Publicação) em andamento — Android em teste fechado no Google Play, aguardando
requisito de 12 testadores por 14 dias pra liberar acesso à produção. iOS ainda pendente
(depende de Mac). Ver `04-migration-plan.md` pro detalhe de cada fase.
