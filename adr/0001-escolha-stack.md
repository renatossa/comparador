# ADR 0001 — Escolha de stack: Flutter

## Status
Aceito

## Contexto
Reescrita completa de um app Cordova (AngularJS + jQuery Mobile), com objetivo de publicar
nativamente nas lojas Android e iOS e modernizar a UI. App é funcionalmente simples (um
formulário com cálculo e destaque visual), sem dependências de recursos nativos avançados.

## Alternativas consideradas
- **React Native**: forte ecossistema JS, mas sem vantagem clara aqui já que não há reuso de
  código/skills em React vindo do projeto legado (que era AngularJS, não React)
- **PWA**: mais simples de publicar na web, mas não entrega experiência de "app de loja"
  nativa nas duas stores, que é requisito explícito
- **Cordova/Capacitor atualizado**: manteria a stack mais próxima da original, mas não atende
  ao objetivo de modernização real de UI/performance

## Decisão
Usar **Flutter**.

## Justificativa
- Um único código-fonte gera build nativo para Android e iOS, sem camada de bridge JS
- Sistema de widgets facilita exatamente o que este app precisa: layout consistente, cores
  dinâmicas por estado (destaque melhor/pior), forms
- Hot reload agiliza o ciclo de teste manual/exploratório durante o desenvolvimento
- Boa curva de aprendizado vindo de um background com Angular

## Consequências
- Equipe/mantenedor precisa aprender Dart (curva pequena, mas existe)
- Empacotamento e assinatura de build para as duas lojas precisam ser configurados do zero
