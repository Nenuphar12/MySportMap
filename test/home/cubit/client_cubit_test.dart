import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:my_sport_map/home/home.dart';
import 'package:strava_repository/strava_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  late StravaRepository stravaRepository;

  setUp(() {
    stravaRepository = MockStravaRepository();
    when(stravaRepository.isAuthenticated)
        // Never returns so the bloc initialization
        // .thenAnswer((_) => Completer<bool>().future);
        .thenAnswer((_) => Future<bool>.value(true));
  });

  group('ClientCubit', () {
    ClientCubit buildCubit() => ClientCubit(stravaRepository: stravaRepository);

    group('constructor', () {
      test('works properly', () {
        expect(buildCubit, returnsNormally);
      });

      test('has correct initial state', () {
        expect(
          buildCubit().state,
          equals(const ClientState()),
        );
      });
    });

    group('setState', () {
      blocTest<ClientCubit, ClientState>(
        'emits correct state when set to ready',
        build: buildCubit,
        act: (cubit) => cubit.setClientStatus(ClientStatus.ready),
        expect: () => [
          const ClientState(status: ClientStatus.ready),
        ],
      );
    });

    // Not working
    // blocTest<ClientCubit, ClientState>(
    //   'returns true if the app is starting when isAppStarting is called',
    //   build: buildCubit,
    //   act: (cubit) => cubit.state.isAppStarting(),
    //   expect: () => true,
    // );

    // blocTest<ClientCubit, ClientState>(
    //   'emits [1] when increment is called',
    //   build: ClientCubit.new,
    //   act: (cubit) => cubit.setClientStatus(ClientState.ready),
    //   expect: () => [equals(ClientState.ready)],
    // );

    // blocTest<ClientCubit, ClientState>(
    //   'emits [-1] when decrement is called',
    //   build: ClientCubit.new,
    //   act: (cubit) => cubit.setClientStatus(ClientState.notAuthorized),
    //   expect: () => [equals(ClientState.notAuthorized)],
    // );
  });
}
