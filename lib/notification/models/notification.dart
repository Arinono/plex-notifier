import 'package:plex_notifier/models/services.dart';
import 'package:plex_notifier/notification/models/discord_notification.dart';

abstract class Notification {
  Map<String, dynamic> notification;

  factory Notification(Map<String, dynamic> notification, [Services type]) {
    switch (type) {
      case Services.discord:
      default:
        return DiscordNotification(notification);
    }
  }
}
