import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:comparador/models/comparacao_model.dart';
import 'package:comparador/models/item.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // ComparacaoModel persiste em segundo plano (RN08) a cada mutação;
    // sem isso, SharedPreferences.getInstance() falha por falta do plugin.
    SharedPreferences.setMockInitialValues({});
  });

  group('RN05 — estado inicial', () {
    test('nova comparação começa com 3 itens vazios', () {
      final model = ComparacaoModel();
      expect(model.itens, hasLength(3));
      expect(model.itens.every((item) => !item.isValido), isTrue);
    });
  });

  group('RN03/RN04 — melhor e pior opção', () {
    test('cenário: comparar dois itens simples', () {
      final model = ComparacaoModel();
      model.atualizarQuantidade(0, 500);
      model.atualizarPreco(0, 10);
      model.atualizarQuantidade(1, 1000);
      model.atualizarPreco(1, 18);

      expect(model.itens[0].valorPorUnidade, 0.02);
      expect(model.itens[1].valorPorUnidade, 0.018);
      expect(model.itens[1].status, ItemStatus.melhor);
      expect(model.itens[0].status, ItemStatus.pior);
    });

    test('item com dados incompletos não recebe destaque nem é comparado', () {
      final model = ComparacaoModel();
      model.atualizarQuantidade(0, 500);
      // item 0 sem preço
      model.atualizarQuantidade(1, 1000);
      model.atualizarPreco(1, 18);

      expect(model.itens[0].status, ItemStatus.neutro);
      expect(model.itens[0].isValido, isFalse);
    });

    test('apenas 1 item preenchido não recebe destaque', () {
      final model = ComparacaoModel();
      model.atualizarQuantidade(0, 500);
      model.atualizarPreco(0, 10);

      expect(model.itens[0].status, ItemStatus.neutro);
    });

    test('empate: todos os itens com o mesmo valor por unidade são "melhor"', () {
      final model = ComparacaoModel();
      model.atualizarQuantidade(0, 500);
      model.atualizarPreco(0, 10);
      model.atualizarQuantidade(1, 1000);
      model.atualizarPreco(1, 20);
      model.atualizarQuantidade(2, 250);
      model.atualizarPreco(2, 5);

      expect(model.itens.every((item) => item.status == ItemStatus.melhor), isTrue);
    });

    test('recalcula a lista inteira a cada mudança, não só o item editado', () {
      final model = ComparacaoModel();
      model.atualizarQuantidade(0, 500);
      model.atualizarPreco(0, 10); // 0.02 — melhor até aqui
      model.atualizarQuantidade(1, 1000);
      model.atualizarPreco(1, 50); // 0.05 — pior

      expect(model.itens[0].status, ItemStatus.melhor);
      expect(model.itens[1].status, ItemStatus.pior);

      // alterar o item 2 deve recomputar o destaque do item 0 também
      model.atualizarQuantidade(2, 100);
      model.atualizarPreco(2, 1); // 0.01 — novo melhor

      expect(model.itens[2].status, ItemStatus.melhor);
      expect(model.itens[0].status, ItemStatus.pior);
    });
  });

  group('RN06 — adicionar item', () {
    test('adiciona itens ilimitadamente', () {
      final model = ComparacaoModel();
      model.adicionarItem();
      expect(model.itens, hasLength(4));

      model.adicionarItem();
      model.adicionarItem();
      expect(model.itens, hasLength(6));
    });
  });

  group('RN07 — limpar', () {
    test('reseta para 3 itens vazios, descartando valores digitados', () {
      final model = ComparacaoModel();
      model.atualizarQuantidade(0, 500);
      model.atualizarPreco(0, 10);
      model.adicionarItem();

      model.limpar();

      expect(model.itens, hasLength(3));
      expect(model.itens.every((item) => !item.isValido), isTrue);
    });
  });

  group('RN09 — remover item individual', () {
    test('remove item do meio da lista e recalcula destaques', () {
      final model = ComparacaoModel();
      model.adicionarItem(); // 4 itens
      model.atualizarQuantidade(0, 500);
      model.atualizarPreco(0, 10); // 0.02
      model.atualizarQuantidade(1, 1000);
      model.atualizarPreco(1, 18); // 0.018 — melhor
      model.atualizarQuantidade(2, 100);
      model.atualizarPreco(2, 5); // 0.05
      model.atualizarQuantidade(3, 200);
      model.atualizarPreco(3, 10); // 0.05

      model.removerItem(1); // remove o item que era "melhor"

      expect(model.itens, hasLength(3));
      // novo menor valor entre os restantes (0.02) deve virar "melhor"
      expect(model.itens[0].valorPorUnidade, 0.02);
      expect(model.itens[0].status, ItemStatus.melhor);
    });

    test('remover até restar 1 item não exibe destaque', () {
      final model = ComparacaoModel();
      model.limpar();
      model.removerItem(2); // 2 itens
      model.atualizarQuantidade(0, 500);
      model.atualizarPreco(0, 10);
      model.atualizarQuantidade(1, 1000);
      model.atualizarPreco(1, 18);

      model.removerItem(1); // 1 item restante

      expect(model.itens, hasLength(1));
      expect(model.itens[0].status, ItemStatus.neutro);
    });

    test('remover o único item restante não quebra (lista fica vazia)', () {
      final model = ComparacaoModel();
      model.removerItem(0);
      model.removerItem(0);
      model.removerItem(0);

      expect(model.itens, isEmpty);
    });
  });

  group('RN10 — validação de valores negativos', () {
    test('rejeita quantidade negativa', () {
      final model = ComparacaoModel();
      final aceitou = model.atualizarQuantidade(0, -500);

      expect(aceitou, isFalse);
      expect(model.itens[0].quantidade, isNull);
    });

    test('rejeita preço negativo', () {
      final model = ComparacaoModel();
      final aceitou = model.atualizarPreco(0, -10);

      expect(aceitou, isFalse);
      expect(model.itens[0].preco, isNull);
    });

    test('aceita valores positivos normalmente', () {
      final model = ComparacaoModel();
      final aceitou = model.atualizarQuantidade(0, 500);

      expect(aceitou, isTrue);
      expect(model.itens[0].quantidade, 500);
    });
  });
}
