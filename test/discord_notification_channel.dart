import 'dart:io';

import 'package:plex_notifier/models/services.dart';
import 'package:plex_notifier/notification/channels/discord.dart';
import 'package:plex_notifier/notification/models/notification.dart';
import 'package:test/test.dart';

void main() {
  group('DiscordNotificationChannel\n', () {
    // ignore: omit_local_variable_types
    final String channelId = Platform.environment['DISCORD_CHANNEL_ID'];
    // ignore: omit_local_variable_types
    final String botToken = Platform.environment['DISCORD_BOT_TOKEN'];
    // ignore: omit_local_variable_types
    final DiscordNotificationChannel channel =
        DiscordNotificationChannel(botToken, channelId);

    group('.connect()\n', () {
      group('When DISCORD_BOT_TOKEN is not provided\n', () {
        test('it should throw a MissingDiscordBotTokenException', () {
          // ignore: omit_local_variable_types
          final DiscordNotificationChannel channel2 =
              DiscordNotificationChannel(null, null);

          expect(
            () async => await channel2.connect(),
            throwsA(isA<MissingDiscordBotTokenException>()),
          );
        });
      });

      /**
       * I have to one-shot test all of these because if I don't go to the
       * identify step, the gateway will rate-limit me and the next test would
       * fail.
       */
      group('it should instanciate an DiscordHttpClient\n', () {
        group('it should be able to get the gateway url\n', () {
          group('it should instanciate a DiscordWebsocketClient\n', () {
            test('it should identity to the gateway', () async {
              await channel.connect();

              expect(channel.http, isA<DiscordHttpClient>());
              expect(channel.http.headers, isA<Map<String, String>>());
              expect(
                channel.http.headers['Authorization'],
                'Bot $botToken',
              );
              expect(channel.ws, isA<DiscordWebsocketClient>());
              expect(channel.ws.socket, isA<WebSocket>());
              expect(channel.ws.heartbeated, false);
              expect(channel.ws.identified, false);

              await Future.delayed(Duration(seconds: 1), () async {
                expect(channel.ws.identified, true);
              });
            });
          });
        });
      });

      group('.notify()\n', () {
        group('When DISCORD_CHANNEL_ID is not provided\n', () {
          test('it should throw a MissingChannelIdException', () {
            // ignore: omit_local_variable_types
            final DiscordNotificationChannel channel2 =
                DiscordNotificationChannel(null, null);

            expect(
              () async => await channel2.notify(
                Notification(<String, dynamic>{}, Services.discord),
              ),
              throwsA(isA<MissingChannelIdException>()),
            );
          });
        });

        group('media.*\n', () {
          test('it should send a simple notification (w/o thumb)', () async {
            // ignore: omit_local_variable_types
            final Map<String, dynamic> map = <String, dynamic>{
              'type': 'rich',
              'color': 0xe5a00d,
              'title': 'Integration notification',
              'description': 'This is an integration notification'
            };
            // ignore: omit_local_variable_types
            final Notification notification =
                Notification(map, Services.discord);
            // ignore: omit_local_variable_types
            final Map<String, dynamic> response =
                await channel.notify(notification);

            expect(response['channel_id'], channelId);
            expect(response['embeds'], [
              {
                'type': 'rich',
                'title': 'Integration notification',
                'description': 'This is an integration notification',
                'color': 15048717
              }
            ]);
          });
        });

        group('library.*\n', () {
          test('it should send a notification with a thumb', () async {
            // ignore: omit_local_variable_types
            final Map<String, dynamic> map = <String, dynamic>{
              'type': 'rich',
              'color': 0xe5a00d,
              'title': 'Integration notification',
              'description': 'This is an integration notification with a thumb',
              'thumbnail': {
                'url':
                    'https://s1.qwant.com/thumbr/0x380/0/6/f97f9f45fa580a3366782d104f4ca8f8aa2df879b37580976fc866f4cb7b1e/17b61e917fbe649f39ca7ca4ad923984.jpg?u=https%3A%2F%2Fs-media-cache-ak0.pinimg.com%2F736x%2F17%2Fb6%2F1e%2F17b61e917fbe649f39ca7ca4ad923984.jpg&q=0&b=1&p=0&a=1',
              }
            };
            // ignore: omit_local_variable_types
            final Notification notification =
                Notification(map, Services.discord);
            // ignore: omit_local_variable_types
            final Map<String, dynamic> response = await channel.notify(
              notification,
            );

            expect(response['channel_id'], channelId);
            expect(response['embeds'], [
              {
                'type': 'rich',
                'title': 'Integration notification',
                'description':
                    'This is an integration notification with a thumb',
                'color': 15048717,
                'thumbnail': {
                  'url':
                      'https://s1.qwant.com/thumbr/0x380/0/6/f97f9f45fa580a3366782d104f4ca8f8aa2df879b37580976fc866f4cb7b1e/17b61e917fbe649f39ca7ca4ad923984.jpg?u=https%3A%2F%2Fs-media-cache-ak0.pinimg.com%2F736x%2F17%2Fb6%2F1e%2F17b61e917fbe649f39ca7ca4ad923984.jpg&q=0&b=1&p=0&a=1',
                  'proxy_url':
                      'https://images-ext-1.discordapp.net/external/-RQbEo-zrF0p_tBPSRDhjfW1YZMWjIv6yOYEyr5pQKc/%3Fu%3Dhttps%253A%252F%252Fs-media-cache-ak0.pinimg.com%252F736x%252F17%252Fb6%252F1e%252F17b61e917fbe649f39ca7ca4ad923984.jpg%26q%3D0%26b%3D1%26p%3D0%26a%3D1/https/s1.qwant.com/thumbr/0x380/0/6/f97f9f45fa580a3366782d104f4ca8f8aa2df879b37580976fc866f4cb7b1e/17b61e917fbe649f39ca7ca4ad923984.jpg',
                  'width': 0,
                  'height': 0
                }
              }
            ]);
            await Future.delayed(
              Duration(milliseconds: channel.ws.heartbeatInterval),
              () async => await channel.close(),
            );
          });
        });
      });
    });
  }, timeout: Timeout(Duration(seconds: 50)));
}
