import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_sport_map/utilities/utilities.dart';
import 'package:strava_repository/strava_repository.dart';

// TODO : when deAuthorizing, the polylines stay in place

class MyMap extends StatefulWidget {
  const MyMap({super.key, required this.isClientReady});

  final bool isClientReady;
  //final ClientState state;

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late GoogleMapController mapController;
  bool polylinesLoaded = false;

  late Set<Polyline> myPolylines = {};

  // TODO : center map on current position ?
  final LatLng _center = const LatLng(43.5628075, 5.6427871);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // TODO: use streams ?
  @override
  Widget build(BuildContext context) {
    logger.d('Building map.');
    if (!polylinesLoaded) {
      if (widget.isClientReady) {
        //if (widget.state == ClientState.ready) {
        //if (BlocProvider.of<ClientCubit>(context).state == ClientState.ready) {
        //if (context.read<ClientCubit>().state == ClientState.ready) {
        // Get the polylines !
        logger.v('Requesting polylines...');
        context.read<StravaRepository>().getAllPolylines().then((polylines) {
          logger.v('Got polylines !!!');
          print('[GOT POLYLINES !!!]');
          setState(() {
            myPolylines = polylines;
            polylinesLoaded = true;
          });
        });
      }
    }

    return Expanded(
      child: GoogleMap(
        polylines: myPolylines,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
    );
  }
}
