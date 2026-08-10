import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:comparador/models/comparacao_model.dart';
import 'package:comparador/models/moeda.dart';
import 'package:comparador/screens/comparacao_screen.dart';

Future<void> _pumpApp(WidgetTester tester, ComparacaoModel model) async {
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: model,
      child: const MaterialApp(home: ComparacaoScreen()),
    ),
  );
}

/// Preenche o item de índice [index] assumindo 2 campos (quantidade, preço)
/// por item, na ordem em que aparecem na lista.
Future<void> _preencherItem(
  WidgetTester tester,
  int index,
  double quantidade,
  double preco,
) async {
  final campos = find.byType(TextField);
  await tester.enterText(campos.at(index * 2), quantidade.toString());
  await tester.pump();
  await tester.enterText(campos.at(index * 2 + 1), preco.toString());
  await tester.pump();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('exibe o título da tela de comparação', (tester) async {
    await _pumpApp(tester, ComparacaoModel());
    expect(find.text('Comparador de Preços'), findsOneWidget);
  });

  testWidgets('cenário: comparar dois itens simples', (tester) async {
    await _pumpApp(tester, ComparacaoModel());

    await _preencherItem(tester, 0, 100, 10); // 0.10 — pior
    await _preencherItem(tester, 1, 1000, 10); // 0.01 — melhor

    expect(find.text('Melhor opção'), findsOneWidget);
    expect(find.text('Pior opção'), findsOneWidget);
    // O símbolo de moeda e o separador decimal variam por locale (ver
    // 03-non-functional.md); só validamos que o valor calculado aparece,
    // formatado com 2 casas decimais.
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            (widget.data?.contains('01') ?? false) &&
            (widget.data?.contains('unidade') ?? false),
      ),
      findsOneWidget,
    );
  });

  testWidgets('cenário: item com dados incompletos não é comparado', (
    tester,
  ) async {
    await _pumpApp(tester, ComparacaoModel());

    final campos = find.byType(TextField);
    await tester.enterText(campos.at(0), '500'); // só a quantidade do item 1
    await tester.pump();

    expect(find.text('Melhor opção'), findsNothing);
    expect(find.text('Pior opção'), findsNothing);
  });

  testWidgets('cenário: adicionar item à comparação', (tester) async {
    await _pumpApp(tester, ComparacaoModel());
    expect(find.byType(TextField), findsNWidgets(6)); // 3 itens x 2 campos

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.byType(TextField), findsNWidgets(8)); // 4 itens x 2 campos
  });

  testWidgets('cenário: limpar comparação', (tester) async {
    await _pumpApp(tester, ComparacaoModel());
    await _preencherItem(tester, 0, 500, 10);

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();

    final campos = tester.widgetList<TextField>(find.byType(TextField));
    expect(campos, hasLength(6));
    expect(campos.every((campo) => campo.controller!.text.isEmpty), isTrue);
  });

  testWidgets('cenário: remover item do meio da lista', (tester) async {
    await _pumpApp(tester, ComparacaoModel());
    expect(find.byType(TextField), findsNWidgets(6));

    await tester.tap(find.byIcon(Icons.delete_outline).at(1));
    await tester.pump();

    expect(find.byType(TextField), findsNWidgets(4));
  });

  testWidgets('cenário: remover até restar 1 item não exibe destaque', (
    tester,
  ) async {
    final model = ComparacaoModel();
    await _pumpApp(tester, model);

    await _preencherItem(tester, 0, 500, 10);
    await _preencherItem(tester, 1, 1000, 18);

    await tester.tap(find.byIcon(Icons.delete_outline).at(2)); // item 3 vazio
    await tester.pump();
    await tester.tap(find.byIcon(Icons.delete_outline).at(1)); // item 2
    await tester.pump();

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Melhor opção'), findsNothing);
    expect(find.text('Pior opção'), findsNothing);
  });

  testWidgets('cenário: impedir valor negativo', (tester) async {
    await _pumpApp(tester, ComparacaoModel());

    final campos = find.byType(TextField);
    await tester.enterText(campos.at(0), '-500');
    await tester.pump();

    final campo = tester.widget<TextField>(campos.at(0));
    expect(campo.controller!.text, isNot(contains('-')));
  });

  group('RN11 — seleção inicial de moeda', () {
    testWidgets('primeira abertura exibe diálogo obrigatório de moeda', (
      tester,
    ) async {
      final model = ComparacaoModel();
      await model.carregar();

      await _pumpApp(tester, model);
      await tester.pump();

      expect(find.text('Escolha sua moeda'), findsOneWidget);
    });

    testWidgets('escolher moeda no diálogo inicial salva e libera a tela', (
      tester,
    ) async {
      final model = ComparacaoModel();
      await model.carregar();

      await _pumpApp(tester, model);
      await tester.pump();

      await tester.tap(find.text('€  Euro'));
      await tester.pumpAndSettle();

      expect(find.text('Escolha sua moeda'), findsNothing);
      expect(model.moeda, Moeda.euro);
      expect(model.precisaSelecionarMoedaInicial, isFalse);
    });

    testWidgets('não pergunta de novo quando já existe moeda salva', (
      tester,
    ) async {
      final anterior = ComparacaoModel();
      anterior.selecionarMoeda(Moeda.dolar);

      final model = ComparacaoModel();
      await model.carregar();

      await _pumpApp(tester, model);
      await tester.pump();

      expect(find.text('Escolha sua moeda'), findsNothing);
    });

    testWidgets(
      'diálogo inicial não fecha ao tentar voltar sem escolher uma moeda',
      (tester) async {
        final model = ComparacaoModel();
        await model.carregar();

        await _pumpApp(tester, model);
        await tester.pump();

        expect(find.text('Escolha sua moeda'), findsOneWidget);

        await tester.binding.handlePopRoute();
        await tester.pump();

        expect(find.text('Escolha sua moeda'), findsOneWidget);
        expect(model.precisaSelecionarMoedaInicial, isTrue);
      },
    );
  });
}
