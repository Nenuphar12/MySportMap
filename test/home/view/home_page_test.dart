import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_sport_map/home/home.dart';
import 'package:strava_repository/strava_repository.dart';

import '../../helpers/helpers.dart';

final activities = [
  Activity(
    id: 1,
    map: PolyLineMap(id: 'a1', summaryPolyline: '_p~iF~ps|U_ulLnnqC'),
  ),
];

void main() {
  late StravaRepository stravaRepository;
  late ClientCubit clientCubit;

  setUp(() {
    stravaRepository = MockStravaRepository();
    when(
      stravaRepository.isAuthenticated,
    ).thenAnswer((_) => Future.value(false));
    when(
      stravaRepository.getCachedActivities,
    ).thenAnswer((_) async => activities);
    when(
      () => stravaRepository.syncActivities(full: any(named: 'full')),
    ).thenAnswer((_) async => activities);

    clientCubit = MockClientCubit();
  });

  /// Pumps the [HomePage] while [clientCubit] goes through [states].
  Future<void> pumpHomePage(
    WidgetTester tester, {
    required List<ClientState> states,
  }) async {
    whenListen(
      clientCubit,
      Stream.fromIterable(states.skip(1)),
      initialState: states.first,
    );
    await tester.pumpWidget(
      RepositoryProvider.value(
        value: stravaRepository,
        child: BlocProvider.value(
          value: clientCubit,
          child: const MaterialApp(home: HomePage()),
        ),
      ),
    );
  }

  ActivitiesState activitiesState(WidgetTester tester) =>
      tester.element(find.byType(HomeView)).read<ActivitiesCubit>().state;

  group('HomePage', () {
    testWidgets('renders HomeView', (tester) async {
      await pumpHomePage(tester, states: [const ClientState()]);

      expect(find.byType(HomeView), findsOneWidget);
    });

    testWidgets('loads the activities when already logged in', (
      tester,
    ) async {
      await pumpHomePage(
        tester,
        states: [const ClientState(status: ClientStatus.ready)],
      );
      await tester.pump();

      verify(stravaRepository.getCachedActivities).called(1);
      verify(() => stravaRepository.syncActivities()).called(1);
      expect(activitiesState(tester).status, ActivitiesStatus.synced);
      expect(activitiesState(tester).polylines, hasLength(1));
    });

    testWidgets('does not load the activities when logged out', (
      tester,
    ) async {
      await pumpHomePage(
        tester,
        states: [const ClientState(status: ClientStatus.notAuthorized)],
      );
      await tester.pump();

      verifyNever(stravaRepository.getCachedActivities);
    });
  });

  group('HomeView', () {
    testWidgets('loads the activities when the user logs in', (tester) async {
      await pumpHomePage(
        tester,
        states: const [
          ClientState(status: ClientStatus.notAuthorized),
          ClientState(status: ClientStatus.ready),
        ],
      );
      await tester.pump();

      verify(() => stravaRepository.syncActivities()).called(1);
      expect(activitiesState(tester).polylines, hasLength(1));
    });

    testWidgets('clears the activities when the user logs out', (
      tester,
    ) async {
      await pumpHomePage(
        tester,
        states: const [
          ClientState(status: ClientStatus.ready),
          ClientState(status: ClientStatus.notAuthorized),
        ],
      );
      await tester.pump();

      expect(activitiesState(tester), const ActivitiesState());
    });

    testWidgets('tells the user when the sync fails', (tester) async {
      when(
        () => stravaRepository.syncActivities(full: any(named: 'full')),
      ).thenThrow(Exception('offline'));

      await pumpHomePage(
        tester,
        states: [const ClientState(status: ClientStatus.ready)],
      );
      await tester.pump();
      await tester.pump();

      expect(
        find.text('Could not sync your activities with Strava.'),
        findsOneWidget,
      );
    });
  });
}
