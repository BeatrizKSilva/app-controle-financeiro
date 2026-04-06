import 'package:flutter/material.dart';
//import 'package:vinta_financas/views/principal.dart';
import 'views/login.dart';

void main() {
  runApp(const VintaApp());
}

class VintaApp extends StatelessWidget {
  const VintaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vinta App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const Login(),
    );
  }
}
