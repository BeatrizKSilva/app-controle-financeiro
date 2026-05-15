import 'package:flutter/material.dart';
import 'categoria.dart'; 

class CategoriaReceita extends Categoria {
  bool isRendaFixa;

  CategoriaReceita({
    required super.nome,
    required super.icone,
    required super.cor,
    this.isRendaFixa = false,
  });
}
