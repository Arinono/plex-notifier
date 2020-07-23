import 'package:plex_notifier/models/services.dart';
import 'package:plex_notifier/notification/builders/discord.dart';
import 'package:plex_notifier/plex/plexecutor.dart';
import 'package:test/test.dart';

void main() {
  group('NotificationBuilder\n', () {
    group('Discord\n', () {
      test('it should instanciate a DiscordNotificationBuilder', () {
        // ignore: omit_local_variable_types
        final NotificationBuilder discord =
            NotificationBuilder(Services.discord);

        expect(discord, isA<DiscordNotificationBuilder>());
      });
    });
  });
}
