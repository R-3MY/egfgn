import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

class StorageService {
  StorageService({final String? customPath})
    : filePath = customPath ?? p.join('data', 'notified_games.json');

  final String filePath;

  Future<List<String>> getNotifiedIds() async {
    final file = File(filePath);
    if (!await file.exists()) {
      return [];
    }
    try {
      final content = await file.readAsString();
      final json = jsonDecode(content) as List<dynamic>;
      return json.cast<String>();
    } catch (e) {
      print('Erreur lors de la lecture du stockage : $e');
      return [];
    }
  }

  Future<void> saveNotifiedIds(final List<String> ids) async {
    final file = File(filePath);
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }
    final content = jsonEncode(ids);
    await file.writeAsString(content);
  }

  Future<bool> hasBeenNotified(final String id) async {
    final ids = await getNotifiedIds();
    return ids.contains(id);
  }

  Future<void> markAsNotified(final String id) async {
    final ids = await getNotifiedIds();
    if (!ids.contains(id)) {
      ids.add(id);
      await saveNotifiedIds(ids);
    }
  }
}
