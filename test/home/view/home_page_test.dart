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
  });
}
