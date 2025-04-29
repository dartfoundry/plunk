/*
  Classes for sending transactional emails.
*/

part of 'package:plunk/plunk.dart';

/// Class used to unwrap contacts embedded as json in a [SendResponse].
class Contact {
  final String? id;
  final String? address;
  final String? email;

  const Contact({this.id, this.address, this.email});

  factory Contact.fromJson(String payload) =>
      Contact.fromMap(jsonDecode(payload));

  factory Contact.fromMap(Map<String, dynamic> map) => Contact(
        id: map['contact']['id'],
        address: map['contact']['email'],
        email: map['email'],
      );
}

/// Class used to wrap a json request to send transactional email.
class SendRequest {
  static const resourcePath = 'send';

  final String body, subject;
  final String? from, name, reply;
  final List<String> to;
  final bool subscribed;
  final Map<String, dynamic> headers;

  const SendRequest({
    required this.to,
    required this.subject,
    required this.body,
    this.subscribed = false,
    this.name,
    this.from,
    this.reply,
    this.headers = const <String, dynamic>{},
  });

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() => {
        'to': to,
        'subject': subject,
        'body': body,
        'subscribed': subscribed,
        'name': name,
        'from': from,
        'reply': reply,
        'headers': headers,
      };
}

/// Class used to unwrap a json response from a [SendRequest].
class SendResponse {
  /// Indicates whether the call was successful.
  final bool? success;

  /// The list of contacts and the email identifiers sent to.
  final List<Email>? emails;

  /// The timestamp of the event.
  final DateTime? timestamp;

  const SendResponse({
    this.success,
    this.emails,
    this.timestamp,
  });

  factory SendResponse.fromJson(String payload) =>
      SendResponse.fromMap(jsonDecode(payload));

  factory SendResponse.fromMap(Map<String, dynamic> map) => SendResponse(
        success: map['success'],
        emails: List<Email>.from(
          map['emails'].map((email) => Email.fromMap(email)),
        ).toList(),
        timestamp: DateTime.tryParse(map['timestamp']),
      );
}

class Email {
  /// The contact the email was sent to.
  final Contact? contact;

  /// The ID of the email.
  final String? email;

  const Email({
    this.contact,
    this.email,
  });

  factory Email.fromMap(Map<String, dynamic> map) => Email(
        contact: Contact.fromMap(map['contact']),
        email: map['email'],
      );
}

/// Class used to unwrap a json response from a subscribe or unsubscribe request.
class SubscriptionResponse {
  final bool? subscribed, success;
  final String? contact;

  const SubscriptionResponse({
    this.success,
    this.contact,
    this.subscribed,
  });

  factory SubscriptionResponse.fromJson(String payload) =>
      SubscriptionResponse.fromMap(jsonDecode(payload));

  factory SubscriptionResponse.fromMap(Map<String, dynamic> map) =>
      SubscriptionResponse(
        success: map['success'],
        contact: map['contact'],
        subscribed: map['subscribed'],
      );
}
