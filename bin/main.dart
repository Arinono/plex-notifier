import 'dart:io';

import 'package:args/args.dart';
import 'package:plex_notifier/server.dart';

ArgResults argResults;

Future main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag('media',
        negatable: true, defaultsTo: true, help: 'Enable plex media.* events.')
    ..addFlag('library',
        negatable: true,
        defaultsTo: true,
        help: 'Enable plex library.new event.');
  parser.addFlag('help',
      negatable: false, abbr: 'h', callback: (help) => usage(help, parser));
  var server = Server(parser.parse(arguments));

  argResults = parser.parse(arguments);

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

void usage(bool help, ArgParser parser) {
  if (help) {
    print(parser.usage);
    exit(0);
  }
}
