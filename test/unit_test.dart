import 'package:egfgn/models/epic_game.dart';
import 'package:egfgn/services/epic_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  group('EpicGame Model', () {
    test('epicUrl should prefer productSlug', () {
      final game = EpicGame(
        id: '1',
        title: 'Test',
        description: 'Desc',
        productSlug: 'prod-slug',
        urlSlug: 'url-slug',
        originalPrice: 100,
        discountPrice: 0,
        isCurrentlyFree: true,
        isUpcomingFree: false,
      );
      expect(game.epicUrl, contains('/p/prod-slug'));
    });

    test('epicUrl should fallback to urlSlug', () {
      final game = EpicGame(
        id: '1',
        title: 'Test',
        description: 'Desc',
        productSlug: null,
        urlSlug: 'url-slug',
        originalPrice: 100,
        discountPrice: 0,
        isCurrentlyFree: true,
        isUpcomingFree: false,
      );
      expect(game.epicUrl, contains('/p/url-slug'));
    });

    test('epicUrl should return default store URL if slugs are null', () {
      final game = EpicGame(
        id: '1',
        title: 'Test',
        description: 'Desc',
        productSlug: null,
        urlSlug: null,
        originalPrice: 100,
        discountPrice: 0,
        isCurrentlyFree: true,
        isUpcomingFree: false,
      );
      expect(game.epicUrl, equals('https://store.epicgames.com/fr/'));
    });

    test('toString should return formatted string', () {
      final game = EpicGame(
        id: '1',
        title: 'Super Game',
        description: 'Desc',
        originalPrice: 100,
        discountPrice: 0,
        isCurrentlyFree: true,
        isUpcomingFree: false,
      );
      expect(
        game.toString(),
        equals('EpicGame(title: Super Game, isFree: true)'),
      );
    });
  });

  group('EpicService Error Handling', () {
    test('should throw exception on non-200 status code', () async {
      final mockClient = MockClient(
        (final request) async => http.Response('Error', 404),
      );

      final service = EpicService(countryCode: 'FR', client: mockClient);

      expect(service.fetchFreeGames(), throwsA(isA<Exception>()));
    });
  });
}
