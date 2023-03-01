import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sport_map/home/view/home_page.dart';
import 'package:my_sport_map/secret.dart';
import 'package:strava_repository/strava_repository.dart';
import 'my_sport_map_observer.dart';

// TODO : splash screen (during loading of client ?)

// TODO : token type bearer ??? (ok with strava api ?)

void main() {
  Bloc.observer = const MySportMapObserver();
  runApp(const MySportMapApp());
}

// TODO : review this doc (and structure of the class)

/// {@template my_sport_map_app}
/// A [StatelessWidget] which constructs a [MaterialApp] with a home to
/// [HomePage].
/// {endtemplate}
class MySportMapApp extends StatelessWidget {
  /// {@macro my_sport_map_app}
  const MySportMapApp({super.key});
  /*{
    stravaRepository =
        StravaRepository(secret: clientSecret, clientId: clientId);
  }
  */

  //late StravaRepository stravaRepository;

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
    return const MaterialApp(
      title: 'My sport map',
      home: HomePage(),
    );
  }
}
