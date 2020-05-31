import 'package:flutter/foundation.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:neucalcu/models/record.dart';

class Calculate with ChangeNotifier {
  static String _instructions = 'Enter your equation';
  String _equation = _instructions;
  String _result = '';

  String get equation => _equation;

  String get result => _result;

  getButtonText({String buttonValue}) {
    if (buttonValue == 'AC') {
      _clearInput();
    } else if (buttonValue == 'Del') {
      _deleteLast();
    } else if (buttonValue == "=") {
      _displayAnswer();
    } else {
      _getButtonText(buttonValue);
    }
    notifyListeners();
  }

  _clearInput() {
    _equation = '0';
    _result = '';
  }

  _deleteLast() {
    if (_equation == _instructions) {
      _clearInput();
    }
    _equation = _equation.substring(0, _equation.length - 1);
    _calculateExpression(isPreviewActive: true);
    if (_equation == '') {
      _clearInput();
    }
  }

  _displayAnswer() {
    if (_result == 'Answer') {
      _removeCommaSeparator();
    }
    _calculateExpression(isPreviewActive: false);

    if (!(_result == 'Syntax Error')) {
      _saveRecord();
      _equation = _result;
      _result = 'Answer';
    }
  }

  void _saveRecord() {
    DateTime now = new DateTime.now();
    DateFormat formatter = new DateFormat('MMMM dd, yyyy');
    String formattedDate = formatter.format(now);

    Record record = Record(
      answer: _result,
      equation: _equation,
      date: formattedDate,
    );

    if (!(_result == 'Answer')) {
      Hive.box<Record>('records').add(record);
      print('Data: ${Hive.box<Record>('records').length}');
    }
  }

  _calculateExpression({bool isPreviewActive}) {
    String tempEquation = equation.replaceAll(',', '');
    String expression = tempEquation;
    expression = expression.replaceAll('×', '*');
    expression = expression.replaceAll('÷', '/');

    try {
      Parser p = Parser();
      Expression exp = p.parse(expression);

      ContextModel context = ContextModel();
      _result = '${exp.evaluate(EvaluationType.REAL, context)}';

      String tempResult = _result.replaceAll(',', '');

      FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
        amount: double.parse(tempResult),
        settings: MoneyFormatterSettings(
          fractionDigits: _getDecimalLength(),
        ),
      );

      _result = fmf.output.nonSymbol.toString();
    } catch (e) {
      if (!isPreviewActive) {
        _result = 'Syntax Error';
      }
    }
  }

  _getButtonText(String buttonValue) {
    _removeCommaSeparator();
    if (_equation == '0' || _equation == _instructions) {
      _equation = buttonValue;
    } else {
      _equation = _equation + buttonValue;
    }
    _calculateExpression(isPreviewActive: true);
  }

  _removeCommaSeparator() {
    String tempEquation = _equation.replaceAll(',', '');
    _equation = tempEquation;
  }

  int _getDecimalLength() {
    int startIndex = _result.indexOf('.') + 1;
    int endIndex = _result.length;

    String decimal = _result.substring(startIndex, endIndex);

    if (_result.contains('.') && _result.endsWith('0')) {
      return 0;
    } else {
      return decimal.length;
    }
  }
}
