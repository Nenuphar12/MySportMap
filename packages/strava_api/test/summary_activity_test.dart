import 'package:strava_api/strava_api.dart';
import 'package:test/test.dart';

// TODO : useless because of json_serialize ?

void main() {
  group('SummaryActivity', () {
    group('fromJson', () {
      test('returns correct SummaryActivity object', () {
        expect(
            SummaryActivity.fromJson(<String, dynamic>{
              //'id': 154504250376823,
              //'external_id': 'garmin_push_12345678987654321',
              "name": "Happy Friday",
              "distance": 24931.4,
              "moving_time": 4500,
              "elapsed_time": 4500,
              "total_elevation_gain": 0,
              "type": "Ride",
              "sport_type": "MountainBikeRide",
              "workout_type": null,
              "id": BigInt.parse('154504250376823'),
              "external_id": "garmin_push_12345678987654321",
              "upload_id": BigInt.parse('987654321234567891234'),
              "start_date": "2018-05-02T12:15:09Z",
              "start_date_local": "2018-05-02T05:15:09Z",
              "timezone": "(GMT-08:00) America/Los_Angeles",
              "utc_offset": -25200,
              "start_latlng": null,
              "end_latlng": null,
              "location_city": null,
              "location_state": null,
              "location_country": "United States",
              "achievement_count": 0,
              "kudos_count": 3,
              "comment_count": 1,
              "athlete_count": 1,
              "photo_count": 0,
              "map": {
                "id": "a12345678987654321",
                "summary_polyline": null,
                "resource_state": 2
              },
              "trainer": true,
              "commute": false,
              "manual": false,
              "private": false,
              "flagged": false,
              "gear_id": "b12345678987654321",
              "from_accepted_tag": false,
              "average_speed": 5.54,
              "max_speed": 11,
              "average_cadence": 67.1,
              "average_watts": 175.3,
              "weighted_average_watts": 210,
              "kilojoules": 788.7,
              "device_watts": true,
              "has_heartrate": true,
              "average_heartrate": 140.3,
              "max_heartrate": 178,
              "max_watts": 406,
              "pr_count": 0,
              "total_photo_count": 1,
              "has_kudoed": false,
              "suffer_score": 82,
            }),
            isA<SummaryActivity>()
                .having((p0) => p0.name, 'name', 'Happy Friday')
                .having((p0) => p0.distance, 'distance', 24931.4)
                .having((p0) => p0.movingTime, 'moving_time', 4500)
                .having((p0) => p0.elapsedTime, 'elapsed_time', 4500)
                .having(
                    (p0) => p0.totalElevationGain, 'total_elevation_gain', 0)
                //.having((p0) => p0.type, description, matcher)
                .having((p0) => p0.sportType, 'sport_type',
                    SportType.MountainBikeRide)
                .having((p0) => p0.workoutType, 'workout_type', null)
                .having((p0) => p0.id, 'id', BigInt.parse('154504250376823'))
                .having((p0) => p0.externalId, 'external_id',
                    'garmin_push_12345678987654321')
                .having((p0) => p0.uploadId, 'upload_id',
                    BigInt.parse('987654321234567891234'))
                .having(
                    (p0) => p0.startDate, 'start_date', '2018-05-02T12:15:09Z')
                .having((p0) => p0.startDateLocal, 'start_date_local',
                    '2018-05-02T05:15:09Z')
                .having((p0) => p0.timezone, 'timezone',
                    '(GMT-08:00) America/Los_Angeles')
                //.having((p0) => p0.utcOffset, description, matcher)
                .having((p0) => p0.startLatLng, 'start_latlng', null)
                .having((p0) => p0.endLatLng, 'end_latlng', null)
                //.having((p0) => p0.locationCity, description, matcher)
                //.having((p0) => p0.locationState, description, matcher)
                //.having((p0) => p0.locationCountry, description, matcher)
                .having((p0) => p0.achievementCount, 'achievement_count', 0)
                .having((p0) => p0.kudosCount, 'kudos_count', 3)
                .having((p0) => p0.commentCount, 'comment_count', 1)
                .having((p0) => p0.athleteCount, 'athlete_count', 1)
                .having((p0) => p0.photoCount, 'photo_count', 0)
                .having((p0) => p0.map, 'map',
                    const PolylineMap(id: 'a12345678987654321', polyline: null))
                .having((p0) => p0.trainer, 'trainer', true)
                .having((p0) => p0.commute, 'commute', false)
                .having((p0) => p0.manual, 'manual', false)
                .having((p0) => p0.private, 'private', false)
                .having((p0) => p0.flagged, 'flagged', false)
                .having((p0) => p0.gearId, 'gear_id', 'b12345678987654321')
                //.having((p0) => p0.fromAcceptedTag, description, matcher)
                .having((p0) => p0.averageSpeed, 'average_speed', 5.54)
                .having((p0) => p0.maxSpeed, 'max_speed', 11)
                //.having((p0) => p0.averageCadence, description, matcher)
                .having((p0) => p0.averageWatts, 'average_watts', 175.3)
                .having((p0) => p0.weightedAverageWatts,
                    'weighted_average_watts', 210)
                .having((p0) => p0.kilojoules, 'kilojoules', 788.7)
                .having((p0) => p0.deviceWatts, 'device_watts', true)
                // Important ones ?
                //.having((p0) => p0.hasHeartrate, description, matcher)
                //.having((p0) => p0.averageHeartrate, description, matcher)
                //.having((p0) => p0.maxHeartrate, description, matcher)
                .having((p0) => p0.maxWatts, 'max_watts', 406)
                //.having((p0) => p0.prCount, description, matcher)
                .having((p0) => p0.totalPhotoCount, 'total_photo_count', 1)
                .having((p0) => p0.hasKudoed, 'has_kudoed', false)
            //.having((p0) => p0.sufferScore, description, matcher)
            );
      });
    });
  });
}
