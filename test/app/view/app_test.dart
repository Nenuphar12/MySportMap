import 'package:flutter_test/flutter_test.dart';
import 'package:my_sport_map/app/app.dart';
import 'package:my_sport_map/home/view/home_page.dart';

void main() {
  group('App', () {
    testWidgets('renders HomePage', (tester) async {
      await tester.pumpWidget(const MySportMapApp());
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
