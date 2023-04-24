import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_sport_map/home/errors/errors.dart';
import 'package:my_sport_map/home/helpers/geolocator_helper.dart';
import 'package:my_sport_map/utilities/my_utilities.dart';
import 'package:strava_repository/strava_repository.dart';

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
  final Completer<GoogleMapController> mapControllerCompleter =
      Completer<GoogleMapController>();

  /// The center of the map.
  LatLng centerOfMap = const LatLng(44, 5);

  /// The default initial position to center the map.
  final LatLng _center = const LatLng(43.5628075, 5);

  Set<Polyline> _myPolylines = {};

  final double initialZoom = 10;

  @override
  void initState() {
    super.initState();

    // Tries to determine current position and ask permission if needed.
    // The map initial position is then updated.
    initializePosition();

    // Load polylines of activities to be displayed
    loadPolylines();
  }

  @override
  Widget build(BuildContext context) {
    MyUtilities.logger.v('[Build] MyGoogleMap');

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: initialZoom,
      ),
      onMapCreated: mapControllerCompleter.complete,
      myLocationEnabled: true,
      polylines: _myPolylines,
      // mapType: MapType.terrain,
      // Keeps centerOfMap updated
      onCameraMove: (position) => centerOfMap = position.target,
    );
  }

  Future<void> loadPolylines() async {
    // Inits (if not already) the storage of Activities
    context.read<StravaRepository>().initLocalStorage();

    // Get polylines stored locally
    final localPolylines =
        await context.read<StravaRepository>().localPolylinesCompleterGM.future;
    MyUtilities.logger.d('[polylines] Got local polylines');
    setState(() {
      _myPolylines = localPolylines;
    });

    // Get new and updated polylines
    final updatedPolylines = await context
        .read<StravaRepository>()
        .updatedPolylinesCompleterGM
        .future;

    // if (MyUtilities.setGMPolylinesEquals(updatedPolylines, _myPolylines)) {
    if (updatedPolylines.length == _myPolylines.length) {
      MyUtilities.logger.d('[polylines] No updated polylines');
    } else {
      MyUtilities.logger.d('[polylines] Got updated polylines');
      setState(() {
        _myPolylines = updatedPolylines;
      });
    }
  }

  Future<void> initializePosition() async {
    try {
      final userPosition = await widget.geolocatorHelper.determinePosition();
      final cameraPosition = CameraPosition(
        target: LatLng(userPosition.latitude, userPosition.longitude),
        zoom: 13,
      );

      // Animate the map to the current position
      final controller = await mapControllerCompleter.future;
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          cameraPosition,
        ),
      );
    } on LocationServiceDisabledException catch (error, stacktrace) {
      MyUtilities.logger.i('location service is disabled');
      final snackBar = SnackBar(content: Text(error.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on PermissionDeniedException catch (error, stacktrace) {
      MyUtilities.logger.i('location permission request denied');
      final snackBar = SnackBar(content: Text(error.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on PermissionDeniedForeverException catch (error, stacktrace) {
      MyUtilities.logger.w('location permission permanently denied');
      final snackBar = SnackBar(content: Text(error.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
