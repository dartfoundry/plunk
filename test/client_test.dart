import 'package:plunk/src/client/client.dart';
import 'package:plunk/src/client/interceptor.dart';
import 'package:plunk/src/client/request.dart';
import 'package:plunk/src/client/request_method.dart';
import 'package:plunk/src/client/response.dart';
import 'package:test/test.dart';

void main() {
  group('Client tests', () {
    test('interceptor should modify request', () async {
      const originalUrl = 'https://example.com/api';
      const modifiedUrl = 'https://modified.com/api';

      const request = Request(
        method: RequestMethod.get,
        url: originalUrl,
      );

      final interceptor = Interceptor(
        onModifyRequest: (_, req) async => const Request(
          url: modifiedUrl,
        ),
      );

      // Test the interceptor directly
      final modifiedRequest = await interceptor.modifyRequest(
        Client(interceptor: interceptor),
        request,
      );

      expect(modifiedRequest.url, equals(modifiedUrl));
    });

    test('interceptor should intercept request', () async {
      const request = Request(
        method: RequestMethod.get,
        url: 'https://example.com/api',
      );

      final interceptor = Interceptor(
        onInterceptRequest: (_, __) async => const Response(
          body: {'intercepted': true},
          headers: {'content-type': 'application/json'},
          statusCode: 200,
        ),
      );

      // Test the interceptor directly
      final response = await interceptor.interceptRequest(
        Client(interceptor: interceptor),
        request,
      );

      expect(response, isNotNull);
      expect(response?.body, isA<Map>());
      expect(response?.body['intercepted'], isTrue);
      expect(response?.statusCode, equals(200));
    });

    test('interceptor should modify response', () async {
      const request = Request(
        method: RequestMethod.get,
        url: 'https://example.com/api',
      );

      const originalResponse = Response(
        body: {'original': true},
        headers: {'content-type': 'application/json'},
        statusCode: 200,
      );

      final interceptor = Interceptor(
        onModifyResponse: (_, __, ___) async => const Response(
          body: {'modified': true},
          headers: {'content-type': 'application/json'},
          statusCode: 201,
        ),
      );

      // Test the interceptor directly
      final modifiedResponse = await interceptor.modifyResponse(
        Client(interceptor: interceptor),
        request,
        originalResponse,
      );

      expect(modifiedResponse, isNotNull);
      expect(modifiedResponse.body, isA<Map>());
      expect(modifiedResponse.body['modified'], isTrue);
      expect(modifiedResponse.statusCode, equals(201));
    });
  });
}
