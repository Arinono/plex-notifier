import 'package:plex_notifier/discord/models/User.dart';

class GuildMember {
  User user;
  String nick;
  List<String> roles;
  int joinedAt;
  int premiumSince;
  bool deaf;
  bool mute;

  GuildMember(Map member) {
    user = User(member['user']);
    nick = member['nick'];
    roles = member['roles'] != null
        ? (member['roles'] as List).map((r) => r.toString()).toList()
        : null;
    joinedAt = int.tryParse(member['joined_at']);
    premiumSince = member['premium_since'];
    deaf = member['deaf'];
    mute = member['mute'];
  }
}
