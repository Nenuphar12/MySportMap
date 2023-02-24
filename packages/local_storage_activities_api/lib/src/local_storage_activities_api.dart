import 'dart:convert';

import 'package:activities_api/activities_api.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template local_storage_activities_api}
/// A Flutter implementation of the [ActivitiesApi] that uses local storage.
/// {@endtemplate}
class LocalStorageActivitiesApi extends ActivitiesApi {
  /// {@macro local_storage_activities_api}
  LocalStorageActivitiesApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  final _activityStreamController =
      BehaviorSubject<List<Activity>>.seeded(const []);

  /// The key used for storing the activities locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kActivitiesCollectionKey = '__activities_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    final activitiesJson = _getValue(kActivitiesCollectionKey);
    if (activitiesJson != null) {
      final activities = List<Map<dynamic, dynamic>>.from(
        json.decode(activitiesJson) as List,
      ).map((json) => Activity.fromJson(json as Map<String, dynamic>)).toList();
      _activityStreamController.add(activities);
    } else {
      _activityStreamController.add(const []);
    }
  }

  @override
  Stream<List<Activity>> getActivities() =>
      _activityStreamController.asBroadcastStream();

  @override
  Future<void> saveActivity(Activity activity) {
    final activities = [..._activityStreamController.value];
    final activiyIndex = activities.indexWhere((t) => t.id == activity.id);
    if (activiyIndex >= 0) {
      activities[activiyIndex] = activity;
    } else {
      activities.add(activity);
    }

    _activityStreamController.add(activities);
    return _setValue(kActivitiesCollectionKey, json.encode(activities));
  }

  @override
  Future<void> deleteActivity(int id) async {
    final activities = [..._activityStreamController.value];
    final activityIndex = activities.indexWhere((t) => t.id == id);
    if (activityIndex == -1) {
      throw ActivityNotFoundException();
    } else {
      activities.removeAt(activityIndex);
      _activityStreamController.add(activities);
      return _setValue(kActivitiesCollectionKey, json.encode(activities));
    }
  }
}
