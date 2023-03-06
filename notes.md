
# Random notes

## My Roadmap

- First very basic release
- add colors !
- add splash screen (manage loading activities)
- release android version
- add tests

### TODO before public

- remove api key (google maps)
- remove secret file
- clean all (?)
- remove this part

## Best practices

### Logging

- (LogRocket - Flutter logging best practices)[https://blog.logrocket.com/flutter-logging-best-practices/]

## Process of authentication - Strava

1. Request code (here)[https://www.strava.com/oauth/mobile/authoriz] (function `_getStravaCode`)
2. Request token in exchange for the code (function `_requestNewAccessToken`)

## Strava_flutter improvements !

- Add documentation

### Url callbacks

Difference between callback and redirect !

### In manifest !

New activity ! Like in Flutter_web_auth !

### Random

TODO : instead of changing strava_flutter, catch errors ???

- If you do a request without token, even deAuth, an error will be thrown !
- Same, if you try a request without token => error

Add this in the doc or fix it so it does not append. Or more explicit error ?

- What if I try to connect two times in a row ?

- Use encrypted shared preferences for storing api token (?)

- not load from shared pref every time ? (we don't care ?)

## For development :

- https://stackoverflow.com/questions/58679233/how-to-change-company-domain-name-in-flutter
