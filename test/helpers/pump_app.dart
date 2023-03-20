import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_sport_map/home/home.dart';
import 'package:my_sport_map/l10n/l10n.dart';
import 'package:strava_repository/strava_repository.dart';

class MockStravaRepository extends Mock implements StravaRepository {}

class MockClientCubit extends Mock implements ClientCubit {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    StravaRepository? stravaRepository,
    ClientCubit? clientCubit,
  }) {
    return pumpWidget(
      RepositoryProvider.value(
        value: stravaRepository ?? MockStravaRepository(),
        // TODO(nenuphar): change not needed anymore ?
        child: BlocProvider.value(
          value: clientCubit ?? MockClientCubit(),
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: widget),
          ),
        ),
        // child: MaterialApp(
        //   localizationsDelegates: AppLocalizations.localizationsDelegates,
        //   supportedLocales: AppLocalizations.supportedLocales,
        //   home: Scaffold(body: widget),
        // ),
      ),
    );
  }
}
