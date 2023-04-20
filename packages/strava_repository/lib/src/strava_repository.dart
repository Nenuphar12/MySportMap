import 'dart:async';
import 'dart:convert';

// TODO(nenuphar): remove this one
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart' as fm show Polyline;
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm
    show Polyline, PolylineId;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
/// {@endtemplate}
class StravaRepository {
  /// {@macro strava_repository}
  StravaRepository({required String secret, required String clientId}) {
    stravaClient = StravaClient(
      secret: secret,
      clientId: clientId,
      applicationName: 'mySportMap',
    );
    isAuthenticated();
    // TODO(nenuphar): Problem -> too fast, I'm not authenticated
    // initLocalStorage();
    // prefsCompleter.complete(SharedPreferences.getInstance());
  }

  // TODO(nenuphar): rename ?
  Future<void> initLocalStorage() async {
    prefs = await SharedPreferences.getInstance();
    // Get activities stored locally
    getLocalActivities();
    // Get polylines from the local activities
    localPolylinesCompleterFM.complete(getPolylinesFM());
    // Update the list of activities
    await updateLocalActivities();
    // Get all the polylines
    updatedPolylinesCompleterFM.complete(getPolylinesFM());
  }

  /// The client used by the repository to fetch data.
  late final StravaClient stravaClient;

  /// The key used for storing the activities locally
  static const activitiesCollectionKey = '__activities_collection_key__';

  /// The key used for storing locally the date of the last activity fetched
  static const activitiesLastCollectionKey =
      '__activities_last_collection_key__';

  // TODO(nenuphar): remove if not needed
  /// [Completer] to access the `shared preferences`.
  final Completer<SharedPreferences> prefsCompleter =
      Completer<SharedPreferences>();

  final Completer<bool> gotLocalActivities = Completer<bool>();
  final Completer<bool> gotUpdatedActivities = Completer<bool>();

  final Completer<List<fm.Polyline>> localPolylinesCompleterFM =
      Completer<List<fm.Polyline>>();
  final Completer<List<fm.Polyline>> updatedPolylinesCompleterFM =
      Completer<List<fm.Polyline>>();
  final Completer<List<gm.Polyline>> localPolylinesCompleterGM =
      Completer<List<gm.Polyline>>();
  final Completer<List<gm.Polyline>> updatedPolylinesCompleterGM =
      Completer<List<gm.Polyline>>();

  final Completer<bool> isAuthenticatedCompleter = Completer<bool>();

  /// [SharedPreferences] instance to access the local stored data.
  late final SharedPreferences prefs;

  // TODO(nenuphar): use a set ?
  List<Activity> userActivities = [];

