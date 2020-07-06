import 'package:plex_notifier/discord/models/Role.dart';

import 'Channel.dart';
import 'GuildMember.dart';
import 'Message.dart';
import 'PresenceUpdate.dart';
import 'VoiceState.dart';

class Guild {
  String id;
  String name;
  String icon;
  String splash;
  String discoverySplash;
  bool owner;
  String ownerId;
  int permissions;
  String region;
  String afkChannelId;
  int afkTimeout;
  bool embedEnabled;
  String embedChannelId;
  int verificationLevel;
  int defaultMessageNotifications;
  int explicitContentFilter;
  List<Role> roles;
  List<Emoji> emojis;
  List<String> features;
  int mfaLevel;
  String applicationId;
  bool widgetEnabled;
  String widgetChannelId;
  String systemChannelId;
  int systemChannelFlags;
  String rulesChannelId;
  int joinedAt;
  bool large;
  bool unavailable;
  int memberCount;
  List<VoiceState> voiceStates;
  List<GuildMember> members;
  List<Channel> channels;
  List<PresenceUpdate> presences;
  int maxPresences;
  int maxMembers;
  String vanityUrlCode;
  String description;
  String banner;
  int premiumTier;
  int premiumSubscriptionCount;
  String preferredLocale;
  String publicUpdatesChannelId;
  int maxVideoChannelUsers;
  int approximateMemberCount;
  int approximatePresenceCount;

  Guild(Map guild) {
    id = guild['id'];
    name = guild['name'];
    icon = guild['icon'];
    splash = guild['splash'];
    discoverySplash = guild['discovery_splash'];
    owner = guild['owner'];
    ownerId = guild['owner_id'];
    permissions = guild['permissions'];
    region = guild['region'];
    afkChannelId = guild['afk_channel_id'];
    afkTimeout = guild['afk_timeout'];
    embedEnabled = guild['embed_enabled'];
    embedChannelId = guild['embed_channel_id'];
    verificationLevel = guild['verification_level'];
    defaultMessageNotifications = guild['default_message_notifications'];
    explicitContentFilter = guild['explicit_content_filter'];
    roles = guild['roles'] != null
        ? (guild['roles'] as List).map((r) => Role(r)).toList()
        : null;
    emojis = guild['emojis'] != null
        ? (guild['emojis'] as List).map((e) => Emoji(e)).toList()
        : null;
    features = guild['features'] != null
        ? (guild['features'] as List).map((f) => f.toString()).toList()
        : null;
    mfaLevel = guild['mfa_level'];
    applicationId = guild['application_id'];
    widgetEnabled = guild['widget_enabled'];
    widgetChannelId = guild['widget_channel_id'];
    systemChannelId = guild['system_channel_id'];
    systemChannelFlags = guild['system_channel_flags'];
    rulesChannelId = guild['rules_channel_id'];
    joinedAt = int.tryParse(guild['joined_at']);
    large = guild['large'];
    unavailable = guild['unavailable'];
    memberCount = guild['member_count'];
    voiceStates = guild['voice_states'] != null
        ? (guild['voice_states'] as List).map((s) => VoiceState(s)).toList()
        : null;
    members = guild['members'] != null
        ? (guild['members'] as List).map((m) => GuildMember(m)).toList()
        : null;
    channels = guild['channels'] != null
        ? (guild['channels'] as List).map((c) => Channel(c)).toList()
        : null;
    presences = guild['presences'] != null
        ? (guild['presences'] as List).map((p) => PresenceUpdate(p)).toList()
        : null;
    maxPresences = guild['max_presences'];
    maxMembers = guild['max_members'];
    vanityUrlCode = guild['vanity_url_code'];
    description = guild['description'];
    banner = guild['banner'];
    premiumTier = guild['premium_tier'];
    premiumSubscriptionCount = guild['premium_subscription_count'];
    preferredLocale = guild['preferred_locale'];
    publicUpdatesChannelId = guild['public_updates_channel_id'];
    maxVideoChannelUsers = guild['max_video_channel_users'];
    approximateMemberCount = guild['approximate_member_count'];
    approximatePresenceCount = guild['approximate_presence_count'];
  }
}
