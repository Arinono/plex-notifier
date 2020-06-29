class Server {
  String title;
  String uuid;

  Server(Map server) {
    title = server['title'];
    uuid = server['uuid'];
  }
}
