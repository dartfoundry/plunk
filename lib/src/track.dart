/*
Events

Events are the power behind Plunk's email marketing automations. 
They are the triggers that start your automations. 
Events are triggered by a user's actions on your site, such as 
signing up for your newsletter, or making a purchase.
*/

part of plunk;

class TrackRequest {
  static const resourcePath = 'track';

  String? email, event;

  TrackRequest({this.email, this.event});

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() => {'email': email, 'event': event};
}

class TrackResponse {
  bool? success;
  String? contact;
  String? event;
  DateTime? timestamp;

  TrackResponse({
    this.success,
    this.contact,
    this.event,
    this.timestamp,
  });

  factory TrackResponse.fromJson(String payload) =>
      TrackResponse.fromMap(jsonDecode(payload));

  factory TrackResponse.fromMap(Map<String, dynamic> map) => TrackResponse(
        contact: map['contact'],
        event: map['event'],
        success: map['success'],
        timestamp: DateTime.tryParse(map['timestamp']),
      );
}
