import 'package:http/http.dart' as http;
import 'package:plunk/src/client/token_authorizer.dart';
import 'package:test/test.dart';

void main() {
  test('TokenAuthorizer.secure', () async {
    final authorizer = TokenAuthorizer(
      token: 'test_token',
    );

    final httpRequest = http.Request(
      'GET',
      Uri.parse('https://example.com/api'),
    );

    await authorizer.secure(httpRequest);

    expect(
      httpRequest.headers['authorization'],
      'Bearer test_token',
    );
  });

  test('TokenAuthorizer creates correct authorization header', () async {
    final authorizer = TokenAuthorizer(
      token: 'special_token_123',
    );

    final httpRequest = http.Request(
      'POST',
      Uri.parse('https://api.example.com/data'),
    );

    await authorizer.secure(httpRequest);

    expect(httpRequest.headers.containsKey('authorization'), isTrue);
    expect(httpRequest.headers['authorization'], equals('Bearer special_token_123'));
  });
}
