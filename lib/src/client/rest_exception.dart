import 'response.dart';

final class RestException implements Exception {
  const RestException({
    required this.message,
    required this.response,
  });

  final String message;
  final Response response;

  @override
  String toString() => 'RestException: $message';
}
