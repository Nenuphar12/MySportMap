import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_sport_map/app/app.dart';
import 'package:my_sport_map/home/view/home_page.dart';
import 'package:strava_repository/strava_repository.dart';

class MockStravaRepository extends Mock implements StravaRepository {}

void main() {
  late StravaRepository stravaRepository;

  setUp(() {
    stravaRepository = MockStravaRepository();
    when(stravaRepository.isAuthenticated)
        .thenAnswer((_) => Future.value(false));
  });

  group('MySportMapApp', () {
    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        MySportMapApp(
          stravaRepository: stravaRepository,
        ),
      );

      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    testWidgets('renders MaterialApp with correct themes', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: stravaRepository,
          child: const AppView(),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
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

    testWidgets('renders HomePage', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: stravaRepository,
          child: const AppView(),
        ),
      );

      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
