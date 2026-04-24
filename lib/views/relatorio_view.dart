import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vinta_financas/controllers/transacao_controller.dart';

class Relatorio extends StatefulWidget {
  const Relatorio({super.key});

  @override
  State<Relatorio> createState() => _RelatorioState();
}

class _RelatorioState extends State<Relatorio> {
  String _anoSelecionado = DateTime.now().year.toString();

  final List<String> _nomeMeses = [
    'JAN',
    'FEV',
    'MAR',
    'ABR',
    'MAI',
    'JUN',
    'JUL',
    'AGO',
    'SET',
    'OUT',
    'NOV',
    'DEZ'
  ];
  List<String> _getAnosDisponiveis(List<Map<String, dynamic>> transacoes) {
    Set<String> anos = {'Todos'};
    for (var t in transacoes) {
      anos.add(t['data'].year.toString());
    }
    List<String> listaAnos = anos.toList();
    listaAnos.sort((a, b) => b.compareTo(a));
    listaAnos.remove('Todos');
    listaAnos.insert(0, 'Todos');
    return listaAnos;
  }

  List<Map<String, dynamic>> _getDadosMensais(
      List<Map<String, dynamic>> transacoes) {
    List<Map<String, dynamic>> resumo = List.generate(12, (index) {
      return {'mes': index + 1, 'receita': 0.0, 'despesa': 0.0, 'saldo': 0.0};
    });

    Iterable<Map<String, dynamic>> transacoesFiltradas = transacoes;
    if (_anoSelecionado != 'Todos') {
      transacoesFiltradas = transacoesFiltradas
          .where((t) => t['data'].year.toString() == _anoSelecionado);
    }
    for (var t in transacoesFiltradas) {
      int indiceMes = t['data'].month - 1;
      double valor = t['valor'];

      if (t['tipo'] == 'receita') {
        resumo[indiceMes]['receita'] += valor;
        resumo[indiceMes]['saldo'] += valor;
      } else {
        resumo[indiceMes]['despesa'] += valor;
        resumo[indiceMes]['saldo'] -= valor;
      }
    }
    return resumo;
  }

  @override
  Widget build(BuildContext context) {
    final transacoes = context.watch<TransacaoController>().transacoes;

    final opcoesDeFiltro = _getAnosDisponiveis(transacoes);
    if (!opcoesDeFiltro.contains(_anoSelecionado)) {
      _anoSelecionado = 'Todos'; // Reset de segurança
    }
    final dadosProntos = _getDadosMensais(transacoes);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Balanço Mensal',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.pink.shade200),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _anoSelecionado,
                    icon: Icon(Icons.keyboard_arrow_down,
                        color: Colors.pink.shade300),
                    style: TextStyle(
                        color: Colors.pink.shade700,
                        fontWeight: FontWeight.bold),
                    onChanged: (String? novoValor) {
                      if (novoValor != null) {
                        setState(() {
                          _anoSelecionado = novoValor;
                        });
                      }
                    },
                    items: opcoesDeFiltro
                        .map<DropdownMenuItem<String>>((String valor) {
                      return DropdownMenuItem<String>(
                          value: valor, child: Text(valor));
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                  flex: 2,
                  child: Text('Mês',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey))),
              Expanded(
                  flex: 3,
                  child: Text('Receitas',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600))),
              Expanded(
                  flex: 3,
                  child: Text('Despesas',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600))),
              const Expanded(
                  flex: 3,
                  child: Text('Saldo',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey))),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: dadosProntos.length,
            itemBuilder: (context, index) {
              final mesCalculado = dadosProntos[index];
              if (mesCalculado['receita'] == 0 && mesCalculado['despesa'] == 0)
                return const SizedBox.shrink();

              String nomeMes = _nomeMeses[mesCalculado['mes'] - 1];
              double receita = mesCalculado['receita'];
              double despesa = mesCalculado['despesa'];
              double saldo = mesCalculado['saldo'];
              String textoSaldo = saldo < 0
                  ? '- R\$ ${saldo.abs().toStringAsFixed(2)}'
                  : 'R\$ ${saldo.toStringAsFixed(2)}';

              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text(nomeMes,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14))),
                    Expanded(
                        flex: 3,
                        child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Text('+ R\$ ${receita.toStringAsFixed(2)}',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600)))),
                    Expanded(
                        flex: 3,
                        child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Text('- R\$ ${despesa.toStringAsFixed(2)}',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600)))),
                    Expanded(
                        flex: 3,
                        child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Text(textoSaldo,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: saldo >= 0
                                        ? Colors.blue.shade700
                                        : Colors.red.shade700,
                                    fontWeight: FontWeight.bold)))),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
