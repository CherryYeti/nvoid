import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'NVoid',
      theme: ThemeData(
        fontFamily: 'ndot45',
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: const Color(0xFFFFFFFF),
          onPrimary: const Color(0xFF000000),
          secondary: const Color(0xFFD71921),
          onSecondary: const Color(0xFFFFFFFF),
          tertiary: const Color(0xFF1B1B1D),
          onTertiary: const Color(0xFFFFFFFF),
          error: const Color(0xFFFF0000),
          onError: const Color(0xFFFFFFFF),
          surface: const Color(0xFF000000),
          onSurface: const Color(0xFFFFFFFF),
        ),
      ),
      home: const MyCalculator(),
    );
  }
}

class MyCalculator extends StatefulWidget {
  const MyCalculator({super.key});

  @override
  _MyCalculatorState createState() => _MyCalculatorState();
}

class _MyCalculatorState extends State<MyCalculator> {
  String _expression = '';
  String _result = '';

  bool _isOperator(String label) {
    return label == '/' ||
        label == '×' ||
        label == '−' ||
        label == '+' ||
        label == '=';
  }

  Widget _buildCalcButton(String label, {int flex = 1}) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    Color backgroundColor;
    Color foregroundColor;
    if (label == 'AC') {
      backgroundColor = colorScheme.primary;
      foregroundColor = colorScheme.secondary;
    } else if (_isOperator(label)) {
      backgroundColor = colorScheme.secondary;
      foregroundColor = colorScheme.onSecondary;
    } else {
      backgroundColor = colorScheme.tertiary;
      foregroundColor = colorScheme.onTertiary;
    }

    final bool isZeroButton = label == '0' && flex > 1;
    final shape = isZeroButton ? const StadiumBorder() : const CircleBorder();

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: SizedBox(
          height: isZeroButton ? 80 : null,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              shape: shape,
              padding: EdgeInsets.zero,
            ),
            onPressed: () => _onButtonPressed(label),
            child: Center(
              child: Text(label, style: const TextStyle(fontSize: 20)),
            ),
          ),
        ),
      ),
    );
  }

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        _expression = '';
        _result = '';
      } else if (buttonText == '=') {
        try {
          String finalExpression = _expression
              .replaceAll('×', '*')
              .replaceAll('−', '-')
              .replaceAll('%', '/100')
              .replaceAllMapped(RegExp(r'(\d)\('), (Match m) => '${m[1]}*(')
              .replaceAllMapped(RegExp(r'\)(\d)'), (Match m) => ')*${m[1]}');
          Parser p = Parser();
          Expression exp = p.parse(finalExpression);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          _result = eval.toString();
        } catch (e) {
          _result = 'Error';
        }
      } else if (buttonText == '+-') {
        if (_expression.startsWith('-')) {
          _expression = _expression.substring(1);
        } else {
          _expression = '-$_expression';
        }
      } else {
        _expression += buttonText;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                color: Theme.of(context).colorScheme.surface,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _expression,
                      style: TextStyle(
                        fontSize: 32,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _result,
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          _buildCalcButton('AC'),
                          _buildCalcButton('%'),
                          _buildCalcButton('+-'),
                          _buildCalcButton('/'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildCalcButton('7'),
                          _buildCalcButton('8'),
                          _buildCalcButton('9'),
                          _buildCalcButton('×'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildCalcButton('4'),
                          _buildCalcButton('5'),
                          _buildCalcButton('6'),
                          _buildCalcButton('−'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildCalcButton('1'),
                          _buildCalcButton('2'),
                          _buildCalcButton('3'),
                          _buildCalcButton('+'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildCalcButton('0', flex: 2),
                          _buildCalcButton('.'),
                          _buildCalcButton('='),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
