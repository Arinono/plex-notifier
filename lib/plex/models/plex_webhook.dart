import 'account.dart';
import 'metadata.dart';

/// # Plex Webhook
///
/// Represents the Plex Webhook parsed paylaod.
class PlexWebhook {
  /// Webhook event type
  ///
  /// ## Library events
  /// `library.new`, `library.on.deck`
  ///
  /// ## Media events
  /// `media.play`, `media.pause`, `media.resume`, `media.stop`, `media.scrobble`
  ///
  /// [See docs](https://support.plex.tv/articles/115002267687-webhooks/)
  String event;
  Account account;
  Metadata metadata;

  /// Constructs the `PlexWebhook` with the given content.
  PlexWebhook(
    this.event,
    this.account,
    this.metadata,
  );

  /// Constructs the `PlexWebhook` with the content
  /// of the Plex Webhook JSON blob.
  PlexWebhook.fromJson(Map<String, dynamic> payload) {
    event = payload['event'];
    account = Account.fromJson(payload['Account']);
    metadata = Metadata.fromJson(payload['Metadata']);
  }

  /// Returns a JSON blob for the `PlexWebhook`.
  Map<String, dynamic> toJson() {
    return {
      'event': event,
      'account': account,
      'metadata': metadata,
    };
  }
}
