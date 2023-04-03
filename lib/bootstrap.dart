import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:my_sport_map/app/app.dart';
import 'package:my_sport_map/app/app_bloc_observer.dart';

void bootstrap({required String clientId, required String secret}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  runZonedGuarded(
    () => runApp(
      MySportMapApp(
        clientId: clientId,
        secret: secret,
      ),
    ),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}

// Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
//   FlutterError.onError = (details) {
//     log(details.exceptionAsString(), stackTrace: details.stack);
//   };

//   Bloc.observer = const AppBlocObserver();

//   await runZonedGuarded(
//     () async => runApp(await builder()),
//     (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
//   );
// }
