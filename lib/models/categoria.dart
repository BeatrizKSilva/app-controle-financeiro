import 'package:flutter/material.dart';

class Categoria {
  String? id;
  String nome;
  final IconData icone;
  final Color cor;

  Categoria({
    this.id,
    required this.nome,
    required this.icone,
    required this.cor,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'icone': icone.codePoint,
      'cor': cor.toARGB32(),
    };
  }

  factory Categoria.fromMap(Map<String, dynamic> map, String documentId) {
    return Categoria(
      id: documentId,
      nome: map['nome'] ?? '',
      icone: IconData(map['icone'], fontFamily: 'MaterialIcons'),
      cor: Color(map['cor']),
    );
  }
}
