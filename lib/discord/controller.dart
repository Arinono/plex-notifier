import 'dart:async';
import 'dart:io';

import 'package:plex_notifier/server.dart';

class DiscordController implements Controller {
  final HttpRequest _req;
  final String _permissions = '35856';
  final String _scope = 'bot';

  DiscordController(this._req);

  @override
  Future<void> execute() async {
    if (_req.method != 'GET') {
      throw RouteNotFoundException();
    }

    await _req.response.redirect(
      Uri.https('discord.com', '/api/oauth2/authorize', {
        'client_id': const String.fromEnvironment('DISCORD_CLIENT_ID',
            defaultValue: null),
        'permissions': _permissions,
        'scope': _scope
      }),
    );
  }
}
