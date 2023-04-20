import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_sport_map/utilities/utilities.dart';
import 'package:strava_repository/strava_repository.dart';

part 'client_state.dart';

/// {@template client_cubit}
/// A [Cubit] which manages a [ClientState] as its state.
/// {@endtemplate}
class ClientCubit extends Cubit<ClientState> {
  /// {@macro client_cubit}
  ///
  /// During initialization, checks if the user is already logged in with
  /// the provided [StravaRepository].
  ClientCubit({required StravaRepository stravaRepository})
      : super(const ClientState()) {
    // Check if user is already logged in.
    stravaRepository.isAuthenticatedCompleter.future.then((isAuthenticated) {
      logger.v('Already Authenticated : $isAuthenticated');
      setClientStatus(
        isAuthenticated ? ClientStatus.ready : ClientStatus.notAuthorized,
      );
    });
    // stravaRepository.isAuthenticated().then((isAuthenticated) {
    //   logger.v('Already Authenticated : $isAuthenticated');
    //   setClientStatus(
    //     isAuthenticated ? ClientStatus.ready : ClientStatus.notAuthorized,
    //   );
    // });
  }

  /// Change the state to a newState.
  void setClientStatus(ClientStatus newStatus) =>
      emit(ClientState(status: newStatus));
}
