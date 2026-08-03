# Comparador — Visão Geral (SDD)

## O que é
App mobile que ajuda o usuário a decidir qual produto compensa mais na hora da compra,
comparando o **preço por unidade** (ex: R$/g, R$/ml, R$/unidade) entre vários itens.

## Origem
Reescrita do app "Comparador" (`com.rodenapps.comparador`), originalmente feito em Cordova +
AngularJS + jQuery Mobile, com build documentado para WP8. O comportamento funcional desta
spec foi extraído por engenharia reversa do código legado (repo `comparador-old`).

> Encontrado em 2026-08-03: o zip `5club-comparador_app-*.zip` (`~/Downloads`) tem o código-fonte
> completo do app legado (`www/src/exato.js` — controller AngularJS com a lógica de negócio
> original, `www/index.html`, artwork do ícone em alta resolução) — fonte mais completa que o
> repo `comparador-old` (que só tinha os artefatos buildados do WP8). Consultar esse zip antes
> de assumir comportamento do legado por inferência/screenshot quando surgir dúvida.

## Objetivo da reescrita
Reescrever do zero, mantendo o comportamento e a proposta de valor do app original,
com stack moderna, UI atualizada e publicação nas lojas Android (Google Play) e iOS (App Store).

## Stack escolhida
**Flutter** — ver justificativa em `adr/0001-escolha-stack.md`.

## Escopo desta primeira versão (MVP)
- Comparar preço por unidade entre múltiplos itens
- Destacar visualmente a melhor e as piores opções
- Persistir os itens localmente entre sessões
- Adicionar/remover itens da comparação
- Publicável nas duas lojas

## Fora de escopo (por ora)
- Contas de usuário / sincronização em nuvem
- Histórico de comparações passadas
- Compartilhamento de comparação
- Leitura de preço via código de barras/OCR

## Como usar esta pasta de specs
1. `01-domain-model.md` — entidades e regras de negócio
2. `02-features/` — uma spec por funcionalidade, com critérios de aceite testáveis
3. `03-non-functional.md` — performance, offline, compatibilidade
4. `04-migration-plan.md` — fases de execução
5. `../adr/` — decisões de arquitetura e por quê foram tomadas

Toda implementação nova deve referenciar a spec correspondente no PR.
