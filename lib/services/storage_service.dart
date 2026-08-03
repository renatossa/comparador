import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/item.dart';
import '../models/moeda.dart';

class StorageService {
  static const _chaveItens = 'comparacao_itens';
  static const _chaveMoeda = 'comparacao_moeda';

  Future<void> salvar(List<Item> itens) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = itens
        .map((item) => {'quantidade': item.quantidade, 'preco': item.preco})
        .toList();
    await prefs.setString(_chaveItens, jsonEncode(lista));
  }

  Future<List<Item>> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final bruto = prefs.getString(_chaveItens);
    if (bruto == null) return [];

    final lista = jsonDecode(bruto) as List;
    return lista.map((json) {
      final map = json as Map<String, dynamic>;
      return Item()
        ..quantidade = (map['quantidade'] as num?)?.toDouble()
        ..preco = (map['preco'] as num?)?.toDouble();
    }).toList();
  }

  Future<void> salvarMoeda(Moeda moeda) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chaveMoeda, moeda.name);
  }

  Future<Moeda?> carregarMoeda() async {
    final prefs = await SharedPreferences.getInstance();
    final nome = prefs.getString(_chaveMoeda);
    if (nome == null) return null;
    return Moeda.values.asNameMap()[nome];
  }
}
