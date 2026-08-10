import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../models/item.dart';
import '../models/moeda.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.index,
    required this.moeda,
    required this.onQuantidadeChanged,
    required this.onPrecoChanged,
    required this.onRemover,
  });

  final Item item;
  final int index;
  final Moeda moeda;
  final ValueChanged<double?> onQuantidadeChanged;
  final ValueChanged<double?> onPrecoChanged;
  final VoidCallback onRemover;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  late final TextEditingController _quantidadeController;
  late final TextEditingController _precoController;

  static final _decimalFormatter = _DecimalInputFormatter();

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

  double? _parseDecimal(String texto) =>
      double.tryParse(texto.replaceAll(',', '.'));

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final scheme = Theme.of(context).colorScheme;

    // Cada card já nasce com um banho de cor — azul neutro por padrão,
    // verde/vermelho quando o destaque é calculado (identidade visual v2,
    // ver specs/04-migration-plan.md Fase 3).
    final corCard = switch (item.status) {
      ItemStatus.melhor => Color.alphaBlend(
        Colors.green.withValues(alpha: 0.16),
        scheme.surface,
      ),
      ItemStatus.pior => Color.alphaBlend(
        Colors.red.withValues(alpha: 0.16),
        scheme.surface,
      ),
      ItemStatus.neutro => scheme.primaryContainer,
    };

    final formato = NumberFormat.currency(
      locale: Localizations.localeOf(context).toString(),
      symbol: widget.moeda.simbolo,
      decimalDigits: 2,
    );

    return Card(
      color: corCard,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _quantidadeController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [_decimalFormatter],
                    decoration: const InputDecoration(
                      labelText: 'Quantidade',
                      helperText: 'em g, ml, kg, litros...',
                    ),
                    onChanged: (texto) =>
                        widget.onQuantidadeChanged(_parseDecimal(texto)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _precoController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [_decimalFormatter],
                    decoration: InputDecoration(
                      labelText: 'Preço (${widget.moeda.simbolo})',
                    ),
                    onChanged: (texto) =>
                        widget.onPrecoChanged(_parseDecimal(texto)),
                  ),
                ),
              ],
            ),
            if (item.isValido) ...[
              const SizedBox(height: 8),
              Text(
                '${formato.format(item.valorPorUnidade)} / unidade',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Aceita dígitos com no máximo um separador decimal (`,` ou `.`), tratados
/// como equivalentes — o teclado varia por região/dispositivo.
class _DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final texto = newValue.text;
    if (texto.isEmpty) return newValue;

    if (!RegExp(r'^\d*[.,]?\d*$').hasMatch(texto)) return oldValue;

    return newValue;
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
