import 'package:flutter/material.dart';
import '../models/exchange_rate.dart';
import '../services/exchange_api.dart';

enum UIState { loading, success, error }

class ExchangeController extends ChangeNotifier {
  UIState _uiState = UIState.loading;
  String _selectedCurrency = 'USD';
  double _amount = 1.0;
  ExchangeRate? _usdRates;

  UIState get uiState => _uiState;
  String get selectedCurrency => _selectedCurrency;
  double get amount => _amount;
  Map<String, double> get convertedRates => _convertRates();

  Future<void> fetchRates() async {
    _uiState = UIState.loading;
    notifyListeners();

    try {
      _usdRates = await ExchangeApi.fetchAndCacheRates();
      _uiState = UIState.success;
    } catch (e) {
      _usdRates = await ExchangeApi.loadCachedRates();
      _uiState = _usdRates != null ? UIState.success : UIState.error;
    }

    notifyListeners();
  }

  void setSelectedCurrency(String currency) {
    _selectedCurrency = currency;
    notifyListeners();
  }

  void setAmount(String input) {
    final parsed = double.tryParse(input);
    _amount = parsed != null && parsed > 0 ? parsed : 1.0;
    notifyListeners();
  }

  Map<String, double> _convertRates() {
    if (_usdRates == null || !_usdRates!.rates.containsKey(_selectedCurrency)) {
      return {};
    }

    final baseToSelected = _usdRates!.rates[_selectedCurrency]!;
    final Map<String, double> converted = {};

    _usdRates!.rates.forEach((code, usdValue) {
      converted[code] = (usdValue / baseToSelected) * _amount;
    });

    return converted;
  }
}
