import 'dart:async';
import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:plex_notifier/models/show.dart';
import 'package:plex_notifier/notification/debouncer.dart';
import 'package:plex_notifier/plex/models/account.dart';
import 'package:plex_notifier/plex/models/metadata.dart';
import 'package:plex_notifier/plex/models/plex_webhook.dart';
import 'package:test/test.dart';

void main() {
  group('NotificationDebouncer\n', () {
    // ignore: omit_local_variable_types
    final PlexWebhookMock parser = PlexWebhookMock();
    NotificationDebouncer notificationDebouncer;

    setUp(() {
      notificationDebouncer = NotificationDebouncer();

      when(parser.parse('show1S1E1')).thenReturn(show1S1E1);
      when(parser.parse('show1S1E2')).thenReturn(show1S1E2);
      when(parser.parse('show1S2E1')).thenReturn(show1S2E1);
      when(parser.parse('show2S1E1')).thenReturn(show2S1E1);
    });

    tearDown(() {
      resetMockitoState();
    });

    group('Basic notfication registration\n', () {
      group('When an unregistered PlexWebhook comes in\n', () {
        test('it should store this notification', () {
          notificationDebouncer.register(
            parser.parse('show1S1E1'),
            () {},
            duration: Duration(microseconds: 0),
          );
          // ignore: omit_local_variable_types
          Show show = notificationDebouncer.getShow(
            show1S1E1.metadata.grandparentGuid,
          );

          NotificationDebouncerTestUtils.show1S1E1Validation(show);

          expect(
            jsonEncode(show),
            '{"showId1":{"title":"Show name","thumb":"thumb","seasonId1":{"title":"Season name","episodes":[{"id":"episodeId1","title":"Episode name","summary":""}]}}}',
          );
        });
      });

      group('When a different unregistered PlexWebhook comes in\n', () {
        test('it should store this notification', () {
          notificationDebouncer.register(
            parser.parse('show1S1E1'),
            () {},
            duration: Duration(microseconds: 0),
          );
          notificationDebouncer.register(
            parser.parse('show1S1E2'),
            () {},
            duration: Duration(microseconds: 0),
          );

          // ignore: omit_local_variable_types
          Show show1 = notificationDebouncer.getShow(
            show1S1E1.metadata.grandparentGuid,
          );
          // ignore: omit_local_variable_types
          Show show2 = notificationDebouncer.getShow(
            show1S1E2.metadata.grandparentGuid,
          );

          NotificationDebouncerTestUtils.show1S1E1Validation(
            show1,
            episodeIdx: 0,
            seasonLen: 1,
            episodeLen: 2,
          );
          NotificationDebouncerTestUtils.show1S1E2Validation(
            show2,
            episodeIdx: 1,
            seasonLen: 1,
            episodeLen: 2,
          );

          expect(
            jsonEncode(show1),
            '{"showId1":{"title":"Show name","thumb":"thumb","seasonId1":{"title":"Season name","episodes":[{"id":"episodeId1","title":"Episode name","summary":""},{"id":"episodeId2","title":"Episode name 2","summary":""}]}}}',
          );
        });
      });

      group('When a different unregisterd PlexWebhook\n', () {
        group('with a new season comes in\n', () {
          test('it should store this notification', () {
            notificationDebouncer.register(
              parser.parse('show1S1E1'),
              () {},
              duration: Duration(microseconds: 0),
            );
            notificationDebouncer.register(
              parser.parse('show1S2E1'),
              () {},
              duration: Duration(microseconds: 0),
            );

            // ignore: omit_local_variable_types
            Show show1 = notificationDebouncer.getShow(
              show1S1E1.metadata.grandparentGuid,
            );
            // ignore: omit_local_variable_types
            Show show2 = notificationDebouncer.getShow(
              show1S2E1.metadata.grandparentGuid,
            );

            NotificationDebouncerTestUtils.show1S1E1Validation(
              show1,
              episodeIdx: 0,
              seasonLen: 2,
              episodeLen: 1,
            );
            NotificationDebouncerTestUtils.show1S2E1Validation(
              show2,
              episodeIdx: 0,
              seasonLen: 2,
              episodeLen: 1,
            );

            expect(
              jsonEncode(show1),
              '{"showId1":{"title":"Show name","thumb":"thumb","seasonId1":{"title":"Season name","episodes":[{"id":"episodeId1","title":"Episode name","summary":""}]},"seasonId2":{"title":"Season name 2","episodes":[{"id":"episodeId1","title":"Episode name","summary":""}]}}}',
            );
          });
        });
      });

      group('When a different unregisterd PlexWebhook\n', () {
        group('with a new show comes in\n', () {
          test('it should store this notification', () {
            notificationDebouncer.register(
              parser.parse('show1S1E1'),
              () {},
              duration: Duration(microseconds: 0),
            );
            notificationDebouncer.register(
              parser.parse('show2S1E1'),
              () {},
              duration: Duration(microseconds: 0),
            );

            // ignore: omit_local_variable_types
            Show show1 = notificationDebouncer.getShow(
              show1S1E1.metadata.grandparentGuid,
            );
            // ignore: omit_local_variable_types
            Show show2 = notificationDebouncer.getShow(
              show2S1E1.metadata.grandparentGuid,
            );

            NotificationDebouncerTestUtils.show1S1E1Validation(
              show1,
              episodeIdx: 0,
              seasonLen: 1,
              episodeLen: 1,
            );
            NotificationDebouncerTestUtils.show2S1E1Validation(
              show2,
              episodeIdx: 0,
              seasonLen: 1,
              episodeLen: 1,
            );

            expect(
              jsonEncode(show1),
              '{"showId1":{"title":"Show name","thumb":"thumb","seasonId1":{"title":"Season name","episodes":[{"id":"episodeId1","title":"Episode name","summary":""}]}}}',
            );
            expect(
              jsonEncode(show2),
              '{"showId2":{"title":"Show name 2","thumb":"thumb","seasonId1":{"title":"Season name","episodes":[{"id":"episodeId1","title":"Episode name","summary":""}]}}}',
            );
          });
        });
      });

      group('When a registered PlexWebhook comes in\n', () {
        test('it should not store this notification again', () {
          notificationDebouncer.register(
            parser.parse('show1S1E1'),
            () {},
            duration: Duration(microseconds: 0),
          );

          // ignore: omit_local_variable_types
          Show show = notificationDebouncer.getShow(
            show1S1E1.metadata.grandparentGuid,
          );

          expect(show.seasons.length, 1);
          expect(
            show.seasons[show1S1E1.metadata.parentGuid].episodes.length,
            1,
          );
          expect(
            jsonEncode(show),
            '{"showId1":{"title":"Show name","thumb":"thumb","seasonId1":{"title":"Season name","episodes":[{"id":"episodeId1","title":"Episode name","summary":""}]}}}',
          );
        });
      });
    });

    group('Timer\n', () {
      group('When a show is added\n', () {
        test('it should be attached to a Timer', () {
          notificationDebouncer.register(
            parser.parse('show1S1E1'),
            () {
              /**
             * Checks that the callback is called.
             * If I change this to:
             * expect(false, true);
             * 
             * The test is failing.
             */
              expect(true, true);
            },
            duration: Duration(microseconds: 10),
          );

          // ignore: omit_local_variable_types
          Show show = notificationDebouncer.getShow(
            show1S1E1.metadata.grandparentGuid,
          );

          expect(show.timer, isA<Timer>());
          expect(show.timer.isActive, true);
        });

        group('When another episode of this show is added\n', () {
          test('it should reset the timer', () {
            /**
           * In this case I knowingly put a failing test
           * and a larger amount for the duration.
           * 
           * This is because I don't expect this callback to be
           * called since the next notification will reset the
           * timer before this happens.
           * 
           * You can check this by wrapping the 2nd registration
           * inside a delayed Future:
           * Future.delayed(const Duration(seconds: 1), () => notification.register...);
           */
            notificationDebouncer.register(
              parser.parse('show1S1E1'),
              () {
                expect(false, true);
              },
              duration: Duration(microseconds: 10),
            );
            notificationDebouncer.register(
              parser.parse('show1S1E2'),
              () {
                expect(true, true);
              },
              duration: Duration(microseconds: 10),
            );

            // ignore: omit_local_variable_types
            Show show = notificationDebouncer.getShow(
              show1S1E1.metadata.grandparentGuid,
            );

            expect(show.timer, isA<Timer>());
            expect(show.timer.isActive, true);
          });
        });
      });
    });
  });
}

