import 'package:plex_notifier/plex/models/plex_webhook.dart';

import 'episode.dart';

/// # Season
///
/// Represents a season when stored in the `NotificationDebouncer`
class Season {
  /// UID of the season
  String id;

  /// Title of the season
  String title;

  /// List of `Episode`
  List<Episode> episodes = [];

  /// Constructs the `Season` with an `id`, a `title` and some `episodes`.
  Season(this.id, this.title, this.episodes);

  /// Constructs the `Season` with the content
  /// of the Plex Webhook JSON blob.
  Season.fromWebhook(PlexWebhook webhook) {
    id = webhook.metadata.parentGuid;
    title = webhook.metadata.parentTitle;
    episodes.add(Episode.fromWebhook(webhook));
  }

  /// Returns a JSON blob for the `Season`.
  Map<String, dynamic> toJson() {
    // ignore: omit_local_variable_types
    final Map<String, dynamic> map = {'title': title, 'episodes': []};
    for (var e in episodes) {
      map['episodes'].add(e.toJson());
    }
    return map;
  }
}
