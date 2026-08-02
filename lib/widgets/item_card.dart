import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/item.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.index,
    required this.onQuantidadeChanged,
    required this.onPrecoChanged,
    required this.onRemover,
  });

  final Item item;
  final int index;
  final ValueChanged<double?> onQuantidadeChanged;
  final ValueChanged<double?> onPrecoChanged;
  final VoidCallback onRemover;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  late final TextEditingController _quantidadeController;
  late final TextEditingController _precoController;

  static final _apenasNumeros = FilteringTextInputFormatter.allow(
    RegExp(r'[0-9.]'),
  );

  @override
  void initState() {
    super.initState();
    _quantidadeController = TextEditingController(
      text: widget.item.quantidade?.toString() ?? '',
    );
    _precoController = TextEditingController(
      text: widget.item.preco?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _quantidadeController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final corDestaque = switch (item.status) {
      ItemStatus.melhor => Colors.green,
      ItemStatus.pior => Colors.red,
      ItemStatus.neutro => null,
    };

    return Card(
      color: corDestaque?.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Item ${widget.index + 1}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (item.status != ItemStatus.neutro) ...[
                  _DestaqueBadge(status: item.status),
                  const SizedBox(width: 4),
                ],
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Remover item',
                  onPressed: widget.onRemover,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quantidadeController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [_apenasNumeros],
                    decoration: const InputDecoration(
                      labelText: 'Quantidade',
                      helperText: 'em g, ml, kg, litros...',
                    ),
                    onChanged: (texto) =>
                        widget.onQuantidadeChanged(double.tryParse(texto)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _precoController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [_apenasNumeros],
                    decoration: const InputDecoration(labelText: 'Preço (R\$)'),
                    onChanged: (texto) =>
                        widget.onPrecoChanged(double.tryParse(texto)),
                  ),
                ),
              ],
            ),
            if (item.isValido) ...[
              const SizedBox(height: 8),
              Text(
                'R\$ ${item.valorPorUnidade.toStringAsFixed(4)} / unidade',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DestaqueBadge extends StatelessWidget {
  const _DestaqueBadge({required this.status});

  final ItemStatus status;

  @override
  Widget build(BuildContext context) {
    final melhor = status == ItemStatus.melhor;
    final cor = melhor ? Colors.green : Colors.red;

    return Chip(
      avatar: Icon(
        melhor ? Icons.thumb_up : Icons.thumb_down,
        size: 16,
        color: Colors.white,
      ),
      label: Text(melhor ? 'Melhor opção' : 'Pior opção'),
      backgroundColor: cor,
      labelStyle: const TextStyle(color: Colors.white),
      visualDensity: VisualDensity.compact,
    );
  }
}
