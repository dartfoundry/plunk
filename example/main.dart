import 'package:plunk/plunk.dart';

void main() async {
  final plunk = Plunk(apiKey: 'YOUR_API_KEY');

  ContactResponse contact = await plunk.contact('test');

  print(contact.id); // test
}
