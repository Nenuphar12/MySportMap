import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_sport_map/home/cubit/activities_cubit.dart';
import 'package:my_sport_map/home/cubit/client_cubit.dart';
import 'package:my_sport_map/home/widgets/widgets.dart';
import 'package:my_sport_map/utilities/utilities.dart';
import 'package:strava_repository/strava_repository.dart';

/// {@template home_page}
/// A [StatelessWidget] which is responsible for providing an
/// [ActivitiesCubit] instance to the [HomeView].
/// {@endtemplate}
class HomePage extends StatelessWidget {
  /// {@macro home_page}
  const HomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final activitiesCubit = ActivitiesCubit(
          stravaRepository: context.read<StravaRepository>(),
        );
        if (context.read<ClientCubit>().state.isReady()) {
          unawaited(activitiesCubit.load());
        }
        return activitiesCubit;
      },
      child: const HomeView(),
    );
  }
}

/// {@template home_view}
/// A [StatelessWidget] which reacts to the provided [ClientCubit] state and
/// notifies it in response to authentication responses.
///
/// The activities are loaded when the user logs in and cleared when they log
/// out.
/// {@endtemplate}
class HomeView extends StatelessWidget {
  /// {@macro home_view}
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ClientCubit, ClientState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            final activitiesCubit = context.read<ActivitiesCubit>();
            if (state.isReady()) {
              unawaited(activitiesCubit.load());
            } else if (state.isNotAuthorized()) {
              activitiesCubit.clear();
            }
          },
        ),
        BlocListener<ActivitiesCubit, ActivitiesState>(
          listenWhen: (previous, current) =>
              previous.status != current.status &&
              current.status == ActivitiesStatus.failure,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Could not sync your activities with Strava.'),
              ),
            );
          },
        ),
      ],
      child: _buildScaffold(),
    );
  }

  Widget _buildScaffold() {
    return BlocBuilder<ClientCubit, ClientState>(
      builder: (context, state) {
        logger.t('Building home_page');

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
                const Icon(Icons.radio_button_off, color: Colors.red),
              const SizedBox(width: 8),
            ],
          ),
          drawer: HomePageDrawer(isLoggedIn: isLoggedIn),
          body: const MyMap(),
        );
      },
    );
  }
}
