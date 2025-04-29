import 'dart:convert';

import 'package:plunk/plunk.dart';
import 'package:plunk/src/client/client.dart';
import 'package:plunk/src/client/request.dart';
import 'package:plunk/src/client/response.dart';
import 'package:plunk/src/client/token_authorizer.dart';

class MockClient extends Client {
  Map<String, dynamic> Function(Request)? mockResponseHandler;
  Exception? exceptionToThrow;

  MockClient({
    this.mockResponseHandler,
    this.exceptionToThrow,
  }) : super(timeout: Duration(seconds: 1));

  @override
  Future<Response> execute({
    TokenAuthorizer? authorizer,
    required Request request,
    bool throwRestExceptions = true,
    bool jsonResponse = true,
    dynamic emitter,
    dynamic reporter,
    int retryCount = 0,
    Duration retryDelay = const Duration(seconds: 1),
    dynamic retryDelayStrategy,
    Duration? timeout,
    bool? withCredentials,
  }) async {
    // If there's an exception to throw, throw it
    if (exceptionToThrow != null) {
      if (exceptionToThrow is PlunkException) {
        throw exceptionToThrow!;
      } else {
        throw exceptionToThrow!;
      }
    }

    // If we have a specific URL trigger for exceptions, handle it
    if (request.url.contains('invalid_email') ||
        (request.body != null && request.body!.contains('invalid_email'))) {
      if (throwRestExceptions) {
        throw PlunkInvalidRequestException(
          code: '400',
          message: 'Invalid email format',
        );
      }
    }

    if (request.url.contains('quota_exceeded')) {
      if (throwRestExceptions) {
        throw PlunkQuotaException(
          code: '402',
          message: 'Quota exceeded',
        );
      }
    }

    if (request.url.contains('invalid_api_key')) {
      if (throwRestExceptions) {
        throw PlunkAuthorizationException(
          code: '401',
          message: 'Unauthorized',
        );
      }
    }

    if (request.url.contains('unexpected_error')) {
      if (throwRestExceptions) {
        throw PlunkUnknownException(
          code: '500',
          message: 'Unknown error',
        );
      }
    }

    // If we have a custom response handler, use it
    if (mockResponseHandler != null) {
      try {
        final responseData = mockResponseHandler!(request);
        return Response(
          body: responseData,
          headers: {'content-type': 'application/json'},
          statusCode: 200,
        );
      } catch (e) {
        rethrow;
      }
    }

    // Default mocked responses based on URL patterns
    if (request.url.contains('/contacts/count')) {
      return Response(
        body: {'count': 10},
        headers: {'content-type': 'application/json'},
        statusCode: 200,
      );
    } else if (request.url.contains('/contacts/subscribe')) {
      return Response(
        body: {
          'success': true,
          'contact': 'test_contact_id',
          'subscribed': true,
        },
        headers: {'content-type': 'application/json'},
        statusCode: 200,
      );
    } else if (request.url.contains('/contacts/unsubscribe')) {
      return Response(
        body: {
          'success': true,
          'contact': 'test_contact_id',
          'subscribed': false,
        },
        headers: {'content-type': 'application/json'},
        statusCode: 200,
      );
    } else if (request.url.contains('/contacts/')) {
      // Extract contact ID from URL
      final contactId = request.url.split('/').last;
      return Response(
        body: <String, dynamic>{
          'success': true,
          'id': contactId,
          'email': 'test@example.com',
          'subscribed': true,
          'data': <String, dynamic>{'key': 'value'},
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        },
        headers: {'content-type': 'application/json'},
        statusCode: 200,
      );
    } else if (request.url.endsWith('/contacts')) {
      if (request.method.toString() == 'GET') {
        // Get all contacts with more explicit Map<String, dynamic> typing
        return Response(
          body: [
            <String, dynamic>{
              'success': true,
              'id': 'test_contact_id_1',
              'email': 'test1@example.com',
              'subscribed': true,
              'data': <String, dynamic>{},
              'createdAt': DateTime.now().toIso8601String(),
              'updatedAt': DateTime.now().toIso8601String(),
            },
            <String, dynamic>{
              'success': true,
              'id': 'test_contact_id_2',
              'email': 'test2@example.com',
              'subscribed': false,
              'data': <String, dynamic>{'key': 'value'},
              'createdAt': DateTime.now().toIso8601String(),
              'updatedAt': DateTime.now().toIso8601String(),
            },
          ],
          headers: {'content-type': 'application/json'},
          statusCode: 200,
        );
      } else if (request.method.toString() == 'POST') {
        // Create contact
        final data = request.body != null ? json.decode(request.body!) : {};
        return Response(
          body: <String, dynamic>{
            'success': true,
            'id': 'new_contact_id',
            'email': data['email'] ?? 'test@example.com',
            'subscribed': data['subscribed'] ?? true,
            'data': data['data'] ?? <String, dynamic>{},
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          },
          headers: {'content-type': 'application/json'},
          statusCode: 200,
        );
      } else if (request.method.toString() == 'PUT') {
        // Update contact
        final data = request.body != null ? json.decode(request.body!) : {};
        String id = data['id'] ?? 'updated_contact_id';
        return Response(
          body: <String, dynamic>{
            'success': true,
            'id': id,
            'email': data['email'] ?? 'updated@example.com',
            'subscribed': data['subscribed'] ?? true,
            'data': data['data'] ?? <String, dynamic>{'key': 'updated_value'},
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          },
          headers: {'content-type': 'application/json'},
          statusCode: 200,
        );
      } else if (request.method.toString() == 'DELETE') {
        // Delete contact
        final data = request.body != null ? json.decode(request.body!) : {};
        return Response(
          body: <String, dynamic>{
            'success': true,
            'id': data['id'] ?? 'deleted_contact_id',
            'email': 'deleted@example.com',
            'subscribed': true,
            'data': <String, dynamic>{},
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          },
          headers: {'content-type': 'application/json'},
          statusCode: 200,
        );
      }
    } else if (request.url.contains('/track')) {
      final data = request.body != null ? json.decode(request.body!) : {};
      return Response(
        body: <String, dynamic>{
          'success': true,
          'contact': 'test_contact_id',
          'event': data['event'] ?? 'test_event',
          'timestamp': DateTime.now().toIso8601String(),
        },
        headers: {'content-type': 'application/json'},
        statusCode: 200,
      );
    } else if (request.url.contains('/send')) {
      return Response(
        body: <String, dynamic>{
          'success': true,
          'emails': [],
          'timestamp': DateTime.now().toIso8601String(),
        },
        headers: {'content-type': 'application/json'},
        statusCode: 200,
      );
    } else if (request.url.contains('/campaigns/send')) {
      return Response(
        body: <String, dynamic>{'success': true},
        headers: {'content-type': 'application/json'},
        statusCode: 200,
      );
    } else if (request.url.endsWith('/campaigns')) {
      if (request.method.toString() == 'POST') {
        // Create campaign
        final data = request.body != null ? json.decode(request.body!) : {};
        return Response(
          body: <String, dynamic>{
            'id': 'new_campaign_id',
            'subject': data['subject'] ?? 'Test Subject',
            'body': data['body'] ?? 'Test Body',
            'recipients': data['recipients'] ?? ['test@example.com'],
            'style': data['style'] ?? 'PLUNK',
            'projectId': 'test_project_id',
            'status': 'draft',
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          },
          headers: {'content-type': 'application/json'},
          statusCode: 200,
        );
      } else if (request.method.toString() == 'PUT') {
        // Update campaign
        final data = request.body != null ? json.decode(request.body!) : {};
        return Response(
          body: <String, dynamic>{
            'id': data['id'] ?? 'updated_campaign_id',
            'subject': data['subject'] ?? 'Updated Subject',
            'body': data['body'] ?? 'Updated Body',
            'recipients': data['recipients'] ?? ['updated@example.com'],
            'style': data['style'] ?? 'PLUNK',
            'projectId': 'test_project_id',
            'status': 'draft',
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          },
          headers: {'content-type': 'application/json'},
          statusCode: 200,
        );
      } else if (request.method.toString() == 'DELETE') {
        // Delete campaign
        final data = request.body != null ? json.decode(request.body!) : {};
        return Response(
          body: <String, dynamic>{
            'id': data['id'] ?? 'deleted_campaign_id',
            'subject': 'Deleted Subject',
            'body': 'Deleted Body',
            'recipients': ['test@example.com'],
            'style': 'PLUNK',
            'projectId': 'test_project_id',
            'status': 'deleted',
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          },
          headers: {'content-type': 'application/json'},
          statusCode: 200,
        );
      }
    }

    // Default fallback
    return Response(
      body: <String, dynamic>{'success': true},
      headers: {'content-type': 'application/json'},
      statusCode: 200,
    );
  }
}
