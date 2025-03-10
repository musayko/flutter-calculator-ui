import 'package:flutter/material.dart';
import 'calculator_button.dart';

class CalculatorButtons extends StatelessWidget {
  final Function(String) onButtonPressed;

  CalculatorButtons({required this.onButtonPressed});
  
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
        return CalculatorButton(
          buttons[index], 
          onPressed: () => onButtonPressed(buttons[index]),
        );
      }
    );
  }
}