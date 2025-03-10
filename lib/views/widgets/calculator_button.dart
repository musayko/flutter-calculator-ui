import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  
  const CalculatorButton(this.label, {super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _getButtonColor(label),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      )
    );
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