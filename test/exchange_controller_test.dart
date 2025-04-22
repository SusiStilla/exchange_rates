import 'package:flutter_test/flutter_test.dart';
import 'package:exchange_rates/controllers/exchange_controller.dart';
import 'package:exchange_rates/models/exchange_rate.dart';

void main() {
  group('ExchangeController', () {
    late ExchangeController controller;

    setUp(() {
      controller = ExchangeController();
    });

    test('Conversion from USD to EUR and JPY is correct', () {
      // Simulated USD-based exchange rates
      final mockRates = ExchangeRate(
        base: 'USD',
        rates: {
          'USD': 1.0,
          'EUR': 0.9,
          'JPY': 135.0,
        },
      );

      // Inject mock data directly
      controller
        ..setSelectedCurrency('EUR')
        ..setAmount('2.0');

      controller.testInjectRates(mockRates);

      final result = controller.convertedRates;

      expect(result['JPY']!.toStringAsFixed(2), '300.00'); // 135 / 0.9 * 2
      expect(result['USD']!.toStringAsFixed(2), '2.22'); // 1 / 0.9 * 2
    });

    test('Handles invalid input amount gracefully', () {
      controller.setAmount('abc'); // Invalid input
      expect(controller.amount, 1.0);
    });
  });
}
