import 'package:flutter_test/flutter_test.dart';

import 'package:comparador/models/item.dart';

void main() {
  group('RN01 — cálculo do valor por unidade', () {
    test('valorPorUnidade = preco / quantidade', () {
      final item = Item()
        ..quantidade = 500
        ..preco = 10;

      expect(item.valorPorUnidade, 0.02);
    });
  });

  group('RN02 — item inválido', () {
    test('quantidade nula é inválido', () {
      final item = Item()..preco = 10;
      expect(item.isValido, isFalse);
    });

    test('preco nulo é inválido', () {
      final item = Item()..quantidade = 500;
      expect(item.isValido, isFalse);
    });

    test('quantidade zero é inválido', () {
      final item = Item()
        ..quantidade = 0
        ..preco = 10;
      expect(item.isValido, isFalse);
    });

    test('preco zero é inválido', () {
      final item = Item()
        ..quantidade = 500
        ..preco = 0;
      expect(item.isValido, isFalse);
    });

    test('item totalmente vazio é inválido', () {
      final item = Item();
      expect(item.isValido, isFalse);
    });

    test('item com quantidade e preço válidos é válido', () {
      final item = Item()
        ..quantidade = 500
        ..preco = 10;
      expect(item.isValido, isTrue);
    });
  });
}
