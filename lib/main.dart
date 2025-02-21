import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorUI(),
    );
  }
}

class CalculatorUI extends StatelessWidget {
  const CalculatorUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 2, // Gives more space for display
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              child: const Text(
                "0", // Default display
                style: TextStyle(color: Colors.white, fontSize: 50),
              ),
            ),
          ),
          Expanded(
            flex: 3, // Less space for buttons
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 26, 26, 26),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: CalculatorButtons(),
            ),
            )
        ],
      ),
    );
  }
}

class CalculatorButtons extends StatelessWidget {
  final List<String> buttons = [
    'C',
    '⌫',
    '%',
    '÷',
    '7',
    '8',
    '9',
    '×',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    '=',
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, //4 buttons per row
            childAspectRatio: 1.2 // Aspect ratio of each button
            ),
        itemCount: buttons.length,
        itemBuilder: (context, index) {
          return CalculatorButton(buttons[index]);
        });
  }
}

class CalculatorButton extends StatelessWidget {
  final String label;
  const CalculatorButton(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // Handle button press
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getButtonColor(label),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }

  Color _getButtonColor(String label) {
    if (label == 'C' || label == '⌫') {
      return Colors.red;
    } else if (label == '=' ||
        label == '+' ||
        label == '-' ||
        label == '×' ||
        label == '÷') {
      return Colors.orange;
    } else {
      return Colors.grey[800]!;
    }
  }
}
