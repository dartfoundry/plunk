library;

import 'dart:convert';

import 'package:plunk/src/client/response.dart';

import 'src/client/client.dart';
import 'src/client/request.dart';
import 'src/client/request_method.dart';
import 'src/client/token_authorizer.dart';

part 'src/campaigns.dart';
part 'src/contacts.dart';
part 'src/emails.dart';
part 'src/events.dart';
part 'src/exceptions.dart';

/// Primary API entry class. Instantiate this class to initialize an
/// API connection, then use it's methods to call API methods.
class Plunk {
  final String apiKey, apiVersion, baseUrl;
  final Duration timeout;
  final bool? useIsolate;

  final TokenAuthorizer _authorizer;
  final String _baseUrl;
  final Client _client;

  Plunk({
    required this.apiKey,
    this.apiVersion = 'v1',
    this.baseUrl = 'https://api.useplunk.com',
    this.timeout = const Duration(seconds: 60),
    this.useIsolate,
  })  : _authorizer = TokenAuthorizer(token: apiKey),
        _baseUrl = '$baseUrl/$apiVersion',
        _client = Client(timeout: timeout, useIsolate: useIsolate);

  // Protected method that can be overridden in tests
  // ignore: unused_element
  Future<Response> _executeRequest(Request request) async {
    return _client.execute(
      authorizer: _authorizer,
      request: request,
    );
  }

  /// Gets the details of a specific contact.
  /// This endpoint can only be accessed with a secret API key.
  /// Returns a [ContactResponse] object containing the contact's
  /// details.
  Future<ContactResponse> getContact({required String id}) async {
    if (id.isEmpty) {
      throw PlunkInvalidRequestException(
        code: '404',
        message: 'Invalid contactId parameter',
      );
    }

    final request = Request(
      method: RequestMethod.get,
      url: '$_baseUrl/${ContactRequest.resourcePath}/$id',
    );

    final response = await _client.execute(
      authorizer: _authorizer,
      request: request,
    );

    switch (response.statusCode) {
      case 200:
        return ContactResponse.fromMap(response.body);
      case 400:
        throw PlunkInvalidRequestException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 401:
        throw PlunkAuthorizationException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 402:
        throw PlunkQuotaException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      default:
        throw PlunkUnknownException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
    }
  }

  /// Get a list of all contacts in your Plunk account.
  /// This endpoint can only be accessed with a secret API key
  /// as it returns sensitive information.
  /// Returns an array of [ContactResponse] objects.
  Future<List<ContactResponse>> getAllContacts() async {
    final request = Request(
      method: RequestMethod.get,
      url: '$_baseUrl/${ContactRequest.resourcePath}',
    );

    final response = await _client.execute(
      authorizer: _authorizer,
      request: request,
    );

    switch (response.statusCode) {
      case 200:
        return List<ContactResponse>.from(
          response.body.map((contact) => ContactResponse.fromMap(contact)),
        );
      case 400:
        throw PlunkInvalidRequestException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 401:
        throw PlunkAuthorizationException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 402:
        throw PlunkQuotaException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      default:
        throw PlunkUnknownException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
    }
  }

  /// Fetches the total number of contacts in your Plunk account.
  /// Useful for displaying the number of contacts in a dashboard,
  /// landing page or other marketing material.
  /// This endpoint can be accessed with either a secret API key or
  /// a public API key.
  /// Returns an integer representing the amount of contacts in your
  /// Plunk account.
  Future<int> getContactCount() async {
    final request = Request(
      method: RequestMethod.get,
      url: '$_baseUrl/${ContactRequest.resourcePath}/count',
    );

    final response = await _client.execute(
      authorizer: _authorizer,
      request: request,
    );

    switch (response.statusCode) {
      case 200:
        return response.body['count'];
      case 400:
        throw PlunkInvalidRequestException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 401:
        throw PlunkAuthorizationException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 402:
        throw PlunkQuotaException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      default:
        throw PlunkUnknownException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
    }
  }

