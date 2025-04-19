import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/exchange_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExchangeController>(
      builder: (context, controller, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Exchange Rates')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: switch (controller.uiState) {
              UIState.loading =>
                const Center(child: CircularProgressIndicator()),
              UIState.error => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Failed to load exchange rates.'),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: controller.fetchRates,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              UIState.success => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CurrencyDropdown(),
                    const SizedBox(height: 16),
                    Expanded(child: _RatesGrid()),
                  ],
                ),
            },
          ),
        );
      },
    );
  }
}

class _CurrencyDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.read<ExchangeController>();
    final currencies = controller.convertedRates.keys.toList()..sort();
    final selected = controller.selectedCurrency;

    return DropdownButton<String>(
      value: selected,
      isExpanded: true,
      items: currencies.map((code) {
        return DropdownMenuItem(
          value: code,
          child: Text(code),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          controller.setSelectedCurrency(value);
        }
      },
    );
  }
}

class _RatesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rates = context.watch<ExchangeController>().convertedRates;

    return GridView.builder(
      itemCount: rates.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final code = rates.keys.elementAt(index);
        final value = rates[code]!.toStringAsFixed(2);

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(code, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(value),
            ],
          ),
        );
      },
    );
  }
}
