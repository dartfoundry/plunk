part of 'package:plunk/plunk.dart';

/// Class wrapper for specific field errors used by
/// [PlunkInvalidRequestException].
class FieldError {
  final String name;
  final String description;

  const FieldError({required this.name, required this.description});

  factory FieldError.fromJson(String str) =>
      FieldError.fromMap(json.decode(str));

  factory FieldError.fromMap(Map<String, dynamic> map) =>
      FieldError(name: map['field'], description: map['description']);
}

/// Base exception class for Plunk.
class PlunkException implements Exception {
  const PlunkException();
}

/// Invalid Request Exceptions occurs when the response received
/// by a request is an HTTP 400 error.
class PlunkInvalidRequestException extends PlunkException {
  final String code, message;
  final List<FieldError>? fields;

  const PlunkInvalidRequestException({
    required this.code,
    required this.message,
    this.fields,
  });

  factory PlunkInvalidRequestException.fromJson(String str) =>
      PlunkInvalidRequestException.fromMap(json.decode(str));

  factory PlunkInvalidRequestException.fromMap(Map<String, dynamic> map) =>
      PlunkInvalidRequestException(
        code: map['code'],
        message: map['message'],
        fields: List<FieldError>.from(
          map['fields'].map((field) => FieldError.fromMap(field)),
        ),
      );
}

/// Authorization Exceptions occurs when the response received
/// by a request is an HTTP 401 error.
class PlunkAuthorizationException extends PlunkException {
  final String code;
  final String message;

  const PlunkAuthorizationException(
      {required this.code, required this.message});

  factory PlunkAuthorizationException.fromJson(String str) =>
      PlunkAuthorizationException.fromMap(json.decode(str));

  factory PlunkAuthorizationException.fromMap(Map<String, dynamic> map) =>
      PlunkAuthorizationException(code: map['code'], message: map['message']);
}

/// Exceed Quota Exceptions occurs when the response received
/// by a request is an HTTP 402 error.
class PlunkQuotaException extends PlunkException {
  final String code;
  final String message;

  const PlunkQuotaException({required this.code, required this.message});

  factory PlunkQuotaException.fromJson(String str) =>
      PlunkQuotaException.fromMap(json.decode(str));

  factory PlunkQuotaException.fromMap(Map<String, dynamic> map) =>
      PlunkQuotaException(code: map['code'], message: map['message']);
}

/// Exceed Quota Exceptions occurs when the response received
/// by a request is not an HTTP 400, 401 or 402 error.
class PlunkUnknownException extends PlunkException {
  final String code;
  final String message;

  const PlunkUnknownException({required this.code, required this.message});

  factory PlunkUnknownException.fromJson(String str) =>
      PlunkUnknownException.fromMap(json.decode(str));

  factory PlunkUnknownException.fromMap(Map<String, dynamic> map) =>
      PlunkUnknownException(code: map['code'], message: map['message']);
}
