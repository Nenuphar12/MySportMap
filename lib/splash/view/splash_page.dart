import 'package:flutter/material.dart';
import 'package:my_sport_map/utilities/utilities.dart';

/// Simple view rendered right when the app is launched while the app determines
/// whether the user is authenticated.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    logger.v('[Build] SplashPage');
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
