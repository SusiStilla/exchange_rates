import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/exchange_rate.dart';

class ExchangeApi {
  static final String _apiKey = dotenv.env['API_KEY']!;
  static final String _url =
      'https://v6.exchangerate-api.com/v6/$_apiKey/latest/USD';
  static const String _storageKey = 'exchange_rates_cache';

  // Fetch from network and save to local storage
  static Future<ExchangeRate> fetchAndCacheRates() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['result'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_storageKey, json.encode(data));

        return ExchangeRate.fromJson(data);
      } else {
        throw Exception('API Error: ${data['error-type']}');
      }
    } else {
      throw Exception('Network Error: ${response.statusCode}');
    }
  }

  // Load from local storage
  static Future<ExchangeRate?> loadCachedRates() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_storageKey);

    if (cached != null) {
      final data = json.decode(cached);
      return ExchangeRate.fromJson(data);
    }

    return null;
  }
}
