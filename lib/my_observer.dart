import 'package:bloc/bloc.dart';

class MyObserver extends BlocObserver {
  MyObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}
