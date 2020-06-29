import 'dart:io';

import 'package:plex_notifier/server.dart';

class ImagesController implements Controller {
  final HttpRequest _req;

  ImagesController(this._req);

  @override
  Future<void> execute() async {
    var filePath = _req.uri.toString().substring(1, _req.uri.toString().length);
    final file = File(filePath);

    if (_req.method != 'GET') {
      throw RouteNotFoundException();
    }
    if ((await file.exists()) == false) {
      throw RouteNotFoundException();
    }

    final bytes = file.readAsBytesSync();
    _req.response.headers.add('Content-Type', 'image/jpeg; charset=utf-8');
    _req.response.add(bytes.buffer.asUint8List());
  }
}

class OpenFileException implements Exception {
  OpenFileException();
}
