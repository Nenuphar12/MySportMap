part of 'client_cubit.dart';

class ClientState extends Equatable {
  const ClientState({
    this.status = ClientStatus.appStarting,
  });

  final ClientStatus status;

  @override
  List<Object> get props => [status];

  /// Whether the app is starting. The client state is not known yet.
  bool isAppStarting() => status == ClientStatus.appStarting;

  /// Whether the client is ready.
  bool isReady() => status == ClientStatus.ready;

  /// Whether the client is not authorized.
  bool isNotAuthorized() => status == ClientStatus.notAuthorized;
}

enum ClientStatus {
  ready, // The client is functional and loaded.
  notAuthorized, // The client as not been authorized
  appStarting, // The app is starting, search for stored client.
}
