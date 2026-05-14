import 'package:flutter/material.dart';
import 'package:vinta_financas/controllers/login_controller.dart';
import 'package:vinta_financas/views/login_view.dart';

class EditarPerfilView extends StatefulWidget {
  const EditarPerfilView({super.key});

  @override
  State<EditarPerfilView> createState() => _EditarPerfilViewState();
}

class _EditarPerfilViewState extends State<EditarPerfilView> {
  final LoginController _loginController = LoginController();
  late TextEditingController _emailController;
  final TextEditingController _senhaAntigaController = TextEditingController();
  final TextEditingController _senhaNovaController = TextEditingController();

  bool _estaCarregando = false;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController(text: _loginController.obterEmailUsuario() ?? '');
  }

  void _salvarAlteracoes() async {
    String senhaAntiga = _senhaAntigaController.text;
    String senhaNova = _senhaNovaController.text;

    if (senhaAntiga.isEmpty || senhaNova.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha a senha antiga e a nova para alterar.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _estaCarregando = true);

    String? erro = await _loginController.atualizarSenha(senhaAntiga, senhaNova);

    if (mounted) {
      setState(() => _estaCarregando = false);
      if (erro == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Senha Atualizada com Sucesso!'), backgroundColor: Colors.green),
        );
        _senhaAntigaController.clear();
        _senhaNovaController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(erro), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _fazerLogout() async {
    await _loginController.fazerLogout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
        (route) => false,
      );
    }
  }

  void _mostrarDialogoExcluir() {
    TextEditingController senhaConfirmacao = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Atenção!', style: TextStyle(color: Colors.red)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Esta ação apagará todos os seus dados. Digite a sua senha para confirmar:'),
              const SizedBox(height: 10),
              TextField(
                controller: senhaConfirmacao,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha atual',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                if (senhaConfirmacao.text.isEmpty) return;
                Navigator.pop(context);
                
                setState(() => _estaCarregando = true);
                String? erro = await _loginController.excluirConta(senhaConfirmacao.text);
                
                if (mounted) {
                  setState(() => _estaCarregando = false);
                  if (erro == null) {
                    _fazerLogout();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(erro), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              child: const Text('Confirmar e Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
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
            const Text('Dados da Conta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'E-mail',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 22),
            const Divider(),
            const SizedBox(height: 16),
            const Text('Alterar Senha', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _senhaAntigaController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha Antiga',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _senhaNovaController,
              decoration: InputDecoration(
                labelText: 'Nova Senha',
                prefixIcon: const Icon(Icons.lock_reset),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 30),
            
            _estaCarregando
                ? const Center(child: CircularProgressIndicator(color: Colors.pink))
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade300,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: _salvarAlteracoes,
                    child: const Text('Salvar Alterações', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
            
            const SizedBox(height: 40),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange,
                side: const BorderSide(color: Colors.orange),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              icon: const Icon(Icons.logout),
              label: const Text('Sair da Conta'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Sair da Conta'),
                    content: const Text('Tem certeza que deseja sair do aplicativo?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar', style: TextStyle(color: Colors.grey))),
                      TextButton(onPressed: _fazerLogout, child: const Text('Confirmar', style: TextStyle(color: Colors.pink))),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              icon: const Icon(Icons.delete_forever),
              label: const Text('Excluir Conta Permanentemente'),
              onPressed: _mostrarDialogoExcluir,
            ),
          ],
        ),
      ),
    );
  }
}