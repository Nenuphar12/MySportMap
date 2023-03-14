// ignore_for_file: public_member_api_docs

/// sport type of an `activity`.
enum SportType {
  undefined,
  alpineSki,
  backcountrySki,
  badminton,
  canoeing,
  crossfit,
  eBikeRide,
  elliptical,
  eMountainBikeRide,
  golf,
  gravelRide,
  handcycle,
  highIntensityIntervalTraining,
  hike,
  iceSkate,
  inlineSkate,
  kayaking,
  kitesurf,
  mountainBikeRide,
  nordicSki,
  pickleball,
  pilates,
  racquetball,
  ride,
  rockClimbing,
  rollerSki,
  rowing,
  run,
  sail,
  skateboard,
  snowboard,
  snowshoe,
  soccer,
  squash,
  stairStepper,
  standUpPaddling,
  surfing,
  swim,
  tableTennis,
  tennis,
  trailRun,
  velomobile,
  virtualRide,
  virtualRow,
  virtualRun,
  walk,
  weightTraining,
  wheelchair,
  windsurf,
  workout,
  yoga
}

/// Helper adding functions to manipulate [SportType]s.
extension SportTypeHelper on SportType {
  /// Returns a [SportType] from a [String] referring to this sport type.
  ///
  /// if no [SportType] corresponds, the type is set to `undefined`.
  ///
  /// The function is case insensitive.
  static SportType getType(String? sportTypeValue) {
    return SportType.values.firstWhere(
      (element) => element
          .toString()
          .toLowerCase()
          .endsWith((sportTypeValue ?? 'undefined').toLowerCase()),
      orElse: () => SportType.undefined,
    );
  }

  // useless (?)
  /// Returns a [String] corresponding to the sport type.
  ///
  /// The string returned is in lowercase.
  String stringValue() {
    return toString().split('.').last;
  }

  /// Deserializes the given json data into an [SportType].
  static SportType fromJson(Map<String, dynamic> json) =>
      getType(json['sport_type'] as String);

  /// Converts this [SportType] into json data.
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'sport_type': toString().split('.').last};
}
