# Simulador de Investimentos

    Aplicativo Flutter para comparar dois investimentos usando juros compostos, aportes mensais e um período compartilhado.

## Funcionalidades

- Formulário para capital inicial, aporte mensal e taxa mensal de dois investimentos.
- Período da simulação em meses.
- Validação dos dados informados.
- Navegação entre a tela de entrada e a tela de resultados.
- Resumo lado a lado com montante final e rendimento total.
- Gráfico de linhas comparativo da evolução dos dois saldos.
- Lista comparativa da evolução mês a mês.
- Alternância para exibir o rendimento acumulado em cada mês.
- Botão para retornar e iniciar uma nova simulação.

## Fórmula

Ao final de cada mês, o saldo é calculado assim:

```text
saldo do mês = saldo anterior x (1 + taxa mensal / 100) + aporte mensal
```

O rendimento total é o montante final menos o capital inicial e a soma dos aportes mensais.

## Como executar

Com o Flutter instalado e configurado:

```bash
flutter pub get
flutter run
```

Para gerar uma versão Android:

```bash
flutter build apk
```

O APK de release será criado em `build/app/outputs/flutter-apk/app-release.apk`.

## Estrutura

- `lib/main.dart`: tema, formulário, modelo de investimento, cálculos e tela de resultados.
- `pubspec.yaml`: configuração e dependências do projeto.

## Exemplo de teste manual

Informe `1000` de capital, `100` de aporte mensal, `1` de taxa e `12` meses para os dois investimentos. Depois altere a taxa do segundo para `1,5` e compare a evolução na tabela.