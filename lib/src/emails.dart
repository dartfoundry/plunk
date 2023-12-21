/*
Sending transactional emails
*/

part of 'package:plunk/plunk.dart';

class Contact {
  String? id;
  String? address;
  String? email;

  Contact({this.id, this.address, this.email});

  factory Contact.fromJson(String payload) =>
      Contact.fromMap(jsonDecode(payload));

  factory Contact.fromMap(Map<String, dynamic> map) => Contact(
        id: map['contact']['id'],
        address: map['contact']['email'],
        email: map['email'],
      );
}

class SendRequest {
  static const resourcePath = 'send';

  String from, subject, body;
  List<String> to;
  String? name;

  SendRequest({
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

class SendResponse {
  bool? success;
  List<Contact>? emails;
  DateTime? timestamp;

  SendResponse({
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

class SubscriptionResponse {
  bool? success;
  String? contact;
  bool? subscribed;

  SubscriptionResponse({
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
