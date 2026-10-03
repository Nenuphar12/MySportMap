import 'dart:async';

import 'package:flutter_map/flutter_map.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
// TODO(nenuphar): improve strava_client to not have this problem
// ignore: implementation_imports
import 'package:strava_client/src/common/common.dart';
import 'package:strava_client/strava_client.dart';
import 'package:strava_repository/src/models/sport_types.dart';
import 'package:strava_repository/strava_repository.dart';

/// Error thrown when an [Activity] with a given id is not found.
class ActivityNotFoundException implements Exception {}

/// {@template strava_repository}
/// A dart repository that handles `activity` by wrapping the `strava_client`.
///
/// The activities are cached locally: [getCachedActivities] returns them
/// without network access and [syncActivities] updates them from Strava.
/// {@endtemplate}
class StravaRepository {
  /// {@macro strava_repository}
  ///
  /// [stravaClient] and [activityCache] can be provided for testing.
  StravaRepository({
    required String secret,
    required String clientId,
    StravaClient? stravaClient,
    ActivityCache? activityCache,
  }) : stravaClient =
           stravaClient ??
           StravaClient(
             secret: secret,
             clientId: clientId,
             applicationName: 'mySportMap',
           ),
       _activityCache =
           activityCache ??
           ActivityCache(directory: getApplicationSupportDirectory);

  /// How far before the newest cached activity an incremental sync starts.
  ///
  /// Strava filters activities by start date, so an activity uploaded late
  /// (e.g. a watch synced days later) can start before the newest cached one.
  static const syncOverlap = Duration(days: 7);

  /// The client used by the repository to fetch data.
  final StravaClient stravaClient;

  final ActivityCache _activityCache;

  /// The sync in progress, shared by concurrent [syncActivities] calls.
  Future<List<Activity>>? _sync;

  /// List [Activity]s of the user.
  Future<List<Activity>> listActivities({
    DateTime? before,
    DateTime? after,
    int? page,
    int? perPage,
  }) async {
    final listSummaryActivities = await stravaClient.activities
        .listLoggedInAthleteActivities(
          before ?? DateTime.now(),
          after ?? DateTime(1999),
          page ?? 1,
          perPage ?? 30,
        );
    final listActivities = listSummaryActivities
        .map(
          (a) => Activity(
            id: a.id,
            sportType: SportTypeHelper.getType(a.type),
            map: a.map,
            startDate: DateTime.tryParse(a.startDate ?? ''),
          ),
        )
        .toList();
    return listActivities;
  }

  /// List **all** [Activity] of the user.
  ///
  /// Only the activities started after [after] are listed, if provided.
  Future<List<Activity>> listAllActivities({DateTime? after}) async {
    var allActivities = <Activity>[];
    var page = 1;
    var notDone = true;
    while (notDone) {
      final someActivities = await listActivities(
        page: page,
        perPage: 100,
        after: after,
      );
      allActivities += someActivities;
      page++;
      if (someActivities.isEmpty) notDone = false;
    }
    return allActivities;
  }

  /// Returns the activities stored locally by the last [syncActivities].
  ///
  /// Returns an empty list if nothing is cached.
  Future<List<Activity>> getCachedActivities() async =>
      (await _activityCache.read())?.activities ?? const [];

  /// Fetches the activities from Strava, updates the local cache and returns
  /// all the activities, most recent first.
  ///
  /// Only the activities started since the newest cached one (minus
  /// [syncOverlap]) are fetched, unless [full] is true or the cache belongs
  /// to another athlete. A full sync also drops the activities deleted on
  /// Strava.
  ///
  /// Concurrent calls share the sync already in progress.
  Future<List<Activity>> syncActivities({bool full = false}) =>
      _sync ??= _syncActivities(full: full).whenComplete(() => _sync = null);

  Future<List<Activity>> _syncActivities({required bool full}) async {
    final athlete = await stravaClient.athletes.getAuthenticatedAthlete();
    final cache = await _activityCache.read();
    final cachedActivities = !full && cache?.athleteId == athlete.id
        ? cache!.activities
        : const <Activity>[];

    DateTime? newestStartDate;
    for (final startDate in cachedActivities.map((a) => a.startDate)) {
      if (startDate != null &&
          (newestStartDate == null || startDate.isAfter(newestStartDate))) {
        newestStartDate = startDate;
      }
    }

    final fetchedActivities = await listAllActivities(
      after: newestStartDate?.subtract(syncOverlap),
    );

    // Fetched activities replace the cached ones with the same id.
    final activitiesById = {
      for (final activity in cachedActivities) activity.id: activity,
      for (final activity in fetchedActivities) activity.id: activity,
    };
    final noDate = DateTime.fromMillisecondsSinceEpoch(0);
    final activities = activitiesById.values.toList()
      ..sort(
        (a, b) => (b.startDate ?? noDate).compareTo(a.startDate ?? noDate),
      );

    await _activityCache.write(
      CachedActivities(athleteId: athlete.id, activities: activities),
    );
    return activities;
  }

