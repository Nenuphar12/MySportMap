import 'dart:convert';
import 'dart:io';

import 'package:strava_repository/src/models/models.dart';

/// {@template cached_activities}
/// The [activities] of the athlete with the [athleteId], as stored by an
/// [ActivityCache].
/// {@endtemplate}
class CachedActivities {
  /// {@macro cached_activities}
  const CachedActivities({required this.athleteId, required this.activities});

  /// The Strava id of the athlete owning the [activities].
  final int athleteId;

  /// The cached [Activity]s.
  final List<Activity> activities;
}

/// {@template activity_cache}
/// Stores [Activity]s in a JSON file, so they can be displayed without
/// fetching them from Strava again.
/// {@endtemplate}
class ActivityCache {
  /// {@macro activity_cache}
  ///
  /// The cache file is stored in the directory returned by [directory].
  ActivityCache({required Future<Directory> Function() directory})
    : _directory = directory;

  /// The version of the file format.
  ///
  /// Bump it when the JSON of [Activity] changes: files written with another
  /// version are ignored.
  static const version = 1;

  static const _fileName = 'activities_cache.json';

  final Future<Directory> Function() _directory;

  Future<File> get _file async =>
      File('${(await _directory()).path}/$_fileName');

  /// Returns the cached activities, or `null` if there is no usable cache.
  Future<CachedActivities?> read() async {
    final file = await _file;
    if (!file.existsSync()) return null;
    try {
      final json =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      if (json['version'] != version) return null;
      return CachedActivities(
        athleteId: json['athlete_id'] as int,
        activities: (json['activities'] as List)
            .map((a) => Activity.fromJson(a as Map<String, dynamic>))
            .toList(),
      );
    } on Object {
      // A corrupt cache is not worth failing for: the next sync rewrites it.
      return null;
    }
  }

  /// Replaces the cached activities with [cache].
  Future<void> write(CachedActivities cache) async {
    final file = await _file;
    await file.parent.create(recursive: true);
    // Write to a temporary file first so a crash never leaves a partial cache.
    final temporaryFile = File('${file.path}.tmp');
    await temporaryFile.writeAsString(
      jsonEncode({
        'version': version,
        'athlete_id': cache.athleteId,
        'activities': cache.activities,
      }),
      flush: true,
    );
    await temporaryFile.rename(file.path);
  }

  /// Deletes the cached activities.
  Future<void> clear() async {
    final file = await _file;
    if (file.existsSync()) await file.delete();
  }
}
