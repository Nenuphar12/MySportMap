import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sport_map/home/home.dart';
import 'package:my_sport_map/l10n/l10n.dart';
import 'package:strava_repository/strava_repository.dart';

/// {@template my_sport_map_app}
/// A [StatelessWidget] which constructs a [MaterialApp] with a home to
/// [HomePage].
/// {endtemplate}
class MySportMapApp extends StatelessWidget {
  const MySportMapApp({super.key, required this.stravaRepository});

  final StravaRepository stravaRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: stravaRepository,
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
