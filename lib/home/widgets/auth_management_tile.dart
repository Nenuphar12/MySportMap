import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sport_map/home/cubit/client_cubit.dart';
import 'package:my_sport_map/utilities/my_utilities.dart';
import 'package:strava_repository/strava_repository.dart';

class AuthManagementTile extends StatelessWidget {
  const AuthManagementTile({required this.isLoggedIn, super.key});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    MyUtilities.logger.v('[Build] AuthManagementTile');
    if (isLoggedIn) {
      return ListTile(
        key: const Key('authManagement_loggedIn_ListTile'),
        leading: const Icon(
          Icons.toggle_on,
          color: Colors.green,
        ),
        title: const Text('Logout of Strava'),
        onTap: () => _deAuth(context),
      );
    } else {
      return ListTile(
        key: const Key('authManagement_notLoggedIn_ListTile'),
        leading: const Icon(
          Icons.toggle_off,
          color: Colors.red,
        ),
        title: const Text('Login with Strava'),
        onTap: () => _login(context),
      );
    }
  }

  void _login(BuildContext context) {
    // If authorization is needed login.
    context.read<StravaRepository>().authenticate().then((value) {
      MyUtilities.logger.v('[_login] login successful');
      context.read<ClientCubit>().setClientStatus(ClientStatus.ready);
    });
  }

  void _deAuth(BuildContext context) {
    // If logged in de-authorize.
    context.read<StravaRepository>().deAuthorize().then((value) {
      MyUtilities.logger.v('[_deAuth] de authorization successful (?)');
      // Update the [ClientCubit].
      context.read<ClientCubit>().setClientStatus(ClientStatus.notAuthorized);
    });
  }
}
