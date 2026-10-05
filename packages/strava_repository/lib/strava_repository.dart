/// A library to wrap [strava_flutter](https://pub.dev/packages/strava_client).
library;

// The type of `Activity.map`, so users do not need to import strava_client.
export 'package:strava_client/strava_client.dart' show PolyLineMap;
export 'src/cache/cache.dart';
export 'src/models/models.dart';
export 'src/strava_repository.dart';
export 'src/utilities/polyline_utility.dart';
