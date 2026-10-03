import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart' show Colors;
import 'package:mocktail/mocktail.dart';
import 'package:strava_client/strava_client.dart';
import 'package:strava_repository/src/models/sport_types.dart';
import 'package:strava_repository/strava_repository.dart';
import 'package:test/test.dart';

class MockStravaClient extends Mock implements StravaClient {}

class MockRepositoryActivity extends Mock implements RepositoryActivity {}

class MockRepositoryAthlete extends Mock implements RepositoryAthlete {}

class MockRepositoryAuthentication extends Mock
    implements RepositoryAuthentication {}

class MockDetailedAthlete extends Mock implements DetailedAthlete {}

SummaryActivity summaryActivity(int id, DateTime startDate) => SummaryActivity(
  id: id,
  type: 'Run',
  startDate: startDate.toIso8601String(),
  map: PolyLineMap(id: 'a$id', summaryPolyline: '_p~iF~ps|U_ulLnnqC'),
);

void main() {
  group('StravaRepository', () {
    late MockStravaClient stravaClient;
    late MockRepositoryActivity activities;
    late MockRepositoryAthlete athletes;
    late MockRepositoryAuthentication authentication;
    late Directory directory;
    late ActivityCache activityCache;
    late StravaRepository repository;

    /// The activities returned by Strava, filtered by start date like the API.
    var remoteActivities = <SummaryActivity>[];

    void stubAthlete(int id) {
      final athlete = MockDetailedAthlete();
      when(() => athlete.id).thenReturn(id);
      when(athletes.getAuthenticatedAthlete).thenAnswer((_) async => athlete);
    }

    setUpAll(() => registerFallbackValue(DateTime(0)));

    setUp(() async {
      stravaClient = MockStravaClient();
      activities = MockRepositoryActivity();
      athletes = MockRepositoryAthlete();
      authentication = MockRepositoryAuthentication();
      when(() => stravaClient.activities).thenReturn(activities);
      when(() => stravaClient.athletes).thenReturn(athletes);
      when(() => stravaClient.authentication).thenReturn(authentication);
      stubAthlete(42);

      remoteActivities = [];
      when(
        () => activities.listLoggedInAthleteActivities(
          any(),
          any(),
          any(),
          any(),
        ),
      ).thenAnswer((invocation) async {
        final after = invocation.positionalArguments[1] as DateTime;
        final page = invocation.positionalArguments[2] as int;
        if (page > 1) return [];
        return remoteActivities
            .where((a) => DateTime.parse(a.startDate!).isAfter(after))
            .toList();
      });

      directory = await Directory.systemTemp.createTemp('strava_repository_');
      activityCache = ActivityCache(directory: () async => directory);
      repository = StravaRepository(
        clientId: 'client_id',
        secret: 'secret',
        stravaClient: stravaClient,
        activityCache: activityCache,
      );
    });

    tearDown(() => directory.delete(recursive: true));

    test('can be instantiated', () {
      expect(
        StravaRepository(clientId: 'client_id', secret: 'secret'),
        isNotNull,
      );
    });

    group('getCachedActivities', () {
      test('returns an empty list when nothing is cached', () async {
        expect(await repository.getCachedActivities(), isEmpty);
      });

      test('returns the activities of the last sync', () async {
        remoteActivities = [summaryActivity(1, DateTime.utc(2026, 9))];

        final synced = await repository.syncActivities();

        expect(await repository.getCachedActivities(), equals(synced));
      });
    });

    group('syncActivities', () {
      test('fetches all activities when nothing is cached', () async {
        remoteActivities = [
          summaryActivity(1, DateTime.utc(2026, 8)),
          summaryActivity(2, DateTime.utc(2026, 9)),
        ];

        final synced = await repository.syncActivities();

        expect(synced.map((a) => a.id), [2, 1], reason: 'most recent first');
        expect(synced.first.startDate, DateTime.utc(2026, 9));
        expect(synced.first.sportType, SportType.run);
        verify(
          () => activities.listLoggedInAthleteActivities(
            any(),
            DateTime(1999),
            1,
            100,
          ),
        ).called(1);

        final cached = await activityCache.read();
        expect(cached?.athleteId, 42);
        expect(cached?.activities, equals(synced));
      });

      test('only fetches activities since the newest cached one, '
          'minus the overlap', () async {
        remoteActivities = [summaryActivity(1, DateTime.utc(2026, 9, 20))];
        await repository.syncActivities();

        remoteActivities = [
          summaryActivity(1, DateTime.utc(2026, 9, 20)),
          // Uploaded late: starts before the newest cached activity.
          summaryActivity(2, DateTime.utc(2026, 9, 18)),
          summaryActivity(3, DateTime.utc(2026, 9, 25)),
        ];
        final synced = await repository.syncActivities();

        expect(synced.map((a) => a.id), [3, 1, 2], reason: 'no duplicates');
        verify(
          () => activities.listLoggedInAthleteActivities(
            any(),
            DateTime.utc(2026, 9, 20).subtract(StravaRepository.syncOverlap),
            1,
            100,
          ),
        ).called(1);
      });

      test('keeps cached activities older than the overlap', () async {
        remoteActivities = [summaryActivity(1, DateTime.utc(2025))];
        await repository.syncActivities();

        remoteActivities = [summaryActivity(2, DateTime.utc(2026))];
        final synced = await repository.syncActivities();

        expect(synced.map((a) => a.id), [2, 1]);
      });

      test(
        'with full fetches everything and drops deleted activities',
        () async {
          remoteActivities = [
            summaryActivity(1, DateTime.utc(2026, 8)),
            summaryActivity(2, DateTime.utc(2026, 9)),
          ];
          await repository.syncActivities();

          // Activity 2 was deleted on Strava.
          remoteActivities = [summaryActivity(1, DateTime.utc(2026, 8))];
          final synced = await repository.syncActivities(full: true);

          expect(synced.map((a) => a.id), [1]);
          expect((await activityCache.read())?.activities, equals(synced));
        },
      );

      test('ignores the cache of another athlete', () async {
        remoteActivities = [summaryActivity(1, DateTime.utc(2026, 9))];
        await repository.syncActivities();

        stubAthlete(7);
        remoteActivities = [summaryActivity(2, DateTime.utc(2026, 8))];
        final synced = await repository.syncActivities();

        expect(synced.map((a) => a.id), [2]);
        expect((await activityCache.read())?.athleteId, 7);
      });

      test('shares the sync in progress between concurrent calls', () async {
        remoteActivities = [summaryActivity(1, DateTime.utc(2026, 9))];

        final results = await Future.wait([
          repository.syncActivities(),
          repository.syncActivities(),
        ]);

        expect(results.first, equals(results.last));
        verify(athletes.getAuthenticatedAthlete).called(1);

        await repository.syncActivities();
        verify(athletes.getAuthenticatedAthlete).called(1);
      });

      test('propagates errors and does not write the cache', () async {
        when(
          athletes.getAuthenticatedAthlete,
        ).thenAnswer((_) async => throw Exception('offline'));

        await expectLater(repository.syncActivities(), throwsException);
        expect(await activityCache.read(), isNull);
      });
    });

    group('deAuthorize', () {
      setUp(() {
        when(authentication.deAuthorize).thenAnswer((_) async {});
      });

      test('deletes the cached activities', () async {
        remoteActivities = [summaryActivity(1, DateTime.utc(2026, 9))];
        await repository.syncActivities();

        await repository.deAuthorize();

        verify(authentication.deAuthorize).called(1);
        expect(await repository.getCachedActivities(), isEmpty);
      });

      test('waits for a running sync before deleting the cache', () async {
        final athlete = MockDetailedAthlete();
        when(() => athlete.id).thenReturn(42);
        final athleteResponse = Completer<DetailedAthlete>();
        when(
          athletes.getAuthenticatedAthlete,
        ).thenAnswer((_) => athleteResponse.future);
        remoteActivities = [summaryActivity(1, DateTime.utc(2026, 9))];

        final sync = repository.syncActivities();
        final deAuthorize = repository.deAuthorize();
        athleteResponse.complete(athlete);
        await Future.wait([sync, deAuthorize]);

        expect(await repository.getCachedActivities(), isEmpty);
      });
    });

    group('polylinesOf', () {
      test('returns a polyline per activity with a route', () {
        final polylines = StravaRepository.polylinesOf([
          Activity(
            id: 1,
            sportType: SportType.run,
            map: PolyLineMap(id: 'a1', summaryPolyline: '_p~iF~ps|U_ulLnnqC'),
          ),
          Activity(
            id: 2,
            map: PolyLineMap(id: 'a2', summaryPolyline: ''),
          ),
          const Activity(id: 3),
        ]);

        expect(polylines, hasLength(1));
        expect(polylines.single.color, Colors.red);
        expect(polylines.single.points, hasLength(2));
      });
    });
  });
}
