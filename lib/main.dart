import 'package:flutter/material.dart';
import 'package:simulator_of_trading/page/page.dart';

import 'page/trade/graph/graph.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Graph(),
    );
  }
}
