# Domain Model

## Entidade: Item de Comparação

| Campo         | Tipo    | Descrição                                              |
|---------------|---------|---------------------------------------------------------|
| quantidade    | number  | Quantidade/tamanho do produto (g, ml, unidades...)       |
| preco         | number  | Preço total pago pelo produto                            |
| valorPorUnidade | number (derivado) | `preco / quantidade`                        |
| status        | enum    | `neutro` \| `melhor` \| `pior` (derivado, ver regras)     |

> No app legado esses campos se chamavam `unidade` (quantidade), `undValor` (preço) e
> `resultado` (valor por unidade) — nomes mantidos aqui apenas como referência de mapeamento.

## Entidade: Comparação

| Campo  | Tipo         | Descrição                                    |
|--------|--------------|------------------------------------------------|
| itens  | List<Item>   | Lista de itens sendo comparados (mín. 3 ao iniciar) |

## Regras de negócio (extraídas do comportamento legado)

**RN01 — Cálculo do valor por unidade**
`valorPorUnidade = preco / quantidade`

**RN02 — Item inválido**
Um item é considerado inválido (não entra na comparação visual) quando `quantidade == 0`,
`preco == 0`, ou o resultado é `NaN`. Item inválido não recebe destaque de cor.

**RN03 — Melhor opção**
Entre os itens válidos, o(s) item(ns) com o **menor** `valorPorUnidade` recebem destaque
"melhor" (verde no app legado).

**RN04 — Pior(es) opção(ões)**
Qualquer item válido cujo `valorPorUnidade` seja maior que o de pelo menos um outro item
válido recebe destaque "pior" (vermelho no app legado).
> Nota de comportamento herdado: no código original, um item nunca é comparado com ele mesmo
> de forma explícita, e o destaque é recalculado a cada alteração de qualquer item da lista —
> isso deve ser preservado (recomputar a lista inteira a cada mudança, não só o item editado).

> **Divergência intencional do legado (confirmada em 2026-08-03):** encontramos o JS original
> do app legado (`www/src/exato.js`, função `ehMenor`, no zip `5club-comparador_app-*.zip`) e
> nele, com **apenas 1 item válido** na lista, esse item é destacado como "melhor" (verde) —
> a função assume verde por padrão e só pinta de vermelho se achar outro item com valor menor,
> sem checar se há itens suficientes para comparar. Na reescrita, decidimos propositalmente
> **não seguir isso**: com menos de 2 itens válidos, nenhum destaque é exibido (ver RN03A
> abaixo). Guardar essa nota para não reabrir a dúvida — já foi perguntado e decidido.

**RN03A — Mínimo para destacar (NOVO, diferente do legado)**
Destaque de "melhor"/"pior" só é calculado quando há **pelo menos 2 itens válidos**. Com 0 ou 1
item válido, todos os itens ficam neutros (sem destaque), mesmo que o item isolado tenha um
`valorPorUnidade` calculável.

**RN05 — Estado inicial**
Uma nova comparação começa com 3 itens vazios.

**RN06 — Adicionar item**
O usuário pode adicionar itens ilimitadamente à lista.

**RN07 — Limpar**
Resetar a comparação volta ao estado inicial (RN05), descartando os valores digitados.

**RN08 — Persistência**
Os itens digitados persistem localmente entre sessões do app (no legado: cookie; na
reescrita: storage local nativo — ver `03-non-functional.md`).

**RN09 — Remover item individual (NOVO, não existia no legado)**
O usuário pode remover um item específico da lista de comparação (feature nova, decidida para
a reescrita — ver `02-features/remover-item.md`).

**RN10 — Validação de valores negativos (NOVO, não existia no legado)**
Quantidade e preço não podem ser negativos. O app deve impedir/rejeitar a entrada de valores
negativos nesses campos.

## Decisões confirmadas
- ✅ RN06: sem limite de itens adicionados, mantido como no legado
- ✅ RN09: remoção individual de item é uma feature nova, aprovada para o MVP
- ✅ RN04 (empate): quando dois ou mais itens válidos empatam no menor `valorPorUnidade`,
  todos recebem o destaque "melhor opção" simultaneamente
- ✅ RN10: valores negativos de quantidade/preço são validados e impedidos (diferente do
  legado, que não tratava)
- ✅ RN03A: com menos de 2 itens válidos, nenhum destaque é exibido — decisão tomada mesmo
  sabendo que diverge do legado (que destacaria "melhor" para 1 item isolado), ver nota em RN04
