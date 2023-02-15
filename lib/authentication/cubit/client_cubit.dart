import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:shared_preferences/shared_preferences.dart';

part 'client_state.dart';

/// {@template client_cubit}
/// A [Cubit] which manages a [client] and a [status] as its state.
/// {@endemplate}
class ClientCubit extends Cubit<ClientState> {
  /// {@macro client_cubit}
  ClientCubit() : super(const ClientState());

  /// Initialize or update the [client].
  ///
  /// The [status] is updated to [ClientStatus.ready] and the new
  /// [client.credentials] are saved into the shared preferences.
  /// The new [state] is emited.
  void setClient(oauth2.Client newClient) {
    print('[call] setClient()');
    emit(ClientState(client: newClient, status: ClientStatus.ready));

    // TODO : good place for that ?
    // Save credentials into shared preferences
    final prefs = SharedPreferences.getInstance();
    prefs.then((valuePref) {
      valuePref.setString("credentials", newClient.credentials.toJson());
    });
  }

  /// Set the [status] of the current state.
  void setStatus(ClientStatus newStatus) {
    print('[call] setStatus()');
    emit(ClientState(client: state.client, status: newStatus));
  }
}
