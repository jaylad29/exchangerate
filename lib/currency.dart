class Currency {
  List<MapEntry<String, dynamic>> rates;
  String date;
  String base;

  Currency({this.rates, this.date, this.base});

  factory Currency.createJASON(Map<String, dynamic> jason) {
    return Currency(
        rates: jason["rates"].entries.toList(),
        date: jason["date"],
        base: jason["base"]);
  }
}
