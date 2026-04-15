import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Graficos extends StatefulWidget{

  final List<Map<String, dynamic>> transacoes;
  final DateTime dataSelecionada;
  final Function(BuildContext) aoEscolherData;

  const Graficos({
    super.key,
    required this.transacoes,
    required this.dataSelecionada,
    required this.aoEscolherData,
  });

  @override
  State<Graficos> createState() => _GraficosState();

}

class _GraficosState extends State<Graficos> {

  String _tipoFiltro = 'despesa';

  final List<String> _meses = const [ 
    'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
    'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
  ];

  @override
  Widget build(BuildContext context) {

    final transacoesDoMes = widget.transacoes.where((t) {
      return t['data'].month == widget.dataSelecionada.month &&
             t['data'].year == widget.dataSelecionada.year &&
             t['tipo'] == _tipoFiltro;
    }).toList();

    Map<String, double> totaisPorCategoria = {};
    Map<String, Color> coresPorCategoria = {};
    double totalGeral = 0.0;

    for (var t in transacoesDoMes) {
      
      String nome = t['categoria'].nome;
      double valor = t['valor'];
      totaisPorCategoria[nome] = (totaisPorCategoria[nome] ?? 0) + valor;
      coresPorCategoria[nome] = t['categoria'].cor;
      totalGeral += valor;
      
    }

    return Column(

      children: [
        Container(
          color: Colors.pink.shade300,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDateSelector(),
              Row(
                children: [
                  _buildToggleBotao('Despesas', 'despesa'),
                  const SizedBox(width: 8),
                  _buildToggleBotao('Receitas', 'receita'),
                ],
              )
            ],
          ),
        ),

        Expanded(
          child: totaisPorCategoria.isEmpty
            ? Center(child: Text('Sem registros para exibir.', style: TextStyle(color: Colors.grey.shade600)))
            : Column(
                children: [
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 50,
                        sections: totaisPorCategoria.entries.map((entry) {
                          final porcentagem = (entry.value / totalGeral) * 100;
                          return PieChartSectionData(
                            color: coresPorCategoria[entry.key],
                            value: entry.value,
                            title: '${porcentagem.toStringAsFixed(1)}%',
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: totaisPorCategoria.length,
                      itemBuilder: (context, index) {
                        String nome = totaisPorCategoria.keys.elementAt(index);
                        double valor = totaisPorCategoria[nome]!;
                        return ListTile(
                          leading: Container(width: 16, height: 16, decoration: BoxDecoration(color: coresPorCategoria[nome], shape: BoxShape.circle)),
                          title: Text(nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                          trailing: Text('R\$ ${valor.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        );
                      },
                    ),
                  ),
                ],
              ),
        ),
      ],
    );
  }

  Widget _buildToggleBotao(String titulo, String valorFiltro) {
    
    bool isSelected = _tipoFiltro == valorFiltro;

    return InkWell(
      onTap: () => setState(() => _tipoFiltro = valorFiltro),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(titulo, style: TextStyle(color: Colors.white, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),    
      ),
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
      onTap: () => widget.aoEscolherData(context), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.dataSelecionada.year}', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
          Row(
            children: [
              Text(_meses[widget.dataSelecionada.month - 1], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}