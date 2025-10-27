import 'package:my_sport_map/bootstrap.dart';
import 'package:my_sport_map/env/env.dart';

void main() {
  bootstrap(clientId: Env.stravaClientId, secret: Env.stravaClientSecret);
}