  /// Used to create a new contact in your Plunk project without
  /// triggering an event.
  /// This endpoint can only be accessed with a secret API key.
  /// Returns a [ContactResponse] object.
  Future<ContactResponse> createContact({
    required String email,
    required bool subscribed,
    Map<String, dynamic>? data,
  }) async {
    final contact = ContactRequest(
      email: email,
      subscribed: subscribed,
      data: data,
    );

    final request = Request(
      body: contact.toJson(),
      method: RequestMethod.post,
      url: '$_baseUrl/${ContactRequest.resourcePath}',
    );

    final response = await _client.execute(
      authorizer: _authorizer,
      request: request,
    );

    switch (response.statusCode) {
      case 200:
        return ContactResponse.fromMap(response.body);
      case 400:
        throw PlunkInvalidRequestException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 401:
        throw PlunkAuthorizationException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 402:
        throw PlunkQuotaException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      default:
        throw PlunkUnknownException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
    }
  }

  /// Deletes a contact.
  /// This endpoint can only be accessed with a secret API key.
  /// It returns the data how it was at the time of deletion, as a
  /// [ContactResponse] object.
  /// After the request the data is removed from your Plunk dashboard.
  Future<ContactResponse> deleteContact({required String id}) async {
    final request = Request(
      body: jsonEncode({'id': id}),
      method: RequestMethod.delete,
      url: '$_baseUrl/${ContactRequest.resourcePath}',
    );

    final response = await _client.execute(
      authorizer: _authorizer,
      request: request,
    );

    switch (response.statusCode) {
      case 200:
        return ContactResponse.fromMap(response.body);
      case 400:
        throw PlunkInvalidRequestException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 401:
        throw PlunkAuthorizationException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 402:
        throw PlunkQuotaException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      default:
        throw PlunkUnknownException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
    }
  }

  /// Updates a contact.
  /// In most cases, it is recommended to use the track endpoint to update
  /// the metadata of a contact. When a new contact tracks an event Plunk
  /// will automatically create the contact instead of throwing a HTTP 404.
  /// This endpoint can only be accessed with a secret API key.
  /// It returns a [ContactResponse] object.
  Future<ContactResponse> updateContact({
    String? id,
    String? email,
    bool? subscribed,
    Map<String, dynamic>? data,
  }) async {
    if (id == null && email == null) {
      throw PlunkInvalidRequestException(
        code: '400',
        message: 'Either the id or email is required.',
      );
    }

    final payload = <String, dynamic>{};
    id != null ? payload['id'] = id : payload['email'] = email;
    if (subscribed != null) payload['subscribed'] = subscribed;
    if (data != null) payload['data'] = data;

    final request = Request(
      body: jsonEncode(payload),
      method: RequestMethod.put,
      url: '$_baseUrl/${ContactRequest.resourcePath}',
    );

    final response = await _client.execute(
      authorizer: _authorizer,
      request: request,
    );

    switch (response.statusCode) {
      case 200:
        return ContactResponse.fromMap(response.body);
      case 400:
        throw PlunkInvalidRequestException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 401:
        throw PlunkAuthorizationException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 402:
        throw PlunkQuotaException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      default:
        throw PlunkUnknownException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
    }
  }

  /// Updates a contact's subscription status to subscribed.
  /// This endpoint can be accessed with either a secret API
  /// key or a public API key.
  /// Returns a [SubscriptionResponse] object.
  Future<SubscriptionResponse> subscribeContact({
    String? id,
    String? email,
  }) async {
    if (id == null && email == null) {
      throw PlunkInvalidRequestException(
        code: '400',
        message: 'Either the id or email is required.',
      );
    }

    final request = Request(
      body: jsonEncode(id != null ? {'id': id} : {'email': email}),
      method: RequestMethod.post,
      url: '$_baseUrl/${ContactRequest.resourcePath}/subscribe',
    );

    final response = await _client.execute(
      authorizer: _authorizer,
      request: request,
    );

    switch (response.statusCode) {
      case 200:
        return SubscriptionResponse.fromMap(response.body);
      case 400:
        throw PlunkInvalidRequestException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 401:
        throw PlunkAuthorizationException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 402:
        throw PlunkQuotaException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      default:
        throw PlunkUnknownException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
    }
  }

