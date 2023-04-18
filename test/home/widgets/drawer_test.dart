import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_sport_map/home/cubit/client_cubit.dart';
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
      when(() => stravaRepository.authenticate())
          .thenAnswer((_) => Future.value());
      when(() => stravaRepository.deAuthorize())
          .thenAnswer((_) => Future.value());

      clientCubit = MockClientCubit();
    });

    Widget buildSubject({required bool isLoggedIn}) {
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

          final loggedInListTile =
              tester.widget<ListTile>(find.byKey(loggedInListTileKey));

          expect((loggedInListTile.leading! as Icon).icon, Icons.toggle_on);
          expect((loggedInListTile.leading! as Icon).color, Colors.green);
          expect((loggedInListTile.title! as Text).data, 'Logout of Strava');
        });

        testWidgets('De authorize (logout) when tile is tapped',
            (tester) async {
          await tester.pumpApp(
            buildSubject(isLoggedIn: true),
            stravaRepository: stravaRepository,
          );
          await tester.tap(find.byKey(loggedInListTileKey));
          await tester.pumpAndSettle();

          verify(() => stravaRepository.deAuthorize()).called(1);
          verify(() => clientCubit.setClientStatus(ClientStatus.notAuthorized))
              .called(1);
        });
      });

      group('when not logged in', () {
        const notLoggedInListTileKey =
            Key('authManagement_notLoggedIn_ListTile');

        testWidgets('tile is correctly rendered', (tester) async {
          await tester.pumpApp(buildSubject(isLoggedIn: false));

          expect(find.byKey(notLoggedInListTileKey), findsOneWidget);

          final notLoggedInListTile =
              tester.widget<ListTile>(find.byKey(notLoggedInListTileKey));

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
          verify(() => clientCubit.setClientStatus(ClientStatus.ready))
              .called(1);
        });
      });
    });
  });
}
