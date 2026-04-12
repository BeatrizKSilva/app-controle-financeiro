import 'package:flutter/material.dart';
import 'package:vinta_financas/views/categoria.dart';
import 'package:vinta_financas/controllers/categoria_despesa_controller.dart';
import 'package:vinta_financas/controllers/categoria_receita_controller.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  int _selectedIndex = 0;

  String _filtroAtual = 'Todos';

  List<Widget> get _pages => [
        Column(
          children: [
            _buildResumoHeader(),
            Expanded(
              child: Container(
                color: Colors.grey.shade100,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment_outlined,
                          size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 10),
                      Text(
                        _filtroAtual == 'Todos'
                            ? 'Nenhum registro encontrado'
                            : 'Não há registros de $_filtroAtual',
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const Center(child: Text('Início', style: TextStyle(fontSize: 24))),
        const Center(child: Text('Gráficos', style: TextStyle(fontSize: 24))),
        const Center(child: Text('')),
        const Center(child: Text('Relatórios', style: TextStyle(fontSize: 24))),
        const Center(child: Text('Opções', style: TextStyle(fontSize: 24))),
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
          onPressed: () {
            if (_filtroAtual == 'Despesas') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Categoria(
                    tituloTela: "Nova Despesa",
                    controller: CategoriaDespesaController(),
                  ),
                ),
              );
            } else if (_filtroAtual == 'Receitas') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Categoria(
                    tituloTela: "Nova Receita",
                    controller: CategoriaReceitaController(),
                  ),
                ),
              );
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

  Widget _buildResumoHeader() {
    return Container(
      color: const Color(0xFFF06292),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildDateSelector(),
          _buildStatColumn('Despesas', '0', Colors.white, onTap: () {
            setState(() {
              _filtroAtual = 'Despesas';
            });
          }),
          _buildStatColumn('Receitas', '0', Colors.white, onTap: () {
            setState(() {
              _filtroAtual = 'Receitas';
            });
          }),
          _buildStatColumn('Saldo', '0', Colors.white, isBold: true, onTap: () {
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
      onTap: () {
        print("Seletor de data clicado!");
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '2026',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
            ),
            const Row(
              children: [
                Text(
                  'abr.',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String title, String value, Color color,
      {bool isBold = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
