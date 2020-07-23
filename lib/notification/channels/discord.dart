import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:plex_notifier/notification/models/notification.dart';
import 'package:plex_notifier/plex/plexecutor.dart';

class DiscordNotificationChannel implements NotificationChannel {
  final String discordBotToken;
  final String channelId;
  final Map<String, String> _headers = <String, String>{};
  DiscordHttpClient http;
  DiscordWebsocketClient ws;

  DiscordNotificationChannel(this.discordBotToken, this.channelId);

  @override
  Future<Map<String, dynamic>> notify(Notification notification) async {
    if (channelId == null) {
      throw MissingChannelIdException();
    }
    // ignore: omit_local_variable_types
    final Response response = await http.createMessage(notification, channelId);
    return jsonDecode(response.body);
  }

  @override
  Future<void> connect() async {
    try {
      if (discordBotToken == null) {
        throw MissingDiscordBotTokenException();
      }

      _headers.putIfAbsent('Authorization', () => 'Bot ${discordBotToken}');

      http = DiscordHttpClient(_headers);

      // ignore: omit_local_variable_types
      final String gatewayUrl = await http.getGatewayUrl();
      ws = DiscordWebsocketClient(discordBotToken, gatewayUrl);
      await ws.connect();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> close() async {
    await ws.close();
  }
}

class DiscordHttpClient {
  final String _baseUrl = 'https://discord.com/api';
  final Map<String, String> headers;

  DiscordHttpClient(this.headers);

  Future<String> getGatewayUrl() async {
    final response = await http.get('$_baseUrl/gateway/bot', headers: headers);
    return jsonDecode(response.body)['url'];
  }

  Future<Response> createMessage(
      Notification notification, String channelId) async {
    headers.putIfAbsent('Content-Type', () => 'application/json');

    return await http.post(
      '$_baseUrl/channels/$channelId/messages',
      headers: headers,
      body: jsonEncode({'embed': notification}),
    );
  }
}

class DiscordWebsocketClient {
  final String _url;
  final String _discordBotToken;
  WebSocket socket;
  bool heartbeated = false;
  bool identified = false;
  int heartbeatInterval = -1;

  DiscordWebsocketClient(this._discordBotToken, this._url);

  Future<void> connect() async {
    socket = await WebSocket.connect(_url);
    socket.listen((event) => _socketEventHandler(event));
  }

  Future<void> close() async {
    print('\n🔴 Closing Discord Gateway connection.');
    await socket.close(1000);
  }

  void _socketEventHandler(dynamic _event) async {
    Map event = jsonDecode(_event);

    if ((heartbeated == true && event['op'] != 11) || event['op'] == 9) {
      await socket.close(1001);
      // TODO reconnect and attempt to resume then throw if not possible
      throw GatewayHeartbeatException();
    }

    switch (event['op']) {
      case 10:
        heartbeating(event['d']['heartbeat_interval']);
        identify();
        break;
      case 11:
        heartbeated = false;
        break;
      case 0:
        _opZeroHandler(event);
        break;
      case 2:
      default:
        break;
    }
  }

  void _opZeroHandler(Map<String, dynamic> event) async {
    switch (event['t']) {
      case 'READY':
        print('🔗 Discord Gateway connection ready.');
        identified = true;
        break;
    }
  }

  void heartbeating(int interval) {
    heartbeatInterval = interval;
    Timer.periodic(Duration(milliseconds: interval), (timer) {
      heartbeated = true;
      socket.add(
        jsonEncode({
          'op': 1,
          'd': null,
        }),
      );
    });
  }

  void identify() {
    socket.add(
      jsonEncode({
        'op': 2,
        'd': {
          'token': _discordBotToken,
          'properties': {
            '\$os': Platform.operatingSystem,
            '\$browser': 'plex_notifier',
            '\$device': Platform.localHostname
          }
        }
      }),
    );
  }
}

class MissingDiscordBotTokenException implements Exception {
  MissingDiscordBotTokenException();
}

class MissingChannelIdException implements Exception {
  MissingChannelIdException();
}

class GatewayHeartbeatException implements Exception {
  GatewayHeartbeatException();
}