class PlexWebhookMock extends Mock implements PlexWebhook {
  PlexWebhook parse(String webhookNumber);
}

PlexWebhook show1S1E1 = PlexWebhook(
  'library.new',
  Account('Arinono'),
  Metadata(
    'library.new',
    'Episode name',
    'Season name',
    'Show name',
    'episodeId1',
    'seasonId1',
    'showId1',
    '',
    'thumb',
  ),
);

PlexWebhook show1S1E2 = PlexWebhook(
  'library.new',
  Account('Arinono'),
  Metadata(
    'library.new',
    'Episode name 2',
    'Season name',
    'Show name',
    'episodeId2',
    'seasonId1',
    'showId1',
    '',
    'thumb',
  ),
);

PlexWebhook show1S2E1 = PlexWebhook(
  'library.new',
  Account('Arinono'),
  Metadata(
    'library.new',
    'Episode name',
    'Season name 2',
    'Show name',
    'episodeId1',
    'seasonId2',
    'showId1',
    '',
    'thumb',
  ),
);

PlexWebhook show2S1E1 = PlexWebhook(
  'library.new',
  Account('Arinono'),
  Metadata(
    'library.new',
    'Episode name',
    'Season name',
    'Show name 2',
    'episodeId1',
    'seasonId1',
    'showId2',
    '',
    'thumb',
  ),
);

