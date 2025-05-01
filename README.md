# Plunk REST Client

[![pub package](https://img.shields.io/pub/v/plunk.svg)](https://pub.dev/packages/plunk)
[![License: BSD-3-Clause](https://img.shields.io/badge/License-BSD--3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

Email remains one of the most effective channels for communicating with users, whether you're sending transactional messages, marketing campaigns, or important notifications. For Dart and Flutter developers looking to integrate robust email capabilities into their applications, this Plunk library offers a comprehensive solution that's easy to use and packed with features.

[Plunk](https://www.useplunk.com) is a modern email platform designed specifically for SaaS applications. It provides powerful tools for sending transactional emails, managing contacts, and running email marketing campaigns. The plunk package is a Dart client that makes it easy to integrate with the Plunk API in your Dart or Flutter applications.

The `plunk` package is a REST client for the Plunk email platform for SaaS. This client is based on the published [Plunk API](https://docs.useplunk.com/api-reference).

The Plunk REST Client is maintained by [DartFoundry](https://dartfoundry.com) where it is used by the Hypermodern AI platform and products to send emails on behalf of partners and to customers.

To learn more about this library, read our article [Introducing the Plunk Email Library for Dart Developers](https://medium.com/dartfoundry/70f4cad9ea4f).

> [!IMPORTANT]
> This library has been updated to support the latest Plunk API and as a result has **BREAKING CHANGES**. Please refer to the [CHANGELOG](CHANGELOG.md) for a list of changes.

## Features

- **Contact Management**: Create, retrieve, update, and delete contacts
- **Email Sending**: Send transactional emails with customizable headers and content
- **Event Tracking**: Track user events and activities
- **Campaign Management**: Create, manage, and send email campaigns
- **Subscription Control**: Manage subscription preferences for contacts

## Getting Started

Add the Plunk client package to your `pubspec.yaml`:

```yaml
  dependencies:
    plunk: ^2.0.2
```

Then run:

```bash
dart pub get
```

## Quick Start

Initialize the client with your API key and start using Plunk's features:

```dart
import 'package:plunk/plunk.dart';

void main() async {
  final plunk = Plunk(apiKey: 'YOUR_API_KEY');

  // Send a transactional email
  final response = await plunk.sendEmail(
    to: ['recipient@example.com'],
    subject: 'Welcome to Our Service',
    body: '<h1>Welcome!</h1><p>Thank you for signing up.</p>',
    from: 'support@yourcompany.com',
    name: 'Your Company',
  );

  print('Email sent: ${response.success}');
}
```

## Usage Examples

### Contact Management

```dart
// Create a new contact
final contact = await plunk.createContact(
  email: 'user@example.com',
  subscribed: true,
  data: {
    'firstName': 'John',
    'lastName': 'Doe',
    'plan': 'premium',
  },
);

// Get a contact by ID
final retrievedContact = await plunk.getContact(id: contact.id!);

// Update a contact
await plunk.updateContact(
  id: contact.id,
  subscribed: true,
  data: {
    'plan': 'enterprise',
    'lastLogin': DateTime.now().toIso8601String(),
  },
);

// Delete a contact
await plunk.deleteContact(id: contact.id!);
```

### Subscription Management

```dart
// Subscribe a contact
await plunk.subscribeContact(email: 'user@example.com');

// Unsubscribe a contact
await plunk.unsubscribeContact(email: 'user@example.com');
```

### Event Tracking

```dart
// Track a user event
await plunk.trackEvent(
  email: 'user@example.com',
  event: 'completed_purchase',
  data: {
    'product': 'Premium Plan',
    'amount': 99.99,
    'currency': 'USD',
  },
);
```

### Email Campaigns

```dart
// Create a campaign
final campaign = await plunk.createCampaign(
  subject: 'New Feature Announcement',
  body: '<h1>Exciting News!</h1><p>We just launched a new feature...</p>',
  recipients: ['user1@example.com', 'user2@example.com'],
  style: CampaignStyle.html,
);

// Send the campaign
await plunk.sendCampaign(
  id: campaign.id!,
  live: true,
);
```

## API Reference

### Contact Methods

| Method | Description |
|--------|-------------|
| `getContact()` | Retrieves a specific contact by ID |
| `getAllContacts()` | Gets all contacts in your Plunk account |
| `getContactCount()` | Gets the total number of contacts |
| `createContact()` | Creates a new contact |
| `updateContact()` | Updates an existing contact |
| `deleteContact()` | Deletes a contact |
| `subscribeContact()` | Sets a contact's subscription status to subscribed |
| `unsubscribeContact()` | Sets a contact's subscription status to unsubscribed |

### Email Methods

| Method | Description |
|--------|-------------|
| `sendEmail()` | Sends a transactional email to one or more recipients |
| `trackEvent()` | Tracks an event for a specific contact |

### Campaign Methods

| Method | Description |
|--------|-------------|
| `createCampaign()` | Creates a new email campaign |
| `updateCampaign()` | Updates an existing campaign |
| `deleteCampaign()` | Deletes a campaign |
| `sendCampaign()` | Sends a campaign to its recipients |

## Error Handling

The library provides specific exception types to handle different error scenarios:

```dart
try {
  await plunk.sendEmail(/* ... */);
} catch (e) {
  if (e is PlunkInvalidRequestException) {
    print('Invalid request: ${e.message}');
  } else if (e is PlunkAuthorizationException) {
    print('Authorization error: ${e.message}');
  } else if (e is PlunkQuotaException) {
    print('Quota exceeded: ${e.message}');
  } else if (e is PlunkUnknownException) {
    print('Unknown error: ${e.message}');
  }
}
```

## Configuration

The Plunk client can be configured with several options:

```dart
final plunk = Plunk(
  apiKey: 'YOUR_API_KEY',
  apiVersion: 'v1',
  baseUrl: 'https://api.useplunk.com',
  timeout: Duration(seconds: 60),
);
```

## Requirements

- Dart SDK 3.0.0 or higher

## Learn More

- [Plunk Documentation](https://docs.useplunk.com/)
- [Plunk API Reference](https://docs.useplunk.com/api-reference)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This package is licensed under the BSD 3-Clause License - see the LICENSE file for details.

## Copyright

This package is Copyright ⓒ 2025 Dom Jocubeit. All rights reserved.
