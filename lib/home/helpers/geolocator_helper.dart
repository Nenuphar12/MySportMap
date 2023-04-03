import 'package:geolocator/geolocator.dart'
    hide LocationServiceDisabledException, PermissionDeniedException;
import 'package:my_sport_map/home/errors/errors.dart';

// TODO(nenuphar): move this class to a package ?

/// Helper class managing user's position using [Geolocator].
///
/// (One of its purposes is to wrap Geolocator's static functions so they can
/// be mocked and tested.)
class GeolocatorHelper {
  const GeolocatorHelper();

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        return Future.error(const PermissionDeniedException());
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      return Future.error(
        const PermissionDeniedForeverException(),
      );
    }

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      return Future.error(const LocationServiceDisabledException());
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return Geolocator.getCurrentPosition();
  }
}
