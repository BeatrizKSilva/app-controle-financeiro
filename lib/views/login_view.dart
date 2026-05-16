import 'package:flutter/material.dart';
import 'package:vinta_financas/controllers/login_controller.dart';
import 'package:vinta_financas/views/cadastro_view.dart';
import 'package:vinta_financas/views/principal_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final LoginController _loginController = LoginController();

  bool _estaCarregando = false;

  bool _ocultarSenha = true;

  void _processarLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _estaCarregando = true);

      String? erro = await _loginController.fazerLogin(
        email: _emailController.text,
        senha: _passwordController.text,
      );

      if (mounted) {

        setState(() => _estaCarregando = false);

        if (erro == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PrincipalView()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(erro),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80),
                const Icon(Icons.account_balance_wallet, size: 100, color: Colors.pink),
                const SizedBox(height: 20),
                const Text(
                  'Vinta Finanças',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.pink),
                ),
                const SizedBox(height: 40),

                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  validator: _loginController.validarEmail,
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: _passwordController,
                  obscureText: _ocultarSenha,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock),

                    suffixIcon: IconButton(
                      icon: Icon(
                        _ocultarSenha ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {

                        setState(() {

                          _ocultarSenha = !_ocultarSenha;

                        });

                      },
                    ),
                    
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  validator: _loginController.validarSenha,
                ),
                const SizedBox(height: 25),

                _estaCarregando
                    ? const Center(child: CircularProgressIndicator(color: Colors.pink))
                    : ElevatedButton(
                        onPressed: _processarLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text('Entrar', style: TextStyle(fontSize: 18)),
                      ),

                const SizedBox(height: 15),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CadastroView()),
                    );
                  },
                  child: const Text(
                    'Não tem uma conta? Cadastre-se',
                    style: TextStyle(color: Colors.pink),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
