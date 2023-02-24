import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

import 'sport_types.dart';
import 'small_models.dart';

part 'detailed_activity.g.dart';
//part 'meta_athlete.g.dart';
//part 'polyline_map.g.dart';

// TODO : extends SummaryActivity ? (nop ?)
// TODO : make it equatable ?
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class DetailedActivity {
  const DetailedActivity({
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
    this.averageSpeed,
    this.maxSpeed,
    this.gearId,
    this.description,
    this.photos,
    this.calories,
    this.deviceName,
    this.embedToken,
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
  final double? averageSpeed;
  final double? maxSpeed;
  final String? gearId;
  // Specific to DetailedActivity from here
  final String? description;
  final PhotosSummary? photos;
  //final SummaryGear gear;
  final double? calories;
  //final DetailedSegmentEffort segmentEfforts;
  final String? deviceName;
  final String? embedToken;
  // TODO ?
  //final Split? splitMetrics;
  //final Split? splitStandart;
  //final Lap laps;
  //final DetailedSegmentEffort best_efforts;

  factory DetailedActivity.fromJson(Map<String, dynamic> json) =>
      _$DetailedActivityFromJson(json);

  Map<String, dynamic> toJson() => _$DetailedActivityToJson(this);
}
