import 'package:cloud_firestore/cloud_firestore.dart';

class Transacao {
  String? id;
  String titulo;
  double valor;
  DateTime data;
  String tipo;
  String categoriaId;
  String? imagemCaminho;

  Transacao({
    this.id,
    required this.titulo,
    required this.valor,
    required this.data,
    required this.tipo,
    required this.categoriaId,
    this.imagemCaminho,
  });

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'valor': valor,
      'data': Timestamp.fromDate(data),
      'tipo': tipo,
      'categoriaId': categoriaId,
      'imagemCaminho': imagemCaminho,
    };
  }

  factory Transacao.fromMap(Map<String, dynamic> map, String documentId) {
    return Transacao(
      id: documentId,
      titulo: map['titulo'] ?? '',
      valor: (map['valor'] ?? 0.0).toDouble(),
      data: (map['data'] as Timestamp).toDate(),
      tipo: map['tipo'] ?? 'despesa',
      categoriaId: map['categoriaId'] ?? '',
      imagemCaminho: map['imagemCaminho'],
    );
  }
}
