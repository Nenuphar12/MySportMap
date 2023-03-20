import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sport_map/home/home.dart';
import 'package:my_sport_map/l10n/l10n.dart';
import 'package:my_sport_map/splash/splash.dart';
import 'package:my_sport_map/utilities/utilities.dart';
import 'package:strava_repository/strava_repository.dart';

/// {@template my_sport_map_app}
/// A [StatefulWidget] which constructs a [MaterialApp] with a splash screen to
/// [SplashPage] and a home to [HomePage].
/// {endtemplate}
///
/// Note: `app.dart` is split into two parts [MySportMapApp] and [AppView].
/// [MySportMapApp] is responsible for creating/providing the [StravaRepository]
/// (AuthenticationBloc) which will be consumed by the [AppView]. This
/// decoupling will enable us to easily test both the [MySportMapApp] and
/// [AppView] widgets later on.
class MySportMapApp extends StatefulWidget {
  const MySportMapApp({
    required this.clientId,
    required this.secret,
    super.key,
  });

  final String clientId;
  final String secret;

  @override
  State<MySportMapApp> createState() => _MySportMapAppState();
}

class _MySportMapAppState extends State<MySportMapApp> {
  late final StravaRepository stravaRepository;
  @override
  void initState() {
    super.initState();
    stravaRepository =
        StravaRepository(secret: widget.secret, clientId: widget.clientId);
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: stravaRepository,
      child: BlocProvider(
        create: (_) => ClientCubit(stravaRepository: stravaRepository),
        child: const AppView(),
      ),
      // child: const AppView(),
    );
  }
}

/// Note:
/// [AppView] is a [StatefulWidget] because it maintains a [GlobalKey] which is
/// used to access the [NavigatorState]. By default, [AppView] will render the
/// [SplashPage] (nope : and it uses [BlocListener] to navigate to different
/// pages based on changes in the [ClientState] (AuthenticationState).)
class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get navigator => navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    logger.v('[build] Build MaterialApp...');
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorKey: navigatorKey,
      title: 'My sport map',
      // home: const HomePage(),

      builder: (context, child) {
        logger.v('Next build');
        return BlocListener<ClientCubit, ClientState>(
          listenWhen: (previous, current) {
            // Only listen once when the app starts
            return previous == const ClientState();
          },
          listener: (context, state) {
            logger.v('[state] $state');
            switch (state.status) {
              case ClientStatus.ready:
                logger.v('case ready');
                navigator.pushAndRemoveUntil<void>(
                  HomePage.route(),
                  (route) => false,
                );
                break;
              case ClientStatus.notAuthorized:
                logger.v('case notAuthorized');
                navigator.pushAndRemoveUntil<void>(
                  // Could be a login page
                  // LoginPage.route(),
                  HomePage.route(),
                  (route) => false,
                );
                break;
              case ClientStatus.appStarting:
                logger.v('case appStarting');
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) {
        logger.v('[onGenerateRoute]');
        return SplashPage.route();
      },
    );
  }
}
