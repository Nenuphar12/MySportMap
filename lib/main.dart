import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:clipboard/clipboard.dart';
import 'package:my_sport_map/screens/authentication.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'secret.dart';
import 'screens/authentication.dart';

void main() {
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

  final TextEditingController _textEditingController = TextEditingController();

  // TODO : tmp ?
  bool isLoggedIn = false;

  void testDeauth() {
    // TODO: implement testDeauth
    print("[call] testDeauth()");
  }

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
    if (gotTheClient) {
      print("WE GOT THE CLIENT");
    }
    // Check if we need authentication
    if (needAuthentication) {
      // Authenticate to get access to your strava data
      return MaterialApp(
          home: AuthenticationPage(
        setClientReady: setClientReady,
      ));
    }
    // Check the client
    if (stravaApiClient == null) {
      // TODO
      // To load my client if it exists
      final prefs = SharedPreferences.getInstance();
      prefs.then((value) {
        String? jsonCredentials = value.getString("credentials");
        // TODO tempo
        //jsonCredentials = null;
        if (jsonCredentials == null) {
          // TODO : create credentials
          setState(() {
            needAuthentication = true;
          });
        } else {
          // TODO : load credentials into client
          var clientCredentials = oauth2.Credentials.fromJson(jsonCredentials);
          setState(() {
            stravaApiClient = oauth2.Client(clientCredentials,
                identifier: clientId, secret: clientSecret);
          });
        }
      });
    }
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Strava Plugin"),
        actions: [
          Icon(
            isLoggedIn
                ? Icons.radio_button_checked_outlined
                : Icons.radio_button_off,
            color: isLoggedIn ? Colors.white : Colors.red,
          ),
          const SizedBox(
            width: 8,
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_login(), _apiGroups()],
        ),
      ),
    ));
  }

  Widget _login() {
    return Builder(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                //onPressed: testAuthentication,
                onPressed: () {
                  print('Change of page...');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AuthenticationPage(
                                setClientReady: setClientReady,
                              )));
                },
                child: const Text("Login With Strava"),
              ),
              ElevatedButton(
                child: Text("De Authorize"),
                onPressed: testDeauth,
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            minLines: 1,
            maxLines: 3,
            controller: _textEditingController,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: const Text("Access Token"),
                suffixIcon: TextButton(
                  child: const Text("Copy"),
                  onPressed: () {
                    FlutterClipboard.copy(_textEditingController.text).then(
                        ((value) => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Copied !")))));
                  },
                )),
          ),
          const Divider()
        ],
      );
    });
  }

  Widget _apiGroups() {
    return IgnorePointer(
      ignoring: !isLoggedIn,
      child: AnimatedOpacity(
        opacity: isLoggedIn ? 1.0 : 0.4,
        duration: Duration(milliseconds: 200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text("Athletes"),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              title: Text("Clubs"),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              title: Text("Gears"),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              title: Text("Routes"),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              title: Text("Running Races"),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              title: Text("Segment Efforts"),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              title: Text("Segments"),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              title: Text("Streams"),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              title: Text("Uploads"),
              trailing: Icon(Icons.chevron_right),
            )
          ],
        ),
      ),
    );
  }
}

class StravaAccount {
  // From here : https://www.strava.com/settings/api
  String clientId = '100668';
  String clientSecret = 'c043f4ba922e8f079b1189f0d6c9f02b221c1e85';

  StravaAccount({
    required this.clientId,
    required this.clientSecret,
  }) {}
}
