import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:comparador/models/item.dart';
import 'package:comparador/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('RN08 — persistência local', () {
    test('salva e recarrega itens', () async {
      final service = StorageService();
      final itens = [
        Item()
          ..quantidade = 500
          ..preco = 10,
        Item(),
      ];

      await service.salvar(itens);
      final carregados = await service.carregar();

      expect(carregados, hasLength(2));
      expect(carregados[0].quantidade, 500);
      expect(carregados[0].preco, 10);
      expect(carregados[1].quantidade, isNull);
      expect(carregados[1].preco, isNull);
    });

    test('carregar sem dados salvos retorna lista vazia', () async {
      final service = StorageService();
      final carregados = await service.carregar();
      expect(carregados, isEmpty);
    });
  });
}
