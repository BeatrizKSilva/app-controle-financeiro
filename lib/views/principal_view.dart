import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vinta_financas/controllers/transacao_controller.dart';
import 'package:vinta_financas/views/categoria_view.dart';
import 'package:vinta_financas/views/graficos_view.dart';
import 'package:vinta_financas/views/opcoes_view.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:vinta_financas/widgets/painel_valor.dart';
import 'package:vinta_financas/views/relatorio_view.dart';

class PrincipalView extends StatefulWidget {
  const PrincipalView({super.key});

  @override
  State<PrincipalView> createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {
  int _selectedIndex = 0;
  String _filtroAtual = 'Todos';
  DateTime _dataSelecionada = DateTime.now();

  final List<String> _meses = const [
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez'
  ];

  Future<void> _escolherData(BuildContext context) async {
    int anoTemporario = _dataSelecionada.year;

    final DateTime? dataEscolhida = await showDialog<DateTime?>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 18),
                    onPressed: () => setStateDialog(() => anoTemporario--),
                  ),
                  Text('$anoTemporario',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 18),
                    onPressed: () => setStateDialog(() => anoTemporario++),
                  ),
                ],
              ),
              content: SizedBox(
                width: 300,
                height: 250,
                child: GridView.builder(
                  itemCount: 12,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.5,
                  ),
                  itemBuilder: (context, index) {
                    bool isSelected = (_dataSelecionada.month == index + 1) &&
                        (_dataSelecionada.year == anoTemporario);

                    return InkWell(
                      onTap: () => Navigator.pop(
                          context, DateTime(anoTemporario, index + 1)),
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.pink.shade300
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _meses[index].toUpperCase(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );

    if (dataEscolhida != null) {
      setState(() {
        _dataSelecionada = dataEscolhida;
      });
    }
  }

  List<Widget> _getPages(TransacaoController transacaoController) {
    return [
      Column(
        children: [
          _buildResumoHeader(transacaoController),
          Expanded(child: _buildListaTransacoes(transacaoController)),
        ],
      ),
      GraficosView(
        dataSelecionada: _dataSelecionada,
        aoEscolherData: _escolherData,
      ),
      const Center(child: Text('')),
      const Relatorio(),
      const Opcoes(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final transacaoController = context.watch<TransacaoController>();

    final pages = _getPages(transacaoController);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Finanças'),
        backgroundColor: Colors.pink.shade300,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: pages[_selectedIndex],
      floatingActionButton: Transform.translate(
        offset: const Offset(0, 15),
        child: FloatingActionButton(
          onPressed: () async {
            final bool isReceitaFiltro = _filtroAtual == 'Receitas';

            final resultado = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Categoria(
                  tituloTela: isReceitaFiltro ? "Nova Receita" : "Nova Despesa",
                  isReceita: isReceitaFiltro,
                ),
              ),
            );

            if (resultado != null && resultado is Map<String, dynamic>) {
              transacaoController.adicionarTransacao({
                'tipo': isReceitaFiltro ? 'receita' : 'despesa',
                'valor': resultado['valor'],
                'categoria': resultado['categoria'],
                'data': resultado['data'],
              });
            }
          },
          backgroundColor: Colors.pink.shade300,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.pink.shade300,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index != 2) setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart), label: 'Gráficos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add, color: Colors.transparent), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart_outlined), label: 'Relatórios'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Opções'),
        ],
      ),
    );
  }

  Widget _buildListaTransacoes(TransacaoController controller) {
    List<Map<String, dynamic>> transacoesFiltradas =
        controller.transacoes.where((t) {
      return t['data'].month == _dataSelecionada.month &&
          t['data'].year == _dataSelecionada.year;
    }).toList();

    if (_filtroAtual == 'Receitas') {
      transacoesFiltradas =
          transacoesFiltradas.where((t) => t['tipo'] == 'receita').toList();
    } else if (_filtroAtual == 'Despesas') {
      transacoesFiltradas =
          transacoesFiltradas.where((t) => t['tipo'] == 'despesa').toList();
    }

    if (transacoesFiltradas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined,
                size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 10),
            Text('Nenhum registro encontrado',
                style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: transacoesFiltradas.length,
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) {
        final transacao = transacoesFiltradas[index];
        final categoria = transacao['categoria'];
        final isReceita = transacao['tipo'] == 'receita';

        return Slidable(
          key: ValueKey(transacao.hashCode),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) async {
                  final resultado = await mostrarPainelValor(
                    context: context,
                    titulo: 'Editar valor',
                    valorInicial: transacao['valor'],
                    dataInicial: transacao['data'],
                    corBotao: Colors.orange,
                  );
                  if (resultado != null) {
                    controller.atualizarTransacao(
                        transacao, resultado['valor'], resultado['data']);
                  }
                },
                backgroundColor: Colors.orange,
                icon: Icons.edit,
                label: 'Editar',
              ),
              SlidableAction(
                onPressed: (context) => controller.removerTransacao(transacao),
                backgroundColor: Colors.red,
                icon: Icons.delete,
                label: 'Excluir',
              ),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: categoria.cor,
              child: Icon(categoria.icone, color: Colors.white),
            ),
            title: Text(categoria.nome,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
                "${transacao['data'].day}/${transacao['data'].month}/${transacao['data'].year}"),
            trailing: Text(
              '${isReceita ? '+' : '-'} R\$ ${transacao['valor'].toStringAsFixed(2)}',
              style: TextStyle(
                color: isReceita ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResumoHeader(TransacaoController controller) {
    return Container(
      color: const Color(0xFFF06292),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDateSelector(),
          _buildStatColumn('Despesas',
              controller.despesasDoMes(_dataSelecionada).toStringAsFixed(2),
              isSelected: _filtroAtual == 'Despesas',
              onTap: () => setState(() => _filtroAtual = 'Despesas')),
          _buildStatColumn('Receitas',
              controller.receitasDoMes(_dataSelecionada).toStringAsFixed(2),
              isSelected: _filtroAtual == 'Receitas',
              onTap: () => setState(() => _filtroAtual = 'Receitas')),
          _buildStatColumn('Saldo',
              controller.saldoDoMes(_dataSelecionada).toStringAsFixed(2),
              isBold: true,
              isSelected: _filtroAtual == 'Saldo',
              onTap: () => setState(() => _filtroAtual = 'Saldo')),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
      onTap: () => _escolherData(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${_dataSelecionada.year}',
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
          Row(
            children: [
              Text(_meses[_dataSelecionada.month - 1],
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const Icon(Icons.keyboard_arrow_down,
                  color: Colors.white, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String title, String value,
      {bool isBold = false, bool isSelected = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black12 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(title,
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
