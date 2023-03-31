import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sport_map/home/cubit/client_cubit.dart';
import 'package:my_sport_map/utilities/utilities.dart';
import 'package:strava_repository/strava_repository.dart';

class AuthManagementButtons extends StatelessWidget {
  const AuthManagementButtons({super.key});

  @override
  Widget build(BuildContext context) {
    logger.v('Build AuthManagementButtons');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        LoginButton(),
        DeAuthButton(),
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: const Key('loginButton_login_elevatedButton'),
      onPressed: () => _login(context),
      child: const Text('Login with Strava'),
    );
  }

  void _login(BuildContext context) {
    // If authorization is needed login, else disable the button and display
    // an informative SnackBar.
    if (context.read<ClientCubit>().state.isNotAuthorized()) {
      context.read<StravaRepository>().authenticate().then(
            (value) =>
                context.read<ClientCubit>().setClientStatus(ClientStatus.ready),
          );
    } else {
      const snackBar = SnackBar(content: Text('You are already logged in.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

class DeAuthButton extends StatelessWidget {
  const DeAuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: const Key('deAuthButton_deAuth_elevatedButton'),
      onPressed: () => _deAuth(context),
      child: const Text('De Authorize'),
    );
  }

  void _deAuth(BuildContext context) {
    // If logged in de-authorize, else disable the button and display an
    // informative SnackBar.
    if (context.read<ClientCubit>().state.isReady()) {
      context.read<StravaRepository>().deAuthorize().then((value) {
        logger.v('[_deAuth] de authorization successful (?)');
        // Update the [ClientCubit].
        context.read<ClientCubit>().setClientStatus(ClientStatus.notAuthorized);
      });
    } else {
      const snackBar = SnackBar(content: Text('You need to login first.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
