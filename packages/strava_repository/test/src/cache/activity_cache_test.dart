import 'dart:convert';
import 'dart:io';

import 'package:strava_repository/src/models/sport_types.dart';
import 'package:strava_repository/strava_repository.dart';
import 'package:test/test.dart';

void main() {
  group('ActivityCache', () {
    late Directory directory;
    late ActivityCache cache;

    final activities = [
      Activity(
        id: 1,
        sportType: SportType.run,
        map: PolyLineMap(id: 'a1', summaryPolyline: '_p~iF~ps|U_ulLnnqC'),
        startDate: DateTime.utc(2026, 9, 20, 7, 30),
      ),
      const Activity(id: 2, sportType: SportType.yoga),
    ];

    File cacheFile() => File('${directory.path}/activities_cache.json');

    setUp(() async {
      directory = await Directory.systemTemp.createTemp('activity_cache_');
      cache = ActivityCache(directory: () async => directory);
    });

    tearDown(() => directory.delete(recursive: true));

    test('read returns null when nothing is cached', () async {
      expect(await cache.read(), isNull);
    });

    test('read returns what write stored', () async {
      await cache.write(
        CachedActivities(athleteId: 42, activities: activities),
      );

      final cached = await cache.read();

      expect(cached?.athleteId, 42);
      expect(cached?.activities, equals(activities));
      expect(
        cached?.activities.first.map?.summaryPolyline,
        '_p~iF~ps|U_ulLnnqC',
      );
    });

    test('write creates a missing directory', () async {
      final nested = Directory('${directory.path}/not/created/yet');
      cache = ActivityCache(directory: () async => nested);

      await cache.write(
        CachedActivities(athleteId: 42, activities: activities),
      );

      expect((await cache.read())?.activities, equals(activities));
    });

    test('write leaves no temporary file behind', () async {
      await cache.write(
        CachedActivities(athleteId: 42, activities: activities),
      );

      expect(directory.listSync().map((f) => f.path), [cacheFile().path]);
    });

    test('read returns null for a corrupt file', () async {
      await cacheFile().writeAsString('{not json');

      expect(await cache.read(), isNull);
    });

    test('read returns null for another file format version', () async {
      await cacheFile().writeAsString(
        jsonEncode({
          'version': ActivityCache.version + 1,
          'athlete_id': 42,
          'activities': <Object>[],
        }),
      );

      expect(await cache.read(), isNull);
    });

    test('clear deletes the cached activities', () async {
      await cache.write(
        CachedActivities(athleteId: 42, activities: activities),
      );

      await cache.clear();

      expect(await cache.read(), isNull);
      expect(cacheFile().existsSync(), isFalse);
    });

    test('clear does nothing when nothing is cached', () async {
      await expectLater(cache.clear(), completes);
    });
  });
}
