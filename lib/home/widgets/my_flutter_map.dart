import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_sport_map/home/helpers/geolocator_helper.dart';
import 'package:my_sport_map/utilities/my_utilities.dart';
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
  /// The center of the map.
  LatLng centerOfMap = LatLng(44, 5);

  /// The default initial position to center the map.
  final LatLng _center = LatLng(43.5628075, 5);

  List<Polyline> _myPolylines = [];

  late FollowOnLocationUpdate _followOnLocationUpdate;
  late StreamController<double?> _followCurrentLocationStreamController;

  final double initialZoom = 10;
  final double centerPositionZoom = 15;
  final double maxZoom = 19;

  @override
  void initState() {
    super.initState();

    _followOnLocationUpdate = FollowOnLocationUpdate.always;
    _followCurrentLocationStreamController = StreamController<double?>();

    // Load polylines of activities to be displayed
    loadPolylines();
  }

  @override
  void dispose() {
    _followCurrentLocationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyUtilities.logger.v('[Build] MyFlutterMap');

    return FlutterMap(
      // mapController: _mapController,
      // TODO(nenuphar): move this out of here
      // (eventually use a static function)
      options: MapOptions(
        center: _center,
        zoom: initialZoom,
        // disable rotation
        interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        // Stop following the location marker on the map if user interacted with
        // the map.
        onPositionChanged: handlePositionChanged,
        // onPositionChanged: (MapPosition position, bool hasGesture) {
        //   if (hasGesture &&
        //       _followOnLocationUpdate != FollowOnLocationUpdate.never) {
        //     setState(
        //       () => _followOnLocationUpdate = FollowOnLocationUpdate.never,
        //     );
        //   }
        // },
      ),
      nonRotatedChildren: [
        // Credit used tile server
        AttributionWidget.defaultWidget(
          source: 'OpenStreetMap contributors',
        ),
        // Button used for user's position
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
              // level 15.
              _followCurrentLocationStreamController.add(centerPositionZoom);
            },
            child: const Icon(
              Icons.my_location,
              color: Colors.white,
            ),
          ),
        ),
      ],
      children: [
        // OpenStreetMap tile layer
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          maxZoom: maxZoom,
          userAgentPackageName: 'com.nenuphar.mySportMap',
        ),

        // TODO(nenuphar): use a Cubit...

        // Polylines of the user
        PolylineLayer(
          polylines: _myPolylines,
        ),
        // Marker showing user's position
        CurrentLocationLayer(
          style: const LocationMarkerStyle(
            markerSize: Size.square(12),
            headingSectorRadius: 40,
          ),
          followCurrentLocationStream:
              _followCurrentLocationStreamController.stream,
          followOnLocationUpdate: _followOnLocationUpdate,
        ),
      ],
    );
  }

  Future<void> loadPolylines() async {
    // TODO(nenuphar): do this earlier ? On creation of repository ?
    // (but it blocks the loading and displaying of the map...)

    // Inits (if not already) the storage of Activities
    context.read<StravaRepository>().initLocalStorage();

    // Get polylines stored locally
    final localPolylines =
        await context.read<StravaRepository>().localPolylinesCompleterFM.future;
    MyUtilities.logger.d('[polylines] Got local polylines');
    setState(() {
      _myPolylines = localPolylines;
    });

    // Get new and updated polylines
    final updatedPolylines = await context
        .read<StravaRepository>()
        .updatedPolylinesCompleterFM
        .future;

    // if (MyUtilities.listFMPolylinesEquals(updatedPolylines, _myPolylines)) {
    if (updatedPolylines.length == _myPolylines.length) {
      MyUtilities.logger.d('[polylines] No updated polylines');
    } else {
      MyUtilities.logger.d('[polylines] Got updated polylines');
      setState(() {
        _myPolylines = updatedPolylines;
      });
    }
  }

  void handlePositionChanged(MapPosition position, bool hasGesture) {
    if (hasGesture && _followOnLocationUpdate != FollowOnLocationUpdate.never) {
      setState(
        () => _followOnLocationUpdate = FollowOnLocationUpdate.never,
      );
    }
  }
}
