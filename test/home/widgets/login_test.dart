import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_sport_map/home/cubit/client_cubit.dart';
import 'package:my_sport_map/home/widgets/auth_management_buttons.dart';
import 'package:strava_repository/strava_repository.dart';

import '../../helpers/helpers.dart';

class MockClientCubit extends MockCubit<ClientState> implements ClientCubit {}

void main() {
  group('AuthManagementButtons', () {
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

    Widget buildSubject() {
      return BlocProvider.value(
        value: clientCubit,
        child: const AuthManagementButtons(),
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(() => const AuthManagementButtons(), returnsNormally);
      });
    });

    group('internal LoginButton', () {
      const loginElevatedButtonKey = Key('loginButton_login_elevatedButton');

      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(
          find.byType(LoginButton),
          findsOneWidget,
        );
      });

      testWidgets(
        'login if user not already logged in when login button is pressed',
        (tester) async {
          when(() => clientCubit.state).thenReturn(
            const ClientState(status: ClientStatus.notAuthorized),
          );
          await tester.pumpApp(
            buildSubject(),
            stravaRepository: stravaRepository,
          );

          await tester.tap(find.byKey(loginElevatedButtonKey));
          await tester.pumpAndSettle();

          verify(() => stravaRepository.authenticate()).called(1);
          verify(() => clientCubit.setClientStatus(ClientStatus.ready))
              .called(1);
        },
      );

      testWidgets(
        'renders snackbar if already logged in when login button is pressed',
        (tester) async {
          when(() => clientCubit.state)
              .thenReturn(const ClientState(status: ClientStatus.ready));
          await tester.pumpApp(
            buildSubject(),
            stravaRepository: stravaRepository,
          );

          await tester.tap(find.byKey(loginElevatedButtonKey));
          await tester.pumpAndSettle();

          expect(find.byType(SnackBar), findsOneWidget);
          expect(
            find.descendant(
              of: find.byType(SnackBar),
              matching: find.text('You are already logged in.'),
            ),
            findsOneWidget,
          );
        },
      );
    });

    group('internal DeAuthButton', () {
      const deAuthElevatedButtonKey = Key('deAuthButton_deAuth_elevatedButton');

      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(
          find.byType(DeAuthButton),
          findsOneWidget,
        );
      });

      testWidgets(
        'de authorize if user is logged in when de authorize button is pressed',
        (tester) async {
          when(() => clientCubit.state).thenReturn(
            const ClientState(status: ClientStatus.ready),
          );
          await tester.pumpApp(
            buildSubject(),
            stravaRepository: stravaRepository,
          );

          await tester.tap(find.byKey(deAuthElevatedButtonKey));
          await tester.pumpAndSettle();

          verify(() => stravaRepository.deAuthorize()).called(1);
          verify(() => clientCubit.setClientStatus(ClientStatus.notAuthorized))
              .called(1);
        },
      );

      testWidgets(
        'renders snackbar if already not authorized when de authorize button '
        'is pressed',
        (tester) async {
          when(() => clientCubit.state).thenReturn(
            const ClientState(status: ClientStatus.notAuthorized),
          );
          await tester.pumpApp(
            buildSubject(),
            stravaRepository: stravaRepository,
          );

          await tester.tap(find.byKey(deAuthElevatedButtonKey));
          await tester.pumpAndSettle();

          expect(find.byType(SnackBar), findsOneWidget);
          expect(
            find.descendant(
              of: find.byType(SnackBar),
              matching: find.text('You need to login first.'),
            ),
            findsOneWidget,
          );
        },
      );
    });
  });
}
