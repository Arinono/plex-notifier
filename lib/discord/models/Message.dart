import 'Channel.dart';
import 'Embed.dart';
import 'User.dart';

class Message {
  String id;
  String channelId;
  String guildId;
  User author;
  Member member;
  String content;
  int timestamp;
  int editedTimestamp;
  bool tts;
  bool mentionEveryone;
  List<User> mentions;
  List<String> mentionRoles;
  List<ChannelMention> mentionChannels;
  List<Attachment> attachments;
  List<Embed> embeds;
  List<Reaction> reactions;
  int nance;
  bool pinned;
  String webhookId;
  int type;
  Activity activity;
  Application application;
  MessageReference messageReference;
  int flags;

  Message(Map msg) {
    id = msg['id'];
    channelId = msg['channel_id'];
    guildId = msg['guild_id'];
    author = User(msg['author']);
    member = Member(msg['member']);
    content = msg['content'];
    timestamp = msg['timestamp'];
    editedTimestamp = msg['edited_timestamp'];
    tts = msg['tts'];
    mentionEveryone = msg['mention_everyone'];
    mentions = (msg['mentions'] as List).map((e) => User(e)).toList();
    mentionRoles = msg['mention_roles'];
    mentionChannels = (msg['mention_channels'] as List)
        .map((e) => ChannelMention(e))
        .toList();
    attachments =
        (msg['attachments'] as List).map((e) => Attachment(e)).toList();
    embeds = (msg['embeds'] as List).map((e) => Embed(e)).toList();
    reactions = (msg['reactions'] as List).map((e) => Reaction(e)).toList();
    nance = msg['nance'];
    pinned = msg['pinned'];
    webhookId = msg['webhook_id'];
    type = msg['type'];
    activity = Activity(msg['activity']);
    application = Application(msg['application']);
    messageReference = MessageReference(msg['message_reference']);
    flags = msg['flags'];
  }
}

class Attachment {
  String id;
  String filename;
  int size;
  String url;
  String proxyUrl;
  int height;
  int width;

  Attachment(Map attachment) {
    id = attachment['id'];
    filename = attachment['filename'];
    size = attachment['size'];
    url = attachment['url'];
    proxyUrl = attachment['proxy_url'];
    height = attachment['height'];
    width = attachment['width'];
  }
}

class Reaction {
  int count;
  bool me;
  Emoji emoji;

  Reaction(Map reac) {
    count = reac['count'];
    me = reac['me'];
    emoji = Emoji(reac['emoji']);
  }
}

class Emoji {
  String id;
  String name;
  List<String> roles;
  User user;
  bool requireColons;
  bool managed;
  bool animated;
  bool available;

  Emoji(Map emoji) {
    id = emoji['id'];
    name = emoji['name'];
    roles = emoji['roles'];
    user = emoji['user'];
    requireColons = emoji['require_colons'];
    managed = emoji['managed'];
    animated = emoji['animated'];
    available = emoji['available'];
  }
}

class Activity {
  int type;
  String partyId;

  Activity(Map activity) {
    type = activity['type'];
    partyId = activity['party_id'];
  }
}

class Application {
  String id;
  String coverImage;
  String description;
  String icon;
  String name;

  Application(Map app) {
    id = app['id'];
    coverImage = app['coverImage'];
    description = app['description'];
    icon = app['icon'];
    name = app['name'];
  }
}

class MessageReference {
  String messageId;
  String channelId;
  String guildId;

  MessageReference(Map ref) {
    messageId = ref['messageId'];
    channelId = ref['channelId'];
    guildId = ref['guildId'];
  }
}

enum MessageTypes {
  DEFAULT,
  RECIPIENT_ADD,
  RECIPIENT_REMOVE,
  CALL,
  CHANNEL_NAME_CHANGE,
  CHANNEL_ICON_CHANGE,
  CHANNEL_PINNED_MESSAGE,
  GUILD_MEMBER_JOIN,
  USER_PREMIUM_GUILD_SUBSCRIPTION,
  USER_PREMIUM_GUILD_SUBSCRIPTION_TIER_1,
  USER_PREMIUM_GUILD_SUBSCRIPTION_TIER_2,
  USER_PREMIUM_GUILD_SUBSCRIPTION_TIER_3,
  CHANNEL_FOLLOW_ADD,
  GUILD_DISCOVERY_DISQUALIFIED,
  GUILD_DISCOVERY_REQUALIFIED,
}

enum MessageActivityTypes {
  _,
  JOIN,
  SPECTATE,
  LISTEN,
  _1,
  JOIN_REQUEST,
}
