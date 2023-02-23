// Repository to abstract our data layer and facilitate communication
// with the bloc layer.
library strava_repository;

export 'src/models/models.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
