// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      id: json['id'] as int?,
      athlete: json['athlete'] == null
          ? null
          : MetaAthlete.fromJson(json['athlete'] as Map<String, dynamic>),
      name: json['name'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
      movingTime: json['moving_time'] as int?,
      elapsedTime: json['elapsed_time'] as int?,
      totalElevationGain: (json['total_elevation_gain'] as num?)?.toDouble(),
      elevHigh: (json['elev_high'] as num?)?.toDouble(),
      elevLow: (json['elev_low'] as num?)?.toDouble(),
      sportType: $enumDecodeNullable(_$SportTypeEnumMap, json['sport_type']),
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      startDateLocal: json['start_date_local'] == null
          ? null
          : DateTime.parse(json['start_date_local'] as String),
      timezone: json['timezone'] as String?,
      startLatLng: LatLng.fromJson(json['start_lat_lng']),
      endLatLng: LatLng.fromJson(json['end_lat_lng']),
      achievementCount: json['achievement_count'] as int?,
      photoCount: json['photo_count'] as int?,
      totalPhotoCount: json['total_photo_count'] as int?,
      map: json['map'] == null
          ? null
          : PolylineMap.fromJson(json['map'] as Map<String, dynamic>),
      workoutType: json['workout_type'] as int?,
      averageSpeed: (json['average_speed'] as num?)?.toDouble(),
      maxSpeed: (json['max_speed'] as num?)?.toDouble(),
      gearId: json['gear_id'] as String?,
    );

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'id': instance.id,
      'athlete': instance.athlete?.toJson(),
      'name': instance.name,
      'distance': instance.distance,
      'moving_time': instance.movingTime,
      'elapsed_time': instance.elapsedTime,
      'total_elevation_gain': instance.totalElevationGain,
      'elev_high': instance.elevHigh,
      'elev_low': instance.elevLow,
      'sport_type': _$SportTypeEnumMap[instance.sportType],
      'start_date': instance.startDate?.toIso8601String(),
      'start_date_local': instance.startDateLocal?.toIso8601String(),
      'timezone': instance.timezone,
      'start_lat_lng': jsonEncode(instance.startLatLng),
      'end_lat_lng': jsonEncode(instance.endLatLng),
      'achievement_count': instance.achievementCount,
      'photo_count': instance.photoCount,
      'total_photo_count': instance.totalPhotoCount,
      'map': instance.map?.toJson(),
      'workout_type': instance.workoutType,
      'average_speed': instance.averageSpeed,
      'max_speed': instance.maxSpeed,
      'gear_id': instance.gearId,
    };

const _$SportTypeEnumMap = {
  SportType.Undefined: 'Undefined',
  SportType.AlpineSki: 'AlpineSki',
  SportType.BackcountrySki: 'BackcountrySki',
  SportType.Badminton: 'Badminton',
  SportType.Canoeing: 'Canoeing',
  SportType.Crossfit: 'Crossfit',
  SportType.EBikeRide: 'EBikeRide',
  SportType.Elliptical: 'Elliptical',
  SportType.EMountainBikeRide: 'EMountainBikeRide',
  SportType.Golf: 'Golf',
  SportType.GravelRide: 'GravelRide',
  SportType.Handcycle: 'Handcycle',
  SportType.HighIntensityIntervalTraining: 'HighIntensityIntervalTraining',
  SportType.Hike: 'Hike',
  SportType.IceSkate: 'IceSkate',
  SportType.InlineSkate: 'InlineSkate',
  SportType.Kayaking: 'Kayaking',
  SportType.Kitesurf: 'Kitesurf',
  SportType.MountainBikeRide: 'MountainBikeRide',
  SportType.NordicSki: 'NordicSki',
  SportType.Pickleball: 'Pickleball',
  SportType.Pilates: 'Pilates',
  SportType.Racquetball: 'Racquetball',
  SportType.Ride: 'Ride',
  SportType.RockClimbing: 'RockClimbing',
  SportType.RollerSki: 'RollerSki',
  SportType.Rowing: 'Rowing',
  SportType.Run: 'Run',
  SportType.Sail: 'Sail',
  SportType.Skateboard: 'Skateboard',
  SportType.Snowboard: 'Snowboard',
  SportType.Snowshoe: 'Snowshoe',
  SportType.Soccer: 'Soccer',
  SportType.Squash: 'Squash',
  SportType.StairStepper: 'StairStepper',
  SportType.StandUpPaddling: 'StandUpPaddling',
  SportType.Surfing: 'Surfing',
  SportType.Swim: 'Swim',
  SportType.TableTennis: 'TableTennis',
  SportType.Tennis: 'Tennis',
  SportType.TrailRun: 'TrailRun',
  SportType.Velomobile: 'Velomobile',
  SportType.VirtualRide: 'VirtualRide',
  SportType.VirtualRow: 'VirtualRow',
  SportType.VirtualRun: 'VirtualRun',
  SportType.Walk: 'Walk',
  SportType.WeightTraining: 'WeightTraining',
  SportType.Wheelchair: 'Wheelchair',
  SportType.Windsurf: 'Windsurf',
  SportType.Workout: 'Workout',
  SportType.Yoga: 'Yoga',
};
