import 'package:provider/provider.dart';
import 'package:vinta_financas/controllers/transacao_controller.dart';
import 'package:vinta_financas/controllers/categoria_despesa_controller.dart';
import 'package:vinta_financas/controllers/categoria_receita_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'views/login_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TransacaoController()),
        ChangeNotifierProvider(
            create: (context) => CategoriaDespesaController()),
        ChangeNotifierProvider(
            create: (context) => CategoriaReceitaController()),
      ],
      child: const VintaApp(),
    ),
  );
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      home: const Login(),
    );
  }
}
