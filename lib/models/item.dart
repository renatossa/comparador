enum ItemStatus { neutro, melhor, pior }

class Item {
  double? quantidade;
  double? preco;
  ItemStatus status = ItemStatus.neutro;

  double get valorPorUnidade => (preco ?? 0) / (quantidade ?? 0);

  bool get isValido {
    if (quantidade == null || preco == null) return false;
    if (quantidade == 0 || preco == 0) return false;
    return !valorPorUnidade.isNaN;
  }
}
