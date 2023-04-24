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
  SportTypes.undefined: 'undefined',
  SportTypes.alpineSki: 'alpineSki',
  SportTypes.backcountrySki: 'backcountrySki',
  SportTypes.badminton: 'badminton',
  SportTypes.canoeing: 'canoeing',
  SportTypes.crossfit: 'crossfit',
  SportTypes.eBikeRide: 'eBikeRide',
  SportTypes.elliptical: 'elliptical',
  SportTypes.eMountainBikeRide: 'eMountainBikeRide',
  SportTypes.golf: 'golf',
  SportTypes.gravelRide: 'gravelRide',
  SportTypes.handcycle: 'handcycle',
  SportTypes.highIntensityIntervalTraining: 'highIntensityIntervalTraining',
  SportTypes.hike: 'hike',
  SportTypes.iceSkate: 'iceSkate',
  SportTypes.inlineSkate: 'inlineSkate',
  SportTypes.kayaking: 'kayaking',
  SportTypes.kitesurf: 'kitesurf',
  SportTypes.mountainBikeRide: 'mountainBikeRide',
  SportTypes.nordicSki: 'nordicSki',
  SportTypes.pickleball: 'pickleball',
  SportTypes.pilates: 'pilates',
  SportTypes.racquetball: 'racquetball',
  SportTypes.ride: 'ride',
  SportTypes.rockClimbing: 'rockClimbing',
  SportTypes.rollerSki: 'rollerSki',
  SportTypes.rowing: 'rowing',
  SportTypes.run: 'run',
  SportTypes.sail: 'sail',
  SportTypes.skateboard: 'skateboard',
  SportTypes.snowboard: 'snowboard',
  SportTypes.snowshoe: 'snowshoe',
  SportTypes.soccer: 'soccer',
  SportTypes.squash: 'squash',
  SportTypes.stairStepper: 'stairStepper',
  SportTypes.standUpPaddling: 'standUpPaddling',
  SportTypes.surfing: 'surfing',
  SportTypes.swim: 'swim',
  SportTypes.tableTennis: 'tableTennis',
  SportTypes.tennis: 'tennis',
  SportTypes.trailRun: 'trailRun',
  SportTypes.velomobile: 'velomobile',
  SportTypes.virtualRide: 'virtualRide',
  SportTypes.virtualRow: 'virtualRow',
  SportTypes.virtualRun: 'virtualRun',
  SportTypes.walk: 'walk',
  SportTypes.weightTraining: 'weightTraining',
  SportTypes.wheelchair: 'wheelchair',
  SportTypes.windsurf: 'windsurf',
  SportTypes.workout: 'workout',
  SportTypes.yoga: 'yoga',
};
