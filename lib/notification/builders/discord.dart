import 'dart:io';

import 'package:plex_notifier/models/show.dart';
import 'package:plex_notifier/plex/models/plex_webhook.dart';
import 'package:plex_notifier/notification/models/notification.dart';
import 'package:plex_notifier/plex/plex_webhook_parser.dart';
import 'package:plex_notifier/plex/plexecutor.dart';

class DiscordNotificationBuilder implements NotificationBuilder {
  DiscordNotificationBuilder();

  @override
  Notification build({PlexWebhook webhook, Show show}) {
    if (webhook != null) {
      return _singleNotification(webhook);
    } else if (show != null) {
      return _groupNotifications(show);
    } else {
      throw DiscordNotificationBuilderNoContentProvidedException();
    }
  }

  Notification _singleNotification(PlexWebhook webhook) {
    // ignore: omit_local_variable_types
    final Map<String, dynamic> map = <String, dynamic>{
      'type': 'rich',
      'color': 0xe5a00d
    };
    // ignore: omit_local_variable_types
    final String title = webhook.metadata.grandparentTitle ??
        webhook.metadata.parentTitle ??
        webhook.metadata.title;

    if (webhook.event.startsWith('media.')) {
      map.addAll(_mediaNotification(webhook));
    } else {
      map.putIfAbsent('title', () => '$title has been added');
      map.putIfAbsent('description', () => webhook.metadata.summary);
    }

    if (webhook.metadata.thumb != null) {
      _addThumb(map, PlexWebhookParser.getThumbName(webhook));
    }

    return Notification(map);
  }

  Notification _groupNotifications(Show show) {
    // ignore: omit_local_variable_types
    final Map<String, dynamic> map = <String, dynamic>{
      'type': 'rich',
      'color': 0xe5a00d
    };
    // ignore: omit_local_variable_types
    final List<Field> fields = [];

    show.seasons.forEach((key, season) {
      fields.add(Field('Season', season.title, false));
      season.episodes.forEach((episode) {
        fields.add(Field('Episode', episode.title, true));
      });
    });

    map.putIfAbsent('title', () => '${show.title} has been added');
    map.putIfAbsent('fields', () => fields);
    if (show.thumb != null) {
      _addThumb(map, show.thumb);
    }

    return Notification(map);
  }

  Map<String, dynamic> _mediaNotification(PlexWebhook webhook) {
    // ignore: omit_local_variable_types
    final Map<String, dynamic> map = <String, dynamic>{
      'title': webhook.metadata.grandparentTitle
    };
    // ignore: omit_local_variable_types
    final String account = webhook.account.name;

    switch (webhook.event) {
      case 'media.play':
        map.putIfAbsent('description', () => 'Played by $account');
        break;
      case 'media.pause':
        map.putIfAbsent('description', () => 'Paused by $account');
        break;
      case 'media.stop':
        map.putIfAbsent('description', () => 'Stopped by $account');
        break;
      case 'media.resume':
        map.putIfAbsent('description', () => 'Resumed by $account');
        break;
      case 'media.scrobble':
        map.putIfAbsent('description', () => 'Finished by $account');
        break;
    }

    return map;
  }

  void _addThumb(Map<String, dynamic> map, String thumb) {
    // ignore: omit_local_variable_types
    final String selfDomain = Platform.environment['SELF_DOMAIN'];
    if (selfDomain == null) {
      print('Missing SELF_DOMAIN. Cannot link \'thumb\' in notification.');
    }
    map.putIfAbsent(
      'thumbnail',
      () => {'url': '$selfDomain/images/${thumb}.jpg'},
    );
  }
}

class Field {
  String name;
  String value;
  bool inline;

  Field(this.name, this.value, this.inline);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'inline': inline,
    };
  }
}

class DiscordNotificationBuilderNoContentProvidedException
    implements Exception {
  DiscordNotificationBuilderNoContentProvidedException();
}
