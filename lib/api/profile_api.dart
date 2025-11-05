import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_api.dart';
import 'token_storage.dart';

class ProfileApi {
  static const String baseUrl = AuthApi.baseUrl;
  static Uri _uri(String path) => Uri.parse('$baseUrl$path');

  /// Fetches the current user's profile. Attempts to return the `user` map if
  /// present, otherwise the decoded response map.
  static Future<Map<String, dynamic>?> fetchProfile() async {
    final headers = await TokenStorage.authHeaders();
    final res = await http.get(_uri('/api/auth/me'), headers: headers);
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) {
        final user = decoded['user'];
        if (user is Map<String, dynamic>) return user;
        return decoded;
      }
      return null;
    }
    // Treat errors as no profile available.
    return null;
  }

  static Future<bool> isActivated() async {
    try {
      final profile = await fetchProfile();
      if (profile == null) return false;
      final val = profile['referralActivatedAt'];
      return val != null && val.toString().isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}

