import 'dart:async';

import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:strava_client/common/session_manager.dart';
import 'package:strava_client/data/repository/client.dart';
import 'package:strava_client/domain/model/model_authentication_response.dart';
import 'package:strava_client/domain/model/model_authentication_scopes.dart';
import 'package:strava_client/domain/model/model_fault.dart';
import 'package:strava_client/domain/repository/repository_authentication.dart';
import 'package:strava_client/common/injections.dart';

class RepositoryAuthenticationImpl extends RepositoryAuthentication {
  @override
  Future<TokenResponse> authenticate(
      {required List<AuthenticationScope> scopes,
        required String redirectUrl,
        bool forceShowingApproval = false,
        required String callbackUrlScheme}) async {
    var completer = Completer<TokenResponse>();
    var token = await sl<SessionManager>().getToken();
    if (token == null) {
      completer.complete(_completeAuthentication(
          scopes: scopes,
          forceShowingApproval: forceShowingApproval,
          redirectUrl: redirectUrl,
          callbackUrlScheme: callbackUrlScheme));
    } else {
      List<AuthenticationScope> oldScopes = AuthenticationScopeHelper.generateScopes(token.scopes ?? "");
      var isScopesAreSame = _compareScopes(oldScopes, scopes);
      if (isScopesAreSame) {
        if (sl<SessionManager>().isTokenExpired(token)) {
          _refreshAccessToken(sl<SessionManager>().clientId, sl<SessionManager>().secret, token.refreshToken)
              .then((refreshResult) {
            sl<SessionManager>()
                .setToken(
                scopes: scopes,
                token: TokenResponse(
                    tokenType: token.tokenType,
                    expiresAt: refreshResult.expiresAt,
                    expiresIn: refreshResult.expiresIn,
                    refreshToken: refreshResult.refreshToken,
                    accessToken: refreshResult.accessToken))
                .then((value) => completer.complete(refreshResult));
          }).onError((error, stackTrace) {
            completer.completeError(error!, stackTrace);
          });
        } else {
          completer.complete(token);
        }
      } else {
        ///Scopes have changed. we need a new token.
        completer.complete(_completeAuthentication(
            scopes: scopes,
            forceShowingApproval: forceShowingApproval,
            redirectUrl: redirectUrl,
            callbackUrlScheme: callbackUrlScheme));
      }
    }
    return completer.future;
  }

  Future<TokenResponse> _completeAuthentication(
      {required List<AuthenticationScope> scopes,
        required bool forceShowingApproval,
        required String redirectUrl,
        required String callbackUrlScheme}) {
    return _getStravaCode(
        redirectUrl: redirectUrl,
        scopes: scopes,
        forceShowingApproval: forceShowingApproval,
        callbackUrlScheme: callbackUrlScheme)
        .then((code) {
      return _requestNewAccessToken(sl<SessionManager>().clientId, sl<SessionManager>().secret, code).then((token) async {
        await sl<SessionManager>().setToken(token: token, scopes: scopes);
        return token;
      });
    });
  }

  /// RedirectUrl works best when it is a custom scheme. For example: strava://auth
  ///
  /// If your redirectUrl is, for exmaple, strava://auth then your callbackUrlScheme should be strava
  Future<String> _getStravaCode(
      {required String redirectUrl,
        required List<AuthenticationScope> scopes,
        required bool forceShowingApproval,
        required String callbackUrlScheme}) async {
    final Completer<String> completer = Completer<String>();
    final params =
        '?client_id=${sl<SessionManager>().clientId}&redirect_uri=$redirectUrl&response_type=code&approval_prompt=${forceShowingApproval ? "force" : "auto"}&scope=${AuthenticationScopeHelper.buildScopeString(scopes)}';

    const authorizationEndpoint = "https://www.strava.com/oauth/mobile/authorize";

    final reqAuth = authorizationEndpoint + params;
    try {
      final result = await FlutterWebAuth.authenticate(
        url: reqAuth,
        callbackUrlScheme: callbackUrlScheme,
      );

      final parsed = Uri.parse(result);

      final error = parsed.queryParameters['error'];
      final code = parsed.queryParameters['code'];
      if (error != null) {
        completer.completeError(Fault(errors: [], message: error));
      } else {
        completer.complete(code);
      }
    } catch (e) {
      completer.completeError(Fault(errors: [], message: e.toString()));
    }
    return completer.future;
  }

  Future<TokenResponse> _requestNewAccessToken(String clientID, String secret, String code) {
    return ApiClient.postRequest(
        endPoint: "/v3/oauth/token",
        queryParameters: {
          "client_id": clientID,
          "client_secret": secret,
          "code": code,
          "grant_type": "authorization_code",
        },
        dataConstructor: (data) => TokenResponse.fromJson(data));
  }

  Future<TokenResponse> _refreshAccessToken(String clientID, String secret, String refreshToken) {
    return ApiClient.postRequest<TokenResponse>(
        endPoint: "/v3/oauth/token",
        queryParameters: {
          "client_id": clientID,
          "client_secret": secret,
          "grant_type": "refresh_token",
          "refresh_token": refreshToken
        },
        dataConstructor: (data) => TokenResponse.fromJson(data));
  }

  bool _compareScopes(List<AuthenticationScope> left, List<AuthenticationScope> right) {
    if (left.length != right.length) {
      return false;
    }
    return left.every((element) => right.contains(element));
  }

  @override
  Future<void> deAuthorize() async {
    var token = await sl<SessionManager>().getToken();

    var params = {"access_token": token?.accessToken ?? ""};
    return ApiClient.postRequest(
        baseUrl: "https://www.strava.com/",
        endPoint: "/oauth/deauthorize",
        queryParameters: params,
        dataConstructor: (data) => null).whenComplete(() => sl<SessionManager>().logout());
  }
}
