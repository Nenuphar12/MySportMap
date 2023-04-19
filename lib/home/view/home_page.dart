import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sport_map/home/cubit/client_cubit.dart';
import 'package:my_sport_map/home/cubit/settings_cubit.dart';
import 'package:my_sport_map/home/widgets/widgets.dart';
import 'package:my_sport_map/utilities/utilities.dart';

/// {@template home_page}
/// A [StatelessWidget] which is responsible for providing a [ClientCubit]
/// instance to the [HomeView].
/// {@endtemplate}
class HomePage extends StatelessWidget {
  /// {@macro home_page}
  const HomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return const HomeView();
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
    return BlocProvider(
      create: (_) => SettingsCubit(),
      child: BlocBuilder<ClientCubit, ClientState>(
        builder: (context, state) {
          logger.v('Building home_page');

          final isLoggedIn = state.isReady();

          // Display the Home page.
          return Scaffold(
            appBar: AppBar(
              title: const Text('My sport map'),
              actions: [
                if (isLoggedIn)
                  const Icon(
                    Icons.radio_button_checked_outlined,
                    color: Colors.white,
                  )
                else
                  const Icon(
                    Icons.radio_button_off,
                    color: Colors.red,
                  ),
                const SizedBox(
                  width: 8,
                )
              ],
            ),
            drawer: HomePageDrawer(isLoggedIn: isLoggedIn),
            body: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                return state.mapType == MyMapTypes.flutterMap
                    ? MyFlutterMap(isClientReady: isLoggedIn)
                    : MyGoogleMap(isClientReady: isLoggedIn);
              },
            ),
          );
        },
      ),
    );
  }
}
