class Player {
  bool local;
  String publicAddress;
  String title;
  String uuid;

  Player(Map player) {
    if (player == null) {
      return;
    }
    local = player['local'];
    publicAddress = player['publicAddress'];
    title = player['title'];
    uuid = player['uuid'];
  }
}
