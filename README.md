# My Sport Map

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)

Small application to view all your Strava's activities on one map !

Generated by the [Very Good CLI][very_good_cli_link] 🤖

A Very Good Project created by Very Good CLI.

---

## Setup the project

Here are a few steps to setup the project.

### Add Google Maps API key

You will need to add your Google maps API key.

*Note:
You can find the full documentation to use Google Maps with Flutter
[HERE](https://codelabs.developers.google.com/codelabs/google-maps-in-flutter/).*

#### For Android

Add your Google Maps API key in `android\app\src\main\AndroidManifest.xml`.

```xml
<!-- TODO: Add your Google Maps API key here -->
<meta-data android:name="com.google.android.geo.API_KEY"
          android:value="YOUR-KEY-HERE" />
```

To get your API key, follow [these instructions](https://developers.google.com/maps/documentation/android-sdk/get-api-key).

### Setup Strava API

You will need to make an Application. According to [Strava
documentation](https://developers.strava.com/docs/getting-started/), follow
these steps :

1. If you have not already, go to https://www.strava.com/register and sign up for a Strava account.
2. After you are logged in, go to https://www.strava.com/settings/api and create an app.
3. You should see the “My API Application” page now. Set the following information :
  - Category: Visualizer
  - Authorization Callback Domain: redirect
  - Optional setup
    - Application name: my_sport_map
    - Application description: Flutter app to see all my activities on one map.

You will now copy your `Client ID` and `Client Secret` into a `lib/secret.dart`
file :

```dart
const String clientId = 'your-client-id';
const String clientSecret = 'your-client-secret';
```

---

## Getting Started 🚀

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

_\*My Sport Map as only been tested on Android at the moment._

### Building the app

To build the application run the following command from the project directory :
```sh
# Android AppBundle
$ flutter build appbundle -t lib/main_production.dart

# Android APK
$ flutter build apk -t lib/main_production.dart
```

Now you just have to login and enjoy all your outside activities !

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:my_sport_map/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli

---

## License

Distributed under the MIT license. See []`LICENSE.md`](https://github.com/Nenuphar12/MySportMap/blob/main/LICENSE.md) for more information.

---

## Acknowledgments

Thanks to [dreampowder](https://github.com/dreampowder/) for implementing
[strava_flutter](https://github.com/dreampowder/strava_flutter/), a Strava API
for Flutter.
