part of 'client_cubit.dart';

enum ClientStatus {
  ready, // The client is functional and loaded.
  notAuthorized, // The client as not been authorized
  appStarting, // The app is starting, search for stored client.
}

class ClientState extends Equatable {
  const ClientState({
    this.status = ClientStatus.appStarting,
  });

  final ClientStatus status;

  @override
  List<Object> get props => [status];
}
