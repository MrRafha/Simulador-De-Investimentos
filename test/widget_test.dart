// Este é um teste básico de widget do Flutter.
//
// Para interagir com um widget no teste, use o utilitário WidgetTester do
// pacote flutter_test. É possível simular toques e rolagens, localizar widgets
// filhos e verificar os valores de suas propriedades.

import 'package:flutter_test/flutter_test.dart';

import 'package:simulador_investimentos/main.dart';

void main() {
  testWidgets('exibe o formulário de comparação', (tester) async {
    await tester.pumpWidget(const SimuladorInvestimentosApp());

    expect(find.text('Comparador de investimentos'), findsOneWidget);
    expect(find.text('Planeje antes de investir'), findsOneWidget);
    expect(find.text('Investimento 1'), findsOneWidget);
    expect(find.text('Investimento 2'), findsOneWidget);
  });
}
