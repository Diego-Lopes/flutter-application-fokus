import 'dart:async';

import 'package:flutter/material.dart';

class TimerViewModel extends ChangeNotifier {
  bool isPlaying = false;

  Timer? timer;
  Duration duration = Duration.zero;

  void startTime(int initialMinutes) {
    duration = Duration.zero;
    isPlaying = true;
    notifyListeners(); //isso se chama change notifer

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (duration.inMinutes < initialMinutes) {
        duration += Duration(seconds: 1);
        notifyListeners();
      } else {
        stopTime();
      }
    });
  }

  void stopTime() {
    notifyListeners();
    isPlaying = false;
    timer?.cancel();
  }
}
