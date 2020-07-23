import 'dart:io';

import 'package:plex_notifier/server/server.dart';

class HealthcheckController implements Controller {
  final HttpRequest req;

  HealthcheckController(this.req) {
    if (req.method != 'GET') {
      throw RouteNotFoundException();
    }
  }

  @override
  Future<void> execute() async {
    req.response.write('I\'m healthy.');
  }
}
