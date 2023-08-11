import 'package:flutter/material.dart';

class Animate with ChangeNotifier {
  bool showAnswer = false;
  late AnimationController leadingController;
  late AnimationController trailingController;

  void start() {
    if (showAnswer) {
      showAnswer = false;
      _reverse(controller: leadingController);
      _reverse(controller: trailingController);
    } else {
      showAnswer = true;
      _forward(controller: leadingController);
      _forward(controller: trailingController);
    }
    notifyListeners();
  }

  void _forward({required AnimationController controller}) {
    controller.forward(from: 0.0);
  }

  void _reverse({required AnimationController controller}) {
    controller.reverse(from: 1.0);
  }
}
