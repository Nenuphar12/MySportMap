
# Roadmap for the project

## Before release

- [x] Code commented
- [x] Tests added for new code parts
- [x] No error, no warning
- [x] Update version
- [x] Secrets and API key removed
- [x] Generate changelog

## Features

- new feature: implement splash screen [planned]
- new feature: center map on current position [planned]
- new feature: add short message when polylines loaded [planned]
- new feature: add colors for activities types [planned]
- new feature: implement `commitlint` [done]
- CI: integrate `git-cliff` in CI [planned]

## Improvements

- improvement: manage errors thrown by strava_client [planned]
- improvement? remove polylines when de authorizing [planned]
- improvement: remove unnecessary functions from strava_repository model [planned]
- improvement: improve tests [planned]
- improvement: add chore to commitizen [planned]
- improvement: add a contribution section in the README (commitlint) [planned]

## Bugs

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

- cleaning: remove all tests // TODO

---

## For *strava_client*

- new feature(strava_client): add `isLoggedIn` feature (load the token in the client if stored) [planned]
- documentation: add documentation [planned]

Inspiration: [appflowy roadmap documentation](https://appflowy.gitbook.io/docs/essential-documentation/roadmap)
