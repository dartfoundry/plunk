/*
Contacts

Your contacts are all users, subscribers and customers that are present in 
your Plunk dashboard. They will automatically be added to your Plunk account 
when they trigger an event on your website or app.
*/

part of plunk;

class ContactRequest {
  static const resourcePath = 'contacts';

  bool? subscribed;
  String? email;
  Map<String, dynamic>? data;

  ContactRequest({this.email, this.subscribed, this.data});

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() => {
        'email': email,
        'subscribed': subscribed,
        'data': data,
      };
}

class ContactResponse {
  bool? success;
  String? id;
  String? email;
  bool? subscribed;
  Map<String, dynamic>? data;
  DateTime? createdAt;
  DateTime? updatedAt;

  ContactResponse({
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
