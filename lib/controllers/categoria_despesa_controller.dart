import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vinta_financas/models/categoria.dart';

class CategoriaDespesaController extends ChangeNotifier {
  List<Categoria> categorias = [];
  bool _defaultsAdicionados = false;

  CategoriaDespesaController() {
    FirebaseAuth.instance.authStateChanges().listen((usuario) {
      if (usuario != null) {
        _iniciarBanco(usuario.uid);
      } else {
        categorias = [];
        notifyListeners();
      }
    });
  }

  void _iniciarBanco(String uid) {
    FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('categorias_despesa')
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.docs.isEmpty && !_defaultsAdicionados) {
        _defaultsAdicionados = true;
        await _criarCategoriasPadrao(uid);
        return; 
      }

      categorias = snapshot.docs.map((documento) {
        return Categoria.fromMap(documento.data(), documento.id);
      }).toList();
      notifyListeners();
    });
  }

  Future<void> _criarCategoriasPadrao(String uid) async {
    final categoriasPadrao = [
      Categoria(
          nome: 'Compras',
          icone: Icons.shopping_bag_outlined,
          cor: Colors.purple),
      Categoria(nome: 'Comida', icone: Icons.restaurant, cor: Colors.orange),
      Categoria(
          nome: 'Beleza',
          icone: Icons.face_retouching_natural,
          cor: Colors.pink),
      Categoria(
          nome: 'Esportes', icone: Icons.fitness_center, cor: Colors.cyan),
      Categoria(nome: 'Lazer', icone: Icons.celebration, cor: Colors.amber),
      Categoria(
          nome: 'Transporte',
          icone: Icons.directions_car_outlined,
          cor: Colors.blue),
      Categoria(nome: 'Moradia', icone: Icons.home_outlined, cor: Colors.teal),
      Categoria(
          nome: 'Saúde',
          icone: Icons.medical_services_outlined,
          cor: Colors.green),
    ];

    final batch = FirebaseFirestore.instance.batch();
    final colecao = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('categorias_despesa');

    for (var cat in categoriasPadrao) {
      final docRef = colecao.doc(); 
      batch.set(docRef, cat.toMap()); 
    }

    await batch.commit(); 
  }

  Future<void> adicionarCategoria(
      String nome, IconData icone, Color cor) async {
    final usuarioAtual = FirebaseAuth.instance.currentUser;
    if (usuarioAtual == null) return;

    Categoria novaCategoria = Categoria(nome: nome, icone: icone, cor: cor);

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuarioAtual.uid)
        .collection('categorias_despesa')
        .add(novaCategoria.toMap());
  }

  Future<void> editarCategoria(
      Categoria categoriaOriginal, String novoNome) async {
    final usuarioAtual = FirebaseAuth.instance.currentUser;
    if (usuarioAtual == null) return;
    if (categoriaOriginal.id == null) return;

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuarioAtual.uid)
        .collection('categorias_despesa')
        .doc(categoriaOriginal.id)
        .update({'nome': novoNome});
  }

  Future<void> removerCategoria(Categoria categoriaOriginal) async {
    final usuarioAtual = FirebaseAuth.instance.currentUser;
    if (usuarioAtual == null || categoriaOriginal.id == null) return;

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuarioAtual.uid)
        .collection('categorias_despesa')
        .doc(categoriaOriginal.id)
        .delete();
  }
}
