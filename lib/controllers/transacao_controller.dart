import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vinta_financas/models/transacao.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

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

  Future<String?> _fazerUploadImagem(String? caminhoLocal) async {
    if (caminhoLocal == null) return null;
    if (caminhoLocal.startsWith('http')) return caminhoLocal;

    try {
      final usuarioAtual = FirebaseAuth.instance.currentUser;
      if (usuarioAtual == null) return null;

      File arquivoImagem = File(caminhoLocal);
      String nomeArquivo = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      Reference pastaNoFirebase = FirebaseStorage.instance
          .ref()
          .child('usuarios')
          .child(usuarioAtual.uid)
          .child('comprovantes')
          .child(nomeArquivo);

      UploadTask tarefaUpload = pastaNoFirebase.putFile(arquivoImagem);
      TaskSnapshot snapshot = await tarefaUpload;

      String urlDownload = await snapshot.ref.getDownloadURL();
      return urlDownload;
    } catch (e) {
      debugPrint('Erro ao fazer upload da imagem: $e');
      return null;
    }
  }

  Future<void> _apagarImagemSeOrfa(String? urlImagem) async {
    if (urlImagem == null || !urlImagem.startsWith('http')) return;

    final usuarioAtual = FirebaseAuth.instance.currentUser;
    if (usuarioAtual == null) return;

    try {
      final ocorrencias = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(usuarioAtual.uid)
          .collection('transacoes')
          .where('imagemCaminho', isEqualTo: urlImagem)
          .get();
      if (ocorrencias.docs.isEmpty) {
        Reference fotoRef = FirebaseStorage.instance.refFromURL(urlImagem);
        await fotoRef.delete();
        debugPrint('Imagem órfã apagada com sucesso do Storage!');
      }
    } catch (e) {
      debugPrint('Erro ao tentar excluir imagem do Storage: $e');
    }
  }

  Future<void> adicionarTransacao(Transacao novaTransacao) async {
    final usuarioAtual = FirebaseAuth.instance.currentUser;
    if (usuarioAtual == null) return;
    novaTransacao.imagemCaminho =
        await _fazerUploadImagem(novaTransacao.imagemCaminho);

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuarioAtual.uid)
        .collection('transacoes')
        .add(novaTransacao.toMap());
  }

  Future<void> adicionarTransacoesRecorrentes(
      Transacao transacaoBase, DateTime dataFim) async {
    final usuarioAtual = FirebaseAuth.instance.currentUser;
    if (usuarioAtual == null) return;
    String? linkImagemNuvem =
        await _fazerUploadImagem(transacaoBase.imagemCaminho);

    final batch = FirebaseFirestore.instance.batch();
    final colecao = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuarioAtual.uid)
        .collection('transacoes');

    DateTime dataAtual = transacaoBase.data;

    int diferencaMeses = ((dataFim.year - dataAtual.year) * 12) +
        (dataFim.month - dataAtual.month);

    if (diferencaMeses < 0) diferencaMeses = 0;

    for (int i = 0; i <= diferencaMeses; i++) {
      final docRef = colecao.doc();

      final novaTransacao = Transacao(
        titulo: transacaoBase.titulo,
        valor: transacaoBase.valor,
        tipo: transacaoBase.tipo,
        categoriaId: transacaoBase.categoriaId,
        data: dataAtual,
        imagemCaminho: linkImagemNuvem,
      );

      batch.set(docRef, novaTransacao.toMap());

      int novoMes = dataAtual.month + 1;
      int novoAno = dataAtual.year;
      if (novoMes > 12) {
        novoMes = 1;
        novoAno++;
      }

      int diaOriginal = transacaoBase.data.day;
      int ultimoDiaDoNovoMes = DateTime(novoAno, novoMes + 1, 0).day;
      int diaSeguro =
          diaOriginal > ultimoDiaDoNovoMes ? ultimoDiaDoNovoMes : diaOriginal;

      dataAtual = DateTime(novoAno, novoMes, diaSeguro);
    }
    await batch.commit();
  }

  Future<void> removerTransacao(Transacao transacao) async {
    final usuarioAtual = FirebaseAuth.instance.currentUser;
    if (usuarioAtual == null || transacao.id == null) return;
    String? imagemParaVerificar = transacao.imagemCaminho;

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuarioAtual.uid)
        .collection('transacoes')
        .doc(transacao.id)
        .delete();

    await _apagarImagemSeOrfa(imagemParaVerificar);
  }

  Future<void> atualizarTransacao(
      Transacao transacaoOriginal,
      String novoTitulo,
      double novoValor,
      DateTime novaData,
      String? novaImagemCaminho) async {
    final usuarioAtual = FirebaseAuth.instance.currentUser;
    if (usuarioAtual == null || transacaoOriginal.id == null) return;

    String? linkImagemFinal = transacaoOriginal.imagemCaminho;
    String? imagemAntigaParaVerificar;

    if (novaImagemCaminho != transacaoOriginal.imagemCaminho) {

      imagemAntigaParaVerificar = transacaoOriginal.imagemCaminho;

      if (novaImagemCaminho != null && !novaImagemCaminho.startsWith('http')) {
        linkImagemFinal = await _fazerUploadImagem(novaImagemCaminho);
      } else if (novaImagemCaminho == null) {
        linkImagemFinal = null;
      }
    }

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuarioAtual.uid)
        .collection('transacoes')
        .doc(transacaoOriginal.id)
        .update({
      'titulo': novoTitulo,
      'valor': novoValor,
      'data': Timestamp.fromDate(novaData),
      'imagemCaminho': linkImagemFinal,
    });

    if (imagemAntigaParaVerificar != null) {
      await _apagarImagemSeOrfa(imagemAntigaParaVerificar);
    }
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
