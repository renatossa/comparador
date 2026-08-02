import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:comparador/models/comparacao_model.dart';
import 'package:comparador/screens/comparacao_screen.dart';

void main() {
  testWidgets('exibe o título da tela de comparação', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ComparacaoModel(),
        child: const MaterialApp(home: ComparacaoScreen()),
      ),
    );

    expect(find.text('Comparador de Preços'), findsOneWidget);
  });
}
