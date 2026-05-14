import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transacao.dart';

class TransacaoController extends ChangeNotifier {
  List<Transacao> _transacoes = [];
  List<Transacao> get transacoes => _transacoes;

  TransacaoController() {
    _iniciarBanco();
  }

  void _iniciarBanco() {
    final usuarioAtual = FirebaseAuth.instance.currentUser;
    if (usuarioAtual == null) return;

    FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuarioAtual.uid)
        .collection('transacoes')
        .snapshots()
        .listen((snapshot) {
      _transacoes = snapshot.docs.map((documento) {
        final dadosFirebase = documento.data();
        return Transacao.fromMap(dadosFirebase, documento.id);
      }).toList();
      notifyListeners();
    });
  }

  Future<void> adicionarTransacao(Transacao novaTransacao) async {
    final usuarioAtual = FirebaseAuth.instance.currentUser;
    if (usuarioAtual == null) return;

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuarioAtual.uid)
        .collection('transacoes')
        .add(novaTransacao.toMap());
  }

  Future<void> removerTransacao(Transacao transacao) async {
    final usuarioAtual = FirebaseAuth.instance.currentUser;
    if (usuarioAtual == null || transacao.id == null) return;

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuarioAtual.uid)
        .collection('transacoes')
        .doc(transacao.id)
        .delete();
  }

  Future<void> atualizarTransacao(Transacao transacaoOriginal,
      String novoTitulo, double novoValor, DateTime novaData) async {
    final usuarioAtual = FirebaseAuth.instance.currentUser;
    if (usuarioAtual == null || transacaoOriginal.id == null) return;

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuarioAtual.uid)
        .collection('transacoes')
        .doc(transacaoOriginal.id)
        .update({
      'titulo': novoTitulo,
      'valor': novoValor,
      'data': Timestamp.fromDate(novaData),
    });
  }

  double despesasDoMes(DateTime dataSelecionada) {
    return _transacoes
        .where((t) =>
            t.tipo == 'despesa' &&
            t.data.month == dataSelecionada.month &&
            t.data.year == dataSelecionada.year)
        .fold(0.0, (soma, item) => soma + item.valor);
  }

  double receitasDoMes(DateTime dataSelecionada) {
    return _transacoes
        .where((t) =>
            t.tipo == 'receita' &&
            t.data.month == dataSelecionada.month &&
            t.data.year == dataSelecionada.year)
        .fold(0.0, (soma, item) => soma + item.valor);
  }

  double saldoDoMes(DateTime dataSelecionada) {
    return receitasDoMes(dataSelecionada) - despesasDoMes(dataSelecionada);
  }
}
