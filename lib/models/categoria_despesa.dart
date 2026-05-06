import 'package:flutter/material.dart';
import 'categoria.dart'; 

class CategoriaDespesa extends Categoria {
  double? limiteMensal;

  CategoriaDespesa({
    required super.nome,
    required super.icone,
    required super.cor,
    this.limiteMensal,
  });
}
