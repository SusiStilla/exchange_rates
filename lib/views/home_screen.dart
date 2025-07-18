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
          appBar: AppBar(
            title: const Align(
              alignment: Alignment.centerLeft,
              child: Text('Currency Converter'),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: switch (controller.uiState) {
                UIState.loading =>
                  const Center(child: CircularProgressIndicator()),
                UIState.error => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                      const _CurrencyInputSection(),
                      const SizedBox(height: 16),
                      Expanded(child: _RatesGrid()),
                    ],
                  ),
              },
            ),
          ),
        );
      },
    );
  }
}

class _CurrencyInputSection extends StatelessWidget {
  const _CurrencyInputSection();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ExchangeController>();
    final currencies = controller.convertedRates.keys.toList()..sort();
    final selected = controller.selectedCurrency;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          initialValue: controller.amount.toStringAsFixed(2),
          decoration: const InputDecoration(
            labelText: 'Amount',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onChanged: controller.setAmount,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: selected,
          decoration: const InputDecoration(
            labelText: 'Select the currency',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
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
        ),
      ],
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
        crossAxisCount: 3,
        childAspectRatio: 0.9,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final code = rates.keys.elementAt(index);
        final value = rates[code]!.toStringAsFixed(2);

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent,
              ),
              alignment: Alignment.center,
              child: Text(
                code,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
