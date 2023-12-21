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

## Use of RestClient library

We are aware `package:rest_client` has been discontinued. We will update this package to either use our own fork of RestClient or another publicly maintained package. We're sorry to see it discontinued.

## Copyright

This package is Copyright ⓒ 2023 Pocket Business, LLC. All rights reserved.
