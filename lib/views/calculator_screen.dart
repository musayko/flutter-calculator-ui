// lib/views/calculator_screen.dart
import 'package:flutter/material.dart';
import '../controllers/calculator_controller.dart';
import 'widgets/calculator_buttons.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _displayValue = "0"; // This will hold the expression or result
  late CalculatorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalculatorController((value) {
      if (mounted) {
        setState(() {
          _displayValue = value; // Update display from controller
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        // ... (Keep your existing AppBar with title and actions)
        backgroundColor: Colors.black,
        title: const Text('Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Calculation History',
            onPressed: () {
              Navigator.pushNamed(context, '/history');
            },
          ),
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            tooltip: 'Km to Mile Converter',
            onPressed: () {
              Navigator.pushNamed(context, '/converter');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SingleChildScrollView( // Important for long expressions
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Text(
                  _displayValue, // Display the expression or result
                  style: const TextStyle(color: Colors.white, fontSize: 50), // Adjust font size if needed
                  textAlign: TextAlign.right,
                  maxLines: 1,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 26, 26, 26),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: CalculatorButtons(onButtonPressed: (buttonText) {
                 _controller.handleButtonPress(buttonText);
              }),
            ),
          )
        ],
      ),
    );
  }
}