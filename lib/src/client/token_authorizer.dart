import 'package:http/http.dart' as http;

/// Authorizor to provide `Bearer` tokents.
final class TokenAuthorizer {
  /// Constructs the authorizer with the given token to pass to the back end.
  TokenAuthorizer({
    required this.token,
  });

  final String token;

  /// Attaches the token as a `Bearer` token to the `authorization` header.
  Future<void> secure(http.Request httpRequest) async {
    httpRequest.headers['authorization'] = 'Bearer $token';
  }
}
