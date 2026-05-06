import 'package:flutter/material.dart';
import 'package:vinta_financas/models/categoria.dart'; 
import 'package:vinta_financas/repositories/categoria_receita_mock.dart';

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

  void editarCategoria(int index, String nome) {
    _bancoCategorias.editarCategoria(index, nome);
    carregarCategorias();
  }
}
