import 'package:flutter/material.dart';
import 'package:vinta_financas/controllers/login_controller.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final LoginController _loginController = LoginController();

  bool _estaCarregando = false;

  void _processarCadastro() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _estaCarregando = true);

      String? erro = await _loginController.registrarUsuario(
        nome: _nomeController.text,
        email: _emailController.text,
        senha: _passwordController.text,
      );

      if (mounted) {
        setState(() => _estaCarregando = false);

        if (erro == null) {
          // Sucesso!
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Conta criada com sucesso! Faça seu login.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
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
      appBar: AppBar(
        title: const Text('Criar nova conta'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome Completo',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Digite seu nome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),

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
                const SizedBox(height: 12.0),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha:',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  validator: _loginController.validarSenha,
                ),
                const SizedBox(height: 12.0),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha:',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Confirme a senha';
                    }
                    if (value != _passwordController.text) {
                      return 'As senhas são diferentes';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),

                _estaCarregando
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.pink),
                      )
                    : ElevatedButton(
                        onPressed: _processarCadastro,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )
                        ),
                        child: const Text('Cadastrar', style: TextStyle(fontSize: 20)),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}