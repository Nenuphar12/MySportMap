import 'package:bloc/bloc.dart';
import 'package:my_sport_map/utilities/utilities.dart';

/// {@template my_sport_map_observer}
/// [BlocObserver] fot the my_sport_map application which observes all state
/// changes.
/// {@endtemplate}
class MySportMapObserver extends BlocObserver {
  /// {@macro my_sport_map_observer}
  const MySportMapObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    logger.v('[MySportMapObserver] ${bloc.runtimeType} $change');
  }
}
