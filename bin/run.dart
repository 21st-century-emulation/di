import 'dart:io';
import 'dart:convert';

Future main() async {
  var server = await HttpServer.bind(
    '0.0.0.0',
    8080,
  );
  print('Listening on 0.0.0.0:${server.port}');

  await for (HttpRequest request in server) {
    if (request.method == 'GET' && request.uri.path == '/status') {
      request.response
        ..statusCode = HttpStatus.ok
        ..write('Healthy');
    } else if (request.method == 'POST' &&
        request.uri.path == '/api/v1/execute') {
      var content = await utf8.decoder.bind(request).join();
      var data = jsonDecode(content) as Map;
      data['state']['interruptsEnabled'] = false;
      data['state']['cycles'] += 4;
      request.response
        ..statusCode = HttpStatus.ok
        ..write(jsonEncode(data));
    }

    await request.response.close();
  }
}
