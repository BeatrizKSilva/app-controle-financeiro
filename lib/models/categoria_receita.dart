import 'package:flutter/material.dart';
import 'categoria.dart'; // Importa a classe pai

class CategoriaReceita extends Categoria {
  bool isRendaFixa;

  CategoriaReceita({
    required super.nome,
    required super.icone,
    required super.cor,
    this.isRendaFixa = false,
  });
}
