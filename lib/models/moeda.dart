enum Moeda {
  real('R\$', 'Real (Brasil)'),
  euro('€', 'Euro'),
  dolar('\$', 'Dólar (EUA)');

  const Moeda(this.simbolo, this.nome);

  final String simbolo;
  final String nome;
}
