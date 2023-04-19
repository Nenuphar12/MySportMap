import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'settings_state.dart';

/// {@template settings_cubit}
/// A [Cubit] which manages the settings of the application with a
/// [SettingsState] as its state.
/// {@endtemplate}
class SettingsCubit extends Cubit<SettingsState> {
  /// {@macro settings_cubit}
  SettingsCubit() : super(const SettingsState());

  // TODO(nenuphar): implement this (?)
  /// Change the state to a new state
  void setSettingsState(SettingsState newState) => emit(const SettingsState());

  /// Change the map type
  void setMapType(MyMapTypes newMapType) =>
      emit(state.changeMapType(newMapType));

  /// Switch the map type
  ///
  /// Change from [MyMapTypes.flutterMap] to [MyMapTypes.googleMap] or the
  /// opposite.
  void switchMapType() => emit(state.switchMapType());
}
