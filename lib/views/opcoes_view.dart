import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vinta_financas/controllers/categoria_despesa_controller.dart';
import 'package:vinta_financas/controllers/categoria_receita_controller.dart';
import 'package:vinta_financas/views/gerenciar_categoria_view.dart';
import 'package:vinta_financas/views/editar_perfil_view.dart';

class Opcoes extends StatelessWidget {
  const Opcoes({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        const Text(
          'Opções',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 20),
        _buildOpcaoItem(
          context,
          titulo: 'Categorias de Receitas',
          subtitulo: 'Editar ou excluir receitas',
          icone: Icons.arrow_upward,
          cor: Colors.green,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GerenciarCategoriasView(
                  tituloTela: 'Receitas',
                  controller: context.read<CategoriaReceitaController>(),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildOpcaoItem(
          context,
          titulo: 'Categorias de Despesas',
          subtitulo: 'Editar ou excluir despesas',
          icone: Icons.arrow_downward,
          cor: Colors.red,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GerenciarCategoriasView(
                  tituloTela: 'Despesas',
                  controller: context.read<CategoriaDespesaController>(),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildOpcaoItem(
          context,
          titulo: 'Editar Perfil',
          subtitulo: 'Gerenciar email, senha e conta',
          icone: Icons.person_outline,
          cor: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditarPerfilView(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildOpcaoItem(BuildContext context,
      {required String titulo,
      required String subtitulo,
      required IconData icone,
      required Color cor,
      required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      shadowColor: Colors.pink.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: cor.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: Icon(icone, color: cor),
        ),
        title: Text(titulo,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle:
            Text(subtitulo, style: TextStyle(color: Colors.grey.shade600)),
        trailing: Icon(Icons.arrow_forward_ios,
            color: Colors.pink.shade300, size: 18),
        onTap: onTap,
      ),
    );
  }
}
