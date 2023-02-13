import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  oauth2.Client? stravaApiClient;
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

  // To connect by OAuth2
  final authorizationEndpoint =
      Uri.parse("https://www.strava.com/oauth/mobile/authorize");
  final tokenEndpoint = Uri.parse('');
  final String clientId = '100668';
  final String clientSecret = 'c043f4ba922e8f079b1189f0d6c9f02b221c1e85';
  // TODO: change the redirect url
  final redirectUrl = Uri.parse('http://localhost');
  late Uri responseUrl;

  final TextEditingController _textEditingController = TextEditingController();

  // TODO: tmp
  bool isLoggedIn = false;
  Future<void> testAuthentication() async {
    print("Test authentication...");
    //ScaffoldMessenger.of(context)
    //    .showSnackBar(const SnackBar(content: Text("Test authentication...")));
    // Let's get the code
    // Test with oauth2 packege
    oauth2.Client stravaClient = await createClient();
    print("Got stravaClient ???");
    //ScaffoldMessenger.of(context)
    //    .showSnackBar(const SnackBar(content: Text("Got stravaClient ???")));

    // POST request to strava auth
    /**
    Dio().post(
      "$authorizationEndpoint",
      queryParameters: {
        "client_id": clientId,
        "client_secret": clientSecret,
        "code": "tempo",
        "grant_type": "authorization_code"
      },
    );
    */
  }

  // Requesting Strava API code with oauth2
  // from here : https://pub.dev/packages/oauth2
  Future<oauth2.Client> createClient() async {
    print("[call] createClient()");
    var grant = oauth2.AuthorizationCodeGrant(
        clientId, authorizationEndpoint, tokenEndpoint,
        secret: clientSecret); // no need for secret ? TODO: test without

    var authorizationUrl = grant.getAuthorizationUrl(
      redirectUrl,
      //scopes: ["activity:read_all,read_all"],
      scopes: ["read_all"],
    );

    // NOTE: looks difficult to open it in strava app and then go back to my app
    // Could be doable with deep links (for later)
    // [Interesting blog](https://augustkimo.medium.com/simple-flutter-sharing-and-deeplinking-open-apps-from-a-url-be56613bdbe6)
    // Or this [interesting package](https://pub.dev/packages/app_links)

    // WORKING !!!
    //if (await canLaunchUrl(authorizationUrl)) {
    //  await launchUrl(authorizationUrl, mode: LaunchMode.externalApplication);
    //}

    // listen (?)
    /**
    final linksStream = linkStream.listen((Uri uri) async {
      if (uri.toString().startsWith(redirectUrl.toString())) {
        responseUrl = uri;
      }
    });

    final linksStream_v2 = getLinksStream().listen((Uri uri) async {
      if (uri.toString().startsWith(redirectUrl)) {
        responseUrl = uri;
      }
    });
    */

    // Using webview !
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (request) {
          if (request.url.startsWith(redirectUrl.toString())) {
            responseUrl = Uri.parse(request.url);
            // tmp
            print("WebViewControler getting the responseUrl");
            print(responseUrl);
            //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            //    content: Text("WebViewControler getting the responseUrl")));
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(authorizationUrl);

    WebViewWidget(
      controller: controller,
    );

    /**
    WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: authorizationUrl.toString(),
      navigationDelegate: (navReq) {
        if (navReq.url.startsWith(redirectUrl)) {
          responseUrl = Uri.parse(navReq.url);
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
      // ------- 8< -------
    );
    */

    //await redirect(authorizationUrl);
    //var responseUrl = await listen(redirectUrl);
    //return await grant.handleAuthorizationResponse(responseUrl.queryParameters);
    await responseUrl;
    return await grant.handleAuthorizationResponse(responseUrl.queryParameters);
  }

  void testDeauth() {
    // TODO: implement testDeauth
    print("[call] testDeauth()");
  }

  @override
  Widget build(BuildContext parecontext) {
    // Check the client
    if (stravaApiClient != null) {
      // TODO
      // To load my client if it exists
      final prefs = SharedPreferences.getInstance();
      prefs.then((value) {
        String? credentials = value.getString("credentials");
        if (credentials == null) {
          // TODO : create credentials
        } else {
          // TODO : load credentials into client
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
                          builder: (context) => const AuthenticationPage()));
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
