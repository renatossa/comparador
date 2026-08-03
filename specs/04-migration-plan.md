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
- [x] Identidade visual em código: paleta com semente azul do ícone legado (`#218ABC`,
      `lib/app_theme.dart`), marca (check) na AppBar, cards com banho de cor (azul/verde/
      vermelho) em vez de destaque só no selo — validado com você em screenshots do emulador
- [x] Ícone do app e splash screen — reaproveitados de
      `comparador-old/platforms/wp8/ApplicationIcon.png` (o ícone original do app legado,
      encontrado no repo antigo local), separados em ícone flat (iOS) + glifo transparente
      (Android adaptive icon + splash) via `flutter_launcher_icons`/`flutter_native_splash`,
      assets em `assets/icon/`. Validado no emulador (launcher e splash com a cara do app antigo)
- [ ] Revisão de acessibilidade (além do ícone+texto já feito no destaque melhor/pior)
- [ ] Testes em dispositivo Android real — você não tem device físico; plano: gerar um `.apk`
      de release e compartilhar direto com um amigo pra instalar (não depende da conta do Play
      Console). Quando a conta for aprovada, dá pra migrar pra track de teste interno
- [ ] Testes em dispositivo iOS real — **depende de Mac**, que você não tem. Alternativas sem
      possuir um Mac fisicamente: alugar Mac na nuvem (ex: MacinCloud), ou usar CI com runner
      macOS (ex: Codemagic, feito pra Flutter, plano grátis generoso) pra compilar/assinar/subir
      pro TestFlight — ainda exige conta Apple Developer (US$ 99/ano)

## Fase 4 — Publicação
- [x] Decidido (2026-08-03): não tentar recuperar a conta antiga "5club" (perfil e apps
      removidos em 2024-11-08 por verificação pendente; a conta também dependia de um colega
      como admin). Em vez disso, registrar uma **conta de desenvolvedor Google Play nova e
      independente**, tipo "Pessoal" (não "Organização" — evita a burocracia de D-U-N-S),
      taxa única de US$ 25 + verificação de identidade própria. Fica dono único, sem depender
      de mais ninguém
- [ ] Registrar a conta nova em play.google.com/console/signup e completar verificação — taxa
      paga e documentos enviados em 2026-08-03, **aguardando resposta do Google** (verificação
      de identidade costuma levar de horas a poucos dias)
- [ ] Build de release Android (Play Store) + iOS (App Store)
- [ ] App ID/bundle ID próprio (ver aviso em `03-non-functional.md` — não usar o antigo, que
      está sob conta de amigo)
- [ ] Ficha da loja (descrição — reaproveitar/adaptar `textos/descricao.txt` do legado, ver nota
      em `00-overview.md` —, screenshots, política de privacidade se necessário)

## Rastreabilidade
Cada PR de implementação deve referenciar a spec (`02-features/*.md`) e as regras de negócio
(`RNxx`) que está implementando.
