
# Roadmap for the project

## Before release

- [] Code commented
- [] Tests added for new code parts
- [] No error, no warning
- [] Update version
- [] Secrets and API key removed
- [] Generate changelog

## Features

- new feature: implement splash screen [in process]
- new feature: center map on current position [planned]
- new feature: add short message when polylines loaded [planned]
- new feature: add colors for activities types [done]
- new feature: implement `commitlint` [done]
- CI: integrate `git-cliff` in CI [planned]
- new feature: add rotation to the flutter_map (create plugin) [planned]

## Improvements

- move: move from google maps to flutter_map ? [planned]
- improvement: remove local strava_client and use the "real" one [planned]
- improvement: add exceptions int `strava_repository.dart` [planned]
- improvement: clean my models to the bare minimum [done]
- improvement: better management of errors thrown by strava_client [planned]
- improvement? remove polylines when de authorizing [planned]
- improvement: remove unnecessary functions from strava_repository model [planned]
- improvement: improve test coverage to 100% [planned]
- improvement: improve tests [planned]
- improvement: add chore to commitizen [planned]
- improvement: add a contribution section in the README (commitlint) [planned]
- improvement: find solution to allow very_good CI tests [done]
- change: change clientState to AuthenticationState ?
- substitution: change the custom function to decode polylines to GoogleMap function to do so [planned]
- clean: clean GM and FM versions to something clearer [planned]

## Bugs

- bug: if two phones on the same account, the refresh token could be wrong
  and then an error is thrown and the state stays as `appStarting` !
  [ // TODO ]
- bug? verification of not calling `context` in `build` method [planned]

## Documentation

- documentation: change version to v0.1.0 // TODO
- documentation: review and improve documentation [planned]

## Design

- design? how to manage the logs ? In utility file ? [planned]
- design? insert repository inside `ClientCubit` ? [planned]
- design? need to dispose of repository ? [planned]
- design? implement specific setter for cubit ? (setReady/setNotAuthorized) [planned]
- design? implement isReady and isNotAuthorized in cubit ? [planned]
- design? use streams for activities [?]
- design? `summaryPolylines` or `polylines` ? (polylines mostly empty ?) [planned]

## Cleaning

- cleaning: remove all "tests" [done] (?)
- cleaning: remove useless translation stuff [planned]
- cleaning: clean launcher icons ?
- do something for `LatLng` (do not import google_maps just for LatLng) (Have to use the one from `latlong2`) [planned]

---

## For *strava_client*

- new feature(strava_client): add `isLoggedIn` feature (load the token in the client if stored) [planned]
- documentation: add documentation [planned]

Inspiration: [appflowy roadmap documentation](https://appflowy.gitbook.io/docs/essential-documentation/roadmap)
