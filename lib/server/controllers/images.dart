import 'dart:io';
import 'dart:typed_data';

import 'package:plex_notifier/server/server.dart';

class ImagesController implements Controller {
  @override
  final HttpRequest req;

  ImagesController(this.req) {
    if (req.method != 'GET') {
      throw RouteNotFoundException();
    }
  }

  @override
  Future<void> execute() async {
    // ignore: omit_local_variable_types
    final String filePath =
        req.uri.toString().substring(1, req.uri.toString().length);
    // ignore: omit_local_variable_types
    final File file = File(filePath);

    if (file.existsSync() == false) {
      throw RouteNotFoundException();
    }

    // ignore: omit_local_variable_types
    final Uint8List bytes = file.readAsBytesSync();
    req.response.headers.add('Content-Type', 'image/jpeg; charset=utf-8');
    req.response.add(bytes.buffer.asUint8List());
  }
}
