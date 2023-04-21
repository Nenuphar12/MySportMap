import 'dart:async';
import 'dart:convert';

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

// TODO(nenuphar): wait for auth everywhere ?
// TODO(nenuphar): divide this file ! Reduce it

/// Error thrown when an [Activity] with a given id is not found.
class ActivityNotFoundException implements Exception {}

/// A dart repository that handles `activity` by wrapping the `strava_client`.
///
/// Note:
/// `FM` refers to **Flutter Map** (using `flutter_map`) and `GM` refers to
/// **Google Map** (using `google_maps_flutter`).
class StravaRepository {
  /// Create a [StravaRepository] instance.
  ///
  /// [secret] is Strava's secret to access its *API* and [clientId] is your
  /// client id for Strava's *API*.
  ///
  /// This constructor calls [isAuthenticated].
  // TODO(nenuphar): develop consequences of calling isAuthenticated
  StravaRepository({required String secret, required String clientId}) {
    stravaClient = StravaClient(
      secret: secret,
      clientId: clientId,
      applicationName: 'mySportMap',
    );
    isAuthenticated();
  }

  // TODO(nenuphar): rename ?
  // This should only be called once at start
  /// Initialize the [userActivities] list.
  ///
  /// First the [Activity]s stored locally are fetched from the
  /// [SharedPreferences] and then the new [Activity]s are fetched from Strava's
  /// server. Finally, the local activities are updated with the new activities.
  ///
  /// After getting the local [Activity]s, [localPolylinesCompleterFM] and
  /// [localPolylinesCompleterGM] are completed with the [fm.Polyline]s and
  /// [gm.Polyline]s stored locally.
  /// After getting the new [Activity]s from Strava's server,
  /// [updatedPolylinesCompleterFM] and [updatedPolylinesCompleterGM] are
  /// completed with the new [fm.Polyline]s and [gm.Polyline]s from Strava that
  /// are not yet stored locally.
  ///
  /// Usage example:
  /// ```dart
  /// StravaRepository stravaRepository =
  ///     StravaRepository(secret: 'your-secret', clientId: 'your-client-id');
  ///
  /// stravaRepository.initLocalStorage();
  ///
  /// // Get polylines stored locally
  /// // (you can also omit this and directly get the updated polylines)
  /// stravaRepository.localPolylinesCompleterFM.future
  ///     .then((localPolylinesFM) {
  ///   // This is called when the local polylines have been fetched.
  ///   // Do something with the polylines...
  /// });
  ///
  /// // Get updated polylines (including stored and new ones)
  /// stravaRepository.updatedPolylinesCompleterFM.future
  ///     .then((localPolylinesFM) {
  ///   // This is called when the polylines have been updated.
  ///   // Do something with the polylines...
  /// });
  /// ```
  Future<void> initLocalStorage() async {
    // To make sure it is only called once
    if (!_localStorageInitialized) {
      _prefs = await SharedPreferences.getInstance();

      // Get activities stored locally
      getLocalActivities();
      // Get polylines from the local activities
      localPolylinesCompleterFM.complete(getPolylinesFM());
      localPolylinesCompleterGM.complete(getPolylinesGM());

      // Update the list of activities
      await updateLocalActivities();
      // Get all the polylines
      updatedPolylinesCompleterFM.complete(getPolylinesFM());
      updatedPolylinesCompleterGM.complete(getPolylinesGM());

      _localStorageInitialized = true;
    }
  }

  /// The client used by the repository to fetch data.
  late final StravaClient stravaClient;

  // TODO(nenuphar): use this or initialize in the constructor ?

  /// Wether the activities have been initialized via the [initLocalStorage]
  /// function.
  ///
  /// This is to ensure that [initLocalStorage] executes only once.
  bool _localStorageInitialized = false;

  /// The key used for storing the activities locally
  static const _activitiesCollectionKey =
      '[com.nenuphar.mySportMap]__activities_collection_key__';

  /// The key used for storing locally the date of the last activity fetched
  static const _activitiesLastCollectionKey =
      '[com.nenuphar.mySportMap]__activities_last_collection_key__';

  /// [Completer] used to get the [fm.Polyline]s from local storage.
  ///
  /// [initLocalStorage] needs to be called (at least) once for this [Completer]
  ///  to be completed.
  ///
  /// Note:
  /// If you directly want all the polylines (including new ones), directly use
  /// [updatedPolylinesCompleterFM].
  ///
  /// Usage example:
  /// ```dart
  /// // Then get the polylines stored locally
  /// stravaRepository.localPolylinesCompleterFM.future.then((polylines) {
  ///   // Do something when the polylines are returned...
  /// })
  final Completer<List<fm.Polyline>> localPolylinesCompleterFM =
      Completer<List<fm.Polyline>>();

  /// [Completer] used to get the updated [fm.Polyline]s (with potential new
  /// polylines).
  ///
  /// [initLocalStorage] needs to be called (at least) once for this [Completer]
  ///  to be completed.
  ///
  /// Usage example:
  /// ```dart
  /// // Get the updated polylines
  /// stravaRepository.updatedPolylinesCompleterFM.future.then((polylines) {
  ///   // Do something when the polylines are returned...
  /// })
  final Completer<List<fm.Polyline>> updatedPolylinesCompleterFM =
      Completer<List<fm.Polyline>>();

