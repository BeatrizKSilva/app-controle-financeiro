import 'package:flutter/material.dart';

class GerenciarCategoriasView extends StatefulWidget {
  final String tituloTela;
  final dynamic controller;

  const GerenciarCategoriasView({
    super.key,
    required this.tituloTela,
    required this.controller,
  });

  @override
  State<GerenciarCategoriasView> createState() =>
      _GerenciarCategoriasViewState();
}

class _GerenciarCategoriasViewState extends State<GerenciarCategoriasView> {
  void _excluirCategoria(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Categoria'),
        content: const Text("Tem certeza que deseja excluir esta categoria?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                widget.controller.categorias.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Categoria excluída com sucesso'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Excluir',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _editarCategoria(int index) {
    final categoria = widget.controller.categorias[index];
    TextEditingController nomeController =
        TextEditingController(text: categoria.nome);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Nome'),
        content: TextField(
          controller: nomeController,
          decoration: const InputDecoration(hintText: "Novo nome da categoria"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              final novoNome = nomeController.text.trim();
              if (novoNome.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('O nome da categoria não pode ficar vazio'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              setState(() {
                widget.controller.editarCategoria(index, novoNome);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Categoria editada com sucesso'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('Salvar',
                style: TextStyle(
                    color: Colors.pink.shade300, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar ${widget.tituloTela}'),
        backgroundColor: Colors.pink.shade300,
        foregroundColor: Colors.white,
      ),
      body: widget.controller.categorias.isEmpty
          ? Center(
              child: Text('Nenhuma categoria encontrada.',
                  style: TextStyle(color: Colors.grey.shade600)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.controller.categorias.length,
              itemBuilder: (context, index) {
                final categoria = widget.controller.categorias[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: categoria.cor,
                      child: Icon(categoria.icone, color: Colors.white),
                    ),
                    title: Text(categoria.nome,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editarCategoria(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _excluirCategoria(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
