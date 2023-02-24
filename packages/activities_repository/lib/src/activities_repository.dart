import 'package:activities_api/activities_api.dart';

/// {@template activities_repository}
/// A repository that handles activity related requests.
/// {@endtemplate}
class ActivitiesRepository {
  /// {@macro activities_repository}
  const ActivitiesRepository({
    required ActivitiesApi activitiesApi,
  }) : _activitiesApi = activitiesApi;

  final ActivitiesApi _activitiesApi;

  /// Provides a [Stream] of all activities.
  Stream<List<Activity>> getActivities() => _activitiesApi.getActivities();

  /// Saves a [activity].
  ///
  /// If a [activity] with the same id already exists, it will be replaced.
  Future<void> saveActivity(Activity activity) =>
      _activitiesApi.saveActivity(activity);

  /// Deletes the `activity` with the given id.
  ///
  /// If no `activity` with the given id exists, a [ActivityNotFoundException]
  /// error is thrown.
  Future<void> deleteActivity(int id) => _activitiesApi.deleteActivity(id);
}
