import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_sport_map/home/home.dart';

void main() {
  group('CounterCubit', () {
    test('initial state is ClientState.appStarting', () {
      expect(ClientCubit().state, equals(ClientState.appStarting));
    });

    blocTest<ClientCubit, ClientState>(
      'emits [1] when incret lled',
      build: ClientCubit.new,
      act: (cubit) => cubit.setCubitState(ClientState.ready),
      expect: () => [equals(ClientState.ready)],
    );

    blocTest<ClientCubit, ClientState>(
      'emits [-1] when decrement is called',
      build: ClientCubit.new,
      act: (cubit) => cubit.setCubitState(ClientState.notAuthorized),
      expect: () => [equals(ClientState.notAuthorized)],
    );
  });
}
