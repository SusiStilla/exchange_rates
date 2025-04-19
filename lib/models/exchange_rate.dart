class ExchangeRate {
  final String base;
  final Map<String, double> rates;

  ExchangeRate({required this.base, required this.rates});

  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    final rawRates = json['conversion_rates'] as Map<String, dynamic>;
    final parsedRates = rawRates.map(
      (key, value) => MapEntry(key, (value as num).toDouble()),
    );

    return ExchangeRate(
      base: json['base_code'] as String,
      rates: parsedRates,
    );
  }
}
