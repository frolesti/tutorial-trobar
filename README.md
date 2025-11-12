# 🏟️ Trobar - Troba el millor bar per veure el partit

## 📋 Configuració Inicial

### 1. Clona el repositori
\`\`\`bash
git clone https://github.com/tu-usuario/trobar.git
cd trobar
\`\`\`

### 2. Instal·la les dependències
\`\`\`bash
flutter pub get
\`\`\`

### 3. Configura les variables d'entorn

#### Google Maps API Key
1. Ves a [Google Cloud Console](https://console.cloud.google.com/)
2. Crea un nou projecte
3. Activa "Maps JavaScript API"
4. Crea una API Key

#### Configuració local
1. Copia el fitxer de plantilla:
\`\`\`bash
cp lib/config/env_config.example.dart lib/config/env_config.dart
\`\`\`

2. Obre `lib/config/env_config.dart` i substitueix:
\`\`\`dart
static const String googleMapsApiKey = 'LA_TEVA_API_KEY_AQUI';
\`\`\`

3. Obre `web/index.html` i substitueix:
\`\`\`html
<script src="https://maps.googleapis.com/maps/api/js?key=LA_TEVA_API_KEY_AQUI"></script>
\`\`\`

### 4. Executa l'aplicació
\`\`\`bash
flutter run -d chrome
\`\`\`

## ⚠️ IMPORTANT - Seguretat

**NEVER commit these files to Git:**
- `lib/config/env_config.dart` (les teves claus reals)
- `web/index.html` (conté la API key)

Aquests fitxers ja estan al `.gitignore`.

## 🔒 Variables d'Entorn

| Variable | Descripció | On obtenir-la |
|----------|------------|---------------|
| `googleMapsApiKey` | API Key de Google Maps | [Google Cloud Console](https://console.cloud.google.com/) |
| `firebaseProjectId` | ID del projecte Firebase | [Firebase Console](https://console.firebase.google.com/) |

## 📱 Tecnologies

- Flutter 3.5.4
- Firebase (Auth, Firestore)
- Google Maps
- BLoC Pattern
\`\`\`

Ara les teves claus estan protegides! 🔒✅
