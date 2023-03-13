import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_sport_map/home/cubit/client_cubit.dart';
import 'package:my_sport_map/home/widgets/map.dart';
import 'package:strava_repository/strava_repository.dart';

import '../../helpers/helpers.dart';

class MockClientCubit extends MockCubit<ClientState> implements ClientCubit {}

// TODO(nenuphar): add points
final Set<Polyline> testPolylines = {
  const Polyline(polylineId: PolylineId('test_polyline_1'))
};

void main() {
  group('MyMap', () {
    late StravaRepository stravaRepository;

    setUp(() {
      stravaRepository = MockStravaRepository();
      when(() => stravaRepository.getAllPolylines()).thenAnswer(
        (_) => Future<Set<Polyline>>.value(
          testPolylines,
        ),
      );
    });

    group('constructor', () {
      test('works properly', () {
        expect(() => const MyMap(isClientReady: false), returnsNormally);
      });
    });

    group('map', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(const MyMap(isClientReady: false));

        expect(find.byType(GoogleMap), findsOneWidget);
      });

      testWidgets('sets the polylines', (tester) async {
        await tester.pumpApp(
          const MyMap(isClientReady: true),
          stravaRepository: stravaRepository,
        );

        verify(() => stravaRepository.getAllPolylines()).called(1);

        await tester.pumpAndSettle();

        final map = tester.widget<GoogleMap>(find.byType(GoogleMap));
        expect(map.polylines, equals(testPolylines));
      });
    });
  });
}
