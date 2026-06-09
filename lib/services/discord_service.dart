import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/epic_game.dart';

class DiscordService {
  DiscordService({required this.webhookUrl});

  final String webhookUrl;

  Future<void> notifyGame(final EpicGame game) async {
    final bool isCurrent = game.isCurrentlyFree;
    final String statusLabel = isCurrent
        ? '🔥 Actuellement GRATUIT'
        : '⏳ Prochainement';
    final int color = isCurrent
        ? 0x00C853
        : 0x2979FF; // Green for current, Blue for upcoming

    final List<Map<String, dynamic>> fields = [
      {
        'name': 'Prix d\'origine',
        'value': game.originalPrice > 0
            ? '${(game.originalPrice / 100).toStringAsFixed(2)} €'
            : 'Gratuit',
        'inline': true,
      },
    ];

    if (game.startDate != null && game.endDate != null) {
      final String startStr = '${game.startDate!.day}/${game.startDate!.month}';
      final String endStr = '${game.endDate!.day}/${game.endDate!.month}';
      fields.add({
        'name': isCurrent ? 'Se termine le' : 'Disponible le',
        'value': isCurrent ? endStr : startStr,
        'inline': true,
      });
    }

    fields.add({
      'name': 'Lien',
      'value': '[Voir sur l\'Epic Games Store](${game.epicUrl})',
      'inline': false,
    });

    final payload = jsonEncode({
      'username': 'Epic Games Notifier',
      'embeds': [
        {
          'title': '$statusLabel : ${game.title}',
          'description': game.description,
          'url': game.epicUrl,
          'color': color,
          'fields': fields,
          if (game.imageUrl != null) 'image': {'url': game.imageUrl},
          'footer': {'text': 'Epic Games Notifier - Par ScraperBot'},
          'timestamp': DateTime.now().toUtc().toIso8601String(),
        },
      ],
    });

    final response = await http.post(
      Uri.parse(webhookUrl),
      headers: {'Content-Type': 'application/json'},
      body: payload,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Erreur Discord: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
