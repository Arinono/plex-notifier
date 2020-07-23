import 'package:plex_notifier/models/services.dart';
import 'package:plex_notifier/notification/models/discord_notification.dart';
import 'package:test/test.dart';
import 'package:plex_notifier/notification/models/notification.dart';

void main() {
  group('Notification\n', () {
    group('Discord\n', () {
      test('it should instanciate a DiscordNotification', () {
        // ignore: omit_local_variable_types
        final Notification discord = Notification(
          {'dummy notification': true},
          Services.discord,
        );

        expect(discord, isA<DiscordNotification>());
      });
    });
  });
}
