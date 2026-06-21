import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CotacaoController {
  final String _apiKey = dotenv.env['AWESOME_API_KEY'] ?? '';

  Future<Map<String, String>> buscarCotacoes() async {
    try {
      final url = Uri.parse('https://economia.awesomeapi.com.br/json/last/USD-BRL,EUR-BRL');
      
      final resposta = await http.get(
        url,
        headers: {
          'x-api-key': _apiKey,
        },
      );

      if (resposta.statusCode == 200) {
        final dados = json.decode(resposta.body);
        
        String dolar = double.parse(dados['USDBRL']['bid']).toStringAsFixed(2);
        String euro = double.parse(dados['EURBRL']['bid']).toStringAsFixed(2);
        
        return {'USD': dolar, 'EUR': euro};
      } else {
        print('Erro na API: Código ${resposta.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar cotações: $e');
    }
    
    return {'USD': '---', 'EUR': '---'};
  }
}