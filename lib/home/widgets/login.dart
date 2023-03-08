import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sport_map/home/cubit/client_cubit.dart';
import 'package:my_sport_map/utilities/utilities.dart';
import 'package:strava_repository/strava_repository.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  void _login(BuildContext context) {
    // If authorization is needed login, else disable the button and display
    // an informative SnackBar.
    if (context.read<ClientCubit>().state == ClientState.notAuthorized) {
      context.read<StravaRepository>().authenticate().then(
            (value) =>
                context.read<ClientCubit>().setCubitState(ClientState.ready),
          );
    } else {
      const snackBar = SnackBar(content: Text('You are already logged in.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _deAuth(BuildContext context) {
    // If logged in de-authorize, else disable the button and display an
    // informative SnackBar.
    if (context.read<ClientCubit>().state == ClientState.ready) {
      context.read<StravaRepository>().deAuthorize().then((value) {
        logger.v('[_testDeauth] Deauthorization successful (?)');
        // Update the [ClientCubit].
        context.read<ClientCubit>().setCubitState(ClientState.notAuthorized);
      });
    } else {
      const snackBar = SnackBar(content: Text('You need to login first.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.d('Build login');
    return Builder(
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _login(context),
                  child: const Text('Login With Strava'),
                ),
                ElevatedButton(
                  onPressed: () => _deAuth(context),
                  child: const Text('De Authorize'),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        );
      },
    );
  }
}
