# Ideias Futuras (backlog, não planejado)

Este arquivo guarda ideias discutidas para versões futuras do app, **fora do MVP** e sem
compromisso de quando (ou se) serão implementadas. Diferente das outras specs, nada aqui é
fonte da verdade pra implementação — antes de qualquer uma virar trabalho real, precisa virar
uma spec de verdade (`02-features/*.md`) com critérios de aceite, RNxx no domain model, etc.

## Conversão de unidade

**Problema**: hoje o app assume que todos os itens de uma comparação estão na mesma unidade
(g com g, ml com ml). Se o usuário digitar um item em gramas e outro em quilos sem perceber,
o app calcula e destaca a "melhor opção" normalmente — mas o resultado está errado, sem nenhum
aviso. É um risco de dar a resposta errada exatamente na função central do app.

**Direção proposta**: em vez de um campo de texto livre com dica ("em g, ml, kg, litros..."),
ter um seletor de unidade por item (g/kg, ml/L, unidade) com conversão automática pra uma base
comum antes de calcular `valorPorUnidade`. Levantaria perguntas a decidir quando for
especificado: o que fazer se o usuário tentar comparar categorias incompatíveis entre si
(ex: peso vs volume)? bloquear, avisar, ou permitir mesmo assim?

## Compartilhar resultado da comparação

Já listado como fora de escopo em `00-overview.md`, detalhando aqui a ideia: permitir exportar
o resultado da comparação (como imagem ou texto) pra compartilhar via apps de mensagem etc.
Baixo esforço de implementação relativo ao valor (potencial de aquisição orgânica de usuários),
mas ainda sem desenho de UX definido (o que exatamente aparece no compartilhamento? só o item
"melhor", ou a lista inteira?).

## Preencher quantidade via leitura de código de barras

