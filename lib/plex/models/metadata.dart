/// # Plex Metadata
///
/// Represents the `Account` value sent inside
/// a Plex Webhook payload.
class Metadata {
  /// Type of the content:
  ///
  /// `show`, `episode`, `track`, ...
  String type;

  /// Title of the episode.
  String title;

  /// Title of the season.
  String parentTitle;

  /// Title of the show.
  String grandparentTitle;

  /// UID of the episode.
  String guid;

  /// UID of the season.
  String parentGuid;

  /// UID of the show.
  String grandparentGuid;

  /// Summary of the episode.
  String summary;

  /// Summary of the episode.
  String thumb;

  /// Constructs the `Metadata` with the given content.
  Metadata(
    this.type,
    this.title,
    this.parentTitle,
    this.grandparentTitle,
    this.guid,
    this.parentGuid,
    this.grandparentGuid,
    this.summary,
    this.thumb,
  );

  /// Constructs the `Metadata` with the content
  /// of the Plex Webhook JSON blob.
  Metadata.fromJson(Map<String, dynamic> payload) {
    type = payload['type'];
    title = payload['title'];
    parentTitle = payload['parentTitle'];
    grandparentTitle = payload['grandparentTitle'];
    guid = payload['guid'];
    parentGuid = payload['parentGuid'];
    grandparentGuid = payload['grandparentGuid'];
    summary = payload['summary'];
    thumb = payload['thumb'];
  }

  /// Returns a JSON blob for the `Metadata`.
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'parentTitle': parentTitle,
      'grandparentTitle': grandparentTitle,
      'guid': guid,
      'parentGuid': parentGuid,
      'grandparentGuid': grandparentGuid,
      'summary': summary,
      'thumb': thumb,
    };
  }
}
