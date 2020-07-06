import 'package:plex_notifier/discord/models/Embed.dart';
import 'package:plex_notifier/plex/models/Metadata.dart';
import 'package:plex_notifier/plex/models/Player.dart';

import 'Account.dart';
import 'Server.dart';

class Notification {
  String event;
  bool user;
  bool owner;
  Account account;
  Server server;
  Player player;
  Metadata metadata;

  Notification(Map notif) {
    event = notif['event'];
    user = notif['user'];
    owner = notif['owner'];
    account = notif['Account'] != null ? Account(notif['Account']) : null;
    server = notif['Server'] != null ? Server(notif['Server']) : null;
    player = notif['Player'] != null ? Player(notif['Player']) : null;
    metadata = notif['Metadata'] != null ? Metadata(notif['Metadata']) : null;
  }

  Embed fmt() {
    switch (event) {
      case 'library.new':
        return _new();
      case 'media.play':
        return _control('Played');
      case 'media.resume':
        return _control('Resumed');
      case 'media.pause':
        return _control('Paused');
      case 'media.stop':
        return _control('Stopped');
      case 'media.scrobble':
        return _control('Finished');
      default:
        return null;
    }
  }

  Embed _new() {
    /**
     * I need to use the debouncer here to get the recuring shows.
     * 
     * Also the fmt() methods as to become a Future/Completer and wait for
     * the timeout to solve the future
     * 
     * It will send an Embed for a single episode or multiple shows.
     */

    print('Metadata type debug for #3: ${metadata.type}');
    switch (metadata.type) {
      case 'episode':
        return Embed.forDiscord(
            '${metadata.grandparentTitle ?? metadata.title} has been added',
            metadata.summary, [
          EmbedField.from(
            'Season',
            season ?? 'Not provided',
            false,
          ),
          EmbedField.from(
            'Episode',
            episode ?? 'Not provided',
            false,
          ),
        ]);
      default:
        return Embed.forDiscord(
          '${metadata.grandparentTitle ?? metadata.title} has been added.',
          null,
          null,
        );
    }
  }

  String get season {
    return metadata.parentTitle.replaceFirst('Season ', '');
  }

  String get episode {
    return metadata.title.replaceFirst('Episode ', '');
  }

  Embed _control(String control) {
    return Embed.forDiscord(
        '${metadata.grandparentTitle}', '$control by ${account.title}.', [
      EmbedField.from(
        'Season',
        season,
        false,
      ),
      EmbedField.from(
        'Episode',
        episode,
        false,
      ),
    ]);
  }
}
