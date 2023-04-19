part of 'settings_cubit.dart';

enum MyMapTypes {
  flutterMap,
  googleMap,
}

class SettingsState extends Equatable {
  const SettingsState({
    this.mapType = MyMapTypes.flutterMap,
  });

  final MyMapTypes mapType;

  @override
  List<Object> get props => [mapType];

  /// Return a new [SettingsState] with the updated [mapType].
  SettingsState changeMapType(MyMapTypes newMapType) {
    return SettingsState(mapType: newMapType);
  }

  /// Return a new [SettingsState] with the updated switched [mapType].
  SettingsState switchMapType() {
    return SettingsState(
      mapType: mapType == MyMapTypes.flutterMap
          ? MyMapTypes.googleMap
          : MyMapTypes.flutterMap,
    );
  }
}
