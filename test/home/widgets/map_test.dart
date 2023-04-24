import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_sport_map/home/cubit/client_cubit.dart';
import 'package:my_sport_map/home/errors/errors.dart';
import 'package:my_sport_map/home/helpers/geolocator_helper.dart';
import 'package:my_sport_map/home/widgets/my_flutter_map.dart';
import 'package:strava_repository/strava_repository.dart';

import '../../helpers/helpers.dart';

class MockClientCubit extends MockCubit<ClientState> implements ClientCubit {}

class MockGeolocatorHelper extends Mock implements GeolocatorHelper {}

// TODO(nenuphar): add points
final Set<Polyline> testPolylines = {
  const Polyline(polylineId: PolylineId('test_polyline_1'))
};

void main() {
  group('MyMap', () {
    late StravaRepository stravaRepository;

    setUp(() {
      stravaRepository = MockStravaRepository();
      when(() => stravaRepository.getAllPolylinesFM()).thenAnswer(
        (_) => Future<Set<Polyline>>.value(
          testPolylines,
        ),
      );
    });

    group('constructor', () {
      test('works properly', () {
        expect(() => const MyFlutterMap(isClientReady: false), returnsNormally);
      });
    });

    group('map', () {
      late GeolocatorHelper geolocatorHelper;

      setUp(() => geolocatorHelper = MockGeolocatorHelper());

      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(const MyFlutterMap(isClientReady: false));

        expect(find.byType(GoogleMap), findsOneWidget);
      });

      testWidgets('sets the polylines', (tester) async {
        await tester.pumpApp(
          const MyFlutterMap(isClientReady: true),
          stravaRepository: stravaRepository,
        );

        verify(() => stravaRepository.getAllPolylinesFM()).called(1);

        await tester.pumpAndSettle();

        final map = tester.widget<GoogleMap>(find.byType(GoogleMap));
        expect(map.polylines, equals(testPolylines));
      });

      // TODO(nenuphar): How to test map ?
      // Cannot test the positioning of the map, because the map is never
      // displayed, thus `onCreateMap` is never called...
      // group('with position', () {
      //   // Mock position of the current user.
      //   const position = LatLng(44, 5);

      //   setUp(() {
      //     when(() => geolocatorHelper.determinePosition()).thenAnswer(
      //       (_) => Future<Position>.value(
      //         Position(
      //           longitude: position.longitude,
      //           latitude: position.latitude,
      //           timestamp: null,
      //           accuracy: 0,
      //           altitude: 120,
      //           heading: 0,
      //           speed: 0,
      //           speedAccuracy: 0,
      //         ),
      //       ),
      //     );
      //   });

      //   testWidgets('centers on the current position', (tester) async {
      //     await tester.pumpApp(
      //       MyMap(
      //         isClientReady: true,
      //         geolocatorHelper: geolocatorHelper,
      //       ),
      //       stravaRepository: stravaRepository,
      //     );

      //     verify(() => geolocatorHelper.determinePosition()).called(1);

      //     await tester.pumpAndSettle(
      //       const Duration(milliseconds: 5000),
      //     ); // useful ?

      //     final myMap = tester.state<MyMapState>(find.byType(MyMap));
      //     final googleMap = tester.widget<GoogleMap>(find.byType(GoogleMap));
      //     googleMap.onMapCreated!.call(controller);
      //     // map.
      //     expect(myMap.centerOfMap, equals(position));
      //     // myMap.controller.future
      //     //     .then((value) => (value.getVisibleRegion()).center);
      //   });
      // });

      group('without location service enabled', () {
        setUp(() {
          when(() => geolocatorHelper.determinePosition()).thenAnswer(
            (_) => Future.error(const LocationServiceDisabledException()),
          );
        });

        testWidgets('checks for location and displays informative SnackBar',
            (tester) async {
          await tester.pumpApp(
            MyFlutterMap(
              isClientReady: true,
              geolocatorHelper: geolocatorHelper,
            ),
            stravaRepository: stravaRepository,
          );

          verify(() => geolocatorHelper.determinePosition()).called(1);

          await tester.pumpAndSettle();

          expect(find.byType(SnackBar), findsOneWidget);
          expect(
            find.descendant(
              of: find.byType(SnackBar),
              matching: find
                  .text(const LocationServiceDisabledException().toString()),
            ),
            findsOneWidget,
          );
        });
      });

      group('with location service denied', () {
        setUp(() {
          when(() => geolocatorHelper.determinePosition()).thenAnswer(
            (_) => Future.error(const PermissionDeniedException()),
          );
        });

        testWidgets(
            'checks for location permissions'
            ' and displays informative SnackBar', (tester) async {
          await tester.pumpApp(
            MyFlutterMap(
              isClientReady: true,
              geolocatorHelper: geolocatorHelper,
            ),
            stravaRepository: stravaRepository,
          );

          verify(() => geolocatorHelper.determinePosition()).called(1);

          await tester.pumpAndSettle();

          expect(find.byType(SnackBar), findsOneWidget);
          expect(
            find.descendant(
              of: find.byType(SnackBar),
              matching: find.text(const PermissionDeniedException().toString()),
            ),
            findsOneWidget,
          );
        });
      });

      group('with location service permanently denied', () {
        setUp(() {
          when(() => geolocatorHelper.determinePosition()).thenAnswer(
            (_) => Future.error(const PermissionDeniedForeverException()),
          );
        });

        testWidgets(
            'checks for location permissions'
            ' and displays informative SnackBar', (tester) async {
          await tester.pumpApp(
            MyFlutterMap(
              isClientReady: true,
              geolocatorHelper: geolocatorHelper,
            ),
            stravaRepository: stravaRepository,
          );

          verify(() => geolocatorHelper.determinePosition()).called(1);

          await tester.pumpAndSettle();

          expect(find.byType(SnackBar), findsOneWidget);
          expect(
            find.descendant(
              of: find.byType(SnackBar),
              matching: find
                  .text(const PermissionDeniedForeverException().toString()),
            ),
            findsOneWidget,
          );
        });
      });
    });
  });
}
