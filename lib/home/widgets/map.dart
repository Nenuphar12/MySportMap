import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart'
    hide LocationServiceDisabledException, PermissionDeniedException;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_sport_map/home/errors/errors.dart';
import 'package:my_sport_map/utilities/utilities.dart';
import 'package:strava_repository/strava_repository.dart';

class MyMap extends StatefulWidget {
  const MyMap({required this.isClientReady, super.key});

  final bool isClientReady;

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  bool _polylinesLoaded = false;

  /// The default initial position to center the map
  final LatLng _center = const LatLng(43.5628075, 5);

  late Set<Polyline> _myPolylines = {};

  @override
  void initState() {
    super.initState();
    // Tries to determine current position and ask permission if needed.
    // The map initial position is then updated.
    _determinePosition().then(
      (position) {
        final currentPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 13,
        );
        // Animate the map to the current position
        _controller.future.then(
          (controller) => controller.animateCamera(
            CameraUpdate.newCameraPosition(
              currentPosition,
            ),
          ),
        );
      },
    ).onError<LocationServiceDisabledException>(
      (error, stackTrace) {
        final snackBar = SnackBar(content: Text(error.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    ).onError<PermissionDeniedException>(
      (error, stackTrace) {
        logger.i('location permission request denied', [error, stackTrace]);
        final snackBar = SnackBar(content: Text(error.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    ).onError<PermissionDeniedForeverException>(
      (error, stackTrace) {
        logger.w('location permission permanently denied', [error, stackTrace]);
        final snackBar = SnackBar(content: Text(error.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );

    // Load polylines of activities to be displayed
    if (!_polylinesLoaded) {
      if (widget.isClientReady) {
        // Get the polylines !
        logger.v('[polylines] Requesting polylines');
        context.read<StravaRepository>().getAllPolylines().then((polylines) {
          logger.v('[polylines] Got polylines');
          setState(() {
            _myPolylines = polylines;
            _polylinesLoaded = true;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.v('Building map.');

    return GoogleMap(
      polylines: _myPolylines,
      onMapCreated: _controller.complete,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 10,
      ),
      myLocationEnabled: true,
      // mapType: MapType.terrain,
    );
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
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
