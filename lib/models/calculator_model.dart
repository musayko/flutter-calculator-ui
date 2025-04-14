// lib/models/calculator_model.dart
import 'package:math_expressions/math_expressions.dart';
import 'package:intl/intl.dart';

class CalculatorModel {
  String _expressionString = "0"; // Stores the expression being built
  String _displayValue = "0"; // What the user sees (can be expression or result)
  String? _lastCalculation; // For history ("5+6/2 = 8")
  bool _evaluated = false; // Flag to check if the last action was '='

  // Use a parser from the math_expressions package
  Parser p = Parser();
  ContextModel cm = ContextModel(); // Context for evaluation (can be empty for simple cases)

  String get displayValue => _displayValue;
  String? get lastCalculation => _lastCalculation;

  void clear() {
    _expressionString = "0";
    _displayValue = "0";
    _lastCalculation = null;
    _evaluated = false;
  }

  void delete() {
    if (_evaluated) { // If result is shown, clear instead of deleting
      clear();
      return;
    }
    if (_displayValue.length > 1) {
      _displayValue = _displayValue.substring(0, _displayValue.length - 1);
      // Ensure expression string is consistent if display was showing it
      _expressionString = _displayValue;
    } else {
      clear(); // Clear if only one character left
    }
     // Handle case where deletion results in an empty string
    if (_displayValue.isEmpty) {
       clear();
    }
  }

  // Appends a number or operator to the expression
  void _appendToExpression(String value) {
    // If the last action was evaluation, start a new expression
    // unless the new value is an operator
    if (_evaluated) {
        if (['+', '-', '×', '÷', '%'].contains(value)) {
             // Start new expression with previous result + new operator
            _expressionString = _displayValue;
        } else {
            // Start completely new expression with the number
            _expressionString = "";
        }
       _evaluated = false; // Reset flag
    }


    // Handle initial '0'
    if (_expressionString == "0" && !['+', '-', '×', '÷', '%', '.'].contains(value)) {
      _expressionString = value;
    } else {
      _expressionString += value;
    }
    _displayValue = _expressionString; // Update display
  }


  void appendNumber(String number) {
     // If evaluated, allow starting new number
    if (_evaluated) {
        _expressionString = number;
        _displayValue = _expressionString;
        _evaluated = false;
        return;
    }
     // Prevent excessively long inputs (optional)
    if (_displayValue.length < 20) {
        if (_expressionString == "0") {
          _expressionString = number;
        } else {
          _expressionString += number;
        }
        _displayValue = _expressionString;
    }
  }

 void appendOperator(String operator) {
    // If evaluated, use the result as the first operand
    if (_evaluated) {
      _expressionString = _displayValue; // Start with the previous result
      _evaluated = false;
    }

    if (_expressionString.isEmpty) return; // Don't add operator if empty

    // Prevent adding multiple operators consecutively (basic check)
    String lastChar = _expressionString.substring(_expressionString.length - 1);
    if (['+', '-', '×', '÷', '%'].contains(lastChar)) {
       // Replace the last operator with the new one
        _expressionString = _expressionString.substring(0, _expressionString.length - 1) + operator;
    } else {
      _expressionString += operator;
    }
     _displayValue = _expressionString; // Show the updated expression
  }

  void appendDecimal() {
     if (_evaluated) {
      _expressionString = "0.";
      _displayValue = _expressionString;
      _evaluated = false;
      return;
    }
     // Avoid multiple decimals in the last number segment
     // Find the last operator
    int lastOperatorIndex = _expressionString.lastIndexOf(RegExp(r'[\+\-×÷%]'));
    String lastSegment = (lastOperatorIndex == -1)
        ? _expressionString
        : _expressionString.substring(lastOperatorIndex + 1);

    if (!lastSegment.contains('.')) {
      if (_expressionString.length < 20) { // Prevent excessively long inputs (optional)
         _expressionString += ".";
         _displayValue = _expressionString;
      }
    }
  }

  // This replaces setOperation and calculate from the previous model
  void evaluateExpression() {
    if (_evaluated) return; // Don't re-evaluate if already evaluated

    try {
       // Replace user-facing operators with ones the package understands
       String expressionToParse = _expressionString.replaceAll('×', '*').replaceAll('÷', '/');

       // Ensure expression doesn't end with an operator (basic check)
       String lastChar = expressionToParse.isNotEmpty ? expressionToParse.substring(expressionToParse.length - 1) : "";
       if (['+', '-', '*', '/', '%'].contains(lastChar)) {
         expressionToParse = expressionToParse.substring(0, expressionToParse.length - 1);
       }

       if (expressionToParse.isEmpty) {
           clear();
           return;
       }

      Expression exp = p.parse(expressionToParse);
      double result = exp.evaluate(EvaluationType.REAL, cm);

      String resultString;
      // Format result nicely
      if (result == result.toInt()) {
        resultString = result.toInt().toString();
      } else {
        resultString = result.toStringAsFixed(5); // Adjust precision as needed
        resultString = resultString.replaceAll(RegExp(r'0+$'), ''); // Remove trailing zeros
        if (resultString.endsWith('.')) {
          resultString = resultString.substring(0, resultString.length - 1);
        }
      }

      // Limit result length (optional)
      if (resultString.length > 15) {
         resultString = result.toStringAsExponential(9); // Use scientific notation
      }


      // Store for history: Original expression = result
      _lastCalculation = "$_expressionString = $resultString";

      // Update display and internal state
      _displayValue = resultString;
      _expressionString = resultString; // Keep result for potential chained calculation
      _evaluated = true; // Set evaluated flag

    } catch (e) {
      // Handle errors (e.g., division by zero, invalid syntax)
      _displayValue = "Error";
      _expressionString = "0"; // Reset expression on error
      _lastCalculation = null;
       _evaluated = true; // Treat error as evaluated state to force clear on next input
      print("Evaluation Error: $e"); // Log error for debugging
    }
  }
}