# ADR 0002 — Gerenciamento de estado: Provider (ChangeNotifier)

## Status
Aceito

## Contexto
O app tem um único estado central: a lista de itens da comparação (`Comparação`, ver
`01-domain-model.md`). Não há navegação complexa entre telas, nem múltiplos estados
independentes competindo. É essencialmente um formulário reativo com uma tela.

## Alternativas consideradas
- **setState puro**: simples, mas mistura lógica de negócio (cálculo de RN01–RN09) com o
  widget da tela, dificultando testar as regras isoladamente — ruim para quem quer boa
  cobertura de teste unitário
- **Riverpod / Bloc**: poder de sobra para a complexidade real do app; adicionam boilerplate
  e curva de aprendizado sem ganho concreto aqui
- **Provider (ChangeNotifier)**: nível de abstração intermediário — permite isolar a lógica de
  domínio (`ComparacaoModel extends ChangeNotifier`) dos widgets, testável sem UI, sem o
  overhead do Riverpod/Bloc

## Decisão
Usar **Provider com ChangeNotifier**.
- `ComparacaoModel` (ChangeNotifier) implementa as regras RN01–RN09 e expõe a lista de itens
- Os widgets consomem via `Consumer`/`context.watch`, sem lógica de negócio no widget
- Isso também facilita os testes unitários das regras de negócio, descritos em
  `02-features/*.md`, sem precisar montar widgets

## Consequências
- Fácil de testar a lógica de domínio isoladamente
- Se o app crescer muito em complexidade de estado no futuro, pode exigir migração para
  Riverpod/Bloc — aceitável, dado o tamanho atual do projeto
