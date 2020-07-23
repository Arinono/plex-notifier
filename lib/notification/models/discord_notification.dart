import 'package:plex_notifier/notification/models/notification.dart';

class DiscordNotification implements Notification {
  @override
  Map<String, dynamic> notification;

  DiscordNotification(this.notification);

  Map<String, dynamic> toJson() {
    // ignore: omit_local_variable_types
    final Map<String, dynamic> map = <String, dynamic>{
      'type': notification['type'],
      'color': notification['color'],
      'title': notification['title'],
    };

    if (notification['description'] != null) {
      map.putIfAbsent('description', () => notification['description']);
    }
    if (notification['fields'] != null) {
      map.putIfAbsent('fields', () => notification['fields']);
    }
    if (notification['thumbnail'] != null) {
      map.putIfAbsent('thumbnail', () => notification['thumbnail']);
    }

    return map;
  }
}
