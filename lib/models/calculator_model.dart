class CalculatorModel {
  String _input = "0";
  String _previousInput = "";
  String _operation = "";
  bool _shouldResetInput = false;

  String get displayValue => _input;

  void clear() {
    _input = "0";
    _previousInput = "";
    _operation = "";
    _shouldResetInput = false;
  }

  void delete() {
    if (_input.length > 1) {
      _input = _input.substring(0, _input.length - 1);
    } else {
      _input = "0";
    }
  }

  void appendNumber(String number) {
    if (_input == "0" || _shouldResetInput) {
      _input = number;
      _shouldResetInput = false;
    } else {
      _input = _input + number;
    }
  }

  void appendDecimal() {
    if (_shouldResetInput) {
      _input = "0.";
      _shouldResetInput = false;
      return;
    }
    
    if (!_input.contains(".")) {
      _input = _input + ".";
    }
  }

  void setOperation(String operation) {
    if (_previousInput.isNotEmpty && !_shouldResetInput) {
      calculate();
    }
    
    _operation = operation;
    _previousInput = _input;
    _shouldResetInput = true;
  }

  void calculate() {
    if (_operation.isEmpty || _previousInput.isEmpty) return;

    double num1 = double.parse(_previousInput);
    double num2 = double.parse(_input);
    double result = 0;

    switch (_operation) {
      case "+":
        result = num1 + num2;
        break;
      case "-":
        result = num1 - num2;
        break;
      case "×":
        result = num1 * num2;
        break;
      case "÷":
        if (num2 != 0) {
          result = num1 / num2;
        } else {
          _input = "Error";
          _previousInput = "";
          _operation = "";
          _shouldResetInput = true;
          return;
        }
        break;
      case "%":
        result = num1 % num2;
        break;
    }

    // Handle integer results to avoid displaying .0
    if (result == result.toInt()) {
      _input = result.toInt().toString();
    } else {
      _input = result.toString();
    }
    
    _previousInput = "";
    _operation = "";
    _shouldResetInput = true;
  }
}