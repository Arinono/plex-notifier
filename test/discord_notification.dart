import 'package:plex_notifier/notification/models/discord_notification.dart';
import 'package:test/test.dart';

void main() {
  group('DiscordNotification\n', () {
    test('it should have a notification property', () {
      // ignore: omit_local_variable_types
      final DiscordNotification notif = DiscordNotification({
        'dummy': 'notification',
      });
      expect(notif.notification, isA<Map<String, dynamic>>());
    });
  });
}
