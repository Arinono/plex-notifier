import 'dart:io';

import 'package:plex_notifier/credentials.dart';
import 'package:plex_notifier/discord/client.dart';
import 'package:plex_notifier/server.dart';

class DiscordController implements Controller {
  final HttpRequest _req;
  final String _permissions = '35856';
  final String _scope = 'bot';
  final DiscordClient _client;

  DiscordController(this._req, this._client);

  @override
  Future<void> execute() async {
    if (_req.method != 'GET') {
      throw RouteNotFoundException();
    }

    await _req.response.redirect(
      Uri.https('discord.com', '/api/oauth2/authorize', {
        'client_id': Credentials.clientId,
        'permissions': _permissions,
        'scope': _scope
      }),
    );
    await _client.getChannels();
    await _client.createPlexChannel();
  }
}
