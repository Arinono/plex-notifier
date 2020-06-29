class Player {
  bool local;
  String publicAddress;
  String title;
  String uuid;

  Player(Map player) {
    local = player['local'];
    publicAddress = player['publicAddress'];
    title = player['title'];
    uuid = player['uuid'];
  }
}
