import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:juststock/api/token_storage.dart';

class AdviceSeenStore {
  static const _kSeen = 'advice_v2_seen_ids_v1';

  static Future<Map<String, String>> _getSeenMap() async {
    final prefs = await SharedPreferences.getInstance();
    final userKey = await TokenStorage.getUserKey();
    final raw = prefs.getString('$_kSeen::$userKey');
    if (raw == null || raw.isEmpty) return {};
    try {
      final map = jsonDecode(raw);
      if (map is Map) {
        return map.map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''));
      }
    } catch (_) {}
    return {};
  }

  static Future<void> _setSeenMap(Map<String, String> map) async {
    final prefs = await SharedPreferences.getInstance();
    final userKey = await TokenStorage.getUserKey();
    await prefs.setString('$_kSeen::$userKey', jsonEncode(map));
  }

  static String _norm(String category) => category.toUpperCase();

  static Future<String?> getSeenId(String category) async {
    final map = await _getSeenMap();
    return map[_norm(category)];
  }

  static Future<void> markSeen(String category, String id) async {
    final map = await _getSeenMap();
    map[_norm(category)] = id;
    await _setSeenMap(map);
  }
}
