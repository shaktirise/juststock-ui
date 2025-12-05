import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:juststock/api/advice_api.dart';
import 'package:juststock/api/token_storage.dart';

class AdviceUnlockedStore {
  static const _kUnlocked = 'advice_v2_unlocked_cache_v1';

  static Future<Map<String, dynamic>> _getRaw() async {
    final prefs = await SharedPreferences.getInstance();
    final userKey = await TokenStorage.getUserKey();
    final raw = prefs.getString('$_kUnlocked::$userKey');
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) return decoded.cast<String, dynamic>();
    } catch (_) {}
    return {};
  }

  static Future<void> _setRaw(Map<String, dynamic> map) async {
    final prefs = await SharedPreferences.getInstance();
    final userKey = await TokenStorage.getUserKey();
    await prefs.setString('$_kUnlocked::$userKey', jsonEncode(map));
  }

  static Future<Set<String>> getUnlockedIds() async {
    final map = await _getRaw();
    return map.keys.toSet();
  }

  static Future<void> put(AdviceDetail detail) async {
    final map = await _getRaw();
    map[detail.id] = _detailToJson(detail);
    await _setRaw(map);
  }

  static Future<AdviceDetail?> get(String id) async {
    final map = await _getRaw();
    final obj = map[id];
    if (obj is Map) {
      return AdviceDetail.fromJson(obj.cast<String, dynamic>());
    }
    return null;
  }

  static Map<String, dynamic> _detailToJson(AdviceDetail d) {
    return {
      'id': d.id,
      'category': d.category,
      if (d.text != null) 'text': d.text,
      if (d.buy != null) 'buy': d.buy,
      if (d.target != null) 'target': d.target,
      if (d.stoploss != null) 'stoploss': d.stoploss,
      if (d.price != null) 'price': d.price,
      if (d.createdAt != null) 'createdAt': d.createdAt!.toIso8601String(),
    };
  }
}
