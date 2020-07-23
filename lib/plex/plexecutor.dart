import 'dart:io';

import 'package:args/args.dart';
import 'package:plex_notifier/models/services.dart';
import 'package:plex_notifier/models/show.dart';
import 'package:plex_notifier/notification/builders/discord.dart';
import 'package:plex_notifier/notification/channels/discord.dart';
import 'package:plex_notifier/notification/debouncer.dart';
import 'package:plex_notifier/plex/models/plex_webhook.dart';
import 'package:plex_notifier/notification/models/notification.dart';

class Plexecutor {
  final ArgResults args;
  final NotificationDebouncer debouncer;
  final NotificationBuilder builder;
  final NotificationChannel notifier;

  Plexecutor(this.debouncer, this.builder, this.notifier, this.args);

  Future<void> execute(PlexWebhook webhook,
      {Duration duration = const Duration(minutes: 3)}) async {
    switch (webhook.event) {
      case 'library.new':
        if (args['library'] == false) break;
        if (webhook.metadata.type
            .contains(RegExp(r'(episode|season|show|album|track)'))) {
          debouncer.register(webhook, () async {
            // ignore: omit_local_variable_types
            final Show show =
                debouncer.getShow(webhook.metadata.grandparentGuid);
            // ignore: omit_local_variable_types
            final Notification notification = builder.build(show: show);
            await notifier.notify(notification);
          }, duration: duration);
          break;
        }
        await _callNotifier(webhook);
        break;
      default:
        if (args['media'] == false) break;
        await _callNotifier(webhook);
        break;
    }
  }

  Future<void> _callNotifier(PlexWebhook webhook) async {
    // ignore: omit_local_variable_types
    final Notification notification = builder.build(webhook: webhook);
    await notifier.notify(notification);
  }
}

abstract class NotificationChannel {
  Future<void> notify(Notification notification);
  Future<void> connect();
  Future<void> close();

  factory NotificationChannel(Services type) {
    switch (type) {
      case Services.discord:
      default:
        // ignore: omit_local_variable_types
        final String discordBotToken = const String.fromEnvironment(
          'DISCORD_BOT_TOKEN',
          defaultValue: null,
        );
        // ignore: omit_local_variable_types
        final String discordChannelId =
            Platform.environment['DISCORD_CHANNEL_ID'];
        return DiscordNotificationChannel(discordBotToken, discordChannelId);
    }
  }
}

abstract class NotificationBuilder {
  Notification build({PlexWebhook webhook, Show show});

  factory NotificationBuilder(Services type) {
    switch (type) {
      case Services.discord:
      default:
        return DiscordNotificationBuilder();
    }
  }
}
