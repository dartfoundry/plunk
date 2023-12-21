part of 'package:plunk/plunk.dart';

class FieldError {
  String name;
  String description;

  FieldError({required this.name, required this.description});

  factory FieldError.fromJson(String str) =>
      FieldError.fromMap(json.decode(str));

  factory FieldError.fromMap(Map<String, dynamic> map) =>
      FieldError(name: map['field'], description: map['description']);
}

class PlunkException implements Exception {}

// HTTP 400
class PlunkInvalidRequestException extends PlunkException {
  String code;
  String message;
  List<FieldError>? fields;

  PlunkInvalidRequestException({
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

// HTTP 401
class PlunkAuthorizationException extends PlunkException {
  String code;
  String message;

  PlunkAuthorizationException({required this.code, required this.message});

  factory PlunkAuthorizationException.fromJson(String str) =>
      PlunkAuthorizationException.fromMap(json.decode(str));

  factory PlunkAuthorizationException.fromMap(Map<String, dynamic> map) =>
      PlunkAuthorizationException(code: map['code'], message: map['message']);
}

// HTTP 402
class PlunkQuotaException extends PlunkException {
  String code;
  String message;

  PlunkQuotaException({required this.code, required this.message});

  factory PlunkQuotaException.fromJson(String str) =>
      PlunkQuotaException.fromMap(json.decode(str));

  factory PlunkQuotaException.fromMap(Map<String, dynamic> map) =>
      PlunkQuotaException(code: map['code'], message: map['message']);
}

class PlunkUnknownException extends PlunkException {
  String code;
  String message;

  PlunkUnknownException({required this.code, required this.message});

  factory PlunkUnknownException.fromJson(String str) =>
      PlunkUnknownException.fromMap(json.decode(str));

  factory PlunkUnknownException.fromMap(Map<String, dynamic> map) =>
      PlunkUnknownException(code: map['code'], message: map['message']);
}
