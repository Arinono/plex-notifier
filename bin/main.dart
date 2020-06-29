import 'dart:io';

import 'package:plex_notifier/server.dart';

Future main() async {
  var server = Server();
  await server.start();

  ProcessSignal.sigint.watch().listen((signal) async {
    await server.close();
  });
  ProcessSignal.sigkill.watch().listen((signal) async {
    await server.close();
  });
  ProcessSignal.sigterm.watch().listen((signal) async {
    await server.close();
  });
  ProcessSignal.sigquit.watch().listen((signal) async {
    await server.close();
  });
}
