import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'client_state.dart';

/// {@template client_cubit}
/// A [Cubit] which manages a [ClientState] as its state.
/// {@endtemplate}
class ClientCubit extends Cubit<ClientState> {
  /// {@macro client_cubit}
  ClientCubit() : super(const ClientState());

  /// Change the state to a newState.
  void setClientStatus(ClientStatus newStatus) =>
      emit(ClientState(status: newStatus));
}
