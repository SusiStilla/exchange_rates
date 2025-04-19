import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Currency Converter'),
        ),
      ),
      body: const Center(
        child: Text('Currency dropdown + exchange grid goes here'),
      ),
    );
  }
}
