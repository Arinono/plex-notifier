import 'dart:collection';
import 'dart:convert';

import 'package:plex_notifier/models/episode.dart';
import 'package:plex_notifier/models/season.dart';
import 'package:plex_notifier/models/show.dart';
import 'package:plex_notifier/notification/builders/discord.dart';
import 'package:plex_notifier/notification/models/notification.dart';
import 'package:plex_notifier/plex/models/account.dart';
import 'package:plex_notifier/plex/models/metadata.dart';
import 'package:plex_notifier/plex/models/plex_webhook.dart';
import 'package:test/test.dart';

void main() {
  group('DiscordNotificationBuilder\n', () {
    // ignore: omit_local_variable_types
    final DiscordNotificationBuilder builder = DiscordNotificationBuilder();

    group('library.*\n', () {
      group('using PlexWebhook\n', () {
        test('it should return a DiscordNotification with a single item', () {
          // ignore: omit_local_variable_types
          final PlexWebhook movie = PlexWebhook(
            'library.new',
            Account('Dummy account'),
            Metadata(
              'movie',
              'Movie name',
              'Movie Name',
              'Movie name',
              'movieId',
              'movieId',
              'movieId',
              'Movie summary',
              null,
            ),
          );
          // ignore: omit_local_variable_types
          final PlexWebhook movieNoGrandparentTitle = PlexWebhook(
            'library.new',
            Account('Dummy account'),
            Metadata(
              'movie',
              'Movie name',
              'Movie Name',
              null,
              'movieId',
              'movieId',
              'movieId',
              'Movie summary',
              null,
            ),
          );
          // ignore: omit_local_variable_types
          final PlexWebhook movieNoParentTitle = PlexWebhook(
            'library.new',
            Account('Dummy account'),
            Metadata(
              'movie',
              'Movie name',
              null,
              null,
              'movieId',
              'movieId',
              'movieId',
              'Movie summary',
              'thumb',
            ),
          );

          // ignore: omit_local_variable_types
          Notification notification = builder.build(webhook: movie);
          expect(
            jsonEncode(notification),
            jsonEncode(
              {
                'type': 'rich',
                'color': 0xe5a00d,
                'title': '${movie.metadata.grandparentTitle} has been added',
                'description': movie.metadata.summary,
              },
            ),
          );

          notification = builder.build(webhook: movieNoGrandparentTitle);
          expect(
            jsonEncode(notification),
            jsonEncode(
              {
                'type': 'rich',
                'color': 0xe5a00d,
                'title': '${movie.metadata.parentTitle} has been added',
                'description': movie.metadata.summary,
              },
            ),
          );

          notification = builder.build(webhook: movieNoParentTitle);
          expect(
            jsonEncode(notification),
            jsonEncode(
              {
                'type': 'rich',
                'color': 0xe5a00d,
                'title': '${movie.metadata.title} has been added',
                'description': movie.metadata.summary,
                'thumbnail': {'url': 'null/images/thumb.jpg'}
              },
            ),
          );
        });

        group('using Show\n', () {
          test('it should return a DiscordNotification with multiple items',
              () {
            // ignore: omit_local_variable_types
            final Show show = Show(
                'showId',
                'Show name',
                'thumb',
                HashMap.from(
                  {
                    'seasonId1': Season(
                      'seasonId1',
                      'Season 01',
                      [
                        Episode(
                          'episodeId1',
                          'Episode name',
                          'episode summary',
                        ),
                        Episode(
                          'episodeId2',
                          'Episode name 2',
                          'episode summary 2',
                        ),
                      ],
                    ),
                    'seasonId2': Season(
                      'seasonId2',
                      'Season 02',
                      [
                        Episode(
                            'episodeId1', 'Episode name', 'episode summary'),
                      ],
                    ),
                  },
                ),
                null);
            // ignore: omit_local_variable_types
            final Notification notification = builder.build(show: show);

            expect(
              jsonEncode(notification),
              jsonEncode(
                {
                  'type': 'rich',
                  'color': 0xe5a00d,
                  'title': '${show.title} has been added',
                  'fields': [
                    {
                      'name': 'Season',
                      'value': '${show.seasons['seasonId1'].title}',
                      'inline': false
                    },
                    {
                      'name': 'Episode',
                      'value': '${show.seasons['seasonId1'].episodes[0].title}',
                      'inline': true
                    },
                    {
                      'name': 'Episode',
                      'value': '${show.seasons['seasonId1'].episodes[1].title}',
                      'inline': true
                    },
                    {
                      'name': 'Season',
                      'value': '${show.seasons['seasonId2'].title}',
                      'inline': false
                    },
                    {
                      'name': 'Episode',
                      'value': '${show.seasons['seasonId2'].episodes[0].title}',
                      'inline': true
                    },
                  ],
                  'thumbnail': {'url': 'null/images/thumb.jpg'},
                },
              ),
            );
          });
        });

        group('without content\n', () {
          test(
              'it should thrown a DiscordNotificationBuilderNoContentProvidedException',
              () {
            expect(
              () => builder.build(),
              throwsA(
                  isA<DiscordNotificationBuilderNoContentProvidedException>()),
            );
          });
        });
      });
    });

    group('media.*\n', () {
      group('media.scrobble\n', () {
        test('it should send a media notification', () {
          // ignore: omit_local_variable_types
          final PlexWebhook movie = PlexWebhook(
            'media.scrobble',
            Account('Dummy account'),
            Metadata(
              'movie',
              'Movie name',
              'Movie Name',
              'Movie name',
              'movieId',
              'movieId',
              'movieId',
              'Movie summary',
              null,
            ),
          );

          // ignore: omit_local_variable_types
          Notification notification = builder.build(webhook: movie);
          expect(
            jsonEncode(notification),
            jsonEncode(
              {
                'type': 'rich',
                'color': 0xe5a00d,
                'title': '${movie.metadata.grandparentTitle}',
                'description': 'Finished by ${movie.account.name}',
              },
            ),
          );
        });
      });

      group('media.play\n', () {
        test('it should send a media notification', () {
          // ignore: omit_local_variable_types
          final PlexWebhook movie = PlexWebhook(
            'media.play',
            Account('Dummy account'),
            Metadata(
              'movie',
              'Movie name',
              'Movie Name',
              'Movie name',
              'movieId',
              'movieId',
              'movieId',
              'Movie summary',
              null,
            ),
          );

          // ignore: omit_local_variable_types
          Notification notification = builder.build(webhook: movie);
          expect(
            jsonEncode(notification),
            jsonEncode(
              {
                'type': 'rich',
                'color': 0xe5a00d,
                'title': '${movie.metadata.grandparentTitle}',
                'description': 'Played by ${movie.account.name}',
              },
            ),
          );
        });
      });

      group('media.pause\n', () {
        test('it should send a media notification', () {
          // ignore: omit_local_variable_types
          final PlexWebhook movie = PlexWebhook(
            'media.pause',
            Account('Dummy account'),
            Metadata(
              'movie',
              'Movie name',
              'Movie Name',
              'Movie name',
              'movieId',
              'movieId',
              'movieId',
              'Movie summary',
              null,
            ),
          );

          // ignore: omit_local_variable_types
          Notification notification = builder.build(webhook: movie);
          expect(
            jsonEncode(notification),
            jsonEncode(
              {
                'type': 'rich',
                'color': 0xe5a00d,
                'title': '${movie.metadata.grandparentTitle}',
                'description': 'Paused by ${movie.account.name}',
              },
            ),
          );
        });
      });

      group('media.resume\n', () {
        test('it should send a media notification', () {
          // ignore: omit_local_variable_types
          final PlexWebhook movie = PlexWebhook(
            'media.resume',
            Account('Dummy account'),
            Metadata(
              'movie',
              'Movie name',
              'Movie Name',
              'Movie name',
              'movieId',
              'movieId',
              'movieId',
              'Movie summary',
              null,
            ),
          );

          // ignore: omit_local_variable_types
          Notification notification = builder.build(webhook: movie);
          expect(
            jsonEncode(notification),
            jsonEncode(
              {
                'type': 'rich',
                'color': 0xe5a00d,
                'title': '${movie.metadata.grandparentTitle}',
                'description': 'Resumed by ${movie.account.name}',
              },
            ),
          );
        });
      });

      group('media.stop\n', () {
        test('it should send a media notification', () {
          // ignore: omit_local_variable_types
          final PlexWebhook movie = PlexWebhook(
            'media.stop',
            Account('Dummy account'),
            Metadata(
              'movie',
              'Movie name',
              'Movie Name',
              'Movie name',
              'movieId',
              'movieId',
              'movieId',
              'Movie summary',
              null,
            ),
          );

          // ignore: omit_local_variable_types
          Notification notification = builder.build(webhook: movie);
          expect(
            jsonEncode(notification),
            jsonEncode(
              {
                'type': 'rich',
                'color': 0xe5a00d,
                'title': '${movie.metadata.grandparentTitle}',
                'description': 'Stopped by ${movie.account.name}',
              },
            ),
          );
        });
      });
    });
  });
}
