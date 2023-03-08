import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sport_map/home/cubit/client_cubit.dart';
import 'package:my_sport_map/home/widgets/widgets.dart';
import 'package:my_sport_map/utilities/utilities.dart';
import 'package:strava_repository/strava_repository.dart';

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
    return BlocBuilder<ClientCubit, ClientState>(
      builder: (context, state) {
        logger.d('Building home_page');
        if (state == ClientState.appStarting) {
          // Check the client when the app is starting
          context
              .read<StravaRepository>()
              .isAuthenticated()
              .then((isAuthenticated) {
            logger.v('Already Authenticated : $isAuthenticated');
            context.read<ClientCubit>().setCubitState(
                  isAuthenticated
                      ? ClientState.ready
                      : ClientState.notAuthorized,
                );
          });
        }

        final isLoggedIn = state == ClientState.ready;

        // Display the Home page.
        return MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('My sport map'),
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
                  // Use of `UniqueKey` because these should be rebuild on every
                  // [ClientBloc] change.
                  Login(
                    key: UniqueKey(),
                  ),
                  //const Center(child: TestConnection()),
                  MyMap(
                    // key: UniqueKey(),
                    isClientReady: state == ClientState.ready,
                    // state: state,
                  ),
                  //ApiGroups(
                  //  isLoggedIn: isLoggedIn,
                  //)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
