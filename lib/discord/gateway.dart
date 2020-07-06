import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:plex_notifier/discord/models/Guild.dart';
import 'package:plex_notifier/discord/models/GuildMember.dart';

class Gateway {
  final String _guildId;
  BotGateway _gateway;
  WebSocket _socket;
  bool _heartbeatSent = false;
  final Function _createChannelCallback;

  Gateway(BotGateway gateway, this._guildId, this._createChannelCallback) {
    _gateway = gateway;
  }

  Future<void> connect() async {
    _socket = await WebSocket.connect(_gateway.url);
    _socket.listen((event) => eventHandler(event));
  }

  Future<void> close() async {
    print('\n🔴 Closing Discord Gateway connection.');
    await _socket.close(1000);
  }

  void eventHandler(dynamic _event) async {
    Map event = jsonDecode(_event);

    if ((_heartbeatSent == true && event['op'] != 11) || event['op'] == 9) {
      await _socket.close(1001);
      // TODO reconnect and attempt to resume then throw if not possibledis
      throw GatewayHeartbeatException();
    }

    // print(event);
    switch (event['op']) {
      case 10:
        heartbeating(event['d']['heartbeat_interval']);
        identify();
        break;
      case 11:
        _heartbeatSent = false;
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
        break;
      case 'GUILD_CREATE':
        Guild guild;
        try {
          guild = Guild(event['d']);
          if (guild.members.indexWhere((GuildMember m) =>
                      m.user.username == 'Plex' && m.user.bot == true) !=
                  -1 &&
              guild.id == _guildId) {
            await _createChannelCallback();
          }
        } catch (e) {
          print('\n🔴 Closing Discord Gateway with error:');
          print(e);
          await _socket.close(1001);
          rethrow;
        }
        break;
    }
  }

  void heartbeating(int interval) {
    Timer.periodic(Duration(milliseconds: interval), (timer) {
      _heartbeatSent = true;
      _socket.add(
        jsonEncode({
          'op': 1,
          'd': null,
        }),
      );
    });
  }

  void identify() {
    _socket.add(
      jsonEncode({
        'op': 2,
        'd': {
          'token': const String.fromEnvironment('DISCORD_BOT_TOKEN',
              defaultValue: null),
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

class BotGateway {
  String url;
  int shards;
  BotGatewaySessionLimit sessionStartLimit;

  BotGateway(Map gateway) {
    url = gateway['url'];
    shards = gateway['shards'];
    sessionStartLimit = BotGatewaySessionLimit(gateway['session_start_limit']);
  }
}

class BotGatewaySessionLimit {
  int total;
  int remaining;
  int resetAfter;

  BotGatewaySessionLimit(Map session) {
    total = session['total'];
    remaining = session['remaining'];
    resetAfter = session['reset_after'];
  }
}

class GatewayHeartbeatException implements Exception {
  GatewayHeartbeatException();
}
