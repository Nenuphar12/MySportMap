part of 'client_cubit.dart';

enum ClientStatus {
  ready,
  notLoaded,
  notCreated,
  notReady,
  notAuthenticated,
  authenticated,
}

class ClientState {
  ClientState({this.status = ClientStatus.notReady, this.client});

  ClientStatus status;
  oauth2.Client? client;
}
