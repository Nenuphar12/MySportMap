import 'dart:io';

import 'package:strava_api/strava_api.dart';
import 'package:strava_repository/strava_repository.dart';

class StravaRepository {
  StravaRepository(this.stravaApiClient);
  //: _stravaApiClient = stravaApiClient ?? StravaApiClient();

  final StravaApiClient stravaApiClient;

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
    var _before = before ?? DateTime.now();
    var _after = after ?? DateTime(1999);
    final listDetailedActivities =
        await stravaApiClient.getLoggedInAthleteActivities(
            before ?? DateTime.now(), after ?? DateTime(1999),
            page: page ?? 1, perPage: perPage ?? 30);
    var listActivities = listDetailedActivities
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
    // TODO
    final detailedActivity = await stravaApiClient.getActivityById(id);
    return Activity(
        id: detailedActivity.id,
        name: detailedActivity.name,
        distance: detailedActivity.distance,
        map: detailedActivity.map);
  }
}
