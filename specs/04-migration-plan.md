# Plano de Migração

Estratégia: **rewrite completo**, guiado pelas specs (não há necessidade de rodar os dois
apps em paralelo — é uma reescrita, não uma migração incremental de sistema em produção).

## Fase 0 — Specs
- [x] Extrair comportamento do legado
- [x] Validar `01-domain-model.md` e `02-features/comparar-precos.md` com você
- [x] Repo `comparador` criado no GitHub com specs, ADRs e README
- [x] `CLAUDE.md` criado com workflow de SDD para o Claude Code seguir
- [x] RN06 (adicionar itens sem limite) — confirmado
- [x] RN09 (remover item individual) — aprovado como feature nova, spec criada
- [x] ADR 0001 (stack: Flutter) — aceito
- [x] ADR 0002 (state management: Provider/ChangeNotifier) — aceito
- [x] RN04 (empate entre melhores) — confirmado: múltiplos itens podem ser destacados como
      "melhor" simultaneamente
- [x] RN10 (validação de valores negativos) — confirmado: reescrita valida e impede negativos

## Fase 1 — Setup do projeto
- [x] ADR 0003 (estrutura de pastas: layer-first) — aceito
- [ ] Instalar Flutter SDK
- [ ] Scaffold do projeto Flutter
- [ ] Configuração de lint, testes, CI básico

## Fase 2 — Implementação do MVP
- Modelo de domínio (Item, Comparação) com testes unitários das regras RN01–RN10
- Tela de comparação (UI nova)
- Persistência local
- Testes de widget/integração cobrindo os cenários de `02-features/comparar-precos.md`

## Fase 3 — Polimento
- Ícone, splash, identidade visual
- Revisão de acessibilidade
- Testes em dispositivos reais Android e iOS

## Fase 4 — Publicação
- Build de release Android (Play Store) + iOS (App Store)
- Ficha da loja (descrição, screenshots, política de privacidade se necessário)

## Rastreabilidade
Cada PR de implementação deve referenciar a spec (`02-features/*.md`) e as regras de negócio
(`RNxx`) que está implementando.
