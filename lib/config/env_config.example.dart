/// PLANTILLA de configuració d'entorn
/// 
/// INSTRUCCIONS:
/// 1. Copia aquest fitxer i anomena'l: env_config.dart
/// 2. Omple les teves claus reals
/// 3. NO pugis env_config.dart a Git!
class EnvConfig {
  // Google Maps API Key
  // Obtén-la de: https://console.cloud.google.com/
  // Tutorial: https://developers.google.com/maps/documentation/javascript/get-api-key
  static const String googleMapsApiKey = 'AIzaSyCtbZRWjkpOHUUsOdMYM107WTFUlEFx_eQ';
  
  // Firebase Configuration
  static const String firebaseProjectId = 'YOUR_FIREBASE_PROJECT_ID';
  
  // App Configuration
  static const String appName = 'Trobar';
  static const String appVersion = '1.0.0';
  
  // Map Configuration
  static const double defaultLatitude = 41.3851; // Barcelona
  static const double defaultLongitude = 2.1734;
  static const double defaultZoom = 14.0;
  static const double nearbyRadiusKm = 5.0;
  
  // API URLs
  static const String apiBaseUrl = 'https://your-api-url.com';
  
  // Debug
  static const bool isDebugMode = true;
  static const bool showDebugBanner = false;
  
  static bool get isConfigured => 
      googleMapsApiKey != 'AIzaSyCtbZRWjkpOHUUsOdMYM107WTFUlEFx_eQ';
  
  static String get configurationError => !isConfigured 
      ? '⚠️ Configura env_config.dart amb les teves claus'
      : '';
}