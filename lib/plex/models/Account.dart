class Account {
  int id;
  String thumb;
  String title;

  Account(Map account) {
    id = account['id'];
    thumb = account['thumb'];
    title = account['title'];
  }
}
