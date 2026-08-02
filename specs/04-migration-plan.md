# Plano de Migração

Estratégia: **rewrite completo**, guiado pelas specs (não há necessidade de rodar os dois
apps em paralelo — é uma reescrita, não uma migração incremental de sistema em produção).

## Fase 0 — Specs (atual)
- [x] Extrair comportamento do legado
- [ ] Validar `01-domain-model.md` e `02-features/comparar-precos.md` com você
- [ ] Resolver as "decisões pendentes" marcadas nas specs (empate, item inválido, remoção de item)

## Fase 1 — Setup do projeto
- Scaffold do projeto Flutter
- Configuração de lint, testes, CI básico
- Estrutura de pastas (a definir em ADR técnico)

## Fase 2 — Implementação do MVP
- Modelo de domínio (Item, Comparação) com testes unitários das regras RN01–RN08
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
