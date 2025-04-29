## 2.0.0 - Jan 25, 2025

- Transferred ownership to DartFoundry at [pub.dev](https://pub.dev/packages/plunk) and [github.com](https://github.com/dartfoundry/plunk).
- Removed `rest_client` dependency and replaced with internal client.
- Updated to Dart SDK `>=3.0.0 <4.0.0`.
- Added the following API methods:
    - `updateContact()` to update a contact.
    - `createCampaign()` to create a campaign.
    - `updateCampaign()` to update an existing campaign.
    - `deleteCampaign()` to delete a campaign.
    - `sendCampaign()` to send a campaign.
- _Breaking changes_ include:
    - Updated `TrackRequest` to latest API.
    - Refactored `track()` &rarr; `trackEvent()` and updated to parameterized inputs.
    - Updated `SendRequest` and `SendResponse` to latest API.
    - Refactored `send()` &rarr; `sendEmail()` and updated to parameterized inputs.
    - Refactored `contact()` &rarr; `getContact()` and updated to parameterized input.
    - Refactored `contacts()` &rarr; `getAllContacts()`.
    - Refactored `count()` &rarr; `getContactCount()`.
    - Refactored `create()` &rarr; `createContact()` and updated to parameterized input.
    - Refactored `subscribe()` &rarr; `subscribeContact()` and updated to parameterized input.
    - Refactored `unsubscribe()` &rarr; `unsubscribeContact()` and updated to parameterized input.
    - Refactored `delete()` &rarr; `deleteContact()` and updated to parameterized input.
- Updated and grouped existing tests.
- Added updateContact tests.
- Added campaign management tests.
- Added tests for rest client and token authorizer.
- Removed TODO.md.

## 1.0.2 - Dec 26, 2023

- Cleaned up code, adding `const` constructors, documenting classes and methods and making fields `final`.
- Renamed `track.dart` &rarr; `events.dart` to more accurately describe its role. Internal only will not affect usage.

## 1.0.1 - Dec 26, 2023

- Updated pubspec description and version.

## 1.0.0 - Dec 21, 2023

- Initial version.
