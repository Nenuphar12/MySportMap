import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'STRAVA_CLIENT_ID', obfuscate: true)
  static final String stravaClientId = _Env.stravaClientId;

  @EnviedField(varName: 'STRAVA_CLIENT_SECRET', obfuscate: true)
  static final String stravaClientSecret = _Env.stravaClientSecret;
}
