import 'package:flutter/material.dart';
import 'package:vinta_financas/repositories/categoria_despesa_mock.dart';

class CategoriaDespesaController extends ChangeNotifier {
  final CategoriaDespesaMock _bancoCategorias = CategoriaDespesaMock();

  List<Categoria> categorias = [];

  CategoriaDespesaController() {
    carregarCategorias();
  }

  void carregarCategorias() {
    categorias = _bancoCategorias.getCategorias();

    notifyListeners();
  }

  void adicionarCategoria(String nome, IconData icone, Color cor) {
    _bancoCategorias.adicionarCategoria(nome, icone, cor);
    carregarCategorias();
  }

  void editarCategoria(int index, String nome) {
    _bancoCategorias.editarCategoria(index, nome);
    carregarCategorias();
  }
}
