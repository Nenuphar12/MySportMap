import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

part 'client_state.dart';

class ClientCubit extends Cubit<ClientState> {
  ClientCubit() : super(ClientState());

  void setClient(oauth2.Client newClient) {
    state.client = newClient;
    state.status = ClientStatus.ready;
    emit(state);
  }

  void setStatus(ClientStatus newStatus) {
    state.status = newStatus;
    emit(state);
  }
}
