/*
  Classes for managing campaigns.
*/

part of 'package:plunk/plunk.dart';

enum CampaignStyle { plunk, html }

/// Class used to wrap a json request to create a campaign.
class CampaignRequest {
  static const resourcePath = 'campaigns';

  final String? id;
  final String body, subject;
  final List<String> recipients;
  final CampaignStyle style;

  const CampaignRequest({
    required this.subject,
    required this.body,
    required this.recipients,
    this.style = CampaignStyle.plunk,
    this.id,
  });

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() => {
        'id': id,
        'subject': subject,
        'body': body,
        'recipients': recipients,
        'style': style.name.toUpperCase(),
      };
}

/// Class used to unwrap campaign embedded as json in a [CampaignResponse].
class CampaignResponse {
  /// The subject of the campaign.
  final String? subject;

  /// The body of the campaign.
  final String? body;

  /// An array of contact IDs or emails to send the campaign to.
  final List<String>? recipients;

  /// Whether the campaign is a PLUNK template or HTML email.
  final CampaignStyle style;

  final String? id;
  final String? projectId;
  final String? delivered;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CampaignResponse({
    required this.subject,
    required this.body,
    this.recipients,
    this.style = CampaignStyle.plunk,
    this.id,
    this.projectId,
    this.delivered,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory CampaignResponse.fromJson(String payload) =>
      CampaignResponse.fromMap(jsonDecode(payload));

  factory CampaignResponse.fromMap(Map<String, dynamic> map) =>
      CampaignResponse(
        id: map['id'],
        subject: map['subject'],
        body: map['body'],
        status: map['status'],
        delivered: map['delivered'],
        style:
            CampaignStyle.values.byName(map['style'].toString().toLowerCase()),
        projectId: map['projectId'],
        createdAt: DateTime.tryParse(map['createdAt']),
        updatedAt: DateTime.tryParse(map['updatedAt']),
      );
}
