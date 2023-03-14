import 'package:json_annotation/json_annotation.dart';

part 'small_models.g.dart';

/// {@template polyline_map}
/// A `polylineMap` item.
///
/// Contains an [id], [polyline] and [summaryPolyline].
///
/// [PolylineMap]s are immutable and can be serialized and deserialized
/// using [toJson] and [fromJson] respectively.
/// {@endtemplate}
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PolylineMap {
  /// {@macro polyline_map}
  const PolylineMap({
    this.id,
    this.polyline,
    this.summaryPolyline,
  });

  /// The unique identifier of the `polylineMap`.
  final String? id;

  /// The polyline of the `polylineMap`.
  ///
  /// Encoded as a string using this algorithm :
  /// https://developers.google.com/maps/documentation/utilities/polylinealgorithm
  ///
  /// Can be decoded using the `polyline_utility.dart` file.
  final String? polyline;

  /// The summary polyline of the `polylineMap`.
  ///
  /// Encoded as a string using this algorithm :
  /// https://developers.google.com/maps/documentation/utilities/polylinealgorithm
  ///
  /// Can be decoded using the `polyline_utility.dart` file.
  final String? summaryPolyline;

  /// Deserializes the given json data into an [PolylineMap].
  static PolylineMap fromJson(Map<String, dynamic> json) =>
      _$PolylineMapFromJson(json);

  /// Converts this [PolylineMap] into json data.
  Map<String, dynamic> toJson() => _$PolylineMapToJson(this);
}

// /// {@template meta_athlete_item}
// /// A single `metaAthlete` item.
// ///
// /// Contains an [id].
// ///
// /// [MetaAthlete]s are immutable and can be serialized and deserialized
// /// using [toJson] and [fromJson] respectively.
// /// {@endtemplate}
// @immutable
// @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
// class MetaAthlete {
//   /// {@macro meta_athlete_item}
//   const MetaAthlete({required this.id});

//   /// The unique identifier of the `metaAthlete`.
//   final int id;

//   /// Deserializes the given json data into a [MetaAthlete].
//   static MetaAthlete fromJson(Map<String, dynamic> json) =>
//       _$MetaAthleteFromJson(json);

//   /// Converts this [MetaAthlete] into json data.
//   Map<String, dynamic> toJson() => _$MetaAthleteToJson(this);
// }

// @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
// class PhotosSummary {
//   const PhotosSummary({
//     this.count,
//     this.primary,
//   });

//   factory PhotosSummary.fromJson(Map<String, dynamic> json) =>
//       _$PhotosSummaryFromJson(json);

//   final int? count;
//   final PhotosSummary_primary? primary;

//   Map<String, dynamic> toJson() => _$PhotosSummaryToJson(this);
// }

// @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
// class PhotosSummary_primary {
//   const PhotosSummary_primary({
//     this.id,
//     this.source,
//     this.uniqueId,
//     this.urls,
//   });

//   factory PhotosSummary_primary.fromJson(Map<String, dynamic> json) =>
//       _$PhotosSummary_primaryFromJson(json);

//   final int? id;
//   final int? source;
//   final String? uniqueId;
//   final String? urls;

//   Map<String, dynamic> toJson() => _$PhotosSummary_primaryToJson(this);
// }
