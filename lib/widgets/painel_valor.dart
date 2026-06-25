import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:vinta_financas/controllers/cotacao_controller.dart'; // IMPORT NOVO

Future<Map<String, dynamic>?> mostrarPainelValor({
  required BuildContext context,
  required String titulo,
  required Color corBotao,
  String? tituloInicial,
  double? valorInicial,
  DateTime? dataInicial,
  String? imagemInicial,
}) {
  TextEditingController tituloController = TextEditingController(
    text: tituloInicial ?? '',
  );
  TextEditingController valorController = TextEditingController(
    text: valorInicial != null ? valorInicial.toStringAsFixed(2) : '',
  );
  DateTime data = dataInicial ?? DateTime.now();
  bool isRecorrente = false;
  DateTime dataFim = DateTime(data.year, data.month + 1, data.day);
  final ImagePicker picker = ImagePicker();
  String? caminhoImagemSelecionada = imagemInicial;

  String moedaSelecionada = 'BRL';
  double taxaDolar = 1.0;
  double taxaEuro = 1.0;
  final CotacaoController cotacaoController = CotacaoController();
  final Future<Map<String, String>> futureCotacoes = cotacaoController.buscarCotacoes();

  return showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateBottomSheet) {
          Future<void> escolherImagem(ImageSource source) async {
            try {
              final XFile? foto = await picker.pickImage(
                source: source,
                imageQuality: 70,
              );
              if (foto != null) {
                setStateBottomSheet(() {
                  caminhoImagemSelecionada = foto.path;
                });
              }
            } catch (e) {
              debugPrint("Erro ao abrir câmera/galeria: $e");
            }
          }

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
                                if (dataFim.isBefore(data)) {
                                  dataFim = DateTime(
                                      data.year, data.month + 1, data.day);
                                }
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                TextField(
                  controller: tituloController,
                  decoration: InputDecoration(
                    labelText: 'Título da Transação',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                FutureBuilder<Map<String, String>>(
                  future: futureCotacoes,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Text("Buscando cotações...", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                      );
                    }
                    
                    if (snapshot.hasData) {
                      taxaDolar = double.tryParse(snapshot.data!['USD'] ?? '1.0') ?? 1.0;
                      taxaEuro = double.tryParse(snapshot.data!['EUR'] ?? '1.0') ?? 1.0;
                    }

                    String displayDolar = snapshot.data?['USD'] ?? '---';
                    String displayEuro = snapshot.data?['EUR'] ?? '---';

                    return Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Hoje: USD R\$ $displayDolar | EUR R\$ $displayEuro", 
                        style: TextStyle(color: corBotao.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.bold)
                      ),
                    );
                  }
                ),
                const SizedBox(height: 5),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: moedaSelecionada,
                          items: ['BRL', 'USD', 'EUR'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setStateBottomSheet(() {
                              moedaSelecionada = val!;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: valorController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: 'Valor',
                          prefixText: moedaSelecionada == 'BRL' ? 'R\$ ' : moedaSelecionada == 'USD' ? 'US\$ ' : '€ ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: caminhoImagemSelecionada == null
                      ? OutlinedButton.icon(
                          icon: Icon(Icons.receipt_long, color: corBotao),
                          label: Text('Anexar Comprovante / Boleto',
                              style: TextStyle(color: corBotao)),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: corBotao.withValues(alpha: 0.5)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext bottomSheetContext) {
                                return SafeArea(
                                  child: Wrap(
                                    children: [
                                      ListTile(
                                        leading:
                                            const Icon(Icons.photo_library),
                                        title:
                                            const Text('Escolher da Galeria'),
                                        onTap: () {
                                          escolherImagem(ImageSource.gallery);
                                          Navigator.of(bottomSheetContext)
                                              .pop();
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.photo_camera),
                                        title: const Text('Tirar Foto'),
                                        onTap: () {
                                          escolherImagem(ImageSource.camera);
                                          Navigator.of(bottomSheetContext)
                                              .pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child:
                                  caminhoImagemSelecionada!.startsWith('http')
                                      ? Image.network(
                                          caminhoImagemSelecionada!,
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(caminhoImagemSelecionada!),
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                            ),
                            Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 15,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.red, size: 20),
                                  onPressed: () {
                                    setStateBottomSheet(() {
                                      caminhoImagemSelecionada = null;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 10),
                CheckboxListTile(
                  title: const Text("Repetir transação?",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  value: isRecorrente,
                  activeColor: corBotao,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (valor) {
                    setStateBottomSheet(() {
                      isRecorrente = valor ?? false;
                    });
                  },
                ),
                if (isRecorrente)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: corBotao.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: corBotao.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Repetir até:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextButton.icon(
                          icon: Icon(Icons.edit_calendar, color: corBotao),
                          label: Text("${dataFim.month}/${dataFim.year}",
                              style: TextStyle(color: corBotao)),
                          onPressed: () async {
                            final DateTime? dataEscolhida =
                                await showDatePicker(
                              context: context,
                              initialDate: dataFim,
                              firstDate: data,
                              lastDate: DateTime(2100),
                            );
                            if (dataEscolhida != null) {
                              setStateBottomSheet(() {
                                dataFim = dataEscolhida;
                              });
                            }
                          },
                        )
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
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
                        double valorDigitado = double.tryParse(valorTexto) ?? 0.0;

                        if (valorDigitado > 0) {
                          
                          double valorFinalConvertido = valorDigitado;
                          if (moedaSelecionada == 'USD') {
                            valorFinalConvertido = valorDigitado * taxaDolar;
                          } else if (moedaSelecionada == 'EUR') {
                            valorFinalConvertido = valorDigitado * taxaEuro;
                          }

                          Navigator.pop(context, {
                            'titulo': tituloController.text.trim(),
                            'valor': valorFinalConvertido,
                            'data': data,
                            'dataFim': isRecorrente ? dataFim : null,
                            'imagemCaminho': caminhoImagemSelecionada,
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