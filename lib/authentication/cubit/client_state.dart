part of 'client_cubit.dart';

enum ClientState {
  ready, // The client is functional and loaded.
  notAuthorized, // The client as not been authorized
  appStarting, // The app is starting, search for stored client.
}
