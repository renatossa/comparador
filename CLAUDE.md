# Instruções para o Claude Code neste projeto

Este projeto segue **Spec-Driven Development (SDD)**. Leia isto antes de implementar qualquer
coisa.

## Regra de ouro
**A spec é a fonte da verdade, não o código.** Se o comportamento pedido diverge do que está
escrito em `specs/`, pare e avise — não implemente silenciosamente algo diferente da spec, e
não decida por conta própria como resolver uma divergência.

Antes de usar qualquer ADR como base para implementação, verifique o campo Status no topo do
arquivo da ADR. Só trate como decisão definitiva se o status for "Aceito".

## Antes de implementar uma feature
1. Leia a spec correspondente em `specs/02-features/*.md`
2. Leia `specs/01-domain-model.md` para as regras de negócio (RNxx) envolvidas
3. Verifique se há decisões pendentes marcadas na spec (`[DECISÃO PENDENTE]`) que afetem o que
   você vai implementar — se sim, pergunte ao usuário antes de prosseguir, não assuma
4. Verifique as ADRs em `adr/` relevantes (stack: `0001`, aceito; state management: `0002`,
   aceito)

## Ao implementar
- Toda lógica de regra de negócio (RNxx) deve ficar isolada do widget/UI (ver ADR 0002 —
  Provider + ChangeNotifier), para ser testável sem montar a árvore de widgets
- Todo "Cenário" descrito nos critérios de aceite de uma spec deve virar um teste automatizado
  (unitário para lógica de domínio, de widget/integração para fluxo de tela)
- Nomeie o commit ou PR referenciando a spec e as regras implementadas, ex:
  `feat: comparar preços (specs/02-features/comparar-precos.md, RN01-RN04)`

## Progresso do projeto (retomar de onde parou)
`specs/04-migration-plan.md` é o "estado vivo" do projeto — reflete o que já foi feito e o
que falta. **Sempre que uma tarefa for concluída, marque o checkbox correspondente nesse
arquivo como parte do mesmo commit.** Se uma tarefa nova surgir que não estava prevista,
adicione-a na fase correta antes de segui-la. Ao abrir o projeto numa nova sessão, leia esse
arquivo primeiro para saber exatamente onde o trabalho parou.

## Se uma spec estiver desatualizada ou incompleta
Atualize a spec como parte do PR — specs e código evoluem juntos. Nunca deixe o código
divergir silenciosamente do que está documentado.

## Lembretes específicos deste projeto
- ✅ App ID definitivo: `com.renatossa.comparador` (migrado em 2026-08-04, conta própria e
  verificada no Play Console — não usar mais `com.example.comparador` nem o antigo
  `com.rodenapps.comparador` do legado, que estava sob conta de amigo)
- Chave de assinatura de release (`android/app/upload-keystore.jks` +
  `android/key.properties`) fica fora do git (gitignored) — nunca tente commitar nem recriar
  sem confirmar com o usuário; perder esse arquivo compromete updates futuros na Play Store
- RN06 (adicionar itens) é **sem limite**, mantido fiel ao app legado
- RN09 (remover item individual) é uma feature **nova**, que não existia no app original

## Estrutura de referência
```
specs/00-overview.md        → visão geral e escopo
specs/01-domain-model.md    → entidades e regras de negócio (RNxx)
specs/02-features/          → uma spec por feature, com critérios de aceite testáveis
specs/03-non-functional.md  → performance, persistência, publicação
specs/04-migration-plan.md  → fases do projeto
adr/                        → decisões de arquitetura
```
