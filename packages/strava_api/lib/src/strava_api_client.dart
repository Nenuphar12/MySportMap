import 'dart:async';
import 'dart:convert';

import 'package:oauth2/oauth2.dart' as oauth2;

import 'package:strava_api/strava_api.dart';

// TODO change name ?
/// Exception thrown when listActivity fails.
class ListActivityRequestFailure implements Exception {}

/// Exception thrown when getActivity fails.
class GetActivityRequestFailure implements Exception {}

/// {@template strava_api_client}
/// Dart API Client which wraps the [Strava API](https://developers.strava.com/)
/// {@endtemplate}
class StravaApiClient {
  /// {@macro strava_api_client}
  StravaApiClient({required this.apiClient});
  /*
  StravaApiClient({oauth2.Client? apiClient})
      : _apiClient =
            // TODO : add credentials !
            apiClient ?? oauth2.Client(oauth2.Credentials.fromJson('TODO'));
  */

  static const _baseUrlStrava = 'https://www.strava.com/api/';

  // TODO : pass [apiClient] to a private variable => _apiClient
  final oauth2.Client apiClient;

  /// Returns an array of [SummaryActivity] `/v3/athlete/activities`.
  ///
  /// Requires activity:read. Only Me activities will be filtered out unless
  /// requested by a token with activity:read_all.
  Future<List<SummaryActivity>> getLoggedInAthleteActivities(
      DateTime before, DateTime after,
      {int page = 1, int perPage = 30}) async {
    var completer = Completer<List<SummaryActivity>>();
    Uri endPoint = Uri.parse('$_baseUrlStrava/v3/athlete/activities');
    var headers = {
      'before': (before.millisecondsSinceEpoch / 1000).toString(),
      'after': (after.millisecondsSinceEpoch / 1000).toString(),
      'page': page.toString(),
      'perPage': perPage.toString(),
    };

    apiClient.get(endPoint, headers: headers).then((response) {
      if (response.statusCode != 200) {
        throw ListActivityRequestFailure();
      }

      // TESTS
      print(json.decode(response.body));
      print(json.decode(response.body).cast<String>());
      print(json.decode(response.body).cast<String>().toList());

      //var data = json.decode(response.body).cast<String>().toList();
      var data = jsonDecode(response.body) as List;
      var activitiesList = data
          //.map((d) => SummaryActivity.fromJson(Map<String, dynamic>.from(d)))
          // TODO : test if `as Map<String, dynamic>` is useful ???
          .map((d) => SummaryActivity.fromJson(d as Map<String, dynamic>))
          .toList();
      completer.complete(activitiesList);
    }).catchError(
        // TODO
        (error, stackTrace) =>
            print(error)); //handleError(completer, error, stackTrace));

    return completer.future;
  }

  // TODO : implement [getActivityById]
  /// Returns a [DetailedActivity] `/v3/activities/{id}`.
  Future<DetailedActivity> getActivityById(int id,
      {bool includeAllEfforts = true}) async {
    var completer = Completer<DetailedActivity>();
    Uri endPoint = Uri.parse('$_baseUrlStrava/v3/activities/$id');

    apiClient.get(endPoint).then((response) {
      if (response.statusCode != 200) {
        throw GetActivityRequestFailure();
      }

      var data = jsonDecode(response.body);
      var activity = DetailedActivity.fromJson(data);
      completer.complete(activity);
    }).catchError((error, StackTrace) => print(error)); // TODO : handle error

    return completer.future;
  }
}
