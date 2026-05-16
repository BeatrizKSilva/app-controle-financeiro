import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vinta_financas/models/categoria.dart';

class CategoriaReceitaController extends ChangeNotifier {
  List<Categoria> categorias = [];
  bool _defaultsAdicionados = false;

  CategoriaReceitaController() {
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
        .collection('categorias_receita')
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
      Categoria(nome: 'Salário', icone: Icons.attach_money, cor: Colors.green),
      Categoria(
          nome: 'Investimentos',
          icone: Icons.trending_up,
          cor: Colors.blue.shade700),
      Categoria(nome: 'Pix', icone: Icons.pix, cor: Colors.teal),
      Categoria(nome: 'Outros', icone: Icons.more_horiz, cor: Colors.grey),
    ];

    final batch = FirebaseFirestore.instance.batch();
    final colecao = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('categorias_receita');

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
        .collection('categorias_receita')
        .add(novaCategoria.toMap());
  }

  Future<void> editarCategoria(
      Categoria categoriaOriginal, String novoNome) async {
    final usuarioAtual = FirebaseAuth.instance.currentUser;
    if (usuarioAtual == null || categoriaOriginal.id == null) return;

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuarioAtual.uid)
        .collection('categorias_receita')
        .doc(categoriaOriginal.id)
        .update({'nome': novoNome});
  }

  Future<void> removerCategoria(Categoria categoriaOriginal) async {
    final usuarioAtual = FirebaseAuth.instance.currentUser;
    if (usuarioAtual == null || categoriaOriginal.id == null) return;

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuarioAtual.uid)
        .collection('categorias_receita')
        .doc(categoriaOriginal.id)
        .delete();
  }
}
