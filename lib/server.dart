import 'dart:io';
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:plex_notifier/discord/controller.dart';
import 'package:plex_notifier/healthcheck/controller.dart';

import 'discord/client.dart';
import 'images/controller.dart';
import 'plex/controller.dart';

class Server {
  final ArgResults args;
  int _port;
  HttpServer _server;
  String _guildId;
  DiscordClient _client;
  String _hostUrl;

  Server(this.args) {
    var port = const String.fromEnvironment('PORT', defaultValue: '80');
    _port = int.tryParse(port) ?? 80;

    _guildId = Platform.environment['DISCORD_GUILD_ID'];
    if (_guildId == null) {
      print('DISCORD_GUILD_ID environment variable is required.');
      exit(1);
    }
    _hostUrl = Platform.environment['HOST_URL'];
    if (_hostUrl == null) {
      print('HOST_URL environment variable is required.');
      exit(1);
    }
    _client = DiscordClient(_guildId, _hostUrl);
    _client.connectToGateway().then((_) => null);
    Directory('images').createSync();
  }

  Future start() async {
    _server = await HttpServer.bind(
        InternetAddress.fromRawAddress(Uint8List.fromList([0, 0, 0, 0])),
        _port);
    print('🚀 Listening on localhost:${_port}');

    await for (HttpRequest req in _server) {
      try {
        var controller = Controller(req, _client, _guildId, args);
        await controller.execute();
      } on RouteNotFoundException {
        req.response.statusCode = 404;
        req.response.write('Route not found: ${req.uri}.');
        print('Route not found: ${req.uri}.');
      } on PlexException {
        req.response.statusCode = 500;
        print('An error occured while reading the Plex notification.');
      } on OpenFileException {
        req.response.statusCode = 500;
        req.response.write('Cannot open file: ${req.uri}.');
        print('Cannot open file: ${req.uri}.');
      } finally {
        await req.response.close();
      }
    }
  }

  Future<void> close() async {
    await _client.closeGatewayConnection();
    print('🔴 Closing HTTP server.');
    await _server.close();
    print('Server successfully shutdown.');
  }

  HttpServer get server {
    return _server;
  }
}

abstract class Controller {
  Future<void> execute();

  factory Controller(HttpRequest _req, DiscordClient _client, String _guildId,
      ArgResults args) {
    switch (_req.uri.toString()) {
      case '/plex':
        return PlexController(_req, _client, _guildId, args);
      case '/discord':
        return DiscordController(_req);
      case '/health':
        return HealthcheckController(_req);
      default:
        if (_req.uri.toString().startsWith('/images')) {
          return ImagesController(_req);
        }
        throw RouteNotFoundException();
    }
  }
}

class RouteNotFoundException implements Exception {
  RouteNotFoundException();
}