class NotificationDebouncerTestUtils {
  static void show1S1E1Validation(
    Show show, {
    int episodeIdx,
    int seasonLen,
    int episodeLen,
  }) {
    expect(show.id, show1S1E1.metadata.grandparentGuid);
    expect(show.title, show1S1E1.metadata.grandparentTitle);
    expect(show.seasons.length, seasonLen ?? 1);
    expect(
      show.seasons[show1S1E1.metadata.parentGuid].id,
      show1S1E1.metadata.parentGuid,
    );
    expect(
      show.seasons[show1S1E1.metadata.parentGuid].title,
      show1S1E1.metadata.parentTitle,
    );
    expect(
      show.seasons[show1S1E1.metadata.parentGuid].episodes.length,
      episodeLen ?? 1,
    );
    expect(
      show.seasons[show1S1E1.metadata.parentGuid].episodes[episodeIdx ?? 0].id,
      show1S1E1.metadata.guid,
    );
    expect(
      show.seasons[show1S1E1.metadata.parentGuid].episodes[episodeIdx ?? 0]
          .title,
      show1S1E1.metadata.title,
    );
    expect(
      show.seasons[show1S1E1.metadata.parentGuid].episodes[episodeIdx ?? 0]
          .summary,
      show1S1E1.metadata.summary,
    );
  }

  static void show1S1E2Validation(
    Show show, {
    int episodeIdx,
    int seasonLen,
    int episodeLen,
  }) {
    expect(show.id, show1S1E2.metadata.grandparentGuid);
    expect(show.title, show1S1E2.metadata.grandparentTitle);
    expect(show.seasons.length, seasonLen ?? 1);
    expect(
      show.seasons[show1S1E2.metadata.parentGuid].id,
      show1S1E2.metadata.parentGuid,
    );
    expect(
      show.seasons[show1S1E2.metadata.parentGuid].title,
      show1S1E2.metadata.parentTitle,
    );
    expect(
      show.seasons[show1S1E2.metadata.parentGuid].episodes.length,
      episodeLen ?? 1,
    );
    expect(
      show.seasons[show1S1E2.metadata.parentGuid].episodes[episodeIdx ?? 0].id,
      show1S1E2.metadata.guid,
    );
    expect(
      show.seasons[show1S1E2.metadata.parentGuid].episodes[episodeIdx ?? 0]
          .title,
      show1S1E2.metadata.title,
    );
    expect(
      show.seasons[show1S1E2.metadata.parentGuid].episodes[episodeIdx ?? 0]
          .summary,
      show1S1E2.metadata.summary,
    );
  }

  static void show1S2E1Validation(
    Show show, {
    int episodeIdx,
    int seasonLen,
    int episodeLen,
  }) {
    expect(show.id, show1S2E1.metadata.grandparentGuid);
    expect(show.title, show1S2E1.metadata.grandparentTitle);
    expect(show.seasons.length, seasonLen ?? 1);
    expect(
      show.seasons[show1S2E1.metadata.parentGuid].id,
      show1S2E1.metadata.parentGuid,
    );
    expect(
      show.seasons[show1S2E1.metadata.parentGuid].title,
      show1S2E1.metadata.parentTitle,
    );
    expect(
      show.seasons[show1S2E1.metadata.parentGuid].episodes.length,
      episodeLen ?? 1,
    );
    expect(
      show.seasons[show1S2E1.metadata.parentGuid].episodes[episodeIdx ?? 0].id,
      show1S2E1.metadata.guid,
    );
    expect(
      show.seasons[show1S2E1.metadata.parentGuid].episodes[episodeIdx ?? 0]
          .title,
      show1S2E1.metadata.title,
    );
    expect(
      show.seasons[show1S2E1.metadata.parentGuid].episodes[episodeIdx ?? 0]
          .summary,
      show1S2E1.metadata.summary,
    );
  }

  static void show2S1E1Validation(
    Show show, {
    int episodeIdx,
    int seasonLen,
    int episodeLen,
  }) {
    expect(show.id, show2S1E1.metadata.grandparentGuid);
    expect(show.title, show2S1E1.metadata.grandparentTitle);
    expect(show.seasons.length, seasonLen ?? 1);
    expect(
      show.seasons[show2S1E1.metadata.parentGuid].id,
      show2S1E1.metadata.parentGuid,
    );
    expect(
      show.seasons[show2S1E1.metadata.parentGuid].title,
      show2S1E1.metadata.parentTitle,
    );
    expect(
      show.seasons[show2S1E1.metadata.parentGuid].episodes.length,
      episodeLen ?? 1,
    );
    expect(
      show.seasons[show2S1E1.metadata.parentGuid].episodes[episodeIdx ?? 0].id,
      show2S1E1.metadata.guid,
    );
    expect(
      show.seasons[show2S1E1.metadata.parentGuid].episodes[episodeIdx ?? 0]
          .title,
      show2S1E1.metadata.title,
    );
    expect(
      show.seasons[show2S1E1.metadata.parentGuid].episodes[episodeIdx ?? 0]
          .summary,
      show2S1E1.metadata.summary,
    );
  }
}
