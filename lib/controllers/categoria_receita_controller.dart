import 'package:flutter/material.dart';
import 'package:vinta_financas/repositories/categoria_receita_mock.dart';
import 'package:vinta_financas/repositories/categoria_despesa_mock.dart';

class CategoriaReceitaController extends ChangeNotifier {
  final CategoriaReceitaMock _bancoCategorias = CategoriaReceitaMock();

  List<Categoria> categorias = [];

  CategoriaReceitaController() {
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
}
