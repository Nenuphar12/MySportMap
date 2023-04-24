import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:strava_client/strava_client.dart' show PolyLineMap;
import 'package:strava_repository/src/models/sport_types.dart';

part 'activity.g.dart';

/// {@template activity_item}
/// A single `activity` item.
///
/// Contains an [id], [sportType] and [map].
///
/// [Activity] are immutable and can be copied using [copyWith], in
/// addition to being serialized and deserialized using [toJson] and
/// [fromJson] respectively.
/// {@endtemplate}
@immutable
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Activity extends Equatable {
  /// {@macro activity_item}
  const Activity({
    this.id,
    this.sportType,
    this.map,
    // this.athlete,
    // this.name,
    // this.distance,
    // this.movingTime,
    // this.elapsedTime,
    // this.totalElevationGain,
    // this.elevHigh,
    // this.elevLow,
    // this.startDate,
    // this.startDateLocal,
    // this.timezone,
    // this.startLatLng,
    // this.endLatLng,
    // this.achievementCount,
    // this.photoCount,
    // this.totalPhotoCount,
    // this.workoutType,
    // this.averageSpeed,
    // this.maxSpeed,
    // this.gearId,
  });

  //@JsonKey(defaultValue: false)
  //@JsonKey(required: true)
  //@JsonKey(ignore: true)

  /// The unique identifier of the `activity`.
  final int? id;

  /// The type of sport of the `activity`.
  final SportTypes? sportType;

  /// The map of the `activity`.
  final PolyLineMap? map;
  // final MetaAthlete? athlete;
  // final String? name;
  // final double? distance;
  // final int? movingTime;
  // final int? elapsedTime;
  // final double? totalElevationGain;
  // final double? elevHigh;
  // final double? elevLow;
  // final DateTime? startDate;
  // final DateTime? startDateLocal;
  // final String? timezone;
  // // explicitly specify which methods of LatLng should be used for
  // // serialization using JsonKey annotation
  // @JsonKey(fromJson: LatLng.fromJson, toJson: jsonEncode)
  // final LatLng? startLatLng;
  // @JsonKey(fromJson: LatLng.fromJson, toJson: jsonEncode)
  // final LatLng? endLatLng;
  // final int? achievementCount;
  // final int? photoCount;
  // final int? totalPhotoCount;
  // final int? workoutType;
  // final double? averageSpeed;
  // final double? maxSpeed;
  // final String? gearId;

  /// Returns a copy of this `activity` with the given values updated.
  ///
  /// {@macro activity_item}
  Activity copyWith({
    int? id,
    SportTypes? sportType,
    PolyLineMap? map,
  }) {
    return Activity(
      id: id ?? this.id,
      sportType: sportType ?? this.sportType,
      map: map ?? this.map,
    );
  }

  /// Deserializes the given json data into an [Activity].
  static Activity fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  /// Converts this [Activity] into json data.
  Map<String, dynamic> toJson() => _$ActivityToJson(this);

  @override
  List<Object?> get props => [id, sportType];
}
