import 'dart:io';

import 'package:plex_notifier/server/server.dart';

class DiscordController implements Controller {
  @override
  final HttpRequest req;
  final String clientId;
  final String _permissions = '35856';
  final String _scope = 'bot';

  DiscordController(this.req, this.clientId) {
    if (req.method != 'GET') {
      throw RouteNotFoundException();
    }
    if (clientId == null) {
      throw MissingDiscordClientIdException();
    }
  }

  @override
  Future<void> execute() async {
    await req.response.redirect(
      Uri.https('discord.com', '/api/oauth2/authorize', {
        'client_id': clientId,
        'permissions': _permissions,
        'scope': _scope,
      }),
    );
  }
}

class MissingDiscordClientIdException implements Exception {
  MissingDiscordClientIdException();
}