  /// Whether the client is already authenticated.
  ///
  /// If the client is authenticated, the token is refreshed.
  Future<bool> isAuthenticated() async {
    final token =
        await LocalStorageManager.getToken(applicationName: 'mySportMap');
    if (token != null) {
      // Refresh the token if needed.
      if (isTokenExpired(token)) {
        // Refresh the token (with authenticate)
        Logger().d('Refreshing token.');
        try {
          await authenticate();
        } catch (e, s) {
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
      isAuthenticatedCompleter.complete(true);
      // return true if a token is stored
      return true;
    } else {
      isAuthenticatedCompleter.complete(false);
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
          AuthenticationScope.profile_read_all
        ],
        redirectUrl: 'com.nenuphar.mysportmap://redirect',
        callbackUrlScheme: 'com.nenuphar.mysportmap',
      );
    } catch (e, s) {
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
  Future<void> deAuthorize() async {
    await stravaClient.authentication.deAuthorize().catchError(logErrorMessage);
  }

  /// List [Activity]s of the user.
  Future<List<Activity>> listActivities({
    DateTime? before,
    DateTime? after,
    int? page,
    int? perPage,
  }) async {
    final listSummaryActivities =
        await stravaClient.activities.listLoggedInAthleteActivities(
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
          ),
        )
        .toList();
    return listActivities;
  }

  /// List **all** [Activity] of the user.
  ///
  /// To get all the [Activity]s after a [DateTime], use the [after] parameter.
  Future<List<Activity>> listAllActivities({
    DateTime? after,
  }) async {
    var allActivities = <Activity>[];
    var page = 1;
    var notDone = true;
    while (notDone) {
      final someActivities =
          await listActivities(page: page, perPage: 100, after: after);
      allActivities += someActivities;
      page++;
      if (someActivities.isEmpty) notDone = false;
    }
    // if we fetched all the activities, update [userActivities]
    if (after == null) userActivities = allActivities;
    return allActivities;
  }

  /// Returns a set of flutter_map [fm.Polyline]s from the encoded
  /// summaryPolylines.
  Future<List<fm.Polyline>> getAllPolylinesFM() async {
    final allActivities = await listAllActivities();
    // final allMaps = allActivities.map((a) => a.map).toList();
    final allPolylines = allActivities
        .map((a) {
          if (a.map?.id != null && a.map?.summaryPolyline != null) {
            return fm.Polyline(
              key: Key(a.map?.id ?? 'no_id'),
              points: decodeEncodedPolylineFM(a.map?.summaryPolyline ?? ''),
              strokeWidth: 2,
              color:
                  SportTypeHelper.getColor(a.sportType ?? SportType.undefined),
            );
          }
        })
        .whereType<fm.Polyline>()
        .toList();
    return allPolylines;
  }

  // List<fm.Polyline> getPolylinesFM() {
  //   // TODO(nenuphar): possible race condition of prefs...
  //   final localPolylines = getLocalPolylinesFM();
  //   updatePolylinesFM();
  //   return localPolylines;
  // }

  FutureOr<List<fm.Polyline>> getPolylinesFM() {
    return activitiesToPolylinesFM(userActivities);
  }

  List<fm.Polyline> getLocalPolylinesFM() {
    final localActivities = userActivities;
    final localPolylines = activitiesToPolylinesFM(localActivities);
    localPolylinesCompleterFM.complete(localPolylines);
    return localPolylines;
  }

  Future<List<fm.Polyline>> updatePolylinesFM() async {
    final newActivities = await updateLocalActivities();
    final newPolylines = activitiesToPolylinesFM(newActivities);
    updatedPolylinesCompleterFM.complete(newPolylines);
    return newPolylines;
  }

  List<fm.Polyline> activitiesToPolylinesFM(List<Activity> activities) {
    return activities
        .map((a) {
          if (a.map?.id != null && a.map?.summaryPolyline != null) {
            return fm.Polyline(
              key: Key(a.map?.id ?? 'no_id'),
              points: decodeEncodedPolylineFM(a.map?.summaryPolyline ?? ''),
              strokeWidth: 2,
              color:
                  SportTypeHelper.getColor(a.sportType ?? SportType.undefined),
            );
          }
        })
        .whereType<fm.Polyline>()
        .toList();
  }

  /// Returns a set of google_maps_flutter [fm.Polyline]s from the encoded
  /// summaryPolylines.
  Future<Set<gm.Polyline>> getAllPolylinesGM() async {
    final allActivities = await listAllActivities();
    // final allMaps = allActivities.map((a) => a.map).toList();
    final allPolylines = allActivities
        .map((a) {
          if (a.map?.id != null && a.map?.summaryPolyline != null) {
            return gm.Polyline(
              polylineId: gm.PolylineId(a.map?.id ?? 'no_id'),
              points: decodeEncodedPolylineGM(a.map?.summaryPolyline ?? ''),
              width: 2,
              color:
                  SportTypeHelper.getColor(a.sportType ?? SportType.undefined),
            );
          }
        })
        .whereType<gm.Polyline>()
        .toSet();
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

  List<Activity> getLocalActivities() {
    Logger().v('Get local activities');
    final encodedActivities = prefs.getString(activitiesCollectionKey);
    final activitiesJsonList =
        jsonDecode(encodedActivities ?? '[]') as List<dynamic>;
    // return userActivities =
    //     jsonDecode(encodedActivities ?? '[]') as List<Activity>;
    return userActivities = activitiesJsonList
        .map(
          (jsonActivity) =>
              Activity.fromJson(jsonActivity as Map<String, dynamic>),
        )
        .toList();
  }

  /// Stores [Activity]s locally.
  Future<void> storeActivitiesLocally(List<Activity> activitiesList) async {
    Logger().v('Store activities locally');
    await prefs.setString(
      activitiesCollectionKey,
      jsonEncode(userActivities),
    );
  }

  // TODO(nenuphar): return userActivities ?
  Future<List<Activity>> updateLocalActivities() async {
    Logger().v("Update user's activities");
    // TODO(nenuphar): does this work ? (it waits ?)
    final lastUpdate = DateTime.fromMillisecondsSinceEpoch(
      prefs.getInt(activitiesLastCollectionKey) ?? 0,
    );
    final isAuth = await isAuthenticatedCompleter.future;
    if (isAuth) {
      final newActivities = await listAllActivities(after: lastUpdate);
      // TODO(nenuphar): test if duplicates
      userActivities += newActivities;
      // Update last fetch time to current time
      await prefs.setInt(
        activitiesLastCollectionKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      await prefs.setString(
        activitiesCollectionKey,
        jsonEncode(userActivities),
      );
    } else {
      // TODO(nenuphar): throw error
    }
    return userActivities;
  }

  /// Logs an error message.
  FutureOr<void> logErrorMessage(dynamic error, dynamic stackTrace) {
    if (error is Fault) {
      Logger().e('Did Receive Fault', error, stackTrace as StackTrace);
    } else {
      Logger().e(
        'Received Error which is not a Fault',
        error,
        stackTrace as StackTrace,
      );
    }
  }

  /// Whether the token is expired.
  bool isTokenExpired(TokenResponse token) {
    final expiresAt =
        DateTime.fromMillisecondsSinceEpoch(token.expiresAt * 1000);
    return DateTime.now().isAfter(expiresAt);
  }
}
