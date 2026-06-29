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
  double _firstOperand = 0;
  String _operator = '';
  bool _shouldResetDisplay = false;
  String _expression = '';
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
        _expression = '$value($_display)';
        _display = _formatResult(result);
        _shouldResetDisplay = true;
      } else if (value == '√') {
        double current = double.tryParse(_display) ?? 0;
        _expression = '√($_display)';
        _display = _formatResult(math.sqrt(current));
        _shouldResetDisplay = true;
      } else if (value == 'log') {
        double current = double.tryParse(_display) ?? 0;
        _expression = 'log($_display)';
        _display = _formatResult(math.log(current) / math.ln10);
        _shouldResetDisplay = true;
      } else if (value == 'ln') {
        double current = double.tryParse(_display) ?? 0;
        _expression = 'ln($_display)';
        _display = _formatResult(math.log(current));
        _shouldResetDisplay = true;
      } else if (value == 'x²') {
        double current = double.tryParse(_display) ?? 0;
        _expression = '($_display)²';
        _display = _formatResult(current * current);
        _shouldResetDisplay = true;
      } else if (value == 'xʸ') {
        _firstOperand = double.tryParse(_display) ?? 0;
        _expression = '$_display^';
        _operator = 'xʸ';
        _shouldResetDisplay = true;
      } else if (value == '1/x') {
        double current = double.tryParse(_display) ?? 0;
        _expression = '1/($_display)';
        _display = current == 0 ? 'Error' : _formatResult(1 / current);
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
        _expression = '$_display%';
        _display = _formatResult(current / 100);
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
          _expression = '$_expression $_display =';
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
          }
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

  Widget _buildButton(String label,
      {Color? bgColor,
      Color? textColor,
      Color? glowColor,
      bool isSmall = false}) {
    return GestureDetector(
        onTap: () => _onButtonPressed(label),
        child: Container(
            margin: EdgeInsets.all(isSmall ? 3 : 6),
            decoration: BoxDecoration(
                color: bgColor ?? const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(20),
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
                      offset: const Offset(0, 3))
                ]),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: isSmall ? 16 : 20,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    const Color operatorColor = Color(0xFFFF9500);
    const Color topRowColor = Color(0xFF505050);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
          child: Column(
        children: [
          //Display
          Expanded(
              flex: 2,
              child: Container(
                  width: double.infinity,
                  alignment: Alignment.bottomRight,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.04),
                      border: Border(
                          bottom: BorderSide(
                        color: Colors.white.withValues(alpha: 0.08),
                        width: 1,
                      ))),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _expression,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Text(
                              _display,
                              style: const TextStyle(
                                fontSize: 72,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            ))
                      ]))),
          //Scientific buttons
          Expanded(
            flex: 3,
            child: GridView.count(
              crossAxisCount: 4,
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.8,
              children: [
                _buildButton('sin',
                    bgColor: const Color(0xFF1C1C1C),
                    textColor: const Color(0xFF00BFFF),
                    isSmall: true),
                _buildButton('cos',
                    bgColor: const Color(0xFF1C1C1C),
                    textColor: const Color(0xFF00BFFF),
                    isSmall: true),
                _buildButton('tan',
                    bgColor: const Color(0xFF1C1C1C),
                    textColor: const Color(0xFF00BFFF),
                    isSmall: true),
                _buildButton(_isDegree ? 'DEG' : 'RAD',
                    bgColor: const Color(0xFF1C1C1C),
                    textColor: const Color(0xFF00BFFF),
                    isSmall: true),
                _buildButton('√',
                    bgColor: const Color(0xFF1C1C1C),
                    textColor: const Color(0xFF00BFFF),
                    isSmall: true),
                _buildButton('log',
                    bgColor: const Color(0xFF1C1C1C),
                    textColor: const Color(0xFF00BFFF),
                    isSmall: true),
                _buildButton('ln',
                    bgColor: const Color(0xFF1C1C1C),
                    textColor: const Color(0xFF00BFFF),
                    isSmall: true),
                _buildButton('π',
                    bgColor: const Color(0xFF1C1C1C),
                    textColor: const Color(0xFF00BFFF),
                    isSmall: true),
                _buildButton('x²',
                    bgColor: const Color(0xFF1C1C1C),
                    textColor: const Color(0xFF00BFFF),
                    isSmall: true),
                _buildButton('xʸ',
                    bgColor: const Color(0xFF1C1C1C),
                    textColor: const Color(0xFF00BFFF),
                    isSmall: true),
                _buildButton('1/x',
                    bgColor: const Color(0xFF1C1C1C),
                    textColor: const Color(0xFF00BFFF),
                    isSmall: true),
                _buildButton('e',
                    bgColor: const Color(0xFF1C1C1C),
                    textColor: const Color(0xFF00BFFF),
                    isSmall: true),
              ],
            ),
          ),
          //Main Buttons
          Expanded(
            flex: 5,
            child: GridView.count(
              crossAxisCount: 4,
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildButton('C', bgColor: const Color(0xFF505050)),
                _buildButton('⌫', bgColor: const Color(0xFF505050)),
                _buildButton('%', bgColor: const Color(0xFF505050)),
                _buildButton('÷',
                    bgColor: operatorColor, glowColor: operatorColor),
                _buildButton('7'),
                _buildButton('8'),
                _buildButton('9'),
                _buildButton('×',
                    bgColor: operatorColor, glowColor: operatorColor),
                _buildButton('4'),
                _buildButton('5'),
                _buildButton('6'),
                _buildButton('-',
                    bgColor: operatorColor, glowColor: operatorColor),
                _buildButton('1'),
                _buildButton('2'),
                _buildButton('3'),
                _buildButton('+',
                    bgColor: operatorColor, glowColor: operatorColor),
                _buildButton('+/-'),
                _buildButton('0'),
                _buildButton('.'),
                _buildButton('=',
                    bgColor: operatorColor, glowColor: operatorColor),
              ],
            ),
          )
        ],
      )),
    );
  }
}
