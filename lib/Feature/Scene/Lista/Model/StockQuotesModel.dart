class StockQuotesModel {
  final String stock;
  final String name;
  final double close;
  final String logo;

  StockQuotesModel({
    required this.stock,
    required this.name,
    required this.close,
    required this.logo,
  });

  factory StockQuotesModel.fromJson(Map<String, dynamic> json) {
    
    return StockQuotesModel(
      stock: json['stock'] as String? ?? '',
      name: json['name'] as String? ?? '',
      close: (json['close'] as num?)?.toDouble() ?? 0.0,
      logo: json['logo'] as String? ?? '',
    );
  }
}
