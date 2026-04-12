import 'package:flutter/material.dart';
import 'package:vinta_financas/repositories/categoria_despesa_mock.dart';

class CategoriaReceitaMock {
  final List<Categoria> _categorias = [
    Categoria(nome: 'Salário', icone: Icons.attach_money, cor: Colors.green),
    Categoria(nome: 'Pix', icone: Icons.pix, cor: Colors.teal),
    Categoria(
        nome: 'Investimentos',
        icone: Icons.trending_up,
        cor: Colors.blue.shade700),
    Categoria(nome: 'Freelance', icone: Icons.computer, cor: Colors.indigo),
  ];

  List<Categoria> getCategorias() => _categorias;

  void adicionarCategoria(String nome, IconData icone, Color cor) {
    _categorias.add(Categoria(nome: nome, icone: icone, cor: cor));
  }
}