Já listado como fora de escopo em `00-overview.md` ("leitura de preço via código de
barras/OCR"), detalhando aqui a ideia depois de avaliar a viabilidade (discutido em
2026-08-10): usar a câmera pra ler o código de barras do produto e preencher o campo
"Quantidade" automaticamente, usando a API gratuita e aberta do
[Open Food Facts](https://world.openfoodfacts.org/) (sem chave de autenticação pra leitura).

**Importante — o que essa integração resolve e o que não resolve**:
- ✅ Resolve: preencher a quantidade/tamanho da embalagem (g/ml/kg/L) automaticamente, evitando
  o usuário ter que procurar e digitar essa informação do rótulo
- ❌ Não resolve: o **preço** continua sendo digitado manualmente — nenhuma API global sabe o
  preço praticado numa loja específica num dia específico

**Cobertura por região** (relevante pro público-alvo do app, Brasil e Portugal): a base é
colaborativa/crowdsourced, então a cobertura varia — boa pra marcas grandes/multinacionais nos
dois países, mas fraca pra produtos regionais/locais (Brasil por ser mercado grande e
fragmentado; Portugal por ser mercado pequeno, ainda que se beneficie de produtos
pan-europeus já cadastrados por outros países da UE). Consequência de design: a busca por
código de barras precisa ser tratada como um *assist* opcional com fallback gracioso pro
preenchimento manual quando o código não for encontrado — nunca uma dependência obrigatória.

**Direção técnica proposta**: pacote `mobile_scanner` (ou similar) pra leitura de código de
barras via câmera no Flutter, chamando a API REST do Open Food Facts (retorna JSON) pra
resolver o código pro tamanho da embalagem.

## Importar item a partir de print de app de mercado

**Problema**: hoje cada item da comparação começa vazio ("Item 1", "Item 2"...) e o usuário
digita nome (não existe hoje, ver nota de domain model abaixo), quantidade e preço na mão pra
cada produto. Levantada em 2026-08-11: em vez de digitar, o usuário tira/recebe um print de um
app de mercado (ex: catálogo de um supermercado, app de delivery) e o Comparador extrai
automaticamente o nome do produto, o preço e a quantidade/unidade a partir da imagem.

**Fluxo desejado**:
1. Usuário fornece o print de uma das duas formas:
   - **Manual**: toca em algum lugar da tela de comparação (ex: botão "importar de print") e
     escolhe uma imagem da galeria
   - **Compartilhamento direto**: ao tirar o print (ou já tendo um salvo) e usar o "Compartilhar"
     nativo do celular, o Comparador aparece como um dos apps de destino — escolher o Comparador
     ali importa a imagem direto, sem precisar abrir o app manualmente antes
2. O app processa a imagem (OCR) e tenta extrair: nome do produto, preço e quantidade/unidade
3. Um novo item é criado na lista de comparação, preenchido com o que foi extraído — o nome
   substitui o rótulo genérico "Item N" desse item
4. Se o app não tem confiança no que extraiu (ex: não achou preço, ou achou mais de um número
   candidato a preço), sinaliza visualmente esse item como "conferir" pra chamar atenção do
   usuário antes de confiar no valor — usuário revisa/corrige manualmente os campos importados
   como faria hoje digitando
5. Repetindo o fluxo (print após print), a lista de comparação vai sendo montada item a item

**O que essa ideia resolve e o que não resolve** (mesmo raciocínio da ideia de código de
barras, ver acima): resolve o trabalho de digitar nome/preço/quantidade lendo de uma fonte que
o usuário já tem na tela (o catálogo do mercado); não resolve nada que a foto não contenha —
se o print for de má qualidade ou o app de mercado tiver um layout que o OCR não reconhece bem,
o resultado fica pior e depende do aviso de "conferir" (passo 4) pra não enganar o usuário.

**Decisões em aberto pra discutir antes de virar spec**:
- **Campo "nome do item" não existe no domain model hoje** (`01-domain-model.md` só tem
  `quantidade`, `preco`, `valorPorUnidade`, `status`) — essa ideia exige adicionar esse campo
  à entidade `Item` e decidir como ele interage com o rótulo "Item N" hoje usado (nome
  substitui o rótulo só quando preenchido? sempre editável manualmente também, sem depender de
  import?)
- **OCR on-device vs. nuvem**: on-device (ex: `google_mlkit_text_recognition`, roda no
  aparelho) preserva a política de privacidade atual do app ("não coleta nenhum dado",
  `docs/privacidade.html`) sem precisar mudar nada; usar um serviço de OCR em nuvem
  (potencialmente mais preciso) enviaria a imagem do print pra fora do aparelho, o que exigiria
  reescrever a política de privacidade e provavelmente pedir consentimento — mudança de peso,
  não decidir de leve
- **Como extrair "qual número é o quê" de um texto solto**: um print de mercado tem vários
  números na tela (preço, preço "de/por", desconto, avaliação, código do produto...). Precisa
  de uma heurística (ex: reconhecer padrão de moeda R$/€, pegar o maior texto como nome, etc.)
  — não há uma fonte estruturada tipo a API do Open Food Facts pra validar; layout varia por
  app de mercado, o que pode exigir heurísticas por app conhecido ou aceitar uma taxa de erro
  maior
- **Design do aviso "conferir"**: reaproveitar o padrão visual já existente de destaque
  melhor/pior (cor + ícone/texto, ver `03-non-functional.md` sobre acessibilidade) pra um novo
  estado "importado, não conferido"? Precisa de critério claro de quando marcar como
  baixa-confiança (campo não encontrado? ambíguo? sempre marcar todo item importado até o
  usuário confirmar, mesmo se a extração pareceu certa?)
- **Compartilhamento direto (share target) por plataforma**: no Android é viável via
  `intent-filter` pra `image/*` (pacote tipo `receive_sharing_intent`); no iOS exige criar um
  **Share Extension** nativo (target adicional no Xcode) — mais uma peça que depende do colega
  com Mac e conta Apple Developer (mesma dependência já registrada pro build de release iOS em
  `04-migration-plan.md`), então a via manual (escolher da galeria) provavelmente chega antes
  no iOS
- Fora de escopo por ora, não custa registrar: preço muda de loja pra loja e de dia pra dia, ou
  seja, diferente da ideia de código de barras (que resolve *quantidade* de forma confiável via
  base de dados), aqui o **preço também** vem do OCR — maior superfície de erro, reforça a
  importância do aviso de "conferir" do passo 4
