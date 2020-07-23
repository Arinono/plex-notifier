import 'dart:convert';
import 'dart:io';

import 'package:mime/mime.dart';
import 'package:plex_notifier/plex/models/plex_webhook.dart';
import 'package:plex_notifier/plex/plex_webhook_parser.dart';
import 'package:plex_notifier/plex/plexecutor.dart';
import 'package:plex_notifier/server/server.dart';

class PlexController implements Controller {
  final PlexWebhookParser _parser = PlexWebhookParser();
  final Plexecutor plexecutor;
  final bool _isNotifierDisabled;
  String _boundary;
  MimeMultipartTransformer _transformer;

  @override
  final HttpRequest req;

  PlexController(this.req, this.plexecutor, this._isNotifierDisabled) {
    if (req.method != 'POST') {
      throw RouteNotFoundException();
    }
    if (req.headers.contentType.mimeType != 'multipart/form-data') {
      throw PlexControllerContentTypeException();
    }
    _boundary = req.headers.contentType.parameters['boundary'];
    _transformer = MimeMultipartTransformer(_boundary);
  }

  @override
  Future<void> execute() async {
    // ignore: omit_local_variable_types
    final List<int> bytes = <int>[];
    List<MimeMultipart> parts;
    PlexWebhook payload;
    String filename;
    var thumb;

    await for (var data in req) {
      bytes.addAll(data);
    }
    parts = await _transformer.bind(Stream.fromIterable([bytes])).toList();

    if (parts.length > 2) {
      throw MimeMultipartException();
    }

    for (var p in parts) {
      var part = RegExp(r'name="(payload|thumb)"')
          .firstMatch(p.headers['content-disposition'])
          .group(1);
      if (part != null) {
        switch (part) {
          case 'payload':
            try {
              // ignore: omit_local_variable_types
              final String content = utf8.decode((await p.toList())[0]);
              payload = _parser.parse(content);
            } catch (e) {
              print('PlexWebhookParserException: ${e.toString()}');
              throw PlexWebhookParserException();
            }
            break;
          case 'thumb':
            thumb = (await p.toList())[0];
            filename = '${PlexWebhookParser.getThumbName(payload)}.jpg';
            File('images/$filename').writeAsBytesSync(thumb);
            break;
        }
      }
    }

    req.response.write('OK');

    if (_isNotifierDisabled == false) {
      await plexecutor.execute(payload);
    }
  }
}

class PlexControllerContentTypeException implements Exception {
  PlexControllerContentTypeException();
}
