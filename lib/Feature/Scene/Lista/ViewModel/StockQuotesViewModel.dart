
import 'package:check/Feature/Scene/Lista/Model/StockQuotesModel.dart';

class StockQuotesViewModel {
  List<StockQuotesModel> quotesData;

  StockQuotesViewModel({required this.quotesData});


  factory StockQuotesViewModel.fromJson(Map<String, dynamic> json) {

    var quotesList = json['stocks'] as List;

    List<StockQuotesModel> quotesData =
        quotesList.map((i) => StockQuotesModel.fromJson(i)).toList();
    return StockQuotesViewModel(quotesData: quotesData);
  }
}
