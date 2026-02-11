import 'package:flutter/material.dart';
import 'src/flavors/flavor_config.dart';

Future<void> mainCommon(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig.setup(flavor);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema GLP JLA',
      home: const Scaffold(body: Center(child: Text('sistema glp jla'))),
    );
  }
}
