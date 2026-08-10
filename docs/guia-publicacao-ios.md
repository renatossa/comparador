# Guia de publicação iOS — Comparador de Preços

Contexto rápido: o app foi reescrito do zero em Flutter (antes era Cordova/AngularJS), mas a
ideia é continuar publicando na **mesma ficha da App Store** que você já tinha, em vez de criar
uma nova do zero. O bundle ID continua o mesmo de sempre: **`com.rodenapps.comparador`**.

## Pré-requisitos

- Mac com Xcode instalado (versão recente)
- Flutter instalado (`flutter doctor` sem erros — [guia oficial](https://docs.flutter.dev/get-started/install/macos))
- Acesso à conta Apple Developer onde o app `com.rodenapps.comparador` já está cadastrado
  (Membership ativo — confere em developer.apple.com → Account → Membership)

## Passo a passo

### 1. Clonar o projeto
```bash
git clone https://github.com/renatossa/comparador.git
cd comparador
flutter pub get
```

### 2. Abrir no Xcode
Abre especificamente o **workspace**, não o `.xcodeproj`:
```bash
open ios/Runner.xcworkspace
```

### 3. Configurar assinatura
No Xcode, seleciona o target **Runner** → aba **"Signing & Capabilities"** → escolhe o seu
**Team** (a conta Apple Developer). O Xcode deve resolver o provisioning profile
automaticamente, já que o bundle ID (`com.rodenapps.comparador`) já existe na sua conta.

### 4. Conferir a versão
O número da versão vem do `pubspec.yaml` (raiz do projeto), campo `version:` — formato
`X.Y.Z+N`. Precisa ser **maior** que a última versão publicada na App Store há uns anos atrás.
Se precisar, muda esse valor antes de seguir (me avisa qual número você usou, pra eu manter
sincronizado com o Android também).

### 5. Archive
No Xcode: seleciona **"Any iOS Device"** como destino (não um simulador — archive não funciona
com simulador), depois **Product → Archive**. Pode levar alguns minutos.

### 6. Validar e enviar
Quando o archive terminar, abre a janela **Organizer** (geralmente abre sozinha) →
**"Distribute App"** → **"App Store Connect"** → **"Upload"**. Segue o assistente (usa as
opções recomendadas/padrão do Xcode).

### 7. Aguardar processamento
No [App Store Connect](https://appstoreconnect.apple.com), o build enviado leva de alguns
minutos a ~1h pra aparecer disponível pra uso.

### 8. Criar a versão na ficha do app
Na ficha do `Comparador de Preços` no App Store Connect → aba de versões → cria uma versão
nova → associa o build que acabou de subir → preenche as notas da versão.

### 9. TestFlight primeiro (recomendado)
Antes de mandar pra revisão da Apple, dá pra distribuir via **TestFlight** pra nós dois
testarmos num iPhone de verdade — evita repetir os perrengues que tivemos no Android testando
tarde demais.

### 10. Enviar pra revisão
Depois de validado no TestFlight, envia a versão pra revisão da Apple. Costuma levar de 1 a 3
dias.

### 11. Publicar
Aprovado, é só escolher entre lançamento manual ou automático assim que a Apple liberar.

## Se der algo errado

- **Erro de provisioning/certificado**: geralmente o próprio Xcode resolve automaticamente
  com "Automatically manage signing" marcado. Se não resolver, o certificado antigo pode ter
  expirado — cria um novo em developer.apple.com → Certificates
- **Bundle ID não aparece na sua conta**: confirma que está logado com a conta certa no Xcode
  (Xcode → Settings → Accounts)
- Qualquer dúvida, me chama — a gente resolve junto
