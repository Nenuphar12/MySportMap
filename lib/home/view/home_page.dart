import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sport_map/authentication/cubit/client_cubit.dart';
import 'package:my_sport_map/authentication/view/authentication_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

import '../../secret.dart';
import '../widgets/widgets.dart';

// TODO where to put this ?
const String apiEndpoint = "https://www.strava.com/api/v3/";

// TODO : restructruc doc + class (and files ?)

/// {@template home_page}
/// A [StatelessWidget] which is responsible for providing a [ClientCubit]
/// instance to the [HomeView].
/// {@endtemplate}
class HomePage extends StatelessWidget {
  /// {@macro home_page}
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => ClientCubit(), child: const HomeView());
  }
}

/// {@template home_view}
/// A [StatelessWidget] which reacts to the provided [ClientCubit] state and
/// notifies it in response to authentication responses.
/// {@endtemplate}
class HomeView extends StatelessWidget {
  /// {@macro home_view}
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientCubit, ClientState>(builder: (context, state) {
      switch (state.status) {

        // The client is ready and functional
        case ClientStatus.ready:
          print('WE GOT THE CLIENT (2)');
          // TODO : save client state after "changes" ?
          // TODO: Handle this case.
          break;

        // Need authentication
        case ClientStatus.needAuthentication:
          // Authenticate to get access to your strava data
          return const MaterialApp(
            home: AuthenticationPage(),
          );

        // Check the client when the app is starting
        case ClientStatus.appStarting:
          // To load my client if it exists
          final prefs = SharedPreferences.getInstance();
          prefs.then((value) {
            String? jsonCredentials = value.getString("credentials");
            // TODO tempo to test
            //jsonCredentials = null;
            if (jsonCredentials == null) {
              // Request creation of credentials
              context
                  .read<ClientCubit>()
                  .setStatus(ClientStatus.needAuthentication);
            } else {
              // Load credentials into client
              var clientCredentials =
                  oauth2.Credentials.fromJson(jsonCredentials);
              var newClient = oauth2.Client(clientCredentials,
                  identifier: clientId, secret: clientSecret, basicAuth: false);
              context.read<ClientCubit>().setClient(
                    newClient,
                  ); // TODO: need a specific status or always "ready" ?

            }
          });
          break;
      }

      var isLoggedIn = (state.status == ClientStatus.ready);

      // Display the Home page.
      return MaterialApp(
          home: Scaffold(
        appBar: AppBar(
          title: const Text("My sport map"),
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
            children: [
              const Login(),
              const Center(child: TestConnection()),
              ApiGroups(
                isLoggedIn: isLoggedIn,
              )
            ],
          ),
        ),
      ));
    });
  }
}
