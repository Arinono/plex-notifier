import 'dart:io';

import 'package:plex_notifier/server.dart';

Future main() async {
  var server = Server();

  ProcessSignal.sigint.watch().listen((signal) async {
    await server.close();
    exit(0);
  });
  ProcessSignal.sigterm.watch().listen((signal) async {
    await server.close();
    exit(0);
  });

  await server.start();
}
