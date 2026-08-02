import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/comparacao_model.dart';
import 'screens/comparacao_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final comparacaoModel = ComparacaoModel();
  await comparacaoModel.carregar();

  runApp(ComparadorApp(comparacaoModel: comparacaoModel));
}

class ComparadorApp extends StatelessWidget {
  const ComparadorApp({super.key, required this.comparacaoModel});

  final ComparacaoModel comparacaoModel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: comparacaoModel,
      child: MaterialApp(
        title: 'Comparador de Preços',
        theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
        darkTheme: ThemeData(
          colorSchemeSeed: Colors.teal,
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: const ComparacaoScreen(),
      ),
    );
  }
}
