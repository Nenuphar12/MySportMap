import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO
// make a cubit for all the authentication informations ?

/**
class AuthenticationData {
  late Uri responseUrl;

  AuthenticationData(this.responseUrl);
}

class AuthenticationDataCubit extends Cubit<AuthenticationData> {
  AuthenticationDataCubit() : super(AuthenticationData(Uri()));

  void setResponseUrl(Uri responseUrl) => emit(AuthenticationData(responseUrl));

  @override
  void onChange(Change<AuthenticationData> change) {
    // TODO: implement onChange
    super.onChange(change);
    print(change);
  }
} */

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

enum AuthenticationState {
  notAuthenticated,
  requestAccepted,
  requestCanceled,
  clientReady,
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  late Uri responseUrl;
  late Future<oauth2.Client> client;
  late oauth2.AuthorizationCodeGrant grant;
  AuthenticationState authState = AuthenticationState.notAuthenticated;

  // To connect by OAuth2
  final authorizationEndpoint =
      Uri.parse("https://www.strava.com/oauth/mobile/authorize");
  final tokenEndpoint = Uri.parse('https://www.strava.com/oauth/token');
  static const String clientId = '100668';
  static const String clientSecret = 'c043f4ba922e8f079b1189f0d6c9f02b221c1e85';
  // TODO: change the redirect url
  final redirectUrl = Uri.parse('http://localhost');

  @override
  Widget build(BuildContext context) {
    switch (authState) {
      case AuthenticationState.notAuthenticated:
        {
          setState(() {
            grant = oauth2.AuthorizationCodeGrant(
                clientId, authorizationEndpoint, tokenEndpoint,
                secret: clientSecret, // no need for secret ? TODO: test without
                basicAuth: false); // Strava does not support basic auth...
          });

          /**
      var grant = oauth2.AuthorizationCodeGrant(
          clientId, authorizationEndpoint, tokenEndpoint,
          secret: clientSecret); // no need for secret ? TODO: test without
          */

          var authorizationUrl = grant.getAuthorizationUrl(
            redirectUrl,
            scopes: ["read_all,activity:read_all,profile:read_all"],
          );

          // TODO manage cancel click
          // Using webview !
          WebViewController controller = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(NavigationDelegate(
              onNavigationRequest: (request) {
                print("Webview navigation request : $request");
                if (request.url.startsWith(redirectUrl.toString())) {
                  //var responseUrl = Uri.parse(request.url);
                  //var newClient = await grant
                  //    .handleAuthorizationResponse(responseUrl.queryParameters);
                  var parameters = Uri.parse(request.url).queryParameters;
                  if (parameters.containsKey("error")) {
                    if (parameters["error"] == "access_denied") {
                      print("ERROR authorization canceled...");
                      setState(() {
                        authState = AuthenticationState.requestCanceled;
                      });
                      return NavigationDecision.prevent;
                    }
                  }

                  setState(() {
                    authState = AuthenticationState.requestAccepted;
                    // TODO: remove next line
                    responseUrl = Uri.parse(request.url);
                    //client = newClient;
                  });

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

          return Scaffold(
            appBar: AppBar(
              title: const Text('First authentication to Strava'),
            ),
            body: Center(
              child: WebViewWidget(
                controller: controller,
              ),
            ),
          );
        }
      case AuthenticationState.requestAccepted:
        {
          //Future<oauth2.Client> newClient =
          //    grant.handleAuthorizationResponse(test.queryParameters);
          setState(() {
            client =
                grant.handleAuthorizationResponse(responseUrl.queryParameters);
            client.then((value) {
              print("GOT THE CLIENT !!!");
              setState(() {
                authState = AuthenticationState.clientReady;
              });
            });
          });
          //Future<oauth2.Client> newClient =
          //    grant.handleAuthorizationResponse(responseUrl.queryParameters);

          return Scaffold(
            appBar: AppBar(
              title: const Text('First authentication to Strava'),
            ),
            body: Center(
              child: Column(
                children: [
                  const Text("Authentication granted : "),
                  Text(responseUrl.toString()),
                ],
              ),
            ),
          );
        }
      case AuthenticationState.clientReady:
        {
          return Scaffold(
            appBar: AppBar(
              title: const Text('First authentication to Strava'),
            ),
            body: const Center(
              child: Text("We got the client !!!"),
            ),
          );
        }
      case AuthenticationState.requestCanceled:
        {
          return Scaffold(
            appBar: AppBar(
              title: const Text('First authentication to Strava'),
            ),
            body: const Center(
              child: Text("You will need to accept you know..."),
            ),
          );
        }
    }
  }
}

// TODO: try with oauth2_client instead ???
