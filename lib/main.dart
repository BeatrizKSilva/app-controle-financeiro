import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vinta_financas/controllers/transacao_controller.dart';
import 'package:vinta_financas/controllers/categoria_despesa_controller.dart';
import 'package:vinta_financas/controllers/categoria_receita_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'views/login_view.dart';
import 'views/principal_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.pink));
          }
          
          if (snapshot.hasData) {
            return const PrincipalView();
          }
          
          return const LoginView();
        },
      ),
    );
  }
}