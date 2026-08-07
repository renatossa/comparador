import 'dart:async';

import 'package:flutter/foundation.dart';

import '../services/storage_service.dart';
import 'item.dart';
import 'moeda.dart';

class ComparacaoModel extends ChangeNotifier {
  ComparacaoModel({StorageService? storageService})
    : _storage = storageService ?? StorageService() {
    _resetarParaEstadoInicial();
  }

  final StorageService _storage;
  final List<Item> itens = [];
  Moeda moeda = Moeda.real;

  /// RN11: verdadeiro quando não havia moeda salva ao carregar, ou seja,
  /// é a primeira abertura do app — a tela deve perguntar a moeda antes de
  /// exibir a comparação.
  bool precisaSelecionarMoedaInicial = false;

  /// Carrega os itens e a moeda persistidos (RN08). Se não houver nada
  /// salvo, mantém o estado inicial (RN05), a moeda padrão e sinaliza RN11.
  Future<void> carregar() async {
    final salvos = await _storage.carregar();
    if (salvos.isNotEmpty) {
      itens
        ..clear()
        ..addAll(salvos);
    }

    final moedaSalva = await _storage.carregarMoeda();
    if (moedaSalva != null) {
      moeda = moedaSalva;
    } else {
      precisaSelecionarMoedaInicial = true;
    }

    _recalcularDestaques(persistir: false);
  }

  void selecionarMoeda(Moeda novaMoeda) {
    moeda = novaMoeda;
    precisaSelecionarMoedaInicial = false;
    notifyListeners();
    unawaited(_storage.salvarMoeda(moeda));
  }

  void _resetarParaEstadoInicial() {
    itens
      ..clear()
      ..addAll(List.generate(3, (_) => Item()));
  }

  void adicionarItem() {
    itens.add(Item());
    _recalcularDestaques();
  }

  void removerItem(int index) {
    itens.removeAt(index);
    _recalcularDestaques();
  }

  void limpar() {
    _resetarParaEstadoInicial();
    _recalcularDestaques();
  }

  bool atualizarQuantidade(int index, double? valor) {
    if (valor != null && valor < 0) return false;
    itens[index].quantidade = valor;
    _recalcularDestaques();
    return true;
  }

  bool atualizarPreco(int index, double? valor) {
    if (valor != null && valor < 0) return false;
    itens[index].preco = valor;
    _recalcularDestaques();
    return true;
  }

  void _recalcularDestaques({bool persistir = true}) {
    final validos = itens.where((item) => item.isValido).toList();

    if (validos.length < 2) {
      for (final item in itens) {
        item.status = ItemStatus.neutro;
      }
    } else {
      final menorValor = validos
          .map((item) => item.valorPorUnidade)
          .reduce((a, b) => a < b ? a : b);

      for (final item in itens) {
        if (!item.isValido) {
          item.status = ItemStatus.neutro;
        } else if (item.valorPorUnidade == menorValor) {
          item.status = ItemStatus.melhor;
        } else {
          item.status = ItemStatus.pior;
        }
      }
    }

    notifyListeners();
    if (persistir) {
      unawaited(_storage.salvar(itens));
    }
  }
}
