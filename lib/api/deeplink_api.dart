import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_api.dart';

class DeepLinkApi {
  static const _apiKey = 'JS_DEEPLINK_KEY_2025';

  static Uri _uri(String path) => Uri.parse('${AuthApi.baseUrl}$path');

  /// Returns a map with keys: shareUrl, appUrl, payload
  static Future<Map<String, dynamic>> createReferral(String refCode) async {
    final url = _uri('/api/deeplink/referral/$refCode?key=$_apiKey');
    final res = await http.get(url, headers: const {'Accept': 'application/json'});
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return data;
    }
    throw Exception('Failed to create referral link (${res.statusCode})');
  }
}

