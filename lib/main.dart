import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/exchange_controller.dart';
import 'views/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ExchangeController()..fetchRates(),
      child: const ExchangeApp(),
    ),
  );
}

class ExchangeApp extends StatelessWidget {
  const ExchangeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exchange Rates',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomeScreen(),
    );
  }
}
