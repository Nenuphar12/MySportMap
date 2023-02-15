part of 'client_cubit.dart';

enum ClientStatus {
  ready, // The client is functional and loaded.
  needAuthentication, // The client as never been authenticated (need it again ?).
  appStarting, // The app is starting, search for stored client.
}

/// The state of the client used to access Strava's API.
class ClientState extends Equatable {
  const ClientState({this.status = ClientStatus.appStarting, this.client});

  /// The status of the [client].
  final ClientStatus status;

  /// The web client to access Strava's API.
  final oauth2.Client? client; // TODO no need for it to be null ?

  // TODO only need status ? Client is never changed alone ?
  @override
  // TODO problems, the changes are not detected ? Lexico ???
  List<Object?> get props => [status, client?.credentials.toJson()];
  //List<Object?> get props => [status];
}
