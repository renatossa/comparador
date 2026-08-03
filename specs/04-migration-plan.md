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
- [x] Instalar Flutter SDK (via snap, `flutter doctor` ok)
- [x] Instalar Android SDK/Android Studio + emulador (Pixel_Comparador, API 36.1) —
      `flutter doctor` sem problemas
- [x] Scaffold do projeto Flutter (estrutura `lib/{models,screens}` conforme ADR 0003,
      `provider` adicionado conforme ADR 0002)
- [x] Configuração de lint (flutter_lints, já no template) e CI básico (GitHub Actions:
      `flutter analyze` + `flutter test`)

## Fase 2 — Implementação do MVP
- [x] ADR 0004 (persistência: shared_preferences) — aceito
- [x] Modelo de domínio (`Item`, `ComparacaoModel`) com testes unitários das regras RN01–RN10
      (`test/models/`)
- [x] Tela de comparação (`ComparacaoScreen` + `ItemCard`), com destaque melhor/pior reforçado
      por ícone/texto (acessibilidade) e suporte a tema claro/escuro
- [x] Persistência local (`StorageService`, RN08) — carrega ao abrir o app, salva a cada mutação
- [x] Testes de widget/integração cobrindo os cenários de `02-features/comparar-precos.md` e
      `02-features/remover-item.md` (`test/screens/`, `test/services/`)
- [x] Verificação manual no emulador Android — validado alinhamento dos campos, separador
      decimal (`,`/`.`), seletor de moeda (R$/€/$) e teclado físico funcionando
- [x] Seletor manual de moeda (R$ padrão, € em seguida) — substituiu a ideia inicial de inferir
      a moeda pelo locale do idioma (não confiável: idioma≠país, ver `03-non-functional.md`)

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
