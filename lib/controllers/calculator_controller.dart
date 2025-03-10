import '../models/calculator_model.dart';

class CalculatorController {
  final CalculatorModel model = CalculatorModel();
  final void Function(String) updateDisplay;

  CalculatorController(this.updateDisplay);

  void handleButtonPress(String buttonText) {
    switch (buttonText) {
      case 'C':
        model.clear();
        break;
      case '⌫':
        model.delete();
        break;
      case '+':
      case '-':
      case '×':
      case '÷':
      case '%':
        model.setOperation(buttonText);
        break;
      case '=':
        model.calculate();
        break;
      case '.':
        model.appendDecimal();
        break;
      default:
        // Handle number buttons
        model.appendNumber(buttonText);
    }
    
    // Update UI with the current display value
    updateDisplay(model.displayValue);
  }
}