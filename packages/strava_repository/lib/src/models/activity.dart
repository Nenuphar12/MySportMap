import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
//import 'package:latlng/latlng.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:strava_api/strava_api.dart';

part 'activity.g.dart';

/// {@template activity_item}
/// A single `activity` item.
///
/// Contains an [id], [name], [distance] and [map] (and other).
@immutable
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Activity extends Equatable {
  const Activity({
    this.id,
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
    this.photoCount,
    this.totalPhotoCount,
    this.map,
    this.workoutType,
    this.averageSpeed,
    this.maxSpeed,
    this.gearId,
  });

  //@JsonKey(defaultValue: false)
  //@JsonKey(required: true)
  //@JsonKey(ignore: true)
  final BigInt? id;
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
  final int? photoCount;
  final int? totalPhotoCount;
  final PolylineMap? map;
  final int? workoutType;
  final double? averageSpeed;
  final double? maxSpeed;
  final String? gearId;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);

  @override
  List<Object?> get props =>
      [id, name, distance, distance, elapsedTime, startDate];
}
