class User {
  String id;
  String username;
  String discriminator;
  String avatar;
  bool bot;
  bool sysyem;
  bool mdaEnabled;
  String locale;
  bool verified;
  String email;
  int flags;
  int premiumType;
  int publicFlags;

  User(Map user) {
    id = user['id'];
    username = user['username'];
    discriminator = user['discriminator'];
    avatar = user['avatar'];
    bot = user['bot'];
    sysyem = user['sysyem'];
    mdaEnabled = user['mda_enabled'];
    locale = user['locale'];
    verified = user['verified'];
    email = user['email'];
    flags = user['flags'];
    premiumType = user['premium_type'];
    publicFlags = user['public_flags'];
  }
}

class Member {
  User user;
  String nick;
  List<String> roles;
  int joinedAt;
  int premiumSince;
  bool deaf;
  bool mute;

  Member(Map member) {
    user = member['user'];
    nick = member['nick'];
    roles = member['roles'];
    joinedAt = member['joined_at'];
    premiumSince = member['premium_since'];
    deaf = member['deaf'];
    mute = member['mute'];
  }
}
