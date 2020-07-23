import 'dart:io';
import 'dart:typed_data';

import 'package:http_parser/http_parser.dart';
import 'package:test/test.dart';
import 'package:plex_notifier/server/server.dart';
import 'package:http/http.dart' as http;

import 'plex_webhook_parser.dart';
import '../bin/main.dart' as bin;

void main() {
  group('HTTP Server\n', () {
    // ignore: omit_local_variable_types
    final String clientId = Platform.environment['DISCORD_CLIENT_ID'];
    // ignore: omit_local_variable_types
    final String host = 'http://localhost';
    // ignore: omit_local_variable_types
    final int port = 8080;
    // ignore: omit_local_variable_types
    final Server server = Server(clientId, bin.parser.parse(<String>[]));

    group('When hitting a invalid route\n', () {
      group('it should throw a RouteNotFoundException and answer with a 404\n',
          () {
        test('generic invalid route', () async {
          // ignore: unawaited_futures
          server.start().then((_) {});

          // ignore: omit_local_variable_types
          final http.Response response =
              await http.get('$host:$port/invalid-route');

          expect(response.statusCode, 404);
          expect(response.body, 'Route not found: GET /invalid-route.');

          await server.close();
        });
      });
      test('!GET /discord', () async {
        // ignore: unawaited_futures
        server.start().then((_) {});

        // ignore: omit_local_variable_types
        final http.Response response = await http.post('$host:$port/discord');

        expect(response.statusCode, 404);
        expect(response.body, 'Route not found: POST /discord.');

        await server.close();
      });
      test('!GET /health', () async {
        // ignore: unawaited_futures
        server.start().then((_) {});

        // ignore: omit_local_variable_types
        final http.Response response = await http.post('$host:$port/health');

        expect(response.statusCode, 404);
        expect(response.body, 'Route not found: POST /health.');

        await server.close();
      });
      test('!POST /plex', () async {
        // ignore: unawaited_futures
        server.start().then((_) {});

        // ignore: omit_local_variable_types
        final http.Response response = await http.get('$host:$port/plex');

        expect(response.statusCode, 404);
        expect(response.body, 'Route not found: GET /plex.');

        await server.close();
      });
      test('!GET /images/:image', () async {
        // ignore: unawaited_futures
        server.start().then((_) {});

        // ignore: omit_local_variable_types
        final http.Response response =
            await http.post('$host:$port/images/watermelon-dog.jpg');

        expect(response.statusCode, 404);
        expect(
            response.body, 'Route not found: POST /images/watermelon-dog.jpg.');

        await server.close();
      });
    });

    group('When hitting a valid route\n', () {
      group('GET /health\n', () {
        test('it should return a 200', () async {
          // ignore: unawaited_futures
          server.start().then((_) {});

          // ignore: omit_local_variable_types
          final http.Response response = await http.get('$host:$port/health');

          expect(response.statusCode, 200);
          expect(response.body, 'I\'m healthy.');
          await server.close();
        });
      });

      group('GET /discord\n', () {
        group('When DISCORD_CLIENT_ID is not provided\n', () {
          test('it should throw a MissingDiscordClientIdException', () async {
            // ignore: omit_local_variable_types
            final Server server2 = Server(null, bin.parser.parse(<String>[]));
            // ignore: unawaited_futures
            server2.start().then((_) {});

            // ignore: omit_local_variable_types
            final http.Response response =
                await http.get('$host:$port/discord');

            expect(
              response.body,
              'Required environment variable DISCORD_CLIENT_ID is missing.',
            );
            expect(response.statusCode, 500);

            await server2.close();
          });
        });
        group('When DISCORD_CLIENT_ID is provided\n', () {
          test('it should redirect', () async {
            // ignore: unawaited_futures
            server.start().then((_) {});

            // ignore: omit_local_variable_types
            final http.Response response =
                await http.get('$host:$port/discord');

            expect(response.statusCode, 200);

            /**
               * Here I'm just trying to make 
               * sure I landed on the Discord page.
               */
            expect(response.body, contains('<title>Discord</title>'));
            expect(
              response.body,
              contains('ASSET_ENDPOINT: \'https://discord.com\''),
            );

            await server.close();
          });
        });
      });

      group('POST /plex', () {
        group('When not receiving a multipart/form-data\n', () {
          test('it should handle the PlexControllerContentTypeException',
              () async {
            // ignore: unawaited_futures
            server.start().then((_) {});

            // ignore: omit_local_variable_types
            final http.Response response = await http.post(
              '$host:$port/plex',
              headers: {
                'Content-Type': 'application/json',
              },
              body: '',
            );

            expect(response.statusCode, 500);
            expect(
              response.body,
              'Expected Content-Type to be multipart/form-data',
            );

            await server.close();
          });
        });

        group('When not receiving the proper content in the form-data\n', () {
          test('it should handle the MimeMultipartException', () async {
            // ignore: unawaited_futures
            server.start().then((_) {});

            // ignore: omit_local_variable_types
            Uri uri = Uri.parse('$host:$port/plex');
            // ignore: omit_local_variable_types
            http.MultipartRequest request = http.MultipartRequest('POST', uri)
              ..fields['payload'] = 'dummy payload'
              ..fields['part2'] = 'part2'
              ..fields['part3'] = 'part3';
            // ignore: omit_local_variable_types
            http.StreamedResponse response = await request.send();

            expect(response.statusCode, 500);
            expect(
              String.fromCharCodes(await response.stream.toBytes()),
              'Format error in the multipart/form-data',
            );

            await server.close();
          });
        });

        group('When the received payload is not a valid JSON\n', () {
          test('it should handle the PlexWebhookParserException', () async {
            // ignore: unawaited_futures
            server.start().then((_) {});

            // ignore: omit_local_variable_types
            final Uri uri = Uri.parse('$host:$port/plex');
            // ignore: omit_local_variable_types
            final http.MultipartRequest request =
                http.MultipartRequest('POST', uri)
                  ..fields['payload'] = 'dummy payload';
            ;

            // ignore: omit_local_variable_types
            final http.StreamedResponse response = await request.send();

            expect(response.statusCode, 500);
            expect(
              String.fromCharCodes(await response.stream.toBytes()),
              'The received payload is not a valid JSON',
            );

            await server.close();
          });
        });

        group('When the received payload is a valid JSON\n', () {
          test('it should return a 200 OK', () async {
            // ignore: unawaited_futures
            server.start().then((_) {});

            // ignore: omit_local_variable_types
            final Uri uri = Uri.parse('$host:$port/plex');
            // ignore: omit_local_variable_types
            final http.MultipartRequest request =
                http.MultipartRequest('POST', uri)
                  ..fields['payload'] = eventExample;
            // eventExample from PlexWebhookParser tests.

            // ignore: omit_local_variable_types
            final http.StreamedResponse response = await request.send();

            expect(response.statusCode, 200);
            expect(
              String.fromCharCodes(await response.stream.toBytes()),
              'OK',
            );

            await server.close();
          });
        });

        group('When the received payload has a thumb\n', () {
          test('it should write it to an images directory', () async {
            // ignore: unawaited_futures
            server.start().then((_) {});

            // ignore: omit_local_variable_types
            final Uri uri = Uri.parse('$host:$port/plex');
            // ignore: omit_local_variable_types
            final http.MultipartRequest request =
                http.MultipartRequest('POST', uri)
                  ..fields['payload'] = eventExample
                  ..files.add(
                    await http.MultipartFile.fromPath(
                      'thumb',
                      'test/assets/watermelon-dog.jpg',
                      contentType: MediaType('image', 'jpeg'),
                    ),
                  );
            // eventExample from PlexWebhookParser tests.

            // ignore: omit_local_variable_types
            final http.StreamedResponse response = await request.send();
            final file = File('images/metadata-1936544-thumb-1432897518.jpg');

            expect(response.statusCode, 200);
            expect(
              String.fromCharCodes(await response.stream.toBytes()),
              'OK',
            );
            expect(file.existsSync(), true);

            await server.close();
            file.deleteSync();
          });
        });
      });

      group('GET /images/watermelon-dog.jpg\n', () {
        group('When the image exists', () {
          test('it should responds with a 200 and the image', () async {
            // ignore: omit_local_variable_types
            final Uint8List origin =
                File('test/assets/watermelon-dog.jpg').readAsBytesSync();
            // ignore: omit_local_variable_types
            final File file = File('images/watermelon-dog.jpg');

            file.writeAsBytesSync(origin);
            // ignore: unawaited_futures
            server.start().then((_) {});

            // ignore: omit_local_variable_types
            final http.Response response =
                await http.get('$host:$port/images/watermelon-dog.jpg');

            expect(response.statusCode, 200);
            expect(
              response.bodyBytes,
              file.readAsBytesSync().buffer.asUint8List(),
            );

            await server.close();
            file.deleteSync();
          });
        });
        group('When the file does not exists', () {
          test('it should return a 404', () async {
            // ignore: unawaited_futures
            server.start().then((_) {});

            // ignore: omit_local_variable_types
            final http.Response response =
                await http.get('$host:$port/images/watermelon-dog.jpg');

            expect(response.statusCode, 404);
            expect(response.body,
                'Route not found: GET /images/watermelon-dog.jpg.');

            await server.close();
          });
        });
      });
    });
  });
}
