# Screenshots para o App Store Connect

Pasta pra organizar as capturas de tela exigidas na ficha do app na App Store, separadas pelos
dois tamanhos obrigatórios. Os screenshots existentes em `docs/` (`screenshot-*.png`,
`screenshot-tablet10-*.png`) são do Android/Play Store e **não servem aqui** — as resoluções
não batem com o que a Apple exige.

## ⚠️ Sobre as imagens já presentes nestas pastas
As 4 imagens já colocadas aqui (`01-comparacao.png`, `02-moedas.png` em cada tamanho) **não
foram capturadas num simulador/dispositivo iOS real** — este ambiente é Linux, sem Xcode/Mac
disponível. Foram geradas rodando o app compilado pra **web** (`flutter build web`) num Chrome
headless, com a janela ajustada pro tamanho lógico exato de cada device (ex: iPhone 14 Plus,
428×926pt @3x) e preenchidas automaticamente com os mesmos dados de exemplo usados nos
screenshots do Android (500/15, 1000/18, 750/9), só pra bater a resolução em pixels exigida.
Como o Flutter renderiza o mesmo código em todas as plataformas, o conteúdo da tela (textos,
cores, layout) deve ser fiel ao app real — mas **falta a moldura nativa do iOS** (status bar,
home indicator) que aparece num device/simulador de verdade.
**Antes de publicar**: o ideal é o colega regerar essas 4 imagens no simulador do Xcode (passo
"Como gerar" abaixo) quando for fazer o build de release — é rápido e fica 100% fiel. Se não
der tempo, estas aqui já cumprem o requisito técnico de resolução da Apple e podem ser usadas
como estão.

## iPhone — tela de 6,5" (obrigatório)
Pasta: `iphone-6.5/`

Até 3 pré-visualizações + 10 capturas de tela, em uma destas resoluções (retrato ou paisagem):
- 1242 × 2688 px (ou 2688 × 1242 px)
- 1284 × 2778 px (ou 2778 × 1284 px)

Simuladores que geram essas resoluções: iPhone 11 Pro Max/XS Max (1242×2688) ou iPhone
14/15/16 Plus (1284×2778).

## iPad — tela de 13" (obrigatório)
Pasta: `ipad-13/`

Até 3 pré-visualizações + 10 capturas de tela, em uma destas resoluções (retrato ou paisagem):
- 2064 × 2752 px (ou 2752 × 2064 px)
- 2048 × 2732 px (ou 2732 × 2048 px)

Simuladores: iPad Pro 13" M4 (2064×2752) ou iPad Pro 12.9" (2048×2732).

## Como gerar
Via simulador do Xcode (não precisa de iPhone/iPad físico pra screenshot, só pra teste real do
app):
```bash
flutter run -d "<nome do simulador>"
```
No simulador, `Cmd+S` salva a captura direto na resolução nativa do device escolhido, sem
precisar redimensionar depois.

## Convenção de nome
`NN-descricao.png`, ex: `01-comparacao.png`, `02-moedas.png` — mesma ideia das telas já
escolhidas pro Android (`docs/screenshot-1-comparacao.png`, `docs/screenshot-2-moedas.png`),
pra manter consistência entre as duas lojas.
