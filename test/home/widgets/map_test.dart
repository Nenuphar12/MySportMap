import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_sport_map/home/widgets/map.dart';
import 'package:strava_repository/strava_repository.dart';

import '../../helpers/helpers.dart';

final List<Polyline> testPolylines = [
  Polyline(points: const [LatLng(43.56, 5), LatLng(43.57, 5.01)]),
];

void main() {
  group('MyMap', () {
    late StravaRepository stravaRepository;

    setUp(() {
      stravaRepository = MockStravaRepository();
      when(
        () => stravaRepository.getAllPolylines(),
      ).thenAnswer((_) => Future.value(testPolylines));
    });

    group('constructor', () {
      test('works properly', () {
        expect(() => const MyMap(isClientReady: false), returnsNormally);
      });
    });

    group('map', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(const MyMap(isClientReady: false));

        expect(find.byType(FlutterMap), findsOneWidget);
        expect(find.byType(TileLayer), findsOneWidget);
        expect(find.byType(CurrentLocationLayer), findsOneWidget);
      });

      testWidgets('does not request polylines when client is not ready', (
        tester,
      ) async {
        await tester.pumpApp(
          const MyMap(isClientReady: false),
          stravaRepository: stravaRepository,
        );

        verifyNever(() => stravaRepository.getAllPolylines());
      });

      testWidgets('sets the polylines', (tester) async {
        await tester.pumpApp(
          const MyMap(isClientReady: true),
          stravaRepository: stravaRepository,
        );

        verify(() => stravaRepository.getAllPolylines()).called(1);

        await tester.pump();

        final layer = tester.widget<PolylineLayer>(find.byType(PolylineLayer));
        expect(layer.polylines, equals(testPolylines));
      });
    });
  });
}
