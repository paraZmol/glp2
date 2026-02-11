import 'package:flutter/material.dart';
import 'src/flavors/flavor_config.dart';
import 'src/services/firebase_service.dart';
import 'src/features/auth/auth_page.dart';
import 'src/theme/app_theme.dart';

Future<void> mainCommon(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig.setup(flavor);
  await FirebaseService.init(flavor);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema GLP JLA',
      theme: AppTheme.lightTheme(),
      home: const AuthPage(),
    );
  }
}
