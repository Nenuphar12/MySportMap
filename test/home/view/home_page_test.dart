import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:my_sport_map/home/home.dart';
import 'package:strava_repository/strava_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  late StravaRepository stravaRepository;
  late ClientCubit clientCubit;

  group('HomePage', () {
    setUp(() {
      stravaRepository = MockStravaRepository();
      when(stravaRepository.isAuthenticated)
          .thenAnswer((_) => Future.value(false));

      clientCubit = MockClientCubit();
      whenListen(
        clientCubit,
        Stream.fromIterable([const ClientState()]),
        initialState: const ClientState(),
      );
      // when(clientCubit.close).thenAnswer((_) => Future.value());
    });

    testWidgets('renders HomeView', (tester) async {
      await tester.pumpApp(
        const HomePage(),
        stravaRepository: stravaRepository,
        clientCubit: clientCubit,
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
  });
}
