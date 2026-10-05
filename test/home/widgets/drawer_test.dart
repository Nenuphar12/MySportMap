import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_sport_map/home/home.dart';
import 'package:my_sport_map/home/widgets/widgets.dart';
import 'package:strava_repository/strava_repository.dart';

import '../../helpers/helpers.dart';

class MockClientCubit extends MockCubit<ClientState> implements ClientCubit {}

void main() {
  group('HomePageDrawer', () {
    late StravaRepository stravaRepository;
    late ClientCubit clientCubit;

    setUp(() {
      stravaRepository = MockStravaRepository();
      when(
        () => stravaRepository.authenticate(),
      ).thenAnswer((_) => Future.value());
      when(
        () => stravaRepository.deAuthorize(),
      ).thenAnswer((_) => Future.value());

      clientCubit = MockClientCubit();
    });

    Widget buildSubject({
      required bool isLoggedIn,
      ActivitiesCubit? activitiesCubit,
    }) {
      if (activitiesCubit != null) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: clientCubit),
            BlocProvider.value(value: activitiesCubit),
          ],
          child: HomePageDrawer(isLoggedIn: isLoggedIn),
        );
      }
      return BlocProvider.value(
        value: clientCubit,
        child: HomePageDrawer(isLoggedIn: isLoggedIn),
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(() => const HomePageDrawer(isLoggedIn: true), returnsNormally);
      });
    });

    group('internal ListView', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject(isLoggedIn: false));

        expect(
          find.byType(ListView),
          findsOneWidget,
        );
      });
    });

    group('refresh tile', () {
      const refreshListTileKey = Key('homePageDrawer_refresh_ListTile');

      testWidgets('is disabled when logged out', (tester) async {
        await tester.pumpApp(buildSubject(isLoggedIn: false));

        final tile = tester.widget<ListTile>(find.byKey(refreshListTileKey));
        expect(tile.enabled, isFalse);
      });

      testWidgets('refreshes all the activities when tapped', (tester) async {
        final activitiesCubit = MockActivitiesCubit();
        when(() => activitiesCubit.state).thenReturn(const ActivitiesState());
        when(activitiesCubit.refresh).thenAnswer((_) async {});

        await tester.pumpApp(
          Scaffold(
            drawer: buildSubject(
              isLoggedIn: true,
              activitiesCubit: activitiesCubit,
            ),
            body: const SizedBox(),
          ),
        );
        tester.state<ScaffoldState>(find.byType(Scaffold).last).openDrawer();
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(refreshListTileKey));
        await tester.pumpAndSettle();

        verify(activitiesCubit.refresh).called(1);
        expect(find.byType(HomePageDrawer), findsNothing, reason: 'closed');
      });
    });

    group('internal AuthManagementTile', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject(isLoggedIn: false));

        expect(
          find.byType(AuthManagementTile),
          findsOneWidget,
        );
      });

      group('when logged in', () {
        const loggedInListTileKey = Key('authManagement_loggedIn_ListTile');

        testWidgets('tile is correctly rendered', (tester) async {
          await tester.pumpApp(buildSubject(isLoggedIn: true));

          expect(find.byKey(loggedInListTileKey), findsOneWidget);

          final loggedInListTile = tester.widget<ListTile>(
            find.byKey(loggedInListTileKey),
          );

          expect((loggedInListTile.leading! as Icon).icon, Icons.toggle_on);
          expect((loggedInListTile.leading! as Icon).color, Colors.green);
          expect((loggedInListTile.title! as Text).data, 'Logout of Strava');
        });

        testWidgets('De authorize (logout) when tile is tapped', (
          tester,
        ) async {
          await tester.pumpApp(
            buildSubject(isLoggedIn: true),
            stravaRepository: stravaRepository,
          );
          await tester.tap(find.byKey(loggedInListTileKey));
          await tester.pumpAndSettle();

          verify(() => stravaRepository.deAuthorize()).called(1);
          verify(
            () => clientCubit.setClientStatus(ClientStatus.notAuthorized),
          ).called(1);
        });
      });

      group('when not logged in', () {
        const notLoggedInListTileKey = Key(
          'authManagement_notLoggedIn_ListTile',
        );

        testWidgets('tile is correctly rendered', (tester) async {
          await tester.pumpApp(buildSubject(isLoggedIn: false));

          expect(find.byKey(notLoggedInListTileKey), findsOneWidget);

          final notLoggedInListTile = tester.widget<ListTile>(
            find.byKey(notLoggedInListTileKey),
          );

          expect((notLoggedInListTile.leading! as Icon).icon, Icons.toggle_off);
          expect((notLoggedInListTile.leading! as Icon).color, Colors.red);
          expect(
            (notLoggedInListTile.title! as Text).data,
            'Login with Strava',
          );
        });

        testWidgets('Authorize (login) when tile is tapped', (tester) async {
          await tester.pumpApp(
            buildSubject(isLoggedIn: false),
            stravaRepository: stravaRepository,
          );
          await tester.tap(find.byKey(notLoggedInListTileKey));
          await tester.pumpAndSettle();

          verify(() => stravaRepository.authenticate()).called(1);
          verify(
            () => clientCubit.setClientStatus(ClientStatus.ready),
          ).called(1);
        });
      });
    });
  });
}
