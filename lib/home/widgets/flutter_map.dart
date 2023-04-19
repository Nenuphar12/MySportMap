import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_sport_map/home/helpers/geolocator_helper.dart';
import 'package:my_sport_map/utilities/utilities.dart';
import 'package:strava_repository/strava_repository.dart';

// TODO(nenuphar): add Strava heatmap
// https://nuxx.net/blog/2020/05/24/high-resolution-strava-global-heatmap-in-josm/

class MyFlutterMap extends StatefulWidget {
  const MyFlutterMap({
    required this.isClientReady,
    super.key,
    this.geolocatorHelper = const GeolocatorHelper(),
  });

  final bool isClientReady;
  final GeolocatorHelper geolocatorHelper;

  @override
  State<MyFlutterMap> createState() => MyFlutterMapState();
}

class MyFlutterMapState extends State<MyFlutterMap> {
  // TODO(nenuphar): remove
  // final Completer<GoogleMapController> controller =
  //     Completer<GoogleMapController>();

  // late MapController _mapController;

  /// The center of the map.
  late LatLng centerOfMap;

  bool _polylinesLoaded = false;

  /// The default initial position to center the map
  final LatLng _center = LatLng(43.5628075, 5);

  late Set<Polyline> _myPolylines = {};

  late FollowOnLocationUpdate _followOnLocationUpdate;
  late StreamController<double?> _followCurrentLocationStreamController;

  @override
  void initState() {
    super.initState();

    _followOnLocationUpdate = FollowOnLocationUpdate.always;
    _followCurrentLocationStreamController = StreamController<double?>();

    // Tries to determine current position and ask permission if needed.
    // The map initial position is then updated.
    // widget.geolocatorHelper.determinePosition().then(
    //   (position) {
    //     final currentPosition = CameraPosition(
    //       target: LatLng(position.latitude, position.longitude),
    //       zoom: 13,
    //     );
    //     // Animate the map to the current position
    //     controller.future.then(
    //       (controller) => controller.animateCamera(
    //         CameraUpdate.newCameraPosition(
    //           currentPosition,
    //         ),
    //       ),
    //     );
    //   },
    // ).onError<LocationServiceDisabledException>(
    //   (error, stackTrace) {
    //     logger.i('location service is disabled');
    //     final snackBar = SnackBar(content: Text(error.toString()));
    //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //   },
    // ).onError<PermissionDeniedException>(
    //   (error, stackTrace) {
    //     logger.i('location permission request denied');
    //     final snackBar = SnackBar(content: Text(error.toString()));
    //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //   },
    // ).onError<PermissionDeniedForeverException>(
    //   (error, stackTrace) {
    //     logger.w('location permission permanently denied');
    //     final snackBar = SnackBar(content: Text(error.toString()));
    //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //   },
    // );

    // Load polylines of activities to be displayed
    if (!_polylinesLoaded) {
      if (widget.isClientReady) {
        // Get the polylines !
        logger.v('[polylines] Requesting polylines');
        context.read<StravaRepository>().getAllPolylinesFM().then((polylines) {
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
  void dispose() {
    _followCurrentLocationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.v('Building map.');

    return FlutterMap(
      // mapController: _mapController,
      options: MapOptions(
        center: _center,
        zoom: 10,
        // Stop following the location marker on the map if user interacted with
        // the map.
        onPositionChanged: (MapPosition position, bool hasGesture) {
          if (hasGesture &&
              _followOnLocationUpdate != FollowOnLocationUpdate.never) {
            setState(
              () => _followOnLocationUpdate = FollowOnLocationUpdate.never,
            );
          }
        },
        // disable rotation
        interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
      ),
      nonRotatedChildren: [
        AttributionWidget.defaultWidget(
          source: 'OpenStreetMap contributors',
        ),
        Positioned(
          right: 15,
          bottom: 30,
          child: FloatingActionButton(
            onPressed: () {
              // Follow the location marker on the map when location updated
              // until user interact with the map.
              setState(
                () => _followOnLocationUpdate = FollowOnLocationUpdate.always,
              );
              // Follow the location marker on the map and zoom the map to
              // level 12.
              _followCurrentLocationStreamController.add(12);
            },
            child: const Icon(
              Icons.my_location,
              color: Colors.white,
            ),
          ),
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.nenuphar.mySportMap',
          maxZoom: 19,
        ),
        PolylineLayer(
          // TODO(nenuphar): change set of polylines to list
          // TODO(nenuphar): simplify polylines when zoomed out
          polylines: _myPolylines.toList(),
        ),
        CurrentLocationLayer(
          followCurrentLocationStream:
              _followCurrentLocationStreamController.stream,
          followOnLocationUpdate: _followOnLocationUpdate,
        ),
      ],
    );

    // return GoogleMap(
    //   polylines: _myPolylines,
    //   onMapCreated: controller.complete,
    //   initialCameraPosition: CameraPosition(
    //     target: _center,
    //     zoom: 10,
    //   ),
    //   myLocationEnabled: true,
    //   // mapType: MapType.terrain,
    //   // Keeps centerOfMap updated
    //   onCameraMove: (position) => centerOfMap = position.target,
    // );
  }
}
