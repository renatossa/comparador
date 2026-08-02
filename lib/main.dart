import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/comparacao_model.dart';
import 'screens/comparacao_screen.dart';

void main() {
  runApp(const ComparadorApp());
}

class ComparadorApp extends StatelessWidget {
  const ComparadorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ComparacaoModel(),
      child: MaterialApp(
        title: 'Comparador de Preços',
        theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
        home: const ComparacaoScreen(),
      ),
    );
  }
}
