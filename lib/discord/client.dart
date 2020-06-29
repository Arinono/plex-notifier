import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as Http;
import 'package:plex_notifier/credentials.dart';
import 'package:plex_notifier/discord/gateway.dart';
import 'package:plex_notifier/models/Channel.dart';
import 'package:plex_notifier/models/Embed.dart';

class DiscordClient {
  final String _guildId;
  final String _hostUrl;
  final String _baseUrl = 'https://discord.com/api';
  final Map<String, String> _headers = HashMap();
  Gateway _gateway;

  List<Channel> channels;

  DiscordClient(this._guildId, this._hostUrl) {
    _headers.putIfAbsent('Authorization', () => 'Bot ${Credentials.botToken}');
  }

  Future<List<Channel>> getChannels() async {
    var response = await Http.get(
      '$_baseUrl/guilds/$_guildId/channels',
      headers: _headers,
    );

    channels =
        (jsonDecode(response.body) as List).map((c) => Channel(c)).toList();
    return channels;
  }

  Future<Channel> createPlexChannel() async {
    if (plexChannel == null) {
      var headers = _headers;
      headers.putIfAbsent('Content-Type', () => 'application/json');
      var response = await Http.post(
        '$_baseUrl/guilds/$_guildId/channels',
        headers: headers,
        body: jsonEncode({
          'name': 'plex',
          'type': ChannelTypes.GUILD_TEXT.index.toString(),
          'topic': 'Plex notifications channel.',
        }),
      );

      var channel = Channel(jsonDecode(response.body));
      channels.add(channel);
      return channel;
    }
    return plexChannel;
  }

  Future<void> createMessage(Embed content, [String file]) async {
    var headers = _headers;
    headers.putIfAbsent('Content-Type', () => 'application/json');
    if (file != null) {
      content.thumbnail =
          EmbedThumbnail.from('$_hostUrl/images/$file', null, null);
    }
    await Http.post(
      '$_baseUrl/channels/${plexChannel.id}/messages',
      headers: headers,
      body: jsonEncode({'embed': content}),
    );
  }

  Future<void> connectToGateway() async {
    var _botGateway = await getGateway();
    _gateway = Gateway(_botGateway);
    return await _gateway.connect();
  }

  Future<void> closeGatewayConnection() async {
    if (_gateway != null) {
      await _gateway.close();
    }
  }

  Future<BotGateway> getGateway() async {
    var response = await Http.get('$_baseUrl/gateway/bot', headers: _headers);
    return BotGateway(jsonDecode(response.body));
  }

  Channel get plexChannel {
    if (channels == null) {
      return null;
    }
    return channels.firstWhere(
      (Channel c) =>
          c.type == ChannelTypes.GUILD_TEXT.index && c.name == 'plex',
      orElse: () => null,
    );
  }
}

enum Toto { Tata }
