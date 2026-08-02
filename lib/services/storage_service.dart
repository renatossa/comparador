import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/item.dart';

class StorageService {
  static const _chave = 'comparacao_itens';

  Future<void> salvar(List<Item> itens) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = itens
        .map((item) => {'quantidade': item.quantidade, 'preco': item.preco})
        .toList();
    await prefs.setString(_chave, jsonEncode(lista));
  }

  Future<List<Item>> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final bruto = prefs.getString(_chave);
    if (bruto == null) return [];

    final lista = jsonDecode(bruto) as List;
    return lista.map((json) {
      final map = json as Map<String, dynamic>;
      return Item()
        ..quantidade = (map['quantidade'] as num?)?.toDouble()
        ..preco = (map['preco'] as num?)?.toDouble();
    }).toList();
  }
}
