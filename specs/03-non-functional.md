# Requisitos Não-Funcionais

## Plataformas
- Android (Google Play) — versão mínima a definir (sugestão: Android 8+ / API 26+)
- iOS (App Store) — versão mínima a definir (sugestão: iOS 13+)

## Persistência
- Local, no dispositivo (substitui o cookie do app legado)
- Sugestão técnica: `shared_preferences` (simples, chave-valor) ou `Hive` (se o modelo
  crescer) — decisão a registrar em ADR quando o time técnico avaliar

## Performance
- Recalcular destaques (RN03/RN04) deve ser instantâneo à digitação (sem lag perceptível)
- App deve funcionar 100% offline (não depende de rede)

## UI / UX
- Modernizar visualmente mantendo a simplicidade original (formulário direto, sem fricção)
- ✅ Suporte a tema claro/escuro — entra no MVP (`ThemeMode.system`)
- Acessibilidade básica: contraste adequado nos destaques de cor (o legado usa só cor para
  indicar melhor/pior — reforçado com ícone + texto no selo "Melhor/Pior opção", não só cor)
- ✅ Identidade visual (decidido em 2026-08-03, Fase 3): azul do ícone do app legado (`#1E9BD7`)
  como cor-semente da paleta, para manter reconhecível pra quem já usava o app antigo. Marca
  (check) reaparece na AppBar. Cada card da comparação já nasce com um leve banho de cor —
  azul (neutro), verde (melhor), vermelho (pior) — em vez de só um selo colorido, pra não ficar
  visualmente "seco"/genérico demais em cima do Material padrão

## Internacionalização
- MVP em pt-BR, mas manter estrutura pronta para i18n futura (textos da interface continuam
  fixos em pt-BR neste MVP)
- ✅ Moeda exibida nos valores (preço, valor por unidade) é escolhida manualmente pelo usuário
  num seletor na tela (R$ é o padrão, com € logo em seguida na lista) — não é inferida
  automaticamente do locale do dispositivo. Decidido em 2026-08-03: locale mistura idioma e
  região (ex: aparelho em inglês fisicamente em Portugal não indica corretamente o país), então
  detecção automática não é confiável; escolha manual persiste entre sessões (RN08)
  A formatação numérica (separador decimal) continua seguindo o locale do idioma do aparelho —
  só o símbolo da moeda é manual

## Publicação
- ⚠️ **LEMBRETE PARA A FASE 4**: o app ID atual usado no projeto (`com.rodenapps.comparador`
  no legado) está registrado sob a conta de um amigo, não da própria autora. Antes de publicar
  nas lojas, será necessário criar um bundle ID/app ID próprio e migrar para ele. Não usar o ID
  antigo na publicação final.
- Ícone, splash screen e screenshots de loja: a produzir como parte da modernização de UI
