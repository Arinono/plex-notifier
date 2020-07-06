class Role {
  String id;
  String name;
  int color;
  bool hoist;
  int position;
  int permissions;
  bool managed;
  bool mentionable;

  Role(Map role) {
    id = role['id'];
    name = role['name'];
    color = role['color'];
    hoist = role['hoist'];
    position = role['position'];
    permissions = role['permissions'];
    managed = role['managed'];
    mentionable = role['mentionable'];
  }
}
