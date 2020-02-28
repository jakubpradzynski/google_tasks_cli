import 'dart:convert';
import 'dart:io';

import 'package:googleapis/tasks/v1.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart';

class ApiAuthenticationService {
  String _clientId;
  String _clientSecret;
  String _credentialsFilePath;
  final _scopes = [TasksApi.TasksScope];

  ApiAuthenticationService(String clientId, String clientSecret, String credentialsFilePath) {
    _clientId = clientId;
    _clientSecret = clientSecret;
    _credentialsFilePath = credentialsFilePath;
  }

  ApiAuthenticationService.fromEnvironmentVariables() {
    _clientId = Platform.environment['GoogleApiClientId'];
    _clientSecret = Platform.environment['GoogleApiClientSecret'];
    _credentialsFilePath = Platform.environment['GoogleApiCredentialsFilePath'];
  }

  Future<AuthClient> getAuthorizedClient() => loadAuthClientFromFileOrOnline();

  Future<AuthClient> loadAuthClientFromFileOrOnline() {
    var credentials = File(_credentialsFilePath);
    if (credentials.existsSync()) {
      return _autoRefreshingClientFromFile(credentials);
    } else {
      return _newClientWithSavedCredentialsInFile(credentials);
    }
  }

  Future<AuthClient> _autoRefreshingClientFromFile(File credentials) {
    return Future.value(autoRefreshingClient(
        ClientId(_clientId, _clientSecret), _credentialsFromJson(credentials.readAsStringSync()), Client()));
  }

  Future<AutoRefreshingAuthClient> _newClientWithSavedCredentialsInFile(File credentials) {
    return clientViaUserConsent(ClientId(_clientId, _clientSecret), _scopes, _prompt)
      ..then((authClient) => {
            credentials.writeAsStringSync(_credentialsToJson(authClient.credentials),
                mode: FileMode.write, encoding: utf8, flush: true)
          });
  }

  String _credentialsToJson(AccessCredentials credentials) => jsonEncode({
        'accessToken': {
          'type': credentials.accessToken.type,
          'data': credentials.accessToken.data,
          'expiry': credentials.accessToken.expiry.toIso8601String()
        },
        'refreshToken': credentials.refreshToken,
        'idToken': credentials.idToken,
        'scopes': credentials.scopes
      });

  AccessCredentials _credentialsFromJson(String json) {
    var decodedJson = jsonDecode(json);
    return AccessCredentials(
        AccessToken(decodedJson['accessToken']['type'], decodedJson['accessToken']['data'],
            DateTime.parse(decodedJson['accessToken']['expiry'])),
        decodedJson['refreshToken'],
        List<String>.from(decodedJson['scopes']),
        idToken: decodedJson['idToken']);
  }

  void _prompt(String url) {
    print('Google Tasks CLI');
    print('Please go to the following URL and grant access:');
    print('=> $url');
  }
}
