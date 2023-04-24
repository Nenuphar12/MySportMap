// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart' show Color, Colors;

/// sport type of an `activity`.
enum SportTypes {
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

/// Helper adding functions to manipulate [SportTypes]s.
extension SportTypeHelper on SportTypes {
  /// Returns a [SportTypes] from a [String] referring to this sport type.
  ///
  /// if no [SportTypes] corresponds, the type is set to `undefined`.
  ///
  /// The function is case insensitive.
  static SportTypes getType(String? sportTypeValue) {
    return SportTypes.values.firstWhere(
      (element) => element
          .toString()
          .toLowerCase()
          .endsWith((sportTypeValue ?? 'undefined').toLowerCase()),
      orElse: () => SportTypes.undefined,
    );
  }

  // useless (?)
  /// Returns a [String] corresponding to the sport type.
  ///
  /// The string returned is in lowercase.
  String stringValue() {
    return toString().split('.').last;
  }

  /// Deserializes the given json data into an [SportTypes].
  static SportTypes fromJson(Map<String, dynamic> json) =>
      getType(json['sport_type'] as String);

  /// Converts this [SportTypes] into json data.
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'sport_type': toString().split('.').last};

  /// Returns a color for each [SportTypes].
  static Color getColor(SportTypes sportType) {
    switch (sportType) {
      case SportTypes.undefined:
        return Colors.black;
      case SportTypes.hike:
        return Colors.green;
      case SportTypes.mountainBikeRide:
        return Colors.blueGrey;
      case SportTypes.ride:
        return Colors.blue;
      case SportTypes.run:
        return Colors.red;
      case SportTypes.trailRun:
        return Colors.orange;
      case SportTypes.walk:
        return Colors.lightGreen;

      // All black from here
      case SportTypes.alpineSki:
        return Colors.black;
      case SportTypes.backcountrySki:
        return Colors.black;
      case SportTypes.badminton:
        return Colors.black;
      case SportTypes.canoeing:
        return Colors.black;
      case SportTypes.crossfit:
        return Colors.black;
      case SportTypes.eBikeRide:
        return Colors.black;
      case SportTypes.elliptical:
        return Colors.black;
      case SportTypes.eMountainBikeRide:
        return Colors.black;
      case SportTypes.golf:
        return Colors.black;
      case SportTypes.gravelRide:
        return Colors.black;
      case SportTypes.handcycle:
        return Colors.black;
      case SportTypes.highIntensityIntervalTraining:
        return Colors.black;
      case SportTypes.iceSkate:
        return Colors.black;
      case SportTypes.inlineSkate:
        return Colors.black;
      case SportTypes.kayaking:
        return Colors.black;
      case SportTypes.kitesurf:
        return Colors.black;
      case SportTypes.nordicSki:
        return Colors.black;
      case SportTypes.pickleball:
        return Colors.black;
      case SportTypes.pilates:
        return Colors.black;
      case SportTypes.racquetball:
        return Colors.black;
      case SportTypes.rockClimbing:
        return Colors.black;
      case SportTypes.rollerSki:
        return Colors.black;
      case SportTypes.rowing:
        return Colors.black;
      case SportTypes.sail:
        return Colors.black;
      case SportTypes.skateboard:
        return Colors.black;
      case SportTypes.snowboard:
        return Colors.black;
      case SportTypes.snowshoe:
        return Colors.black;
      case SportTypes.soccer:
        return Colors.black;
      case SportTypes.squash:
        return Colors.black;
      case SportTypes.stairStepper:
        return Colors.black;
      case SportTypes.standUpPaddling:
        return Colors.black;
      case SportTypes.surfing:
        return Colors.black;
      case SportTypes.swim:
        return Colors.black;
      case SportTypes.tableTennis:
        return Colors.black;
      case SportTypes.tennis:
        return Colors.black;
      case SportTypes.velomobile:
        return Colors.black;
      case SportTypes.virtualRide:
        return Colors.black;
      case SportTypes.virtualRow:
        return Colors.black;
      case SportTypes.virtualRun:
        return Colors.black;
      case SportTypes.weightTraining:
        return Colors.black;
      case SportTypes.wheelchair:
        return Colors.black;
      case SportTypes.windsurf:
        return Colors.black;
      case SportTypes.workout:
        return Colors.black;
      case SportTypes.yoga:
        return Colors.black;
    }
  }
}
