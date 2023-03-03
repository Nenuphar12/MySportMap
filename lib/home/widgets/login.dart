import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:my_sport_map/authentication/cubit/client_cubit.dart';
import 'package:my_sport_map/utilities/utilities.dart';
import 'package:strava_repository/strava_repository.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  void _login(BuildContext context) {
    // If authorization is needed login, else disable the button.
    if (context.read<ClientCubit>().state == ClientState.notAuthorized) {
      context.read<StravaRepository>().authenticate().then(
          (value) => context.read<ClientCubit>().setState(ClientState.ready));
    }
  }

  void _deAuth(BuildContext context) {
    // TEST
    logger.v('[call] testDeauth() - start');
    // END_TEST
    context.read<StravaRepository>().deAuthorize().then((value) {
      logger.v('[_testDeauth] Deauthorization successful (?)');
      // Update the [ClientCubit].
      context.read<ClientCubit>().setState(ClientState.notAuthorized);
    }); // TODO : catch error !!!
    // TEST
    logger.v('[call] testDeauth() - end');
    // END_TEST
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => _login(context),
                child: const Text("Login With Strava"),
              ),
              ElevatedButton(
                onPressed: () => _deAuth(context),
                child: const Text("De Authorize"),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          // TODO : usefull ??? What is this ?
          const Divider()
        ],
      );
    });
  }

  void testAuthentication(BuildContext context) {
    context.read<StravaRepository>().authenticate();
  }
}
