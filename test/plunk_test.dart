import 'package:test/test.dart';
import 'package:plunk/plunk.dart';

void main() {
  group('Plunk', () {
    late Plunk plunk;

    setUp(() {
      plunk = Plunk(apiKey: 'your_api_key');
    });

    test('Track method should send a track request', () async {
      final email = 'test@example.com';
      final event = 'test_event';

      final trackResponse = await plunk.track(email, event);

      expect(trackResponse.success, isNotNull);
      expect(trackResponse.contact, isNotNull);
      expect(trackResponse.event, equals(event));
      expect(trackResponse.timestamp, isA<DateTime>());
    });

    test('Track method should handle exceptions', () async {
      final invalidEmail = 'invalid_email';

      expect(
        () async => await plunk.track(invalidEmail, 'test_event'),
        throwsA(isA<PlunkException>()),
      );
    });

    test('Contact method should send a contact request', () async {
      final contactId = '123';

      final contactResponse = await plunk.contact(contactId);

      expect(contactResponse.success, isNotNull);
      expect(contactResponse.id, equals(contactId));
      expect(contactResponse.email, isNotNull);
    });

    test('Contact method should handle exceptions', () async {
      final invalidContactId = '';

      expect(
        () async => await plunk.contact(invalidContactId),
        throwsA(isA<PlunkException>()),
      );
    });

    test('Contacts method should send a contacts request', () async {
      final contactsResponse = await plunk.contacts();

      expect(contactsResponse, isA<List<ContactResponse>>());
    });

    test('Contacts method should handle exceptions', () async {
      expect(
        () async => await plunk.contacts(),
        throwsA(isA<PlunkException>()),
      );
    });

    test('Count method should send a count request', () async {
      final count = await plunk.count();

      expect(count, isA<int>());
    });

    test('Count method should handle exceptions', () async {
      expect(
        () async => await plunk.count(),
        throwsA(isA<PlunkException>()),
      );
    });

    test('Create method should send a create contact request', () async {
      final email = 'test@example.com';
      final subscribed = true;
      final data = {'key': 'value'};

      final contactResponse = await plunk.create(email, subscribed, data);

      expect(contactResponse.success, isNotNull);
      expect(contactResponse.id, isNotNull);
      expect(contactResponse.email, equals(email));
      expect(contactResponse.subscribed, equals(subscribed));
      expect(contactResponse.data, equals(data));
    });

    test('Create method should handle exceptions', () async {
      final invalidEmail = 'invalid_email';

      expect(
        () async => await plunk.create(invalidEmail, true, {}),
        throwsA(isA<PlunkException>()),
      );
    });

    test('Subscribe method should send a subscribe request', () async {
      final contactId = '123';

      final subscriptionResponse = await plunk.subscribe(contactId);

      expect(subscriptionResponse.success, isNotNull);
      expect(subscriptionResponse.contact, equals(contactId));
      expect(subscriptionResponse.subscribed, equals(true));
    });

    test('Subscribe method should handle exceptions', () async {
      final invalidContactId = '';

      expect(
        () async => await plunk.subscribe(invalidContactId),
        throwsA(isA<PlunkException>()),
      );
    });

    test('Unsubscribe method should send an unsubscribe request', () async {
      final contactId = '123';

      final subscriptionResponse = await plunk.unsubscribe(contactId);

      expect(subscriptionResponse.success, isNotNull);
      expect(subscriptionResponse.contact, equals(contactId));
      expect(subscriptionResponse.subscribed, equals(false));
    });

    test('Unsubscribe method should handle exceptions', () async {
      final invalidContactId = '';

      expect(
        () async => await plunk.unsubscribe(invalidContactId),
        throwsA(isA<PlunkException>()),
      );
    });

    test('Send method should send a send email request', () async {
      final from = 'sender@example.com';
      final to = ['recipient@example.com'];
      final subject = 'Test Subject';
      final body = 'Test Body';
      final name = 'John Doe';

      final sendResponse = await plunk.send(from, to, subject, body, name);

      expect(sendResponse.success, isNotNull);
      expect(sendResponse.emails, isA<List<Contact>>());
      expect(sendResponse.timestamp, isA<DateTime>());
    });

    test('Send method should handle exceptions', () async {
      final invalidEmail = 'invalid_email';

      expect(
        () async => await plunk.send(invalidEmail, ['recipient@example.com'],
            'Test Subject', 'Test Body', 'John Doe'),
        throwsA(isA<PlunkException>()),
      );
    });

    test('Delete method should send a delete contact request', () async {
      final contactId = '123';

      final deletedContact = await plunk.delete(contactId);

      expect(deletedContact.success, isNotNull);
      expect(deletedContact.id, equals(contactId));
      expect(deletedContact.email, isNotNull);
    });

    test('Delete method should handle exceptions', () async {
      final invalidContactId = '';

      expect(
        () async => await plunk.delete(invalidContactId),
        throwsA(isA<PlunkException>()),
      );
    });

    test('InvalidRequestException should be thrown for 400 response', () async {
      final invalidEmail = 'invalid_email';

      expect(
        () async => await plunk.track(invalidEmail, 'test_event'),
        throwsA(isA<PlunkInvalidRequestException>()),
      );
    });

    test('AuthorizationException should be thrown for 401 response', () async {
      // Simulate an unauthorized request by providing an invalid API key
      final invalidPlunk = Plunk(apiKey: 'invalid_api_key');

      expect(
        () async => await invalidPlunk.track('test@example.com', 'test_event'),
        throwsA(isA<PlunkAuthorizationException>()),
      );
    });

    test('QuotaException should be thrown for 402 response', () async {
      final contactId = '123';

      expect(
        () async => await plunk.subscribe(contactId),
        throwsA(isA<PlunkQuotaException>()),
      );
    });

    test('UnknownException should be thrown for unexpected response', () async {
      // Simulate a response with an unexpected status code
      final unexpectedPlunk = Plunk(apiKey: 'unexpected_api_key');

      expect(
        () async =>
            await unexpectedPlunk.track('test@example.com', 'test_event'),
        throwsA(isA<PlunkUnknownException>()),
      );
    });

    test('InvalidRequestException should be thrown for invalid contactId',
        () async {
      final invalidContactId = '';

      expect(
        () async => await plunk.contact(invalidContactId),
        throwsA(isA<PlunkInvalidRequestException>()),
      );
    });

    test(
        'InvalidRequestException should be thrown for invalid email in create method',
        () async {
      final invalidEmail = 'invalid_email';

      expect(
        () async => await plunk.create(invalidEmail, true, {}),
        throwsA(isA<PlunkInvalidRequestException>()),
      );
    });

    test(
        'InvalidRequestException should be thrown for invalid contactId in delete method',
        () async {
      final invalidContactId = '';

      expect(
        () async => await plunk.delete(invalidContactId),
        throwsA(isA<PlunkInvalidRequestException>()),
      );
    });
  });
}
