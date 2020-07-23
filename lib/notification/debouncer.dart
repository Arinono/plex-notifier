import 'dart:collection';

import 'package:plex_notifier/models/episode.dart';
import 'package:plex_notifier/models/season.dart';
import 'package:plex_notifier/models/show.dart';
import 'package:plex_notifier/plex/models/plex_webhook.dart';

/// # NotificationDebouncer
class NotificationDebouncer {
  /// Internal notification [HashMap].
  final HashMap<String, Show> _notifications = HashMap<String, Show>();

  NotificationDebouncer();

  /// Register new incomming notification using the `PlexWebhook` object.
  /// Also set a [Timer] using the given `callback` and an optional `duration`
  /// [Duration].
  ///
  /// When a new show comes in, sets it using its UID in the map.
  ///
  /// When a notification from an existing show comes in, resets the show
  /// [Timer] and add the new content to its map (either a new season or a
  /// new episode).
  void register(PlexWebhook webhook, Function callback,
      {Duration duration = const Duration(minutes: 3)}) {
    final gpguid = webhook.metadata.grandparentGuid;
    final pguid = webhook.metadata.parentGuid;
    // ignore: omit_local_variable_types
    final Show show = _notifications[gpguid];

    if (_notifications.containsKey(gpguid)) {
      show.resetTimer(callback, duration: duration);
      if (_notifications[gpguid].seasons.containsKey(pguid)) {
        if (_notifications[gpguid]
            .seasons[pguid]
            .episodes
            .contains(Episode.fromWebhook(webhook))) {
          return;
        }
        _notifications[gpguid]
            .seasons[pguid]
            .episodes
            .add(Episode.fromWebhook(webhook));
        return;
      }
      _notifications[gpguid].seasons[pguid] = Season.fromWebhook(webhook);
      return;
    }
    _notifications[gpguid] =
        Show.fromWebhook(webhook, callback, duration: duration);
  }

  /// Returns a `Show` using its UID.
  Show getShow(String uid) {
    return _notifications[uid];
  }
}
