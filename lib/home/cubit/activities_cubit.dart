import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:my_sport_map/utilities/utilities.dart';
import 'package:strava_repository/strava_repository.dart';

part 'activities_state.dart';

/// {@template activities_cubit}
/// A [Cubit] which manages the user's activities displayed on the map, as an
/// [ActivitiesState].
/// {@endtemplate}
class ActivitiesCubit extends Cubit<ActivitiesState> {
  /// {@macro activities_cubit}
  ActivitiesCubit({required StravaRepository stravaRepository})
    : _stravaRepository = stravaRepository,
      super(const ActivitiesState());

  final StravaRepository _stravaRepository;

  /// Incremented by [clear], so a sync started before it is discarded.
  int _generation = 0;

  /// Shows the cached activities right away, then syncs them with Strava.
  Future<void> load() async {
    final generation = _generation;
    final cachedActivities = await _stravaRepository.getCachedActivities();
    if (isClosed || generation != _generation) return;
    emit(
      ActivitiesState(
        status: ActivitiesStatus.syncing,
        polylines: StravaRepository.polylinesOf(cachedActivities),
      ),
    );
    await _sync(full: false);
  }

  /// Fetches all the activities from Strava again.
  ///
  /// Unlike [load], this also picks up activities edited or deleted on Strava.
  Future<void> refresh() async {
    emit(state.copyWith(status: ActivitiesStatus.syncing));
    await _sync(full: true);
  }

  /// Removes the activities from the map, e.g. after logging out.
  void clear() {
    _generation++;
    emit(const ActivitiesState());
  }

  Future<void> _sync({required bool full}) async {
    final generation = _generation;
    try {
      final activities = await _stravaRepository.syncActivities(full: full);
      if (isClosed || generation != _generation) return;
      emit(
        ActivitiesState(
          status: ActivitiesStatus.synced,
          polylines: StravaRepository.polylinesOf(activities),
        ),
      );
    } on Object catch (error, stackTrace) {
      logger.w(
        '[activities] Sync failed',
        error: error,
        stackTrace: stackTrace,
      );
      if (isClosed || generation != _generation) return;
      emit(state.copyWith(status: ActivitiesStatus.failure));
    }
  }
}
