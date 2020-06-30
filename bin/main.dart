import 'dart:io';

import 'package:args/args.dart';
import 'package:plex_notifier/server.dart';

ArgResults argResults;

Future main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag(
      'media',
      negatable: true,
      defaultsTo: true,
      help: 'Enable plex media.* events.',
    )
    ..addFlag(
      'library',
      negatable: true,
      defaultsTo: true,
      help: 'Enable plex library.new event.',
    )
    ..addFlag(
      'verbose',
      negatable: false,
      defaultsTo: false,
      help: 'Add more logging.',
      abbr: 'v',
    );
  parser.addFlag(
    'help',
    negatable: false,
    abbr: 'h',
    callback: (help) => usage(help, parser),
  );

  if (const String.fromEnvironment('DISCORD_BOT_TOKEN', defaultValue: null) ==
      null) {
    print('DISCORD_BOT_TOKEN environment variable is required.');
    exit(1);
  }
  if (const String.fromEnvironment('DISCORD_CLIENT_ID', defaultValue: null) ==
      null) {
    print('DISCORD_CLIENT_ID environment variable is required.');
    exit(1);
  }
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
