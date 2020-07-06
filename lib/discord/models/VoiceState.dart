import 'package:plex_notifier/discord/models/GuildMember.dart';

class VoiceState {
  String guildId;
  String channelId;
  String userId;
  GuildMember member;
  String sessionId;
  bool deaf;
  bool mute;
  bool selfDeaf;
  bool selfMute;
  bool selfStream;
  bool suppress;

  VoiceState(Map state) {
    guildId = state['guild_id'];
    channelId = state['channel_id'];
    userId = state['user-Id'];
    member = GuildMember(state['member']);
    sessionId = state['session_id'];
    deaf = state['deaf'];
    mute = state['mute'];
    selfDeaf = state['self_deaf'];
    selfMute = state['self_mute'];
    selfStream = state['self_stream'];
    suppress = state['suppress'];
  }
}
