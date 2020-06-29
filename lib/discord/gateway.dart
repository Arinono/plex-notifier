import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:plex_notifier/credentials.dart';

class Gateway {
  BotGateway _gateway;
  WebSocket _socket;
  bool _heartbeatSent = false;
  bool ready = false;

  Gateway(BotGateway gateway) {
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
      // TODO reconnect and attempt to resume then throw if not possible
      throw GatewayHeartbeatException();
    }

    switch (event['op']) {
      case 10:
        heartbeating(event['d']['heartbeat_interval']);
        identify();
        break;
      case 11:
        _heartbeatSent = false;
        break;
      case 0:
        if (event['t'] == 'READY') {
          ready = true;
          print('🔗 Discord Gateway connection ready.');
        }
        break;
      case 2:
      default:
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
          'token': Credentials.botToken,
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
