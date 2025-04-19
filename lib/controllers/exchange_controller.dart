import 'package:flutter/material.dart';
import '../models/exchange_rate.dart';
import '../services/exchange_api.dart';

enum UIState { loading, success, error }

class ExchangeController extends ChangeNotifier {
  UIState _uiState = UIState.loading;
  String _selectedCurrency = 'USD';
  ExchangeRate? _usdRates;

  UIState get uiState => _uiState;
  String get selectedCurrency => _selectedCurrency;
  Map<String, double> get convertedRates => _convertRates();

  // Load from cache or fetch from API
  Future<void> fetchRates() async {
    _uiState = UIState.loading;
    notifyListeners();

    try {
      _usdRates = await ExchangeApi.loadCachedRates();

      // Fetch from network only if no local data
      if (_usdRates == null) {
        _usdRates = await ExchangeApi.fetchAndCacheRates();
      }

      _uiState = UIState.success;
    } catch (e) {
      _uiState = UIState.error;
    }

    notifyListeners();
  }

  void setSelectedCurrency(String currency) {
    _selectedCurrency = currency;
    notifyListeners(); // Just recalculate from USD locally
  }

  // Convert all rates from USD → selectedCurrency
  Map<String, double> _convertRates() {
    if (_usdRates == null || !_usdRates!.rates.containsKey(_selectedCurrency)) {
      return {};
    }

    final baseToSelected = _usdRates!.rates[_selectedCurrency]!;
    final Map<String, double> converted = {};

    _usdRates!.rates.forEach((code, usdValue) {
      converted[code] = usdValue / baseToSelected;
    });

    return converted;
  }
}
