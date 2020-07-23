import 'dart:io';

import 'package:args/args.dart';
import 'package:plex_notifier/server/server.dart';

final ArgParser parser = ArgParser()
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

Future<void> main(List<String> arguments) async {
  parser.addFlag(
    'help',
    negatable: false,
    abbr: 'h',
    callback: (help) => usage(help, parser),
  );
  // ignore: omit_local_variable_types
  final ArgResults args = parser.parse(arguments);

  // ignore: omit_local_variable_types
  final String discordClientId =
      const String.fromEnvironment('DISCORD_CLIENT_ID', defaultValue: null);
  // ignore: omit_local_variable_types
  final Server server = Server(discordClientId, args);

  ProcessSignal.sigint.watch().listen((signal) async {
    await server.close();
    await server.channel.close();
    exit(0);
  });
  ProcessSignal.sigterm.watch().listen((signal) async {
    await server.close();
    await server.channel.close();
    exit(0);
  });

  await server.channel.connect();
  await server.start();
}

void usage(bool help, ArgParser parser) {
  if (help) {
    print(parser.usage);
    exit(0);
  }
}
