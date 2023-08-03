import 'package:flutter/material.dart';
import 'price_screen.dart';

void main() {
  runApp(const BitcoinTicker());
}

class BitcoinTicker extends StatelessWidget {
  const BitcoinTicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PriceScreen(),
    );
  }
}