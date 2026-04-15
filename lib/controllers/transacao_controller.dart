import 'package:flutter/material.dart';

class TransacaoController extends ChangeNotifier {
  final List<Map<String, dynamic>> _transacoes = [];

  List<Map<String, dynamic>> get transacoes => _transacoes;

  void adicionarTransacao(Map<String, dynamic> novaTransacao) {
    _transacoes.add(novaTransacao);
    notifyListeners(); // O megafone! Avisa a tela que algo mudou.
  }

  void removerTransacao(Map<String, dynamic> transacao) {
    _transacoes.remove(transacao);
    notifyListeners();
  }

  void atualizarTransacao(Map<String, dynamic> transacaoOriginal,
      double novoValor, DateTime novaData) {
    // Como os Maps são por referência, se mudarmos aqui, muda na lista toda!
    transacaoOriginal['valor'] = novoValor;
    transacaoOriginal['data'] = novaData;
    notifyListeners();
  }

  double despesasDoMes(DateTime dataSelecionada) {
    return _transacoes
        .where((t) =>
            t['tipo'] == 'despesa' &&
            t['data'].month == dataSelecionada.month &&
            t['data'].year == dataSelecionada.year)
        .fold(0.0, (soma, item) => soma + item['valor']);
  }

  double receitasDoMes(DateTime dataSelecionada) {
    return _transacoes
        .where((t) =>
            t['tipo'] == 'receita' &&
            t['data'].month == dataSelecionada.month &&
            t['data'].year == dataSelecionada.year)
        .fold(0.0, (soma, item) => soma + item['valor']);
  }

  double saldoDoMes(DateTime dataSelecionada) {
    return receitasDoMes(dataSelecionada) - despesasDoMes(dataSelecionada);
  }
}
