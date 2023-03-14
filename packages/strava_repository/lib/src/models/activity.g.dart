// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      id: json['id'] as int?,
      sportType: $enumDecodeNullable(_$SportTypeEnumMap, json['sport_type']),
      map: json['map'] == null ? null : PolyLineMap.fromJson(json['map']),
    );

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'id': instance.id,
      'sport_type': _$SportTypeEnumMap[instance.sportType],
      'map': instance.map?.toJson(),
    };

const _$SportTypeEnumMap = {
  SportType.undefined: 'undefined',
  SportType.alpineSki: 'alpineSki',
  SportType.backcountrySki: 'backcountrySki',
  SportType.badminton: 'badminton',
  SportType.canoeing: 'canoeing',
  SportType.crossfit: 'crossfit',
  SportType.eBikeRide: 'eBikeRide',
  SportType.elliptical: 'elliptical',
  SportType.eMountainBikeRide: 'eMountainBikeRide',
  SportType.golf: 'golf',
  SportType.gravelRide: 'gravelRide',
  SportType.handcycle: 'handcycle',
  SportType.highIntensityIntervalTraining: 'highIntensityIntervalTraining',
  SportType.hike: 'hike',
  SportType.iceSkate: 'iceSkate',
  SportType.inlineSkate: 'inlineSkate',
  SportType.kayaking: 'kayaking',
  SportType.kitesurf: 'kitesurf',
  SportType.mountainBikeRide: 'mountainBikeRide',
  SportType.nordicSki: 'nordicSki',
  SportType.pickleball: 'pickleball',
  SportType.pilates: 'pilates',
  SportType.racquetball: 'racquetball',
  SportType.ride: 'ride',
  SportType.rockClimbing: 'rockClimbing',
  SportType.rollerSki: 'rollerSki',
  SportType.rowing: 'rowing',
  SportType.run: 'run',
  SportType.sail: 'sail',
  SportType.skateboard: 'skateboard',
  SportType.snowboard: 'snowboard',
  SportType.snowshoe: 'snowshoe',
  SportType.soccer: 'soccer',
  SportType.squash: 'squash',
  SportType.stairStepper: 'stairStepper',
  SportType.standUpPaddling: 'standUpPaddling',
  SportType.surfing: 'surfing',
  SportType.swim: 'swim',
  SportType.tableTennis: 'tableTennis',
  SportType.tennis: 'tennis',
  SportType.trailRun: 'trailRun',
  SportType.velomobile: 'velomobile',
  SportType.virtualRide: 'virtualRide',
  SportType.virtualRow: 'virtualRow',
  SportType.virtualRun: 'virtualRun',
  SportType.walk: 'walk',
  SportType.weightTraining: 'weightTraining',
  SportType.wheelchair: 'wheelchair',
  SportType.windsurf: 'windsurf',
  SportType.workout: 'workout',
  SportType.yoga: 'yoga',
};
