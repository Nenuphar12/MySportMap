import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_sport_map/home/cubit/activities_cubit.dart';
import 'package:my_sport_map/home/helpers/geolocator_helper.dart';
import 'package:my_sport_map/utilities/utilities.dart';

/// {@template my_map}
/// The map displaying the activities of the provided [ActivitiesCubit] and the
/// user's position.
///
/// The map is centered once on the user's position. The follow button keeps
/// it centered on the user until they move the map.
/// {@endtemplate}
class MyMap extends StatefulWidget {
  /// {@macro my_map}
  const MyMap({
    super.key,
    this.geolocatorHelper = const GeolocatorHelper(),
  });

  final GeolocatorHelper geolocatorHelper;

  @override
  State<MyMap> createState() => MyMapState();
}

class MyMapState extends State<MyMap> {
  /// The default initial position to center the map
  static const _center = LatLng(43.5628075, 5);

  /// The zoom level used when following the user's position.
  static const followZoom = 15.0;

  /// Asks the location layer to center the map on the user, at a zoom level.
  final _alignPositionController = StreamController<double?>();

  /// When the location layer centers the map on the user.
  AlignOnUpdate alignPositionOnUpdate = AlignOnUpdate.once;

  @override
  void dispose() {
    unawaited(_alignPositionController.close());
    super.dispose();
  }

  void _followUser() {
    setState(() => alignPositionOnUpdate = AlignOnUpdate.always);
    _alignPositionController.add(followZoom);
  }

  void _onPositionChanged(MapCamera camera, bool hasGesture) {
    // The user moved the map: stop centering it on them.
    if (hasGesture && alignPositionOnUpdate != AlignOnUpdate.never) {
      setState(() => alignPositionOnUpdate = AlignOnUpdate.never);
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.t('Building map.');

    return BlocBuilder<ActivitiesCubit, ActivitiesState>(
      builder: (context, state) {
        return FlutterMap(
          options: MapOptions(
            initialCenter: _center,
            initialZoom: 10,
            onPositionChanged: _onPositionChanged,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.nenuphar.mysportmap',
              retinaMode: RetinaMode.isHighDensity(context),
            ),
            PolylineLayer(
              polylines: state.polylines,
              simplificationTolerance: 0.6,
            ),
            CurrentLocationLayer(
              alignPositionStream: _alignPositionController.stream,
              alignPositionOnUpdate: alignPositionOnUpdate,
            ),
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
            if (state.status == ActivitiesStatus.syncing)
              const Align(
                alignment: Alignment.topCenter,
                child: LinearProgressIndicator(),
              ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                // Leave room for the attribution button below.
                padding: const EdgeInsets.only(right: 16, bottom: 64),
                child: FloatingActionButton(
                  key: const Key('myMap_followUser_floatingActionButton'),
                  tooltip: 'Follow my position',
                  onPressed: _followUser,
                  child: const Icon(Icons.my_location),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
