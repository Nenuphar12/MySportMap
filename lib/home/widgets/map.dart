import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_sport_map/utilities/utilities.dart';
import 'package:strava_repository/strava_repository.dart';

class MyMap extends StatefulWidget {
  const MyMap({required this.isClientReady, super.key});

  final bool isClientReady;
  //final ClientState state;

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late GoogleMapController mapController;
  bool polylinesLoaded = false;

  late Set<Polyline> myPolylines = {};

  final LatLng _center = const LatLng(43.5628075, 5.6427871);

  // ignore: use_setters_to_change_properties
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    logger.d('Building map.');
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
      polylines: myPolylines,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11,
      ),
    );
  }
}
