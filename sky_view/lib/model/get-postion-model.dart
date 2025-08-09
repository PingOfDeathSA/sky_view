class GetPositionModel {
  final String name;
  final String start_date;
  final String end_date;
  final String symbol;
  final double ra;
  final double de;

  GetPositionModel({
    required this.name,
    required this.start_date,
    required this.end_date,
    required this.symbol,
    required this.ra,
    required this.de,
  });

  factory GetPositionModel.fromMap(Map<String, dynamic> map) {
    return GetPositionModel(
      name: map['name'] ?? '',
      start_date: map['start_date'] ?? '',
      end_date: map['end_date'] ?? '',
      symbol: map['symbol'] ?? '',
      ra: map['ra'] ?? 0,
      de: map['de'] ?? 0,
    );
  }
}
