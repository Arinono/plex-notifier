/// # Plex Account
///
/// Represents the `Account` value sent inside
/// a Plex Webhook payload.
class Account {
  /// The name of the `Account`.
  String name;

  /// Constructs the `Account` with the given name.
  Account(
    this.name,
  );

  /// Constructs the `Account` with the content
  /// of the Plex Webhook JSON blob.
  Account.fromJson(Map<String, dynamic> payload) {
    name = payload['title'];
  }

  /// Returns a JSON blob for the `Account`.
  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