  /// [Completer] used to get the [gm.Polyline]s from local storage.
  ///
  /// [initLocalStorage] needs to be called (at least) once for this [Completer]
  ///  to be completed.
  ///
  /// Note:
  /// If you directly want all the polylines (including new ones), directly use
  /// [updatedPolylinesCompleterGM].
  ///
  /// Usage example:
  /// ```dart
  /// // Then get the polylines stored locally
  /// stravaRepository.localPolylinesCompleterGM.future.then((polylines) {
  ///   // Do something when the polylines are returned...
  /// })
  final Completer<Set<gm.Polyline>> localPolylinesCompleterGM =
      Completer<Set<gm.Polyline>>();

  /// [Completer] used to get the updated [gm.Polyline]s (with potential new
  /// polylines).
  ///
  /// [initLocalStorage] needs to be called (at least) once for this [Completer]
  ///  to be completed.
  ///
  /// Usage example:
  /// ```dart
  /// // Get the updated polylines
  /// stravaRepository.updatedPolylinesCompleterGM.future.then((polylines) {
  ///   // Do something when the polylines are returned...
  /// })
  final Completer<Set<gm.Polyline>> updatedPolylinesCompleterGM =
      Completer<Set<gm.Polyline>>();

  /// Wether the user is authenticated.
  ///
  /// This [Completer] is completed after [isAuthenticated] completes.
  final Completer<bool> isAuthenticatedCompleter = Completer<bool>();

  /// [SharedPreferences] instance to access the local stored data.
  late final SharedPreferences _prefs;

  /// Strava's [Activity]s of the authenticated user.
  List<Activity> userActivities = [];

  /// Whether the client is already authenticated.
  ///
  /// To verify authentication, the stored [TokenResponse] is checked.
  ///
  /// If the client is authenticated and the token has expired, the token is
  /// refreshed by calling [authenticate].
  ///
  /// [isAuthenticatedCompleter] is completed with the result of the
  /// authentication.
  Future<bool> isAuthenticated() async {
    final token =
        await LocalStorageManager.getToken(applicationName: 'mySportMap');
    if (token != null) {
      // Refresh the token if needed.
      if (isTokenExpired(token)) {
        // Refresh the token (with authenticate)
        Logger().d('[Token] Refreshing');
        try {
          await authenticate();
        } catch (e, s) {
          // Currently never reached I think because all errors are catched by
          // authenticate.
          logErrorMessage(e, s);
          isAuthenticatedCompleter.complete(false);
          return false;
        }
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
  /// - `activity_read_all`
  /// - `read_all`
  /// - `profile_read_all`
  ///
  /// In case of an error during authentication, the `token` is revoked by
  /// calling [SessionManager.logout] and then [authenticate] is called again
  /// (**WARNING** this could lead to an infinite recursive call of
  /// [authenticate]).
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
  ///
  /// **Information**: The current [TokenResponse] needs to be valid.
  /// Else an error is thrown.
  Future<void> deAuthorize() async {
    await stravaClient.authentication.deAuthorize().catchError(logErrorMessage);
  }

  /// List Strava's [Activity]s of the user.
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

  /// List **all** Strava's [Activity]s of the user.
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

  /// Returns the [List] of flutter_map [fm.Polyline]s from the
  /// [userActivities].
  ///
  /// The encoded [fm.Polyline] are decoded with [decodeEncodedPolylineFM].
  FutureOr<List<fm.Polyline>> getPolylinesFM() {
    return userActivities
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

  /// Returns the [Set] of flutter_map [gm.Polyline]s from the
  /// [userActivities].
  ///
  /// The encoded [gm.Polyline] are decoded with [decodeEncodedPolylineGM].
  FutureOr<Set<gm.Polyline>> getPolylinesGM() {
    return userActivities
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

  /// Fetch all the user's [Activity]s locally stored with [SharedPreferences].
  List<Activity> getLocalActivities() {
    Logger().v('Get local activities');
    final encodedActivities = _prefs.getString(_activitiesCollectionKey);
    final activitiesJsonList =
        jsonDecode(encodedActivities ?? '[]') as List<dynamic>;
    return userActivities = activitiesJsonList
        .map(
          (jsonActivity) =>
              Activity.fromJson(jsonActivity as Map<String, dynamic>),
        )
        .toList();
  }

  /// Update [userActivities] with the most recent [Activity]s.
  ///
  /// Waits for the authentication check to be completed, with
  /// [isAuthenticatedCompleter], before querying Strava.
  Future<List<Activity>> updateLocalActivities() async {
    Logger().v("[activities - remote] Update user's activities");

    // Get last update time
    final lastUpdate = DateTime.fromMillisecondsSinceEpoch(
      _prefs.getInt(_activitiesLastCollectionKey) ?? 0,
    );

    // Wait for authentication
    final isAuth = await isAuthenticatedCompleter.future;

    // If we can access Strava's database
    if (isAuth) {
      final newActivities = await listAllActivities(after: lastUpdate);
      if (newActivities.isNotEmpty) {
        // TODO(nenuphar): test if duplicates
        userActivities += newActivities;
        // Update last fetch time to current time
        await _prefs.setInt(
          _activitiesLastCollectionKey,
          DateTime.now().millisecondsSinceEpoch,
        );
        // Store the user's activities
        await _prefs.setString(
          _activitiesCollectionKey,
          jsonEncode(userActivities),
        );
      }
    } else {
      // The user is not authenticated
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
