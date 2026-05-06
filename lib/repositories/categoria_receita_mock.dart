import 'package:flutter/material.dart';
import 'package:vinta_financas/models/categoria.dart';
import 'package:vinta_financas/models/categoria_receita.dart';

class CategoriaReceitaMock {
  final List<Categoria> _categorias = [
    CategoriaReceita(
      nome: 'Salário',
      icone: Icons.attach_money,
      cor: Colors.green,
      isRendaFixa: true, // Aqui usando o atributo que só a receita tem
    ),
    CategoriaReceita(
      nome: 'Pix',
      icone: Icons.pix,
      cor: Colors.teal,
    ),
    CategoriaReceita(
      nome: 'Investimentos',
      icone: Icons.trending_up,
      cor: Colors.blue.shade700,
    ),
    CategoriaReceita(
      nome: 'Freelance',
      icone: Icons.computer,
      cor: Colors.indigo,
    ),
  ];

  List<Categoria> getCategorias() => _categorias;

  void adicionarCategoria(String nome, IconData icone, Color cor) {
    _categorias.add(CategoriaReceita(nome: nome, icone: icone, cor: cor));
  }

  void editarCategoria(int index, String novoNome) {
    _categorias[index].nome = novoNome;
  }
}
