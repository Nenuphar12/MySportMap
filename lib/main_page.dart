import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sport_map/authentication/cubit/client_cubit.dart';
import 'package:my_sport_map/authentication/view/authentication_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

import 'secret.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  // TODO check if basic auth is okay with client

  @override
  Widget build(BuildContext context) {
    //context.read<ClientCubit>().onError();
    return BlocBuilder<ClientCubit, ClientState>(builder: (context, state) {
      //if (gotTheClient) {
      if (state.status == ClientStatus.ready) {
        print("WE GOT THE CLIENT");
      }
      // Check if we need authentication
      //if (needAuthentication) {
      if (state.status == ClientStatus.notAuthenticated) {
        // Authenticate to get access to your strava data
        return MaterialApp(
          home: AuthenticationPage(),
        );
      }
      // Check the client
      //if (stravaApiClient == null) {
      //if (state.client == null) {
      if (state.status == ClientStatus.appStarting) {
        // TODO
        // To load my client if it exists
        final prefs = SharedPreferences.getInstance();
        prefs.then((value) {
          String? jsonCredentials = value.getString("credentials");
          // TODO tempo
          //jsonCredentials = null;
          if (jsonCredentials == null) {
            // TODO : create credentials
            state.status = ClientStatus.notAuthenticated;
            //setState(() {
            //  needAuthentication = true;
            //});
          } else {
            // TODO : load credentials into client
            var clientCredentials =
                oauth2.Credentials.fromJson(jsonCredentials);
            var newClient = oauth2.Client(clientCredentials,
                identifier: clientId, secret: clientSecret);
            context.read<ClientCubit>().setClient(
                  newClient,
                ); // TODO: need a specific status or always "ready" ?
            //state.client = oauth2.Client(clientCredentials,
            //    identifier: clientId, secret: clientSecret);
            //state.status = ClientStatus.ready;

            //setState(() {
            //  stravaApiClient = oauth2.Client(clientCredentials,
            //      identifier: clientId, secret: clientSecret);
            //});
          }
        });
      }
      return MaterialApp(
          home: Scaffold(
        appBar: AppBar(
          title: const Text("Flutter Strava Plugin"),
          actions: [
            Icon(
              //isLoggedIn
              true
                  ? Icons.radio_button_checked_outlined
                  : Icons.radio_button_off,
              //color: isLoggedIn ? Colors.white : Colors.red,
              color: true ? Colors.white : Colors.red,
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
      // TODO tempo
      return Container();
    });
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
                  //Navigator.push(
                  //    context,
                  //    MaterialPageRoute(
                  //        builder: (context) => AuthenticationPage()));
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
            //controller: _textEditingController,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: const Text("Access Token"),
                suffixIcon: TextButton(
                  child: const Text("Copy"),
                  onPressed: () {
                    // TODO ?
                    //FlutterClipboard.copy(_textEditingController.text).then(
                    //    ((value) => ScaffoldMessenger.of(context).showSnackBar(
                    //        const SnackBar(content: Text("Copied !")))));
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
      //ignoring: !isLoggedIn,
      ignoring: false,
      child: AnimatedOpacity(
        //opacity: isLoggedIn ? 1.0 : 0.4,
        opacity: true ? 1.0 : 0.4,
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

  void testDeauth() {
    // TODO: implement testDeauth
    print("[call] testDeauth()");
  }
}

class StravaAccount {
  // From here : https://www.strava.com/settings/api
  String clientId = '100668';
  String clientSecret = 'c043f4ba922e8f079b1189f0d6c9f02b221c1e85';

  StravaAccount({
    required this.clientId,
    required this.clientSecret,
  });
}
