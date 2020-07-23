import 'dart:convert';

import 'package:plex_notifier/plex/models/plex_webhook.dart';

/// # PlexWebhookParser
///
/// Small parser to help get the content of the
/// Plex Webhook (as a String) into a `PlexWebhook` object.
class PlexWebhookParser {
  PlexWebhookParser();

  /// Returns a `PlexWebhook` from a String JSON blob.
  ///
  /// Thows [PlexWebhookParserException] on invalid JSON
  /// (on [FormatException]).
  PlexWebhook parse(String content) {
    Map<String, dynamic> payload;
    try {
      payload = jsonDecode(content);
    } on FormatException {
      throw PlexWebhookParserException();
    }
    return PlexWebhook.fromJson(payload);
  }

  static String getThumbName(PlexWebhook webhook) {
    if (webhook.metadata.thumb == null) return null;
    return webhook.metadata.thumb
        .toString()
        .replaceFirst('/library/', '')
        .replaceAll('/', '-');
  }
}

/// Specific exception thown when catching a [FormatException] while parsing
/// the Plex Webhook content specifically.
class PlexWebhookParserException implements Exception {
  PlexWebhookParserException();
}
