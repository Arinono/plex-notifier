import 'package:mockito/mockito.dart';
import 'package:plex_notifier/models/show.dart';
import 'package:plex_notifier/notification/debouncer.dart';
import 'package:plex_notifier/plex/models/account.dart';
import 'package:plex_notifier/plex/models/metadata.dart';
import 'package:plex_notifier/plex/models/plex_webhook.dart';
import 'package:plex_notifier/plex/plexecutor.dart';
import 'package:plex_notifier/notification/models/notification.dart';
import 'package:test/test.dart';

import '../bin/main.dart' as bin;

void main() {
  group('Plexecutor\n', () {
    // ignore: omit_local_variable_types
    final NotificationDebouncer debouncer = NotificationDebouncer();
    // ignore: omit_local_variable_types
    final NotificationBuilderMock builder = NotificationBuilderMock();
    // ignore: omit_local_variable_types
    final NotificationChannelMock notifier = NotificationChannelMock();
    // ignore: omit_local_variable_types
    final Plexecutor plexecutor = Plexecutor(
      debouncer,
      builder,
      notifier,
      bin.parser.parse(<String>[]),
    );
    // ignore: omit_local_variable_types
    final Notification notification = Notification(
      {'dummy notification': true},
    );

    tearDown(() {
      resetMockitoState();
    });

    group('When a new Webhook comes in\n', () {
      group('event type: library.*\n', () {
        group('media type: episode\n', () {
          test(
              'it should debounce the parsed webhook and give a callback pointing towards the channel',
              () async {
            // ignore: omit_local_variable_types
            final PlexWebhook whShow1 = PlexWebhook(
              'library.new',
              Account('Test'),
              Metadata(
                'episode',
                'Episode name',
                'Season name',
                'Show name',
                'episodeId',
                'seasonId',
                'showId',
                'dummy summary',
                'thumb',
              ),
            );
            debouncer.register(whShow1, () {});
            // ignore: omit_local_variable_types
            final Show show = debouncer.getShow(
              whShow1.metadata.grandparentGuid,
            );
            when(builder.build(show: show)).thenReturn(notification);
            when(notifier.notify(notification));

            await plexecutor.execute(
              whShow1,
              duration: Duration(milliseconds: 100),
            );

            // Verifying that no called was made before the callback was debounced
            verifyNever(builder.build(show: show));
            verifyNever(notifier.notify(notification));
            await Future.delayed(Duration(milliseconds: 100), () {
              verifyInOrder([
                builder.build(show: show),
                notifier.notify(notification),
              ]);
            });
          });
        });

        group('event type: !episode\n', () {
          test('it should directly build and fire a notification', () async {
            // ignore: omit_local_variable_types
            final PlexWebhook notShow = PlexWebhook(
              'library.new',
              Account('Test'),
              Metadata(
                'movie',
                'Movie name',
                null,
                null,
                'movieId',
                null,
                null,
                'dummy summary',
                'thumb',
              ),
            );
            when(builder.build(webhook: notShow)).thenReturn(notification);
            when(notifier.notify(notification));

            await plexecutor.execute(notShow);

            verifyInOrder([
              builder.build(webhook: notShow),
              notifier.notify(notification),
            ]);
          });
        });
      });

      group('event type: media.*\n', () {
        test('it should directly build and fire a notification', () async {
          // ignore: omit_local_variable_types
          final PlexWebhook mediaEvt = PlexWebhook(
              'media.play',
              Account('Test'),
              Metadata(
                'movie',
                'Movie name',
                null,
                null,
                'movieId',
                null,
                null,
                'dummy summary',
                'thumb',
              ));
          when(builder.build(webhook: mediaEvt)).thenReturn(notification);
          when(notifier.notify(notification));

          await plexecutor.execute(mediaEvt);

          verifyInOrder([
            builder.build(webhook: mediaEvt),
            notifier.notify(notification),
          ]);
        });
      });
    });
  });
}

class NotificationDebouncerMock extends Mock implements NotificationDebouncer {}

class NotificationBuilderMock extends Mock implements NotificationBuilder {}

class NotificationChannelMock extends Mock implements NotificationChannel {}
