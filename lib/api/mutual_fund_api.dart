import 'dart:convert';

import 'package:http/http.dart' as http;

import 'auth_api.dart';

class MutualFundApi {
  static const String baseUrl = AuthApi.baseUrl;

  static Uri _uri(String path) => Uri.parse('$baseUrl$path');

  static Future<Map<String, dynamic>> saveEnrollment({
    required Map<String, dynamic> payload,
  }) async {
    final res = await http.post(
      _uri('/api/mutual-fund-enrollment'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      final data = jsonDecode(res.body);
      if (data is Map<String, dynamic>) return data;
      return {'status': 'ok', 'enrollment': data};
    }
    throw HttpException(
        statusCode: res.statusCode, message: _extractError(res));
  }

  static Future<Map<String, dynamic>> getEnrollment(String enrollmentId) async {
    final id = enrollmentId.trim();
    final res = await http.get(_uri('/api/mutual-fund-enrollment/$id'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data is Map<String, dynamic>) return data;
      return {'enrollment': data};
    }
    throw HttpException(
        statusCode: res.statusCode, message: _extractError(res));
  }

  static String _extractError(http.Response res) {
    try {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) {
        return decoded['message']?.toString() ??
            decoded['error']?.toString() ??
            'Request failed (${res.statusCode})';
      }
      return decoded.toString();
    } catch (_) {
      return 'Request failed (${res.statusCode})';
    }
  }
}

class HttpException implements Exception {
  final int statusCode;
  final String message;

  HttpException({required this.statusCode, required this.message});

  @override
  String toString() => 'HttpException($statusCode): $message';
}
