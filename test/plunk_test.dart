// ignore_for_file: overridden_fields

import 'dart:convert';

import 'package:plunk/plunk.dart';
import 'package:plunk/src/client/request.dart';
import 'package:plunk/src/client/request_method.dart';
import 'package:plunk/src/client/token_authorizer.dart';
import 'package:test/test.dart';

import 'mocks/mock_client.dart';

class MockPlunk extends Plunk {
  final MockClient mockClient = MockClient();

  // Need to override all private fields that we need access to
  // ignore: annotate_overrides
  late String baseUrl;
  late TokenAuthorizer authorizer;

  MockPlunk({required String apiKey}) : super(apiKey: apiKey) {
    // Re-initialize the private fields since we can't access them directly
    baseUrl = 'https://api.useplunk.com/v1';
    authorizer = TokenAuthorizer(token: apiKey);
  }

  void mockThrowException(Exception exception) {
    mockClient.exceptionToThrow = exception;
  }

  void setMockResponseHandler(Map<String, dynamic> Function(Request) handler) {
    mockClient.mockResponseHandler = handler;
  }

  @override
  Future<ContactResponse> getContact({required String id}) async {
    if (id.isEmpty) {
      throw PlunkInvalidRequestException(
        code: '404',
        message: 'Invalid contactId parameter',
      );
    }

    final request = Request(
      method: RequestMethod.get,
      url: '$baseUrl/${ContactRequest.resourcePath}/$id',
    );

    final response = await mockClient.execute(
      authorizer: authorizer,
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

  @override
  Future<List<ContactResponse>> getAllContacts() async {
    final request = Request(
      method: RequestMethod.get,
      url: '$baseUrl/${ContactRequest.resourcePath}',
    );

    final response = await mockClient.execute(
      authorizer: authorizer,
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

  @override
  Future<int> getContactCount() async {
    final request = Request(
      method: RequestMethod.get,
      url: '$baseUrl/${ContactRequest.resourcePath}/count',
    );

    final response = await mockClient.execute(
      authorizer: authorizer,
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

  @override
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
      url: '$baseUrl/${ContactRequest.resourcePath}',
    );

    final response = await mockClient.execute(
      authorizer: authorizer,
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

  @override
  Future<ContactResponse> deleteContact({required String id}) async {
    final request = Request(
      body: jsonEncode({'id': id}),
      method: RequestMethod.delete,
      url: '$baseUrl/${ContactRequest.resourcePath}',
    );

    final response = await mockClient.execute(
      authorizer: authorizer,
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

  @override
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
      url: '$baseUrl/${ContactRequest.resourcePath}',
    );

    final response = await mockClient.execute(
      authorizer: authorizer,
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

  @override
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
      url: '$baseUrl/${ContactRequest.resourcePath}/subscribe',
    );

    final response = await mockClient.execute(
      authorizer: authorizer,
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

  @override
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
      url: '$baseUrl/${ContactRequest.resourcePath}/unsubscribe',
    );

    final response = await mockClient.execute(
      authorizer: authorizer,
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

  @override
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
      url: '$baseUrl/${CampaignRequest.resourcePath}',
    );

    final response = await mockClient.execute(
      authorizer: authorizer,
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

  @override
  Future<CampaignResponse> deleteCampaign({required String id}) async {
    final request = Request(
      body: jsonEncode({'id': id}),
      method: RequestMethod.delete,
      url: '$baseUrl/${CampaignRequest.resourcePath}',
    );

    final response = await mockClient.execute(
      authorizer: authorizer,
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

  @override
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
      url: '$baseUrl/${CampaignRequest.resourcePath}',
    );

    final response = await mockClient.execute(
      authorizer: authorizer,
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

  @override
  Future<bool> sendCampaign({
    required String id,
    bool live = false,
    int? delay,
  }) async {
    final payload = {'id': id, 'live': live, 'delay': delay};

    final request = Request(
      body: jsonEncode(payload),
      method: RequestMethod.post,
      url: '$baseUrl/${CampaignRequest.resourcePath}/send',
    );

    final response = await mockClient.execute(
      authorizer: authorizer,
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

  @override
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
    // Check if we need to throw an exception
    if (mockClient.exceptionToThrow != null) {
      throw mockClient.exceptionToThrow!;
    }

    // Return a manually constructed SendResponse for testing
    return SendResponse(
      success: true,
      emails: [
        Email(
          email: 'test_email_id',
          contact: Contact(
            id: 'test_contact_id',
            address: 'test@example.com',
            email: 'test_email_id',
          ),
        ),
      ],
      timestamp: DateTime.now(),
    );
  }

  @override
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
      url: '$baseUrl/${TrackRequest.resourcePath}',
    );

    final response = await mockClient.execute(
      authorizer: authorizer,
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

void main() {
  group('Plunk', () {
    late MockPlunk plunk;

    setUp(() {
      plunk = MockPlunk(apiKey: 'test_api_key');
    });

    group('event tracking', () {
      test('trackEvent method should return a TrackResponse', () async {
        final email = 'test@example.com';
        final event = 'test_event';

        final trackResponse = await plunk.trackEvent(email: email, event: event);

        expect(trackResponse, isA<TrackResponse>());
        expect(trackResponse.success, isTrue);
        expect(trackResponse.contact, equals('test_contact_id'));
        expect(trackResponse.event, equals(event));
        expect(trackResponse.timestamp, isA<DateTime>());
      });

      test('trackEvent method should handle exceptions', () async {
        final invalidEmail = 'invalid_email';

        plunk.mockThrowException(PlunkInvalidRequestException(
          code: '400',
          message: 'Invalid email format',
        ));

        expect(
          () async => await plunk.trackEvent(email: invalidEmail, event: 'test_event'),
          throwsA(isA<PlunkInvalidRequestException>()),
        );
      });
    });

    group('contact management', () {
      test('getContact method should send a ContactRequest', () async {
        final contactId = '123';

        final contactResponse = await plunk.getContact(id: contactId);

        expect(contactResponse, isA<ContactResponse>());
        expect(contactResponse.id, equals(contactId));
        expect(contactResponse.email, equals('test@example.com'));
      });

      test('getContact method should handle exceptions', () async {
        final invalidContactId = '';

        expect(
          () async => await plunk.getContact(id: invalidContactId),
          throwsA(isA<PlunkInvalidRequestException>()),
        );
      });

      test('getAllContacts method should send a ContactRequest', () async {
        final contactsResponse = await plunk.getAllContacts();

        expect(contactsResponse, isA<List<ContactResponse>>());
        expect(contactsResponse.length, equals(2));
        expect(contactsResponse[0].id, equals('test_contact_id_1'));
        expect(contactsResponse[1].id, equals('test_contact_id_2'));
      });

      test('getAllContacts method should handle exceptions', () async {
        plunk.mockThrowException(PlunkAuthorizationException(
          code: '401',
          message: 'Unauthorized',
        ));

        expect(
          () async => await plunk.getAllContacts(),
          throwsA(isA<PlunkAuthorizationException>()),
        );
      });

      test('getContactCount method should return an int', () async {
        final count = await plunk.getContactCount();

        expect(count, isA<int>());
        expect(count, equals(10));
      });

      test('getContactCount method should handle exceptions', () async {
        plunk.mockThrowException(PlunkAuthorizationException(
          code: '401',
          message: 'Unauthorized',
        ));

        expect(
          () async => await plunk.getContactCount(),
          throwsA(isA<PlunkAuthorizationException>()),
        );
      });

      test('createContact method should return a ContactResponse', () async {
        final email = 'test@example.com';
        final subscribed = true;
        final data = {'key': 'value'};

        final contactResponse =
            await plunk.createContact(email: email, subscribed: subscribed, data: data);

        expect(contactResponse, isA<ContactResponse>());
        expect(contactResponse.email, equals(email));
        expect(contactResponse.subscribed, equals(subscribed));
      });

      test('createContact method should handle exceptions', () async {
        final invalidEmail = 'invalid_email';

        plunk.mockThrowException(PlunkInvalidRequestException(
          code: '400',
          message: 'Invalid email format',
        ));

        expect(
          () async => await plunk.createContact(email: invalidEmail, subscribed: true),
          throwsA(isA<PlunkInvalidRequestException>()),
        );
      });

      test('updateContact method should return a ContactResponse', () async {
        final id = '1234';
        final subscribed = false;
        final data = {'key': 'someothervalue'};

        final contactResponse =
            await plunk.updateContact(id: id, subscribed: subscribed, data: data);

        expect(contactResponse, isA<ContactResponse>());
        expect(contactResponse.id, equals(id));
        expect(contactResponse.subscribed, equals(subscribed));
      });

      test('updateContact method should handle exceptions', () async {
        final invalidEmail = 'invalid_email';

        plunk.mockThrowException(PlunkInvalidRequestException(
          code: '400',
          message: 'Invalid email format',
        ));

        expect(
          () async => await plunk.updateContact(email: invalidEmail, subscribed: true),
          throwsA(isA<PlunkInvalidRequestException>()),
        );
      });

      test('deleteContact method should return a ContactResponse', () async {
        final contactId = '123';

        final deletedContact = await plunk.deleteContact(id: contactId);

        expect(deletedContact, isA<ContactResponse>());
        expect(deletedContact.id, isNotNull);
        expect(deletedContact.email, equals('deleted@example.com'));
      });

      test('deleteContact method should handle exceptions', () async {
        final invalidContactId = '';

        plunk.mockThrowException(PlunkInvalidRequestException(
          code: '400',
          message: 'Invalid contact ID',
        ));

        expect(
          () async => await plunk.deleteContact(id: invalidContactId),
          throwsA(isA<PlunkInvalidRequestException>()),
        );
      });

      test('subscribeContact method should return a SubscriptionResponse', () async {
        final contactId = '123';

        final subscriptionResponse = await plunk.subscribeContact(id: contactId);

        expect(subscriptionResponse, isA<SubscriptionResponse>());
        expect(subscriptionResponse.success, isTrue);
        expect(subscriptionResponse.contact, equals('test_contact_id'));
        expect(subscriptionResponse.subscribed, isTrue);
      });

      test('subscribeContact method should handle exceptions', () async {
        final invalidContactId = '';

        plunk.mockThrowException(PlunkInvalidRequestException(
          code: '400',
          message: 'Invalid contact ID',
        ));

        expect(
          () async => await plunk.subscribeContact(id: invalidContactId),
          throwsA(isA<PlunkInvalidRequestException>()),
        );
      });

      test('unsubscribeContact method should return a SubscriptionResponse', () async {
        final contactId = '123';

        final subscriptionResponse = await plunk.unsubscribeContact(id: contactId);

        expect(subscriptionResponse, isA<SubscriptionResponse>());
        expect(subscriptionResponse.success, isTrue);
        expect(subscriptionResponse.contact, equals('test_contact_id'));
        expect(subscriptionResponse.subscribed, isFalse);
      });

      test('unsubscribeContact method should handle exceptions', () async {
        final invalidContactId = '';

        plunk.mockThrowException(PlunkInvalidRequestException(
          code: '400',
          message: 'Invalid contact ID',
        ));

        expect(
          () async => await plunk.unsubscribeContact(id: invalidContactId),
          throwsA(isA<PlunkInvalidRequestException>()),
        );
      });
    });

    group('transactional email', () {
      test('sendEmail method should return a SendResponse', () async {
        final from = 'sender@example.com';
        final to = ['recipient@example.com'];
        final subject = 'Test Subject';
        final body = 'Test Body';
        final name = 'John Doe';

        final sendResponse =
            await plunk.sendEmail(from: from, to: to, subject: subject, body: body, name: name);

        expect(sendResponse, isA<SendResponse>());
        expect(sendResponse.success, isTrue);
        expect(sendResponse.emails, isNotEmpty);
        expect(sendResponse.timestamp, isA<DateTime>());
      });

      test('sendEmail method should handle exceptions', () async {
        final invalidEmail = 'invalid_email';

        plunk.mockThrowException(PlunkInvalidRequestException(
          code: '400',
          message: 'Invalid email format',
        ));

        expect(
          () async => await plunk.sendEmail(
              from: invalidEmail,
              to: ['recipient@example.com'],
              subject: 'Test Subject',
              body: 'Test Body',
              name: 'John Doe'),
          throwsA(isA<PlunkInvalidRequestException>()),
        );
      });
    });

    group('campaign management', () {
      test('createCampaign method should return a CampaignResponse', () async {
        final subject = 'A subject';
        final body = 'A body';
        final recipients = ['someone@example.com'];
        final style = CampaignStyle.html;

        final campaignResponse = await plunk.createCampaign(
            subject: subject, body: body, recipients: recipients, style: style);

        expect(campaignResponse, isA<CampaignResponse>());
        expect(campaignResponse.id, equals('new_campaign_id'));
        expect(campaignResponse.subject, equals(subject));
        expect(campaignResponse.body, equals(body));
      });

      test('createCampaign method should handle exceptions', () async {
        final subject = 'A subject';
        final body = 'A body';
        final recipients = <String>[]; // Empty
        final style = CampaignStyle.html;

        plunk.mockThrowException(PlunkInvalidRequestException(
          code: '400',
          message: 'Recipients cannot be empty',
        ));

        expect(
          () async => await plunk.createCampaign(
              subject: subject, body: body, recipients: recipients, style: style),
          throwsA(isA<PlunkInvalidRequestException>()),
        );
      });

      test('updateCampaign method should return a CampaignResponse', () async {
        final id = '1234';
        final subject = 'A subject';
        final body = 'A body';
        final recipients = ['someone@example.com'];
        final style = CampaignStyle.plunk;

        final campaignResponse = await plunk.updateCampaign(
            id: id, subject: subject, body: body, recipients: recipients, style: style);

        expect(campaignResponse, isA<CampaignResponse>());
        expect(campaignResponse.id, equals(id));
        expect(campaignResponse.subject, equals(subject));
        expect(campaignResponse.body, equals(body));
      });

      test('updateCampaign method should handle exceptions', () async {
        final id = ''; // Empty
        final subject = 'A subject';
        final body = 'A body';
        final recipients = ['someone@example.com'];
        final style = CampaignStyle.plunk;

        plunk.mockThrowException(PlunkInvalidRequestException(
          code: '400',
          message: 'Campaign ID cannot be empty',
        ));

        expect(
          () async => await plunk.updateCampaign(
              id: id, subject: subject, body: body, recipients: recipients, style: style),
          throwsA(isA<PlunkInvalidRequestException>()),
        );
      });

      test('deleteCampaign method should return a CampaignResponse', () async {
        final id = '1234';
        final campaignResponse = await plunk.deleteCampaign(id: id);

        expect(campaignResponse, isA<CampaignResponse>());
        expect(campaignResponse.id, equals(id));
        expect(campaignResponse.status, equals('deleted'));
      });

      test('deleteCampaign method should handle exceptions', () async {
        final invalidCampaignId = '';

        plunk.mockThrowException(PlunkInvalidRequestException(
          code: '400',
          message: 'Campaign ID cannot be empty',
        ));

        expect(
          () async => await plunk.deleteCampaign(id: invalidCampaignId),
          throwsA(isA<PlunkInvalidRequestException>()),
        );
      });

      test('sendCampaign method returns true', () async {
        final id = '1234';
        final live = true;
        final delay = 60;

        final sendResponse = await plunk.sendCampaign(id: id, live: live, delay: delay);

        expect(sendResponse, isTrue);
      });

      test('sendCampaign method should handle exceptions', () async {
        final invalidId = ''; // Empty

        plunk.mockThrowException(PlunkInvalidRequestException(
          code: '400',
          message: 'Campaign ID cannot be empty',
        ));

        expect(
          () async => await plunk.sendCampaign(
            id: invalidId,
          ),
          throwsA(isA<PlunkInvalidRequestException>()),
        );
      });
    });

    group('exception handling', () {
      test('InvalidRequestException should be thrown for 400 response', () async {
        plunk.mockThrowException(PlunkInvalidRequestException(
          code: '400',
          message: 'Invalid request',
        ));

        expect(
          () async => await plunk.trackEvent(email: 'test@example.com', event: 'test_event'),
          throwsA(isA<PlunkInvalidRequestException>()),
        );
      });

      test('AuthorizationException should be thrown for 401 response', () async {
        plunk.mockThrowException(PlunkAuthorizationException(
          code: '401',
          message: 'Unauthorized',
        ));

        expect(
          () async => await plunk.trackEvent(email: 'test@example.com', event: 'test_event'),
          throwsA(isA<PlunkAuthorizationException>()),
        );
      });

      test('QuotaException should be thrown for 402 response', () async {
        plunk.mockThrowException(PlunkQuotaException(
          code: '402',
          message: 'Quota exceeded',
        ));

        expect(
          () async => await plunk.subscribeContact(id: '123'),
          throwsA(isA<PlunkQuotaException>()),
        );
      });

      test('UnknownException should be thrown for unexpected response', () async {
        plunk.mockThrowException(PlunkUnknownException(
          code: '500',
          message: 'Unknown error',
        ));

        expect(
          () async => await plunk.trackEvent(email: 'test@example.com', event: 'test_event'),
          throwsA(isA<PlunkUnknownException>()),
        );
      });
    });
  });
}
