// TODO(nenuphar): Document this...
// ignore_for_file: public_member_api_docs, camel_case_types

import 'package:json_annotation/json_annotation.dart';

part 'small_models.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MetaAthlete {
  const MetaAthlete({this.id});

  factory MetaAthlete.fromJson(Map<String, dynamic> json) =>
      _$MetaAthleteFromJson(json);

  final int? id;

  Map<String, dynamic> toJson() => _$MetaAthleteToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PolylineMap {
  const PolylineMap({
    this.id,
    this.polyline,
    this.summaryPolyline,
  });
  factory PolylineMap.fromJson(Map<String, dynamic> json) =>
      _$PolylineMapFromJson(json);

  final String? id;
  final String? polyline;
  final String? summaryPolyline;

  Map<String, dynamic> toJson() => _$PolylineMapToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PhotosSummary {
  const PhotosSummary({
    this.count,
    this.primary,
  });

  factory PhotosSummary.fromJson(Map<String, dynamic> json) =>
      _$PhotosSummaryFromJson(json);

  final int? count;
  final PhotosSummary_primary? primary;

  Map<String, dynamic> toJson() => _$PhotosSummaryToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PhotosSummary_primary {
  const PhotosSummary_primary({
    this.id,
    this.source,
    this.uniqueId,
    this.urls,
  });

  factory PhotosSummary_primary.fromJson(Map<String, dynamic> json) =>
      _$PhotosSummary_primaryFromJson(json);

  final int? id;
  final int? source;
  final String? uniqueId;
  final String? urls;

  Map<String, dynamic> toJson() => _$PhotosSummary_primaryToJson(this);
}
