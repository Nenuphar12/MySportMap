// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'small_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaAthlete _$MetaAthleteFromJson(Map<String, dynamic> json) => MetaAthlete(
      id: json['id'] as int?,
    );

Map<String, dynamic> _$MetaAthleteToJson(MetaAthlete instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

PolylineMap _$PolylineMapFromJson(Map<String, dynamic> json) => PolylineMap(
      id: json['id'] as String?,
      polyline: json['polyline'] as String?,
      summaryPolyline: json['summary_polyline'] as String?,
    );

Map<String, dynamic> _$PolylineMapToJson(PolylineMap instance) =>
    <String, dynamic>{
      'id': instance.id,
      'polyline': instance.polyline,
      'summary_polyline': instance.summaryPolyline,
    };

PhotosSummary _$PhotosSummaryFromJson(Map<String, dynamic> json) =>
    PhotosSummary(
      count: json['count'] as int?,
      primary: json['primary'] == null
          ? null
          : PhotosSummary_primary.fromJson(
              json['primary'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$PhotosSummaryToJson(PhotosSummary instance) =>
    <String, dynamic>{
      'count': instance.count,
      'primary': instance.primary?.toJson(),
    };

PhotosSummary_primary _$PhotosSummary_primaryFromJson(
  Map<String, dynamic> json,
) =>
    PhotosSummary_primary(
      id: json['id'] as int?,
      source: json['source'] as int?,
      uniqueId: json['unique_id'] as String?,
      urls: json['urls'] as String?,
    );

Map<String, dynamic> _$PhotosSummary_primaryToJson(
  PhotosSummary_primary instance,
) =>
    <String, dynamic>{
      'id': instance.id,
      'source': instance.source,
      'unique_id': instance.uniqueId,
      'urls': instance.urls,
    };
