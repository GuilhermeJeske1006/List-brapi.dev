import 'package:check/Feature/Scene/Lista/Model/StockQuotesModel.dart';
import 'package:check/Service/QuoteService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:check/Feature/Scene/Lista/ViewModel/StockQuotesViewModel.dart';
import 'dart:io';

class StockQuotesView extends StatefulWidget {
  @override
  _StockQuotesViewState createState() => _StockQuotesViewState();
}

class _StockQuotesViewState extends State<StockQuotesView> {
  StockQuotesViewModel viewModel = StockQuotesViewModel(quotesData: []);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStockQuotes();
  }

  Future<void> _fetchStockQuotes() async {
    QuoteService service = QuoteService();
    try {
      StockQuotesViewModel? fetchedViewModel = await service.fetchStockQuotes();
      if (fetchedViewModel != null) {
        setState(() {
          viewModel = fetchedViewModel;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog('Failed to load stock quotes');
      }
    } on SocketException {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('No Internet connection');
    } on HttpException {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Failed to load stock quotes');
    } on FormatException {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Bad response format');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Unexpected error: $e');
    }
  }

  void _showErrorDialog(String message) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Bolsa de Valores'),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : _buildQuotesList(),
      ),
    );
  }

  Widget _buildQuotesList() {
    return ListView.builder(
      itemCount: viewModel.quotesData.length,
      itemBuilder: (context, index) {
        final quote = viewModel.quotesData[index];
        return _buildQuoteCard(quote);
      },
    );
  }

  Widget _buildQuoteCard(StockQuotesModel quote) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Verificar se a URL do logo é válida antes de carregar
                if (Uri.tryParse(quote.logo)?.isAbsolute == true)
                  SvgPicture.network(
                    quote.logo,
                    width: 24,
                    height: 24,
                    fit: BoxFit.fitHeight,
                  )
                else
                  Icon(
                    Icons.broken_image,
                    size: 24,
                    color: Colors.red,
                  ),
                SizedBox(width: 8),
                Text(
                  quote.stock,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Nome: ${quote.name}'),
            SizedBox(height: 8),
            Text('Fechamento: ${quote.close.toString()}'),
          ],
        ),
      ),
    );
  }
}