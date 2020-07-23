import 'dart:io';
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:mime/mime.dart';
import 'package:plex_notifier/models/services.dart';
import 'package:plex_notifier/notification/debouncer.dart';
import 'package:plex_notifier/plex/plex_webhook_parser.dart';
import 'package:plex_notifier/plex/plexecutor.dart';

import 'controllers/discord.dart';
import 'controllers/healthcheck.dart';
import 'controllers/images.dart';
import 'controllers/plex.dart';

class Server {
  final ArgResults args;
  final String discordClientId;
  final NotificationDebouncer debouncer = NotificationDebouncer();
  final NotificationBuilder builder = NotificationBuilder(Services.discord);
  final NotificationChannel channel = NotificationChannel(Services.discord);
  Plexecutor plexecutor;

  bool _isNotifierDisabled;
  int _port;
  HttpServer _server;

  Server(this.discordClientId, this.args) {
    final port = const String.fromEnvironment('PORT', defaultValue: '8080');
    _port = int.tryParse(port) ?? 8080;
    _isNotifierDisabled =
        Platform.environment['DISABLE_NOTIFIER'] == 'true' ? true : false;
    plexecutor = Plexecutor(debouncer, builder, channel, args);
  }

  Future<void> start() async {
    _server = await HttpServer.bind(
        InternetAddress.fromRawAddress(Uint8List.fromList([0, 0, 0, 0])),
        _port);
    print('🚀 Listening on localhost:${_port}');

    await for (HttpRequest req in _server) {
      try {
        req.response.statusCode = 200;
        await handleRequest(req);
      } on RouteNotFoundException {
        req.response.statusCode = 404;
        req.response.write('Route not found: ${req.method} ${req.uri}.');
        print('Route not found: ${req.uri}.');
      } on MissingDiscordClientIdException {
        req.response.statusCode = 500;
        req.response.write(
          'Required environment variable DISCORD_CLIENT_ID is missing.',
        );
        print('Required environment variable DISCORD_CLIENT_ID is missing.');
      } on PlexControllerContentTypeException {
        req.response.statusCode = 500;
        req.response.write('Expected Content-Type to be multipart/form-data');
      } on MimeMultipartException {
        req.response.statusCode = 500;
        req.response.write('Format error in the multipart/form-data');
      } on PlexWebhookParserException {
        req.response.statusCode = 500;
        req.response.write('The received payload is not a valid JSON');
      } finally {
        await req.response.close();
      }
    }
  }

  Future<void> close() async {
    print('🔴 Closing HTTP server.');
    await _server.close();
    print('Server successfully shutdown.');
  }

  Future<void> handleRequest(HttpRequest req) async {
    // ignore: omit_local_variable_types
    final Controller controller = Controller(
      req,
      discordClientId: discordClientId,
      isNotifierDisabled: _isNotifierDisabled,
      plexecutor: plexecutor,
    );

    await controller.execute();
  }
}

abstract class Controller {
  final HttpRequest req;
  Future<void> execute();

  factory Controller(
    HttpRequest req, {
    String discordClientId,
    NotificationChannel notifier,
    bool isNotifierDisabled,
    Plexecutor plexecutor,
  }) {
    switch (req.uri.toString()) {
      case '/health':
        return HealthcheckController(req);
      case '/discord':
        return DiscordController(req, discordClientId);
      case '/plex':
        return PlexController(req, plexecutor, isNotifierDisabled);
      default:
        if (req.uri.toString().startsWith('/images')) {
          return ImagesController(req);
        }
        throw RouteNotFoundException();
    }
  }
}

class RouteNotFoundException implements Exception {
  RouteNotFoundException();
}
