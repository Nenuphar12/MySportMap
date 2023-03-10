import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:my_sport_map/home/home.dart';
import 'package:strava_repository/strava_repository.dart';

import '../../helpers/helpers.dart';

class MockClientCubit extends MockCubit<ClientState> implements ClientCubit {}

void main() {
  late StravaRepository stravaRepository;

  group('HomePage', () {
    setUp(() {
      stravaRepository = MockStravaRepository();
      when(stravaRepository.isAuthenticated)
          .thenAnswer((_) => Future.value(false));
    });

    testWidgets('renders HomeView', (tester) async {
      await tester.pumpApp(
        const HomePage(),
        stravaRepository: stravaRepository,
      );

      expect(find.byType(HomeView), findsOneWidget);
    });
  });

  group('HomeView', () {
    late ClientCubit clientCubit;

    setUp(() {
      clientCubit = MockClientCubit();
      when(() => clientCubit.state).thenReturn(const ClientState());

      stravaRepository = MockStravaRepository();
    });

    //   testWidgets('calls _login when login button is tapped', (tester) async {
    //     when(() => clientCubit.state).thenReturn(ClientState.notAuthorized);
    //     when(() => clientCubit.setCubitState(ClientState.notAuthorized))
    //         .thenReturn(null);
    //   });

    // testWidgets('renders current count', (tester) async {
    //   const state = 42;
    //   when(() => clientCubit.state).thenReturn(state);
    //   await tester.pumpApp(
    //     BlocProvider.value(
    //       value: counterCubit,
    //       child: const CounterView(),
    //     ),
    //   );
    //   expect(find.text('$state'), findsOneWidget);
    // });

    //   testWidgets('calls increment when increment button is tapped',
    //       (tester) async {
    //     when(() => counterCubit.state).thenReturn(0);
    //     when(() => counterCubit.increment()).thenReturn(null);
    //     await tester.pumpApp(
    //       BlocProvider.value(
    //         value: counterCubit,
    //         child: const CounterView(),
    //       ),
    //     );
    //     await tester.tap(find.byIcon(Icons.add));
    //     verify(() => counterCubit.increment()).called(1);
    //   });

    //   testWidgets('calls decrement when decrement button is tapped',
    //       (tester) async {
    //     when(() => counterCubit.state).thenReturn(0);
    //     when(() => counterCubit.decrement()).thenReturn(null);
    //     await tester.pumpApp(
    //       BlocProvider.value(
    //         value: counterCubit,
    //         child: const CounterView(),
    //       ),
    //     );
    //     await tester.tap(find.byIcon(Icons.remove));
    //     verify(() => counterCubit.decrement()).called(1);
    //   });
  });
}
