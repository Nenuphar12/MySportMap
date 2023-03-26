import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_sport_map/utilities/utilities.dart';
import 'package:strava_repository/strava_repository.dart';

class MyMap extends StatefulWidget {
  const MyMap({required this.isClientReady, super.key});

  final bool isClientReady;

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late GoogleMapController mapController;
  bool polylinesLoaded = false;

  /// Whether the location permission is granted (on the spot).
  bool isLocationPermissionChanged = false;

  /// [Key] used to rebuild the map when location is authorized.
  Key googleMapKey = const Key('initial_google_map');

  late Set<Polyline> myPolylines = {};

  final LatLng _center = const LatLng(43.5628075, 5.6427871);

  // ignore: use_setters_to_change_properties
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    // Ask for location permission (if needed) and if it is newly granted,
    // rebuild the map
    _checkLocalizationPermission().then((value) {
      logger.d('Location permission granted.');
      setState(() {
        isLocationPermissionChanged = true;
        // Reload the map
        googleMapKey = const Key('google_map_reloaded_with_location');
      });
    }).onError((error, stackTrace) {
      const snackBar = SnackBar(
        content: Text('Localization is not permitted.\n\n'
            'Consider enabling it if you want the map to display'
            ' your position.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.v('Building map.');
    if (!polylinesLoaded) {
      if (widget.isClientReady) {
        // Get the polylines !
        logger.v('Requesting polylines...');
        context.read<StravaRepository>().getAllPolylines().then((polylines) {
          logger.v('Got polylines !!!');
          setState(() {
            myPolylines = polylines;
            polylinesLoaded = true;
          });
        });
      }
    }

    return GoogleMap(
      key: googleMapKey,
      polylines: myPolylines,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11,
      ),
      myLocationEnabled: true,
    );
  }

  /// Determine if localization is permitted and ask permission if needed.
  ///
  /// Returns `true` if the permission is newly granted and `false` if it was
  /// already granted previously. (indicates a change)
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<bool> _checkLocalizationPermission() async {
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
        return Future.error('Location permissions are denied');
      }

      return true;
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied,'
        ' we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted
    return false;
  }
}
