import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> mostrarPainelValor({
  required BuildContext context,
  required String titulo,
  required Color corBotao,
  double? valorInicial,
  DateTime? dataInicial,
}) {
  TextEditingController valorController = TextEditingController(
    text: valorInicial != null ? valorInicial.toStringAsFixed(2) : '',
  );
  DateTime data = dataInicial ?? DateTime.now();

  return showModalBottomSheet<Map<String, dynamic>>(
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
                    Text(
                      titulo,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          "${data.day}/${data.month}/${data.year}",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_month, color: corBotao),
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
                      backgroundColor: corBotao,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (valorController.text.isNotEmpty) {
                        String valorTexto =
                            valorController.text.replaceAll(',', '.');
                        double valor = double.tryParse(valorTexto) ?? 0.0;

                        if (valor > 0) {
                          Navigator.pop(context, {
                            'valor': valor,
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
