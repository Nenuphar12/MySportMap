import 'package:bloc/bloc.dart';

part 'client_state.dart';

/// {@template client_cubit}
/// A [Cubit] which manages a [ClientState] as its state.
/// {@endemplate}
class ClientCubit extends Cubit<ClientState> {
  /// {@macro client_cubit}
  ClientCubit() : super(ClientState.appStarting);

  /// Change the state to a newState.
  void setCubitState(ClientState newState) => emit(newState);
}
