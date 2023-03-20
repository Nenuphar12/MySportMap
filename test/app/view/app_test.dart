import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_sport_map/app/app.dart';
import 'package:my_sport_map/home/home.dart';
import 'package:my_sport_map/splash/view/splash_page.dart';
import 'package:strava_repository/strava_repository.dart';

import '../../helpers/helpers.dart';

// TODO(nenuphar): clean this file and implement more tests.

void main() {
  late StravaRepository stravaRepository;
  late ClientCubit clientCubit;

  setUp(() {
    stravaRepository = MockStravaRepository();
    when(stravaRepository.isAuthenticated)
        .thenAnswer((_) => Future.value(false));

    clientCubit = MockClientCubit();
    // TEST: necessary section
    whenListen(
      clientCubit,
      Stream.fromIterable(
        [
          const ClientState(),
          // const ClientState(status: ClientStatus.notAuthorized),
        ],
      ),
      initialState: const ClientState(),
    );
  });

  group('MySportMapApp', () {
    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        const MySportMapApp(
          clientId: 'client-id',
          secret: 'secret',
        ),
      );

      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    testWidgets('renders MaterialApp with correct themes', (tester) async {
      // TODO(nenuphar): do I use this ?
      // Wait indefinitely to stay on the SplashPage and generate only one
      // MaterialApp.
      when(stravaRepository.isAuthenticated)
          .thenAnswer((_) => Completer<bool>().future);

      // ERROR: this generates 2 MaterialApps...
      // await tester.pumpApp(
      //   const AppView(),
      //   stravaRepository: stravaRepository,
      //   clientCubit: clientCubit,
      // );
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: stravaRepository,
          child: BlocProvider.value(
            value: clientCubit,
            child: const AppView(),
          ),
        ),
      );

      // TODO(nenuphar): Test ? working ?
      // await expectLater(
      //   clientCubit.stream,
      //   emitsInOrder([
      //     const ClientState(),
      //     const ClientState(status: ClientStatus.notAuthorized),
      //   ]),
      // );

      // Finds two widgets: one for the SplashPage and then one for the HomePage
      // (after authentication status acquired).
      expect(find.byType(MaterialApp), findsOneWidget);

      final materialApp =
          tester.widget<MaterialApp>(find.byType(MaterialApp).first);
      expect(
        materialApp.theme,
        equals(
          ThemeData(
            appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
            colorScheme: ColorScheme.fromSwatch(
              accentColor: const Color(0xFF13B9FF),
            ),
          ),
        ),
      );
    });

    testWidgets('renders SplashPage', (tester) async {
      await tester.pumpApp(
        const AppView(),
        stravaRepository: stravaRepository,
        clientCubit: clientCubit,
      );
      // await tester.pumpWidget(
      //   RepositoryProvider.value(
      //     value: stravaRepository,
      //     child: const AppView(),
      //   ),
      // );

      expect(find.byType(SplashPage), findsOneWidget);
    });

    // testWidgets('renders HomePage', (tester) async {
    //   await tester.pumpApp(
    //     const AppView(),
    //     stravaRepository: stravaRepository,
    //     clientCubit: clientCubit,
    //   );

    //   await tester.pumpAndSettle();

    //   expect(find.byType(HomePage), findsOneWidget);
    // });
  });
}
