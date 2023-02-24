import 'package:activities_api/activities_api.dart';

/// {@template activities_api}
/// The interface for an API that provides access to a list of activities.
/// {@endtemplate}
abstract class ActivitiesApi {
  /// {@macro activities_api}
  const ActivitiesApi();

  /// Provides a [Stream] of all Activities.
  Stream<List<Activity>> getActivities();

  /// Saves an [Activity].
  ///
  /// If an [Activity] with the same id already exists, it will be replaced.
  Future<void> saveActivity(Activity activity);

  /// Deletes the `activity` with the given id.
  ///
  /// If no `activity` with the given id exists, an [ActivityNotFoundException]
  /// error is thrown.
  Future<void> deleteActivity(int id);
}

/// Error thrown when an [Activity] with a given id is not found.
class ActivityNotFoundException implements Exception {}
