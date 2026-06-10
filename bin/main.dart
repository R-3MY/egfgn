import 'dart:async';
import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:egfgn/services/discord_service.dart';
import 'package:egfgn/services/epic_service.dart';
import 'package:egfgn/services/storage_service.dart';

//* ENVIRONNEMENT VARIABLES
final env = DotEnv(includePlatformEnvironment: true)..load();

String _getEnv(final String key, final String fromEnv) {
  final value = env[key];
  if (value != null && value.isNotEmpty) return value;
  return fromEnv;
}

final String webhookUrl = _getEnv(
  'WEBHOOK_URL',
  const String.fromEnvironment('WEBHOOK_URL'),
);
final String countryCode = _getEnv(
  'COUNTRY_CODE',
  const String.fromEnvironment('COUNTRY_CODE', defaultValue: 'FR'),
);
final int checkIntervalHours =
    int.tryParse(env['CHECK_INTERVAL'] ?? '') ??
    int.tryParse(const String.fromEnvironment('CHECK_INTERVAL')) ??
    24;

final Duration interval = Duration(hours: checkIntervalHours);

final int? roleId =
    int.tryParse(env['ROLE_ID'] ?? '') ??
    int.tryParse(const String.fromEnvironment('ROLE_ID'));

//* MAIN FUNCTION
Future<void> main() async {
  if (webhookUrl.isEmpty) {
    print('Erreur : WEBHOOK_URL n\'est pas défini.');
    exit(1);
  }

  print('Démarrage du service de notification Epic Games Store...');
  print('Pays : $countryCode');
  print('Intervalle : $checkIntervalHours heures');

  final epicService = EpicService(countryCode: countryCode);
  final discordService = DiscordService(
    webhookUrl: webhookUrl,
    roleId: roleId?.toString(),
  );
  final storageService = StorageService();

  while (true) {
    try {
      await runTask(epicService, discordService, storageService);
    } catch (e) {
      print('Erreur lors de l\'exécution : $e');
    }

    print(
      'Prochaine vérification dans $checkIntervalHours heures (${DateTime.now().add(Duration(hours: checkIntervalHours))})',
    );
    await Future<void>.delayed(Duration(hours: checkIntervalHours));
  }
}

Future<void> runTask(
  final EpicService epicService,
  final DiscordService discordService,
  final StorageService storageService,
) async {
  print('Vérification des jeux gratuits...');

  final games = await epicService.fetchFreeGames();
  print('${games.length} jeux gratuits actuellement disponibles.');

  final notifiedIds = await storageService.getNotifiedIds();
  int newNotifications = 0;

  for (final game in games) {
    final statusKey =
        '${game.id}-${game.isCurrentlyFree ? 'current' : 'upcoming'}';

    if (!notifiedIds.contains(statusKey)) {
      print(
        'Changement de statut détecté pour : ${game.title}. Envoi de la notification...',
      );
      try {
        await discordService.notifyGame(game);
        await storageService.markAsNotified(statusKey);
        newNotifications++;
      } catch (e) {
        print('Erreur lors de la notification pour ${game.title} : $e');
      }
    } else {
      print('Statut déjà notifié pour : ${game.title}');
    }
  }

  if (newNotifications == 0) {
    print('Aucun nouveau jeu gratuit à notifier.');
  } else {
    print('$newNotifications nouvelles notifications envoyées.');
  }
}
