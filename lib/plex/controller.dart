import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:mime/mime.dart';
import 'package:plex_notifier/discord/client.dart';
import 'package:plex_notifier/plex/models/Notification.dart';

import '../server.dart';

class PlexController implements Controller {
  final HttpRequest _req;
  final DiscordClient _client;
  final ArgResults args;
  String _boundary;
  MimeMultipartTransformer _transformer;

  PlexController(this._req, this._client, String guildId, this.args) {
    if (_req.headers.contentType.mimeType != 'multipart/form-data') {
      throw PlexException();
    }
    _boundary = _req.headers.contentType.parameters['boundary'];
    _transformer = MimeMultipartTransformer(_boundary);
  }

  @override
  Future<void> execute() async {
    final bytes = <int>[];
    var parts = [];
    var payload;
    var thumb;

    if (_req.method != 'POST') {
      throw RouteNotFoundException();
    }

    await for (var data in _req) {
      bytes.addAll(data);
    }

    parts = await _transformer.bind(Stream.fromIterable([bytes])).toList();

    if (parts.length > 2) {
      throw PlexException();
    }
    for (var i = 0; i < parts.length; i++) {
      if (i == 0) {
        if (parts[i].headers['content-type'] != 'application/json' ||
            RegExp(r'name="(payload)"')
                    .firstMatch(parts[i].headers['content-disposition'])
                    .group(1) ==
                null) {
          throw PlexException();
        }
        payload = jsonDecode(utf8.decode((await parts[i].toList())[0])) as Map;
      } else if (i == 1) {
        if (parts[i].headers['content-type'] != 'image/jpeg' ||
            RegExp(r'name="(thumb)"')
                    .firstMatch(parts[i].headers['content-disposition'])
                    .group(1) ==
                null) {
          throw PlexException();
        }
        thumb = (await parts[i].toList())[0];
      }
    }

    var filename;
    if (thumb != null) {
      filename =
          '${payload['Metadata']['thumb'].toString().replaceFirst('/library/', '').replaceAll('/', '-')}.jpeg';
      await File('images/$filename').writeAsBytes(thumb);
    }

    await _sendNotification(payload, filename);
  }

  Future<void> _sendNotification(Map _notif, [String filename]) async {
    var notif = Notification(_notif);
    if ((notif.event.contains('media') && args['media'] == false) ||
        (notif.event.contains('library') && args['library'] == false)) {
      return;
    }
    var str = notif.fmt();

    await _client.getChannels();
    if (str != null) {
      await _client.createMessage(str, filename);
    }
  }
}

class PlexException implements Exception {
  PlexException();
}
