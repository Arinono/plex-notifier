import 'package:plex_notifier/models/services.dart';
import 'package:plex_notifier/notification/channels/discord.dart';
import 'package:plex_notifier/plex/plexecutor.dart';
import 'package:test/test.dart';

void main() {
  group('NotificationChannel\n', () {
    group('Discord\n', () {
      test('it should instanciate a DiscordNotificationChannel', () {
        // ignore: omit_local_variable_types
        final NotificationChannel discord =
            NotificationChannel(Services.discord);

        expect(discord, isA<DiscordNotificationChannel>());
      });
    });
  });
}
