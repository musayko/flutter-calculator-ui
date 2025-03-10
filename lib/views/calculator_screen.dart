import 'package:flutter/material.dart';
import '../controllers/calculator_controller.dart';
import 'widgets/calculator_buttons.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _displayValue = "0";
  late CalculatorController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller with callback to update display
    _controller = CalculatorController((value) {
      setState(() {
        _displayValue = value;
      });
    });
  }

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
              child: Text(
                _displayValue, // Dynamic display value
                style: const TextStyle(color: Colors.white, fontSize: 50),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            flex: 3, // Less space for buttons
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 26, 26, 26),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: CalculatorButtons(onButtonPressed: _controller.handleButtonPress),
            ),
          )
        ],
      ),
    );
  }
}