import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_sport_map/home/errors/errors.dart';
import 'package:my_sport_map/home/helpers/geolocator_helper.dart';
import 'package:my_sport_map/utilities/utilities.dart';
import 'package:strava_repository/strava_repository.dart';

// TODO(nenuphar): add Strava heatmap
// https://nuxx.net/blog/2020/05/24/high-resolution-strava-global-heatmap-in-josm/

class MyGoogleMap extends StatefulWidget {
  const MyGoogleMap({
    required this.isClientReady,
    super.key,
    this.geolocatorHelper = const GeolocatorHelper(),
  });

  final bool isClientReady;
  final GeolocatorHelper geolocatorHelper;

  @override
  State<MyGoogleMap> createState() => MyGoogleMapState();
}

class MyGoogleMapState extends State<MyGoogleMap> {
  final Completer<GoogleMapController> controller =
      Completer<GoogleMapController>();

  /// The center of the map.
  late LatLng centerOfMap;

  bool _polylinesLoaded = false;

  /// The default initial position to center the map
  final LatLng _center = const LatLng(43.5628075, 5);

  late Set<Polyline> _myPolylines = {};

  @override
  void initState() {
    super.initState();
    // Tries to determine current position and ask permission if needed.
    // The map initial position is then updated.
    widget.geolocatorHelper.determinePosition().then(
      (position) {
        final currentPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 13,
        );
        // Animate the map to the current position
        controller.future.then(
          (controller) => controller.animateCamera(
            CameraUpdate.newCameraPosition(
              currentPosition,
            ),
          ),
        );
      },
    ).onError<LocationServiceDisabledException>(
      (error, stackTrace) {
        logger.i('location service is disabled');
        final snackBar = SnackBar(content: Text(error.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    ).onError<PermissionDeniedException>(
      (error, stackTrace) {
        logger.i('location permission request denied');
        final snackBar = SnackBar(content: Text(error.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    ).onError<PermissionDeniedForeverException>(
      (error, stackTrace) {
        logger.w('location permission permanently denied');
        final snackBar = SnackBar(content: Text(error.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );

    // Load polylines of activities to be displayed
    if (!_polylinesLoaded) {
      if (widget.isClientReady) {
        // Get the polylines !
        logger.v('[polylines] Requesting polylines');
        context.read<StravaRepository>().getAllPolylinesGM().then((polylines) {
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
      onMapCreated: controller.complete,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 10,
      ),
      myLocationEnabled: true,
      // mapType: MapType.terrain,
      // Keeps centerOfMap updated
      onCameraMove: (position) => centerOfMap = position.target,
    );
  }
}
