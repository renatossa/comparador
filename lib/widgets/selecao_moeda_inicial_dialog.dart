import 'package:flutter/material.dart';

import '../models/moeda.dart';

/// Diálogo de seleção de moeda na primeira abertura do app (RN11).
/// Obrigatório: sem botão de "agora não" e sem fechar tocando fora —
/// só é dispensado quando o usuário escolhe uma das opções.
class SelecaoMoedaInicialDialog extends StatelessWidget {
  const SelecaoMoedaInicialDialog({super.key, required this.onSelecionada});

  final ValueChanged<Moeda> onSelecionada;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: const Text('Escolha sua moeda'),
        content: const Text(
          'Qual moeda você quer usar como referência para comparar preços?',
        ),
        actions: Moeda.values
            .map(
              (moeda) => TextButton(
                onPressed: () {
                  onSelecionada(moeda);
                  Navigator.of(context).pop();
                },
                child: Text('${moeda.simbolo}  ${moeda.nome}'),
              ),
            )
            .toList(),
      ),
    );
  }
}
