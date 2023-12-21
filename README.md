# Plunk REST Client

The `plunk` package is a REST client for the [Plunk](https://www.useplunk.com) email platform for SaaS.

The Plunk REST Client is maintained by Pocket Business where it is used by the Pocket Business m-commerce platform and it's brands to send emails to merchants and customers.

## Getting Started

Add the Plunk client package to your `pubspec.yaml`:

```yaml
  dependencies:
    plunk: ^1.0.0
```

## Usage

Import the Plunk package in your code:

```dart
import 'package:plunk/plunk.dart';

void main() {
  final plunk = Plunk(apiKey: 'YOUR_API_KEY');

  ContactResponse contact = await plunk.contact('test');

  print(contact.id); // test
}
```

## API Methods
Method | Input | Output | Description
--- | --- | --- | ---
`track` | `String` email, `String` event | `TrackResponse` | Triggers an event and creates it if it doesn't exist.
`contact` | `String` contactId | `ContactResponse` | Gets the details of a specific contact.
`contacts` | | `List<ContactResponse>` | Get a list of all contacts in your Plunk account.
`count` | | `int` | Gets the total number of contacts in your Plunk account.
`create` | `String` email, `bool` subscribed, `Map<String, dynamic>` data | `ContactResponse` | Used to create a new contact in your Plunk project without triggering an event.
`subscribe` | `String` contactId | `SubscriptionResponse` | Updates a contact's subscription status to subscribed.
`unsubscribe` | `String` contactId | `SubscriptionResponse` | Updates a contact's subscription status to unsubscribed.
`send` | `String` from, `List<String>` to, `String` subject, `String` body, `String?` name | `SendResponse` | Used to send transactional emails to a single recipient or multiple recipients at once.
`delete` | `String` contactId | `ContactResponse` | Deletes a contact.

## Use of RestClient library

We are aware `package:rest_client` has been discontinued. We will update this package to either use our own fork of RestClient or another publicly maintained package. We're sorry to see it discontinued.

## Copyright

This package is Copyright ⓒ 2023 Pocket Business, LLC. All rights reserved.
