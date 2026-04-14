import 'package:flutter/material.dart';

class Categoria extends StatefulWidget {
  final String tituloTela;
  final dynamic controller;

  const Categoria(
      {super.key, required this.tituloTela, required this.controller});

  @override
  State<Categoria> createState() => _CategoriaState();
}

class _CategoriaState extends State<Categoria> {
  final List<IconData> _opcoesDeIcones = [
    Icons.shopping_bag_outlined,
    Icons.local_gas_station_outlined,
    Icons.fitness_center_outlined,
    Icons.pets_outlined,
    Icons.school_outlined,
    Icons.medical_services_outlined,
    Icons.flight_takeoff_outlined,
    Icons.movie_outlined,
  ];

  final List<Color> _opcoesDeCores = [
    Colors.purple,
    Colors.pink,
    Colors.amber,
    Colors.cyan,
    Colors.teal,
    Colors.indigo,
    Colors.brown,
  ];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _mostrarNovacategoria(BuildContext context) {
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
                      decoration: const InputDecoration(
                        hintText: "Nome da Categoria",
                      ),
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
                          onTap: () {
                            setStateDialog(() {
                              iconeSelecionado = iconeAtual;
                            });
                          },
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
                      style: TextStyle(color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () {
                    if (nomeController.text.isNotEmpty) {
                      widget.controller.adicionarCategoria(nomeController.text,
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

  void _insercaoValor(BuildContext context, dynamic categoria) {
    TextEditingController valorController = TextEditingController();

    DateTime data = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Inserir valor: ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            "${data.day}/${data.month}/${data.year}",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_month,
                                color: Colors.pink),
                            onPressed: () async {
                              final DateTime? dataEscolhida =
                                  await showDatePicker(
                                context: context,
                                initialDate: data,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );

                              if (dataEscolhida != null &&
                                  dataEscolhida != data) {
                                setStateBottomSheet(() {
                                  data = dataEscolhida;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: valorController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    autofocus: true,
                    decoration: InputDecoration(
                      prefixText: 'R\$ ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade300,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (valorController.text.isNotEmpty) {
                          String valorTexto =
                              valorController.text.replaceAll(',', '.');
                          double valor = double.tryParse(valorTexto) ?? 0.0;

                          if (valor > 0) {
                            Navigator.pop(context);
                            Navigator.pop(context, {
                              'valor': valor,
                              'categoria': categoria,
                              'data': data,
                            });
                          }
                        }
                      },
                      child: const Text('Confirmar'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tituloTela),
        backgroundColor: Colors.pink.shade300,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _mostrarNovacategoria(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecione a Categoria',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.75,
                ),
                itemCount: widget.controller.categorias.length,
                itemBuilder: (context, index) {
                  final categoria = widget.controller.categorias[index];
                  return GestureDetector(
                    onTap: () {
                      _insercaoValor(context, categoria);
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: categoria.cor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            categoria.icone,
                            color: Colors.white,
                            size: 25,
                          ),
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
