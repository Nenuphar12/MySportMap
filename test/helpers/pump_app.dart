import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_sport_map/l10n/l10n.dart';
import 'package:strava_repository/strava_repository.dart';

class MockStravaRepository extends Mock implements StravaRepository {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    StravaRepository? stravaRepository,
  }) {
    return pumpWidget(
      RepositoryProvider.value(
        value: stravaRepository ?? MockStravaRepository(),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: widget),
        ),
      ),
    );
  }
}
