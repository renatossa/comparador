enum Moeda {
  real('R\$', 'Real'),
  euro('€', 'Euro'),
  dolar('\$', 'Dólar');

  const Moeda(this.simbolo, this.nome);

  final String simbolo;
  final String nome;
}