  /// Updates a contact's subscription status to unsubscribed.
  /// This endpoint can be accessed with either a secret API
  /// key or a public API key.
  /// Returns a [SubscriptionResponse] object.
  Future<SubscriptionResponse> unsubscribeContact({
    String? id,
    String? email,
  }) async {
    if (id == null && email == null) {
      throw PlunkInvalidRequestException(
        code: '400',
        message: 'Either the id or email is required.',
      );
    }

    final request = Request(
      body: jsonEncode(id != null ? {'id': id} : {'email': email}),
      method: RequestMethod.post,
      url: '$_baseUrl/${ContactRequest.resourcePath}/unsubscribe',
    );

    final response = await _client.execute(
      authorizer: _authorizer,
      request: request,
    );

    switch (response.statusCode) {
      case 200:
        return SubscriptionResponse.fromMap(response.body);
      case 400:
        throw PlunkInvalidRequestException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 401:
        throw PlunkAuthorizationException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 402:
        throw PlunkQuotaException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      default:
        throw PlunkUnknownException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
    }
  }

  /// Used to create a new campaign in your Plunk project.
  /// This endpoint can only be accessed with a secret API key.
  /// Returns a [CampaignResponse] object.
  Future<CampaignResponse> createCampaign({
    required String subject,
    required String body,
    required List<String> recipients,
    CampaignStyle style = CampaignStyle.plunk,
  }) async {
    final campaign = CampaignRequest(
      subject: subject,
      body: body,
      recipients: recipients,
      style: style,
    );

    final request = Request(
      body: campaign.toJson(),
      method: RequestMethod.post,
      url: '$_baseUrl/${CampaignRequest.resourcePath}',
    );

    final response = await _client.execute(
      authorizer: _authorizer,
      request: request,
    );

    switch (response.statusCode) {
      case 200:
        return CampaignResponse.fromMap(response.body);
      case 400:
        throw PlunkInvalidRequestException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 401:
        throw PlunkAuthorizationException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 402:
        throw PlunkQuotaException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      default:
        throw PlunkUnknownException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
    }
  }

  /// Deletes a campaign.
  /// This endpoint can only be accessed with a secret API key.
  /// It returns the data how it was at the time of deletion, as a
  /// [CampaignResponse] object.
  /// After the request the data is removed from your Plunk dashboard.
  Future<CampaignResponse> deleteCampaign({required String id}) async {
    final request = Request(
      body: jsonEncode({'id': id}),
      method: RequestMethod.delete,
      url: '$_baseUrl/${CampaignRequest.resourcePath}',
    );

    final response = await _client.execute(
      authorizer: _authorizer,
      request: request,
    );

    switch (response.statusCode) {
      case 200:
        return CampaignResponse.fromMap(response.body);
      case 400:
        throw PlunkInvalidRequestException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 401:
        throw PlunkAuthorizationException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 402:
        throw PlunkQuotaException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      default:
        throw PlunkUnknownException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
    }
  }

  /// Updates an existing campaign.
  /// This endpoint can only be accessed with a secret API key.
  /// It returns a [CampaignResponse] object.
  Future<CampaignResponse> updateCampaign({
    required String id,
    required String subject,
    required String body,
    required List<String> recipients,
    CampaignStyle style = CampaignStyle.plunk,
  }) async {
    final campaign = CampaignRequest(
      id: id,
      subject: subject,
      body: body,
      recipients: recipients,
      style: style,
    );

    final request = Request(
      body: campaign.toJson(),
      method: RequestMethod.put,
      url: '$_baseUrl/${CampaignRequest.resourcePath}',
    );

    final response = await _client.execute(
      authorizer: _authorizer,
      request: request,
    );

    switch (response.statusCode) {
      case 200:
        return CampaignResponse.fromMap(response.body);
      case 400:
        throw PlunkInvalidRequestException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 401:
        throw PlunkAuthorizationException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 402:
        throw PlunkQuotaException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      default:
        throw PlunkUnknownException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
    }
  }

