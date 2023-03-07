import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sport_map/home/home.dart';
import 'package:my_sport_map/l10n/l10n.dart';
import 'package:my_sport_map/secret.dart';
import 'package:strava_repository/strava_repository.dart';

// TODO(nenuphar): splash screen (during loading of client ?)

// TODO(nenuphar): token type bearer ??? (ok with strava api ?) looks good

// TODO(nenuphar): catch errors !!!

// TODO(nenuphar): initialize logger in utility file ?

// TODO(nenuphar): do not call context in build method !

// TODO(nenuphar): insert the repository inside the bloc ?

// TODO(nenuphar): dispose of repository or other stuff ?

// TODO(nenuphar): review this doc (and structure of the class)

/// {@template my_sport_map_app}
/// A [StatelessWidget] which constructs a [MaterialApp] with a home to
/// [HomePage].
/// {endtemplate}
class MySportMapApp extends StatelessWidget {
  const MySportMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) =>
          StravaRepository(clientId: clientId, secret: clientSecret),
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'My sport map',
      home: const HomePage(),
    );
  }
}
