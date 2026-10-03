part of 'activities_cubit.dart';

enum ActivitiesStatus {
  initial, // Nothing loaded yet, or the user logged out.
  syncing, // Showing the cached activities while syncing with Strava.
  synced, // Showing the activities fetched from Strava.
  failure, // The last sync failed: showing the activities known before it.
}

class ActivitiesState extends Equatable {
  const ActivitiesState({
    this.status = ActivitiesStatus.initial,
    this.polylines = const [],
  });

  final ActivitiesStatus status;

  /// The routes of the activities to display on the map.
  final List<Polyline> polylines;

  @override
  List<Object> get props => [status, polylines];

  ActivitiesState copyWith({
    ActivitiesStatus? status,
    List<Polyline>? polylines,
  }) {
    return ActivitiesState(
      status: status ?? this.status,
      polylines: polylines ?? this.polylines,
    );
  }
}
