// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart' show Color, Colors;

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

  // TODO(nenuphar): doc...
  static Color getColor(SportType sportType) {
    switch (sportType) {
      case SportType.undefined:
        return Colors.black;
      case SportType.hike:
        return Colors.green;
      case SportType.mountainBikeRide:
        return Colors.blueGrey;
      case SportType.ride:
        return Colors.blue;
      case SportType.run:
        return Colors.red;
      case SportType.trailRun:
        return Colors.orange;
      case SportType.walk:
        return Colors.lightGreen;

      // All black from here
      case SportType.alpineSki:
        return Colors.black;
      case SportType.backcountrySki:
        return Colors.black;
      case SportType.badminton:
        return Colors.black;
      case SportType.canoeing:
        return Colors.black;
      case SportType.crossfit:
        return Colors.black;
      case SportType.eBikeRide:
        return Colors.black;
      case SportType.elliptical:
        return Colors.black;
      case SportType.eMountainBikeRide:
        return Colors.black;
      case SportType.golf:
        return Colors.black;
      case SportType.gravelRide:
        return Colors.black;
      case SportType.handcycle:
        return Colors.black;
      case SportType.highIntensityIntervalTraining:
        return Colors.black;
      case SportType.iceSkate:
        return Colors.black;
      case SportType.inlineSkate:
        return Colors.black;
      case SportType.kayaking:
        return Colors.black;
      case SportType.kitesurf:
        return Colors.black;
      case SportType.nordicSki:
        return Colors.black;
      case SportType.pickleball:
        return Colors.black;
      case SportType.pilates:
        return Colors.black;
      case SportType.racquetball:
        return Colors.black;
      case SportType.rockClimbing:
        return Colors.black;
      case SportType.rollerSki:
        return Colors.black;
      case SportType.rowing:
        return Colors.black;
      case SportType.sail:
        return Colors.black;
      case SportType.skateboard:
        return Colors.black;
      case SportType.snowboard:
        return Colors.black;
      case SportType.snowshoe:
        return Colors.black;
      case SportType.soccer:
        return Colors.black;
      case SportType.squash:
        return Colors.black;
      case SportType.stairStepper:
        return Colors.black;
      case SportType.standUpPaddling:
        return Colors.black;
      case SportType.surfing:
        return Colors.black;
      case SportType.swim:
        return Colors.black;
      case SportType.tableTennis:
        return Colors.black;
      case SportType.tennis:
        return Colors.black;
      case SportType.velomobile:
        return Colors.black;
      case SportType.virtualRide:
        return Colors.black;
      case SportType.virtualRow:
        return Colors.black;
      case SportType.virtualRun:
        return Colors.black;
      case SportType.weightTraining:
        return Colors.black;
      case SportType.wheelchair:
        return Colors.black;
      case SportType.windsurf:
        return Colors.black;
      case SportType.workout:
        return Colors.black;
      case SportType.yoga:
        return Colors.black;
    }
  }
}
