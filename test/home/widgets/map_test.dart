import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_sport_map/home/home.dart';
import 'package:my_sport_map/home/widgets/map.dart';

import '../../helpers/helpers.dart';

final List<Polyline> testPolylines = [
  Polyline(points: const [LatLng(43.56, 5), LatLng(43.57, 5.01)]),
];

void main() {
  group('MyMap', () {
    late ActivitiesCubit activitiesCubit;

    const followButtonKey = Key('myMap_followUser_floatingActionButton');

    setUp(() {
      activitiesCubit = MockActivitiesCubit();
      when(() => activitiesCubit.state).thenReturn(
        ActivitiesState(
          status: ActivitiesStatus.synced,
          polylines: testPolylines,
        ),
      );
    });

    AlignOnUpdate alignPositionOnUpdate(WidgetTester tester) => tester
        .widget<CurrentLocationLayer>(find.byType(CurrentLocationLayer))
        .alignPositionOnUpdate;

    test('can be instantiated', () {
      expect(() => const MyMap(), returnsNormally);
    });

    testWidgets('renders the map layers', (tester) async {
      await tester.pumpApp(const MyMap(), activitiesCubit: activitiesCubit);

      expect(find.byType(FlutterMap), findsOneWidget);
      expect(find.byType(TileLayer), findsOneWidget);
      expect(find.byType(CurrentLocationLayer), findsOneWidget);
      expect(find.byKey(followButtonKey), findsOneWidget);
    });

    testWidgets('displays the polylines of the activities', (tester) async {
      await tester.pumpApp(const MyMap(), activitiesCubit: activitiesCubit);

      final layer = tester.widget<PolylineLayer>(find.byType(PolylineLayer));
      expect(layer.polylines, equals(testPolylines));
    });

    testWidgets('shows a progress bar while syncing', (tester) async {
      when(() => activitiesCubit.state).thenReturn(
        const ActivitiesState(status: ActivitiesStatus.syncing),
      );

      await tester.pumpApp(const MyMap(), activitiesCubit: activitiesCubit);

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('shows no progress bar once synced', (tester) async {
      await tester.pumpApp(const MyMap(), activitiesCubit: activitiesCubit);

      expect(find.byType(LinearProgressIndicator), findsNothing);
    });

    group('follow button', () {
      testWidgets('centers the map on the first position only by default', (
        tester,
      ) async {
        await tester.pumpApp(const MyMap(), activitiesCubit: activitiesCubit);

        expect(alignPositionOnUpdate(tester), AlignOnUpdate.once);
      });

      testWidgets('follows the user when tapped', (tester) async {
        await tester.pumpApp(const MyMap(), activitiesCubit: activitiesCubit);

        await tester.tap(find.byKey(followButtonKey));
        await tester.pump();

        expect(alignPositionOnUpdate(tester), AlignOnUpdate.always);
      });

      testWidgets('stops following when the user moves the map', (
        tester,
      ) async {
        await tester.pumpApp(const MyMap(), activitiesCubit: activitiesCubit);
        await tester.tap(find.byKey(followButtonKey));
        await tester.pump();

        await tester.drag(find.byType(FlutterMap), const Offset(-200, 0));
        await tester.pump();

        expect(alignPositionOnUpdate(tester), AlignOnUpdate.never);
      });
    });
  });
}
