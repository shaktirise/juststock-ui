import 'package:dio/dio.dart';

class DailyTipApi {
  final Dio dio;
  DailyTipApi(this.dio);

  /// GET /api/daily-tip/latest
  /// Returns a map for the latest tip or null.
  Future<Map<String, dynamic>?> latest() async {
    final r = await dio.get('/api/daily-tip/latest');
    final data = r.data;
    if (data is Map<String, dynamic>) {
      final tip = data['tip'];
      if (tip is Map) return (tip as Map).cast<String, dynamic>();
    }
    return null;
  }

  /// GET /api/daily-tip?limit=20
  /// Returns a list of tips (each a Map).
  Future<List<Map<String, dynamic>>> list({int limit = 20}) async {
    final r = await dio.get('/api/daily-tip', queryParameters: {'limit': limit});
    final data = r.data;
    if (data is Map<String, dynamic>) {
      final items = data['items'];
      if (items is List) {
        return items
            .map((e) => (e is Map<String, dynamic>) ? e : (e as Map).cast<String, dynamic>())
            .cast<Map<String, dynamic>>()
            .toList();
      }
    }
    if (data is List) {
      return data
          .map((e) => (e is Map<String, dynamic>) ? e : (e as Map).cast<String, dynamic>())
          .cast<Map<String, dynamic>>()
          .toList();
    }
    return const [];
  }
}

