import 'dart:convert';
import 'package:check/Feature/Scene/Lista/ViewModel/StockQuotesViewModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class QuoteService {
  static const String baseUrl = 'https://brapi.dev/api';
  static const String token = 'sth7V4nEigUskBUd9UfcKV';
  Future<StockQuotesViewModel?> fetchStockQuotes() async {

    var url = Uri.parse('${baseUrl}/quote/list?token=${token}');
    try {
      var response = await http.get(url);
      if (kDebugMode) {
        print('Status da resposta: ${response.statusCode}');
        print('Resposta recebida: ${response.body}');
      }
      if (response.statusCode == 200) {
        return StockQuotesViewModel.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro na requisição: $e');
      }
      return null;
    }
  }
}
