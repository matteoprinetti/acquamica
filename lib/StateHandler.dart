import 'package:flutter/cupertino.dart';
import 'dart:developer' as developer;

enum appState {
  BOOTSTRAP,
  SPLASH,
  TUTORIAL,
  MAIN,
  NOSIM,
  ADMIN
}

class StateHandler extends ChangeNotifier {
  appState state = appState.BOOTSTRAP;

  StateHandler({required appState pState}) {
    developer.log("StateHandler constructor");

    // if the tutorial is gone already - show
    state = pState;
  }

  refresh() {
    // just send a notify again
    notifyListeners(); // valori iniziali
  }

  void setState(appState _state) {
    state = _state;
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }
}