  /// Deletes the locally cached activities.
  Future<void> clearCache() async {
    // Let a running sync finish first, or it would write the cache back.
    await _sync?.then<void>((_) {}, onError: (Object _) {});
    await _activityCache.clear();
  }

  /// Fetches all the activities and returns their [Polyline]s.
  Future<List<Polyline>> getAllPolylines() async =>
      polylinesOf(await listAllActivities());

  /// Returns the [Polyline]s of the [activities] that have a route.
  static List<Polyline> polylinesOf(Iterable<Activity> activities) {
    final allPolylines = activities
        .map((a) {
          if (a.map?.id != null &&
              a.map?.summaryPolyline != null &&
              a.map?.summaryPolyline != '') {
            return Polyline(
              points: decodeEncodedPolyline(a.map?.summaryPolyline ?? ''),
              color: SportTypeHelper.getColor(
                a.sportType ?? SportType.undefined,
              ),
            );
          }
        })
        .whereType<Polyline>()
        .toList();
    return allPolylines;
  }

  /// Fetch a specific [Activity] from its [id].
  Future<Activity> getActivity(int id) async {
    final detailedActivity = await stravaClient.activities.getActivity(id);
    return Activity(
      id: detailedActivity.id,
      sportType: SportTypeHelper.getType(detailedActivity.type),
      map: detailedActivity.map,
    );
  }

  /// Whether the client is already authenticated.
  ///
  /// If the client is authenticated, the token is refreshed.
  Future<bool> isAuthenticated() async {
    final token = await LocalStorageManager.getToken(
      applicationName: 'mySportMap',
    );
    if (token != null) {
      // Refresh the token if needed.
      if (isTokenExpired(token)) {
        // Refresh the token (with authenticate)
        Logger().d('Refreshing token.');
        try {
          await authenticate();
        } on Object catch (e, s) {
          logErrorMessage(e, s);
          await deAuthorize();
          return false;
        }
        // await authenticate().catchError((dynamic error, dynamic stackTrace) {
        //   logErrorMessage(
        //     error,
        //     stackTrace,
        //   );
        //   return false;
        // });
        Logger().d('Token refreshed');
      }
      // return true if a token is stored
      return true;
    } else {
      return false;
    }
  }

  /// Authenticates to Strava and authorizes the required scopes.
  ///
  /// The required scopes are :
  /// - activity_read_all
  /// - read_all
  /// - profile_read_all
  Future<void> authenticate() async {
    // From source code :
    // RedirectUrl works best when it is a custom scheme. For example: strava://auth
    // If your redirectUrl is, for example, strava://auth then your callbackUrlScheme should be strava
    try {
      await stravaClient.authentication.authenticate(
        scopes: [
          AuthenticationScope.activity_read_all,
          AuthenticationScope.read_all,
          AuthenticationScope.profile_read_all,
        ],
        redirectUrl: 'com.nenuphar.mysportmap://redirect',
        callbackUrlScheme: 'com.nenuphar.mysportmap',
      );
    } on Object catch (e, s) {
      logErrorMessage(e, s);
      // TODO(nenuphar): remove token from memory
      // and authenticate from zero again
      // (ok not authenticate directly, just set as notAuthorized)
      await sl<SessionManager>().logout();
      // WARNING possible infinite recursive call !
      await authenticate();
    }
    // ).catchError(logErrorMessage);
    Logger().d('[strava_repository] Authenticated ! (?)');
  }

  /// De authorizes the app from the user's Strava account.
  ///
  /// The cached activities are deleted, as they belong to this account.
  Future<void> deAuthorize() async {
    await stravaClient.authentication.deAuthorize().catchError(logErrorMessage);
    await clearCache();
  }

  /// Logs an error message.
  FutureOr<void> logErrorMessage(dynamic error, dynamic stackTrace) {
    if (error is Fault) {
      Logger().e(
        'Did Receive Fault',
        error: error,
        stackTrace: stackTrace as StackTrace,
      );
    } else {
      Logger().e(
        'Received Error which is not a Fault',
        error: error,
        stackTrace: stackTrace as StackTrace,
      );
    }
  }

  /// Whether the token is expired.
  bool isTokenExpired(TokenResponse token) {
    final expiresAt = DateTime.fromMillisecondsSinceEpoch(
      token.expiresAt * 1000,
    );
    return DateTime.now().isAfter(expiresAt);
  }
}
