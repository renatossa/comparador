# ADR 0004 — Persistência local: shared_preferences

## Status
Aceito

## Contexto
RN08 exige persistir os itens da comparação localmente entre sessões (substitui o cookie do
app legado). O modelo de dados é simples: uma lista de `Item`, cada um com dois campos
numéricos opcionais (`quantidade`, `preco`). Não há relacionamentos, buscas complexas, nem
necessidade de índices — apenas salvar e recarregar uma lista pequena a cada mudança.
`03-non-functional.md` já sugeria essas duas alternativas, deixando a escolha final para
quando o time técnico avaliasse.

## Alternativas consideradas
- **Hive**: banco NoSQL embutido, mais rápido para volumes grandes e modelos que crescem,
  mas exige gerar adapters/type IDs e adiciona uma dependência mais pesada para um caso de uso
  que é, na prática, uma lista de poucos números
- **shared_preferences**: armazenamento chave-valor simples; para persistir uma lista de itens
  basta serializar para JSON (`jsonEncode`/`jsonDecode`) e salvar como uma única string.
  Suficiente para o volume e a complexidade atuais do modelo

## Decisão
Usar **shared_preferences**, salvando a lista de itens serializada como JSON sob uma única
chave (ex: `comparacao_itens`).
- `StorageService` (em `lib/services/`) isola a leitura/escrita, conforme ADR 0003 — o
  `ComparacaoModel` não conhece o mecanismo de persistência, só chama `salvar()`/`carregar()`
- Salvar após toda mutação relevante (RN06, RN07, RN09, alteração de quantidade/preço);
  carregar uma vez ao iniciar o app

## Consequências
- Implementação simples, sem boilerplate de adapters
- Se o modelo de domínio crescer significativamente (novas entidades, relações, histórico —
  hoje fora de escopo), pode exigir migração para Hive ou outra solução; aceitável dado o
  escopo atual do MVP
