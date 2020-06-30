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
    account = Account(notif['Account']);
    server = Server(notif['Server']);
    player = Player(notif['Player']);
    metadata = Metadata(notif['Metadata']);
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
