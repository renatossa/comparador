import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/comparacao_model.dart';
import '../models/moeda.dart';
import '../widgets/item_card.dart';

class ComparacaoScreen extends StatelessWidget {
  const ComparacaoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparador de Preços'),
        actions: [
          Consumer<ComparacaoModel>(
            builder: (context, model, _) => PopupMenuButton<Moeda>(
              tooltip: 'Escolher moeda',
              initialValue: model.moeda,
              onSelected: (moeda) =>
                  context.read<ComparacaoModel>().selecionarMoeda(moeda),
              itemBuilder: (context) => Moeda.values
                  .map(
                    (moeda) => PopupMenuItem(
                      value: moeda,
                      child: Text('${moeda.simbolo}  ${moeda.nome}'),
                    ),
                  )
                  .toList(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      model.moeda.simbolo,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Limpar',
            onPressed: () => context.read<ComparacaoModel>().limpar(),
          ),
        ],
      ),
      body: Consumer<ComparacaoModel>(
        builder: (context, model, _) {
          if (model.itens.isEmpty) {
            return const Center(child: Text('Nenhum item na comparação'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: model.itens.length,
            itemBuilder: (context, index) {
              final item = model.itens[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ItemCard(
                  key: ObjectKey(item),
                  item: item,
                  index: index,
                  moeda: model.moeda,
                  onQuantidadeChanged: (valor) =>
                      model.atualizarQuantidade(index, valor),
                  onPrecoChanged: (valor) =>
                      model.atualizarPreco(index, valor),
                  onRemover: () => model.removerItem(index),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<ComparacaoModel>().adicionarItem(),
        tooltip: 'Adicionar item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
