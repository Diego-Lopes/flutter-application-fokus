import 'package:flutter/material.dart';
import 'package:fokus/app/shared/utils/app_config.dart';
import 'package:fokus/app/view_model/timer_view_model.dart';
import 'package:provider/provider.dart';

class TimerWidget extends StatefulWidget {
  final int initialMinutes;

  const TimerWidget({super.key, required this.initialMinutes});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late TimerViewModel timerViewModel;
  final isPausedNotifer = ValueNotifier<bool>(false);

  @override
  void initState() {
    timerViewModel = Provider.of<TimerViewModel>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timerViewModel.stopTime();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(20, 68, 128, 0.5),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xff144480), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: timerViewModel,
            builder: (context, child) {
              final duration = timerViewModel.duration;

              return Text(
                "${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}",
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'monospace',
                ),
              );
            },
          ),

          // Timer
          const SizedBox(height: 40),

          // Botões de controle
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ListenableBuilder(
              listenable: timerViewModel,
              builder: (context, child) {
                bool isPlaying = timerViewModel.isPlaying;
                return ElevatedButton(
                  onPressed: () {
                    if (isPlaying) {
                      timerViewModel.stopTime();
                    } else {
                      timerViewModel.startTime(
                        widget.initialMinutes,
                        isPausedNotifer,
                      );
                    }
                    isPausedNotifer.value = false;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPlaying
                        ? Colors.red
                        : AppConfig.buttonColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isPlaying ? Icons.stop : Icons.play_arrow,
                        color: AppConfig.backgroundColor,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isPlaying ? "Parar" : "Iniciar",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppConfig.backgroundColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          ValueListenableBuilder(
            valueListenable: isPausedNotifer,
            builder: (context, value, child) {
              if (!timerViewModel.isPlaying) return SizedBox.shrink();
              return ListenableBuilder(
                listenable: timerViewModel,
                builder: (context, child) {
                  return SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        isPausedNotifer.value = !value;
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            value ? Icons.play_circle : Icons.pause,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            value ? "Continuar" : "Pausar",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppConfig.backgroundColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
