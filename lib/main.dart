import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  // Ponto de entrada do aplicativo: cria a árvore de widgets Flutter.
  runApp(const SimuladorInvestimentosApp());
}

class SimuladorInvestimentosApp extends StatelessWidget {
  const SimuladorInvestimentosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comparador de investimentos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff0c6e69),
          brightness: Brightness.light,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const TelaFormularioInvestimento(),
    );
  }
}

class Investimento {
  const Investimento({
    required this.name,
    required this.capitalInicial,
    required this.aporteMensal,
    required this.taxaMensal,
  });

  final String name;
  final double capitalInicial;
  final double aporteMensal;
  final double taxaMensal;

  List<double> evolucao(int meses) {
    var saldo = capitalInicial;
    final valores = <double>[];

    for (var mes = 1; mes <= meses; mes++) {
      // A cada mês, o saldo recebe juros e depois o novo aporte mensal.
      saldo = saldo * (1 + taxaMensal / 100) + aporteMensal;
      valores.add(saldo);
    }
    return valores;
  }
}

class TelaFormularioInvestimento extends StatefulWidget {
  const TelaFormularioInvestimento({super.key});

  @override
  State<TelaFormularioInvestimento> createState() =>
      _TelaFormularioInvestimentoState();
}

class _TelaFormularioInvestimentoState
    extends State<TelaFormularioInvestimento> {
  final _formKey = GlobalKey<FormState>();
  final _controladorCapitalUm = TextEditingController();
  final _controladorAporteUm = TextEditingController();
  final _controladorTaxaUm = TextEditingController();
  final _controladorCapitalDois = TextEditingController();
  final _controladorAporteDois = TextEditingController();
  final _controladorTaxaDois = TextEditingController();
  final _controladorMeses = TextEditingController(text: '12');

  @override
  void dispose() {
    for (final controller in [
      _controladorCapitalUm,
      _controladorAporteUm,
      _controladorTaxaUm,
      _controladorCapitalDois,
      _controladorAporteDois,
      _controladorTaxaDois,
      _controladorMeses,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  double _numero(TextEditingController controller) {
    return double.parse(controller.text.trim().replaceAll(',', '.'));
  }

  String? _numeroObrigatorio(String? value, {bool integer = false}) {
    // Aceita ponto ou vírgula como separador decimal para facilitar a entrada.
    final normalized = value?.trim().replaceAll(',', '.');
    final number = double.tryParse(normalized ?? '');
    if (number == null || number < 0 || (integer && number < 1)) {
      return integer
          ? 'Informe pelo menos 1 mês.'
          : 'Informe um número válido.';
    }
    return null;
  }

  void _mostrarResultados() {
    // A navegação só acontece quando todos os campos passam pela validação.
    if (!_formKey.currentState!.validate()) return;

    final meses = int.parse(_controladorMeses.text.trim());
    final primeiro = Investimento(
      name: 'Investimento 1',
      capitalInicial: _numero(_controladorCapitalUm),
      aporteMensal: _numero(_controladorAporteUm),
      taxaMensal: _numero(_controladorTaxaUm),
    );
    final segundo = Investimento(
      name: 'Investimento 2',
      capitalInicial: _numero(_controladorCapitalDois),
      aporteMensal: _numero(_controladorAporteDois),
      taxaMensal: _numero(_controladorTaxaDois),
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TelaResultados(
          primeiro: primeiro,
          segundo: segundo,
          meses: meses,
        ),
      ),
    );
  }

  Widget _secaoInvestimento({
    required String title,
    required Color color,
    required TextEditingController capital,
    required TextEditingController deposit,
    required TextEditingController rate,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: color,
                  child: const Icon(Icons.trending_up,
                      size: 17, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: capital,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: _numeroObrigatorio,
              decoration: const InputDecoration(
                labelText: 'Capital inicial',
                prefixText: 'R\$ ',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: deposit,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: _numeroObrigatorio,
              decoration: const InputDecoration(
                labelText: 'Aporte mensal',
                prefixText: 'R\$ ',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: rate,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: _numeroObrigatorio,
              decoration: const InputDecoration(
                labelText: 'Taxa mensal',
                suffixText: '%',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comparador de investimentos')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Text('Planeje antes de investir',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 6),
            Text(
              'Compare dois cenários usando o mesmo período e veja qual rende mais.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            _secaoInvestimento(
              title: 'Investimento 1',
              color: const Color(0xff0c6e69),
              capital: _controladorCapitalUm,
              deposit: _controladorAporteUm,
              rate: _controladorTaxaUm,
            ),
            const SizedBox(height: 14),
            _secaoInvestimento(
              title: 'Investimento 2',
              color: const Color(0xffc85c2d),
              capital: _controladorCapitalDois,
              deposit: _controladorAporteDois,
              rate: _controladorTaxaDois,
            ),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: TextFormField(
                  controller: _controladorMeses,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      _numeroObrigatorio(value, integer: true),
                  decoration: const InputDecoration(
                    labelText: 'Período compartilhado',
                    suffixText: 'meses',
                    prefixIcon: Icon(Icons.calendar_month),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _mostrarResultados,
              icon: const Icon(Icons.compare_arrows),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Comparar investimentos'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaResultados extends StatefulWidget {
  const TelaResultados(
      {super.key,
      required this.primeiro,
      required this.segundo,
      required this.meses});

  final Investimento primeiro;
  final Investimento segundo;
  final int meses;

  @override
  State<TelaResultados> createState() => _TelaResultadosState();
}

class _TelaResultadosState extends State<TelaResultados> {
  // Este estado controla uma informação extra exibida na tabela.
  bool _mostrarRendimentoMensal = false;

  String _moeda(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  Widget _cartaoResumo(
      Investimento investimento, List<double> valores, Color color) {
    final valorFinal = valores.last;
    final valorInvestido =
        investimento.capitalInicial + investimento.aporteMensal * widget.meses;
    final rendimento = valorFinal - valorInvestido;
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 30, height: 5, color: color),
              const SizedBox(height: 12),
              Text(investimento.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(_moeda(valorFinal),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const Text('montante final'),
              const SizedBox(height: 8),
              Text(_moeda(rendimento),
                  style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              const Text('rendimento total'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final valoresPrimeiro = widget.primeiro.evolucao(widget.meses);
    final valoresSegundo = widget.segundo.evolucao(widget.meses);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado da comparação'),
        actions: [
          IconButton(
            tooltip: 'Nova simulação',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          Text('Visão geral', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cartaoResumo(
                  widget.primeiro, valoresPrimeiro, const Color(0xff0c6e69)),
              const SizedBox(width: 10),
              _cartaoResumo(
                  widget.segundo, valoresSegundo, const Color(0xffc85c2d)),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gráfico de evolução',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  const Text('Comparação do saldo acumulado em cada mês.'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _LegendaGrafico(
                          color: const Color(0xff0c6e69),
                          label: widget.primeiro.name),
                      const SizedBox(width: 18),
                      _LegendaGrafico(
                          color: const Color(0xffc85c2d),
                          label: widget.segundo.name),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: PintorGraficoInvestimentos(
                        valoresPrimeiro: valoresPrimeiro,
                        valoresSegundo: valoresSegundo,
                        corPrimeiro: const Color(0xff0c6e69),
                        corSegundo: const Color(0xffc85c2d),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Evolução mensal',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            title: const Text('Exibir rendimento acumulado'),
            value: _mostrarRendimentoMensal,
            onChanged: (value) =>
                setState(() => _mostrarRendimentoMensal = value),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  const DataColumn(label: Text('Mês')),
                  const DataColumn(label: Text('Investimento 1')),
                  const DataColumn(label: Text('Investimento 2')),
                  if (_mostrarRendimentoMensal)
                    const DataColumn(label: Text('Rendimento 1')),
                  if (_mostrarRendimentoMensal)
                    const DataColumn(label: Text('Rendimento 2')),
                ],
                rows: List.generate(
                  widget.meses,
                  (index) => DataRow(cells: [
                    DataCell(Text('${index + 1}')),
                    DataCell(Text(_moeda(valoresPrimeiro[index]))),
                    DataCell(Text(_moeda(valoresSegundo[index]))),
                    if (_mostrarRendimentoMensal)
                      DataCell(Text(_moeda(
                        valoresPrimeiro[index] -
                            widget.primeiro.capitalInicial -
                            widget.primeiro.aporteMensal * (index + 1),
                      ))),
                    if (_mostrarRendimentoMensal)
                      DataCell(Text(_moeda(
                        valoresSegundo[index] -
                            widget.segundo.capitalInicial -
                            widget.segundo.aporteMensal * (index + 1),
                      ))),
                  ]),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Cálculo: saldo do mês anterior × (1 + taxa) + aporte mensal.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _LegendaGrafico extends StatelessWidget {
  const _LegendaGrafico({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}

class PintorGraficoInvestimentos extends CustomPainter {
  PintorGraficoInvestimentos({
    required this.valoresPrimeiro,
    required this.valoresSegundo,
    required this.corPrimeiro,
    required this.corSegundo,
  });

  final List<double> valoresPrimeiro;
  final List<double> valoresSegundo;
  final Color corPrimeiro;
  final Color corSegundo;

  @override
  void paint(Canvas canvas, Size size) {
    // Reserva espaço para os eixos e transforma os valores em coordenadas.
    const leftPadding = 42.0;
    const topPadding = 12.0;
    const rightPadding = 8.0;
    const bottomPadding = 24.0;
    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;
    final maximum = [
      ...valoresPrimeiro,
      ...valoresSegundo,
    ].reduce(math.max);
    final scale = maximum == 0 ? 1.0 : maximum;

    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 1.5;
    final textStyle = TextStyle(color: Colors.grey.shade700, fontSize: 10);

    for (var line = 0; line <= 4; line++) {
      final y = topPadding + chartHeight * line / 4;
      canvas.drawLine(Offset(leftPadding, y),
          Offset(size.width - rightPadding, y), gridPaint);
      _drawText(canvas, '${(100 - line * 25)}%', Offset(0, y - 6), textStyle);
    }
    canvas.drawLine(
      const Offset(leftPadding, topPadding),
      Offset(leftPadding, topPadding + chartHeight),
      axisPaint,
    );
    canvas.drawLine(
      Offset(leftPadding, topPadding + chartHeight),
      Offset(size.width - rightPadding, topPadding + chartHeight),
      axisPaint,
    );

    _desenharSerie(canvas, valoresPrimeiro, corPrimeiro, leftPadding,
        topPadding, chartWidth, chartHeight, scale);
    _desenharSerie(canvas, valoresSegundo, corSegundo, leftPadding, topPadding,
        chartWidth, chartHeight, scale);

    _drawText(
        canvas, 'Mês 1', Offset(leftPadding, size.height - 16), textStyle);
    if (valoresPrimeiro.length > 1) {
      _drawText(canvas, 'Mês ${valoresPrimeiro.length}',
          Offset(size.width - 52, size.height - 16), textStyle);
    }
  }

  void _desenharSerie(
    Canvas canvas,
    List<double> values,
    Color color,
    double leftPadding,
    double topPadding,
    double chartWidth,
    double chartHeight,
    double scale,
  ) {
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final dotPaint = Paint()..color = color;
    final path = Path();
    final denominator = math.max(values.length - 1, 1);

    for (var index = 0; index < values.length; index++) {
      final x = leftPadding + chartWidth * index / denominator;
      final y = topPadding + chartHeight * (1 - values[index] / scale);
      final point = Offset(x, y);
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawCircle(point, 3.5, dotPaint);
    }
    canvas.drawPath(path, linePaint);
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant PintorGraficoInvestimentos oldDelegate) {
    return oldDelegate.valoresPrimeiro != valoresPrimeiro ||
        oldDelegate.valoresSegundo != valoresSegundo;
  }
}
