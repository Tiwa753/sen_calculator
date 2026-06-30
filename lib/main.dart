import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  double _firstOperand = 0;
  String _operator = '';
  bool _shouldResetDisplay = false;
  bool _isDegree = true;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _display = '0';
        _expression = '';
        _firstOperand = 0;
        _operator = '';
        _shouldResetDisplay = false;
      } else if (value == '⌫') {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = '0';
        }
      } else if (value == 'sin' || value == 'cos' || value == 'tan') {
        double current = double.tryParse(_display) ?? 0;
        double angle = _isDegree ? current * math.pi / 180 : current;
        double result = 0;
        if (value == 'sin') result = math.sin(angle);
        if (value == 'cos') result = math.cos(angle);
        if (value == 'tan') result = math.tan(angle);
        _expression = '$value($_display) = ${_formatResult(result)}';
        _display = _formatResult(result);
        _shouldResetDisplay = true;
      } else if (value == '√') {
        double current = double.tryParse(_display) ?? 0;
        double result = math.sqrt(current);
        _expression = '√($_display) = ${_formatResult(result)}';
        _display = _formatResult(result);
        _shouldResetDisplay = true;
      } else if (value == 'log') {
        double current = double.tryParse(_display) ?? 0;
        double result = math.log(current) / math.ln10;
        _expression = 'log($_display) = ${_formatResult(result)}';
        _display = _formatResult(result);
        _shouldResetDisplay = true;
      } else if (value == 'ln') {
        double current = double.tryParse(_display) ?? 0;
        double result = math.log(current);
        _expression = 'ln($_display) = ${_formatResult(result)}';
        _display = _formatResult(result);
        _shouldResetDisplay = true;
      } else if (value == 'x²') {
        double current = double.tryParse(_display) ?? 0;
        double result = current * current;
        _expression = '($_display)² = ${_formatResult(result)}';
        _display = _formatResult(result);
        _shouldResetDisplay = true;
      } else if (value == 'xʸ') {
        _firstOperand = double.tryParse(_display) ?? 0;
        _expression = '$_display^';
        _operator = 'xʸ';
        _shouldResetDisplay = true;
      } else if (value == 'sinh' || value == 'cosh' || value == 'tanh') {
        double x = double.tryParse(_display) ?? 0;
        double result = 0;
        if (value == 'sinh') result = (math.exp(x) - math.exp(-x)) / 2;
        if (value == 'cosh') result = (math.exp(x) + math.exp(-x)) / 2;
        if (value == 'tanh') {
          double sinhX = (math.exp(x) - math.exp(-x)) / 2;
          double coshX = (math.exp(x) + math.exp(-x)) / 2;
          result = sinhX / coshX;
        }
        _expression = '$value($_display) = ${_formatResult(result)}';
        _display = _formatResult(result);
        _shouldResetDisplay = true;
      } else if (value == '∛') {
        double x = double.tryParse(_display) ?? 0;
        double result = x < 0
            ? -math.pow(-x, 1 / 3).toDouble()
            : math.pow(x, 1 / 3).toDouble();
        _expression = '∛($_display) = ${_formatResult(result)}';
        _display = _formatResult(result);
        _shouldResetDisplay = true;
      } else if (value == '|x|') {
        double x = double.tryParse(_display) ?? 0;
        double result = x.abs();
        _expression = '|$_display| = ${_formatResult(result)}';
        _display = _formatResult(result);
        _shouldResetDisplay = true;
      } else if (value == 'x!') {
        double x = double.tryParse(_display) ?? 0;
        if (x < 0 || x % 1 != 0) {
          _display = 'Error';
        } else {
          double result = _factorial(x.toInt());
          _expression = '$_display! = ${_formatResult(result)}';
          _display = _formatResult(result);
        }
        _shouldResetDisplay = true;
      } else if (value == 'EXP') {
        double x = double.tryParse(_display) ?? 0;
        double result = math.pow(10, x).toDouble();
        _expression = '10^$_display = ${_formatResult(result)}';
        _display = _formatResult(result);
        _shouldResetDisplay = true;
      } else if (value == 'nPr' || value == 'nCr' || value == 'mod') {
        _firstOperand = double.tryParse(_display) ?? 0;
        _expression = '$_display $value';
        _operator = value;
        _shouldResetDisplay = true;
      } else if (value == '1/x') {
        double current = double.tryParse(_display) ?? 0;
        if (current == 0) {
          _display = 'Error';
        } else {
          double result = 1 / current;
          _expression = '1/($_display) = ${_formatResult(result)}';
          _display = _formatResult(result);
        }
        _shouldResetDisplay = true;
      } else if (value == 'π') {
        _display = _formatResult(math.pi);
        _shouldResetDisplay = false;
      } else if (value == 'e') {
        _display = _formatResult(math.e);
        _shouldResetDisplay = false;
      } else if (value == 'DEG' || value == 'RAD') {
        _isDegree = !_isDegree;
      } else if (value == '%') {
        double current = double.tryParse(_display) ?? 0;
        double result = current / 100;
        _expression = '$_display% = ${_formatResult(result)}';
        _display = _formatResult(result);
        _shouldResetDisplay = true;
      } else if (value == '+/-') {
        double current = double.tryParse(_display) ?? 0;
        _display = _formatResult(-current);
      } else if (['+', '-', '×', '÷'].contains(value)) {
        _firstOperand = double.tryParse(_display) ?? 0;
        _expression = '$_display $value';
        _operator = value;
        _shouldResetDisplay = true;
      } else if (value == '=') {
        if (_operator.isNotEmpty) {
          double secondOperand = double.tryParse(_display) ?? 0;
          double result = 0;
          switch (_operator) {
            case '+':
              result = _firstOperand + secondOperand;
              break;
            case '-':
              result = _firstOperand - secondOperand;
              break;
            case '×':
              result = _firstOperand * secondOperand;
              break;
            case '÷':
              if (secondOperand == 0) {
                _display = 'Error';
                _operator = '';
                _shouldResetDisplay = true;
                return;
              }
              result = _firstOperand / secondOperand;
              break;
            case 'xʸ':
              result = math.pow(_firstOperand, secondOperand).toDouble();
              break;
            case 'nPr':
              result = _permutation(_firstOperand, secondOperand);
              break;
            case 'nCr':
              result = _combination(_firstOperand, secondOperand);
              break;
            case 'mod':
              result = _firstOperand % secondOperand;
              break;
          }
          if (result.isNaN) {
            _display = 'Error';
            _operator = '';
            _shouldResetDisplay = true;
            return;
          }
          _expression = '$_expression $_display = ${_formatResult(result)}';
          _display = _formatResult(result);
          _operator = '';
          _shouldResetDisplay = true;
        }
      } else if (value == '.') {
        if (_shouldResetDisplay) {
          _display = '0.';
          _shouldResetDisplay = false;
        } else if (!_display.contains('.')) {
          _display += '.';
        }
      } else {
        if (_shouldResetDisplay || _display == '0') {
          _display = value;
          _shouldResetDisplay = false;
        } else {
          if (_display.length < 10) _display += value;
        }
      }
    });
  }

  String _formatResult(double result) {
    if (result % 1 == 0) {
      return result.toInt().toString();
    } else {
      return double.parse(result.toStringAsFixed(8)).toString();
    }
  }

  double _factorial(int n) {
    if (n <= 1) return 1;
    double result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }

  double _permutation(double n, double r) {
    int ni = n.toInt();
    int ri = r.toInt();
    if (ni < 0 || ri < 0 || ri > ni) return double.nan;
    return _factorial(ni) / _factorial(ni - ri);
  }

  double _combination(double n, double r) {
    int ni = n.toInt();
    int ri = r.toInt();
    if (ni < 0 || ri < 0 || ri > ni) return double.nan;
    return _factorial(ni) / (_factorial(ri) * _factorial(ni - ri));
  }

  Widget _buildButton(String label,
      {Color? bgColor,
      Color? textColor,
      Color? glowColor,
      bool isSmall = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _onButtonPressed(label),
        child: Container(
          margin: EdgeInsets.all(isSmall ? 3 : 5),
          decoration: BoxDecoration(
            color: bgColor ?? const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(isSmall ? 12 : 18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
            boxShadow: [
              if (glowColor != null)
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.5),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isSmall ? 13 : 20,
                fontWeight: FontWeight.w500,
                color: textColor ?? Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(List<Widget> buttons) {
    return Expanded(
      child: Row(children: buttons),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color operatorColor = Color(0xFFFF9500);
    const Color topRowColor = Color(0xFF505050);
    const Color sciColor = Color(0xFF00BFFF);
    const Color sciBgColor = Color(0xFF1C1C1C);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            // Display area
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                alignment: Alignment.bottomRight,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withValues(alpha: 0.08),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _expression,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        _display,
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scientific buttons - 3 rows
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(3, 6, 3, 0),
                child: Column(
                  children: [
                    _buildRow([
                      _buildButton('sin',
                          bgColor: sciBgColor,
                          textColor: sciColor,
                          isSmall: true),
                      _buildButton('cos',
                          bgColor: sciBgColor,
                          textColor: sciColor,
                          isSmall: true),
                      _buildButton('tan',
                          bgColor: sciBgColor,
                          textColor: sciColor,
                          isSmall: true),
                      _buildButton(_isDegree ? 'DEG' : 'RAD',
                          bgColor: sciBgColor,
                          textColor: sciColor,
                          isSmall: true),
                    ]),
                    _buildRow([
                      _buildButton('√',
                          bgColor: sciBgColor,
                          textColor: sciColor,
                          isSmall: true),
                      _buildButton('log',
                          bgColor: sciBgColor,
                          textColor: sciColor,
                          isSmall: true),
                      _buildButton('ln',
                          bgColor: sciBgColor,
                          textColor: sciColor,
                          isSmall: true),
                      _buildButton('π',
                          bgColor: sciBgColor,
                          textColor: sciColor,
                          isSmall: true),
                    ]),
                    _buildRow([
                      _buildButton('x²',
                          bgColor: sciBgColor,
                          textColor: sciColor,
                          isSmall: true),
                      _buildButton('xʸ',
                          bgColor: sciBgColor,
                          textColor: sciColor,
                          isSmall: true),
                      _buildButton('1/x',
                          bgColor: sciBgColor,
                          textColor: sciColor,
                          isSmall: true),
                      _buildButton('e',
                          bgColor: sciBgColor,
                          textColor: sciColor,
                          isSmall: true),
                    ]),
                  ],
                ),
              ),
            ),

            // Extra functions - 2 rows x 5 (new)
            SizedBox(
              height: 88,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(3, 4, 3, 0),
                child: Column(
                  children: [
                    _buildRow([
                      _buildButton('sinh',
                          bgColor: sciBgColor,
                          textColor: sciColor,
                          isSmall: true),
                      _buildButton('cosh',
                          bgColor: sciBgColor,
                          textColor: sciColor,
                          isSmall: true),
                      _buildButton('tanh',
                          bgColor: sciBgColor,
                          textColor: sciColor,
                          isSmall: true),
                      _buildButton('nPr',
                          bgColor: sciBgColor,
                          textColor: sciColor,
                          isSmall: true),
                      _buildButton('nCr',
                          bgColor: sciBgColor,
                          textColor: sciColor,
                          isSmall: true),
                    ]),
                    _buildRow([
                      _buildButton('x!',
                          bgColor: sciBgColor,
                          textColor: sciColor,
                          isSmall: true),
                      _buildButton('∛',
                          bgColor: sciBgColor,
                          textColor: sciColor,
                          isSmall: true),
                      _buildButton('|x|',
                          bgColor: sciBgColor,
                          textColor: sciColor,
                          isSmall: true),
                      _buildButton('mod',
                          bgColor: sciBgColor,
                          textColor: sciColor,
                          isSmall: true),
                      _buildButton('EXP',
                          bgColor: sciBgColor,
                          textColor: sciColor,
                          isSmall: true),
                    ]),
                  ],
                ),
              ),
            ),

            // Main buttons - 5 rows
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(3, 0, 3, 6),
                child: Column(
                  children: [
                    _buildRow([
                      _buildButton('C', bgColor: topRowColor),
                      _buildButton('⌫', bgColor: topRowColor),
                      _buildButton('%', bgColor: topRowColor),
                      _buildButton('÷',
                          bgColor: operatorColor, glowColor: operatorColor),
                    ]),
                    _buildRow([
                      _buildButton('7'),
                      _buildButton('8'),
                      _buildButton('9'),
                      _buildButton('×',
                          bgColor: operatorColor, glowColor: operatorColor),
                    ]),
                    _buildRow([
                      _buildButton('4'),
                      _buildButton('5'),
                      _buildButton('6'),
                      _buildButton('-',
                          bgColor: operatorColor, glowColor: operatorColor),
                    ]),
                    _buildRow([
                      _buildButton('1'),
                      _buildButton('2'),
                      _buildButton('3'),
                      _buildButton('+',
                          bgColor: operatorColor, glowColor: operatorColor),
                    ]),
                    _buildRow([
                      _buildButton('+/-'),
                      _buildButton('0'),
                      _buildButton('.'),
                      _buildButton('=',
                          bgColor: operatorColor, glowColor: operatorColor),
                    ]),
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
