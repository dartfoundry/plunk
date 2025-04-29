import 'package:http/http.dart' as http;

import 'proxy.dart';

http.Client createHttpClient({
  Proxy? proxy,
  bool withCredentials = false,
}) =>
    throw UnimplementedError();

Future<dynamic> processJson(String? body) => throw UnimplementedError();

bool shouldSpawnIsolate() => throw UnimplementedError();
