//import 'package:strava_api/strava_api.dart';
import 'package:strava_client/domain/model/model_authentication_scopes.dart';
import 'package:strava_repository/strava_repository.dart';
import 'package:strava_client/strava_client.dart';

class StravaRepository {
  StravaRepository({required secret, required clientId}) {
    this.stravaClient = StravaClient(
        secret: secret, clientId: clientId, applicationName: "mySportMap");
  }
  //: _stravaApiClient = stravaApiClient ?? StravaApiClient();

  //final StravaApiClient stravaApiClient;
  late final StravaClient stravaClient;

  /// List **all** [Activity] of the user.
  Future<List<Activity>> listAllActivities() async {
    List<Activity> allActivities = [];
    var page = 1;
    var notDone = true;
    while (notDone) {
      var someActivities = await listActivities(page: page, perPage: 50);
      allActivities += someActivities;
      page++;
      if (someActivities.isEmpty) notDone = false;
    }
    return allActivities;
  }

  /// List [Activity] of the user.
  Future<List<Activity>> listActivities(
      {DateTime? before, DateTime? after, int? page, int? perPage}) async {
    final listSummaryActivities = await stravaClient.activities
        .listLoggedInAthleteActivities(before ?? DateTime.now(),
            after ?? DateTime(1999), page ?? 1, perPage ?? 30);
    /*
    await stravaClient.getLoggedInAthleteActivities(
        before ?? DateTime.now(), after ?? DateTime(1999),
        page: page ?? 1, perPage: perPage ?? 30);
    */
    var listActivities = listSummaryActivities
        .map((a) =>
            Activity(id: a.id, name: a.name, distance: a.distance, map: a.map))
        .toList();
    /*
    var listActivities = [];
    for (var activity in listDetailedActivities) {
      listActivities.add(Activity(
          id: activity.id,
          name: activity.name,
          distance: activity.distance,
          map: activity.map));
    }
    */
    return listActivities;
  }

  /// Fetch a specific [Activity].
  Future<Activity> getActivity(int id) async {
    final detailedActivity = await stravaClient.activities.getActivity(id);
    return Activity(
        id: detailedActivity.id,
        name: detailedActivity.name,
        distance: detailedActivity.distance,
        map: detailedActivity.map);
  }

  Future<void> authenticate() async {
    // TODO good parameters ???
    // From source code :
    // RedirectUrl works best when it is a custom scheme. For example: strava://auth
    // If your redirectUrl is, for exmaple, strava://auth then your callbackUrlScheme should be strava
    await stravaClient.authentication.authenticate(
      scopes: [
        AuthenticationScope.activity_read_all,
        AuthenticationScope.read_all,
        AuthenticationScope.profile_read_all
      ],
      redirectUrl: 'com.example.mysportmap://redirect',
      //redirectUrl: 'com.example.mysportmap://redirect',
      //redirectUrl: 'com.example.mysportmap',
      //redirectUrl: 'my_sport_map://auth',
      //redirectUrl: 'com.example.my_sport_map://auth',
      //redirectUrl: 'stravaflutter://redirect',
      //callbackUrlScheme: 'com.example.mysportmap',
      callbackUrlScheme: 'com.example.mysportmap',
      //callbackUrlScheme: 'com.example.my_sport_map',
      //callbackUrlScheme: 'stravaflutter',
      //callbackUrlScheme: 'localhost',
      forceShowingApproval: true, // TEST (not enought...)
    );
    print('[strava_repository] Authenticated ! (?)');
  }

  Future<void> deAuthorize() async {
    await stravaClient.authentication.deAuthorize();
  }
}
