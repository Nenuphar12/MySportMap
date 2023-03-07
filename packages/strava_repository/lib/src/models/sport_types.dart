// ignore_for_file: constant_identifier_names

enum SportType {
  Undefined,
  AlpineSki,
  BackcountrySki,
  Badminton,
  Canoeing,
  Crossfit,
  EBikeRide,
  Elliptical,
  EMountainBikeRide,
  Golf,
  GravelRide,
  Handcycle,
  HighIntensityIntervalTraining,
  Hike,
  IceSkate,
  InlineSkate,
  Kayaking,
  Kitesurf,
  MountainBikeRide,
  NordicSki,
  Pickleball,
  Pilates,
  Racquetball,
  Ride,
  RockClimbing,
  RollerSki,
  Rowing,
  Run,
  Sail,
  Skateboard,
  Snowboard,
  Snowshoe,
  Soccer,
  Squash,
  StairStepper,
  StandUpPaddling,
  Surfing,
  Swim,
  TableTennis,
  Tennis,
  TrailRun,
  Velomobile,
  VirtualRide,
  VirtualRow,
  VirtualRun,
  Walk,
  WeightTraining,
  Wheelchair,
  Windsurf,
  Workout,
  Yoga
}

extension SportTypeHelper on SportType {
  static SportType getType(String sportTypeValue) {
    return SportType.values.firstWhere(
      (element) => element.toString().endsWith(sportTypeValue),
      orElse: () => SportType.Undefined,
    );
  }

  // TODO(nenuphar): useless (?)
  String stringValue() {
    return toString().split('.').last;
  }

  SportType fromJson(Map<String, dynamic> json) =>
      getType(json['sport_type'] as String);

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'sport_type': toString().split('.').last};
}
