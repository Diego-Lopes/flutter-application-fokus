import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fokus/app/view/widgets/timer_widget.dart';
import 'package:fokus/app/view_model/timer_view_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockTimerViewModel extends Mock implements TimerViewModel {}

void main() {
  late MockTimerViewModel mockTimerViewModel;

  setUpAll(() {
    registerFallbackValue(ValueNotifier<bool>(false));
  });

  setUp(() {
    mockTimerViewModel = MockTimerViewModel();
    when(() => mockTimerViewModel.isPlaying).thenReturn(false);

    when(() => mockTimerViewModel.duration).thenReturn(Duration.zero);
  });

  tearDown(() {
    mockTimerViewModel.stopTime();
  });

  group('TimerWidget', () {
    Widget createWidget() {
      return ChangeNotifierProvider<TimerViewModel>.value(
        value: mockTimerViewModel,
        child: MaterialApp(
          home: Scaffold(body: TimerWidget(initialMinutes: 1)),
        ),
      );
    }

    testWidgets('Exibe tempo inicial zerado e formatado corretamente', (
      teste,
    ) async {
      await teste.pumpWidget(createWidget());

      expect(find.text('00:00'), findsOneWidget);
    });

    testWidgets('Ao tocar em iniciar, chama startTimer do TimerViewModel', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget());

      final startButton = find.text('Iniciar');
      expect(startButton, findsOneWidget);

      await tester.tap(startButton);
      await tester.pumpAndSettle();

      verify(() => mockTimerViewModel.startTime(any(), any())).called(1);
    });

    testWidgets('Pausa a contagem ao clicar em pausar', (tester) async {
      await tester.pumpWidget(createWidget());
      final startButton = find.text('Iniciar');
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      tester.runAsync(() async {
        final pauseButton = find.text('Pausar');
        expect(pauseButton, findsOneWidget);

        await tester.tap(pauseButton);
        await tester.pumpAndSettle(Duration(seconds: 2));

        expect(find.text('00:01'), findsOneWidget);
      });
    });

    testWidgets('chama stopTime ao clicar em parar', (tester) async {
      await tester.pumpWidget(createWidget());
      final startButton = find.text('Iniciar');
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      tester.runAsync(() async {
        final pauseButton = find.text('Pausar');
        expect(pauseButton, findsOneWidget);

        await tester.tap(pauseButton);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Parar'));
        await tester.pumpAndSettle();

        verify(() => mockTimerViewModel.stopTime()).called(1);
      });
    });
  });
}
