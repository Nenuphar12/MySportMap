import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_sport_map/home/home.dart';
import 'package:strava_repository/strava_repository.dart';

import '../../helpers/helpers.dart';

Activity activityWithRoute(int id) => Activity(
  id: id,
  map: PolyLineMap(id: 'a$id', summaryPolyline: '_p~iF~ps|U_ulLnnqC'),
);

void main() {
  group('ActivitiesCubit', () {
    late StravaRepository stravaRepository;

    final cachedActivities = [activityWithRoute(1)];
    final syncedActivities = [activityWithRoute(1), activityWithRoute(2)];
    final cachedPolylines = StravaRepository.polylinesOf(cachedActivities);
    final syncedPolylines = StravaRepository.polylinesOf(syncedActivities);

    setUp(() {
      stravaRepository = MockStravaRepository();
      when(
        () => stravaRepository.getCachedActivities(),
      ).thenAnswer((_) async => cachedActivities);
      when(
        () => stravaRepository.syncActivities(full: any(named: 'full')),
      ).thenAnswer((_) async => syncedActivities);
    });

    ActivitiesCubit buildCubit() =>
        ActivitiesCubit(stravaRepository: stravaRepository);

    test('has correct initial state', () {
      expect(buildCubit().state, const ActivitiesState());
    });

    group('load', () {
      blocTest<ActivitiesCubit, ActivitiesState>(
        'shows the cached activities, then the synced ones',
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => [
          ActivitiesState(
            status: ActivitiesStatus.syncing,
            polylines: cachedPolylines,
          ),
          ActivitiesState(
            status: ActivitiesStatus.synced,
            polylines: syncedPolylines,
          ),
        ],
        verify: (_) {
          verify(() => stravaRepository.syncActivities()).called(1);
        },
      );

      blocTest<ActivitiesCubit, ActivitiesState>(
        'keeps the cached activities when the sync fails',
        setUp: () {
          when(
            () => stravaRepository.syncActivities(full: any(named: 'full')),
          ).thenThrow(Exception('offline'));
        },
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => [
          ActivitiesState(
            status: ActivitiesStatus.syncing,
            polylines: cachedPolylines,
          ),
          ActivitiesState(
            status: ActivitiesStatus.failure,
            polylines: cachedPolylines,
          ),
        ],
      );
    });

    group('refresh', () {
      blocTest<ActivitiesCubit, ActivitiesState>(
        'runs a full sync, keeping the activities shown meanwhile',
        build: buildCubit,
        seed: () => ActivitiesState(
          status: ActivitiesStatus.synced,
          polylines: cachedPolylines,
        ),
        act: (cubit) => cubit.refresh(),
        expect: () => [
          ActivitiesState(
            status: ActivitiesStatus.syncing,
            polylines: cachedPolylines,
          ),
          ActivitiesState(
            status: ActivitiesStatus.synced,
            polylines: syncedPolylines,
          ),
        ],
        verify: (_) {
          verify(() => stravaRepository.syncActivities(full: true)).called(1);
        },
      );
    });

    group('clear', () {
      blocTest<ActivitiesCubit, ActivitiesState>(
        'removes the activities',
        build: buildCubit,
        seed: () => ActivitiesState(
          status: ActivitiesStatus.synced,
          polylines: syncedPolylines,
        ),
        act: (cubit) => cubit.clear(),
        expect: () => [const ActivitiesState()],
      );

      late Completer<List<Activity>> sync;

      blocTest<ActivitiesCubit, ActivitiesState>(
        'discards a sync that finishes after it',
        setUp: () {
          sync = Completer<List<Activity>>();
          when(
            () => stravaRepository.syncActivities(full: any(named: 'full')),
          ).thenAnswer((_) => sync.future);
        },
        build: buildCubit,
        act: (cubit) async {
          final load = cubit.load();
          // Let the cached activities be emitted and the sync start.
          await Future<void>.delayed(Duration.zero);
          cubit.clear();
          sync.complete(syncedActivities);
          await load;
        },
        expect: () => [
          ActivitiesState(
            status: ActivitiesStatus.syncing,
            polylines: cachedPolylines,
          ),
          const ActivitiesState(),
        ],
      );
    });
  });
}
