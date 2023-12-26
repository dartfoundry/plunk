/*
Sending transactional emails
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

  final String body, from, subject;
  final String? name;
  final List<String> to;

  const SendRequest({
    required this.from,
    required this.subject,
    required this.body,
    required this.to,
    this.name,
  });

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() => {
        'from': from,
        'subject': subject,
        'body': body,
        'to': to,
        'name': name,
      };
}

/// Class used to unwrap a json response from a [SendRequest].
class SendResponse {
  final bool? success;
  final List<Contact>? emails;
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
        emails: List<Contact>.from(
          map['emails'].map((email) => Contact.fromMap(email)),
        ).toList(),
        timestamp: DateTime.tryParse(map['timestamp']),
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
