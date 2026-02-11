import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../flavors/flavor_config.dart';

/// Servicio responsable de inicializar Firebase de forma centralizada.
///
/// - En mobile (android/ios) usa los archivos google-services.json / GoogleService-Info.plist
///   proporcionados por Firebase para cada flavor.
/// - En web intenta leer variables de entorno desde `.env` y construir `FirebaseOptions`.
class FirebaseService {
  static Future<void> init(Flavor flavor) async {
    // carga variables de entorno si existen
    try {
      await dotenv.load();
    } catch (_) {
      // ignore si no existe .env
    }

    if (kIsWeb) {
      final apiKey = dotenv.env['FIREBASE_API_KEY'] ?? '';
      final authDomain = dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? '';
      final projectId = dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
      final storageBucket = dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '';
      final messagingSenderId =
          dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
      final appId = dotenv.env['FIREBASE_APP_ID'] ?? '';
      final measurementId = dotenv.env['FIREBASE_MEASUREMENT_ID'] ?? '';

      if (apiKey.isEmpty || projectId.isEmpty || appId.isEmpty) {
        // intenta inicializar sin opciones (fallará si no hay configuración web)
        await Firebase.initializeApp();
        return;
      }

      final options = FirebaseOptions(
        apiKey: apiKey,
        authDomain: authDomain,
        projectId: projectId,
        storageBucket: storageBucket,
        messagingSenderId: messagingSenderId,
        appId: appId,
        measurementId: measurementId.isEmpty ? null : measurementId,
      );

      await Firebase.initializeApp(options: options);
    } else {
      // mobile usa la configuracion por archivos (google-services.json / plist)
      await Firebase.initializeApp();
    }
  }
}
