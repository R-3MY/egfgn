import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/epic_game.dart';

class EpicService {
  EpicService({required this.countryCode, final http.Client? client})
    : _client = client ?? http.Client();

  final String countryCode;
  final http.Client _client;

  String get targetUrl =>
      'https://store-site-backend-static-ipv4.ak.epicgames.com/freeGamesPromotions?locale=$countryCode&country=$countryCode&allowCountries=$countryCode';

  Future<List<EpicGame>> fetchFreeGames() async {
    final response = await _client.get(Uri.parse(targetUrl));
    if (response.statusCode != 200) {
      throw Exception('Erreur HTTP: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final elements = data['data']['Catalog']['searchStore']['elements'] as List;

    return elements
        .map((final e) => EpicGame.fromJson(e as Map<String, dynamic>))
        .where((final game) => game.isCurrentlyFree || game.isUpcomingFree)
        .toList();
  }
}
