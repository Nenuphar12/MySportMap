import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:clipboard/clipboard.dart';
import 'package:my_sport_map/authentication/cubit/client_cubit.dart';
import 'package:my_sport_map/main_page.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:shared_preferences/shared_preferences.dart';
import 'secret.dart';
import 'my_observer.dart';

void main() {
  Bloc.observer = MyObserver();
  runApp(const MyApp());
}

class MainData {
  oauth2.Client? stravaApiClient;
  bool needAuthentication = false;
  bool gotTheClient = false;

  MainData(
      {this.stravaApiClient = null,
      this.needAuthentication = false,
      this.gotTheClient = false});
}

class MainCubit extends Cubit<MainData> {
  MainCubit() : super(MainData());

  void setClient(oauth2.Client? client) {
    state.stravaApiClient = client;
    emit(state);
  }

  void setNeedAuthentication(bool need) {
    state.needAuthentication = need;
    emit(state);
  }

  void setGotTheClient(bool gotIt) {
    state.gotTheClient = gotIt;
    emit(state);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  oauth2.Client? stravaApiClient;
  bool needAuthentication = false;
  bool gotTheClient = false;

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // This widget is the root of your application.
  /**
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

  // TODO : tmp ?
  bool isLoggedIn = false;

  // Callback to get back to the main page
  // It is probably awfull TODO : change...
  void setClientReady() {
    setState(() {
      gotTheClient = true;
      needAuthentication = false; // TODO : ?
    });
  }

  @override
  Widget build(BuildContext parecontext) {
    // TODO !
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('My sport map')),
        body:
            BlocProvider(create: (_) => ClientCubit(), child: const MainPage()),
      ),
    );
  }
}
