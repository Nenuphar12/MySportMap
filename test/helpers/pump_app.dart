import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_sport_map/home/home.dart';
import 'package:strava_repository/strava_repository.dart';

class MockStravaRepository extends Mock implements StravaRepository {}

class MockClientCubit extends Mock implements ClientCubit {}

class MockActivitiesCubit extends MockCubit<ActivitiesState>
    implements ActivitiesCubit {}

// class MockNavigatorObserver extends Mock implements NavigatorObserver {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    StravaRepository? stravaRepository,
    ClientCubit? clientCubit,
    ActivitiesCubit? activitiesCubit,
    // NavigatorObserver? navigatorObserver,
  }) {
    final defaultActivitiesCubit = MockActivitiesCubit();
    when(
      () => defaultActivitiesCubit.state,
    ).thenReturn(const ActivitiesState());

    return pumpWidget(
      RepositoryProvider.value(
        value: stravaRepository ?? MockStravaRepository(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: clientCubit ?? MockClientCubit()),
            BlocProvider.value(
              value: activitiesCubit ?? defaultActivitiesCubit,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(body: widget),
            // navigatorObservers: [
            //   navigatorObserver ?? MockNavigatorObserver(),
            // ],
          ),
        ),
      ),
    );
  }
}