  /// Used to send an existing email campaign to a single recipient or multiple
  /// recipients at once.
  /// This endpoint can only be accessed with a secret key.
  /// Returns a boolean indicating whether the campaign was sent successfully.
  Future<bool> sendCampaign({
    required String id,
    bool live = false,
    int? delay,
  }) async {
    final payload = {'id': id, 'live': live, 'delay': delay};

    final request = Request(
      body: jsonEncode(payload),
      method: RequestMethod.post,
      url: '$_baseUrl/${CampaignRequest.resourcePath}/send',
    );

    final response = await _client.execute(
      authorizer: _authorizer,
      request: request,
    );

    switch (response.statusCode) {
      case 200:
        return true;
      case 400:
        throw PlunkInvalidRequestException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 401:
        throw PlunkAuthorizationException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 402:
        throw PlunkQuotaException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      default:
        throw PlunkUnknownException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
    }
  }

  /// Used to send transactional emails to a single recipient or multiple
  /// recipients at once. Transactional emails are programmatically sent
  /// emails that are considered to be part of your application's workflow.
  /// This could be a password reset email, a billing email or other
  /// non-marketing emails.
  /// This endpoint can only be accessed with a secret key.
  /// Returns a [SendResponse] object.
  Future<SendResponse> sendEmail({
    required List<String> to,
    required String subject,
    required String body,
    bool subscribed = false,
    String? name,
    String? from,
    String? reply,
    Map<String, dynamic> headers = const {},
  }) async {
    final sendRequest = SendRequest(
      to: to,
      subject: subject,
      body: body,
      subscribed: subscribed,
      name: name,
      from: from,
      reply: reply,
      headers: headers,
    );

    final request = Request(
      body: sendRequest.toJson(),
      method: RequestMethod.post,
      url: '$_baseUrl/${SendRequest.resourcePath}',
    );

    final response = await _client.execute(
      authorizer: _authorizer,
      request: request,
    );

    switch (response.statusCode) {
      case 200:
        return SendResponse.fromMap(response.body);
      case 400:
        throw PlunkInvalidRequestException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 401:
        throw PlunkAuthorizationException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 402:
        throw PlunkQuotaException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      default:
        throw PlunkUnknownException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
    }
  }

  /// Triggers an event and creates it if it doesn't exist.
  /// This endpoint can be accessed with both the public and
  /// private API keys, meaning that you can trigger events
  /// from both the client and the server.
  /// Return a [TrackResponse] object containing the success
  /// status, contact ID, event ID, and timestamp.
  Future<TrackResponse> trackEvent({
    required String email,
    required String event,
    bool subscribed = true,
    Map<String, dynamic> data = const <String, dynamic>{},
  }) async {
    final trackRequest = TrackRequest(
      email: email,
      event: event,
      subscribed: subscribed,
      data: data,
    );

    final request = Request(
      body: trackRequest.toJson(),
      method: RequestMethod.post,
      url: '$_baseUrl/${TrackRequest.resourcePath}',
    );

    final response = await _client.execute(
      authorizer: _authorizer,
      request: request,
    );

    switch (response.statusCode) {
      case 200:
        return TrackResponse.fromMap(response.body);
      case 400:
        throw PlunkInvalidRequestException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 401:
        throw PlunkAuthorizationException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      case 402:
        throw PlunkQuotaException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
      default:
        throw PlunkUnknownException(
          code: response.statusCode.toString(),
          message: response.body.toString(),
        );
    }
  }
}
