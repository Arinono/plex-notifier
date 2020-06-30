import 'dart:io';

import 'package:plex_notifier/server.dart';

class HealthcheckController implements Controller {
  final HttpRequest _req;

  HealthcheckController(this._req);

  @override
  Future<void> execute() async {
    if (_req.method != 'GET') {
      throw RouteNotFoundException();
    }

    _req.response.write('I\'m healthy.');
  }
}
