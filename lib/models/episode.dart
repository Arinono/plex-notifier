import 'package:plex_notifier/plex/models/plex_webhook.dart';

/// # Episode
///
/// Represents a season when stored in the `NotificationDebouncer`
class Episode {
  String id;
  String title;
  String summary;

  /// Constructs the `Episode` with an `id`, a `title` and a `summary`.
  Episode(this.id, this.title, this.summary);

  /// Constructs the `Episode` with the content
  /// of the Plex Webhook JSON blob.
  Episode.fromWebhook(PlexWebhook webhook) {
    id = webhook.metadata.guid;
    title = webhook.metadata.title;
    summary = webhook.metadata.summary;
  }

  /// Returns a JSON blob for the `Episode`.
  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'summary': summary};
  }
}
