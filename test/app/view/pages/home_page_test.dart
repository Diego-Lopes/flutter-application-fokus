import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fokus/app/shared/utils/routes.dart';
import 'package:fokus/app/view/pages/home_page.dart';
import 'package:fokus/app/view/pages/timer_page.dart';
import 'package:fokus/app/view/widgets/timer_widget.dart';
import 'package:fokus/app/view_model/timer_view_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockTimerViewModel extends Mock implements TimerViewModel {}

void main() {
  late MockTimerViewModel mockTimerViewModel;

  Widget createWidget() {
    return ChangeNotifierProvider<TimerViewModel>.value(
      value: mockTimerViewModel,
      child: MaterialApp(
        home: Scaffold(body: HomePage()),
        routes: routes,
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

  group('HomePage - ', () {
    group('Modo Foco -', () {
      testWidgets('Lista os modos e renderiza os botões da página do timer', (
        tester,
      ) async {
        await tester.pumpWidget(createWidget());

        expect(find.text('Modo Foco'), findsOneWidget);
        expect(find.text('Pausa Curta'), findsOneWidget);
        expect(find.text('Pausa Longa'), findsOneWidget);

        await tester.tap(find.text('Modo Foco'));
        await tester.pumpAndSettle();

        expect(find.byType(TimerPage), findsOneWidget);
        expect(find.byType(TimerWidget), findsOneWidget);
      });
    });
    group('Pausa Longa - ', () {
      testWidgets('Lista os modos e renderiza os botões da página do timer', (
        tester,
      ) async {
        await tester.pumpWidget(createWidget());

        expect(find.text('Modo Foco'), findsOneWidget);
        expect(find.text('Pausa Curta'), findsOneWidget);
        expect(find.text('Pausa Longa'), findsOneWidget);

        await tester.tap(find.text('Pausa Longa'));
        await tester.pumpAndSettle();

        expect(find.byType(TimerPage), findsOneWidget);
        expect(find.byType(TimerWidget), findsOneWidget);
      });
    });
    group('Pausa Curta - ', () {
      testWidgets('Lista os modos e renderiza os botões da página do timer', (
        tester,
      ) async {
        await tester.pumpWidget(createWidget());

        expect(find.text('Modo Foco'), findsOneWidget);
        expect(find.text('Pausa Curta'), findsOneWidget);
        expect(find.text('Pausa Longa'), findsOneWidget);

        await tester.tap(find.text('Pausa Curta'));
        await tester.pumpAndSettle();

        expect(find.byType(TimerPage), findsOneWidget);
        expect(find.byType(TimerWidget), findsOneWidget);
      });
    });
  });
}
