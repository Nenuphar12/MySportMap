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

void main() {
  late StravaRepository stravaRepository;
  late ClientCubit clientCubit;
  // late NavigatorObserver navigatorObserver;

  setUp(() {
    stravaRepository = MockStravaRepository();
    // Needs to wait a little bit ? To be sure to get to the Splash Screen ?
    when(stravaRepository.isAuthenticated)
        .thenAnswer((_) => Future.value(false));

    clientCubit = MockClientCubit();
    whenListen(
      clientCubit,
      Stream.fromIterable(
        [
          const ClientState(),
          const ClientState(status: ClientStatus.notAuthorized),
        ],
      ),
      initialState: const ClientState(),
    );

    // Verify that the states of clientCubit are emitted in the right way
    // expectLater(
    //   clientCubit.stream,
    //   emitsInOrder([
    //     const ClientState(),
    //     const ClientState(status: ClientStatus.notAuthorized),
    //   ]),
    // );

    // navigatorObserver = MockNavigatorObserver();
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
      // Verify that the states of clientCubit are emitted in the right way
      // Not working at some other places, I don't know why...
      // (not working before pumpAndSettle because it makes wait and then
      // everything is already settled ?)
      await expectLater(
        clientCubit.stream,
        emitsInOrder([
          const ClientState(),
          const ClientState(status: ClientStatus.notAuthorized),
        ]),
      );

      // Wait indefinitely to stay on the SplashPage and generate only one
      // MaterialApp. (Not necessary - not used here)
      when(stravaRepository.isAuthenticated)
          .thenAnswer((_) => Future<bool>.value(false));
      // .thenAnswer((_) => Completer<bool>().future);

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: stravaRepository,
          child: BlocProvider.value(
            value: clientCubit,
            child: const AppView(),
          ),
        ),
      );

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

      expect(find.byType(SplashPage), findsOneWidget);
    });

    testWidgets('renders HomePage', (tester) async {
      await tester.pumpApp(
        const AppView(),
        stravaRepository: stravaRepository,
        clientCubit: clientCubit,
        // navigatorObserver: navigatorObserver,
      );

      // Wait for the splash screen to be removed and for HomePage
      // to be rendered
      await tester.pumpAndSettle();

      // verify(navigatorObserver.didPush(HomePage.route(), any()));

      expect(find.byType(HomePage), findsOneWidget);
    });

    // testWidgets('set cubit state properly', (tester) async {
    //   when(stravaRepository.isAuthenticated)
    //       .thenAnswer((_) => Future<bool>.value(true));

    //   await tester.pumpApp(
    //     const AppView(),
    //     stravaRepository: stravaRepository,
    //     clientCubit: clientCubit,
    //     // navigatorObserver: navigatorObserver,
    //   );

    //   expect(
    //     clientCubit.state,
    //     equals(const ClientState(status: ClientStatus.ready)),
    //   );
    // });
  });
}
