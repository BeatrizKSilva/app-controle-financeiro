import 'package:flutter/material.dart';
import 'package:vinta_financas/repositories/user_mock.dart';
import 'package:vinta_financas/views/login.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  late TextEditingController _emailController;
  final TextEditingController _senhaAntigaController = TextEditingController();
  final TextEditingController _senhaNovaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: UserMock.email);
  }

  void _salvarAlteracoes() {
    String senhaAntiga = _senhaAntigaController.text;
    String senhaNova = _senhaNovaController.text;

    if (senhaNova.isNotEmpty) {
      if (!UserMock.verificarSenhaAntiga(senhaAntiga)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Senha Incorreta'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }
    UserMock.atualizarPerfil(_emailController.text, senhaNova);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perfil Atualizado com Sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
    _senhaAntigaController.clear();
    _senhaNovaController.clear();
  }

  void _mostarConfirmacao(
      {required String titulo,
      required String mensagem,
      required VoidCallback onConfirm,
      bool isExcluir = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensagem),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: onConfirm,
              child: Text('Confirmar',
                  style:
                      TextStyle(color: isExcluir ? Colors.red : Colors.pink)),
            ),
          ],
        );
      },
    );
  }

  void _fazerLogout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: Colors.pink.shade300,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Dados da Conta',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                prefixIcon: const Icon(Icons.email_outlined),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 22),
            const Divider(),
            const SizedBox(height: 16),
            const Text('Alterar Senha',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _senhaAntigaController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha Antiga',
                prefixIcon: const Icon(Icons.lock_outline),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _senhaNovaController,
              decoration: InputDecoration(
                labelText: 'Nova Senha',
                prefixIcon: const Icon(Icons.lock_reset),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade300,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(15)),
              ),
              onPressed: _salvarAlteracoes,
              child: const Text('Salvar Alterações',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 40),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange,
                side: const BorderSide(color: Colors.orange),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(15)),
              ),
              icon: const Icon(Icons.logout),
              label: const Text('Sair da Conta'),
              onPressed: () {
                _mostarConfirmacao(
                  titulo: 'Sair da Conta',
                  mensagem: 'Tem certeza que deseja sir do aplicativo?',
                  onConfirm: _fazerLogout,
                );
              },
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              icon: const Icon(Icons.delete_forever),
              label: const Text('Excluir Conta Permanentemente'),
              onPressed: () {
                _mostarConfirmacao(
                  titulo: 'Atenção!',
                  mensagem:
                      'Esta ação não pode ser desfeita. Todos os seus dados serão apagados. Deseja continuar?',
                  isExcluir: true,
                  onConfirm: () {
                    UserMock.excluirConta();
                    _fazerLogout(); // Depois de excluir, manda pro login também
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
