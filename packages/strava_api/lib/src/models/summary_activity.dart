import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

import 'small_models.dart';
import 'sport_types.dart';

part 'summary_activity.g.dart';
//part 'meta_athlete.g.dart';
//part 'polyline_map.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class SummaryActivity {
  const SummaryActivity({
    this.id,
    this.externalId,
    this.uploadId,
    this.athlete,
    this.name,
    this.distance,
    this.movingTime,
    this.elapsedTime,
    this.totalElevationGain,
    this.elevHigh,
    this.elevLow,
    this.sportType,
    this.startDate,
    this.startDateLocal,
    this.timezone,
    this.startLatLng,
    this.endLatLng,
    this.achievementCount,
    this.kudosCount,
    this.commentCount,
    this.athleteCount,
    this.photoCount,
    this.totalPhotoCount,
    this.map,
    this.trainer,
    this.commute,
    this.manual,
    this.private,
    this.flagged,
    this.workoutType,
    this.uploadIdStr,
    this.averageSpeed,
    this.maxSpeed,
    this.hasKudoed,
    this.hideFromHome,
    this.gearId,
    this.kilojoules,
    this.averageWatts,
    this.deviceWatts,
    this.maxWatts,
    this.weightedAverageWatts,
  });

  //@JsonKey(defaultValue: false)
  //@JsonKey(required: true)
  //@JsonKey(ignore: true)
  final int? id;
  final String? externalId;
  final int? uploadId;
  final MetaAthlete? athlete;
  final String? name;
  final double? distance;
  final int? movingTime;
  final int? elapsedTime;
  final double? totalElevationGain;
  final double? elevHigh;
  final double? elevLow;
  final SportType? sportType;
  final DateTime? startDate;
  final DateTime? startDateLocal;
  final String? timezone;
  // explicitly specify which methods of LatLng should be used for
  // serialization using JsonKey annotation
  @JsonKey(fromJson: LatLng.fromJson, toJson: jsonEncode)
  final LatLng? startLatLng;
  @JsonKey(fromJson: LatLng.fromJson, toJson: jsonEncode)
  final LatLng? endLatLng;
  final int? achievementCount;
  final int? kudosCount;
  final int? commentCount;
  final int? athleteCount;
  final int? photoCount;
  final int? totalPhotoCount;
  final PolylineMap? map;
  final bool? trainer;
  final bool? commute;
  final bool? manual;
  final bool? private;
  final bool? flagged;
  final int? workoutType;
  final String? uploadIdStr;
  final double? averageSpeed;
  final double? maxSpeed;
  final bool? hasKudoed;
  final bool? hideFromHome;
  final String? gearId;
  final double? kilojoules;
  final double? averageWatts;
  final bool? deviceWatts;
  final int? maxWatts;
  final int? weightedAverageWatts;

  factory SummaryActivity.fromJson(Map<String, dynamic> json) =>
      _$SummaryActivityFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryActivityToJson(this);
}
