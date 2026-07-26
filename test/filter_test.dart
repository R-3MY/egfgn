import 'package:egfgn/services/epic_service.dart';
import 'package:test/test.dart';

void main() {
  test('Should fetch and filter free games from Epic Games API', () async {
    final epicService = EpicService(countryCode: 'FR');

    print('Récupération des jeux depuis l\'API Epic Games...');
    final games = await epicService.fetchFreeGames();

    print('${games.length} jeux trouvés (Actuels + À venir).');

    for (final game in games) {
      print(
        '- [${game.isCurrentlyFree ? "ACTUEL" : "À VENIR"}] ${game.title} : ${game.epicUrl}',
      );

      expect(game.id, isNotEmpty);
      expect(game.title, isNotEmpty);
      expect(game.isCurrentlyFree || game.isUpcomingFree, isTrue);

      if (game.isCurrentlyFree) {
        expect(game.discountPrice, equals(0));
      }
    }

    expect(games, isNotEmpty);
  });
}
