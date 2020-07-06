class ClientStatus {
  String desktop;
  String mobile;
  String web;

  ClientStatus(Map status) {
    desktop = status['desktop'];
    mobile = status['mobile'];
    web = status['web'];
  }
}
