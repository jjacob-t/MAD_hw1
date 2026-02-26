import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String display = '0';
  double? firstNumber;
  String? operator;
  bool _isDark = false;
  bool _waiting = false;

  // Single function for all button presses that checks which button was pressed and acts accordingly
  void onButtonPressed(String value) {
    setState(() {
      if (value == 'AC') {
        display = '0';
        firstNumber = null;
        operator = null;
        return;
      }

      // When an operator is pressed, parse the number in the display, store the operator, and signal waiting for second number
      if (value == '+' || value == '-' || value == '×' || value == '/') {
        firstNumber = double.parse(display);
        operator = value;
        display = '$firstNumber$operator'; 
        _waiting = true;
        return;
      }

      // With valid first num and operator, parse second number and perform operation
      if (value == '=') {
        if (firstNumber != null && operator != null) {
          double secondNumber = double.parse(display);
          double result = 0;

          switch (operator) {
            case '+':
              result = firstNumber! + secondNumber;
              break;
            case '-':
              result = firstNumber! - secondNumber;
              break;
            case '×':
              result = firstNumber! * secondNumber;
              break;
            case '/':
              // Dividing by 0 simply produces 0 instead of an error
              result = secondNumber == 0 ? 0 : firstNumber! / secondNumber;
              break;
          }

          display = result.toString();
          firstNumber = null;
          operator = null;
        }
        return;
      }

      // Second number pressed
      if (_waiting) {
        display = value;
        _waiting = false;
      } else if (display == '0') {
        display = value;
      } else {
        display += value;
      }
    });
  }

  void _toggleTheme() {
    setState(() {
    _isDark = !_isDark;
  });
}

  // Button building widget to avoid having 16 near identical ones later
  Widget buildButton(String text) {
    // Checks if the button being built is an operator
    final bool isOperator =  ['+', '-', '×', '/', '=', 'AC'].contains(text);

    // If the button is an operator, its color is blue. Else, it will be grey
    final Color baseColor = isOperator ? Colors.lightBlue : const Color(0xFF2E2E2E);
  return Expanded(
    child: AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: () => onButtonPressed(text),
          style: ButtonStyle(
            elevation: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return 0; // Elevation drops to 0 when pressed
              }
                return 10; // High rest elevation
            }),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.orange; // Buttons turn orange when pressed
              }
              return baseColor; // Appropriate base button color
            }),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calculator'),
          actions: [
            // Theme toggle button top right of appbar
            IconButton(
              onPressed: _toggleTheme,
              icon: Icon(_isDark ? Icons.light_mode : Icons.dark_mode),
              tooltip: 'Toggle Theme',
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Display area container
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(24),
                child: Text(
                  display,
                  style: TextStyle(
                    fontSize: 48,
                    color: _isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    // Labels and places for various buttons
                    Row(
                      children: [
                        buildButton('7'),
                        buildButton('8'),
                        buildButton('9'),
                        buildButton('/'),
                      ],
                    ),
                    Row(
                      children: [
                        buildButton('4'),
                        buildButton('5'),
                        buildButton('6'),
                        buildButton('×'),
                      ],
                    ),
                    Row(
                      children: [
                        buildButton('1'),
                        buildButton('2'),
                        buildButton('3'),
                        buildButton('-'),
                      ],
                    ),
                    Row(
                      children: [
                        buildButton('AC'),
                        buildButton('0'),
                        buildButton('='),
                        buildButton('+'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}