/*
  Contacts

  Your contacts are all users, subscribers and customers that are present in 
  your Plunk dashboard. They will automatically be added to your Plunk account 
  when they trigger an event on your website or app.
*/

part of 'package:plunk/plunk.dart';

/// Class used to wrap a json request for a contact.
class ContactRequest {
  static const resourcePath = 'contacts';

  final bool? subscribed;

  /// The ID of the contact. If the contact already exists, the ID will be
  /// returned. If the contact is new, a new ID will be generated.
  final String? id;

  /// The email of the contact.
  final String? email;

  final Map<String, dynamic>? data;

  const ContactRequest({this.id, this.email, this.subscribed, this.data});

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'subscribed': subscribed,
        'data': data,
      };
}

/// Class used to unwrap a json response from a [ContactRequest].
class ContactResponse {
  final bool? subscribed, success;
  final String? email, id;
  final Map<String, dynamic>? data;
  final DateTime? createdAt, updatedAt;

  const ContactResponse({
    this.success,
    this.id,
    this.email,
    this.subscribed,
    this.data,
    this.createdAt,
    this.updatedAt,
  });

  factory ContactResponse.fromJson(String payload) =>
      ContactResponse.fromMap(jsonDecode(payload));

  factory ContactResponse.fromMap(Map<String, dynamic> map) => ContactResponse(
        success: map['success'],
        id: map['id'],
        email: map['email'],
        subscribed: map['subscribed'],
        data: map['data'],
        createdAt: DateTime.tryParse(map['createdAt']),
        updatedAt: DateTime.tryParse(map['updatedAt']),
      );
}
