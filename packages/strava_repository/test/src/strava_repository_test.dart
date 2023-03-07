// ignore_for_file: prefer_const_constructors
import 'package:strava_repository/strava_repository.dart';
import 'package:test/test.dart';

void main() {
  group('StravaRepository', () {
    test('can be instantiated', () {
      expect(
        StravaRepository(clientId: 'client_id', secret: 'secret'),
        isNotNull,
      );
    });
  });
}
