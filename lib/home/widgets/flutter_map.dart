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
  // TODO(nenuphar): do something about this
  // late MapController _mapController;

  /// The center of the map.
  late LatLng centerOfMap;

  bool _polylinesLoaded = false;

  /// The default initial position to center the map
  final LatLng _center = LatLng(43.5628075, 5);

  late List<Polyline> _myPolylines = [];

  late FollowOnLocationUpdate _followOnLocationUpdate;
  late StreamController<double?> _followCurrentLocationStreamController;

  @override
  void initState() {
    super.initState();

    _followOnLocationUpdate = FollowOnLocationUpdate.always;
    _followCurrentLocationStreamController = StreamController<double?>();

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
          // TODO(nenuphar): simplify polylines when zoomed out
          polylines: _myPolylines,
        ),
        CurrentLocationLayer(
          followCurrentLocationStream:
              _followCurrentLocationStreamController.stream,
          followOnLocationUpdate: _followOnLocationUpdate,
          style: const LocationMarkerStyle(
            markerSize: Size.square(12),
            headingSectorRadius: 40,
          ),
        ),
      ],
    );
  }
}
