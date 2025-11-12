import 'package:dio/dio.dart';

class UserApiV2 {
  final Dio dio;
  UserApiV2(this.dio);

  Future<Map<String, dynamic>> me() async {
    final r = await dio.get('/api/auth/me');
    final data = r.data as Map<String, dynamic>;
    return (data['user'] as Map).cast<String, dynamic>();
  }

  /// Returns the raw payload from /api/auth/me which includes
  /// both `user` and `membership` when available.
  Future<Map<String, dynamic>> meRaw() async {
    final r = await dio.get('/api/auth/me');
    if (r.data is Map) return (r.data as Map).cast<String, dynamic>();
    return const {};
  }

  /// Convenience helper to fetch just the membership snapshot from /me.
  Future<Map<String, dynamic>?> membershipSnapshot() async {
    final raw = await meRaw();
    final m = raw['membership'];
    if (m is Map) return (m as Map).cast<String, dynamic>();
    // Some servers might return inside user.membership.
    final user = raw['user'];
    if (user is Map && user['membership'] is Map) {
      return (user['membership'] as Map).cast<String, dynamic>();
    }
    return null;
  }

  /// POST /api/auth/membership/backfill
  /// Attempts to backfill membership window from historical events.
  Future<Map<String, dynamic>> backfillMembership({bool dryRun = false}) async {
    final r = await dio.post('/api/auth/membership/backfill', data: {
      if (dryRun) 'dryRun': true,
    });
    if (r.data is Map) return (r.data as Map).cast<String, dynamic>();
    return const {};
  }

  Future<Map<String, dynamic>> updateName(String name) async {
    final r = await dio.put('/api/auth/me', data: {'name': name});
    final data = r.data as Map<String, dynamic>;
    return (data['user'] as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> updatePhone(String phone) async {
    // Normalize Indian numbers: 10-digit -> +91XXXXXXXXXX
    String p = phone.trim();
    if (RegExp(r'^\d{10}$').hasMatch(p)) {
      p = '+91' + p;
    }
    final r = await dio.put('/api/auth/me', data: {'phone': p});
    final data = r.data as Map<String, dynamic>;
    return (data['user'] as Map).cast<String, dynamic>();
  }
}
