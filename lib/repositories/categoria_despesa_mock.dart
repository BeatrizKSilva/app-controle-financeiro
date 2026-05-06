import 'package:flutter/material.dart';
import 'package:vinta_financas/models/categoria_despesa.dart';
import 'package:vinta_financas/models/categoria.dart';

class CategoriaDespesaMock {
  final List<Categoria> _categorias = [
    CategoriaDespesa(
        nome: 'Compras',
        icone: Icons.shopping_cart_outlined,
        cor: Colors.orange),
    CategoriaDespesa(
        nome: 'Alimentação', icone: Icons.restaurant_outlined, cor: Colors.red),
    CategoriaDespesa(
        nome: 'Transporte',
        icone: Icons.directions_bus_outlined,
        cor: Colors.blue),
    CategoriaDespesa(
        nome: 'Moradia', icone: Icons.home_outlined, cor: Colors.green),
  ];

  List<Categoria> getCategorias() => _categorias;

  void adicionarCategoria(String nome, IconData icone, Color cor) {
    _categorias.add(CategoriaDespesa(nome: nome, icone: icone, cor: cor));
  }

  void editarCategoria(int index, String novoNome) {
    _categorias[index].nome = novoNome;
  }
}
