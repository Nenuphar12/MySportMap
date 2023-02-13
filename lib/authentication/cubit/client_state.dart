part of 'client_cubit.dart';

enum ClientStatus {
  ready,
  notLoaded,
  notCreated,
  notReady,
  notAuthenticated,
  authenticated,
  appStarting,
}

class ClientState extends Equatable {
  ClientState({this.status = ClientStatus.appStarting, this.client});

  ClientStatus status;
  oauth2.Client? client;

  // TODO only need status ? Client is never changed alone ?
  @override
  List<Object?> get props => [status, client?.credentials.toJson()];
}
