import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sport_map/home/view/home_page.dart';
import 'my_sport_map_observer.dart';

// TODO : splash screen (during loading of client ?)

void main() {
  Bloc.observer = const MySportMapObserver();
  runApp(const MySportMapApp());
}

// TODO : review this doc (and structure of the class)

/// {@template my_sport_map_app}
/// A [StatelessWidget] which constructs a [MaterialApp] with a home to
/// [HomePage].
/// {endtemplate}
class MySportMapApp extends StatelessWidget {
  /// {@macro my_sport_map_app}
  const MySportMapApp({super.key});

  /*
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  */

  /*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Map sample app'),
        backgroundColor: Colors.green[700],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
    ));
  }
  */

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My sport map',
      home: HomePage(),
    );
  }
}
