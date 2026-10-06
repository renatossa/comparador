import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:comparador/models/item.dart';
import 'package:comparador/models/moeda.dart';
import 'package:comparador/widgets/item_card.dart';

void main() {
  testWidgets('valores inteiros carregados não exibem ".0"', (tester) async {
    final item = Item()
      ..quantidade = 45
      ..preco = 15;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ItemCard(
            item: item,
            index: 0,
            moeda: Moeda.real,
            onQuantidadeChanged: (_) {},
            onPrecoChanged: (_) {},
            onRemover: () {},
          ),
        ),
      ),
    );

    final campos = tester.widgetList<TextField>(find.byType(TextField));
    expect(campos.map((c) => c.controller!.text), ['45', '15']);
  });
}
