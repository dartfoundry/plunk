/*
  Events

  Events are the power behind Plunk's email marketing automations. 
  They are the triggers that start your automations. 
  Events are triggered by a user's actions on your site, such as 
  signing up for your newsletter, or making a purchase.
*/

part of 'package:plunk/plunk.dart';

/// Class used to wrap a json request to post a track event.
class TrackRequest {
  static const resourcePath = 'track';

  final String email, event;
  final bool subscribed;
  final Map<String, dynamic> data;

  const TrackRequest({
    required this.email,
    required this.event,
    this.subscribed = true,
    this.data = const <String, dynamic>{},
  });

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() => {
        'email': email,
        'event': event,
        'subscribed': subscribed,
        'data': data,
      };
}

/// Class used to unwrap a json response from a [TrackRequest].
class TrackResponse {
  final bool? success;
  final String? contact, event;
  final DateTime? timestamp;

  const TrackResponse({
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
