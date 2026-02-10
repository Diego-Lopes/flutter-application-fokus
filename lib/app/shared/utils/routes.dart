import 'package:flutter/material.dart';
import 'package:fokus/app/shared/enums/timer_type.dart';
import 'package:fokus/app/view/pages/home_page.dart';
import 'package:fokus/app/view/pages/timer_page.dart';

Map<String, Widget Function(BuildContext)> get routes =>
    <String, WidgetBuilder>{
      '/home': (context) => HomePage(),
      '/timer': (context) => TimerPage(
        timerType:
            (ModalRoute.of(context)?.settings.arguments as TimerType?) ??
            TimerType.focus,
      ),
    };
