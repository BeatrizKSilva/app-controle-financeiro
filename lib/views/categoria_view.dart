import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vinta_financas/widgets/painel_valor.dart';
import 'package:vinta_financas/controllers/categoria_receita_controller.dart';
import 'package:vinta_financas/controllers/categoria_despesa_controller.dart';

class Categoria extends StatefulWidget {
  final String tituloTela;
  final bool isReceita;

  const Categoria({
    super.key,
    required this.tituloTela,
    required this.isReceita,
  });

  @override
  State<Categoria> createState() => _CategoriaState();
}

class _CategoriaState extends State<Categoria> {
  final List<IconData> _opcoesDeIcones = [
// Alimentação e Compras
    Icons.shopping_cart_outlined, Icons.shopping_bag_outlined,
    Icons.restaurant_outlined, Icons.local_cafe_outlined,
    Icons.fastfood_outlined,
    // Transporte e Contas
    Icons.directions_car_outlined, Icons.directions_bus_outlined,
    Icons.local_gas_station_outlined, Icons.flight_takeoff_outlined,
    Icons.home_outlined, Icons.water_drop_outlined,
    Icons.electric_bolt_outlined, Icons.wifi_outlined,
    // Saúde, Beleza e Esportes
    Icons.medical_services_outlined, Icons.fitness_center_outlined,
    Icons.face_retouching_natural, Icons.spa_outlined,
    // Educação, Lazer e Pets
    Icons.school_outlined, Icons.menu_book_outlined,
    Icons.movie_outlined, Icons.sports_esports_outlined,
    Icons.palette_outlined, Icons.music_note_outlined,
    Icons.pets_outlined, Icons.child_care_outlined,
    // Finanças e Trabalho
    Icons.attach_money, Icons.credit_card_outlined,
    Icons.work_outline, Icons.trending_up,
    // Outros
    Icons.card_giftcard_outlined, Icons.category_outlined, Icons.more_horiz,
  ];

  final List<Color> _opcoesDeCores = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow.shade700,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.blueGrey,
    Colors.grey.shade700,
    Colors.black87
  ];

  void _mostrarNovacategoria(BuildContext context, dynamic controllerAtivo) {
    TextEditingController nomeController = TextEditingController();
    IconData iconeSelecionado = _opcoesDeIcones[0];
    Color corSelecionada = _opcoesDeCores[0];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Criar Nova Categoria'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nomeController,
                      decoration:
                          const InputDecoration(hintText: "Nome da Categoria"),
                      autofocus: true,
                    ),
                    const SizedBox(height: 20),
                    const Text("Escolha um icone:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _opcoesDeIcones.map((iconeAtual) {
                        final bool isSelecionado =
                            iconeAtual == iconeSelecionado;
                        return GestureDetector(
                          onTap: () => setStateDialog(
                              () => iconeSelecionado = iconeAtual),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelecionado
                                  ? Colors.pink.shade100
                                  : Colors.grey.shade100,
                              shape: BoxShape.circle,
                              border: isSelecionado
                                  ? Border.all(color: Colors.pink, width: 2)
                                  : null,
                            ),
                            child: Icon(iconeAtual,
                                color: isSelecionado
                                    ? Colors.pink
                                    : Colors.grey.shade700),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text("Cor:"),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _opcoesDeCores.map((cor) {
                        final bool isSelecionada = cor == corSelecionada;
                        return GestureDetector(
                          onTap: () =>
                              setStateDialog(() => corSelecionada = cor),
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: cor,
                              shape: BoxShape.circle,
                              border: isSelecionada
                                  ? Border.all(color: Colors.black, width: 3)
                                  : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar',
                        style: TextStyle(color: Colors.grey))),
                TextButton(
                  onPressed: () {
                    if (nomeController.text.isNotEmpty) {
                      controllerAtivo.adicionarCategoria(nomeController.text,
                          iconeSelecionado, corSelecionada);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Adicionar',
                      style: TextStyle(color: Colors.pink)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _insercaoValor(BuildContext context, dynamic categoria) async {
    final resultado = await mostrarPainelValor(
        context: context,
        titulo: 'Inserir Valor',
        corBotao: Colors.pink.shade300);

    if (resultado != null && context.mounted) {
      Navigator.pop(context, {
        'titulo': resultado['titulo'],
        'valor': resultado['valor'],
        'categoria': categoria,
        'data': resultado['data'],
        'dataFim': resultado['dataFim'],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Busca o controller correto baseado no booleano
    final dynamic controller = widget.isReceita
        ? context.watch<CategoriaReceitaController>()
        : context.watch<CategoriaDespesaController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tituloTela),
        backgroundColor: Colors.pink.shade300,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _mostrarNovacategoria(context, controller),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.category_outlined,
                      color: Colors.pink.shade300, size: 24),
                ),
                const SizedBox(width: 15),
                Text(
                  'Selecione a Categoria',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.75,
                ),
                itemCount: controller.categorias.length,
                itemBuilder: (context, index) {
                  final categoria = controller.categorias[index];
                  return GestureDetector(
                    onTap: () => _insercaoValor(context, categoria),
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: categoria.cor, shape: BoxShape.circle),
                          child: Icon(categoria.icone,
                              color: Colors.white, size: 25),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          categoria.nome,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
