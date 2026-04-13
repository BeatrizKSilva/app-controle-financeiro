import 'package:flutter/material.dart';
import 'package:vinta_financas/controllers/categoria_despesa_controller.dart';
import 'package:vinta_financas/controllers/categoria_receita_controller.dart';
import 'package:vinta_financas/views/categoria.dart';
import 'package:vinta_financas/views/opcoes.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  int _selectedIndex = 0;
  String _filtroAtual = 'Todos';

  final CategoriaReceitaController _receitaController =
      CategoriaReceitaController();
  final CategoriaDespesaController _despesaController =
      CategoriaDespesaController();

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

  double _totalDespesas = 0.0;
  double _totalReceitas = 0.0;
  double get _saldo => _totalReceitas - _totalDespesas;

  List<Map<String, dynamic>> _transacoes = [];

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
                    highlightColor: Colors.pink.shade100,
                    splashColor: Colors.pink.shade200,
                  ),
                  Text(
                    '$anoTemporario',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 18),
                    onPressed: () => setStateDialog(() => anoTemporario++),
                    highlightColor: Colors.pink.shade100,
                    splashColor: Colors.pink.shade200,
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
                      onTap: () {
                        Navigator.pop(
                            context, DateTime(anoTemporario, index + 1));
                      },
                      borderRadius: BorderRadius.circular(8),
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
                            fontSize: 14,
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

  List<Widget> get _pages => [
        Column(
          children: [
            _buildResumoHeader(),
            Expanded(
              child: Container(
                color: Colors.grey.shade100,
                child: _buildListaTransacoes(),
              ),
            ),
          ],
        ),
        const Center(child: Text('Gráficos', style: TextStyle(fontSize: 24))),
        const Center(child: Text('')),
        const Center(child: Text('Relatórios', style: TextStyle(fontSize: 24))),
        Opcoes(
          receitaController: _receitaController,
          despesaController: _despesaController,
        ),
      ];

  void _onItemTapped(int index) {
    if (index == 2) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //barra superior
      appBar: AppBar(
        title: const Text('Minhas Finanças'),
        backgroundColor: Colors.pink.shade300,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      //corpo da tela
      body: _pages[_selectedIndex],

      //botão flutuante
      floatingActionButton: Transform.translate(
        offset: const Offset(0,
            15), // se quiser alterar a posição do botão, basta mudar os valores de x e y

        child: FloatingActionButton(
          onPressed: () async {
            if (_filtroAtual == 'Receitas') {
              final resultado = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Categoria(
                    tituloTela: "Nova Receita",
                    controller: _receitaController,
                  ),
                ),
              );

              if (resultado != null && resultado is Map) {
                setState(() {
                  _totalReceitas += resultado['valor'];
                  _transacoes.add({
                    'tipo': 'receita',
                    'valor': resultado['valor'],
                    'categoria': resultado['categoria'],
                    'data': resultado['data'],
                  });
                });
              }
            } else {
              final resultado = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Categoria(
                    tituloTela: "Nova Despesa",
                    controller: _despesaController,
                  ),
                ),
              );
              if (resultado != null && resultado is Map) {
                setState(() {
                  _totalDespesas += resultado['valor'];
                  _transacoes.add({
                    'tipo': 'despesa', // Para sabermos a cor depois
                    'valor': resultado['valor'],
                    'categoria': resultado['categoria'],
                    'data': resultado['data'],
                  });
                });
              }
            }
          },
          backgroundColor: Colors.pink.shade300,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      //barra inferior
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // fundo branco
        selectedItemColor: Colors.pink.shade300, // icone clicado fica rosa
        unselectedItemColor: Colors.grey, //icone solto fica cinza
        type: BottomNavigationBarType.fixed,

        selectedFontSize: 13.0, //tamanho da fonte do item selecionado
        unselectedFontSize: 11.0, //tamanho da fonte do item não selecionado

        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart), label: 'Gráficos'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Colors.transparent),
            label: '',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart_outlined), label: 'Relatórios'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Opções'),
        ],
      ),
    );
  }

  Widget _buildListaTransacoes() {
    List<Map<String, dynamic>> transacoesFiltradas = _transacoes;
    if (_filtroAtual == 'Receitas') {
      transacoesFiltradas =
          _transacoes.where((t) => t['tipo'] == 'receita').toList();
    } else if (_filtroAtual == 'Despesas') {
      transacoesFiltradas =
          _transacoes.where((t) => t['tipo'] == 'despesa').toList();
    }
    if (transacoesFiltradas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined,
                size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 10),
            Text(
              _filtroAtual == 'Todos' || _filtroAtual == 'Saldo'
                  ? 'Nenhum registro encontrado'
                  : 'Não há registros de $_filtroAtual',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
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

        return Container(
          decoration: BoxDecoration(
            color: Colors.white, // Fundo branco contínuo
            border: Border(
              // Linha sutil na parte de baixo para separar os itens da lista
              bottom: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              height: 45,
              width: 45,
              decoration:
                  BoxDecoration(color: categoria.cor, shape: BoxShape.circle),
              child: Icon(categoria.icone, color: Colors.white),
            ),
            title: Text(
              categoria.nome,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              "${transacao['data'].day}/${transacao['data'].month}/${transacao['data'].year}",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            trailing: Text(
              '${isReceita ? '+' : '-'} R\$ ${transacao['valor'].toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResumoHeader() {
    return Container(
      color: const Color(0xFFF06292),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildDateSelector(),
          _buildStatColumn(
              'Despesas', _totalDespesas.toStringAsFixed(2), Colors.white,
              isSelected: _filtroAtual == 'Despesas', onTap: () {
            setState(() {
              _filtroAtual = 'Despesas';
            });
          }),
          _buildStatColumn(
              'Receitas', _totalReceitas.toStringAsFixed(2), Colors.white,
              isSelected: _filtroAtual == 'Receitas', onTap: () {
            setState(() {
              _filtroAtual = 'Receitas';
            });
          }),
          _buildStatColumn('Saldo', _saldo.toStringAsFixed(2), Colors.white,
              isBold: true, isSelected: _filtroAtual == 'Saldo', onTap: () {
            setState(() {
              _filtroAtual = 'Saldo';
            });
          }),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
      onTap: () => _escolherData(context),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_dataSelecionada.year}',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
            ),
            Row(
              children: [
                Text(
                  _meses[_dataSelecionada.month - 1],
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.keyboard_arrow_down,
                    color: Colors.white, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String title, String value, Color color,
      {bool isBold = false, bool isSelected = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.black.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              title,
              style:
                  TextStyle(color: color.withValues(alpha: 0.8), fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
