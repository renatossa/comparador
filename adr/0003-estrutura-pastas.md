# ADR 0003 — Estrutura de pastas do projeto Flutter

## Status
Aceito

## Contexto
O app tem uma única tela (comparação) e um único modelo de estado central (`ComparacaoModel`,
ver ADR 0002). Não há múltiplas features nem navegação complexa. A estrutura de pastas precisa
sobretudo suportar a regra já definida no `CLAUDE.md`: lógica de negócio (RNxx) isolada da UI,
testável sem montar widgets.

## Alternativas consideradas
- **Feature-first** (uma pasta por funcionalidade, ex: `lib/comparacao/{model,screen,widgets}`):
  organiza bem quando há várias features, mas aqui só existe uma — criaria uma pasta única
  segurando tudo, sem ganho real de organização
- **Clean Architecture** (camadas `data/domain/presentation` com casos de uso, repositórios,
  etc.): poder de sobra para um formulário com cálculo e destaque de cor; adicionaria
  boilerplate sem necessidade real de desacoplamento (não há fonte de dados externa além do
  storage local)
- **Layer-first** (uma pasta por tipo: `models/`, `screens/`, `widgets/`, `services/`):
  simples, direto, e já é suficiente para isolar lógica de domínio da UI conforme exigido

## Decisão
Usar **layer-first**, com a seguinte estrutura em `lib/`:

```
lib/
  main.dart
  models/
    item.dart              # entidade Item (RN01, RN02)
    comparacao_model.dart   # ComparacaoModel extends ChangeNotifier (RN01–RN10)
  screens/
    comparacao_screen.dart  # tela única do MVP
  widgets/
    item_card.dart          # widget de item da lista (input + destaque melhor/pior)
  services/
    storage_service.dart    # persistência local (RN08)

test/
  models/
    comparacao_model_test.dart  # testes unitários das regras RN01–RN10
  widgets/
    item_card_test.dart         # testes de widget
  screens/
    comparacao_screen_test.dart # testes de integração dos cenários de 02-features/*.md
```

- `models/` não importa nada de `screens/` ou `widgets/` — mantém a lógica de negócio testável
  isoladamente, sem montar árvore de widgets
- `services/` isola a implementação de persistência (shared_preferences ou Hive, decisão
  técnica ainda em aberto — ver `03-non-functional.md`) atrás de uma interface simples, para
  poder trocar a implementação sem tocar em `models/`
- Cada arquivo de teste espelha o arquivo correspondente em `lib/`

## Consequências
- Estrutura simples de navegar para um app deste tamanho
- Se o app crescer para múltiplas telas/features no futuro, uma reorganização para
  feature-first pode ser necessária — aceitável, dado o escopo atual do MVP
