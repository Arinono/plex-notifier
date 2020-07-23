import 'dart:async';
import 'dart:collection';

import 'package:plex_notifier/plex/models/plex_webhook.dart';
import 'package:plex_notifier/plex/plex_webhook_parser.dart';

import 'package:plex_notifier/models/season.dart';

/// # Show
///
/// Represents a show when stored in the `NotificationDebouncer`.
class Show {
  /// UID od the show.
  String id;

  /// Title of the show.
  String title;

  /// Thumb name
  String thumb;

  /// HashMap containing a the Show UID as key and a set of seasons.
  ///
  /// ```json
  /// {
  ///   "showUID": {
  ///     "title": "Show title",
  ///     "seasonUID": {
  ///       "id": "seasonUID",
  ///       "title": "Season title",
  ///       "episodes": [{
  ///         "id": "episodeUID",
  ///         "title": "Episode title",
  ///         "summary": "Episode summary"
  ///       },
  ///       { ... }]
  ///     }
  ///   }
  /// }
  /// ```
  HashMap<String, Season> seasons = HashMap<String, Season>();

  /// A [Timer] used to debounce notification.
  ///
  /// ## Use case
  /// **When** a Plex Webhook comes in, a [Timer] is attached to the show.
  ///
  /// **And** if a new episode comes in for the same show
  ///
  /// **Then** the [Timer] is resetted
  ///
  /// **And When** the [Timer] times out
  ///
  /// **Then** the callback is fired as it should (to send to notification)
  Timer timer;

  /// Constructs the `Show` with an `id`, a `title`, some `seasons` and a
  /// `callback` to call when the [Timer] times out.
  ///
  /// #### Optionnal named arguments:
  /// **duration**: the [Duration] of the [Timer]. Default to 3 minutes.
  Show(this.id, this.title, this.thumb, this.seasons, Function callback,
      {Duration duration}) {
    timer = Timer(Duration(minutes: duration ?? 3), callback);
  }

  /// Constructs the `Show` with the content
  /// of the Plex Webhook JSON blob.
  ///
  /// Also takes a `callback` to call when the [Timer] times out.
  ///
  /// #### Optionnal named arguments:
  /// **duration**: the [Duration] of the [Timer]. Default to 3 minutes.
  Show.fromWebhook(PlexWebhook webhook, Function callback,
      {Duration duration = const Duration(minutes: 3)}) {
    id = webhook.metadata.grandparentGuid;
    title = webhook.metadata.grandparentTitle;
    thumb = PlexWebhookParser.getThumbName(webhook);
    seasons[webhook.metadata.parentGuid] = Season.fromWebhook(webhook);
    timer = Timer(duration, callback);
  }

  /// Resets the [Timer] with the given `callback` and an optional
  /// `duration` (which defaults to 3 minutes).
  void resetTimer(Function callback,
      {Duration duration = const Duration(minutes: 3)}) {
    timer.cancel();
    timer = Timer(duration, callback);
  }

  /// Returns a JSON blob for the `Show`.
  Map<String, dynamic> toJson() {
    // ignore: omit_local_variable_types
    final Map<String, Map<String, dynamic>> map = {
      id: {'title': title, 'thumb': thumb}
    };

    for (var k in seasons.keys) {
      map[id][k] = seasons[k].toJson();
    }
    return map;
  }
}
