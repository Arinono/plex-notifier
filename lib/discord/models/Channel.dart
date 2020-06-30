import 'User.dart';

class Channel {
  String id;
  int type;
  String guildId;
  int position;
  List<Overwrite> permissionOverwrites;
  String name;
  String topic;
  bool nsfw;
  String lastMessageId;
  int bitrate;
  int userLimit;
  int rateLimitPerUser;
  List<User> recipients;
  String icon;
  String ownerId;
  String applicationId;
  String parentId;
  int lastPinTimestamp;

  Channel(Map channel) {
    id = channel['id'];
    type = channel['type'];
    guildId = channel['guild_id'];
    position = channel['position'];
    permissionOverwrites = (channel['permission_overwrites'] as List)
        .map((e) => Overwrite(e))
        .toList();
    name = channel['name'];
    topic = channel['topic'];
    nsfw = channel['nsfw'];
    lastMessageId = channel['last_message_id'];
    bitrate = channel['bitrate'];
    userLimit = channel['user_limit'];
    rateLimitPerUser = channel['rate_limit_per_user'];
    recipients = channel['recipients'];
    icon = channel['icon'];
    ownerId = channel['owner_id'];
    applicationId = channel['application_id'];
    parentId = channel['parent_id'];
    lastPinTimestamp = channel['last_pin_timestamp'];
  }
}

class Overwrite {
  String id;
  String type;
  int allow;
  int deny;

  Overwrite(Map over) {
    id = over['id'];
    type = over['type'];
    allow = over['allow'];
    deny = over['deny'];
  }
}

class ChannelMention {
  String id;
  String guildId;
  int type;
  String name;

  ChannelMention(Map channel) {
    id = channel['id'];
    guildId = channel['guild_id'];
    type = channel['type'];
    name = channel['name'];
  }
}

enum ChannelTypes {
  GUILD_TEXT,
  DM,
  GUILD_VOICE,
  GROUP_DM,
  GUILD_CATEGORY,
  GUILD_NEWS,
  GUILD_STORE,
}
