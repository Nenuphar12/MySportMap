import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:strava_api/strava_api.dart';

class MockOauth2Client extends Mock implements oauth2.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('StravaApiClient', () {
    late oauth2.Client oauth2Client;
    late StravaApiClient apiClient;

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      oauth2Client = MockOauth2Client();
      apiClient = StravaApiClient(apiClient: oauth2Client);
    });

    // TODO
    /*
    group('constructor', () {
      test('does not require an httpClient', () {
        expect(StravaApiClient(), isNotNull);
      });
    });
    */
  });
}
