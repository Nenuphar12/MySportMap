import 'package:json_annotation/json_annotation.dart';

part 'small_models.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MetaAthlete {
  const MetaAthlete({required this.id});

  final int id;

  factory MetaAthlete.fromJson(Map<String, dynamic> json) =>
      _$MetaAthleteFromJson(json);

  Map<String, dynamic> toJson() => _$MetaAthleteToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PolylineMap {
  const PolylineMap({
    required this.id,
    required this.polyline,
    this.summaryPolyline,
  });

  final int id;
  final String polyline;
  final String? summaryPolyline;

  factory PolylineMap.fromJson(Map<String, dynamic> json) =>
      _$PolylineMapFromJson(json);

  Map<String, dynamic> toJson() => _$PolylineMapToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PhotosSummary {
  const PhotosSummary({
    required this.count,
    required this.primary,
  });

  final int count;
  final PhotosSummary_primary primary;

  factory PhotosSummary.fromJson(Map<String, dynamic> json) =>
      _$PhotosSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$PhotosSummaryToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PhotosSummary_primary {
  const PhotosSummary_primary({
    required this.id,
    required this.source,
    required this.uniqueId,
    required this.urls,
  });

  final int id;
  final int source;
  final String uniqueId;
  final String urls;

  factory PhotosSummary_primary.fromJson(Map<String, dynamic> json) =>
      _$PhotosSummary_primaryFromJson(json);

  Map<String, dynamic> toJson() => _$PhotosSummary_primaryToJson(this);
}
