import 'package:flutter/material.dart';

class Categoria {
  final String nome;
  final IconData icone;
  final Color cor;

  Categoria({required this.nome, required this.icone, required this.cor});
}

class CategoriaDespesaMock {
  final List<Categoria> _categorias = [
    Categoria(
        nome: 'Compras',
        icone: Icons.shopping_cart_outlined,
        cor: Colors.orange),
    Categoria(
        nome: 'Alimentação', icone: Icons.restaurant_outlined, cor: Colors.red),
    Categoria(
        nome: 'Transporte',
        icone: Icons.directions_bus_outlined,
        cor: Colors.blue),
    Categoria(nome: 'Moradia', icone: Icons.home_outlined, cor: Colors.green),
  ];

  List<Categoria> getCategorias() => _categorias;

  void adicionarCategoria(String nome, IconData icone, Color cor) {
    _categorias.add(Categoria(nome: nome, icone: icone, cor: cor));
  }
}
