import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fokus/app/shared/enums/timer_type.dart';
import 'package:fokus/app/view/pages/timer_page.dart';
import 'package:fokus/app/view_model/timer_view_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockTimerViewModel extends Mock implements TimerViewModel {}

void main() {
  late MockTimerViewModel mockTimerViewModel;

  Widget createWidget({TimerType timerType = TimerType.focus}) {
    return ChangeNotifierProvider<TimerViewModel>.value(
      value: mockTimerViewModel,
      child: MaterialApp(
        home: Scaffold(body: TimerPage(timerType: timerType)),
      ),
    );
  }

  setUpAll(() {
    registerFallbackValue(ValueNotifier<bool>(false));
  });

  setUp(() {
    mockTimerViewModel = MockTimerViewModel();

    when(() => mockTimerViewModel.isPlaying).thenReturn(false);
    when(() => mockTimerViewModel.duration).thenReturn(Duration.zero);
  });

  group('TimerPage UI', () {
    group('TimerType = focus', () {
      testWidgets('Deve exibir o tempo inicial formatado corretamente', (
        tester,
      ) async {
        await tester.pumpWidget(createWidget());

        expect(find.text('00:00'), findsOneWidget);
        expect(find.text('Iniciar'), findsOneWidget);
      });

      testWidgets('Deve chamar startTimeao clicar em iniciar', (tester) async {
        await tester.tap(find.text('Iniciar'));
        await tester.pumpAndSettle();

        verify(() => mockTimerViewModel.startTime(25, any())).called(1);
      });

      testWidgets('Mostrar o botão de pausar depois de iniciar a contagem', (
        tester,
      ) async {
        await tester.tap(find.text('Iniciar'));
        await tester.pumpAndSettle();

        tester.runAsync(() async {
          expect(find.text('Pausar'), findsOneWidget);
          expect(find.text('Iniciar'), findsNothing);
        });
      });

      testWidgets('mostrar continuar após pausar o contador', (tester) async {
        await tester.pumpWidget(createWidget());

        await tester.tap(find.text('Iniciar'));
        await tester.pumpAndSettle();

        tester.runAsync(() async {
          await tester.tap(find.text('Pausar'));
          await tester.pumpAndSettle();

          expect(find.text('Continuar'), findsOneWidget);
        });
      });

      testWidgets('Deve chamar stopTime ao clicar em parar', (tester) async {
        await tester.pumpWidget(createWidget());

        await tester.tap(find.text('Iniciar'));
        await tester.pumpAndSettle();

        tester.runAsync(() async {
          await tester.tap(find.text('Parar'));
          await tester.pumpAndSettle();

          verify(() => mockTimerViewModel.stopTime()).called(1);
        });
      });
    });

    group('TimerType = longBreak', () {
      testWidgets('Deve exibir o tempo inicial formatado corretamente', (
        tester,
      ) async {
        await tester.pumpWidget(createWidget(timerType: TimerType.longBreak));

        expect(find.text('00:15'), findsOneWidget);
        expect(find.text('Iniciar'), findsOneWidget);
      });

      testWidgets('Deve chamar startTimeao clicar em iniciar', (tester) async {
        await tester.tap(find.text('Iniciar'));
        await tester.pumpAndSettle();

        verify(() => mockTimerViewModel.startTime(15, any())).called(1);
      });

      testWidgets('Mostrar o botão de pausar depois de iniciar a contagem', (
        tester,
      ) async {
        await tester.tap(find.text('Iniciar'));
        await tester.pumpAndSettle();

        tester.runAsync(() async {
          expect(find.text('Pausar'), findsOneWidget);
          expect(find.text('Iniciar'), findsNothing);
        });
      });

      testWidgets('mostrar continuar após pausar o contador', (tester) async {
        await tester.pumpWidget(createWidget(timerType: TimerType.longBreak));

        await tester.tap(find.text('Iniciar'));
        await tester.pumpAndSettle();

        tester.runAsync(() async {
          await tester.tap(find.text('Pausar'));
          await tester.pumpAndSettle();

          expect(find.text('Continuar'), findsOneWidget);
        });
      });

      testWidgets('Deve chamar stopTime ao clicar em parar', (tester) async {
        await tester.pumpWidget(createWidget(timerType: TimerType.longBreak));

        await tester.tap(find.text('Iniciar'));
        await tester.pumpAndSettle();

        tester.runAsync(() async {
          await tester.tap(find.text('Parar'));
          await tester.pumpAndSettle();

          verify(() => mockTimerViewModel.stopTime()).called(1);
        });
      });
    });

    group('TimerType = shortBreak', () {
      testWidgets('Deve exibir o tempo inicial formatado corretamente', (
        tester,
      ) async {
        await tester.pumpWidget(createWidget(timerType: TimerType.shortBreak));

        expect(find.text('00:05'), findsOneWidget);
        expect(find.text('Iniciar'), findsOneWidget);
      });

      testWidgets('Deve chamar startTimeao clicar em iniciar', (tester) async {
        await tester.tap(find.text('Iniciar'));
        await tester.pumpAndSettle();

        verify(() => mockTimerViewModel.startTime(5, any())).called(1);
      });

      testWidgets('Mostrar o botão de pausar depois de iniciar a contagem', (
        tester,
      ) async {
        await tester.tap(find.text('Iniciar'));
        await tester.pumpAndSettle();

        tester.runAsync(() async {
          expect(find.text('Pausar'), findsOneWidget);
          expect(find.text('Iniciar'), findsNothing);
        });
      });

      testWidgets('mostrar continuar após pausar o contador', (tester) async {
        await tester.pumpWidget(createWidget(timerType: TimerType.shortBreak));

        await tester.tap(find.text('Iniciar'));
        await tester.pumpAndSettle();

        tester.runAsync(() async {
          await tester.tap(find.text('Pausar'));
          await tester.pumpAndSettle();

          expect(find.text('Continuar'), findsOneWidget);
        });
      });

      testWidgets('Deve chamar stopTime ao clicar em parar', (tester) async {
        await tester.pumpWidget(createWidget(timerType: TimerType.shortBreak));

        await tester.tap(find.text('Iniciar'));
        await tester.pumpAndSettle();

        tester.runAsync(() async {
          await tester.tap(find.text('Parar'));
          await tester.pumpAndSettle();

          verify(() => mockTimerViewModel.stopTime()).called(1);
        });
      });
    });
  });
}
