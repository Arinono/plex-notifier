import 'ClientStatus.dart';
import 'Message.dart';
import 'User.dart';

class PresenceUpdate {
  User user;
  List<String> roles;
  Activity game;
  String guildId;
  String status;
  List<Activity> activities;
  ClientStatus clientStatus;
  int premiumSince;
  String nick;

  PresenceUpdate(Map update) {
    user = User(update['user']);
    roles = update['roles'] != null
        ? (update['roles'] as List).map((r) => r.toString()).toList()
        : null;
    game = update['game'] != null ? Activity(update['game']) : null;
    guildId = update['guild_id'];
    status = update['status'];
    activities = update['activities'] != null
        ? (update['activities'] as List).map((a) => Activity(a)).toList()
        : null;
    clientStatus = ClientStatus(update['client_status']);
    premiumSince = update['premium_since'];
    nick = update['nick'];
  }
}
