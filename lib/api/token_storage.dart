import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_api.dart';

class TokenStorage {
  static const _kToken = 'auth.token';
  static const _kTokenExp = 'auth.token.expiresAt';
  static const _kRefresh = 'auth.refreshToken';
  static const _kRefreshExp = 'auth.refresh.expiresAt';
  static const _kUser = 'auth.user.json';

  static Future<void> saveAuth(AuthResponse auth) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kToken, auth.token);
    if (auth.tokenExpiresAt != null) {
      await prefs.setString(_kTokenExp, auth.tokenExpiresAt!);
    }
    await prefs.setString(_kRefresh, auth.refreshToken);
    if (auth.refreshTokenExpiresAt != null) {
      await prefs.setString(_kRefreshExp, auth.refreshTokenExpiresAt!);
    }
    if (auth.user != null) {
      await prefs.setString(_kUser, jsonEncode(auth.user));
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kToken);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kRefresh);
  }

  static Future<void> updateTokens(TokenPair pair) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kToken, pair.token);
    if (pair.tokenExpiresAt != null) {
      await prefs.setString(_kTokenExp, pair.tokenExpiresAt!);
    }
    await prefs.setString(_kRefresh, pair.refreshToken);
    if (pair.refreshTokenExpiresAt != null) {
      await prefs.setString(_kRefreshExp, pair.refreshTokenExpiresAt!);
    }
  }

  static Future<Map<String, String>> authHeaders({Map<String, String>? extra}) async {
    final token = await getToken();
    if (token == null) return {...?extra};
    return {
      'Authorization': 'Bearer $token',
      ...?extra,
    };
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kToken);
    await prefs.remove(_kTokenExp);
    await prefs.remove(_kRefresh);
    await prefs.remove(_kRefreshExp);
    await prefs.remove(_kUser);
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kUser);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return null;
  }

  /// Returns a stable key for the current user, preferring id/_id then email,
  /// and finally the access token if nothing else is available.
  static Future<String> getUserKey() async {
    final user = await getUser();
    if (user != null) {
      final id = user['id']?.toString() ?? user['_id']?.toString();
      if (id != null && id.isNotEmpty) return id;
      final email = user['email']?.toString();
      if (email != null && email.isNotEmpty) return email;
    }
    final token = await getToken();
    return token ?? 'anon';
  }
}
