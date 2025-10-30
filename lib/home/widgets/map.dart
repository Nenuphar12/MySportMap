// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_sport_map/home/helpers/geolocator_helper.dart';
import 'package:my_sport_map/utilities/utilities.dart';
import 'package:strava_repository/strava_repository.dart';

class MyMap extends StatefulWidget {
  const MyMap({
    required this.isClientReady,
    super.key,
    this.geolocatorHelper = const GeolocatorHelper(),
  });

  final bool isClientReady;
  final GeolocatorHelper geolocatorHelper;

  @override
  State<MyMap> createState() => MyMapState();
}

class MyMapState extends State<MyMap> {
  bool _polylinesLoaded = false;

  /// The default initial position to center the map
  final LatLng _center = const LatLng(43.5628075, 5);

  late List<Polyline> _myPolylines = [];

  @override
  void initState() {
    super.initState();

    // Load polylines of activities to be displayed
    if (!_polylinesLoaded) {
      if (widget.isClientReady) {
        // Get the polylines !
        logger.t('[polylines] Requesting polylines');
        context.read<StravaRepository>().getAllPolylines().then((polylines) {
          logger.t('[polylines] Got polylines');
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
    logger.t('Building map.');

    return FlutterMap(
      options: MapOptions(initialCenter: _center, initialZoom: 10),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.nenuphar.mysportmap',
          retinaMode: RetinaMode.isHighDensity(context),
        ),
        PolylineLayer(polylines: _myPolylines, simplificationTolerance: 0.6),
        const Scalebar(
          alignment: Alignment.bottomLeft,
          textStyle: TextStyle(
            color: Color.fromARGB(160, 0, 0, 0),
            fontSize: 12,
          ),
          lineColor: Color.fromARGB(160, 0, 0, 0),
        ),
        const RichAttributionWidget(
          // Include prebuilt attribution widget that meets all requirements
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              // onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')), // (external)
            ),
          ],
        ),
      ],
    );
  }
}
